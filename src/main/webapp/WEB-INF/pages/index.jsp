<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head lang="en">

    <meta charset="UTF-8">

    <title>WebSocket Example</title>

    <link rel="stylesheet" type="text/css" href="${ctx}/resources/css/normalize.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/resources/css/styles.css">

</head>
<body>

<div class="container">

    <div class="header">
        <h1>WebSocket Example</h1>
    </div>

    <div class="chat-container-outer">
        <div class="chat-container-inner">
            <div class="info-box"></div>
            <div class="chat-box"></div>
            <div class="control-box">
                <input type="text" name="nickname" class="user-name" id="userNickname" placeholder="Nickname" maxlength="50">
                <input type="text" name="message" class="user-message" id="userMessage" placeholder="Message" maxlength="80"/>
                <button class="send-button" id="send-button">Send</button>
            </div>
        </div>
    </div>

</div>

<script type="text/html" id="parcel-template">
    <div class="parcel">
        <div class="nickname">{{ nickname }}:</div>
        <div class="message">{{ message }}</div>
    </div>
</script>

<script type='text/javascript' src='${ctx}/resources/js/vendor/jquery.js'></script>
<script type='text/javascript' src='${ctx}/resources/js/vendor/underscore.js'></script>
<script type='text/javascript' src='${ctx}/resources/js/vendor/utils.js'></script>

<script>

    _.templateSettings = {
        interpolate: /\{\{(.+?)\}\}/g
    };

    var userColor = "#ffcfa1";
    var othersColor = "#a1d1ff";

    jQuery(document).ready(function($) {

        var userId = guid();
        var parcelTemplate = _.template($("#parcel-template").html());

        var webSocket = new WebSocket('ws://localhost:8080/${ctx}/websocket/echo');

        webSocket.onopen = function(event) {
            $('div.info-box').append($('<div>Connected!</div>'));
        };

        webSocket.onmessage = function(event) {
            var parcel = JSON.parse(event.data);
            var backgroundColor = (parcel.userId === userId) ? userColor : othersColor;
            var parcelHtml = parcelTemplate(parcel);
            $('div.chat-box').append($(parcelHtml).css({'background-color': backgroundColor}));
        };

        webSocket.onclose = function(event) {
            $('div.info-box').append($('<div>Closed!</div>'));
        };

        $('#send-button').click(function() {
            var userMessage = $('#userMessage').val();
            if (userMessage == "") {
                return false;
            }
            var userNickname = $('#userNickname').val();
            userNickname = (userNickname == "") ? "guest" : userNickname;
            var parcel = {userId: userId, nickname: userNickname, message: userMessage};

            webSocket.send(JSON.stringify(parcel));

        });

    });

</script>

</body>
</html>