<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class Main
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.ConnectButton = New System.Windows.Forms.Button
        Me.GetReqButton = New System.Windows.Forms.Button
        Me.DisconnectButton = New System.Windows.Forms.Button
        Me.DGView = New System.Windows.Forms.DataGridView
        Me.createDummyButton = New System.Windows.Forms.Button
        Me.dumpBugButton = New System.Windows.Forms.Button
        Me.crIDText = New System.Windows.Forms.TextBox
        Me.custListButton = New System.Windows.Forms.Button
        Me.whitneyBox = New System.Windows.Forms.CheckBox
        Me.sandboxCheckbox = New System.Windows.Forms.CheckBox
        CType(Me.DGView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'ConnectButton
        '
        Me.ConnectButton.Location = New System.Drawing.Point(12, 377)
        Me.ConnectButton.Name = "ConnectButton"
        Me.ConnectButton.Size = New System.Drawing.Size(75, 23)
        Me.ConnectButton.TabIndex = 0
        Me.ConnectButton.Text = "Connect"
        Me.ConnectButton.UseVisualStyleBackColor = True
        '
        'GetReqButton
        '
        Me.GetReqButton.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.GetReqButton.Location = New System.Drawing.Point(548, 467)
        Me.GetReqButton.Name = "GetReqButton"
        Me.GetReqButton.Size = New System.Drawing.Size(111, 23)
        Me.GetReqButton.TabIndex = 1
        Me.GetReqButton.Text = "Get Reqs"
        Me.GetReqButton.UseVisualStyleBackColor = True
        '
        'DisconnectButton
        '
        Me.DisconnectButton.Enabled = False
        Me.DisconnectButton.Location = New System.Drawing.Point(12, 406)
        Me.DisconnectButton.Name = "DisconnectButton"
        Me.DisconnectButton.Size = New System.Drawing.Size(75, 23)
        Me.DisconnectButton.TabIndex = 2
        Me.DisconnectButton.Text = "Disconnect"
        Me.DisconnectButton.UseVisualStyleBackColor = True
        '
        'DGView
        '
        Me.DGView.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DGView.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.DGView.Location = New System.Drawing.Point(93, 13)
        Me.DGView.Name = "DGView"
        Me.DGView.Size = New System.Drawing.Size(1080, 446)
        Me.DGView.TabIndex = 4
        '
        'createDummyButton
        '
        Me.createDummyButton.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.createDummyButton.Location = New System.Drawing.Point(138, 467)
        Me.createDummyButton.Name = "createDummyButton"
        Me.createDummyButton.Size = New System.Drawing.Size(145, 23)
        Me.createDummyButton.TabIndex = 5
        Me.createDummyButton.Text = "Create Dummy Bug"
        Me.createDummyButton.UseVisualStyleBackColor = True
        '
        'dumpBugButton
        '
        Me.dumpBugButton.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.dumpBugButton.Location = New System.Drawing.Point(779, 468)
        Me.dumpBugButton.Name = "dumpBugButton"
        Me.dumpBugButton.Size = New System.Drawing.Size(149, 23)
        Me.dumpBugButton.TabIndex = 6
        Me.dumpBugButton.Text = "Dump Bug"
        Me.dumpBugButton.UseVisualStyleBackColor = True
        '
        'crIDText
        '
        Me.crIDText.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.crIDText.Location = New System.Drawing.Point(934, 471)
        Me.crIDText.Name = "crIDText"
        Me.crIDText.Size = New System.Drawing.Size(146, 20)
        Me.crIDText.TabIndex = 7
        '
        'custListButton
        '
        Me.custListButton.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.custListButton.Location = New System.Drawing.Point(350, 467)
        Me.custListButton.Name = "custListButton"
        Me.custListButton.Size = New System.Drawing.Size(121, 23)
        Me.custListButton.TabIndex = 8
        Me.custListButton.Text = "Custom Lists"
        Me.custListButton.UseVisualStyleBackColor = True
        '
        'whitneyBox
        '
        Me.whitneyBox.AutoSize = True
        Me.whitneyBox.Location = New System.Drawing.Point(708, 470)
        Me.whitneyBox.Name = "whitneyBox"
        Me.whitneyBox.Size = New System.Drawing.Size(65, 17)
        Me.whitneyBox.TabIndex = 9
        Me.whitneyBox.Text = "Whitney"
        Me.whitneyBox.UseVisualStyleBackColor = True
        '
        'sandboxCheckbox
        '
        Me.sandboxCheckbox.AutoSize = True
        Me.sandboxCheckbox.Checked = True
        Me.sandboxCheckbox.CheckState = System.Windows.Forms.CheckState.Checked
        Me.sandboxCheckbox.Location = New System.Drawing.Point(12, 13)
        Me.sandboxCheckbox.Name = "sandboxCheckbox"
        Me.sandboxCheckbox.Size = New System.Drawing.Size(68, 17)
        Me.sandboxCheckbox.TabIndex = 10
        Me.sandboxCheckbox.Text = "Sandbox"
        Me.sandboxCheckbox.UseVisualStyleBackColor = True
        '
        'Main
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(1204, 502)
        Me.Controls.Add(Me.sandboxCheckbox)
        Me.Controls.Add(Me.whitneyBox)
        Me.Controls.Add(Me.custListButton)
        Me.Controls.Add(Me.crIDText)
        Me.Controls.Add(Me.dumpBugButton)
        Me.Controls.Add(Me.createDummyButton)
        Me.Controls.Add(Me.DGView)
        Me.Controls.Add(Me.DisconnectButton)
        Me.Controls.Add(Me.GetReqButton)
        Me.Controls.Add(Me.ConnectButton)
        Me.Name = "Main"
        Me.Text = "GetReqs"
        CType(Me.DGView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ConnectButton As System.Windows.Forms.Button
    Friend WithEvents GetReqButton As System.Windows.Forms.Button
    Friend WithEvents DisconnectButton As System.Windows.Forms.Button
    Friend WithEvents DGView As System.Windows.Forms.DataGridView
    Friend WithEvents createDummyButton As System.Windows.Forms.Button
    Friend WithEvents dumpBugButton As System.Windows.Forms.Button
    Friend WithEvents crIDText As System.Windows.Forms.TextBox
    Friend WithEvents custListButton As System.Windows.Forms.Button
    Friend WithEvents whitneyBox As System.Windows.Forms.CheckBox
    Friend WithEvents sandboxCheckbox As System.Windows.Forms.CheckBox

End Class
