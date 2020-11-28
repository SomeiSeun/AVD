VERSION 5.00
Begin VB.Form frmACN 
   Caption         =   "ACN ICAO"
   ClientHeight    =   7935
   ClientLeft      =   1380
   ClientTop       =   2220
   ClientWidth     =   12870
   Icon            =   "ACNICAO.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   7935
   ScaleWidth      =   12870
   Begin VB.CheckBox txtSavePCNOutputtoFile 
      Caption         =   "Save PCN Output to a Text File"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   5880
      TabIndex        =   17
      Top             =   840
      Width           =   3015
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Show Ext File"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   2400
      TabIndex        =   16
      Top             =   120
      Width           =   855
   End
   Begin VB.Frame fraCalcMode 
      Caption         =   "Other Calculation Modes"
      Height          =   615
      Left            =   5760
      TabIndex        =   10
      Top             =   120
      Width           =   5415
      Begin VB.OptionButton optCalcMode 
         Caption         =   "Life"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   3
         Left            =   3720
         TabIndex        =   14
         Top             =   240
         Width           =   735
      End
      Begin VB.OptionButton optCalcMode 
         Caption         =   "Thickness"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   2
         Left            =   2400
         TabIndex        =   13
         Top             =   240
         Width           =   1215
      End
      Begin VB.OptionButton optCalcMode 
         Caption         =   "ACN Batch"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   1
         Left            =   960
         TabIndex        =   12
         Top             =   240
         Width           =   1335
      End
      Begin VB.OptionButton optCalcMode 
         Caption         =   "PCN"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   11
         Top             =   240
         Value           =   -1  'True
         Width           =   735
      End
      Begin VB.OptionButton optCalcMode 
         Caption         =   "MGW"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   4
         Left            =   4440
         TabIndex        =   15
         Top             =   240
         Width           =   855
      End
   End
   Begin VB.PictureBox picAlphaCurves 
      AutoRedraw      =   -1  'True
      BackColor       =   &H00FFFFFF&
      FontTransparent =   0   'False
      Height          =   6135
      Left            =   120
      ScaleHeight     =   6075
      ScaleWidth      =   6675
      TabIndex        =   9
      Top             =   1200
      Width           =   6735
   End
   Begin VB.CommandButton cmdUnitConversions 
      Caption         =   "Unit Conversions"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   120
      TabIndex        =   7
      Top             =   120
      Width           =   1215
   End
   Begin VB.CommandButton cmdGraphAlpha 
      Caption         =   "Show Alpha"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   1440
      TabIndex        =   8
      Top             =   120
      Width           =   855
   End
   Begin VB.Frame framePavementType 
      Caption         =   "Single Aircraft ACN"
      Height          =   615
      Left            =   3480
      TabIndex        =   4
      Top             =   120
      Width           =   2175
      Begin VB.OptionButton optPavementType 
         Caption         =   "Rigid"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   1
         Left            =   1200
         TabIndex        =   6
         Top             =   240
         Width           =   855
      End
      Begin VB.OptionButton optPavementType 
         Caption         =   "Flexible"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   8.25
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   255
         Index           =   0
         Left            =   120
         TabIndex        =   5
         Top             =   240
         Value           =   -1  'True
         Width           =   975
      End
   End
   Begin VB.CommandButton cmdBack 
      Caption         =   "&Back"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   11280
      TabIndex        =   3
      Top             =   120
      Width           =   975
   End
   Begin VB.CommandButton cmdEditFile 
      Caption         =   "&Edit File"
      Height          =   375
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.CommandButton cmdReadFile 
      Caption         =   "Read &File"
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   360
      Visible         =   0   'False
      Width           =   855
   End
   Begin VB.TextBox txtOutput 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   6135
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   0
      Top             =   1200
      Width           =   11655
   End
End
Attribute VB_Name = "frmACN"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim CaptionHeader$, picAlphaCurvesVisible As Boolean
Public FlexibleACN         As Boolean

