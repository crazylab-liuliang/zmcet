<%--
  Created by IntelliJ IDEA.
  User: albert
  Date: 2017/12/18
  Time: 11:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>娃娃达人</title>
    <style type="text/css">
        html, body {
            background-color: #111;
            text-align: center;
        }
    </style>

    <script>
        function onPressStart(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "/op?type=0&value=0", true);
            xmlhttp.send()
        }

        function onPressForward(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "/op?type=1&value=1", true);
            xmlhttp.send()
        }

        function onPressBack(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "/op?type=2&value=1", true);
            xmlhttp.send()
        }

        function onPressLeft(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "/op?type=3&value=1", true);
            xmlhttp.send()
        }

        function onPressRight(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "/op?type=4&value=1", true);
            xmlhttp.send()
        }

        function onPressTake(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "/op?type=5&value=0", true);
            xmlhttp.send()
        }
    </script>
</head>
<body>
    <canvas id="video-canvas"></canvas>
    <script type="text/javascript" src="RES/js/jsmpeg.min.js"></script>
    <script type="text/javascript">
        var canvas = document.getElementById('video-canvas');
        var url = 'ws://118.190.156.61:10002/camera_0';
        var player = new JSMpeg.Player(url, {canvas: canvas});
    </script>

    <button type="button" onclick="onPressStart()">start</button>
    <button type="button" onclick="onPressForward()">forward</button>
    <button type="button" onclick="onPressBack()">back</button>
    <button type="button" onclick="onPressLeft()">left</button>
    <button type="button" onclick="onPressRight()">right</button>
    <button type="button" onclick="onPressTake()">take</button>
</body>
</html>
