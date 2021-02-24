 <%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<meta charset="UTF-8">

<link href="../../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="../../jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="../../jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="../../jquery/bs_pagination/en.js"></script>


	<script type="text/javascript">

	$(function(){
		//为按钮绑定事件，打开添加操作的模态窗口
		$("#addBtn").click(function () {
			/*
			* 操作模态窗口的方式
			* 需要操作模态窗口的jQuery对象，调用model方法，为该方法传递参数。show打开窗口，hide隐藏窗口
			* */


			$.ajax({
				url:"${pageContext.request.contextPath}/active/activeUsers",
				type:"get",
				dataType:"json",
				success:function (data) {
					//data里面存的应该是全部的用户信息,是一个数组形式，所以需要遍历
					//n为遍历出来的user对象
					var user;
					$.each(data,function (i,n) {
						user+="<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#create-marketActivityOwner").html(user)

				}
			})
			var id="${user.id}";

			$("#create-marketActivityOwner").val(id);
			$("#createActivityModal").modal("show");

		})

        // 条件日历组件
        $(".time").datetimepicker({
            minView: "month",		// 设置只显示到月份
            language:  'zh-CN',
            format: 'yyyy-mm-dd', 	// 显示格式
            autoclose: true,		// 选中自动关闭
            todayBtn: true,			// 显示今日按钮
            pickerPosition: "bottom-left"
        });

		// 默认展开列表的第一页,每页展现两条记录
		pageList(1,2);

		// 为查询按钮绑定事件,触发pageList方法
		$("#searchBtn").click(function(){
			/**
			 * 点击查询按钮的时候,我们应该将搜索框中的信息保存起来,保存到隐藏域中
			 */

			$("#hidden-name").val($.trim($("#search-name").val()))
			$("#hidden-owner").val($.trim($("#search-owner").val()))
			$("#hidden-startDate").val($.trim($("#search-startTime").val()))
			$("#hidden-endDate").val($.trim($("#search-endTime").val()))

			pageList(1,2);

		});


		//为打开的模态窗口的保存按钮绑定保存操作
		$("#saveBtn").click(addActivity)

		//添加全选功能
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})
		$("#activityBody").on("click",$("input[name=xz]"),function () {
			//$("#qx").prop("checked",$("input[name=xz]").length == $("intput[name=xz]:checked").length);
			$("#qx").prop("checked",$(":checkbox[name='xz']").length == $(":checkbox[name='xz']:checked").length);
		});

		//删除市场活动
		$("#deleteBtn").click(delActivity);
		//修改市场活动
		$("#editBtn").click(editActivity);
		//更新市场活动
		$("#updateBtn").click(updateActivity);
		
	});


	//添加市场活动
	function addActivity() {

		$.ajax({
			url:"${pageContext.request.contextPath}/active/activeAdd",
			data:{

				"owner":$.trim($("#create-marketActivityOwner").val()),
				"name":$.trim($("#create-marketActivityName").val()),
				"startDate":$.trim($("#create-startTime").val()),
				"endDate":$.trim($("#create-endTime").val()),
				"cost":$.trim($("#create-cost").val()),
				"description":$.trim($("#create-describe").val())

			},
			type:"post",
			dataType: "json",
			success:function (data) {
				if(data){
					$("#activityAddForm")[0].reset();
					$("#createActivityModal").modal("hide");
				}else{
					alert("添加失败");
				}




			}
		})

	}
	//删除市场活动
	function delActivity() {
		//找到复选框中选中的jquery对象
		var $xz = $(":checkbox[name='xz']:checked");
		if($xz.length==0){
			alert("请选择要删除的对象");
		}else{//拼接参数
			if(confirm("确定删除所选中的记录吗?")){
				var parm="";
				//将$xz中每一个dom对象遍历出来，取其value值，就相当于获得了对应的id
				for(var i=0;i<$xz.length;i++){
					parm+="id="+$($xz[i]).val();
					//如果不是最后一个元素
					if(i<$xz.length-1){
						parm+="&";
					}
				}

				$.ajax({
					url:"${pageContext.request.contextPath}/active/activeDel",
					type:"post",
					data:parm,
					dataType:"json",
					success:function (data) {
						//这里需要传回来的数据未true或者false来进行判断删除是否成功
						if(data){
							// 删除成功后
							// 回到第一页,维持每页展现的记录数
							// pageList(1,2);
							pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						}else{
							alert("删除市场活动失败");
						}
					}
				});
			}



		}

	}
	//修改市场活动
	function editActivity() {
		//找到复选框中选中的jquery对象
		var $xz = $(":checkbox[name='xz']:checked");
		if($xz.length==0){
			alert("请选择要修改的对象");
		}
		if($xz.length>1){
			alert("请选择一个市场活动");
		}
		if($xz.length==1){
			var id = $xz.val();
			$.ajax({
				url:"${pageContext.request.contextPath}/active/activeEdit",
				type:"get",
				data:{"id":id},
				dataType:"json",
				success:function (data) {
					// 处理所有者下拉框
					var html = "<option></option>";

					$.each(data.uList,function(i,n){
						html += "<option value='"+n.id+"'>"+n.name+"</option>";
					})
					$("#edit-owner").html(html);

					// 处理单条activity
					$("#edit-id").val(data.a.id);
					$("#edit-name").val(data.a.name);
					$("#edit-owner").val(data.a.owner);
					$("#edit-endDate").val(data.a.endDate);
					$("#edit-cost").val(data.a.cost);
					$("#edit-startDate").val(data.a.startDate);
					$("#edit-description").val(data.a.description);

					// 所有的值都填写好之后,打开修改操作的模态窗口
					$("#editActivityModal").modal("show");
				}
			})
		}

	}
	//更新市场活动
    function  updateActivity() {
        $.ajax({
            url:"${pageContext.request.contextPath}/active/ativeUpdate",
            data:{

                "id":$.trim($("#edit-id").val()),
                "owner":$.trim($("#edit-owner").val()),
                "name":$.trim($("#edit-name").val()),
                "startDate":$.trim($("#edit-startDate").val()),
                "endDate":$.trim($("#edit-endDate").val()),
                "cost":$.trim($("#edit-cost").val()),
                "description":$.trim($("#edit-description").val())

            },
            type:"post",
            dataType: "json",
            success:function (data) {
                if(data){

                    pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
                        ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));

                    $("#editActivityModal").modal("hide");
                }else{
                    alert("更新失败");
                }




            }
        })
    }

	//分页查询
    function pageList(pageNo,pageSize) {
		//将全选框去取消
		$("#qx").prop("checked",false);

		//查询前将隐藏域中的值取出来放到搜索框中，
		$("#search-name").val($.trim($("#hidden-name").val()))
		$("#search-owner").val($.trim($("#hidden-owner").val()))
		$("#search-startTime").val($.trim($("#hidden-startDate").val()))
		$("#search-endTime").val($.trim($("#hidden-endDate").val()))



		$.ajax({
			url:"${pageContext.request.contextPath}/active/activitySearch",
			type:"get",
			data:{
				"pageNo":pageNo,
				"pageSize":pageSize,

				//动态整合搜索框内容，进行查询显示
				"name":$.trim($("#search-name").val()),
				"owner":$.trim($("#search-owner").val()),
				"startTime":$.trim($("#search-startTime").val()),
				"endTime":$.trim($("#search-endTime").val()),
			},
			dataType:"json",
			success:function (data) {
			/*
			* 需要传回来的数据格式
			*{"total":?,"dataList":[{市场活动1},{2},{3}...]}
			* */
				var html = "";

				// 每一个n就是每一个市场活动对象
				$.each(data.dataList,function(i,n){

					html += '<tr class="active">';
					html += '<td><input type="checkbox" name="xz" value='+n.id+' /></td>';
							html += '<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'/SSM_CRM_war_exploded/active/activeDetail?id='+n.id+'\';">'+n.name+'</a></td>';
					html += '<td>'+n.owner+'</td>';
					html += '<td>'+n.startDate+'</td>';
					html += '<td>'+n.endDate+'</td>';
					html += '</tr>';

				})

				$("#activityBody").html(html);
				// 计算总页数
				var totalPages = data.total % pageSize == 0 ? data.total / pageSize : parseInt(data.total / pageSize)+1;

				// 数据处理完毕后,结合分页查询,对前端展现分页信息
				$("#activityPage").bs_pagination({
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
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});

			}
        });

    }


	
</script>
</head>
<body>

<input type="hidden" id="hidden-name" />
<input type="hidden" id="hidden-owner" />
<input type="hidden" id="hidden-startDate" />
<input type="hidden" id="hidden-endDate" />


	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" id="activityAddForm" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-marketActivityOwner">

								</select>
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>
						
						<div class="form-group">
							<label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startTime" readonly>
							</div>
							<label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endTime" readonly>
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id" />

						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" >
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate" readonly>
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate" readonly>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
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
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startTime" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endTime">
				    </div>
				  </div>
				  
				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
					<%--
						data-toggle="modal" :表示触发该按钮会打开一个模态窗口
						data-target="#createActivityModal"：表示要打开哪个模态窗口，通过#id的方式找到该窗口
						这样写的话，无法在此基础上进行扩充功能
						所以以后的触发模态窗口要用js代码来完成
					--%>
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id ="qx" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityBody">
					</tbody>
				</table>
			</div>

				<div style="height: 50px; position: relative;top: 30px;">
					<div id="activityPage"></div>


				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>