'Private Declare Function ShellExecute Lib _
    "shell32.dll" Alias "ShellExecuteA" _
    (ByVal hwnd As Long, _
    ByVal lpOperation As String, _
    ByVal lpFile As String, _
    ByVal lpParameters As String, _
    ByVal lpDirectory As String, _
    ByVal nShowCmd As Long) As Long

Private Const SW_SHOWNORMAL = 1

Public Sub GraphAlphaCurves()

  Dim I As Integer, DTemp As Double, TempX As Double, TempY As Double
  Dim SaveForeColor As Long, IExit As Integer, picTextHeight As Single
  Dim VertAxisX  As Double, VertAxisTop   As Double, VertAxisBottom As Double
  Dim HorizAxisY As Double, HorizAxisLeft As Double, HorizAxisRight As Double
  Dim VertScale As Double, HorizScale As Double
  Dim Tick As Double, GraphBorder As Double
  Dim VertTicksN As Integer, HorizTicksN As Integer
  Dim VertTicksLength As Double, HorizTicksLength As Double
  Dim VertTicksDel As Double, HorizTicksDel As Double
  Dim picLeft  As Double, picTop    As Double
  Dim picWidth As Double, picHeight As Double
  Dim NPoints As Integer, Max As Double
  Dim VertPoint() As Double, HorizPoint() As Double
  Dim HorizText() As String
  Const CoveragesMax As Double = 1000000
  Dim Coverages As Double, DeltaLogCoverages As Double
  Dim NCurves As Integer, NW As Integer, IC As Long
  
' Note: if Y becomes more positive from bottom to top, .TextHeight() is -ve.
  
  With picAlphaCurves
  
    SaveForeColor = .ForeColor
'    .ForeColor = &H80000012
    .ForeColor = &H0
  
    picLeft = .ScaleLeft:    picTop = .ScaleTop
    picWidth = .ScaleWidth:  picHeight = .ScaleHeight
    Tick = 0.01
    VertTicksLength = Tick * picWidth
    HorizTicksLength = Tick * picHeight
    GraphBorder = 0.1
  
  VertAxisX = picLeft + 1.1 * GraphBorder * picWidth
  VertAxisBottom = picTop + (1 - 1.1 * GraphBorder) * picHeight
  VertAxisTop = picTop + GraphBorder * picHeight
  
  HorizAxisY = VertAxisBottom
  HorizAxisLeft = VertAxisX
  HorizAxisRight = picLeft + (1 - GraphBorder) * picWidth
  
  HorizTicksN = 7
  ReDim HorizPoint(1 To HorizTicksN), HorizText(1 To HorizTicksN)
  HorizScale = (HorizAxisRight - HorizAxisLeft) / (HorizTicksN - 1)
  HorizText(1) = "0":  HorizText(2) = "1":  HorizText(3) = "2"
  HorizText(4) = "3":  HorizText(5) = "4"
  HorizText(6) = "5":  HorizText(7) = "6"
  For I = 1 To HorizTicksN
    HorizPoint(I) = HorizAxisLeft + (I - 1) * HorizScale
'    picAlphaCurves.Line (HorizPoint(I), HorizAxisY)-(HorizPoint(I), HorizAxisY + HorizTicksLength)
    picAlphaCurves.Line (HorizPoint(I), VertAxisTop)-(HorizPoint(I), HorizAxisY + HorizTicksLength)
    .CurrentX = HorizPoint(I) - .TextWidth(HorizText(I)) / 2
    picAlphaCurves.Print HorizText(I)
  Next I
  S$ = "log10 (Coverages)"
  .CurrentX = HorizAxisLeft + (HorizAxisRight - HorizAxisLeft - .TextWidth(S$)) / 2
  .CurrentY = .CurrentY - VertTicksLength * -0#
  picAlphaCurves.Print S$
  
  picAlphaCurves.Line (VertAxisX, VertAxisBottom)-(VertAxisX, VertAxisTop)
  picAlphaCurves.Line (HorizAxisLeft, HorizAxisY)-(HorizAxisRight, HorizAxisY)
  
  Max = 1.4
  picTextHeight = .TextHeight("ABC")
  
  If Max = 0 Then Max = 99
  VertTicksN = 8
  VertScale = (VertAxisTop - VertAxisBottom) / Max
  For I = 1 To VertTicksN
    DTemp = VertAxisBottom + (I - 1) * 0.2 * VertScale
