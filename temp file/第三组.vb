


Private Sub getCkFlag (devNumber As Long) As Boolean
'判断是否可以生成出库任务

	'判断设备是否封锁
	If ls_worksign = "0" Or ls_worksign = "2" Or ls_worksign = "4" Then
		getCkFlag = False
		'0（设备停用）、1（设备启用）、2（全部封锁）、3（入库/回流封锁）、4（出库封锁）
		wf_tracezl ls_ssjname, "输送机出库模式被封锁！"
		Exit Function
	End If

	Dim rs_xdtockss As ADODB.Recordset
	Set rs_xdtockss = New ADODB.Recordset
	On Error Resume Next
	On Error GoTo erro
			
	' Set rs_xdtockss = cn.Execute("select xdnumber, phyline, is_hl from xdtockss where xdnumber = '" & CLng(devNumber) & "'")
	Set rs_xdtockss = cn.Execute("select xdnumber, phyline, is_hl from xdtockss where xdnumber = " & CLng(devNumber))

	' 读取出库输送机是否有入库|回流作业
	If iopc_option.get_opcreadvalue(devNumber + 742) Then
		'如果写入成功
		If iopc_option.asyncWrite(1, devNumber + 742) Then  
			wf_tracezl availabledev_value, "下位输送机入库回流标志为True，不允许出库，下发退回标志成功！"
			wf_message devNumber, availabledev_value + "下位输送机入库回流标志为True，不允许出库，下发退回标志成功！"
		'如果写入失败
		Else 
			wf_tracezl availabledev_value, "下位输送机入库回流标志为True，不允许出库，下发退回标志失败！"
			wf_message devNumber, availabledev_value + "下位输送机入库回流标志为True，不允许出库，下发退回标志失败！"
		End If
		' GoTo line
		getCkFlag = False
	Else '没有任务
		If rs_xdtockss.RecordCount = 2 Then '查询 双排的
			getCkFlag = True
		ElseIf  rs_xdtockss.RecordCount = 1 Then '查询 单排的
			getCkFlag = True
		'ElseIf  rs_xdtockss.RecordCount = 0 Then '查询没有结果
			'getCkFlag = False
			'Exit Function
		End If
	End If

	'读取出库输送机是否空闲
	If wf_getcktask(devNumber, "CY") = False Then  
		If iopc_option.asyncWrite(1, devNumber + 793) Then
			wf_tracezl availabledev_value, "对应巷道有未完成的作业，不允许出库，下发退回标志成功！"
			wf_message devNumber, availabledev_value + "对应巷道有未完成的作业，不允许出库，下发退回标志成功！"
		Else
			wf_tracezl availabledev_value, "对应巷道有未完成的作业，不允许出库，下发退回标志失败！"
			wf_message devNumber, availabledev_value + "对应巷道有未完成的作业，不允许出库，下发退回标志失败！"
		End If
		' GoTo line
		getCkFlag = False
	Else
		If rs_xdtockss.RecordCount = 2 Then '查询 双排的
			getCkFlag = True
		ElseIf  rs_xdtockss.RecordCount = 1 Then '查询 单排的
			getCkFlag = True
		' ElseIf  rs_xdtockss.RecordCount = 0 Then '查询没有结果
			' getCkFlag = False
			' Exit Function
		End If
	End If

End Sub