<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.good.vo.Good" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jtwu
  Date: 2021/9/22
  Time: 14:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>
        在线购物平台
    </title>
</head>
<style>
    .navbar {
        margin-bottom: 0;
        position: fixed;
        left: 0;
        right: 0;
        z-index: 9999;
    }
    #titleText{
        background-color: #037bd2;
        font-size: xxx-large;
        color: whitesmoke;
        transition-duration: 0.4s;
        border: none;
        width: 100%;
        text-decoration: none;
        cursor:pointer
    }
    a.astyle{
        background-color: #037bd2;
        font-size: xx-large;
        color: whitesmoke;
        transition-duration: 0.4s;
        border: none;
        width: 100%;
        text-decoration: none;
        cursor:pointer
    }
    .astyle:hover{
        color: lightgray;
    }
    #title_tr{
        color: #037bd2;
        border-style: none;
    }
    td.title_td{
        border-style: none;
    }
    table.title{
        position: fixed;
        width: 100%;
        height: 10%;
        top: 0;
        background-color: #037bd2;
        margin-left: 1%;
        z-index: 0;
    }
    .bd{
        margin-top: 10%;
        margin-left: 20%;
        margin-right: 20%;
        height: 70%;
    }
    .dh{
        height: 33.3%;
        width: 100%;
        writing-mode: vertical-lr;
        font-size: xx-large;
        font-family: "Microsoft Himalaya";
        color: white;
        text-align: center;
        cursor: pointer;

    }
    /*.dh:hover{*/
    /*    background-color: #2e6da4;*/
    /*}*/
    /*.dh:visited{*/
    /*    background-color: #2e6da4;*/
    /*}*/
    .i1{
        width: 400px;
        height: 400px;
        background-size: 100%;
        border-radius: 10px;
    }
    .i2{
        width: 300px;
        height: 300px;
        background-size: 100% 100%;
        border-radius: 10px;
    }
    .i3{
        width: 50px;
        height: 50px;
        background-size: 100% 100%;
    }
    .button1{
        margin: 0 auto;
        background-color: salmon; /* Green */
        border: none;
        color: white;
        margin-top: 5%;
        padding: 15px 30px;
        width: 200%;
        text-align: center;
        text-decoration: none;
        display: inline-block;
        font-size: 32px;
        border-radius: 5px;
    }
    .button1:active {
        background-color: #e4b9c0;
        box-shadow: 0 5px #d9edf7;
        transform: translateY(4px);
    }
    .sp1 {
        font-family: "Microsoft Himalaya";
        color: #a94442;
        font-style: italic;
        font-size: x-large;
    }
    .sp2 {
        font-family: "Microsoft Himalaya";
        font-size: large;
        font-style: inherit;
        margin-left: 5%;
        color: #a94442;

    }
    .s1 {
        cursor: pointer;
        display: table-cell;
        vertical-align: middle;
    }

</style>
<c:if test="${empty pictures}">
    <c:if test="${empty requestScope.flag}">
        <jsp:forward page="GoodServlet"></jsp:forward>
    </c:if>
</c:if>
<%
    List<String> imgList = (List<String>)session.getAttribute("pictures");
    Good good = (Good) session.getAttribute("good");
    String s = "";
    if (imgList != null) {
        Iterator<String> it = imgList.iterator();
        while (it.hasNext()) {
            String url = it.next();
            if (s == "") {
                s += url;
            } else {
                s = s + " " + url;
            }
        }
    }
%>