'    picAlphaCurves.Line (VertAxisX, DTemp)-(VertAxisX - VertTicksLength, DTemp)
    picAlphaCurves.Line (HorizAxisRight, DTemp)-(VertAxisX - VertTicksLength, DTemp)
    S$ = Format((I - 1) * 0.2, "0.0")
    .CurrentX = VertAxisX - VertTicksLength - .TextWidth(S$)
    .CurrentY = DTemp - picTextHeight / 2
    picAlphaCurves.Print S$
  Next I
  
  S$ = Format(0.2, "00.0")
  TempX = VertAxisX - VertTicksLength * 2 - _
          .TextWidth(S$) - .TextWidth("A")
  DTemp = VertAxisBottom + (VertAxisTop - VertAxisBottom) / 2
  TempY = picTextHeight / 2
  .CurrentX = TempX:  .CurrentY = DTemp - TempY * 5
  picAlphaCurves.Print "A"
  .CurrentX = TempX:  .CurrentY = DTemp - TempY * 3
  picAlphaCurves.Print "L"
  .CurrentX = TempX:  .CurrentY = DTemp - TempY
  picAlphaCurves.Print "P"
  .CurrentX = TempX:  .CurrentY = DTemp + TempY
  picAlphaCurves.Print "H"
  .CurrentX = TempX:  .CurrentY = DTemp + TempY * 3
  picAlphaCurves.Print "A"

  NPoints = 20
  DeltaLogCoverages = Log10(CoveragesMax) / (NPoints)
  NCurves = 24
  
  For NW = 1 To NCurves
    .CurrentX = VertAxisX
    Coverages = 1  ' 10^0
    If frmGear.chkNew07Alphas.Value = vbChecked Then ' GFH 09/26/06.
      .CurrentY = HorizAxisY + New06AlphaFactorFromCurve(NW, Coverages) * VertScale
    Else ' Old system.
      .CurrentY = HorizAxisY + AlphaFactorFromCurve(NW, Coverages, NCurves) * VertScale
    End If
    For IC = 1 To NPoints
      TempX = VertAxisX + IC * DeltaLogCoverages * HorizScale
      Coverages = 10 ^ (IC * DeltaLogCoverages)
    If frmGear.chkNew07Alphas.Value = vbChecked Then ' GFH 09/26/06.
      TempY = HorizAxisY + New06AlphaFactorFromCurve(NW, Coverages) * VertScale
    Else ' Old system.
      TempY = HorizAxisY + AlphaFactorFromCurve(NW, Coverages, NCurves) * VertScale
    End If
      picAlphaCurves.Line -(TempX, TempY)
    Next IC
  Next NW
  
  S$ = "Alpha Curves For 1 Through 24 Wheels"
  .CurrentX = HorizAxisLeft + (HorizAxisRight - HorizAxisLeft - .TextWidth(S$)) / 2
  .CurrentY = VertAxisTop - picTextHeight * 2.5
  picAlphaCurves.Print S$
  S$ = "as Computed in the Program"
  .CurrentX = HorizAxisLeft + (HorizAxisRight - HorizAxisLeft - .TextWidth(S$)) / 2
