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
    <link rel="shortcut icon" href="/RES/img/logo.ico" type="image/x-icon" />

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.3/umd/popper.min.js" integrity="sha384-vFJXuSJphROIrBnz7yo7oB41mKfc8JzQZiCq4NCceLEaO4IHwicKwpJf9c9IpFgh" crossorigin="anonymous"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/js/bootstrap.min.js" integrity="sha384-alpBpkh1PFOepccYVYDB4do5UnbKysX5WZXm3XxPqe5iKTfUKjNkCk9SaVuEZflJ" crossorigin="anonymous"></script>

    <style type="text/css">
        html, body {
            background-color: #111;
            text-align: center;
        }

        .container-fluid {
            padding-left: 0px;
            padding-right: 0px;
        }
    </style>

    <script>
        function onPressStart(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "http://118.190.156.61:8900/op?machine=apple&type=0&value=0", true);
            xmlhttp.send()
        }

        function onPressForward(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "http://118.190.156.61:8900/op?machine=apple&type=1&value=1", true);
            xmlhttp.send()
        }

        function onPressBack(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "http://118.190.156.61:8900/op?machine=apple&type=2&value=1", true);
            xmlhttp.send()
        }

        function onPressLeft(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "/op?machine=apple&type=3&value=1", true);
            xmlhttp.send()
        }

        function onPressRight(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "http://118.190.156.61:8900/op?machine=apple&type=4&value=1", true);
            xmlhttp.send()
        }

        function onPressTake(){
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.open("GET", "http://118.190.156.61:8900/op?machine=apple&type=5&value=0", true);
            xmlhttp.send()
        }
    </script>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-7">
                <canvas id="video-canvas" style="width:100%"></canvas>
            </div>
            <div class="col-md-5">
                <button type="button" onclick="onPressStart()">start</button>
                <button type="button" onclick="onPressForward()">forward</button>
                <button type="button" onclick="onPressBack()">back</button>
                <button type="button" onclick="onPressLeft()">left</button>
                <button type="button" onclick="onPressRight()">right</button>
                <button type="button" onclick="onPressTake()">take</button>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="/RES/js/jsmpeg.min.js"></script>
    <script type="text/javascript">
        var canvas = document.getElementById('video-canvas');
        var url = 'ws://118.190.156.61:10002/camera_0';
        var player = new JSMpeg.Player(url, {canvas: canvas});
    </script>

</body>
</html>
