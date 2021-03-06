<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="${pageContext.request.contextPath}/js/template.js"></script>
<script id="welcome1" type="text/html">
    <li class="userName">
        您好：{{name}}!
    </li>
    <li class="dropdown">
        <a href="#" class="dropdown-toggle user-active" data-toggle="dropdown" role="button">
            <img class="img-circle" src="${pageContext.request.contextPath}/images/user.jpeg" height="30" />
            <span class="caret"></span>
        </a>
        <ul class="dropdown-menu">
            <li>
                <a href="#" data-toggle="modal" data-target="#modifyPasswordModal">
                    <i class="glyphicon glyphicon-cog"></i>修改密码
                </a>
            </li>
            <li>
                <a href="#" onclick="logout()">
                    <i class="glyphicon glyphicon-off"></i> 退出
                </a>
            </li>
        </ul>
    </li>
</script>
<script id="welcome2" type="text/html">
    <li>
        <a href="#" data-toggle="modal" data-target="#loginModal">登陆</a>
    </li>
    <li>
        <a href="#" data-toggle="modal" data-target="#registModal">注册</a>
    </li>
</script>
<script>
    $(function changetop() {
        var li1=document.getElementById("main");
        var li2=document.getElementById("myOrders");
        var li3=document.getElementById("cart");
        var li4=document.getElementById("center");
        li1.className="";
        li2.className="";
        li3.className="";
        li4.className="";
        switch (<%=request.getParameter("page")%>) {
            case 1:li1.className="active";break;
            case 2:li2.className="active";break;
            case 3:li3.className="active";break;
            case 4:li4.className="active";break;
        }
    });
    //密码登入
    function loginByAccount() {
        $.post(
            '${pageContext.request.contextPath}/front/customer/loginByAccount',
            $('#frmLoginByAccount').serialize(),
            function (result) {
                if (result.status==1) {
                    $('#loginModal').modal('hide');//登入模态框消失
                    $('#navbarInfo').html(template('welcome1',result.data));//局部刷新
                }
                else
                    $('#loginInfo').html(result.message);
            }
        );
    }
    //退出
    function logout() {
        $.post(
            '${pageContext.request.contextPath}/front/customer/logout',
            function (result) {
                if (result.status==1){
                    $('#navbarInfo').html(template('welcome2',result.data));//局部刷新
                }
                else
                    alert("退出失败！");
            }
        )
    }
    //注册
    function regist() {
        $.post(
            '${pageContext.request.contextPath}/front/customer/regist',
            $('#frmRegist').serialize(),
            function (result) {
                if (result.status==1) {
                    $('#registModal').modal('hide');//登入模态框消失
                }
                alert(result.message)
            }
        );
    }
    //修改密码
    function modifyPassword(test) {
        if (test)
            $.post(
                '${pageContext.request.contextPath}/front/customer/modifyPassword',
                $('#frmModifyPassword').serialize(),
                function (result) {
                    if (result.status==1) {
                        $('#modifyPasswordModal').modal('hide');//登入模态框消失
                    }
                    alert(result.message)
                }
            );
        else
            $('#modifyPasswordModal').modal('hide');//登入模态框消失
    }
</script>
<!-- navbar start -->
<div class="navbar navbar-default clear-bottom">
    <div class="container">
        <div class="navbar-header">
                <img class="brand-img" src="${pageContext.request.contextPath}/images/logo.jpg" alt="logo" height="70">
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li class="active" id="main">
                    <a href="${pageContext.request.contextPath}/front/product/search?page=1">商城主页</a>
                </li>
                <li id="myOrders">
                    <a href="${pageContext.request.contextPath}/front/Orders/findAll?page=2">我的订单</a>
                </li>
                <li id="cart">
                    <a href="${pageContext.request.contextPath}/front/sessions/cart?page=3">购物车</a>
                </li>
                <li id="center">
                    <a href="${pageContext.request.contextPath}/front/tell/findAll?page=4">会员中心</a>
                </li>
            </ul>
            <ul class="nav navbar-nav navbar-right" id="navbarInfo">
                <c:choose>
                    <c:when test="${empty customer}">
                        <li>
                            <a href="#" data-toggle="modal" data-target="#loginModal">登陆</a>
                        </li>
                        <li>
                            <a href="#" data-toggle="modal" data-target="#registModal">注册</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="userName">
                            您好：${customer.name}！
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle user-active" data-toggle="dropdown" role="button">
                                <img class="img-circle" src="${pageContext.request.contextPath}/images/user.jpeg" height="30" />
                                <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <li>
                                    <a href="#" data-toggle="modal" data-target="#modifyPasswordModal">
                                        <i class="glyphicon glyphicon-cog"></i>修改密码
                                    </a>
                                </li>
                                <li>
                                    <a href="#" onclick="logout()">
                                        <i class="glyphicon glyphicon-off"></i> 退出
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</div>
<!-- navbar end -->

<!-- 修改密码模态框 start -->
<div class="modal fade" id="modifyPasswordModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">修改密码</h4>
            </div>
            <form id="frmModifyPassword" class="form-horizontal" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">原密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="password">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">新密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="newPassword">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">重复密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="renewPassword">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" aria-label="Close">关&nbsp;&nbsp;闭</button>
                    <button type="reset" class="btn btn-warning">重&nbsp;&nbsp;置</button>
                    <button type="button" class="btn btn-warning" onclick="modifyPassword(confirm('是否确认修改'))">修&nbsp;&nbsp;改</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- 修改密码模态框 end -->

<!-- 登录模态框 start  -->
<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <!-- 用户名密码登陆 start -->
        <div class="modal-content" id="login-account">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">用户名密码登录&nbsp;&nbsp;<small class="text-danger" id="loginInfo"></small></h4>
            </div>
            <form  class="form-horizontal" method="post" id="frmLoginByAccount">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">用户名：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text" name="loginName" placeholder="请输入用户名">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">密&nbsp;&nbsp;&nbsp;&nbsp;码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="password" placeholder="请输入密码">
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="text-align: center">
                    <a class="btn-link">忘记密码？</a> &nbsp;
                    <button type="button" class="btn btn-warning" data-dismiss="modal" aria-label="Close">关&nbsp;&nbsp;闭</button>
                    <button type="button" class="btn btn-warning" onclick="loginByAccount()">登&nbsp;&nbsp;陆</button> &nbsp;&nbsp;
                </div>
            </form>
        </div>
        <!-- 用户名密码登陆 end -->
    </div>
</div>
<!-- 登录模态框 end  -->

<!-- 注册模态框 start -->
<div class="modal fade" id="registModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">会员注册</h4>
            </div>
            <form id="frmRegist" class="form-horizontal" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">用户姓名:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text" name="userName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">登陆账号:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text" name="loginName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">登录密码:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="password">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">联系电话:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text" name="phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">联系地址:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text" name="address">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" aria-label="Close">关&nbsp;&nbsp;闭</button>
                    <button type="reset" class="btn btn-warning">重&nbsp;&nbsp;置</button>
                    <button type="button" class="btn btn-warning" onclick="regist()">注&nbsp;&nbsp;册</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- 注册模态框 end -->