'  .CurrentY = VertAxisTop
  picAlphaCurves.Print S$
  
  If frmGear.chkNew07Alphas.Value = vbChecked Then ' GFH 09/26/06.
    .CurrentX = VertAxisX + 4.7 * HorizScale
    .CurrentY = HorizAxisY + 1.17 * VertScale
    picAlphaCurves.Print "1"
    .CurrentX = VertAxisX + 5.08 * HorizScale
    .CurrentY = HorizAxisY + 1.075 * VertScale
    picAlphaCurves.Print "2"
    .CurrentX = VertAxisX + 5.35 * HorizScale
    .CurrentY = HorizAxisY + 0.94 * VertScale
    picAlphaCurves.Print "4"
    .CurrentX = VertAxisX + 5.49 * HorizScale
    .CurrentY = HorizAxisY + 0.824 * VertScale
    picAlphaCurves.Print "6"
    .CurrentX = VertAxisX + 5.6 * HorizScale
    .CurrentY = HorizAxisY + 0.65 * VertScale
    picAlphaCurves.Print "24"
  Else
    .CurrentX = VertAxisX + 4.7 * HorizScale
    .CurrentY = HorizAxisY + 1.2 * VertScale
    picAlphaCurves.Print "1"
    .CurrentX = VertAxisX + 5 * HorizScale
    .CurrentY = HorizAxisY + 1.1 * VertScale
    picAlphaCurves.Print "2"
    .CurrentX = VertAxisX + 5.15 * HorizScale
    .CurrentY = HorizAxisY + 1.02 * VertScale
    picAlphaCurves.Print "3"
    .CurrentX = VertAxisX + 5.3 * HorizScale
    .CurrentY = HorizAxisY + 0.69 * VertScale
    picAlphaCurves.Print "24"
  End If
  
  .ForeColor = SaveForeColor
  
  End With
  
End Sub

Private Sub cmdBack_Click()
  Unload frmACN
  Set frmACN = Nothing
End Sub

Private Sub cmdEditFile_Click()
  
  Dim LRet As Long

  If Not FirstFileRead Then
    Ret = MsgBox("A file must be opened before editing.", , "Edit File Error")
    Exit Sub
  End If
  
' Opens Notepad, or application associated with file extension.
'  LRet = ShellExecute(Me.hwnd, _
         vbNullString, _
         FilePath$ & FileName$, _
         vbNullString, _
         FilePath$, _
         SW_SHOWNORMAL)
  
End Sub

Private Sub cmdGraphAlpha_Click()

  txtOutput.Visible = False
  picAlphaCurves.Visible = True
  picAlphaCurvesVisible = True
  picAlphaCurves.Cls
  picAlphaCurves.Refresh
  Call GraphAlphaCurves
'  picAlphaCurves.Refresh
'  txtOutput.Visible = False
'  picAlphaCurves.Visible = False

End Sub

Private Sub cmdReadFile_Click()

  Dim FileExt$, FullFileName$, I As Long
  Dim S$
  On Error GoTo cmdReadFileError
  
'  cdlFiles.Filter = "(txt files) *.txt|*.txt"
'  cdlFiles.FilterIndex = 1
'  cdlFiles.DefaultExt = ".dat"
'  cdlFiles.CancelError = True
'  cdlFiles.ShowOpen
'  cdlFiles.InitDir = FilePath$

'  If StrComp(Right$(cdlFiles.FileName, 4), ".txt", 1) = 0 Then
'    FirstFileRead = True
'    FileName$ = cdlFiles.FileTitle
'    FullFileName$ = cdlFiles.FileName
'    FilePath$ = Left$(FullFileName$, Len(FullFileName$) - Len(FileName$))
'    FileExt$ = Right$(FullFileName$, 4)
'    Caption = CaptionHeader$ & FullFileName$
'  Else
'    S$ = "The file is not a valid type." & vbCrLf & "Must be .txt"
'    Ret = MsgBox(S$, , "Wrong Extension")
'  End If

'  Call ReadDataFile
  
  Exit Sub
  
cmdReadFileError:
'  If Err = cdlCancel Then Exit Sub

End Sub

