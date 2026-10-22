export const orderStates = { '1': '待支付', '2': '已支付', '3': '已取消', '4': '已完成' }
export const inventoryTypes = { INITIAL: '初始库存', ORDER_RESERVE: '下单预留', ORDER_RELEASE: '取消回补', ADMIN_ADJUST: '人工调整' }
export const configs = {
  categories: { title: '游戏分类', description: '维护分类展示、图标和热门推荐。', id: 'categoryId', permission: 'category', editable: true, columns: [['name','分类名称'],['sort','排序'],['recommended','热门推荐'],['status','状态'],['updatedAt','更新时间']] },
  props: { title: '道具商品', description: '管理商品内容与上下架，库存通过独立操作调整。', id: 'propId', permission: 'prop', editable: true, columns: [['name','商品名称'],['categoryName','游戏分类'],['price','售价'],['stock','可售库存'],['sales','已售数量'],['status','状态'],['updatedAt','更新时间']] },
  banners: { title: '首页轮播', description: '配置轮播图片与关联的站内商品。', id: 'bannerId', permission: 'banner', editable: true, columns: [['title','轮播标题'],['targetPropId','目标商品ID'],['sort','排序'],['status','状态'],['updatedAt','更新时间']] },
  members: { title: '商城会员', description: '查看会员资料和账号状态，禁用会使原登录会话失效。', id: 'memberId', permission: 'member', columns: [['username','会员账号'],['nickname','昵称'],['emailMasked','邮箱'],['phoneMasked','联系方式'],['status','状态'],['lastLoginAt','最近登录']] },
  orders: { title: '商城订单', description: '查询交易明细、取消待支付订单，或登记道具交付。', id: 'orderId', permission: 'order', columns: [['orderNo','订单号'],['member','购买会员'],['totalAmount','订单金额'],['totalQuantity','购买数量'],['status','订单状态'],['createdAt','下单时间']] },
  reviews: { title: '商品评价', description: '查看评价及购买记录，隐藏违规内容并保留原因。', id: 'reviewId', permission: 'review', columns: [['propName','商品名称'],['username','会员账号'],['score','评分'],['content','评价内容'],['status','可见状态'],['createdAt','发表时间']] },
  'stock-logs': { title: '库存流水', description: '追踪库存变化和操作来源，交易流水保留历史。', id: 'stockLogId', permission: 'stock', columns: [['propName','商品名称'],['changeQty','变动数量'],['beforeStock','变动前'],['afterStock','变动后'],['bizType','业务类型'],['reason','操作原因'],['createdAt','操作时间']] }
}
export function stateOptions(resource) {
  if (resource === 'stock-logs') return []
  const values = resource === 'orders' ? orderStates : resource === 'reviews' ? { VISIBLE: '可见', HIDDEN: '已隐藏' } : resource === 'members' ? { '0': '正常', '1': '禁用' } : resource === 'props' ? { '0': '下架', '1': '上架' } : { '0': '停用', '1': '启用' }
  return Object.entries(values).map(([value,label]) => ({ value,label }))
}
export function display(resource, key, value) {
  if (key === 'status') return stateOptions(resource).find(x => x.value === value)?.label || value
  if (key === 'bizType') return inventoryTypes[value] || value
  if (key === 'recommended') return value ? '推荐' : '普通'
  if (key === 'member') return value?.username || '—'
  if (['price','totalAmount','originalPrice'].includes(key)) return value == null ? '—' : `¥${value}`
  if (key.endsWith('At')) return value ? value.replace('T',' ').replace('+08:00','') : '—'
  return value ?? '—'
}
