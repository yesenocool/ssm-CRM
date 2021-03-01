<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		// 条件日历组件
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});


		pagelist(1,3)
		// 来为创建窗口添加事件
		$("#addBtn").click(addBtn);
		//保存线索按钮
		$("#saveBtn").click(saveBtn);
		//绑定修改按钮
		$("#editBtn").click(editClue);
		$("#search-button").click(searchButton);
		
	});

	//为查询按钮绑定事件
	function searchButton() {
		$("#hidden-fullname").val($.trim($("#search-fullname").val()));
		$("#hidden-company").val($.trim($("#search-company").val()));
		$("#hidden-phone").val($.trim($("#search-phone").val()));
		$("#hidden-source").val($.trim($("#search-source").val()));
		$("#hidden-owner").val($.trim($("#search-owner").val()));
		$("#hidden-mphone").val($.trim($("#search-mphone").val()));
		$("#hidden-state").val($.trim($("#search-state").val()));

		pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
	}

	//修改选定的线索信息
	function editClue() {
		//找到复选框中选中的id
		var $id = $(":checked[name='xz']:checked");
		if($id.length==0){
			alert("请选中一条线索");
		};
		if($id.length>1){
			alert("请最多选中一条线索");
		};
		if($id.length==1){
			var id= $id.val();

			$.ajax({
				url:"${pageContext.request.contextPath}/clue/getClueById",
				data:{
					"id":id,
				},
				dataType:"json",
				type:"get",
				success:function (data) {
					/*
					处理拥有者的下拉列
					 */
					var html ="<option></option>";
					$.each(data.uList,function (i,n) {
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					});
					$("#edit-clueOwner").html(html);

					/*
					填写如其他信息
					 */
					$("#edit-company").val(data.clue.company);
					$("#edit-surname").val(data.clue.fullname);
					$("#edit-job").val(data.clue.job);
					$("#edit-email").val(data.clue.email);
					$("#edit-phone").val(data.clue.phone);
					$("#edit-website").val(data.clue.website);
					$("#edit-mphone").val(data.clue.mphone);
					$("#edit-describe").val(data.clue.description);
					$("#edit-contactSummary").val(data.clue.contactSummary);
					$("#edit-nextContactTime").val(data.clue.nextContactTime);
					$("#edit-address").val(data.clue.address);

					//设置下拉框的默认值
					$("#edit-clueOwner").val(data.clue.owner);
					$("#edit-source").val(data.clue.source);
					$("#edit-status").val(data.clue.state);
					$("#edit-call").val(data.clue.appellation);


					// 最后将修改操作的隐藏域展示出来
					$("#editClueModal").modal("show");
				}

			});
		}


	}

	//绑定更新按钮
	function updateBtn() {
		$.ajax({
			url:"workbench/clue/updateClue",
			type:"post",
			data:{
				"id":$(".xz:checked").val(),
				"company" : $("#edit-company").val(),
				"fullname" : $("#edit-surname").val(),
				"job" : $("#edit-job").val(),
				"email" : $("#edit-email").val(),
				"phone" : $("#edit-phone").val(),
				"website" : $("#edit-website").val(),
				"mphone" : $("#edit-mphone").val(),
				"description" : $("#edit-describe").val(),
				"contactSummary" : $("#edit-contactSummary").val(),
				"nextContactTime" : $("#edit-nextContactTime").val(),
				"address" : $("#edit-address").val(),
				"owner" : $("#edit-clueOwner").val(),
				"source": $("#edit-source").val(),
				"state" : $("#edit-status").val(),
				"appellation" : $("#edit-call").val()
			},
			dataType:"json",
			success:function(data){
				if(data){
					// 更新列表
					pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));

					// 关闭修改线索的模态窗口
					$("#editClueModal").modal("hide");

				}else{
					alert("更新失败!");
				}
			}
		})
	}

	//显示所有线索
	function selectClue() {
		$.ajax({
			url:"${pageContext.request.contextPath}/clue/selectAllClue",
			type:"get",
			dataType:"json",
			success:function (data) {
				//返回格式  {}
				var html="";
				$.each(data,function (i,n) {
					html+='<tr>';
					html+='<td><input type="checkbox" /></td>';
					html+='<td><a style="text-decoration: none; cursor: pointer;" href="\'/SSM_CRM_war_exploded/clue/showDetail?id=' + n.id + '">' + n.fullname + n.appellation + '</a></td>';
					html+='<td>动力节点</td>';
					html+='<td>010-84846003</td>';
					html+='<td>12345678901</td>';
					html+='<td>广告</td>';
					html+='<td>zhangsan</td>';
					html+='<td>已联系</td>';
					html+='</tr>';
				});
			}
		})
	}

	//创建按钮事件
	function addBtn() {
		$.ajax({
			url:"${pageContext.request.contextPath}/clue/getUserList",
			dataType:"json",
			type:"psot",
			success:function (data) {


				var html="<option></option>";
				$.each(data,function (i,n) {
					html+="<option value='"+n.id+"'>"+n.name+"</option>"
				});
				$("#create-clueOwner").html(html);

				var id = "${user.id}";
				$("#create-clueOwner").val(id);
				// 处理完所有下拉框列表数据后，打开模态窗口

				$("#createClueModal").modal("show");
			}
		})
	}
	//模块中的保存按钮事件
	function saveBtn() {
		$.ajax({
			url:"${pageContext.request.contextPath}/clue/saveBtn",
			data:{
				"fullname":$.trim($("#create-surname").val()),
				"appellation":$.trim($("#create-appellation").val()),
				"owner":$.trim($("#create-clueOwner").val()),
				"company":$.trim($("#create-company").val()),
				"job":$.trim($("#create-job").val()),
				"email":$.trim($("#create-email").val()),
				"phone":$.trim($("#create-phone").val()),
				"website":$.trim($("#create-website").val()),
				"mphone":$.trim($("#create-mphone").val()),
				"state":$.trim($("#create-status").val()),
				"source":$.trim($("#create-source").val()),
				"description":$.trim($("#create-describe").val()),
				"contactSummary":$.trim($("#create-contactSummary").val()),
				"nextContactTime":$.trim($("#create-nextContactTime").val()),
				"address":$.trim($("#create-address").val())

			},
			dataType:"json",
			type:"post",
			success:function (data) {
				if(data){
					//刷新页面

					//关闭模态
					// 关闭模态窗口
					$("#createClueModal").modal("hide");
				}else{
					alert("添加线索失败");
				}

			}

		})
		pagelist(1,5);
	}

	//分页查询事件
	function  pagelist(pageNo,pageSize) {
		// 将全选框的对勾取消
		$("#qx").prop("checked",false);

		// 将隐藏域中的值赋值给查询框,防止更换页数时,查询条件为空
		$("#search-fullname").val($.trim($("#hidden-fullname").val()));
		$("#search-company").val($.trim($("#hidden-company").val()));
		$("#search-phone").val($.trim($("#hidden-phone").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-mphone").val($.trim($("#hidden-mphone").val()));
		$("#search-state").val($.trim($("#hidden-state").val()));
		$.ajax({
			url:"${pageContext.request.contextPath}/clue/clueSearch",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,
				"fullname" : $.trim($("#search-fullname").val()),
				"company" : $.trim($("#search-company").val()),
				"phone" : $.trim($("#search-phone").val()),
				"source" : $.trim($("#search-source").val()),
				"owner" : $.trim($("#search-owner").val()),
				"mphone" : $.trim($("#search-mphone").val()),
				"state" : $.trim($("#search-state").val())
			},
			dataType:"json",
			type:"get",
			success:function (data) {
				var html="";
				$.each(data.cList,function (i,n) {
				html+='<tr>';
				html+='	<td><input type="checkbox" name="xz" value='+n.id+' /></td>';
	  		    html+=' <td><a style="text-decoration: none; cursor: pointer;"  onclick="window.location.href=\'/SSM_CRM_war_exploded/clue/clueDetail?id='+n.id+'\';">'+ n.fullname + n.appellation +'</a></td>';
				html+='	<td>'+n.company+'</td>';
				html+='	<td>'+ n.phone+'</td>';
				html+='	<td>'+n.mphone+'</td>';
				html+='	<td>'+n.source+'</td>';
				html+='	<td>'+n.owner+'</td>';
				html+='	<td>'+n.state+'</td>';
				html+='	</tr>';
				});
				$("#clueActivety").html(html);

				// 计算总页数
				var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize) + 1;

				// 数据处理完毕后,结合分页查询,对前端展现分页信息
				$("#cluePage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					// 该回调函数是在点击分页组件的时候触发的
					onChangePage: function (event, data) {
						pageList(data.currentPage, data.rowsPerPage);
					}
				});
			}

		})
	}
	
