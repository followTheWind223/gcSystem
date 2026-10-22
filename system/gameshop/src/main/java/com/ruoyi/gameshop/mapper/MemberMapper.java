package com.ruoyi.gameshop.mapper;

import com.ruoyi.gameshop.model.query.ShopQuery;
import com.ruoyi.gameshop.persistence.entity.*;
import java.util.List;
import org.apache.ibatis.annotations.*;

@Mapper
public interface MemberMapper {
  MemberEntity bySysUserId(@Param("userId") Long userId);

  MemberEntity lockMemberBySysUserId(@Param("userId") Long userId);

  Long lockSysUser(@Param("userId") Long userId);

  MemberEntity findMember(@Param("id") Long id);

  MemberEntity lockMember(@Param("id") Long id);

  int insertMember(MemberEntity row);

  MemberEntity byUsername(@Param("username") String username);

  MemberEntity byEmail(@Param("email") String email);

  int updateProfile(MemberEntity row);

  int updateAvatar(MemberEntity row);

  int changePassword(MemberEntity row);

  int setStatus(MemberEntity row);

  int recordLogin(@Param("id") Long id);

  List<MemberEntity> listMember(ShopQuery query);

  long countMember(ShopQuery query);
}
