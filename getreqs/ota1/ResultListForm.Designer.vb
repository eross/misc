<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class ResultListForm
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
        Me.ListBox = New System.Windows.Forms.TextBox
        Me.SuspendLayout()
        '
        'ListBox
        '
        Me.ListBox.Location = New System.Drawing.Point(12, 12)
        Me.ListBox.Multiline = True
        Me.ListBox.Name = "ListBox"
        Me.ListBox.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.ListBox.Size = New System.Drawing.Size(718, 576)
        Me.ListBox.TabIndex = 0
        '
        'ResultListForm
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(742, 600)
        Me.Controls.Add(Me.ListBox)
        Me.Name = "ResultListForm"
        Me.Text = "ResultListForm"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents ListBox As System.Windows.Forms.TextBox
End Class
