package com.naver.chattest;

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

@Controller
@ServerEndpoint(value = "/echo.do") // 클라이언트가 접속할 서버 주소
public class EchoHandler {

   private static final List<Session> sessionList = new ArrayList<Session>();
   private static final Logger logger = LoggerFactory.getLogger(EchoHandler.class);

   public EchoHandler() {
      logger.info("웹소켓(서버) 객체 생성");

      /*
       * @onOpen 는 클라이언트가 웹소켓에 들어오고 서버에 아무런 문제 없이 들러왔을때 실행하는 메소드입니다.
       * 
       * javax.websocket.Session; 접속자마다 한개의 세션이 생성되어 데이터 통신수단으로 사용디며 접속자 마다 구분됩니다.
       * 
       */
   }

   @OnOpen
   public void onOpen(Session session) {
      logger.info("Open session id:" + session.getId());
     
      try {
         // 자신과 연결된 session을 통해 문자열을 보냅니다.(즉, 자기 자신에게만 메시지 전달)
         session.getBasicRemote().sendText("Connection Established");
      } catch (Exception e) {
         System.out.println(e.getMessage());
      }
      sessionList.add(session);
   }
   @OnError
   public void onError(Throwable e,Session session) {
	   logger.info("error입니다.");
   }
   @OnClose
   public void onClose(Session session) {
	   logger.info("Session " + session.getId()+ "has ended");
	   sessionList.remove(session);
   }
   
   @OnMessage
   public void onMessage(String getMessage, Session session) {
	   logger.info("onMessage : " + session.getId());
	   logger.info("onMessage : " + getMessage);
	   int index= getMessage.lastIndexOf(",");
	   String input = getMessage.substring(0, index);
	   String sender = getMessage.substring(index+1);
	   logger.info("Message From " + input + ":" + sender);
	   try {
		   session.getBasicRemote().sendText(input);
		   
	   } catch (Exception e) {
		   e.printStackTrace();
	   }
	   String message = sender +">" +input;
	   sendAllSessionToMessage(session, message);
   }
   private void sendAllSessionToMessage(Session self, String sendMessage) {
	   try {
		   for(Session session : EchoHandler.sessionList) {
			   if(!self.getId().equals(session.getId())) {
				   session.getBasicRemote().sendText(sendMessage);
			   }
		   }
	   } catch(Exception e) {
		   e.printStackTrace();
	   }
   }
   
}