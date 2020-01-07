package com.naver.chattest.domain;

import javax.websocket.Session;

import lombok.Data;

@Data
public class Cart {
	private Session session;
	private String id;
	private String filename;
}