<script>
    window.alert = alert();
    var index = 0;
    var imgList = "<%=s%>".split(" ");
    function next() {
        // var s = document.getElementById("src").value;
        var flag = 1;
        index ++;
        if (index == imgList.length) {
            index = 0;
            flag = 0;
        }
        document.getElementById("picture").src = imgList[index];
        if (flag == 1) {
            document.getElementById(index.toString()).style.boxShadow = "inset 0 1px 1px white,0 0 8px lightskyblue";
            document.getElementById((index - 1).toString()).style.boxShadow = "none";
        } else {
            document.getElementById(index.toString()).style.boxShadow = "inset 0 1px 1px white,0 0 8px lightskyblue";
            document.getElementById((imgList.length - 1).toString()).style.boxShadow = "none";
        }
    }
    function back() {
        // var s = document.getElementById("src").value;
        var flag = 1;
        index --;
        if (index < 0) {
            index = imgList.length - 1;
            flag = 0;
        }
        document.getElementById("picture").src = imgList[index];
        if (flag == 1) {
            document.getElementById(index.toString()).style.boxShadow = "inset 0 1px 1px white,0 0 8px lightskyblue";
            document.getElementById((index + 1).toString()).style.boxShadow = "none";
        } else {
            document.getElementById(index.toString()).style.boxShadow = "inset 0 1px 1px white,0 0 8px lightskyblue";
            document.getElementById((0).toString()).style.boxShadow = "none";
        }
    }

    function dianji(x) {
        if (x == "true") {
            alert("商品已冻结", "ZT2");
        } else {
            alert("商品正在出售", "ZT1");
        }
    }

    function panDuan(freeze) {
        if (freeze == "true") {
            alert("抱歉，商品已冻结，无法购买", "DG");
        } else {
            location.href = "information.jsp";
        }
    }

    function alert(data, type) {
        var div = document.createElement("div");
        var p = document.createElement("p");
        var img = document.createElement("img");
        var btu = document.createElement("button");
        var text = document.createTextNode(data?data:"");
        var btuTest = document.createTextNode("确定");
        var imgPath;
        if (type == "DG") {
            imgPath = "pictures/叉叉.png";
        } else if (type == "ZT1") {
            imgPath = "pictures/商品.png";
        } else if (type == "ZT2") {
            imgPath = "pictures/商品冻结.png";
        }

        p.appendChild(text);
        btu.appendChild(btuTest);
        img.src = imgPath;
        div.appendChild(img);
        div.appendChild(p);
        div.appendChild(btu);
        document.getElementsByTagName("body")[0].appendChild(div);
        btu.onclick = function () {
            div.parentNode.removeChild(div);
        }
        css(btu, {
            'margin': '0 auto',
            'background-color': '#4CAF50',
            'border': 'none',
            'color': 'white',
            'margin-top': '5%',
            'padding': '5px 10px',
            'text-decoration': 'none',
            'display': 'inline-block',
            'font-size': '16px',
            'border-radius': '5px'
        })
        css(div, {
            'top': '30%',
            'left': '40%',
            'background': 'white',
            'position': 'fixed',
            'margin': '0 auto',
            'width': '400px',
            'text-align': 'center',
            'height': '250px',
            'border-radius': '20px'
        })
        css(img, {
            'width': '100px',
            'height': '100px',
        })
        css(img, {
            'margin-top': '20px'
        })
    }

    function css(target, cssList) {
        var str = target.getAttribute("style")?target.getAttribute("style"):"";
        for (var i in cssList) {
            str += i + ':' + cssList[i] + ';';
        }
        target.style.cssText = str;
    }

    function login() {
        location.href = "sign_in.jsp";
    }

</script>
<body style="background-image: url(pictures/background.png);">
<c:if test="${not empty sessionScope.good}">
    <input type="hidden" value="${pageContext.request.contextPath}/pictures/" id="src">
    <div class="navbar navbar-inverse">
        <table class="title">
            <tr id="title_tr" align="center">
                <td width="60%" align="center"><a href="GoodServlet" id="titleText">在 线 购 物 系 统</a></td>
                <td width="10%" class="title_td"><a href="GoodServlet" class="astyle">商品列表</a></td>
                <td width="10%" class="title_td"><a class="astyle" onclick="dianji('${sessionScope.good.freeze}')">商品状态</a></td>
                <td width="10%" class="title_td"><a href="./sign_in.jsp" class="astyle">商家登录</a></td>
            </tr>
        </table>
    </div>
    <form action="information.jsp" method="post">
        <div class="bd">
            <div style="width: 10%; height: 100%; background: #9acfea; float: left">
                <div id="d1" class="dh" onclick="document.getElementById('w1').style.display='block';
            document.getElementById('w2').style.display='none'; document.getElementById('w3').style.display='none';
            document.getElementById('d1').style.background='#2e6da4'; document.getElementById('d2').style.background='#9acfea';
            document.getElementById('d3').style.background='#9acfea';"; style="background: #2e6da4;">商品简介</div>
                <div id="d2" class="dh" onclick="document.getElementById('w2').style.display='block';
            document.getElementById('w1').style.display='none'; document.getElementById('w3').style.display='none';
            document.getElementById('d1').style.background='#9acfea'; document.getElementById('d2').style.background='#2e6da4';
            document.getElementById('d3').style.background='#9acfea'">商品图片</div>
                <div id="d3" class="dh" onclick="document.getElementById('w3').style.display='block';
            document.getElementById('w2').style.display='none'; document.getElementById('w1').style.display='none';
            document.getElementById('d1').style.background='#9acfea'; document.getElementById('d2').style.background='#9acfea';
            document.getElementById('d3').style.background='#2e6da4'">商品信息</div>
            </div>
            <div style="width: 90%; height: 100%; float: left; background: #d9edf7" id="w1">
                <div style="width: 45%; height: 100%; float: left; padding-top: 5%; z-index: 0">
                    <img src="${sessionScope.good.pictures.get(0)}" class="i1">
                </div>
                <div style="padding-top: 5%; padding-left: 50%; text-align: left">
                    <h1 style="margin: 0 auto">${sessionScope.good.goodName}</h1>
