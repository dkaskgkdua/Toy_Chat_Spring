package com.naver.chattest.dao;

import java.util.HashMap;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.naver.chattest.domain.Chat;


@Repository
public class MemberDAO {
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public int insert(Chat chat) {
		return sqlSession.insert("Chats.insert", chat );
	}
	
	public Chat isMember(String id) {
		return sqlSession.selectOne("Chats.idcheck", id);
	}
}