Private Sub cmdUnitConversions_Click()
  
  If picAlphaCurves.Visible Then
    txtOutput.Visible = True
    picAlphaCurves.Visible = False
  End If
    
  S$ = "  To Convert From       To       Multiply By" & NL2
  S$ = S$ & "              cm        in         0.3937008" & vbCrLf
  S$ = S$ & "              MPa       psi      145.0377438" & vbCrLf
  S$ = S$ & "              kPa       psi        0.1450377438" & vbCrLf
  S$ = S$ & "              kg        lb         2.2046225" & vbCrLf
  S$ = S$ & "              kg/cm^3   lb/in^3    36.1273" & vbCrLf
  S$ = S$ & "              MN/m^3    lb/in^3    3.68396" & NL2 & vbCrLf
  S$ = S$ & "NOTE: The value for the gravitational constant listed in" & vbCrLf
  S$ = S$ & "      the original ICAO source code is 9.815 m/s.s. This is" & vbCrLf
  S$ = S$ & "      not consistent with the kg to lb conversion factor used" & vbCrLf
  S$ = S$ & "      in the program, as given above (9.80665 is consistent)." & vbCrLf
  S$ = S$ & "      The result is that the ACN values are slightly high." & vbCrLf
  S$ = S$ & "      Computing rigid ACN for the SWL ACN 100 gear illustrates" & vbCrLf
  S$ = S$ & "      the effect. Flexible ACN values for the SWL ACN 100 gear" & vbCrLf
  S$ = S$ & "      are off by more than the rigid ACN values because of" & vbCrLf
  S$ = S$ & "      inconsistencies between the definition of ACN and the" & vbCrLf
  S$ = S$ & "      program implementation."
  S$ = S$ & NL2
    
  S$ = S$ & "      Also, aircraft weights and tire pressures displayed in" & vbCrLf
  S$ = S$ & "      English units may look odd, i.e. B727-200 = 172,999 lbs." & vbCrLf
  S$ = S$ & "      This occurs because the values taken from original sources" & vbCrLf
  S$ = S$ & "      are converted to English/metric units by multiplying by the" & vbCrLf
  S$ = S$ & "      conversion factors above and rounded to a practical" & vbCrLf
  S$ = S$ & "      level of precision."
  
  
  txtOutput.Text = S$
  
End Sub

Private Sub Command1_Click()

  If picAlphaCurves.Visible Then
    txtOutput.Visible = True
    picAlphaCurves.Visible = False
  End If
    
  txtOutput.Text = ExtFileText

End Sub

Private Sub Form_Activate()

  Top = frmGear.Top + 450
  Left = frmGear.Left + 450
  Height = frmGear.Height - 450
  Width = frmGear.Width '- 400
  
'  txtOutput.Height = frmACNtxtOutputHeight
'  txtOutput.Width = frmACNtxtOutputWidth
  txtOutput.Height = frmACN.Height - 1900
  txtOutput.Width = frmACN.Width - 360
  
  picAlphaCurves.Height = 6495 'txtOutput.Height ' frmACNgphAlphaHeight
  picAlphaCurves.Width = 8175 'txtOutput.Width ' frmACNgphAlphaWidth
  If Not picAlphaCurvesVisible Then picAlphaCurves.Visible = False
  
  txtSavePCNOutputtoFile.Value = SavePCNOutputtoFile
  
  If ACNOnly Then
    optCalcMode(0).Visible = False
    optCalcMode(2).Visible = False
    optCalcMode(3).Visible = False
    optCalcMode(4).Visible = False
    txtSavePCNOutputtoFile.Visible = False
    txtOutput.Top = txtOutput.Top - 270
    txtOutput.Height = txtOutput.Height + 270
  End If
  
  If ACN_mode_true Then
    If optPavementType(0).Value = True Then
      FlexibleACN = True
      txtOutput.Text = ACNFlexibleOutputText$
    ElseIf optPavementType(1).Value = True Then
      FlexibleACN = False
      txtOutput.Text = ACNRigidOutputText$
    End If
    If frmGear.chkBatch.Value = vbChecked Then
      txtOutput.Text = ACNBatchOutputText ' Overwrite if in batch mode.
    End If
  Else