<%--                    <h6 style="color: red">${sessionScope.good.wwhDes}</h6>--%>
                    <br/>
                </div>
                <div style="padding-top: 2%; padding-bottom: 2%; padding-left: 50%; text-align: left; background-image: url(pictures/price3.png)">
                    <span style="color: orangered; font-size: large; text-align: center; padding-bottom: 15px">价格</span><span style="color: orangered; font-size: xxx-large; text-align: center; margin-left: 10%">￥${sessionScope.good.price}</span>
                </div>
                <div style="margin: 0 auto; float: left; padding-top: 10%; padding-left: 10%">
                        <%--                <input type="submit" value="选购" class="button1">--%>
                    <input type="button" value="选购" class="button1" onclick="panDuan('${sessionScope.good.freeze}')">
                </div>
            </div>
            <div style="width: 90%; height: 100%; float: left;display: none; background: #d9edf7" id="w2">
                <div style="margin: 0 auto; text-align: center; margin-top: 5%">
                    <img src="${sessionScope.good.pictures.get(0)}" class="i2" id="picture">
                </div>
                <div style="margin: 0 auto; text-align: center; margin-top: 10%; width: 80%; height: 20%; position: relative; left: 22%">
                    <div><img src="pictures/back.png" style="width: 50px; height: 50px; cursor: pointer; float: left" onclick="back()"></div>
                    <div style="display: inline; overflow-x: scroll; white-space: nowrap; float: left">
                        <c:forEach items="${sessionScope.pictures}" var="i" varStatus="st">
                            <span id="${st.index}" style="max-width: 30%; box-shadow: 0px 0px 10px #2e6da4"><img class="i3" src="${i}"></span>
                        </c:forEach>
                    </div>
                    <div><img src="pictures/more.png" style="width: 50px; height: 50px; cursor: pointer; float: left" onclick="next()"></div>
                </div>
            </div>
            <div style="width: 90%; height: 100%; float: left;display: none; background: #d9edf7" id="w3">
                <div style="margin-top: 10%; margin-left: 5%; margin-right: 5%;">
                    <span class="sp1">商品名称：</span><span class="sp2">${sessionScope.good.goodName}</span>
                </div>
<%--                <div style="margin-top: 3%; margin-left: 5%; margin-right: 5%;">--%>
<%--                    <span class="sp1">商品产地：</span><span class="sp2">${sessionScope.good.origin}</span>--%>
<%--                </div>--%>
                <div style="margin-top: 3%; margin-left: 5%; margin-right: 5%;">
                    <span class="sp1">商品状态：</span><span class="sp2">${sessionScope.good.online?(sessionScope.good.freeze?"冻结":"在售"):"已下架"}</span>
                </div>
                <div style="margin-top: 5%; margin-left: 5%; margin-right: 5%; border: 3px #a94442; border-radius: 10px; z-index: 9999; border-style: dotted">
                    <span class="sp1">${good.description}</span>
                </div>
            </div>
        </div>
    </form>
</c:if>
<c:if test="${empty sessionScope.good}">
    <div style="position: absolute; z-index: 9999; top: 1%; right: 1%; display: table; vertical-align: middle; cursor: pointer" onclick="login()">
        <span class="s1"><img src="pictures/登录.png" style="width: 40px; height: 40px"></span>
        <span class="s1" style="color: white; font-size: xx-large; font-family: 'Microsoft Himalaya'">商家登录</span>
    </div>
    <div style="margin: 0 auto; width: 50%; margin-top: 10%">
        <form action="SellerServlet?method=login" method="post">
            <div style="border: 5px #e4b9c0; border-radius: 10px; border-style: solid; background: white; margin-left: 15%; margin-right: 15%; padding-bottom: 7%; padding-top: 5%">
                <div style="display: table; margin: 0 auto; text-align: center">
                    <div style="vertical-align: middle; display: table-cell; color: midnightblue; font-family: 'Microsoft Himalaya'; font-size: xx-large">当前没有商品，请等待商家发布。</div>
                    <div style="display: table-cell; vertical-align: middle"><img src="pictures/笑脸.png" style="width: 60px; height: 60px"></div>
                </div>
            </div>
        </form>
    </div>
</c:if>

</body>
</html>
