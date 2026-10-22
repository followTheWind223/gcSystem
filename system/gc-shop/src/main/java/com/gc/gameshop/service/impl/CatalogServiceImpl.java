package com.gc.gameshop.service.impl;

import static com.gc.gameshop.support.ShopValues.*;

import com.fasterxml.jackson.core.type.TypeReference;
import com.gc.gameshop.exception.ShopException;
import com.gc.gameshop.mapper.*;
import com.gc.gameshop.model.bo.*;
import com.gc.gameshop.model.command.*;
import com.gc.gameshop.model.query.ShopQuery;
import com.gc.gameshop.model.result.*;
import com.gc.gameshop.persistence.entity.*;
import com.gc.gameshop.service.*;
import com.gc.gameshop.support.*;
import java.util.*;
import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CatalogServiceImpl implements CatalogService {
  private final CatalogMapper db;
  private final ReviewMapper reviews;
  private final MediaService media;
  private final ShopJson json;
  private final OrderMapper orders;

  public CatalogServiceImpl(
      CatalogMapper db,
      ReviewMapper reviews,
      MediaService media,
      ShopJson json,
      OrderMapper orders) {
    this.db = db;
    this.reviews = reviews;
    this.media = media;
    this.json = json;
    this.orders = orders;
  }

  private ShopQuery publicQuery(int limit) {
    return new ShopQuery(
        0,
        limit,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        "sales_desc",
        null,
        null,
        null,
        null,
        true);
  }

  private void state(String s) {
    if (s != null && !Set.of("0", "1").contains(s)) throw ShopException.invalid("资源状态不合法。");
  }

  private String name(String s, int min, int max) {
    String v = clean(s);
    if (v == null || v.length() < min || v.codePointCount(0, v.length()) > max)
      throw ShopException.invalid("文本长度不符合要求。");
    return v;
  }

  private GameCategoryEntity cat(Long id) {
    var c = db.findGameCategory(id);
    if (c == null || !"0".equals(c.getDelFlag())) throw ShopException.missing();
    return c;
  }

  private PropEntity prop(Long id) {
    var p = db.findProp(id);
    if (p == null || !"0".equals(p.getDelFlag())) throw ShopException.missing();
    return p;
  }

  private BannerEntity bn(Long id) {
    var b = db.findBanner(id);
    if (b == null || !"0".equals(b.getDelFlag())) throw ShopException.missing();
    return b;
  }

  private boolean visible(PropEntity p) {
    if (p == null || !"0".equals(p.getDelFlag()) || !"1".equals(p.getStatus())) return false;
    var c = db.findGameCategory(p.getCategoryId());
    return c != null && "0".equals(c.getDelFlag()) && "1".equals(c.getStatus());
  }

  private void version(int expected, int actual) {
    if (expected != actual) throw ShopException.conflict("MALL_VERSION_CONFLICT", "数据已变化，请重新读取。");
  }

  private CategoryResult categoryValue(GameCategoryEntity c) {
    return new CategoryResult(
        id(c.getCategoryId()),
        c.getName(),
        media.url(c.getIconMediaId()),
        c.getSort(),
        c.getRecommended() == 1);
  }

  public List<CategoryResult> categories() {
    return db.listGameCategory(publicQuery(10000)).stream().map(this::categoryValue).toList();
  }

  public HomeResult home() {
    var banners =
        db.listBanner(publicQuery(1000)).stream()
            .filter(b -> visible(db.findProp(b.getTargetPropId())))
            .limit(10)
            .map(
                b ->
                    new BannerResult(
                        id(b.getBannerId()),
                        b.getTitle(),
                        media.url(b.getImageMediaId()),
                        id(b.getTargetPropId()),
                        b.getSort()))
            .toList();
    var cats =
        db.listGameCategory(publicQuery(10000)).stream()
            .filter(c -> c.getRecommended() == 1)
            .limit(8)
            .map(this::categoryValue)
            .toList();
    return new HomeResult(
        banners,
        cats,
        db.listProp(publicQuery(12)).stream().map(this::summary).toList(),
        time(now()));
  }

  private PropSummaryResult summary(PropEntity p) {
    var c = db.findGameCategory(p.getCategoryId());
    return new PropSummaryResult(
        id(p.getPropId()),
        id(p.getCategoryId()),
        c.getName(),
        p.getName(),
        media.url(p.getCoverMediaId()),
        money(p.getPrice()),
        money(p.getOriginalPrice()),
        p.getStock(),
        p.getSales(),
        time(p.getOnSaleTime()),
        visible(p) && p.getStock() > 0);
  }

  private List<PropImageResult> images(Long id) {
    return db.images(id).stream()
        .map(i -> new PropImageResult(media.url(i.getMediaId()), i.getSort()))
        .toList();
  }

  private List<SpecificationResult> specs(PropEntity p) {
    return json.read(p.getSpecJson(), new TypeReference<List<SpecificationResult>>() {});
  }

  private List<String> delivery(PropEntity p) {
    return json.read(p.getDeliveryFieldsJson(), new TypeReference<List<String>>() {});
  }

  private PropDetailResult detailValue(PropEntity p) {
    var s = summary(p);
    return new PropDetailResult(
        s.propId(),
        s.categoryId(),
        s.categoryName(),
        s.name(),
        s.coverUrl(),
        s.price(),
        s.originalPrice(),
        s.stock(),
        s.sales(),
        s.onSaleAt(),
        s.canPurchase(),
        images(p.getPropId()),
        p.getDetailHtml(),
        specs(p),
        delivery(p),
        Math.toIntExact(reviews.countVisible(p.getPropId())),
        reviews.averageScore(p.getPropId()));
  }

  public PropDetailResult detail(Long id) {
    var p = db.findProp(id);
    if (!visible(p)) throw new ShopException(404, "MALL_PROP_NOT_FOUND", "商品不存在或不可浏览。");
    return detailValue(p);
  }

  public PageResult<PropSummaryResult> props(ShopQuery q) {
    return new PageResult<>(db.listProp(q).stream().map(this::summary).toList(), db.countProp(q));
  }

  public AdminPropResult adminProp(Long id) {
    var p = prop(id);
    var s = detailValue(p);
    return new AdminPropResult(
        s.propId(),
        s.categoryId(),
        s.categoryName(),
        s.name(),
        s.coverUrl(),
        s.price(),
        s.originalPrice(),
        s.stock(),
        s.sales(),
        s.onSaleAt(),
        s.canPurchase(),
        s.images(),
        s.detailHtml(),
        s.specs(),
        s.deliveryFields(),
        s.reviewCount(),
        s.averageScore(),
        p.getStatus(),
        p.getVersion(),
        time(p.getCreateTime()),
        time(p.getUpdateTime()));
  }

  public PageResult<AdminPropResult> adminProps(ShopQuery q) {
    state(q.status());
    return new PageResult<>(
        db.listProp(q).stream().map(p -> adminProp(p.getPropId())).toList(), db.countProp(q));
  }

  public AdminCategoryResult category(Long id) {
    var c = cat(id);
    return new AdminCategoryResult(
        id(id),
        c.getName(),
        media.url(c.getIconMediaId()),
        c.getSort(),
        c.getRecommended() == 1,
        c.getStatus(),
        c.getVersion(),
        time(c.getCreateTime()),
        time(c.getUpdateTime()));
  }

  public PageResult<AdminCategoryResult> categories(ShopQuery q) {
    state(q.status());
    return new PageResult<>(
        db.listGameCategory(q).stream().map(c -> category(c.getCategoryId())).toList(),
        db.countGameCategory(q));
  }

  @Transactional
  public AdminCategoryResult createCategory(CreateCategoryCommand c, Actor a) {
    GameCategoryEntity e = new GameCategoryEntity();
    e.setName(name(c.name(), 2, 30));
    e.setIconMediaId(media.mediaId(c.iconUrl()));
    e.setSort(c.sort() == null ? 0 : c.sort());
    e.setRecommended(Boolean.TRUE.equals(c.recommended()) ? 1 : 0);
    e.setStatus(c.status() == null ? "0" : c.status());
    e.setVersion(0);
    e.setDelFlag("0");
    e.setCreateBy(a.name());
    e.setUpdateBy(a.name());
    db.insertGameCategory(e);
    return category(e.getCategoryId());
  }

  @Transactional
  public AdminCategoryResult updateCategory(Long id, UpdateCategoryCommand c, Actor a) {
    var e = db.lockGameCategory(id);
    if (e == null || !"0".equals(e.getDelFlag())) throw ShopException.missing();
    version(c.version(), e.getVersion());
    e.setName(name(c.name(), 2, 30));
    e.setIconMediaId(media.mediaId(c.iconUrl()));
    e.setSort(c.sort());
    e.setRecommended(c.recommended() ? 1 : 0);
    e.setStatus(c.status());
    e.setUpdateBy(a.name());
    if (db.updateGameCategory(e) != 1)
      throw ShopException.conflict("MALL_VERSION_CONFLICT", "数据已变化。");
    return category(id);
  }

  @Transactional
  public void deleteCategory(Long id) {
    var c = db.lockGameCategory(id);
    if (c == null || !"0".equals(c.getDelFlag())) return;
    if (db.countCategoryProps(id) > 0)
      throw ShopException.conflict("MALL_CATEGORY_IN_USE", "分类仍有关联商品。");
    db.deleteGameCategory(id);
  }

  public AdminBannerResult banner(Long id) {
    var b = bn(id);
    return new AdminBannerResult(
        id(id),
        b.getTitle(),
        media.url(b.getImageMediaId()),
        id(b.getTargetPropId()),
        b.getSort(),
        b.getStatus(),
        b.getVersion(),
        time(b.getCreateTime()),
        time(b.getUpdateTime()));
  }

  public PageResult<AdminBannerResult> banners(ShopQuery q) {
    state(q.status());
    return new PageResult<>(
        db.listBanner(q).stream().map(b -> banner(b.getBannerId())).toList(), db.countBanner(q));
  }

  @Transactional
  public AdminBannerResult createBanner(CreateBannerCommand c, Actor a) {
    prop(id(c.targetPropId()));
    BannerEntity b = new BannerEntity();
    b.setTitle(name(c.title(), 1, 60));
    b.setImageMediaId(media.mediaId(c.imageUrl()));
    b.setTargetPropId(id(c.targetPropId()));
    b.setSort(c.sort() == null ? 0 : c.sort());
    b.setStatus(c.status() == null ? "0" : c.status());
    b.setVersion(0);
    b.setDelFlag("0");
    b.setCreateBy(a.name());
    b.setUpdateBy(a.name());
    db.insertBanner(b);
    return banner(b.getBannerId());
  }

  @Transactional
  public AdminBannerResult updateBanner(Long id, UpdateBannerCommand c, Actor a) {
    var b = db.lockBanner(id);
    if (b == null || !"0".equals(b.getDelFlag())) throw ShopException.missing();
    version(c.version(), b.getVersion());
    prop(id(c.targetPropId()));
    b.setTitle(name(c.title(), 1, 60));
    b.setImageMediaId(media.mediaId(c.imageUrl()));
    b.setTargetPropId(id(c.targetPropId()));
    b.setSort(c.sort());
    b.setStatus(c.status());
    b.setUpdateBy(a.name());
    if (db.updateBanner(b) != 1) throw ShopException.conflict("MALL_VERSION_CONFLICT", "数据已变化。");
    return banner(id);
  }

  @Transactional
  public void deleteBanner(Long id) {
    db.lockBanner(id);
    db.deleteBanner(id);
  }

  private void fields(PropEntity p, PropChanges c, Actor a) {
    var cat = db.lockGameCategory(id(c.categoryId()));
    if (cat == null || !"0".equals(cat.getDelFlag())) throw ShopException.missing();
    if ("1".equals(c.status()) && !"1".equals(cat.getStatus()))
      throw ShopException.conflict("MALL_PROP_UNAVAILABLE", "停用分类内不能上架商品。");
    p.setCategoryId(cat.getCategoryId());
    p.setName(name(c.name(), 2, 80));
    p.setCoverMediaId(media.mediaId(c.coverUrl()));
    p.setPrice(amount(c.price()));
    capacity(p.getPrice());
    p.setOriginalPrice(c.originalPrice() == null ? null : amount(c.originalPrice()));
    if (p.getOriginalPrice() != null && p.getOriginalPrice().compareTo(p.getPrice()) < 0)
      throw ShopException.invalid("划线价不能低于售价。");
    unique(c.images().stream().map(PropImageCommand::url).toList());
    if (c.images().stream().noneMatch(i -> i.url().equals(c.coverUrl())))
      throw ShopException.invalid("封面必须在图片集合内。");
    unique(c.specs().stream().map(SpecificationCommand::name).toList());
    unique(c.deliveryFields());
    if (!Set.of("gameAccount", "serverName", "roleName").containsAll(c.deliveryFields()))
      throw ShopException.invalid("交付字段不合法。");
    Safelist safe =
        new Safelist()
            .addTags(
                "p", "br", "strong", "em", "ul", "ol", "li", "h2", "h3", "blockquote", "img", "a")
            .addAttributes("img", "src", "alt")
            .addAttributes("a", "href", "title");
    var html = Jsoup.parseBodyFragment(c.detailHtml());
    for (var e : html.select("img")) {
      if (!e.attr("src").matches("/api/mall/media/[0-9a-f]{32}\\.(png|jpg|webp)")) e.remove();
      else media.mediaId(e.attr("src"));
    }
    for (var e : html.select("a")) {
      String h = e.attr("href");
      if (!h.startsWith("/")
          || h.startsWith("//")
          || h.indexOf('\\') >= 0
          || h.chars().anyMatch(Character::isISOControl)) e.removeAttr("href");
    }
    p.setDetailHtml(Jsoup.clean(html.body().html(), safe));
    p.setSpecJson(json.write(c.specs()));
    p.setDeliveryFieldsJson(json.write(c.deliveryFields()));
    if ("1".equals(c.status()) && !"1".equals(p.getStatus())) p.setOnSaleTime(now());
    p.setStatus(c.status());
    p.setUpdateBy(a.name());
  }

  private void images(Long pid, List<PropImageCommand> images) {
    db.deleteImages(pid);
    for (var i : images) {
      PropImageEntity e = new PropImageEntity();
      e.setPropId(pid);
      e.setMediaId(media.mediaId(i.url()));
      e.setSort(i.sort() == null ? 0 : i.sort());
      db.insertPropImage(e);
    }
  }

  @Transactional
  public AdminPropResult createProp(CreatePropCommand c, Actor a) {
    db.lockGameCategory(id(c.categoryId()));
    PropEntity p = new PropEntity();
    fields(
        p,
        new PropChanges(
            c.categoryId(),
            c.name(),
            c.coverUrl(),
            c.price(),
            c.originalPrice(),
            c.images(),
            c.detailHtml(),
            c.specs(),
            c.deliveryFields(),
            c.status() == null ? "0" : c.status()),
        a);
    p.setStock(c.initialStock() == null ? 0 : c.initialStock());
    p.setSales(0);
    p.setVersion(0);
    p.setDelFlag("0");
    p.setCreateBy(a.name());
    db.insertProp(p);
    images(p.getPropId(), c.images());
    StockLogEntity log = new StockLogEntity();
    log.setPropId(p.getPropId());
    log.setPropName(p.getName());
    log.setChangeQty(p.getStock());
    log.setBeforeStock(0);
    log.setAfterStock(p.getStock());
    log.setBizType("INITIAL");
    log.setBizKey(id(p.getPropId()));
    log.setOperatorType(a.type());
    log.setOperatorId(a.id());
    log.setOperatorName(a.name());
    log.setReason("创建商品初始库存");
    orders.insertStockLog(log);
    return adminProp(p.getPropId());
  }

  @Transactional
  public AdminPropResult updateProp(Long pid, UpdatePropCommand c, Actor a) {
    var old = prop(pid);
    java.util.stream.Stream.of(old.getCategoryId(), id(c.categoryId()))
        .distinct()
        .sorted()
        .forEach(db::lockGameCategory);
    var p = db.lockProp(pid);
    if (p == null || !"0".equals(p.getDelFlag())) throw ShopException.missing();
    version(c.version(), p.getVersion());
    fields(
        p,
        new PropChanges(
            c.categoryId(),
            c.name(),
            c.coverUrl(),
            c.price(),
            c.originalPrice(),
            c.images(),
            c.detailHtml(),
            c.specs(),
            c.deliveryFields(),
            c.status()),
        a);
    if (db.updateProp(p) != 1) throw ShopException.conflict("MALL_VERSION_CONFLICT", "数据已变化。");
    images(pid, c.images());
    return adminProp(pid);
  }

  @Transactional
  public AdminPropResult status(Long pid, UpdatePropStatusCommand c, Actor a) {
    var old = prop(pid);
    db.lockGameCategory(old.getCategoryId());
    var p = db.lockProp(pid);
    if (p == null || !"0".equals(p.getDelFlag())) throw ShopException.missing();
    version(c.version(), p.getVersion());
    if ("1".equals(c.status()) && !"1".equals(cat(p.getCategoryId()).getStatus()))
      throw ShopException.conflict("MALL_PROP_UNAVAILABLE", "分类未启用。");
    if ("1".equals(c.status()) && !"1".equals(p.getStatus())) p.setOnSaleTime(now());
    p.setStatus(c.status());
    p.setUpdateBy(a.name());
    if (db.setPropStatus(p) != 1) throw ShopException.conflict("MALL_VERSION_CONFLICT", "数据已变化。");
    return adminProp(pid);
  }

  @Transactional
  public void deleteProp(Long pid) {
    var old = db.findProp(pid);
    if (old == null || !"0".equals(old.getDelFlag())) return;
    db.lockGameCategory(old.getCategoryId());
    db.lockProp(pid);
    db.deleteProp(pid);
  }
}
