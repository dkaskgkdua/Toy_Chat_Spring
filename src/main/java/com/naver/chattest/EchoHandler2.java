package com.naver.chattest;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;

import com.naver.chattest.domain.Cart;

@Controller
@ServerEndpoint(value = "/boot.do") // 클라이언트가 접속할 서버 주소
public class EchoHandler2 {

   private static final List<Cart> sessionList = new ArrayList<Cart>();
   private static final Logger logger = LoggerFactory.getLogger(EchoHandler2.class);

   public EchoHandler2() {
      logger.info("웹소켓(서버) 객체 생성");

      /*
       * @onOpen 는 클라이언트가 웹소켓에 들어오고 서버에 아무런 문제 없이 들러왔을때 실행하는 메소드입니다.
       * 
       * javax.websocket.Session; 접속자마다 한개의 세션이 생성되어 데이터 통신수단으로 사용디며 접속자 마다 구분됩니다.
       * 
       */
   }

   @OnOpen
   public void onOpen2(Session session) {
      logger.info("Open session id:" + session.getId());
      logger.info("session 쿼리 스트링 : " + session.getQueryString());
      
      String queryString = session.getQueryString();
      String id = queryString.substring(queryString.indexOf("=")+1, queryString.indexOf("&"));
      System.out.println("id = " + id);
      String filename = queryString.substring(queryString.indexOf("/"));
      Cart cart = new Cart();
      cart.setSession(session);
      cart.setFilename(filename);
      cart.setId(id);
      sessionList.add(cart);
      
      String message = id + "님이 입장하셨습니다.in";
      sendAllSessionToMessage(session, message);
      
      
      
   }
   @OnError
   public void onError2(Throwable e,Session session) {
	   e.printStackTrace();
	   logger.info("error입니다.");
	   remove(session);
   }
   @OnClose
   public void onClose(Session session) throws InvocationTargetException {
	   logger.info("Session " + session.getId()+ "has ended");
	   remove(session);
   }
   
   private void remove(Session session) {
	   synchronized(sessionList) {
		   for(int i=0; i<sessionList.size(); i++) {
			   Session s = sessionList.get(i).getSession();
			   if(session.getId().equals(s.getId())) { // 나와 세션 아이디가 같으면
				   sessionList.remove(i);
			   }
		   }
	   }
   }
   
   @OnMessage
   public void onMessage2(String getMessage, Session session) {
	   logger.info("onMessage : " + getMessage);
	   sendAllSessionToMessage(session, getMessage);
   }
   private void sendAllSessionToMessage(Session self, String message) {
	   String info = getinfo(self);
	   
	   synchronized(sessionList) {
		   try {
			   for(Cart cart : EchoHandler2.sessionList) {
				   Session s = cart.getSession();
				   if(!self.getId().equals(s.getId())) { //나를 제외한 사람에게
					   // 1234&/2019-7-6/bbs2019769753.png&1234님이 들어옵니다.
					   logger.info("나를 제외한 모든 사람에게 보내는 메시지:" + info + "&" + message);
					   s.getBasicRemote().sendText(info + "&" + message);
				   }
			   }
		   }catch(Exception e) {
			   logger.info("sendAllSessionToMessage 오류" + e.getMessage());
		   }
	   } 
   }
   
   private String getinfo(Session self) {
	   String information = "";
	   synchronized(sessionList) {
		   
			   for(Cart cart : EchoHandler2.sessionList) {
				   Session s = cart.getSession();
				   if(self.getId().equals(s.getId())) { 
					   information = cart.getId() + "&" + cart.getFilename();
					   // 보낸 사람의 정보 : 1234&/2019-7-6/bbs2019769753.png
					   logger.info("보낸 사람의 정보:" + information);
					   break;
				   }
			   }
		   
	   }
	   return information;
   }
   
}