Imports TDAPIOLELib
Imports TDAPIOLELib.TDAPI_REQMODE

Public Class Main
    Private tdc As TDConnection = Nothing
    Private Sub ResizeView(ByVal view As DataGridView)
        For i = 0 To view.ColumnCount - 1
            view.AutoResizeColumn(i)
        Next
    End Sub
    Private Sub SetupDGView()
        With DGView
            .ColumnCount = 2
            .Columns(0).Name = "Req Id"
            .Columns(0).DefaultCellStyle.Font = _
                New Font(Me.DGView.DefaultCellStyle.Font, FontStyle.Italic)
            .Columns(1).Name = "Name"
        End With
    End Sub
    Private Sub SetupDGViewForCr()
        With DGView
            .ColumnCount = 7
            .Columns(0).Name = "CR ID"
            .Columns(1).Name = "Project"
            .Columns(2).Name = "Detected By"
            .Columns(3).Name = "Assigned To"
            .Columns(4).Name = "Status"
            .Columns(5).Name = "Summary"
            .Columns(6).Name = "Priority"
        End With
    End Sub
    Private Sub ErrHandler(ByVal err As ErrObject, ByVal msg As String)
        MsgBox("Error caught:  " & msg & err.Description)
    End Sub
    Private Function GetReqByPath(ByVal tdc As TDConnection, ByVal fullPath$, _
    Optional ByVal delimChar As String = "\") _
        As Req
        ' This function returns a Req object specified by its 
        ' full path. 
        ' For example: 
        ' Set r = GetReqByPath("SCRATCH\OTA_REQ_DEMO\OTA_S_O_1") 
        ' will return the OTA_S_O_1 object. 
        ' A requirement name is not unique in the project, but it is 
        ' unique as a direct child of another requirement. 
        ' Therefore, these routine works by walking down the 
        ' requirement tree along the fullPath until the requirement 
        ' is found at the end of the path. 
        ' If a backslash is not used as the folder delimiter, any other
        ' character can be passed in the delimChar argurment. 


        Dim rFact As ReqFactory
        Dim theReq As Req, ParentReq As Req
        Dim reqList As List
        Dim NodeArray() As String, PathArray() As String
        Dim WorkingDepth As Integer

        ParentReq = Nothing
        On Error GoTo GetReqByPathErr

        SetupDGView()

        'Trim the fullPath and strip leading and trailing delimiters 
        fullPath = Trim(fullPath)
        Dim pos%, ln%
        pos = InStr(1, fullPath, delimChar)
        If pos = 1 Then
            fullPath = Mid(fullPath, 2)
        End If

        ln = Len(fullPath)
        pos = InStr(ln - 1, fullPath, delimChar)
        If pos > 0 Then
            fullPath = Mid(fullPath, 1, ln - 1)
        End If
        ' Get an array of requirements, and the length 
        ' of the path 

        NodeArray = Split(fullPath, delimChar)
        WorkingDepth = LBound(NodeArray)

        ' Walk down the tree 
        'tdc is the global TDConnection object. 

        rFact = tdc.ReqFactory
        For WorkingDepth = LBound(NodeArray) To UBound(NodeArray)
            'First time, find under the root (-1) 
            'After that, under the previous requirement found: ParentReq.ID 

            If WorkingDepth = LBound(NodeArray) Then
                reqList = rFact.Find(-1, "RQ_REQ_NAME", _
                        NodeArray(WorkingDepth), TDREQMODE_FIND_EXACT)
            Else
                reqList = rFact.Find(ParentReq.ID, "RQ_REQ_NAME", _
                        NodeArray(WorkingDepth), TDREQMODE_FIND_EXACT)
            End If

            ' Delete parent. Each loop has to find it again. 

            ParentReq = Nothing
            Dim strItem, reqID&, strID$, thePath$
            For Each strItem In reqList
                ' The List returned from ReqFactory.Find is a List 
                ' of strings of format ID,Name. 
                ' For example "9,Products/Services On Sale" 
                ' Extract the ID from the string by splitting the 
                ' string at the comma. 
                pos = InStr(strItem, ",")
                strID = Mid(strItem, 1, pos - 1)
                ' Convert the ID to a long, and get the object 
                reqID = CLng(strID)
                theReq = rFact.Item(reqID)
                'Now check that the object is at the correct depth. 
                'If so, we've found the requirement. On the next loop, 
                'we'll look from here down. 
                thePath = theReq.Path
                PathArray = Split(thePath, "\")
                ' Debug.Print "Number of elements is " & UBound(PathArray) 
                ' Debug.Print theReq.ID, theReq.Name 
                If UBound(PathArray) = WorkingDepth Then
                    ParentReq = theReq
                    Exit For
                End If

            Next strItem
            If ParentReq Is Nothing Then Exit For
        Next WorkingDepth
        If ParentReq IsNot Nothing Then
            Dim children As List
            children = rFact.GetChildrenList(CLng(ParentReq.ID))
            Debug.Print("Number of requirements: " & children.Count)
            'ListBox.BeginUpdate()
            DGView.Rows.Clear()
            For Each c In children
                Dim creq As Req
                creq = c
                Debug.Print(creq.ID & ":  " & creq.Name)
                'ListBox.Items.Add(creq.ID & ":  " & creq.Name)
                Dim row As String() = {creq.ID, creq.Name}
                Me.DGView.Rows.Add(row)
            Next
            For i = 0 To DGView.ColumnCount - 1
                DGView.AutoResizeColumn(i)
            Next
            'ListBox.EndUpdate()

        End If
        GetReqByPath = ParentReq
        Exit Function

GetReqByPathErr:
        ErrHandler(Err, "GetReqByPath")
        GetReqByPath = Nothing
    End Function

    Private Function makeConnection(ByVal qcHostName$, ByVal qcDomain$, ByVal qcProject$, _
        ByVal qcUser$, ByVal qcPassword$) As TDConnection
        '------------------------------------------------------------------------ 
        ' This routine makes the connection to the gobal TDConnection object, 
        ' declared at the project level as Global tdc as TDConnection, 
        ' and connects the user to the specified project. 
        '----------------------------------------------------------------------- 

        Dim qcServer As String
        Dim errmsg As String
        Dim SUCCESS As Integer
        Dim FAILURE As Integer
        SUCCESS = 1
        FAILURE = 0

        tdc = Nothing
        Const fName = "makeConnection" 'For error message 
        On Error GoTo makeConnectionErr
        errmsg = ""

        'Construct server argument of format "http://server:port/qcbin" 

        qcServer = "http://" & qcHostName
        qcServer = qcServer & "/qcbin"
        ''Check status (For illustrative purposes.) 
        'MsgBox(tdc.LoggedIn) 'Error: OTA Server is not connected 
        'MsgBox(tdc.Connected) 'False 
        'MsgBox(tdc.ServerName) 'Blank string 

        'Create the connection 

        errmsg = "Failed to create TDConnection"
        If (tdc Is Nothing) Then tdc = New TDConnection
        If (tdc Is Nothing) Then GoTo makeConnectionErr
        errmsg = ""
        tdc.InitConnectionEx(qcServer)

        'Log on to server 

        tdc.Login(qcUser, qcPassword)
        tdc.Connect(qcDomain, qcProject)

        makeConnection = tdc
        Debug.Print("*****QC*****:  Successful connection")
        'tdc.Logout()
        Exit Function

makeConnectionErr:

        'ErrHandler(Err, fName, Err.Description & vbCrLf & errmsg)
        MsgBox("Error making connection to Quality Center:  " & Err.Description & vbCrLf & errmsg)
        makeConnection = Nothing

    End Function


    Private Sub Connect_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ConnectButton.Click
        If tdc Is Nothing Then
            ConnectButton.Enabled = False
            LoginForm.ShowDialog()
            If sandboxCheckbox.Checked = True Then
                makeConnection("qc.atlanta.hp.com", "DEFAULT", "QualityCenter_Sandbox", LoginForm.UsernameTextBox.Text, LoginForm.PasswordTextBox.Text)
            Else
                makeConnection("qc.atlanta.hp.com", "IPG_SIRIUS", "SIRIUS_FW", LoginForm.UsernameTextBox.Text, LoginForm.PasswordTextBox.Text)
            End If
            DisconnectButton.Enabled = True
            sandboxCheckbox.Enabled = False
        Else
            MsgBox("Already Connected to QC")
            ConnectButton.Enabled = True
        End If
    End Sub

    Private Sub GetReq_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles GetReqButton.Click
        If tdc IsNot Nothing Then
            Dim path As String
            If sandboxCheckbox.Checked = True Then
                path = "Requirements\EricR\Proj1\Requirements"
            Else
                path = "Requirements\Platforms\Ampere\Requirements"
            End If
            Dim rq As Req
            'ListBox.Items.Clear()
            GetReqButton.Enabled = False
            rq = GetReqByPath(tdc, path)
            GetReqButton.Enabled = True
            'MsgBox("ID: " & rq.ID & "  Name = " & rq.Name)
        Else
            MsgBox("You need to connect to Quality Center first.")
        End If

    End Sub

    Private Sub DisconnectButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DisconnectButton.Click
        If tdc IsNot Nothing Then
            tdc.Logout()
            DisconnectButton.Enabled = False
            ConnectButton.Enabled = True
            sandboxCheckbox.Enabled = True
            tdc = Nothing
            Debug.Print("DisconnectButton_Click:  logged out of qc")
        End If
    End Sub


    Private Sub createDummyButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles createDummyButton.Click
        If tdc IsNot Nothing Then
            Dim BugF As BugFactory
            Dim Bug1 As Bug
            BugF = tdc.BugFactory
            Bug1 = BugF.AddItem(System.DBNull.Value)
            Bug1.Summary = "This is an autogenerated defect--ignore this"

            Bug1.Status = "New"
            Bug1.Priority = "2 - High"
            Bug1.Field("BG_SEVERITY") = "4 - Low"
            Bug1.Field("BG_DESCRIPTION") = "Dummy defect -- ignore this"
            Bug1.Field("BG_DETECTION_DATE") = "5/12/2009"
            If sandboxCheckbox.Checked = True Then
                Bug1.Field("BG_PROJECT") = "Unknown"
            Else
                Bug1.Field("BG_PROJECT") = "_Recycle Bin"
            End If
            Bug1.Field("BG_REPRODUCIBLE") = "Y"

            ' State
            Bug1.Field("BG_USER_05") = "Open"
            Bug1.Field("BG_USER_08") = "Pre-release"
            ' sub state
            If sandboxCheckbox.Checked = True Then
                ' component
                Bug1.Field("BG_USER_42") = "Unknown"
                Bug1.Field("BG_USER_09") = "Unknown"
                ' problem(Type)
                Bug1.Field("BG_USER_43") = "Defect"
                ' product
                Bug1.Field("BG_USER_52") = "Unknown"
            Else
                ' component
                Bug1.Field("BG_USER_42") = ".Unknown"
                Bug1.Field("BG_USER_09") = "Unassigned"
                ' problem(Type)
                Bug1.Field("BG_USER_43") = "Problem Report"
                ' product
                Bug1.Field("BG_USER_52") = ".Not Applicable"
            End If





    
            ' reproducibility
            Bug1.Field("BG_USER_69") = "Always"
            ' encountered by
            Bug1.Field("BG_USER_75") = "R&D Other"
            ' Environment 1-3
            Bug1.Field("BG_USER_76") = ".Not Applicable"
            Bug1.Field("BG_USER_77") = ".Not Applicable"
            Bug1.Field("BG_USER_78") = ".Not Applicable"
            'Bug1.Field("BG_DETECTION_VERSION") = "1.0"
            'Bug1.Field("BG_USER_26") = "IPG_SIRIUS:SIRIUS_FW"
            ' Found in FW version
            Bug1.Field("BG_USER_81") = "1.0"
            ' Found in HW Version
            Bug1.Field("BG_USER_82") = "BB1"
            ' Found in SW of SDK
            Bug1.Field("BG_USER_83") = "1.0"
            ' How Found
            Bug1.Field("BG_USER_85") = "Misc: Normal Product Usage"
            ' SubProject
            Bug1.Field("BG_USER_90") = "Not Applicable"
            ' Team
            Bug1.Field("BG_USER_93") = "Firmware"
            ' Test area
            Bug1.Field("BG_USER_94") = "Other"
            ' Found in Client SW
            Bug1.Field("BG_USER_95") = "XP SP2"
            Bug1.Post()
            Debug.Print(Bug1.ID)

        Else
            MsgBox("You need to connect to Quality Center first.")
        End If
    End Sub

    Private Sub dumpBugButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles dumpBugButton.Click
        Dim cr As Integer
        Try
            cr = CLng(crIDText.Text)
        Catch ex As Exception
            MsgBox("You must enter the CR id")
            Return
        End Try


        If tdc IsNot Nothing Then
            SetupDGViewForCr()
            DGView.Rows.Clear()
            Dim BugF As BugFactory


            BugF = tdc.BugFactory
            Dim fields = BugF.Fields
            For Each i In fields
                Debug.Print(CStr(i.Name()))
            Next
            Dim filter = BugF.Filter()
            If whitneyBox.Checked = True Then
                filter.Filter("BG_STATUS") = "Open"
                filter.Filter("BG_USER_52") = "Whitney"

                Dim bugList = filter.NewList()
                For Each b In bugList
                    Debug.Print(b.Status & ": " & b.Summary & ": " & b.Status & ": " & b.Priority)
                    Dim r As String() = {b.ID, b.Project, b.DetectedBy, b.AssignedTo, b.Status, b.Summary, b.Priority}
                    DGView.Rows.Add(r)
                Next
            Else
                Dim b As Bug
                b = BugF.Item(cr)
                Debug.Print(b.Status & ": " & b.Summary & ": " & b.Status & ": " & b.Priority)
                Dim r As String() = {b.ID, b.Project, b.DetectedBy, b.AssignedTo, b.Status, b.Summary, b.Priority}
                DGView.Rows.Add(r)
                For Each i In fields
                    Debug.Print(CStr(i.Name()) & ":   " & CStr(b.Field(i.Name())))
                Next
            End If


            ResizeView(DGView)

        Else
            MsgBox("You need to connect to Quality Center first.")
        End If
    End Sub

    Public Sub CustomLists(ByVal tdc As TDConnection)
        Dim cust As Customization
        Dim custFields As CustomizationFields
        Dim aCustField As CustomizationField
        'Dim custLists As CustomizationLists
        Dim aCustList As CustomizationList
        Dim listName$, cnt%
        Dim msg As String
        '--------------------------------------------------- 
        'Get the customization object and CustomizationFields 
        'tdc is the global TDConnection object. 
        cust = tdc.Customization
        custFields = cust.Fields

        msg = "Active Entities for requirement table : " & Chr(13)
        'Walk through the fields of the bug table and output 
        ' the some properties of the fields that are linked 
        ' to custom lists. 
        ' For Each aCustField In custFields.Fields("BUG")
        For Each aCustField In custFields.Fields
            If aCustField.IsActive Then
                listName = ""
                'If the field is linked to a custom list, get the name 
                ' of the list and the field properties. 
                If Not (aCustField.List Is Nothing) Then
                    cnt = cnt + 1
                    '----------------------------------------- 
                    ' Get the CustomizationList from 
                    ' CustomizationField.List 
                    aCustList = aCustField.List
                    listName = _
                        " [Values from " & aCustList.Name & ".]"
                    msg = msg & aCustField.ColumnName _
                        & ", " & aCustField.UserLabel _
                        & listName & Chr(13) & vbCrLf
                End If
                msg = msg & aCustField.ColumnName & ", " & " <not customized>" & Chr(13)
            End If
        Next
        msg = msg & vbCrLf & "Count of fields with lists = " & CStr(cnt)
        ResultListForm.ListBox.Text = msg
        ResultListForm.ShowDialog()
        MsgBox(msg)
    End Sub


    Private Sub custListButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles custListButton.Click
        If tdc IsNot Nothing Then
            CustomLists(tdc)
        Else
            MsgBox("You need to connect to Quality Center first.")
        End If
    End Sub
End Class
