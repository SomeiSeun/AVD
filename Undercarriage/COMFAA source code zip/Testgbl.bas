Attribute VB_Name = "modTestGbl"
Option Explicit

Public Function LPad1$(N, SS$)
' Adds leading spaces to string SS$ to make it N characters long.
' Used to format output to a file. #### characters in a Format function
' do not force spaces like QuickBasic.
' Typically, SS = Format(XX, "0.00")
  Dim ITemp As Integer
  ITemp = Len(SS$)
  If N - ITemp < 0 Then N = ITemp + 1
  LPad1$ = Space$(N - ITemp) & SS$
End Function

Public Sub Continue()
' Dummy statement
End Sub
