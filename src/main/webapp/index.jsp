<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>员工列表</title>
<!-- Web路径：
不以/开头的相对路径，找资源以当前资源的项目路径为基准，经常容易出问题
以/开头的相对路径，找资源以服务器的路径为标准（http://localhost:8080），需要加上项目名
http://localhost:8080/ssm-crud -->
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<link
	href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script src="${APP_PATH}/static/jquery-3.4.1.js"></script>
<script
	src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>

<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">修改员工信息</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal">

					<div class="form-group">
						<label for="empName_update" class="col-sm-2 control-label">姓名</label>
						<div class="col-sm-8">
							<p class="form-control-static" id="empName_update_static"></p>
						</div>
					</div>

					<div class="form-group">
						<label for="gender" class="col-sm-2 control-label">性别</label>
						<div class="col-sm-8">
							<label class="radio-inline"> <input type="radio"
								name="gender" id="gender1_update" value="男" checked="checked">
								男
							</label> <label class="radio-inline"> <input type="radio"
								name="gender" id="gender2_update" value="女"> 女
							</label>
						</div>
					</div>

					<div class="form-group">
						<label for="email" class="col-sm-2 control-label">邮箱</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="email"
								id="email_update" placeholder="登录名@主机名.域名"> <span
								class="help-block"></span>
						</div>
					</div>

					<div class="form-group">
						<label for="email" class="col-sm-2 control-label">部门</label>
						<div class="col-sm-4">
							<!-- 							部门提交部门id即可 -->
							<select class="form-control" name="dId" id="dept_update_select"></select>
						</div>
					</div>

				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="emp_update_btn">修改</button>
			</div>
		</div>
	</div>
</div>
<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
				<h4 class="modal-title" id="myModalLabel">新增员工</h4>
			</div>
			<div class="modal-body">
				<form class="form-horizontal">

					<div class="form-group">
						<label for="empName_add" class="col-sm-2 control-label">姓名</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="empName"
								id="empName_add" placeholder="3-16位的英文或2-5位的中文"> <span
								class="help-block"></span>
						</div>
					</div>

					<div class="form-group">
						<label for="gender" class="col-sm-2 control-label">性别</label>
						<div class="col-sm-8">
							<label class="radio-inline"> <input type="radio"
								name="gender" id="gender1_add" value="男" checked="checked">
								男
							</label> <label class="radio-inline"> <input type="radio"
								name="gender" id="gender2_add" value="女"> 女
							</label>
						</div>
					</div>

					<div class="form-group">
						<label for="email" class="col-sm-2 control-label">邮箱</label>
						<div class="col-sm-8">
							<input type="text" class="form-control" name="email"
								id="email_add" placeholder="登录名@主机名.域名"> <span
								class="help-block"></span>
						</div>
					</div>

					<div class="form-group">
						<label for="email" class="col-sm-2 control-label">部门</label>
						<div class="col-sm-4">
							<!-- 							部门提交部门id即可 -->
							<select class="form-control" name="dId" id="dept_add_select"></select>
						</div>
					</div>

				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
				<button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
			</div>
		</div>
	</div>
</div>

<div class="container">
	<!-- 标题 -->
	<div class="row">
		<div class="col-md-12">
			<h1>SSM-CRUD</h1>
		</div>
	</div>
	<!-- 新增，删除按钮 -->
	<div class="row">
		<div class="col-md-4 col-md-offset-8">
			<button class="btn btn-primary" id="emp_add_modal_btn">新增员工</button>
			<button class="btn btn-danger" id="emp_delete_all_btn">删除所选员工</button>
		</div>
	</div>
	<!-- 表格数据 -->
	<div class="row">
		<div class="col-md-12">
			<table class="table table-hover" id="emps_table">
				<thead>
					<tr>
					<th><input type="checkbox" id="check_all"></th>
						<th>编号</th>
						<th>姓名</th>
						<th>性别</th>
						<th>邮箱</th>
						<th>部门</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
			</table>
		</div>
	</div>
	<!-- 分页信息 -->
	<div class="row">
		<!-- 分页文字信息 -->
		<div class="col-md-6" id="page_info"></div>
		<!-- 分页条信息 -->
		<div class="col-md-6" id="page_nav"></div>
	</div>
