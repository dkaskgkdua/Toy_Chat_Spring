package com.naver.chattest.service;

import java.util.Map;

import com.naver.chattest.domain.Chat;

public interface MemberService {
	public int insert(Chat m);
	public int isId(String id);
	public Map<String, Object> isMember(String id, String password);
}