</script>
</head>
<body>

<%--隐藏域,存放临时数据的--%>
<input type="hidden" id="hidden-fullname" />
<input type="hidden" id="hidden-company" />
<input type="hidden" id="hidden-phone" />
<input type="hidden" id="hidden-source" />
<input type="hidden" id="hidden-owner" />
<input type="hidden" id="hidden-mphone" />
<input type="hidden" id="hidden-state" />

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${applicationScope.appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
								  <option></option>
								  <c:forEach items="${applicationScope.clueState}" var="b">
									  <option value="${b.value}">${b.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach var="c" items="${applicationScope.source}">
									  <option value="${c.value}">${c.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
									<c:forEach items="${applicationScope.appellation}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" >
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" >
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" >
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" >
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
									<c:forEach items="${applicationScope.clueState}" var="c">
										<option  value="c.value">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${applicationScope.source}" var="c">
										<option value="${c.value}" >${c.text}</option>
									</c:forEach>

								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="search-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control">
					  	  <option></option>
						  <c:forEach items="${applicationScope.source}" var="c">
							  <option value="${c.value}" id="search-source">${c.text}</option>
						  </c:forEach>

					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="search-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control">
					  	<option></option>
					  	<c:forEach items="${applicationScope.clueState}" var="c">
							<option id="search-state" value="c.value">${c.text}</option>
						</c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="submit" class="btn btn-default" id="search-button">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox"  name="qx"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueActivety">

					</tbody>
				</table>
			</div>
			
	<%--		<div style="height: 50px; position: relative;top: 60px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>