package com.example.spring.websocket.handler;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by a.evstratiev on 8/15/2014.
 */
public class EchoHandler extends TextWebSocketHandler {

    private static Set<WebSocketSession> clients = Collections.synchronizedSet(new HashSet<WebSocketSession>());

    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        clients.add(session);
    }

    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        for (WebSocketSession client : clients) {
            client.sendMessage(message);
        }
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        clients.remove(session);
    }
}