'   The frmACN.optCalcMode() values are set in frmGear.
    If frmACN.optCalcMode(0).Value = True Then ' Startup default.
      If PCNOutputText <> "" Then
        txtOutput.Text = PCNOutputText$
      Else
        txtOutput.Text = ExtFileText
      End If
    ElseIf frmACN.optCalcMode(1).Value = True Then
      txtOutput.Text = ACNBatchOutputText
    ElseIf frmACN.optCalcMode(2).Value = True Then
      txtOutput.Text = ThicknessOutputText
    ElseIf frmACN.optCalcMode(3).Value = True Then
      txtOutput.Text = LifeOutputText
    ElseIf frmACN.optCalcMode(4).Value = True Then
      txtOutput.Text = MGWOutputText
    End If
  End If
  
End Sub

Private Sub Form_GotFocus()
  frmACN.Refresh
  frmACN.picAlphaCurves.Refresh
End Sub


Private Sub Form_Load()
  
  Caption = "ICAO ACN Computation, Detailed Output "

  frmACN.Top = frmGear.Top
  frmACN.Left = frmGear.Left
  
  picAlphaCurvesVisible = False
  
'  Top = frmGear.Top
'  Left = frmGear.Left
'  Height = frmACNHeight
'  Width = frmACNWidth
  
End Sub

Private Sub Form_Resize()
  Dim Ht As Long, WT As Long
  
  Ht = frmACN.Height - 1400
  WT = frmACN.Width - 360
  If Ht < 0 Or WT < 0 Then Exit Sub ' Needed when minimized.
  txtOutput.Height = frmACN.Height - 1400
  txtOutput.Width = frmACN.Width - 360

End Sub

Private Sub Form_Unload(Cancel As Integer)
  SavePCNOutputtoFile = txtSavePCNOutputtoFile.Value
  frmGear.SetFocus
End Sub

Private Sub optCalcMode_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)
  
  If picAlphaCurves.Visible Then
    txtOutput.Visible = True
    picAlphaCurves.Visible = False
  End If
  
  If optCalcMode(Index).Caption = "PCN" Then
    txtOutput.Text = PCNOutputText
  ElseIf optCalcMode(Index).Caption = "ACN Batch" Then
    txtOutput.Text = ACNBatchOutputText
  ElseIf optCalcMode(Index).Caption = "Thickness" Then
    txtOutput.Text = ThicknessOutputText
  ElseIf optCalcMode(Index).Caption = "Life" Then
    txtOutput.Text = LifeOutputText
  ElseIf optCalcMode(Index).Caption = "MGW" Then
    txtOutput.Text = MGWOutputText
  End If

End Sub

Private Sub optPavementType_MouseUp(Index As Integer, Button As Integer, Shift As Integer, X As Single, Y As Single)

  If picAlphaCurves.Visible Then
    txtOutput.Visible = True
    picAlphaCurves.Visible = False
  End If
  
    If optPavementType(0).Value = True Then
      FlexibleACN = True
      txtOutput.Text = ACNFlexibleOutputText$
'    Else
    ElseIf optPavementType(1).Value = True Then
      FlexibleACN = False
      txtOutput.Text = ACNRigidOutputText$
    End If
'  If optPavementType(Index).Caption = "Flexible" Then
'    FlexibleACN = True
'    txtOutput.Text = ACNFlexibleOutputText
'  ElseIf optPavementType(Index).Caption = "Rigid" Then
'    FlexibleACN = False
'    txtOutput.Text = ACNRigidOutputText
'  End If
  
End Sub

Private Sub picAlphaCurves_Click()
  Clipboard.Clear
  Clipboard.SetData picAlphaCurves.Image
End Sub

Private Sub txtOutput_Click()
  Clipboard.Clear
  Clipboard.SetText txtOutput.Text
End Sub
