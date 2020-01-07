package com.naver.chattest.domain;


import org.springframework.web.multipart.MultipartFile;

import lombok.Data;
@Data
public class Chat {
	private String id;
	private String password;
	private MultipartFile uploadfile;
	private String savefile="/image/default.png";
	private String originalfile="/image/default.png";
}
