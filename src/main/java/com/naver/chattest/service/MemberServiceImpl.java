package com.naver.chattest.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.naver.chattest.dao.MemberDAO;
import com.naver.chattest.domain.Chat;

@Service
public class MemberServiceImpl implements MemberService {
	@Autowired
	private MemberDAO dao;
		
	@Override
	public int insert(Chat m) {
		return dao.insert(m);
	}
	@Override
	public int isId(String id) {
		Chat member = dao.isMember(id);
		int result = -1;
		if(member != null) {
			result = 0;
		}
		return result;
	}
	@Override
	public Map<String, Object> isMember(String id, String password) {
		Map<String, Object> map = new HashMap<String, Object>();
		Chat member = dao.isMember(id);
		int result = -1;
		if(member != null) {
			if(member.getPassword().equals(password)) {
				result = 1;
				map.put("filename", member.getSavefile());
			} else {
				result = 0;
			}
		}
		map.put("result", result);
		return map;
	}
}