</div>
<script type="text/javascript">
	//数据总记录数,当前页码
	var totalRecord,currentPage;

	//页面加载完成后，直接发送Ajax请求，得到分页数据
	$(function() {
		to_page(1);
	})
	function to_page(pn) {
		$.ajax({
			url : "${APP_PATH}/emps",
			data : "pn=" + pn,
			type : "get",
			success : function(result) {
				//1.解析并显示员工数据
				build_emps_table(result);
				//2.解析并显示分页数据
				build_page_info(result);
				//3.解析并显示分页条数据
				build_page_nav(result);
			}
		});
	}
	//解析显示员工数据
	function build_emps_table(result) {
		$("#emps_table tbody").empty();
		var emps = result.extend.pageInfo.list;
		$.each(emps, function(index, item) {
			var checkBoxTd =$("<td><input type='checkbox' class='check_item'></td>");
			var empIdTd = $("<td></td>").append(item.empId);
			var empNameTd = $("<td></td>").append(item.empName);
			var genderTd = $("<td></td>").append(item.gender);
			var emailTd = $("<td></td>").append(item.email);
			var editBtn = $("<button></button>").addClass(
					"btn btn-primary btn-sm edit_btn").append(
					$("<span></span>").addClass("glyphicon glyphicon-pencil"))
					.append("编辑");
			var delBtn = $("<button></button>").addClass(
					"btn btn-danger btn-sm del_btn").append(
					$("<span></span>").addClass("glyphicon glyphicon-trash"))
					.append("删除");
			//为编辑、删除按钮添加一个自定义属性，记录当前员工id
			editBtn.attr("edit_id",item.empId);
			delBtn.attr("del_id",item.empId);
			
			var btnTd = $("<td></td>").append(editBtn).append(" ").append(
					delBtn);
			var deptNameTd = $("<td></td>").append(item.department.deptName);
			$("<tr></tr>").append(checkBoxTd).append(empIdTd).append(empNameTd).append(genderTd)
					.append(emailTd).append(deptNameTd).append(btnTd).appendTo(
							"#emps_table tbody");
		})
	}
	//解析显示分页信息
	function build_page_info(result) {
		$("#page_info").empty();
		$("#page_info").append(
				"第" + result.extend.pageInfo.pageNum + "页，共"
						+ result.extend.pageInfo.pages + "页，共"
						+ result.extend.pageInfo.total + "条数据");
		totalRecord = result.extend.pageInfo.total;
		currentPage = result.extend.pageInfo.pageNum;
	}
	//解析显示分页条
	function build_page_nav(result) {
		$("#page_nav").empty();
		var navEle = $("<nav></nav>");
		var ul = $("<ul></ul>").addClass("pagination");
		var firstPageLi = $("<li></li>").append(
				$("<a></a>").attr("href", "#").append("首页"));
		var prePageLi = $("<li></li>").append(
				$("<a></a>").attr("href", "#").append(
						$("<span></span>").append("&laquo;")));
		var nextPageLi = $("<li></li>").append(
				$("<a></a>").attr("href", "#").append(
						$("<span></span>").append("&raquo;")));
		var lastPageLi = $("<li></li>").append(
				$("<a></a>").attr("href", "#").append("末页"));
		if (!result.extend.pageInfo.hasPreviousPage) {
			firstPageLi.addClass("disabled");
			prePageLi.addClass("disabled");
		} else {
			//为元素添加点击翻页事件
			firstPageLi.click(function() {
				to_page(1);
			});
			prePageLi.click(function() {
				to_page(result.extend.pageInfo.pageNum - 1);
			});
		}
		if (!result.extend.pageInfo.hasNextPage) {
			lastPageLi.addClass("disabled");
			nextPageLi.addClass("disabled");
		} else {
			nextPageLi.click(function() {
				to_page(result.extend.pageInfo.pageNum + 1);
			});
			lastPageLi.click(function() {
				to_page(result.extend.pageInfo.pages);
			});
		}
		ul.append(firstPageLi).append(prePageLi);
		$.each(result.extend.pageInfo.navigatepageNums, function(index, item) {
			var pageNumLi = $("<li></li>").append(
					$("<a></a>").attr("href", "#").append(item));
			if (result.extend.pageInfo.pageNum == item)
				pageNumLi.addClass("active");
			pageNumLi.click(function() {
				to_page(item);
			});
			ul.append(pageNumLi);
		})
		ul.append(nextPageLi).append(lastPageLi);
		navEle.append(ul).appendTo("#page_nav");
	}
	
	//清空表单样式及内容
	function reset_form(ele){
		$(ele)[0].reset();
		$(ele).find("*").removeClass("has-success has-error");
		$(ele).find(".help-block").text("");
	}

	//点击新增按钮弹出模态框
	$("#emp_add_modal_btn").click(function() {
		//表单重置,包括数据和样式
		reset_form("#empAddModal form");
		//发送Ajax请求，查出部门信息并显示在下拉列表中
		getDepts("#empAddModal select");
		//弹出模态框
		$("#empAddModal").modal({
			backdrop : "static"
		});
	});

	function getDepts(ele) {
		$(ele).empty();
		$.ajax({
			url : "${APP_PATH}/depts",
			type : "GET",
			success : function(result) {
				//在下拉列表中显示部门信息
				$.each(result.extend.depts, function() {
					var optionEle = $("<option></option>")
							.append(this.deptName).attr("value", this.deptId);
					optionEle.appendTo(ele);
				});
			}
		});
	}

	//校验表单数据
	function validate_add_form() {
		//拿到要校验的数据，使用正则表达式
		var empName = $("#empName_add").val();
		//名字为3-16位的英文或2-5位的中文
		var regName = /(^[a-zA-Z]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
		if (regName.test(empName)) {

			show_validate_msg("#empName_add", "success", "");

		} else {
			//alert("名字应为3-16位的英文或2-5位的中文");
			show_validate_msg("#empName_add", "error", "名字应为3-16位的英文或2-5位的中文");
			return false;
		}

		//校验邮箱信息
		var email = $("#email_add").val();
		var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
		if (regEmail.test(email)) {
			show_validate_msg("#email_add", "success", "");
		} else {
			//alert("邮箱格式不正确");
			show_validate_msg("#email_add", "error", "邮箱格式不正确");
			return false;
		}
	}

	//显示校验结果的提示信息
	function show_validate_msg(ele, status, msg) {
		//清除当前元素的校验状态
		$(ele).parent().removeClass("has-error has-success");
		$(ele).next("span").text("");
		if (status == "error") {
			$(ele).parent().addClass("has-error");
			$(ele).next("span").text(msg);
		} else if (status == "success") {
			$(ele).parent().addClass("has-success");
			$(ele).next("span").text(msg);
		}
	}

	//检验用户名（姓名）是否可用（假设不能重复）
	$("#empName_add").change(function(){
		var empName=this.value;
		//发送Ajax请求校验用户名是否可用
		$.ajax({
			url:"${APP_PATH}/checkuser",
			data:"empName="+empName,
			type:"POST",
			success:function(result){
				if(result.code==100){
					show_validate_msg("#empName_add", "success", "");
					$("#emp_save_btn").attr("ajax_validate","success");
				}else{
					show_validate_msg("#empName_add", "error",result.extend.validate_msg);
					$("#emp_save_btn").attr("ajax_validate","error");
				}
			}
		});
	});
	
	//点击保存，保存员工
	$("#emp_save_btn").click(function() {
		//模态框中填写的表单数据提交给服务器进行保存
		//判断之前的Ajax校验是否成功
	 	if($(this).attr("ajax_validate")=="error"){
			return false;
		}
		//对要提交给服务器的数据进行校验
		if (validate_add_form()==false) {
			return false;
		} 
		//发送Ajax请求保存员工
		$.ajax({
			url : "${APP_PATH}/emps",
			type : "POST",
			data : $("#empAddModal form").serialize(),
			success : function(result) {
				if(result.code==100){					
				//员工数据保存成功
				//1.关闭模态框
				$("#empAddModal").modal("hide");
				//2.发送Ajax请求来到最后一页，显示刚才保存的数据
				to_page(totalRecord);
				}else{
					//显示失败信息
					if(undefined!=result.extend.errorFields.empName){
						//显示名字错误信息
						show_validate_msg("#empName_add", "error",result.extend.errorFields.empName);
					}
					if(undefined!=result.extend.errorFields.email){
						//显示邮箱错误信息
						show_validate_msg("#email_add", "error", result.extend.errorFields.email);
					}
				}
			}
		});
	});
	
	//按钮创建之前就绑定click,所以绑定不上
	//1.可以在创建按钮的时候绑定 2.绑定点击.live() jQuery新版本没有live,使用on
	$(document).on("click",".edit_btn",function(){
	//查出部门信息并显示
	getDepts("#empUpdateModal select");
	//查出员工信息并显示
	getEmp($(this).attr("edit_id"));
	//把员工id传递给模态框的更新按钮
	$("#emp_update_btn").attr("edit_id",$(this).attr("edit_id"));
	//弹出模态框
		$("#empUpdateModal").modal({
			backdrop : "static"
		});
	});
	
	$(document).on("click",".del_btn",function(){
		//1.弹出确认删除的对话框
		var empName = $(this).parents("tr").find("td:eq(2)").text();
		var empId = $(this).attr("del_id");
		if(confirm("确定删除【"+empName+"】吗？")){
			//确认后发送Ajax请求删除该员工信息
			$.ajax({
				url:"${APP_PATH}/emp/"+empId,
				type:"DELETE",
				success:function(result){
					to_page(currentPage);
				}
			});
		}
	});
	
	function getEmp(id){
		$.ajax({
			url:"${APP_PATH}/emp/"+id,
			type:"GET",
			success:function(result){
				var emp = result.extend.emp;
				$("#empName_update_static").text(emp.empName);
				$("#email_update").val(emp.email);
				$("#empUpdateModal input[name=gender]").val([emp.gender]);
				$("#dept_update_select").val([emp.dId]);
			}
		});
	}
	
	$("#emp_update_btn").click(function(){
		//验证邮箱是否合法
		//校验邮箱信息
		var email = $("#email_update").val();
		var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
		if (regEmail.test(email)) {
			show_validate_msg("#email_update", "success", "");
		} else {
			//alert("邮箱格式不正确");
			show_validate_msg("#email_update", "error", "邮箱格式不正确");
			return false;
		}
		//发送Ajax请求，保存员工数据
		$.ajax({
			url:"${APP_PATH}/emp/"+$(this).attr("edit_id"),
			type:"PUT",
			data:$("#empUpdateModal form").serialize(),
			success:function(result){
				//1.关闭模态框
				$("#empUpdateModal").modal("hide");
				//回到本页面
				to_page(currentPage);
			}
		});
		
	});
	
	//完成全选/全不选功能
	$("#check_all").click(function(){
		//attr获取checked是undefined
		//d推荐用prop修改和读取dom原生属性的 值，自定义属性的值用attr
		$(".check_item").prop("checked",$(this).prop("checked"));
	});
	
	//check_item
	$(document).on("click",".check_item",function(){
		//判断当前的元素是否全部被选中
		var flag = $(".check_item:checked").length==$(".check_item").length;
		$("#check_all").prop("checked",flag);
	});
	
	//点击【删除所选员工】按钮，进行批量删除
	$("#emp_delete_all_btn").click(function(){
		var empNames="";
		var del_ids_str="";
		$.each($(".check_item:checked"),function(){
			//组装员工名字字符串
			empNames += $(this).parents("tr").find("td:eq(2)").text()+",";
			//组装员工id字符串
			del_ids_str+= $(this).parents("tr").find("td:eq(1)").text()+"-";
		});
		//去除empNames多余的“，”
		empNames = empNames.substring(0,empNames.length-1);
		//去除del_ids_str多余的“-”
		del_ids_str = del_ids_str.substring(0,del_ids_str.length-1);
		if(confirm("确定删除【"+empNames+"】吗？")){
			$.ajax({
				url:"${APP_PATH}/emp/"+del_ids_str,
				type:"DELETE",
				success:function(result){
					alert(result.msg);
					//回到当前页面
					to_page(currentPage);
				}
			});
		}
	});
</script>
</body>
</html>