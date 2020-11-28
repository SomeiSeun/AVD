VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "MSFlxGrd.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "ComDlg32.OCX"
Begin VB.Form frmGear 
   Appearance      =   0  'Flat
   AutoRedraw      =   -1  'True
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "ACN Comp"
   ClientHeight    =   9810
   ClientLeft      =   1395
   ClientTop       =   2175
   ClientWidth     =   12450
   FillColor       =   &H00C00000&
   BeginProperty Font 
      Name            =   "MS Sans Serif"
      Size            =   8.25
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H00C0C0C0&
   Icon            =   "Gear.frx":0000
   KeyPreview      =   -1  'True
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   9810
   ScaleWidth      =   12450
   Begin MSComDlg.CommonDialog CdlFiles 
      Left            =   4440
      Top             =   8520
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.Frame fraLibraryFunctions 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Library Functions"
      Height          =   1815
      Left            =   9840
      TabIndex        =   49
      Top             =   1560
      Width           =   2535
      Begin VB.CommandButton cmdOpenAircraftWindow 
         Caption         =   "Open Aircraft Window"
         Height          =   375
         Left            =   240
         TabIndex        =   55
         Top             =   1440
         Width           =   2055
      End
      Begin VB.CommandButton cmdRemoveACfromLibrary 
         Caption         =   "Remove Aircraft"
         Height          =   450
         Left            =   1320
         TabIndex        =   53
         Top             =   840
         Width           =   1095
      End
      Begin VB.CommandButton cmdAddACtoLibrary 
         Caption         =   "Add Aircraft"
         Height          =   450
         Left            =   120
         TabIndex        =   52
         Top             =   840
         Width           =   1095
      End
      Begin VB.CommandButton cmdLoadACfromLibrary 
         Caption         =   "Load Ext File"
         Height          =   450
         Left            =   120
         TabIndex        =   51
         Top             =   240
         Width           =   1095
      End
      Begin VB.CommandButton cmdSaveACinLibrary 
         Caption         =   "Save Ext File"
         Height          =   450
         Left            =   1320
         TabIndex        =   50
         Top             =   240
         Width           =   1095
      End
   End
   Begin VB.Frame fraPCNBatchMode 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Computational Mode"
      Height          =   1215
      Left            =   6360
      TabIndex        =   44
      Top             =   7320
      Width           =   6015
      Begin VB.CommandButton btnMORE 
         Caption         =   "MORE >>>"
         Height          =   375
         Left            =   4800
         TabIndex        =   48
         Top             =   480
         Width           =   1095
      End
      Begin VB.CommandButton btnPCN_rigid 
         Caption         =   "PCN Rigid Batch"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   735
         Left            =   2520
         TabIndex        =   46
         Top             =   360
         Width           =   2100
      End
      Begin VB.CommandButton btnPCN_flexible 
         Caption         =   "PCN Flexible Batch"
         BeginProperty Font 
            Name            =   "MS Sans Serif"
            Size            =   12
            Charset         =   0
            Weight          =   700
            Underline       =   0   'False
            Italic          =   0   'False
            Strikethrough   =   0   'False
         EndProperty
         Height          =   735
         Left            =   240
         TabIndex        =   45
         Top             =   360
         Width           =   2100
      End
   End
   Begin VB.TextBox txtStress 
      Height          =   285
      Left            =   11280
      TabIndex        =   43
      Top             =   8640
      Width           =   855
   End
   Begin VB.Frame fraMiscellaneousFunctions 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Miscellaneous Functions"
      Height          =   1455
      Left            =   9840
      TabIndex        =   34
      Top             =   3480
      Width           =   2535
      Begin VB.CommandButton cmdAbout 
         Caption         =   "About"
         Height          =   450
         Left            =   1320
         TabIndex        =   38
         Top             =   840
         Width           =   1095
      End
      Begin VB.CommandButton cmdHelp 
         Caption         =   "&Help"
         Height          =   450
         Left            =   120
         TabIndex        =   37
         Top             =   840
         Width           =   1095
      End
      Begin VB.CommandButton cmdExit 
         Caption         =   "E&xit"
         Height          =   450
         Left            =   1320
         TabIndex        =   36
         Top             =   240
         Width           =   1095
      End
      Begin VB.CommandButton cmdOutputDetails 
         Caption         =   "&Details"
         Height          =   450
         Left            =   120
         TabIndex        =   35
         Top             =   240
         Width           =   1095
      End
   End
   Begin VB.TextBox txtEvaluationThickness 
      Height          =   285
      Left            =   8880
      TabIndex        =   27
      Top             =   8640
      Width           =   975
   End
   Begin MSFlexGridLib.MSFlexGrid grdOutput 
      Height          =   975
      Left            =   6360
      TabIndex        =   17
      Top             =   7320
      Width           =   4215
      _ExtentX        =   7435
      _ExtentY        =   1720
      _Version        =   393216
      FixedRows       =   0
      FixedCols       =   0
      ScrollBars      =   0
   End
   Begin MSFlexGridLib.MSFlexGrid grdParms 
      Height          =   615
      Left            =   2700
      TabIndex        =   16
      Top             =   5925
      Width           =   2775
      _ExtentX        =   4895
      _ExtentY        =   1085
      _Version        =   393216
      FixedRows       =   0
      ScrollBars      =   0
   End
   Begin VB.CommandButton cmdRedraw 
      Caption         =   "&Redraw"
      Height          =   495
      Left            =   10920
      TabIndex        =   14
      TabStop         =   0   'False
      Top             =   7440
      Visible         =   0   'False
      Width           =   975
   End
   Begin VB.Frame fraEditWheels 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Edit Wheels"
      Height          =   1440
      Left            =   9840
      TabIndex        =   11
      Top             =   0
      Width           =   2535
      Begin VB.CommandButton cmdSelectWheel 
         Caption         =   "Se&lect"
         Height          =   450
         Left            =   120
         TabIndex        =   5
         Top             =   840
         Width           =   1095
      End
      Begin VB.CommandButton cmdMoveWheel 
         Caption         =   "&Move"
         Height          =   450
         Left            =   1320
         TabIndex        =   4
         Top             =   840
         Width           =   1095
      End
      Begin VB.CommandButton cmdRemoveWheel 
         Caption         =   "&Remove"
         Height          =   450
         Left            =   1320
         TabIndex        =   3
         Top             =   240
         Width           =   1095
      End
      Begin VB.CommandButton cmdAddWheel 
         Caption         =   "&Add"
         Height          =   450
         Left            =   120
         TabIndex        =   2
         Top             =   240
         Width           =   1095
      End
   End
   Begin VB.ListBox lstACGroup 
      BackColor       =   &H00FFFFFF&
      Height          =   1620
      Left            =   150
      TabIndex        =   0
      Top             =   495
      Width           =   2415
   End
   Begin VB.ListBox lstLibFile 
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H00000000&
      Height          =   5520
      IntegralHeight  =   0   'False
      Left            =   150
      TabIndex        =   1
      Top             =   2400
      Width           =   2415
   End
   Begin VB.PictureBox picGear 
      BackColor       =   &H00C0FFFF&
      FillStyle       =   0  'Solid
      ForeColor       =   &H00000000&
      Height          =   5655
      Left            =   2700
      ScaleHeight     =   5595
      ScaleWidth      =   6915
      TabIndex        =   6
      TabStop         =   0   'False
      Top             =   240
      Width           =   6975
   End
   Begin VB.Frame fraCompMode 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Computational Modes"
      Height          =   1215
      Left            =   6360
      TabIndex        =   18
      Top             =   6000
      Width           =   6015
      Begin VB.OptionButton optCalcMode 
         BackColor       =   &H00C0C0C0&
         Caption         =   "Life"
         Height          =   300
         Index           =   6
         Left            =   2280
         TabIndex        =   54
         Top             =   240
         Width           =   855
      End
      Begin VB.CommandButton btnLESS 
         Caption         =   "LESS <<<"
         Height          =   495
         Left            =   5160
         TabIndex        =   47
         Top             =   600
         Width           =   735
      End
      Begin VB.OptionButton optCalcMode 
         BackColor       =   &H00C0C0C0&
         Caption         =   "Edge Stress"
         Height          =   300
         Index           =   5
         Left            =   4440
         TabIndex        =   41
         Top             =   240
         Width           =   1455
      End
      Begin VB.OptionButton optCalcMode 
         BackColor       =   &H00C0C0C0&
         Caption         =   "Int. Stress"
         Height          =   300
         Index           =   4
         Left            =   3120
         TabIndex        =   40
         Top             =   240
         Width           =   1215
      End
      Begin VB.OptionButton optCalcMode 
         BackColor       =   &H00C0C0C0&
         Caption         =   "MGW"
         Height          =   300
         Index           =   3
         Left            =   960
         TabIndex        =   39
         Top             =   720
         Width           =   855
      End
      Begin VB.OptionButton optCalcMode 
         BackColor       =   &H00C0C0C0&
         Caption         =   "PCN"
         Height          =   300
         Index           =   2
         Left            =   120
         TabIndex        =   25
         Top             =   720
         Width           =   735
      End
      Begin VB.CommandButton cmdRigidCompute 
         Caption         =   "&Rigid"
         Height          =   400
         Left            =   3600
         TabIndex        =   22
         Top             =   600
         Width           =   1335
      End
      Begin VB.CommandButton cmdFlexibleCompute 
         Caption         =   "&Flexible"
         Height          =   400
         Left            =   2040
         TabIndex        =   21
         Top             =   600
         Width           =   1330
      End
      Begin VB.OptionButton optCalcMode 
         BackColor       =   &H00C0C0C0&
         Caption         =   "Thickness"
         Height          =   300
         Index           =   1
         Left            =   960
         TabIndex        =   20
         Top             =   240
         Value           =   -1  'True
         Width           =   1215
      End
      Begin VB.OptionButton optCalcMode 
         BackColor       =   &H00C0C0C0&
         Caption         =   "ACN"
         Height          =   300
         Index           =   0
         Left            =   120
         TabIndex        =   19
         Top             =   240
         Width           =   735
      End
   End
   Begin VB.Frame fraOptions 
      BackColor       =   &H00C0C0C0&
      Caption         =   "Options"
      Height          =   1095
      Left            =   9840
      TabIndex        =   28
      Top             =   4920
      Width           =   2535
      Begin VB.CheckBox chkMGWcovs 
         BackColor       =   &H00C0C0C0&
         Caption         =   "MGW at Current covs."
         Height          =   375
         Left            =   120
         TabIndex        =   56
         Top             =   840
         Visible         =   0   'False
         Width           =   2295
      End
      Begin VB.CheckBox chkBatch 
         BackColor       =   &H00C0C0C0&
         Caption         =   "Batch"
         Height          =   375
         Left            =   120
         TabIndex        =   33
         Top             =   240
         Width           =   960
      End
      Begin VB.CheckBox chkPCAThicknessDesign 
         BackColor       =   &H00C0C0C0&
         Caption         =   "PCA Thick"
         Height          =   375
         Left            =   1200
         TabIndex        =   31
         Top             =   240
         Width           =   1275
      End
      Begin VB.CheckBox chkPCAforGrossWeight 
         BackColor       =   &H00C0C0C0&
         Caption         =   "PCA MGW"
         Height          =   375
         Left            =   1200
         TabIndex        =   32
         Top             =   600
         Width           =   1215
      End
      Begin VB.CheckBox chkNew07Alphas 
         BackColor       =   &H00C0C0C0&
         Caption         =   "'07 Alphas"
         Height          =   375
         Left            =   1200
         TabIndex        =   29
         Top             =   0
         Value           =   1  'Checked
         Visible         =   0   'False
         Width           =   1305
      End
      Begin VB.CheckBox chkUnitsConversion 
         BackColor       =   &H00C0C0C0&
         Caption         =   "Metric"
         Height          =   375
         Left            =   120
         TabIndex        =   30
         Top             =   600
         Width           =   960
      End
   End
   Begin VB.Label lblStress 
      Alignment       =   2  'Center
      BackColor       =   &H00B0FFFF&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Stress ="
      Height          =   285
      Left            =   10320
      TabIndex        =   42
      Top             =   8640
      Width           =   855
   End
   Begin VB.Label lblEvaluationThickness 
      Alignment       =   2  'Center
      BackColor       =   &H00B0FFFF&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Evaluation Thickness ="
      ForeColor       =   &H00000000&
      Height          =   285
      Left            =   6600
      TabIndex        =   26
      Top             =   8640
      Width           =   2175
   End
   Begin VB.Label lblCriticalAircraftText 
      BackColor       =   &H80000005&
      BorderStyle     =   1  'Fixed Single
      Height          =   255
      Left            =   150
      TabIndex        =   24
      Top             =   8280
      Width           =   2415
   End
   Begin VB.Label lblCriticalAircraft 
      Alignment       =   2  'Center
      BackColor       =   &H00B0FFFF&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Critical Aircraft"
      ForeColor       =   &H00000000&
      Height          =   255
      Left            =   150
      TabIndex        =   23
      Top             =   8040
      Width           =   2415
   End
   Begin VB.Label lblMessage 
      Alignment       =   2  'Center
      BackColor       =   &H00FFFFFF&
      Height          =   495
      Left            =   0
      TabIndex        =   15
      Top             =   8640
      Width           =   2775
      WordWrap        =   -1  'True
   End
   Begin VB.Label lblYSelected 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H00000000&
      Height          =   255
      Left            =   8160
      TabIndex        =   13
      Top             =   0
      Width           =   1815
   End
   Begin VB.Label lblXSelected 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   4440
      TabIndex        =   12
      Top             =   0
      Width           =   1865
   End
   Begin VB.Label lblYcoord 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   6480
      TabIndex        =   10
      Top             =   0
      Width           =   1575
   End
   Begin VB.Label lblXcoord 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H80000008&
      Height          =   255
      Left            =   2760
      TabIndex        =   9
      Top             =   0
      Width           =   1575
   End
   Begin VB.Label lblLibAircraft 
      Alignment       =   2  'Center
      BackColor       =   &H00B0FFFF&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Library Aircraft"
      ForeColor       =   &H00000000&
      Height          =   255
      Left            =   150
      TabIndex        =   8
      Top             =   2160
      Width           =   2415
   End
   Begin VB.Label lblACGroup 
      Alignment       =   2  'Center
      BackColor       =   &H00B0FFFF&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Aircraft Group"
      ForeColor       =   &H00000000&
      Height          =   255
      Left            =   150
      TabIndex        =   7
      Top             =   240
      Width           =   2415
   End
End
Attribute VB_Name = "frmGear"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim NM1 As Integer, lstAircraftName$
Dim MaxGWFlexible As Boolean
'Dim ACNBatchOutput

Dim Dragging As Boolean, DragX As Single, DragY As Single
' Public frmGearCaptionStart As String In Global.

Private Sub FlexibleandRigidMGW(PavementType As String)

  Dim I As Long, NAircraft As Long, LoopStart As Long, LoopEnd As Long
  Dim lstLibFileListIndexSave As Integer
  Dim Thick As Double, MGW As Double, MGWCoverages As Double
  Dim S As String, SS As String
    
  If chkMGWcovs.Value = vbChecked And chkBatch.Value = vbChecked Then
    Ret = MsgBox("This function is not available in batch mode.", vbOKOnly, "Function Not Available")
    Exit Sub
  End If
  
  NAircraft = lstLibFile.ListCount
  lstLibFileListIndexSave = lstLibFile.ListIndex
  If chkBatch.Value = vbChecked Then ' All aircraft in the list.
    LoopStart = 0
    LoopEnd = NAircraft - 1
  Else                               ' The currently selected aircraft.
    LoopStart = lstLibFileListIndexSave
    LoopEnd = lstLibFileListIndexSave
  End If
  
  If PavementType = "Flexible" Then
    MaxGWFlexible = True ' Needed by Sub GetMGW().
  
    S = "Library file name = " & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext" & vbCrLf & vbCrLf
    S = S & "Evaluation pavement type is flexible and design procedure is CBR" & vbCrLf
    If chkNew07Alphas.Value = vbChecked Then
      SS = "Alpha Values are those approved by the ICAO in 2007." & vbCrLf
    Else
      SS = "Alpha Values are those used in AC 150/5320-6C/D design charts." & vbCrLf
    End If
    S = S & SS & vbCrLf
    S = S & "                                         CBR = " & Format(InputCBR, "0.00") & vbCrLf
    S = S & "               Evaluation pavement thickness = "
    S = S & Format(EvalThick * UnitsOut.inch, UnitsOut.inchFormat) & " " & UnitsOut.inchName & vbCrLf & vbCrLf
    If UnitsOut.Metric Then SS = "Metric." Else SS = "Imperial."
    S = S & "Results Table: Maximum Allowable Gross Weight Computations, Units = " & SS & vbCrLf

    S = S & "                             Gross   Percent    Tire     Annual    6D      20-yr      Max. Allowable" & vbCrLf
    S = S & " No.  Aircraft Name          Weight  Gross Wt   Press     Deps    Thick  Coverages     Gross Weight" & vbCrLf
    S = S & "----------------------------------------------------------------------------------------------------------" & vbCrLf
    SS = S
    
    S = ""
    For I = LoopStart To LoopEnd
      lstLibFile.ListIndex = I
      Call GetMGW("MGWOnly", MGW, MGWCoverages, Thick)
      S = S & LPad(3, Format(I + 1, "0")) & "  " & RPad(21, lstLibFile.Text)
      S = S & LPad(9, Format(GrossWeight * UnitsOut.pounds, UnitsOut.poundsFormat))
      S = S & LPad(8, Format(PcntOnMainGears, "0.00"))
      S = S & LPad(10, Format(TirePressure * UnitsOut.psi, UnitsOut.psiFormat))
      S = S & LPad(10, Format(AnnualDepartures, "#,###,##0"))
      S = S & LPad(8, Format(Thick * UnitsOut.inch, UnitsOut.inchFormat))
      S = S & LPad(10, Format(MGWCoverages, "#,###,##0"))
      S = S & LPad(15, Format(MGW * UnitsOut.pounds, UnitsOut.poundsFormat)) & vbCrLf
    Next I

  Else
    MaxGWFlexible = False ' Needed by Sub GetMGW().
      
    S = "Library file name = " & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext" & vbCrLf & vbCrLf
    S = S & "Evaluation pavement type is rigid" & vbCrLf
    S = S & SS & vbCrLf
    If chkPCAforGrossWeight.Value = vbChecked Then
      SS = "Maximum gross weight computed with the PCA interior stress design method."
    Else
      SS = "Maximum gross weight computed with the AC 150/5320-6C/D edge stress design method."
    End If
    S = S & SS & vbCrLf & vbCrLf
    S = S & "                                     k Value = "
    S = S & Format(InputkValue * UnitsOut.pci, UnitsOut.pciFormat) & " " & UnitsOut.pciName & vbCrLf
    S = S & "                           flexural strength = "
    S = S & Format(ConcreteFlexuralStrength * UnitsOut.psi, UnitsOut.psiFormat) & " " & UnitsOut.psiName & vbCrLf
    S = S & "               Evaluation pavement thickness = "
    S = S & Format(EvalThick * UnitsOut.inch, UnitsOut.inchFormat) & " " & UnitsOut.inchName & vbCrLf & vbCrLf
    
    If UnitsOut.Metric Then SS = "Metric." Else SS = "Imperial."
    S = S & "Results Table: Maximum Allowable Gross Weight Computations, Units = " & SS & vbCrLf
    
    S = S & "                             Gross   Percent    Tire     Annual    6D      20-yr      Max. Allowable" & vbCrLf
    S = S & " No.  Aircraft Name          Weight  Gross Wt   Press     Deps    Thick  Coverages     Gross Weight" & vbCrLf
    S = S & "----------------------------------------------------------------------------------------------------------" & vbCrLf
    SS = S
    
    S = ""
    
'      For I = 0 To lstLibFile.ListCount - 1
    For I = LoopStart To LoopEnd
      lstLibFile.ListIndex = I
      Call GetMGW("MGWOnly", MGW, MGWCoverages, Thick)
      S = S & LPad(3, Format(I + 1, "0")) & "  " & RPad(21, lstLibFile.Text)
      S = S & LPad(9, Format(GrossWeight * UnitsOut.pounds, UnitsOut.poundsFormat))
      S = S & LPad(8, Format(PcntOnMainGears, "0.00"))
      S = S & LPad(10, Format(TirePressure * UnitsOut.psi, UnitsOut.psiFormat))
      S = S & LPad(10, Format(AnnualDepartures, "#,###,##0"))
      S = S & LPad(8, Format(Thick * UnitsOut.inch, UnitsOut.inchFormat))
      S = S & LPad(10, Format(MGWCoverages, "#,###,##0"))
      S = S & LPad(15, Format(MGW * UnitsOut.pounds, UnitsOut.poundsFormat)) & vbCrLf
    Next I
    
  End If ' Pavement Type.

  lstLibFile.ListIndex = lstLibFileListIndexSave
  MGWOutputText = SS & S
  frmACN.optCalcMode(4).Value = True
  
End Sub

Private Sub btnLESS_Click()

' Reset to PCN mode.
  If Not optCalcMode(2).Value Then
    optCalcMode(2).Value = True
  End If
  
  fraPCNBatchMode.Visible = True

  fraCompMode.Visible = False

End Sub

Private Sub btnMORE_Click()

  fraPCNBatchMode.Visible = False

  fraCompMode.Visible = True
  
End Sub

Private Sub btnPCN_flexible_Click()

  Dim chkBatchSave As Long

  If ACNOnly Then
  
    optCalcMode(0).Value = True ' Sets ACN mode. GFH 1/27/12.
    Call cmdFlexibleCompute_Click ' Computes Coverages first. GFH 9/28/09.
    
  Else
  
    optCalcMode(2).Value = True ' Sets PCN mode. GFH 9/28/09.
    chkBatchSave = chkBatch.Value
    chkBatch.Value = vbChecked
    Call cmdFlexibleCompute_Click ' Computes Coverages first. GFH 9/28/09.
    chkBatch.Value = chkBatchSave
  
  End If
  
End Sub

Private Sub btnPCN_rigid_Click()

  Dim chkBatchSave As Long
 
  If ACNOnly Then
  
    optCalcMode(0).Value = True ' Sets ACN mode. GFH 1/27/12.
    Call cmdRigidCompute_Click ' Computes Coverages first. GFH 9/28/09.
    
  Else
  
    optCalcMode(2).Value = True ' Sets PCN mode. GFH 9/28/09.
'    chkBatch.Value = chkBatchSave
    chkBatchSave = chkBatch.Value
    chkBatch.Value = vbChecked
    Call cmdRigidCompute_Click ' Computes Coverages first. GFH 9/28/09.
    chkBatch.Value = chkBatchSave
  
  End If
  
End Sub

Private Sub chkNew07Alphas_Click()

  If chkNew07Alphas.Value = vbChecked Then
    Call Disclaimer07Alphas ' In modAlpha.
  End If

' Reset output tables to zero out Alpha and ACN data.
  AlphaFactor = InputAlpha
  Call ResetOutputs
  Call PlotGear ' Also calls GearCG and updates the parameter output grid.
  Call WriteOutputGrid
  ACNFlexibleOutputText = "" ' Text for the Details window.
  
End Sub

'Izydor Kawa code added
Public Sub chkUnitsConversion_Click()
  With UnitsOut
    If chkUnitsConversion.Value Then
'     Multiply by these to output from English to Metric.
'     Divide by these to input from Metric to English.
      .Name = "Metric"
      .Metric = True
      .inch = 25.4             ' to mm
      .inchName = "mm"
      .inchFormat = "#,##0.0"
      .squareInch = .inch * .inch     'ik03
      .squareInchName = "mm^2"        'ik03
      .squareInchFormat = "#,##0"   'ik03
      .pounds = 1 / 2204.6225  ' to tonnes
      .poundsName = "tonnes"
      .poundsFormat = "#,##0.000"
      .psi = 6.894757          ' to kPa
      .psiName = "kPa"
      .psiFormat = "#,##0"
      .psiMPa = 0.006894757    ' to MPa
      .psiMPaName = "MPa"
      .psiMPaFormat = "#,##0.00"
      .pci = 0.27144716        ' to MN/m^3
      .pciName = "MN/m^3"      ' Changed from kg/cm^3 on 06-08-04, GFH.
      .pciFormat = "#,##0.0"
      .covFormat = "#,###,##0"
    Else
'     Use these to input/output from English to English.
      .Name = "English"
      .Metric = False
      .inch = 1
      .inchName = "in"
      .inchFormat = "#,##0.00"
      .squareInch = .inch * .inch     'ik03
      .squareInchName = "in^2"        'ik03
      .squareInchFormat = "#,##0.0" 'ik03 GFH 01/21/03
      .pounds = 1
      .poundsName = "lbs"
      .poundsFormat = "#,###,##0"
      .psi = 1
      .psiName = "psi"
      .psiFormat = "#,##0.0"  '  GFH 01/21/03
      .psiMPa = 1
      .psiMPaName = "psi"
      .psiMPaFormat = "#,##0"
      .pci = 1
      .pciName = "lbs/in^3"
      .pciFormat = "#,##0.0"
      .covFormat = "#,###,##0"
    End If
  End With
  
  If lblXSelected.Caption <> "" Then 'added by Izydor Kawa
    lblXSelected.Caption = "X Sel. = " & Format(LastXP * UnitsOut.inch, "#,##0.00") & " " + UnitsOut.inchName
    lblYSelected.Caption = "Y Sel. = " & Format(LastYP * UnitsOut.inch, "#,##0.00") & " " + UnitsOut.inchName
  End If

  txtEvaluationThickness.Text = EvalThick * UnitsOut.inch
  Call MainSetGrids
  Call WriteParmGrid
  Call WriteOutputGrid

End Sub 'Izydor Kawa code end
Private Sub cmdAbout_Click()
  Dim VV As Double, UU As Double, I As Long
  frmAboutBox.Show
  Exit Sub
'  For I = 1 To 170
  For I = 1 To 20
'    UU = Log10(U(I))
    UU = Log10(-I * 0.00005 + 0.0005)
    VV = -0.0481 - 1.1562 * UU - 0.6414 * UU * UU - 0.473 * UU * UU * UU
    Debug.Print VV  'I; UU; VV; V(I)
  Next I
  Exit Sub
End Sub

Private Sub FlexibleThickness()
  
  Dim I As Long, ListIndexSave As Long
  Dim CBRsave As Double
  Dim S As String, Scomma As String, SESWL As String, SThick As String, FullFileName As String
    
  CBRsave = InputCBR
  If CBRsave = 0 Then
    S = "Please click on the CBR title cell" & vbCrLf & "in the output grid and enter a CBR value."
    MsgBox S, vbOKOnly, "Input CBR Value Required"
    Exit Sub
  End If
  
  fraCompMode.Enabled = False
  chkUnitsConversion.Enabled = False
  cmdRigidCompute.Enabled = False
  cmdFlexibleCompute.Enabled = False

  S = "  Flexible Pavement Thickness Design by the CBR Method - Units are "
  If UnitsOut.Metric Then S = S & "Metric" & vbCrLf Else S = S & "English" & vbCrLf
  S = S & " No.     Aircraft Name     Gross Wt.  Ann. Deps.  Coverages    CBR      ESWL  Des. Thickness" & vbCrLf
  Scomma = ""
  SESWL = "":  SThick = ""
  
  If Not chkBatch = vbChecked Then ' Design for current aircraft only.
  
'    TirePressure = GrossWeight * PcntOnMainGears / NWheels / NMainGears / TireContactArea / 100 'ik0333
    Call FlexibleACN
    S = S & LPad(3, Format(I + 1, "0")) & "  " & (RPad(20, lstLibFile.Text))
    grdParms.Col = 1: grdParms.Row = GrossWeightRow:
    S = S & LPad(10, grdParms.Text)
    grdParms.Row = AnnualDeparturesRow 'CoveragesRow
     S = S & LPad(10, grdParms.Text)
    grdParms.Row = FlexibleCoveragesRow
    S = S & LPad(12, grdParms.Text)
    FlexDesignESWL = FlexDesignESWL * UnitsOut.pounds ' set in ACNFlexBas Sub WriteFlexibleOutputData.
    S = S & LPad(10, Format(CBRsave, "#,##0.000"))
    SESWL = SESWL & LPad(10, Format(FlexDesignESWL * UnitsOut.pounds, UnitsOut.poundsFormat)) & vbCrLf
    S = S & LPad(10, Format(FlexDesignESWL * UnitsOut.pounds, UnitsOut.poundsFormat))
    grdOutput.Col = CBRtCol:  grdOutput.Row = 4
    SThick = SThick & LPad(10, grdOutput.Text) & vbCrLf
    S = S & LPad(10, grdOutput.Text) & vbCrLf
    ThicknessOutputText = S
    frmACN.optCalcMode(2).Value = True
      
  Else ' Design for all aircraft in the current lstLibFile.
  
    ListIndexSave = lstLibFile.ListIndex
    For I = 0 To lstLibFile.ListCount - 1
      lstLibFile.ListIndex = I
      InputCBR = CBRsave
'      TirePressure = GrossWeight * PcntOnMainGears / NWheels / NMainGears / TireContactArea / 100 'ik0333
      Call FlexibleACN
      S = S & LPad(3, Format(I + 1, "0")) & "  " & (RPad(20, lstLibFile.Text))
      Scomma = Scomma & Format(I + 1, "0") & "," & lstLibFile.Text & ","
      grdParms.Col = 1: grdParms.Row = GrossWeightRow:
      S = S & LPad(10, grdParms.Text)
      Scomma = Scomma & Format(CLng(grdParms.Text), "0") & ","
      grdParms.Row = AnnualDeparturesRow 'CoveragesRow
      S = S & LPad(10, grdParms.Text)
      'Scomma = Scomma & Format(CLng(grdParms.Text), "0") & ","
      Scomma = Scomma & Format(CDbl(grdParms.Text), "0") & ","
      grdParms.Row = FlexibleCoveragesRow
      S = S & LPad(12, grdParms.Text)
      'Scomma = Scomma & Format(CLng(grdParms.Text), "0") & ","
      Scomma = Scomma & Format(CDbl(grdParms.Text), "0") & ","
      
      FlexDesignESWL = FlexDesignESWL * UnitsOut.pounds ' set in ACNFlexBas Sub WriteFlexibleOutputData.
      S = S & LPad(10, Format(CBRsave, "#,##0.000"))
      Scomma = Scomma & Format(CBRsave, "0.000") & ","
      SESWL = SESWL & LPad(10, Format(FlexDesignESWL * UnitsOut.pounds, UnitsOut.poundsFormat)) & vbCrLf
      S = S & LPad(10, Format(FlexDesignESWL * UnitsOut.pounds, UnitsOut.poundsFormat))
      Scomma = Scomma & Format(FlexDesignESWL * UnitsOut.pounds, "0") & ","
      grdOutput.Col = CBRtCol:  grdOutput.Row = 4
      SThick = SThick & LPad(10, grdOutput.Text) & vbCrLf
      S = S & LPad(10, grdOutput.Text) & vbCrLf
      Scomma = Scomma & Trim(grdOutput.Text) & vbCrLf
    Next I
    lstLibFile.ListIndex = ListIndexSave ' Return to original aircraft.
  
    Debug.Print S
    Debug.Print SESWL
    Debug.Print SThick
    
'    FullFileName = ExtFilePath$ & "FlexBatchOutput.txt"
'    If Dir(FullFileName) <> "" Then Kill FullFileName
'    I = FreeFile
'    Open FullFileName For Output As I
'    Print #I, S
'    Close (I)
  
'    FullFileName = ExtFilePath$ & "FlexBatchOutputComma.txt"
'    If Dir(FullFileName) <> "" Then Kill FullFileName
'    I = FreeFile
'    Open FullFileName For Output As I
'    Print #I, Scomma
'    Close (I)
    
    ThicknessOutputText = S
    frmACN.optCalcMode(2).Value = True
    
  End If
    
  fraCompMode.Enabled = True
  chkUnitsConversion.Enabled = True
  cmdRigidCompute.Enabled = True
  cmdFlexibleCompute.Enabled = True
    
End Sub

Private Sub FlexibleACNforBatch(Caller As String)
  
  Dim I As Long, J As Long, ListIndexSave As Long, ICAOCodeIndex As Long
  Dim CBRsave As Double
  Dim S As String, Scomma As String, SS As String, FullFileName As String
    
  fraCompMode.Enabled = False
  chkUnitsConversion.Enabled = False
  cmdRigidCompute.Enabled = False
  cmdFlexibleCompute.Enabled = False
  
  ReDim ACNInputACrtn(0 To lstLibFile.ListCount - 1, 1 To 4)
  
  If Not chkBatch = vbChecked Then  ' Design for current aircraft only.
  
'    TirePressure = GrossWeight * PcntOnMainGears / NWheels / NMainGears / TireContactArea / 100 'ik0333
    Call FlexibleACN
    I = lstLibFile.ListIndex
    For J = 1 To 4:  ACNInputACrtn(I, J) = ACNFlex(J):  Next J
  
  Else ' Design for all aircraft in the current lstLibFile.

    If Caller = "FromACN" Then
    
      S = S & "Flexible ACN at Indicated Gross Weight and Strength. Units = " & UnitsOut.Name & "." & vbCrLf
      S = S & " No. Aircraft Name          Gross    % GW on     Tire       ACN at Indicated Code" & vbCrLf
      S = S & "                            Weight  Main Gear  Pressure   A(15)  B(10)   C(6)   D(3)" & vbCrLf
      S = S & "------------------------------------------------------------------------------------" & vbCrLf
    
      Scomma = ""
  
      ListIndexSave = lstLibFile.ListIndex
      For I = 0 To lstLibFile.ListCount - 1
    
        lstLibFile.ListIndex = I
        Call FlexibleACN
        For J = 1 To 4:  ACNInputACrtn(I, J) = ACNFlex(J):  Next J
      
        S = S & LPad(3, Format(I + 1, "0")) & " " & (RPad(20, lstLibFile.Text))
        Scomma = Scomma & Format(I + 1, "0") & "," & lstLibFile.Text & ","
        grdParms.Col = 1: grdParms.Row = GrossWeightRow:
        S = S & LPad(10, grdParms.Text)
        grdParms.Row = PcntOnMainGearsRow:
        S = S & LPad(10, grdParms.Text)
        Scomma = Scomma & Format(CLng(grdParms.Text), "0") & ","
        grdParms.Row = TirePressureRow:
        S = S & LPad(10, grdParms.Text)
        Scomma = Scomma & Format(CLng(grdParms.Text), "0") & ","
        grdOutput.Col = ACNFlexCol
        grdOutput.Row = 4
        S = S & LPad(9, grdOutput.Text)
        Scomma = Scomma & Format(CDbl(grdOutput.Text), "0.00") & ","
        grdOutput.Row = 3
        S = S & LPad(7, grdOutput.Text)
        Scomma = Scomma & Format(CDbl(grdOutput.Text), "0.00") & ","
        grdOutput.Row = 2
        S = S & LPad(7, grdOutput.Text)
        Scomma = Scomma & Format(CDbl(grdOutput.Text), "0.00") & ","
        grdOutput.Row = 1
        S = S & LPad(7, grdOutput.Text) & vbCrLf
        Scomma = Scomma & Format(CDbl(grdOutput.Text), "0.00") & vbCrLf
      
      Next I
    
    Else
    
      If InputCBR >= 13 Then
        ICAOCodeIndex = 4: SS = "A(15)"
      ElseIf 8 < InputCBR And InputCBR < 13 Then
        ICAOCodeIndex = 3: SS = "B(10)"
      ElseIf 4 < InputCBR And InputCBR <= 8 Then
        ICAOCodeIndex = 2: SS = "C(6)"
      ElseIf InputCBR <= 4 Then
        ICAOCodeIndex = 1: SS = "D(3)"
      End If
    
      S = S & "Results Table 3. Flexible ACN at Indicated Gross Weight and Strength" & vbCrLf
      S = S & " No. Aircraft Name          Gross    % GW on     Tire       ACN      ACN on" & vbCrLf
      S = S & "                            Weight  Main Gear  Pressure    Thick      " & SS & vbCrLf
      S = S & "--------------------------------------------------------------------------" & vbCrLf
    
      Scomma = ""
  
      ListIndexSave = lstLibFile.ListIndex
      For I = 0 To lstLibFile.ListCount - 1
    
        lstLibFile.ListIndex = I
        Call FlexibleACN
        For J = 1 To 4
          ACNInputACrtn(I, J) = ACNFlex(J)
        Next J
      
        S = S & LPad(3, Format(I + 1, "0")) & " " & (RPad(20, lstLibFile.Text))
        grdParms.Col = 1: grdParms.Row = GrossWeightRow:
        S = S & LPad(10, grdParms.Text)
        grdParms.Row = PcntOnMainGearsRow:
        S = S & LPad(10, grdParms.Text)
        grdParms.Row = TirePressureRow:
        S = S & LPad(10, grdParms.Text)
        grdOutput.Row = ICAOCodeIndex
        grdOutput.Col = CBRtCol
        S = S & LPad(10, grdOutput.Text)
        grdOutput.Col = ACNFlexCol
        S = S & LPad(10, grdOutput.Text) & vbCrLf
      
      Next I
        
    End If
    
    lstLibFile.ListIndex = ListIndexSave ' Return to original aircraft.
  
'    FullFileName = ExtFilePath$ & "FlexBatchACNOutput.txt" ' Commented out by GFH 01-05-12.
'    If Dir(FullFileName) <> "" Then Kill FullFileName
'    I = FreeFile
'    Open FullFileName For Output As I
'    Print #I, S
'    Close (I)
    
'    FullFileName = ExtFilePath$ & "FlexBatchACNOutputComma.txt"
'    If Dir(FullFileName) <> "" Then Kill FullFileName
'    I = FreeFile
'    Open FullFileName For Output As I
'    Print #I, Scomma
'    Close (I)
    
    ACNBatchOutputText = S
    frmACN.optCalcMode(1).Value = True
    
  End If
    
  fraCompMode.Enabled = True
  chkUnitsConversion.Enabled = True
  cmdRigidCompute.Enabled = True
  cmdFlexibleCompute.Enabled = True
    
End Sub

Private Sub RigidACNforBatch(Caller As String)
  
  Dim I As Long, J As Long, ListIndexSave As Long, ICAOCodeIndex As Long
  Dim CBRsave As Double, DTemp As Double
  Dim S As String, Scomma As String, SS As String, FullFileName As String
    
  fraCompMode.Enabled = False
  chkUnitsConversion.Enabled = False
  cmdRigidCompute.Enabled = False
  cmdFlexibleCompute.Enabled = False

  ReDim ACNInputACrtn(0 To lstLibFile.ListCount - 1, 1 To 4)
  
  If Not chkBatch = vbChecked Then ' Design for current aircraft only.
  
'    TirePressure = GrossWeight * PcntOnMainGears / NWheels / NMainGears / TireContactArea / 100 'ik0333
    Call RigidACN
    I = lstLibFile.ListIndex
    For J = 1 To 4:  ACNInputACrtn(I, J) = ACNRigid(J):  Next J
  
  Else ' Design for all aircraft in the current lstLibFile.
  
    If Caller = "FromACN" Then
    
      S = S & "Rigid ACN at Indicated Gross Weight and Strength. Units = " & UnitsOut.Name & "." & vbCrLf
      S = S & " No. Aircraft Name          Gross    % GW on     Tire      ACN at Indicated Code" & vbCrLf
      If UnitsOut.Metric Then
        S = S & "                            Weight  Main Gear  Pressure  A(150)  B(80)  C(40)  D(20)" & vbCrLf
      Else
        S = S & "                            Weight  Main Gear  Pressure  A(552) B(295) C(147)  D(74)" & vbCrLf
      End If
      S = S & "------------------------------------------------------------------------------------" & vbCrLf
    
      Scomma = ""
  
      ListIndexSave = lstLibFile.ListIndex
      For I = 0 To lstLibFile.ListCount - 1
    
        lstLibFile.ListIndex = I
        Call RigidACN
        For J = 1 To 4:  ACNInputACrtn(I, J) = ACNRigid(J):  Next J
      
        S = S & LPad(3, Format(I + 1, "0")) & " " & (RPad(20, lstLibFile.Text))
        Scomma = Scomma & Format(I + 1, "0") & "," & lstLibFile.Text & ","
        grdParms.Col = 1: grdParms.Row = GrossWeightRow:
        S = S & LPad(10, grdParms.Text)
        Scomma = Scomma & Format(CLng(grdParms.Text), "0") & ","
        grdParms.Row = PcntOnMainGearsRow:
        S = S & LPad(10, grdParms.Text)
        grdParms.Row = TirePressureRow:
        S = S & LPad(10, grdParms.Text)
        Scomma = Scomma & Format(CLng(grdParms.Text), "0") & ","
        grdOutput.Col = ACNRigCol
        grdOutput.Row = 4
        S = S & LPad(9, grdOutput.Text)
        Scomma = Scomma & Format(CDbl(grdOutput.Text), "0.00") & ","
        grdOutput.Row = 3
        S = S & LPad(7, grdOutput.Text)
        Scomma = Scomma & Format(CDbl(grdOutput.Text), "0.00") & ","
        grdOutput.Row = 2
        S = S & LPad(7, grdOutput.Text)
        Scomma = Scomma & Format(CDbl(grdOutput.Text), "0.00") & ","
        grdOutput.Row = 1
        S = S & LPad(7, grdOutput.Text) & vbCrLf
        Scomma = Scomma & Format(CDbl(grdOutput.Text), "0.00") & vbCrLf
      
      Next I
    
    Else
    
      If InputkValue >= 442 Then
        DTemp = Int(150# / 0.27144716)
        ICAOCodeIndex = 4: SS = "A(" & Format(DTemp * UnitsOut.pci, "0") & ")"
      ElseIf 221 < InputkValue And InputkValue < 442 Then
        DTemp = 80# / 0.27144716:
        ICAOCodeIndex = 3: SS = "B(" & Format(DTemp * UnitsOut.pci, "0") & ")"
      ElseIf 92 < InputkValue And InputkValue <= 221 Then
        DTemp = 40# / 0.27144716:
        ICAOCodeIndex = 2: SS = "C(" & Format(DTemp * UnitsOut.pci, "0") & ")"
      ElseIf InputkValue <= 92 Then
        DTemp = 20# / 0.27144716:
        ICAOCodeIndex = 1: SS = "D(" & Format(DTemp * UnitsOut.pci, "0") & ")"
      End If
    
      S = S & "Results Table 3. Rigid ACN at Indicated Gross Weight and Strength" & vbCrLf
      S = S & " No. Aircraft Name          Gross    % GW on     Tire       ACN     ACN on" & vbCrLf
      S = S & "                            Weight  Main Gear  Pressure    Thick    " & SS & vbCrLf
      S = S & "--------------------------------------------------------------------------" & vbCrLf
    
      Scomma = ""
  
      ListIndexSave = lstLibFile.ListIndex
      For I = 0 To lstLibFile.ListCount - 1
    
        lstLibFile.ListIndex = I
        Call RigidACN
        For J = 1 To 4
          ACNInputACrtn(I, J) = ACNRigid(J)
        Next J
      
        S = S & LPad(3, Format(I + 1, "0")) & " " & (RPad(20, lstLibFile.Text))
        grdParms.Col = 1: grdParms.Row = GrossWeightRow:
        S = S & LPad(10, grdParms.Text)
        grdParms.Row = PcntOnMainGearsRow:
        S = S & LPad(10, grdParms.Text)
        grdParms.Row = TirePressureRow:
        S = S & LPad(10, grdParms.Text)
        grdOutput.Row = ICAOCodeIndex
        grdOutput.Col = RigtCol
        S = S & LPad(10, grdOutput.Text)
        grdOutput.Col = ACNRigCol
        S = S & LPad(10, grdOutput.Text) & vbCrLf
      
      Next I
        
    End If
    
    lstLibFile.ListIndex = ListIndexSave ' Return to original aircraft.
  
'    FullFileName = ExtFilePath$ & "RigidBatchACNOutput.txt" ' Commented out by GFH 01-05-12.
'    If Dir(FullFileName) <> "" Then Kill FullFileName
'    I = FreeFile
'    Open FullFileName For Output As I
'    Print #I, S
'    Close (I)
  
'    FullFileName = ExtFilePath$ & "RigidBatchACNOutputComma.txt"
'    If Dir(FullFileName) <> "" Then Kill FullFileName
'    I = FreeFile
'    Open FullFileName For Output As I
'    Print #I, Scomma
'    Close (I)
    
    ACNBatchOutputText = S
    frmACN.optCalcMode(1).Value = True
    
  End If
    
  fraCompMode.Enabled = True
  chkUnitsConversion.Enabled = True
  cmdRigidCompute.Enabled = True
  cmdFlexibleCompute.Enabled = True
    
End Sub

Private Sub RigidACN()

  Dim I As Integer, cmdCaption$, S$
  Dim kValueSave As Double
  
  On Error GoTo RigidACNErr

  If Not ComputingRigid Then
  
    lblMessage.Caption = "Computing Rigid"
    cmdCaption$ = cmdRigidCompute.Caption
    cmdRigidCompute.Caption = "Stop Rigid"
    
    fraCompMode.Enabled = False
    fraEditWheels.Enabled = False
    'fraLibraryFunctions.Enabled = False
    cmdExit.Enabled = False
    lstACGroup.Enabled = False
    lstLibFile.Enabled = False
    cmdFlexibleCompute.Enabled = False
  
    For I = 1 To NSubgrades
      ACNRigidk(I) = 0
      RigidThickness(I) = 0
      ACNRigid(I) = 0
    Next I
    Call WriteOutputGrid
    ComputingRigid = True
  
'    Izydor Kawa code Begin
'    Call ACNRigComp old version for center stress with PCA progam.
   
    If ACN_mode_true Then
      kValueSave = InputkValue
      InputkValue = 0#
      Call ACNRigComp
      InputkValue = kValueSave
    Else
      Coverages = RigidCoverages
      If Not SamePcntAndPress Then
        TirePressure = GrossWeight * PcntOnMainGears / NWheels / NMainGears / TireContactArea / 100
      End If
      If chkPCAThicknessDesign.Value = vbChecked Then ' GFH 05-08-08.
        Call ACNRigComp
      Else
        Call ThicknessDesign ' Edge stress using H-51 program.
      End If
    End If
'   Izydor Kawa code End

  Else
  
    StopComputation = True
    Exit Sub
    
  End If
    
  Call WriteParmGrid
  Call WriteOutputGrid
  Call PlotGear
  
  ComputingRigid = False
  
'  If ACN_mode_true Then
    cmdRigidCompute.Enabled = True
    cmdFlexibleCompute.Enabled = True
'  End If

  lblMessage.Caption = "Rigid Computation Finished"
  cmdRigidCompute.Caption = cmdCaption$
  fraEditWheels.Enabled = True
'  fraLibraryFunctions.Enabled = True
  cmdExit.Enabled = True
  lstACGroup.Enabled = True
  lstLibFile.Enabled = True
  fraCompMode.Enabled = True 'ik004
  
  Exit Sub

RigidACNErr:

  S$ = "An unexpected error has occurred:" & vbCrLf & vbCrLf
  S$ = S$ & "Number =" & Str(Err.Number) & vbCrLf
  S$ = S$ & "Source = " & Err.Source & vbCrLf
  S$ = S$ & "Description = " & Err.Description
  I = MsgBox(S$, vbOKOnly, "Unexpected Error")
  Close
  Resume Next

End Sub

Private Sub RigidThicknessEdge()
' Also computes for Westergaard interior stress if PCA method checked.
  
  Dim I As Long, ListIndexSave As Long
  Dim Ksave As Double, RRS As Double
  Dim S As String, SS As String
  Dim Scomma As String, SESWL As String, SThick As String, FullFileName As String
    
  If cmdRigidCompute.Caption = "Stop Rigid" Then
    ComputingRigid = False
    Exit Sub
  End If
    
  Ksave = InputkValue
  If Ksave = 0 Then
    S = "Please click on the k Value title cell" & vbCrLf & "in the output grid and enter a k value."
    MsgBox S, vbOKOnly, "Input k Value Required"
    Exit Sub
  End If
  
  fraCompMode.Enabled = False
  chkUnitsConversion.Enabled = False
  cmdRigidCompute.Enabled = False
  cmdFlexibleCompute.Enabled = False

  If chkPCAThicknessDesign.Value = vbChecked Then
    S = "      Rigid Pavement Thickness Design by the PCA Interior Stress Method" & vbCrLf
  Else
    S = "      Rigid Pavement Thickness Design by the AC 150/5320-6C/D Edge Stress Method" & vbCrLf
  End If
  S = S & Space(22) & "Units = "
  If UnitsOut.Metric Then S = S & "Metric, " Else S = S & "English, "
  S = S & "k Value = " & Format(Ksave * UnitsOut.pci, UnitsOut.pciFormat) & " " & UnitsOut.pciName & vbCrLf
'  S = S & "Radius of Relative Stiffness = " & Format(RRS * UnitsOut.inch, UnitsOut.inchFormat) & vbCrLf
  If optCalcMode(4) Or optCalcMode(5) Then SS = "    Stress   " Else SS = "Des. Thickness"
'  S = S & " No.     Aircraft Name     Gross Wt.  Ann. Deps.  Coverages   k Value  " & SS
  S = S & " No.     Aircraft Name     Gross Wt.  Ann. Deps.  Coverages    RRS     " & SS & vbCrLf
  If UnitsOut.Metric Then
    S = S & Space(28) & UnitsOut.poundsName & Space(30) & UnitsOut.inchName
    If optCalcMode(4) Or optCalcMode(5) Then
      S = S & Space(12) & UnitsOut.psiMPaName & vbCrLf
    Else
      S = S & Space(12) & UnitsOut.inchName & vbCrLf
    End If
  Else
    S = S & Space(29) & UnitsOut.poundsName & Space(31) & UnitsOut.inchName
    If optCalcMode(4) Or optCalcMode(5) Then
      S = S & Space(12) & UnitsOut.psiMPaName & vbCrLf
    Else
      S = S & Space(12) & UnitsOut.inchName & vbCrLf
    End If
  End If
  Scomma = ""
  SThick = ""
  
  If Not chkBatch = vbChecked Then ' Design for current aircraft only.
  
'    TirePressure = GrossWeight * PcntOnMainGears / NWheels / NMainGears / TireContactArea / 100 'ik0333
    Call RigidACN
'    S = S & "   RRS" & vbCrLf
    S = S & LPad(3, Format(I + 1, "0")) & "  " & (RPad(20, lstLibFile.Text))
    grdParms.Col = 1: grdParms.Row = GrossWeightRow:
    S = S & LPad(10, grdParms.Text)
    grdParms.Row = AnnualDeparturesRow
    S = S & LPad(10, grdParms.Text)
    grdParms.Row = RigidCoveragesRow
    S = S & LPad(12, grdParms.Text)
'    S = S & LPad(11, Format(Ksave * UnitsOut.pci, UnitsOut.pciFormat))
    RRS = ((4000000 * RigidThickness(1) ^ 3) / (12# * (1# - 0.15 * 0.15) * Ksave)) ^ 0.25
    S = S & "  " & CPad(12, Format(RRS * UnitsOut.inch, UnitsOut.inchFormat))
    If optCalcMode(4) Or optCalcMode(5) Then
      SS = txtStress.Text
    Else
      grdOutput.Col = RigtCol:  grdOutput.Row = 4
      SS = grdOutput.Text
    End If
    SThick = SThick & CPad(10, SS) & vbCrLf
    S = S & CPad(12, SS)
    ThicknessOutputText = S
    frmACN.optCalcMode(2).Value = True
    Debug.Print UnitsOut.inch; Ksave; RigidThickness(1)
  Else ' Design for all aircraft in the current lstLibFile.
  
    ListIndexSave = lstLibFile.ListIndex
    S = S & vbCrLf
    For I = 0 To lstLibFile.ListCount - 1
      lstLibFile.ListIndex = I
      InputkValue = Ksave
'      TirePressure = GrossWeight * PcntOnMainGears / NWheels / NMainGears / TireContactArea / 100 'ik0333
      Call RigidACN
      S = S & LPad(3, Format(I + 1, "0")) & "  " & (RPad(20, lstLibFile.Text))
      Scomma = Scomma & Format(I + 1, "0") & "," & lstLibFile.Text & ","
      grdParms.Col = 1: grdParms.Row = GrossWeightRow:
      S = S & LPad(10, grdParms.Text)
      Scomma = Scomma & Format(CLng(grdParms.Text), "0") & ","
      grdParms.Row = AnnualDeparturesRow
      S = S & LPad(10, grdParms.Text)
      Scomma = Scomma & Format(CLng(grdParms.Text), "0") & ","
      grdParms.Row = RigidCoveragesRow
      S = S & LPad(12, grdParms.Text)
      Scomma = Scomma & Format(CLng(grdParms.Text), "0") & ","
      RRS = ((4000000 * RigidThickness(1) ^ 3) / (12# * (1# - 0.15 * 0.15) * Ksave)) ^ 0.25
      S = S & LPad(12, Format(RRS * UnitsOut.inch, UnitsOut.inchFormat))
      Scomma = Scomma & Format(RRS * UnitsOut.inch, UnitsOut.inchFormat) & ","
'      S = S & LPad(11, Format(Ksave * UnitsOut.pci, UnitsOut.pciFormat))
'      Scomma = Scomma & Format(Ksave * UnitsOut.pci, UnitsOut.pciFormat) & ","
      If optCalcMode(4) Or optCalcMode(5) Then
        SS = txtStress.Text
      Else
        grdOutput.Col = RigtCol:  grdOutput.Row = 4
        SS = grdOutput.Text
      End If
      SThick = SThick & LPad(10, SS) & vbCrLf
      S = S & LPad(12, SS) & vbCrLf
      Scomma = Scomma & Trim(grdOutput.Text) & vbCrLf
    Next I
'    InputkValue = Ksave
    lstLibFile.ListIndex = ListIndexSave ' Return to original aircraft.
  
    Debug.Print S
    Debug.Print SThick
  
'    FullFileName = ExtFilePath$ & "RigidBatchOutput.txt"
'    If Dir(FullFileName) <> "" Then Kill FullFileName
'    I = FreeFile
'    Open FullFileName For Output As I
'    Print #I, S
'    Close (I)
  
'    FullFileName = ExtFilePath$ & "RigidBatchOutputComma.txt"
'    If Dir(FullFileName) <> "" Then Kill FullFileName
'    I = FreeFile
'    Open FullFileName For Output As I
'    Print #I, Scomma
'    Close (I)
  
    ThicknessOutputText = S
    frmACN.optCalcMode(2).Value = True
  
  End If
    
  cmdRigidCompute.Enabled = True
  cmdFlexibleCompute.Enabled = True
  fraCompMode.Enabled = True
  chkUnitsConversion.Enabled = True
    
End Sub

Private Sub FlexibleACN()
' Also called by Sub FlexibleThickness, which reqires that InputCBR
' be set in ACNFlexComp. Sub FlexibleACN requires that InputCBR be
' set to zero in ACNFlexComp.

  Dim I As Integer, cmdCaption$, S$
  Dim CBRsave As Double
  
  On Error GoTo FlexibleACNErr
  
  CBRsave = InputCBR
  
  If Not ComputingFlexible Then
  
    If ACN_mode_true Then
      InputCBR = 0#
'    Else
'      Coverages = FlexibleCoverages
    End If
    
    lblMessage.Caption = "Computing Flexible"
    cmdCaption$ = cmdFlexibleCompute.Caption
    
    cmdFlexibleCompute.Caption = "Stop Flexible"
    
    fraCompMode.Enabled = False
    fraEditWheels.Enabled = False
'    fraLibraryFunctions.Enabled = False
    cmdExit.Enabled = False
    lstACGroup.Enabled = False
    lstLibFile.Enabled = False
    cmdRigidCompute.Enabled = False
  
    For I = 1 To NSubgrades
      ACNFlexCBR(I) = 0
      CBRThickness(I) = 0
      ACNFlex(I) = 0
    Next I
    Call WriteOutputGrid
    ComputingFlexible = True
  
    Call ACNFlexComp
    
  Else
  
    StopComputation = True
    Exit Sub
    
  End If
  
  Call WriteParmGrid
  Call WriteOutputGrid
  Call PlotGear
  ComputingFlexible = False
  
  InputCBR = CBRsave ' Write outputs first.
  lblMessage.Caption = "Flexible Computation Finished"
  cmdFlexibleCompute.Caption = cmdCaption$
  fraEditWheels.Enabled = True
'  fraLibraryFunctions.Enabled = True
  cmdExit.Enabled = True
  lstACGroup.Enabled = True
  lstLibFile.Enabled = True
  fraCompMode.Enabled = True
  cmdRigidCompute.Enabled = True
  
  Exit Sub

FlexibleACNErr:

  S$ = "An unexpected error has occurred in Sub FlexibleACN:" & vbCrLf & vbCrLf
  S$ = S$ & "Number =" & Str(Err.Number) & vbCrLf
  S$ = S$ & "Source = " & Err.Source & vbCrLf
  S$ = S$ & "Description = " & Err.Description
  I = MsgBox(S$, vbOKOnly, "Unexpected Error")
  Close
  Resume Next

End Sub



Private Sub cmdAddACtoLibrary_Click()

  Dim DupName As Boolean, InsertName$, S$
  
  S$ = "Enter a name for the aircraft." & NL2
  S$ = S$ & "This name will be used as the title" & vbCrLf
  S$ = S$ & "saved in the external library."
  
  InsertName$ = InputBox(S$, "Adding an Aircraft", lstLibFile.Text)
  If InsertName$ = "" Then Exit Sub
  
  Call InsertNewAircraft(InsertName$, DupName)
  Call UpdateDataFromLibrary(libIndex)
  
  If DupName Then Exit Sub
  
  Call WriteExternalFile
  
  lstACGroupIndex = lstACGroup.ListCount - 1
'  lstACGroup.ListIndex = lstACGroupIndex
'  ILibACGroup = lstACGroupIndex + 1
  If lstACGroupIndex = lstACGroup.ListIndex Then
    Call lstACGroup_Click
  Else
    lstACGroup.Selected(lstACGroupIndex) = True
  End If

End Sub

Private Sub cmdAddWheel_Click()
  Operation = AddWheel
  EditWheels = True 'Izydor Kawa code
End Sub

Private Sub cmdExit_Click()
  Unload Me
End Sub

Private Sub cmdPrint_Click()
  Dim IErr As Integer, S$, SS$
  
  On Error GoTo PrintError
  PrintForm
'  SavePicture picGear4.Image, "Struc.BMP"
  Exit Sub

PrintError:
  IErr = Err
  SS$ = "Printer Error"
  If IErr = 57 Then
    S$ = "There has been a printer error (" & Format(IErr, "0") & ")." & NL2
    S$ = S$ & "Please check the printer before retrying."
    Ret = MsgBox(S$, 0, SS$)
  ElseIf IErr = 68 Then
    S$ = "The printer is not online or is not connected." & NL2
    S$ = S$ & "Please check and retry printing."
    Ret = MsgBox(S$, 0, SS$)
  Else
    S$ = "There has been a printer error (" & Format(IErr, "0") & ")." & NL2
    S$ = S$ & "Please check the printer before retrying."
    Ret = MsgBox(S$, 0, SS$)
  End If
  Exit Sub

End Sub

Private Sub cmdFlexibleCompute_Click()

  Dim MGW As Double, CriticalACThick As Double
  
  lblMessage.Caption = ""
  
'  Coverages = FlexibleCoverages
  If optCalcMode(6) Then ' Life only from subroutine.
    Call FlexibleandRigidPCN("Flexible")
  ElseIf ACN_mode_true And Not PCN_mode_true Then
    Call FlexibleACNforBatch("FromACN")
  ElseIf Not ACN_mode_true And Not PCN_mode_true And Not MaxGrossWeightTrue Then
    Call FlexibleThickness
  ElseIf PCN_mode_true Then
    Call FlexibleandRigidPCN("Flexible")
  ElseIf MaxGrossWeightTrue Then
    Call FlexibleandRigidMGW("Flexible")
  End If
  
End Sub

Private Sub cmdHelp_Click()
  
  Dim nRet As Integer, I As Integer
  Const cdlHelpFinder As Integer = 15
' HELP_FINDER is 0x000b (= 11) in Winuser.h, but it starts
' Help with the Topics window set to the last used tab.
' HELP_TAB is 0x000f (= 15) in Winuser.h, with the Topics
' window tab set to the last OSWinHelp argument (0 = 1st tab).
' But it always starts Help with the Topics window tab set
' to Contents, just like HELP_FINDER is supposed to.
' And the Help system still does not work properly.
  
'  nRet = OSWinHelp(Me.hwnd, App.HelpFile, cdlHelpFinder, 0)

' SendKeys "{F1}"

  Dim dwCookie As Long ' Declared as Public for use in uninitialize in frmStartup.cmdExit.
'                         But dwCookie was not set to nonzero by HtmlHelp in testing.
  Const HH_INITIALIZE = &H1C
  Const HH_DISPLAY_TOPIC = &H0     ' Display topic identified by number in Data

'  SendKeys ("{F1}") ' Does not unload with application end.
'  The F1 key is handled by KeyDown in all of the major forms.
'  The application help file name is blank in the Ledfaa13 Properties dialog.

  dwCookie = 0 ' Null
'  HelpStarted = True
  Ret = HtmlHelp(CLng(0), vbNullString, HH_INITIALIZE, dwCookie)
  DoEvents ' For luck.
  
'  S$ = ACDATPath$ & "COMFAA.chm"
  S = App.HelpFile
'  Ret = HtmlHelp(frmStartup.hWnd, S$, HH_DISPLAY_TOPIC, CLng(0))
  Ret = HtmlHelp(CLng(0), S$, HH_DISPLAY_TOPIC, CLng(0))
  DoEvents ' For luck.
  
'  If HelpTopic = -1 Then
'    Ret = WinHelp(frmStartup.hWnd, S$, HELP_INDEX, CLng(HelpTopic))
'  Else
'    Ret = WinHelp(frmStartup.hWnd, S$, HELP_CONTEXT, CLng(HelpTopic))
'  End If
'  Ret = WinHelpBynum(frmStartup.hWnd, S$, HELP_INDEX, HelpTopic)


End Sub

Private Sub cmdLoadACfromLibrary_Click()

  Dim I As Integer, J As Integer, FullFileName$
  Static Started As Boolean
  On Error GoTo ReadFileError
  
  Call CheckChangedData
  If ChangeDataRet = vbCancel Then
    ChangeDataRet = 0
    Exit Sub
  End If
  
  ChangeDataRet = 0
  
  CdlFiles.InitDir = ExtFilePath$
  CdlFiles.Filter = "ext files|*.ext"
  CdlFiles.CancelError = True
  CdlFiles.ShowOpen  ' Skip rest of sub on Cancel.
  ExternalAircraftFileName$ = CdlFiles.FileTitle
  FullFileName$ = CdlFiles.FileName
  ExtFilePath$ = Left$(FullFileName$, Len(FullFileName$) - Len(ExternalAircraftFileName$))
  Debug.Print FullFileName$; " "; ExtFilePath$; " "; ExternalAircraftFileName$
  CdlFiles.InitDir = ExtFilePath$
'  FileExt$ = Right$(DatFileName$, 4)
  ExternalAircraftFileName$ = Left$(ExternalAircraftFileName$, Len(ExternalAircraftFileName$) - 4)
  libNAC = LibACGroup(ExternalLibraryIndex) - 1 ' Number of aircraft without the external library.
  J = libNAC
'  Call ReadExternalFile(J) ' Returns with libNAC increased by the number in the external file.
  Call ReadExternalFile(libNAC) ' Returns with libNAC increased by the number in the external file.
' Keep the file name inside the form caption area.
  I = frmGear.Width / 120 - Len(frmGearCaptionStart) - 5 ' 120 = twips / character.
  If I < Len(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext") Then S = "..." Else S = ""
  frmGear.Caption = frmGearCaptionStart & S & Right(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext", I)
' Could use TextWidth, but it would be more difficult.
' Debug.Print TextWidth(frmGear.Caption); Len(frmGear.Caption); frmGear.Width
    
  If lstACGroup.ListIndex = ExternalLibraryIndex - 1 Then
    libIndex = J + 1 ' First airplane in the new list, saved above.
    Call UpdateDataFromLibrary(libIndex)
    Call lstACGroup_Click
  End If

  Refresh
  
  ACNFlexibleOutputText$ = ""
  ACNRigidOutputText$ = ""
  ACNBatchOutputText = ""
  PCNOutputText$ = ""
  ThicknessOutputText = ""
  LifeOutputText = ""
  MGWOutputText = ""
  
  Exit Sub
  
ReadFileError:
  Debug.Print "Error No = "; Err
  If Err = cdlCancel Then Exit Sub
  Ret = MsgBox(Err.Description & " occurred reading the external airplane file.", vbOKOnly, "File Error")

End Sub

Private Sub cmdMoveWheel_Click()
  Operation = MoveWheel
  EditWheels = True 'Izydor Kawa code
End Sub

Private Sub cmdOpenAircraftWindow_Click()
  frmAircraft.Show vbModeless, frmGear
End Sub

Private Sub cmdOutputDetails_Click()
  frmACN.Show vbModeless, frmGear
End Sub

'
Private Sub FlexibleandRigidPCN(ByVal PavementType As String)

' Find PCN by the AC 150/5335-5B method.
' Works in single-aircraft mode and in batch mode (less and more buttons).

  Dim I As Long, J As Long, NAircraft As Long
'  Dim CriticalACIndex As Long ' Made a public variable so it can be set from a mouse down event.
'  Dim EvalThick As Double ' Made a public variable so it can be set from a click event.
  Dim CriticalACCovsToFailure As Double, CriticalACEquivCovs() As Double
  Dim ConversionACCovs() As Double
  Dim CDFTotal As Double, MGWLimitN As Long, WheelLoadLimitN
'  Dim CriticalACTotalEquivCovs() As Double ' Made a public variable for output.
  Dim CriticalACTotalAnnualDepartures() As Double
  Dim ConversionACCovsToFailure() As Double, Thickness As Double
  Dim Covs As Double, DelCovs As Double
  Dim LastThick As Double, DelThick As Double
  Dim ThickM1 As Double, ThickM2 As Double, ThickM3 As Double, ThickM4 As Double
  Dim Func As Double, FuncM1 As Double, NewtonCoeff As Double
  Dim CoveragesSave As Double, AnnualDeparturesSave As Double, GrossWeightSave As Double
  Dim CoveragesSaveLoop As Double, GrossWeightSaveLoop As Double
  Dim GrossWt As Double, DelGrossWt As Double, GrossWeightM1 As Double, GrossWeightM2 As Double
  Dim MGW As Double ' MaxGrossWeight() is a public variable for output.
  Dim FlexiblePCN As Boolean
' Coverages is a global variable.
  Dim LogCoverages As Double, LogCovs As Double, DelLogCovs As Double
  Dim S As String, SS As String, FullFileName As String, FF As String
  Dim chkPCAThicknessDesignSave As Integer
  Dim LoopStart As Long, LoopEnd As Long, LoopStartLife As Long, LoopEndLife As Long
  Dim FNo As Integer, FileName As String
  Dim lstLibFileListIndexSave As Long
  Dim ACName() As String, InputGrossWeight() As Double, InputAnnualDepartures() As Double
  Dim ThickFlexible() As Double, ThickRigid() As Double, DTemp As Double
  Dim ThickLife() As Double ' For printing to see if EvalThick reached.
  Dim ThickCriticalAC() As Double, CriticalACThick As Double
  Dim MaxNWheels As Long, MaxNMainGears As Long
  Dim DoLifeOnly As Boolean, ICAOCodeIndex As Long, ICAOCode(1 To 4) As String
  Dim ACNThicknessRtn() As Double
  Dim FullOutput As Boolean
  Const Exp As Double = 2.7182818285, MaxFlexLogCovs As Double = 700 '18.42 = Log(100,000,000)
'  Const MGWLimit As Double = 1.4, WheelLoadLimit As Double = 70000#
  Const MGWLimit As Double = 1.4 * 1000#, WheelLoadLimit As Double = 70000# * 1000#
  
  FullOutput = True
  If PavementType = "Flexible" Then
    ICAOCode(1) = "D(3)":  ICAOCode(2) = "C(6)":  ICAOCode(3) = "B(10)":  ICAOCode(4) = "A(15)"
  Else
    ICAOCode(1) = "D(" & Format(20# / 0.27144716 * UnitsOut.pci, "0") & ")"
    ICAOCode(2) = "C(" & Format(40# / 0.27144716 * UnitsOut.pci, "0") & ")"
    ICAOCode(3) = "B(" & Format(80# / 0.27144716 * UnitsOut.pci, "0") & ")"
    ICAOCode(4) = "A(" & Format(Int(150# / 0.27144716) * UnitsOut.pci, "0") & ")"
  End If
  
  If optCalcMode(6) Then DoLifeOnly = True Else DoLifeOnly = False
  
  If txtEvaluationThickness.Text = "" Then Call txtEvaluationThickness_Click
  If EvalThick < 0.1 Then
    S = "Evaluation thickness cannot be less than "
    S = S & Format(0.1 * UnitsOut.inch, UnitsOut.inchFormat) & " " & UnitsOut.inchName & "." & vbCrLf
    S = S & "The operation will be aborted."
    MsgBox S, vbOKOnly, "Thickness Too Small"
    Exit Sub
  End If
  
  If chkBatch.Value = vbUnchecked And Not DoLifeOnly Then
    S = lblCriticalAircraftText.Caption
    If S = "" Or S <> lstLibFile.List(CriticalACIndex) Then ' The first test is required for an index > ListCount.
      S = "Right click an entry in the Library Aircraft" & vbCrLf
      S = S & "list box to select the critical aircraft. The" & vbCrLf
      S = S & "PCN operation cannot be completed without" & vbCrLf
      S = S & "a critical aircraft and is being aborted." & vbCrLf
      S = S & "so that a critical aircraft can be selected."
      MsgBox S, vbOKOnly, "Critical Airplane not Selected"
      Exit Sub
    End If
  End If
  
  If PavementType = "Flexible" Then
    If InputCBR = 0 Then
      S = "Please click on the CBR title cell in the" & vbCrLf & "output grid and enter a CBR value."
      MsgBox S, vbOKOnly, "Input CBR Value Required"
      Exit Sub
    End If
    ComputingFlexible = True
    FlexiblePCN = True
  Else
    If InputkValue = 0 Then
      S = "Please click on the k Value title cell" & vbCrLf & "in the output grid and enter a k value."
      MsgBox S, vbOKOnly, "Input k Value Required"
      Exit Sub
    End If
    ComputingRigid = False ' Need to check this in RigidACN.
    FlexiblePCN = False
  End If
    
  NAircraft = lstLibFile.ListCount
  ReDim ConversionACCovsToFailure(0 To NAircraft), ConversionACCovs(0 To NAircraft)
  
  lstLibFileListIndexSave = lstLibFile.ListIndex
  LoopStartLife = 0
  LoopEndLife = NAircraft - 1
  If chkBatch.Value = vbChecked Then ' All aircraft are critical aircraft, one-by-one.
    LoopStart = 0
    LoopEnd = NAircraft - 1
  Else                               ' A single critical aircraft.
    If DoLifeOnly Then
      LoopStartLife = lstLibFileListIndexSave
      LoopEndLife = lstLibFileListIndexSave
    End If
    LoopStart = CriticalACIndex
    LoopEnd = CriticalACIndex
  End If
  
  If DoLifeOnly Then lstLibFile.ListIndex = LoopStartLife Else lstLibFile.ListIndex = LoopStart
  optCalcMode(1).Value = True ' Start in thickness mode.
  GrossWeightSave = GrossWeight
'  CoveragesSave = Coverages
  CoveragesSave = RigidCoverages
  If FlexiblePCN Then CoveragesSave = FlexibleCoverages
  AnnualDeparturesSave = AnnualDepartures
  Call WriteParmGrid
  
  ReDim InputGrossWeight(0 To NAircraft), InputAnnualDepartures(0 To NAircraft)
  ReDim ThickFlexible(0 To NAircraft), ThickRigid(0 To NAircraft), ThickLife(0 To NAircraft)
  
' Find the design thickness and the coverages-to-failure for all aircraft.
  
  MaxNWheels = 0:  MaxNMainGears = 0
  For I = LoopStartLife To LoopEndLife
  
    If NWheels > MaxNWheels Then MaxNWheels = NWheels
    If NMainGears > MaxNMainGears Then MaxNMainGears = NMainGears
  
    lstLibFile.ListIndex = I
    InputGrossWeight(I) = GrossWeight
    InputAnnualDepartures(I) = AnnualDepartures
        
    CoveragesSaveLoop = RigidCoverages
    If FlexiblePCN Then CoveragesSaveLoop = FlexibleCoverages
    DelCovs = CoveragesSaveLoop / 1000
    LogCoverages = Log(CoveragesSaveLoop)
    DelLogCovs = 0.001
    NewtonCoeff = 1#
    J = 0
  
    If FlexiblePCN Then
    
      Call ACNFlexComp
      ThickFlexible(I) = CBRThickness(1) ' Design thickness - comes free.
      ThickM1 = ThickFlexible(I):  ThickM2 = ThickM1
      ThickM3 = ThickM1:           ThickM4 = ThickM1
      FuncM1 = CBRThickness(1) - EvalThick
      Do
        ThickM4 = ThickM3:  ThickM3 = ThickM2:  ThickM2 = ThickM1
        ThickM1 = CBRThickness(1)
        J = J + 1
        LogCovs = LogCoverages
        LogCoverages = LogCoverages + DelLogCovs
        FlexibleCoverages = Exp ^ LogCoverages
        LastThick = CBRThickness(1)
        Call ACNFlexComp
        DelThick = CBRThickness(1) - LastThick
        If DelThick = 0 Then
'          SS = "Two successive thickness evaluations gave the same thickness." & vbCrLf
'          SS = SS & "The calculation of design thickness cannot converge." & vbCrLf
'          SS = SS & "The evaluation thickness may be too large."
'          MsgBox SS, vbOKOnly, "Thickness May Be Too Large"
          Exit Do
        End If
'        Do
'        This loop works ok but the exit with MaxFlexLogCovs below appears to be more consistent.
'          If (LogCovs - NewtonCoeff * FuncM1 * DelLogCovs / DelThick) >= MaxFlexLogCovs Then
'            NewtonCoeff = NewtonCoeff / 2
'            Debug.Print "In changing NewtonCoeff"; NewtonCoeff
'          Else
'            Exit Do
'          End If
'        Loop
        LogCoverages = LogCovs - NewtonCoeff * FuncM1 * DelLogCovs / DelThick
        If LogCoverages > MaxFlexLogCovs Then LogCoverages = MaxFlexLogCovs
        FlexibleCoverages = Exp ^ LogCoverages
        Call ACNFlexComp
        If LogCoverages >= MaxFlexLogCovs Then Exit Do
        FuncM1 = CBRThickness(1) - EvalThick
        DoEvents
        NewtonCoeff = 1#
        If J > 30 Then
          CBRThickness(1) = (ThickM4 + ThickM3 + ThickM2 + ThickM1) / 4#
          Exit Do
        End If
      Loop Until Abs(FuncM1) < 0.0001
      ThickLife(I) = CBRThickness(1)
  
      ConversionACCovsToFailure(I) = FlexibleCoverages
      FlexibleCoverages = CoveragesSaveLoop ' = coverages of conversion airplane over 20 years.
      ConversionACCovs(I) = FlexibleCoverages
      
    Else
    
      Call RigidACN
      ThickRigid(I) = RigidThickness(1) ' Design thickness - comes free.
      FuncM1 = RigidThickness(1) - EvalThick
      Do
        J = J + 1
        LogCovs = LogCoverages
        LogCoverages = LogCoverages + DelLogCovs
        RigidCoverages = Exp ^ LogCoverages
        LastThick = RigidThickness(1)
        Call RigidACN
        If RigidThickness(1) = 0 Then ' Occurs in ACNRigComp when very light load or thick pavement for PCA.
          LogCoverages = MaxFlexLogCovs:  Coverages = Exp ^ LogCoverages
          Exit Do
        End If
        DelThick = RigidThickness(1) - LastThick
        If DelThick = 0 Then Exit Do
        LogCoverages = LogCovs - 1# * FuncM1 * DelLogCovs / DelThick
        If LogCoverages > MaxFlexLogCovs Then LogCoverages = MaxFlexLogCovs
        RigidCoverages = Exp ^ LogCoverages
        Call RigidACN
        If LogCoverages >= MaxFlexLogCovs Then Exit Do
        If RigidThickness(1) = 0 Then ' Occurs in ACNRigComp when very light load or thick pavement for PCA.
          LogCoverages = MaxFlexLogCovs:  Coverages = Exp ^ LogCoverages
          Exit Do
        End If
        FuncM1 = RigidThickness(1) - EvalThick
        DoEvents
      Loop Until Abs(FuncM1) < 0.0001
      ThickLife(I) = RigidThickness(1)
  
      ConversionACCovsToFailure(I) = RigidCoverages
      RigidCoverages = CoveragesSaveLoop ' = coverages of conversion airplane over 20 years.
      ConversionACCovs(I) = RigidCoverages
    
    End If
  
    Call WriteParmGrid
'    Debug.Print I; J; ConversionACCovsToFailure(I); CBRThickness(1); RigidThickness(1); CriticalACEquivCovs(I)
  
  Next I
  
  If DoLifeOnly Then
  
    If PavementType = "Flexible" Then
  
      FF = Replace(DateValue(Date), "/", "-")
      FF = FF & " " & Format(Hour(Time), "00") & ";" & Format(Minute(Time), "00") & ";" & Format(Second(Time), "00")
      FileName = "Life Results Flexible " & FF & ".txt"
      S = "This file name = " & FileName & vbCrLf
      S = S & "Library file name = " & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext" & vbCrLf
      S = S & "Units = " & UnitsOut.Name & vbCrLf & vbCrLf
      S = S & "Evaluation pavement type is flexible and design procedure is CBR" & vbCrLf
      If chkNew07Alphas.Value = vbChecked Then
        SS = "Alpha Values are those approved by the ICAO in 2007." & vbCrLf
      Else
        SS = "Alpha Values are those used in AC 150/5320-6C/D design charts." & vbCrLf
      End If
      S = S & SS & vbCrLf
      S = S & "                                         CBR = " & Format(InputCBR, "0.00") & vbCrLf
      S = S & "               Evaluation pavement thickness = "
      S = S & Format(EvalThick * UnitsOut.inch, UnitsOut.inchFormat) & " " & UnitsOut.inchName & vbCrLf & vbCrLf

      S = S & "Results Table: Life Computations" & vbCrLf

      S = S & "                             Gross   Percent    Tire     Annual    6D      20-yr    Life        Coverages" & vbCrLf
      S = S & " No.  Aircraft Name          Weight  Gross Wt   Press     Deps    Thick  Coverages  Thick   to Failure (Life)" & vbCrLf
      S = S & "----------------------------------------------------------------------------------------------------------" & vbCrLf
    
      ReDim ACName(0 To lstLibFile.ListCount)
'      For I = 0 To lstLibFile.ListCount - 1
      For I = LoopStartLife To LoopEndLife
        lstLibFile.ListIndex = I
        ACName(I) = lstLibFile.Text
        S = S & LPad(3, Format(I + 1, "0")) & "  " & RPad(21, ACName(I))
        S = S & LPad(9, Format(GrossWeight * UnitsOut.pounds, UnitsOut.poundsFormat))
        S = S & LPad(8, Format(PcntOnMainGears, "0.00"))
        S = S & LPad(10, Format(TirePressure * UnitsOut.psi, UnitsOut.psiFormat))
        S = S & LPad(10, Format(AnnualDepartures, "#,###,##0")) ' GFH 9/28/09.
        S = S & LPad(8, Format(ThickFlexible(I) * UnitsOut.inch, UnitsOut.inchFormat))
        S = S & LPad(10, Format(FlexibleCoverages, "#,###,##0"))
        S = S & LPad(8, Format(ThickLife(I) * UnitsOut.inch, UnitsOut.inchFormat))
        If ConversionACCovsToFailure(I) < 10000000 Then
          S = S & LPad(19, Format(ConversionACCovsToFailure(I), "#,##0")) & vbCrLf
        Else
          S = S & LPad(19, Format(ConversionACCovsToFailure(I), "#,###,##0.0E+000")) & vbCrLf
        End If
      Next I
    
    Else
  
      FF = Replace(DateValue(Date), "/", "-")
      FF = FF & " " & Format(Hour(Time), "00") & ";" & Format(Minute(Time), "00") & ";" & Format(Second(Time), "00")
      FileName = "Life Results Rigid " & FF & ".txt"
      S = "This file name = " & FileName & vbCrLf
      S = S & "Library file name = " & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext" & vbCrLf
      S = S & "Units = " & UnitsOut.Name & vbCrLf & vbCrLf
      S = S & "Evaluation pavement type is rigid" & vbCrLf
      If chkPCAThicknessDesign.Value = vbChecked Then
        SS = "Equivalent coverages computed with the PCA interior stress design method."
      Else
        SS = "Equivalent coverages computed with the AC 150/5320-6C/D edge stress design method."
      End If
      S = S & SS & vbCrLf
      If chkPCAforGrossWeight.Value = vbChecked Then
        SS = "Maximum gross weight computed with the PCA interior stress design method."
      Else
        SS = "Maximum gross weight computed with the AC 150/5320-6C/D edge stress design method."
      End If
      S = S & SS & vbCrLf & vbCrLf
      S = S & "                                     k Value = "
      S = S & Format(InputkValue * UnitsOut.pci, UnitsOut.pciFormat) & " " & UnitsOut.pciName & vbCrLf
      S = S & "                           flexural strength = "
      S = S & Format(ConcreteFlexuralStrength * UnitsOut.psi, UnitsOut.psiFormat) & " " & UnitsOut.psiName & vbCrLf
      S = S & "               Evaluation pavement thickness = "
      S = S & Format(EvalThick * UnitsOut.inch, UnitsOut.inchFormat) & " " & UnitsOut.inchName & vbCrLf & vbCrLf
      
      S = S & "Results Table: Life Computations" & vbCrLf

      S = S & "                             Gross   Percent    Tire     Annual    6D      20-yr    Life        Coverages" & vbCrLf
      S = S & " No.  Aircraft Name          Weight  Gross Wt   Press     Deps    Thick  Coverages  Thick   to Failure (Life)" & vbCrLf
      S = S & "----------------------------------------------------------------------------------------------------------" & vbCrLf
    
      ReDim ACName(0 To lstLibFile.ListCount)
'      For I = 0 To lstLibFile.ListCount - 1
      For I = LoopStartLife To LoopEndLife
        lstLibFile.ListIndex = I
        ACName(I) = lstLibFile.Text
        S = S & LPad(3, Format(I + 1, "0")) & "  " & RPad(21, ACName(I))
        S = S & LPad(9, Format(GrossWeight * UnitsOut.pounds, UnitsOut.poundsFormat))
        S = S & LPad(8, Format(PcntOnMainGears, "0.00"))
        S = S & LPad(10, Format(TirePressure * UnitsOut.psi, UnitsOut.psiFormat))
        S = S & LPad(10, Format(AnnualDepartures, "#,###,##0"))
        S = S & LPad(8, Format(ThickRigid(I) * UnitsOut.inch, UnitsOut.inchFormat))
        S = S & LPad(10, Format(RigidCoverages, "#,###,##0"))
        S = S & LPad(8, Format(ThickLife(I) * UnitsOut.inch, UnitsOut.inchFormat))
        If ConversionACCovsToFailure(I) < 10000000 Then
          S = S & LPad(19, Format(ConversionACCovsToFailure(I), "#,##0")) & vbCrLf
        Else
          S = S & LPad(19, Format(ConversionACCovsToFailure(I), "#,###,##0.0E+000")) & vbCrLf
        End If
      Next I
    
    End If ' Pavement Type.

    lstLibFile.ListIndex = lstLibFileListIndexSave
  
    If chkBatch.Value = vbUnchecked Then
      If ConversionACCovsToFailure(lstLibFileListIndexSave) < 9999999 Then
        SS = Format(ConversionACCovsToFailure(lstLibFileListIndexSave), "#,##0")
      Else
        SS = Format(ConversionACCovsToFailure(lstLibFileListIndexSave), "#,###,###,###,##0.0E+000")
      End If
      lblMessage = "Covs to Failure = " & vbCrLf & SS
    End If
  
'    FNo = FreeFile()
'    If Dir(FileName) <> "" Then Kill FileName
'    Open FileName For Output As FNo
'    Print #FNo, S
'    Close (FNo)
    
    LifeOutputText = S
    frmACN.optCalcMode(3).Value = True
    
    cmdFlexibleCompute.Visible = True
    cmdRigidCompute.Enabled = True
    ComputingFlexible = False
    ComputingRigid = False
    optCalcMode(6).Value = True
    Exit Sub
  
  End If ' DoLifeOnly
  
  ReDim CriticalACEquivCovs(0 To NAircraft, 0 To NAircraft), CriticalACTotalEquivCovs(0 To NAircraft)
  ReDim CriticalACTotalAnnualDepartures(0 To NAircraft), ThickCriticalAC(0 To NAircraft)
  
' Find the total equivalent coverages for each critical aircraft.
  For I = LoopStart To LoopEnd
    CriticalACCovsToFailure = ConversionACCovsToFailure(I)
    CriticalACTotalEquivCovs(I) = 0#
    For J = 0 To NAircraft - 1
      CriticalACEquivCovs(I, J) = ConversionACCovs(J) * CriticalACCovsToFailure / ConversionACCovsToFailure(J)
      CriticalACTotalEquivCovs(I) = CriticalACTotalEquivCovs(I) + CriticalACEquivCovs(I, J)
    Next J
  Next I

  ComputingRigid = False
  ComputingFlexible = False
  ReDim MaxGrossWeight(0 To NAircraft), ACNrtn(0 To NAircraft, 0 To 4), ACNThicknessRtn(0 To NAircraft, 0 To 4)
'  ReDim ACNInputACrtn(0 To NAircraft, 0 To 4) Moved to Sub FlexibleACNforBatch() and Sub RigidACNforBatch.
  
' Find PCN values for each aircraft considered to be the critical aircraft in turn.

  MGWLimitN = 0: WheelLoadLimitN = 0
  For I = LoopStart To LoopEnd
  
    optCalcMode(1).Value = True ' Switch to thickness mode to return library coverages, not 10,000.
    lstLibFile.ListIndex = I
    lblCriticalAircraftText.Caption = lstLibFile.Text
'    CoveragesSaveLoop = Coverages
    If PavementType = "Flexible" Then DTemp = PtoCFlex Else DTemp = PtoCRigid
    CriticalACTotalAnnualDepartures(I) = CriticalACTotalEquivCovs(I) * DTemp * PtoTC / 20
    GrossWeightSaveLoop = GrossWeight
    
'   Maximum Gross Weight calculation.
    optCalcMode(3).Value = True
'    Coverages = CriticalACTotalEquivCovs(I)
    If FlexiblePCN Then
      CoveragesSaveLoop = FlexibleCoverages
      FlexibleCoverages = CriticalACTotalEquivCovs(I)
      MaxGWFlexible = True
    Else
      CoveragesSaveLoop = RigidCoverages
      RigidCoverages = CriticalACTotalEquivCovs(I)
      MaxGWFlexible = False
    End If
'    Call GetMGW(MGW, CriticalACThick)
    Call GetMGW("MGWforPCN", MGW, DTemp, CriticalACThick)
    
'   Cap the maximum allowable gross weight to avoid unreasonably high PCNs.
    If MGW > GrossWeightSaveLoop * MGWLimit Then ' GFH 10-08-11.
      MGW = GrossWeightSaveLoop * MGWLimit
      If MGW * PcntOnMainGears / 100# / NMainGears / NWheels > WheelLoadLimit Then
        MGW = WheelLoadLimit * NWheels * NMainGears / (PcntOnMainGears / 100#)
        WheelLoadLimitN = WheelLoadLimitN + 1
        MGWLimitN = MGWLimitN - 1
      End If
      MGWLimitN = MGWLimitN + 1
    ElseIf MGW * PcntOnMainGears / 100# / NMainGears / NWheels > WheelLoadLimit Then
      MGW = WheelLoadLimit * NWheels * NMainGears / (PcntOnMainGears / 100#)
      WheelLoadLimitN = WheelLoadLimitN + 1
    End If
    
    MaxGrossWeight(I) = MGW ' Save for output.
    ThickCriticalAC(I) = CriticalACThick ' Save for output.
'   ACN Calculation
'    Coverages = CoveragesSaveLoop ' Suppresses data changed message. ************ needed?
    optCalcMode(0).Value = True ' ACN mode.
    GrossWeight = MGW
    If FlexiblePCN Then
'      Call cmdFlexibleCompute_Click
      Call FlexibleACN ' Avoids the batch mode running.
      For J = 1 To 4
        ACNrtn(I, J) = ACNFlex(J)
        ACNThicknessRtn(I, J) = CBRThickness(J)
      Next J
    Else
'      Call cmdRigidCompute_Click
      Call RigidACN ' Avoids the batch mode running.
      For J = 1 To 4
        ACNrtn(I, J) = ACNRigid(J)
        ACNThicknessRtn(I, J) = RigidThickness(J)
      Next J
    End If
    Debug.Print lstLibFile.Text; " "; ACNrtn(I, 1); " "; ACNrtn(I, 2); " "; ACNrtn(I, 3); " "; ACNrtn(I, 4)
'    Coverages = CoveragesSaveLoop     ' Suppresses data changed message at top of loop.
    RigidCoverages = CoveragesSaveLoop     ' Suppresses data changed message at top of loop.
    If FlexiblePCN Then FlexibleCoverages = CoveragesSaveLoop
    GrossWeight = GrossWeightSaveLoop ' Suppresses data changed message at top of loop.
    
  Next I
  
  lblCriticalAircraftText.Caption = ""

'  Call optCalcMode_Click(2) ' Switch back to PCN.
  optCalcMode(2).Value = True
 ' Switch back to PCN.
  lstLibFile.ListIndex = LoopStart
  GrossWeight = GrossWeightSave
'  Coverages = CoveragesSave
  RigidCoverages = CoveragesSave
  If FlexiblePCN Then FlexibleCoverages = CoveragesSave
  
  If PavementType = "Flexible" Then
    
    FF = Replace(DateValue(Date), "/", "-")
    FF = FF & " " & Format(Hour(Time), "00") & ";" & Format(Minute(Time), "00") & ";" & Format(Second(Time), "00")
    FileName = "PCN Results Flexible " & FF & ".txt"
    S = "This file name = " & FileName & vbCrLf
    S = S & "Library file name = " & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext" & vbCrLf
    S = S & "Units = " & UnitsOut.Name & vbCrLf & vbCrLf
    S = S & "Evaluation pavement type is flexible and design procedure is CBR." & vbCrLf
    If chkNew07Alphas.Value = vbChecked Then
      SS = "Alpha Values are those approved by the ICAO in 2007." & vbCrLf
    Else
      SS = "Alpha Values are those used in AC 150/5320-6C/D design charts." & vbCrLf
    End If
    S = S & SS & vbCrLf
    
    If InputCBR >= 13 Then ICAOCodeIndex = 4
    If 8 < InputCBR And InputCBR < 13 Then ICAOCodeIndex = 3
    If 4 < InputCBR And InputCBR <= 8 Then ICAOCodeIndex = 2
    If InputCBR <= 4 Then ICAOCodeIndex = 1
    SS = ICAOCode(ICAOCodeIndex)
    
    S = S & "                                         CBR = " & Format(InputCBR, "0.00") & " (Subgrade Category is " & SS & ")" & vbCrLf
    S = S & "               Evaluation pavement thickness = "
    S = S & Format(EvalThick * UnitsOut.inch, UnitsOut.inchFormat) & " " & UnitsOut.inchName & vbCrLf
    S = S & "         Pass to Traffic Cycle (PtoTC) Ratio = " & Format(PtoTC, "0.00")
    If PtoTC < 1# Or 3# < PtoTC Or (PtoTC - Int(PtoTC)) <> 0 Then S = S & " (non-standard)"
    S = S & vbCrLf

    S = S & "           Maximum number of wheels per gear = " & Format(MaxNWheels, "0") & vbCrLf
    S = S & "        Maximum number of gears per aircraft = " & Format(MaxNMainGears, "0") & vbCrLf & vbCrLf

    If MaxNWheels >= 4 Then
      S = S & "At least one aircraft has 4 or more wheels per gear.  The FAA recommends a reference section assuming" & vbCrLf
      If UnitsOut.Metric Then
        S = S & "127 mm of HMA and 203 mm of crushed aggregate for equivalent thickness calculations." & vbCrLf & vbCrLf
      Else
        S = S & "5 inches of HMA and 8 inches of crushed aggregate for equivalent thickness calculations." & vbCrLf & vbCrLf
      End If
    Else
      S = S & "No aircraft have 4 or more wheels per gear.  The FAA recommends a reference section assuming" & vbCrLf
      If UnitsOut.Metric Then
        S = S & "76 mm of HMA and 152 mm of crushed aggregate for equivalent thickness calculations." & vbCrLf & vbCrLf
      Else
        S = S & "3 inches of HMA and 6 inches of crushed aggregate for equivalent thickness calculations." & vbCrLf & vbCrLf
      End If
    End If
    
    S = S & "Results Table 1. Input Traffic Data" & vbCrLf

    S = S & "                            Gross   Percent    Tire     Annual      20-yr     6D" & vbCrLf
    S = S & " No.  Aircraft Name         Weight  Gross Wt   Press     Deps     Coverages  Thick" & vbCrLf
    S = S & "---------------------------------------------------------------------------------" & vbCrLf
    
    lstLibFileListIndexSave = lstLibFile.ListIndex
    ReDim ACName(0 To lstLibFile.ListCount)
    For I = 0 To lstLibFile.ListCount - 1
      lstLibFile.ListIndex = I
      ACName(I) = lstLibFile.Text
      S = S & LPad(3, Format(I + 1, "0")) & "  " & RPad(20, ACName(I))
      S = S & LPad(10, Format(GrossWeight * UnitsOut.pounds, UnitsOut.poundsFormat))
      S = S & LPad(7, Format(PcntOnMainGears, "0.00"))
      S = S & LPad(10, Format(TirePressure * UnitsOut.psi, UnitsOut.psiFormat))
'      S = S & LPad(10, Format(FlexibleAnnualDepartures, "#,###,##0"))
'      S = S & LPad(12, Format(Coverages, "#,###,##0"))
      S = S & LPad(10, Format(AnnualDepartures, "#,###,##0")) ' GFH 9/28/09.
      S = S & LPad(12, Format(FlexibleCoverages, "#,###,##0"))
'      S = S & LPad(12, Format(Coverages, "#,###,##0"))
      S = S & LPad(8, Format(ThickFlexible(I) * UnitsOut.inch, UnitsOut.inchFormat)) & vbCrLf
    Next I
    
  Else
  
    FF = Replace(DateValue(Date), "/", "-")
    FF = FF & " " & Format(Hour(Time), "00") & ";" & Format(Minute(Time), "00") & ";" & Format(Second(Time), "00")
    FileName = "PCN Results Rigid " & FF & ".txt"
    S = "This file name = " & FileName & vbCrLf
    S = S & "Library file name = " & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext" & vbCrLf
    S = S & "Units = " & UnitsOut.Name & vbCrLf & vbCrLf
    S = S & "Evaluation pavement type is rigid" & vbCrLf
    If chkPCAThicknessDesign.Value = vbChecked Then
      SS = "Equivalent coverages computed with the PCA interior stress design method."
    Else
      SS = "Equivalent coverages computed with the AC 150/5320-6C/D edge stress design method."
    End If
    S = S & SS & vbCrLf
    If chkPCAforGrossWeight.Value = vbChecked Then
      SS = "Maximum gross weight computed with the PCA interior stress design method."
    Else
      SS = "Maximum gross weight computed with the AC 150/5320-6C/D edge stress design method."
    End If
    S = S & SS & vbCrLf & vbCrLf
    
    If InputkValue >= 442 Then ICAOCodeIndex = 4
    If 221 < InputkValue And InputkValue < 442 Then ICAOCodeIndex = 3
    If 92 < InputkValue And InputkValue <= 221 Then ICAOCodeIndex = 2
    If InputkValue <= 92 Then ICAOCodeIndex = 1
    SS = ICAOCode(ICAOCodeIndex)
    
    S = S & "                                     k Value = "
    S = S & Format(InputkValue * UnitsOut.pci, UnitsOut.pciFormat) & " " & UnitsOut.pciName & " (Subgrade Category is " & SS & ")" & vbCrLf
    S = S & "                           flexural strength = "
    S = S & Format(ConcreteFlexuralStrength * UnitsOut.psi, UnitsOut.psiFormat) & " " & UnitsOut.psiName & vbCrLf
    S = S & "               Evaluation pavement thickness = "
    S = S & Format(EvalThick * UnitsOut.inch, UnitsOut.inchFormat) & " " & UnitsOut.inchName & vbCrLf
    S = S & "         Pass to Traffic Cycle (PtoTC) Ratio = " & Format(PtoTC, "0.00")
    If PtoTC < 1# Or 3# < PtoTC Or (PtoTC - Int(PtoTC)) <> 0 Then S = S & " (non-standard)"
    S = S & vbCrLf & vbCrLf
  
    S = S & "           Maximum number of wheels per gear = " & Format(MaxNWheels, "0") & vbCrLf
    S = S & "        Maximum number of gears per aircraft = " & Format(MaxNMainGears, "0") & vbCrLf & vbCrLf

    S = S & "Results Table 1. Input Traffic Data" & vbCrLf

    S = S & "                           Gross   Percent    Tire     Annual      20-yr     6D" & vbCrLf
    S = S & " No. Aircraft Name         Weight  Gross Wt   Press     Deps     Coverages  Thick" & vbCrLf
    S = S & "---------------------------------------------------------------------------------" & vbCrLf
    
    lstLibFileListIndexSave = lstLibFile.ListIndex
    ReDim ACName(0 To lstLibFile.ListCount)
    For I = 0 To lstLibFile.ListCount - 1
      lstLibFile.ListIndex = I
      ACName(I) = lstLibFile.Text
      S = S & LPad(3, Format(I + 1, "0")) & "  " & RPad(20, ACName(I))
      S = S & LPad(9, Format(GrossWeight * UnitsOut.pounds, UnitsOut.poundsFormat))
      S = S & LPad(7, Format(PcntOnMainGears, "0.00"))
      S = S & LPad(10, Format(TirePressure * UnitsOut.psi, UnitsOut.psiFormat))
'      S = S & LPad(10, Format(RigidAnnualDepartures, "#,###,##0"))
'      S = S & LPad(12, Format(Coverages, "#,###,##0"))
      S = S & LPad(10, Format(AnnualDepartures, "#,###,##0"))
      S = S & LPad(12, Format(RigidCoverages, "#,###,##0"))
      S = S & LPad(8, Format(ThickRigid(I) * UnitsOut.inch, UnitsOut.inchFormat)) & vbCrLf
    Next I
    
  End If

  S = S & vbCrLf
  lstLibFile.ListIndex = lstLibFileListIndexSave
   
  S = S & "Results Table 2. PCN Values" & vbCrLf

  FullOutput = False
  If FullOutput Then
    S = S & "                          Critical        Thickness      Maximum    " & vbCrLf
    S = S & "                       Aircraft Total     for Total     Allowable       PCN at Indicated Code" & vbCrLf
    If PavementType = "Flexible" Then
      S = S & " No. Aircraft Name       Equiv. Covs.    Equiv. Covs.  Gross Weight    A(15)  B(10)   C(6)   D(3)    CDF" & vbCrLf
    Else
      S = S & " No. Aircraft Name       Equiv. Covs.    Equiv. Covs.  Gross Weight   " _
            & ICAOCode(4) & ICAOCode(3) & ICAOCode(2) & ICAOCode(1) & "    CDF" & vbCrLf
    End If
    S = S & "---------------------------------------------------------------------------------------------------------" & vbCrLf
  Else
    S = S & "                          Critical        Thickness      Maximum      ACN Thick at" & vbCrLf
    S = S & "                       Aircraft Total     for Total     Allowable    Max. Allowable           PCN on" & vbCrLf
    If PavementType = "Flexible" Then
      S = S & " No. Aircraft Name       Equiv. Covs.    Equiv. Covs.  Gross Weight   Gross Weight    CDF      " & ICAOCode(ICAOCodeIndex) & vbCrLf
    Else
      S = S & " No. Aircraft Name       Equiv. Covs.    Equiv. Covs.  Gross Weight   Gross Weight    CDF     " & ICAOCode(ICAOCodeIndex) & vbCrLf
    End If
    S = S & "---------------------------------------------------------------------------------------------------" & vbCrLf
  End If
  
  CDFTotal = 0#
  For I = LoopStart To LoopEnd
    S = S & LPad(3, Format(I + 1, "0")) & "  " & RPad(20, ACName(I))
    If CriticalACTotalEquivCovs(I) <= 5000000 Then ' About one departure per minute for 20 years.
      S = S & LPad(11, Format(CriticalACTotalEquivCovs(I), "#,###,##0"))
    Else
      S = S & LPad(11, ">5,000,000")
    End If
    S = S & LPad(13, Format(ThickCriticalAC(I) * UnitsOut.inch, UnitsOut.inchFormat))
    S = S & LPad(16, Format(MaxGrossWeight(I) * UnitsOut.pounds, UnitsOut.poundsFormat))
    If FullOutput Then
      S = S & LPad(10, Format(ACNrtn(I, 4), "#,###,##0.0")) & LPad(7, Format(ACNrtn(I, 3), "#,###,##0.0"))
      S = S & LPad(7, Format(ACNrtn(I, 2), "#,###,##0.0")) & LPad(7, Format(ACNrtn(I, 1), "#,###,##0.0"))
    Else
      S = S & LPad(14, Format(ACNThicknessRtn(I, ICAOCodeIndex) * UnitsOut.inch, "0.00"))
    End If
    DTemp = ConversionACCovs(I) / ConversionACCovsToFailure(I)
    CDFTotal = CDFTotal + DTemp
    S = S & LPad(11, Format(DTemp, "0.0000"))
    If FullOutput Then
      S = S & vbCrLf
    Else
      S = S & LPad(9, Format(ACNrtn(I, ICAOCodeIndex), "#,###,##0.0")) & vbCrLf
    End If
  Next I
  If FullOutput Then J = 85 Else J = 70
  S = S & Space(J) & "Total CDF =" & LPad(9, Format(CDFTotal, "0.0000")) & vbCrLf

  J = 0
  For I = 0 To NAircraft - 1
    If ThickLife(I) < EvalThick * 0.99 Then J = J + 1
  Next I
  If J = NAircraft Then
    SS = vbCrLf
    SS = SS & "When computing the numbers of coverages to failure, the coverages for none" & vbCrLf
    SS = SS & "of the aircraft converged at a pavement thickness greater than 99 percent of" & vbCrLf
    SS = SS & "the evaluation thickness. This means that the life of the pavement is unlimited" & vbCrLf
    SS = SS & "and the pavement is very strong in relation to the aircraft loading. The" & vbCrLf
    SS = SS & "relative aircraft load evaluations are also unreliable. Consider reviewing" & vbCrLf
    SS = SS & "the procedures used to determine the evaluation thickness and the strength" & vbCrLf
    SS = SS & "of the support. The thicknesses for unlimited operations of each of the" & vbCrLf
    SS = SS & "aircraft are as follows." & vbCrLf & vbCrLf
    SS = SS & "Results Table 2a. Thicknesses for Unlimited Operations" & vbCrLf

    For I = 0 To NAircraft - 1
      SS = SS & RPad(20, ACName(I))
      SS = SS & LPad(13, Format(ThickLife(I) * UnitsOut.inch, UnitsOut.inchFormat)) & vbCrLf
    Next I
    S = S & SS
  End If
    
  MGWLimitN = 0
  If MGWLimitN > 0 Then
    If MGWLimitN = 1 Then SS = "One aircraft had its " Else SS = Format(MGWLimitN, "0") & " aircraft had their "
    SS = vbCrLf & SS
    SS = SS & "maximum allowable gross weight for PCN calculation " & vbCrLf
    SS = SS & "capped at " & Format(MGWLimit * 100#, "0") & " per cent of the input gross weight." & vbCrLf
    S = S & SS
  End If
    
  WheelLoadLimitN = 0
  If WheelLoadLimitN > 0 Then
    If WheelLoadLimitN = 1 Then SS = "One aircraft had its " Else SS = Format(WheelLoadLimitN, "0") & " aircraft had their "
    SS = vbCrLf & SS
    SS = SS & "maximum allowable wheel load for PCN calculation " & vbCrLf
    SS = SS & "capped at " & Format(WheelLoadLimit, UnitsOut.poundsFormat) & " " & UnitsOut.poundsName & " wheel load." & vbCrLf
    S = S & SS
  End If
    
' Run to get ACN values at input GVW for output to the summary file.
  optCalcMode(0).Value = True ' Switch to ACN mode.
  If PavementType = "Flexible" Then
    Call FlexibleACNforBatch("FromPCNBatch")
  Else
    Call RigidACNforBatch("FromPCNBatch")
  End If
  S = S & vbCrLf & ACNBatchOutputText
  optCalcMode(2).Value = True ' Return to PCN mode.

' Print equivalent coverages for each critical aircraft.
  If False Then
    SS = vbCrLf
    For I = LoopStart To LoopEnd
      SS = SS & vbCrLf
      SS = SS & "                                   Critical Aircraft = " & ACName(I) & vbCrLf
      SS = SS & "              Critical Aircraft Coverages To Failure = " & Format(ConversionACCovsToFailure(I), "#,###,###,###,##0.0E+000") & vbCrLf
      SS = SS & "Thickness for Critical Aircraft Coverages To Failure = " & Format(ThickLife(I), "#,###,##0.00") & vbCrLf
      SS = SS & "        Total Critical Aircraft Equivalent Coverages = " & Format(CriticalACTotalEquivCovs(I), "#,###,###,###,##0.0E+000") & vbCrLf & vbCrLf
      SS = SS & " Aircraft Name     Aircraft Covs           AC Covs To Failure       Critical AC Equiv Covs" & vbCrLf
      For J = 0 To NAircraft - 1
        SS = SS & RPad(20, ACName(J)) & LPad(12, Format(ConversionACCovs(J), "#,###,##0")) & "  "
        SS = SS & LPad(28, Format(ConversionACCovsToFailure(J), "#,###,###,###,##0.0E+000")) & " "
        SS = SS & LPad(28, Format(CriticalACEquivCovs(I, J), "#,###,###,###,##0.0E+000")) & vbCrLf
      Next J
      SS = SS & vbCrLf
    Next I
    S = S & SS
  End If
  
  PCNOutputText = S

'  FNo = FreeFile()
'  If Dir(FileName) <> "" Then Kill FileName
'  Open FileName For Output As FNo
'  Print #FNo, S
'  Close (FNo)
'  frmACN.optCalcMode(0).Value = True
  
' Summary information to a comma delimited string for insertion
' into an Excel spreadsheet prepared by Jeff Rapol.
  S = "Num,Plane,GWin,ACNin,ADout,6Dt,COV20yr,COVtoF,CDFt,GWcdf,PCNcdf,EVALt,SUBcode,KorCBR,PtoTC,FlexOrRig" & vbCrLf
  For I = LoopStart To LoopEnd
    S = S & Format(I + 1, "0") & "," & ACName(I) & ","
    S = S & Format(InputGrossWeight(I) * UnitsOut.pounds, "0.000") & ","
    S = S & Format(ACNInputACrtn(I, ICAOCodeIndex), "0.0") & ","
    S = S & Format(InputAnnualDepartures(I) * PtoTC, "0") & ","
    If PavementType = "Flexible" Then DTemp = ThickFlexible(I) Else DTemp = ThickRigid(I)
    S = S & Format(DTemp * UnitsOut.inch, "0.00") & ","
    S = S & Format(ConversionACCovs(I), "0.00000E+000") & ","
    S = S & Format(ConversionACCovsToFailure(I), "0.00000E+000") & ","
    S = S & Format(ThickCriticalAC(I) * UnitsOut.inch, "0.00") & ","
    S = S & Format(MaxGrossWeight(I) * UnitsOut.pounds, "0.000") & ","
    S = S & Format(ACNrtn(I, ICAOCodeIndex), "0.0") & ","
    S = S & Format(EvalThick * UnitsOut.inch, "0.0") & ","
    S = S & Left(ICAOCode(ICAOCodeIndex), 1) & ","
    If PavementType = "Flexible" Then
      DTemp = InputCBR
      SS = "F"
    Else
      DTemp = InputkValue * UnitsOut.pci
      SS = "R"
    End If
    S = S & Format(DTemp, "0.00") & ","
    S = S & Format(PtoTC, "0.00") & ","
    S = S & SS & vbCrLf
  Next I

'  FNo = FreeFile()
'  FF = Replace(DateValue(Date), "/", "-")
'  FF = FF & " " & Format(Hour(Time), "00") & ";" & Format(Minute(Time), "00") & ";" & Format(Second(Time), "00")
'  FileName = ExtFilePath$ & ExternalAircraftFileName$ & " - Summary Results " & FF & ".txt"
'  If Dir(FileName) <> "" Then Kill FileName
'  Open FileName For Output As FNo
'  Print #FNo, S
'  Close (FNo)
  
  PCNOutputText = PCNOutputText & vbCrLf & vbCrLf & "Results Table 4. Summary Output for Copy and Paste Into the "
  PCNOutputText = PCNOutputText & "Support Spread Sheet" & vbCrLf & vbCrLf
  PCNOutputText = PCNOutputText & S
  
  If SavePCNOutputtoFile = vbChecked Then ' Mirrors check box in frmACN.
    FNo = FreeFile()
    If Dir(FileName) <> "" Then Kill FileName
    Open FileName For Output As FNo
    Print #FNo, PCNOutputText
    Close (FNo)
  End If
  
  frmACN.optCalcMode(0).Value = True
  
End Sub

Private Sub cmdRedraw_Click()

  Dim I As Long, J As Long, NAircraft As Long
  
End Sub

Private Sub GetMGW(CallSource As String, MGW As Double, ReturnCoverages As Double, CriticalACThick As Double)

  Dim I As Long, J As Long, NAircraft As Long
'  Dim CriticalACIndex As Long ' Made a public variable so it can be set from a mouse down event.
'  Dim EvalThick As Double ' Made a public variable so it can be set from a click event.
  Dim CriticalACCovsToFailure As Double, CriticalACEquivCovs() As Double
  Dim ConversionACCovs() As Double
  Dim CriticalACTotalEquivCovs As Double
  Dim ConversionACCovsToFailure() As Double, Thickness As Double
  Dim Covs As Double, DelCovs As Double
  Dim LastThick As Double, DelThick As Double
  Dim ThickM1 As Double, ThickM2 As Double, ThickM3 As Double, ThickM4 As Double
  Dim Func As Double, FuncM1 As Double, NewtonCoeff As Double
  Dim FlexibleCoveragesSave As Double, RigidCoveragesSave As Double, WheelRadiusSave As Double
  Dim GrossWeightSave As Double, AnnualDeparturesSave As Double
  Dim GrossWt As Double, DelGrossWt As Double, GrossWeightM1 As Double, GrossWeightM2 As Double
  Dim FlexiblePCN As Boolean
  Dim LogCoverages As Double, LogCovs As Double, DelLogCovs As Double
  Dim S As String, SS As String, FullFileName As String
  Dim chkPCAThicknessDesignSave As Integer
  Const Exp As Double = 2.7182818285, MaxFlexLogCovs As Double = 18.42 ' = Log(100,000,000)

  If Not (MinEvalThickness <= EvalThick And EvalThick <= MaxEvalThickness) Then
    MsgBox "Please enter a valid evaluation thickness.", vbOKOnly, "Enter Evaluation Thickness"
    Exit Sub
  End If

'  lstLibFile.ListIndex = CriticalACIndex
  CriticalACIndex = lstLibFile.ListIndex
  GrossWeightSave = GrossWeight
  AnnualDeparturesSave = AnnualDepartures
  WheelRadiusSave = WheelRadius
  FlexibleCoveragesSave = FlexibleCoverages
  RigidCoveragesSave = RigidCoverages
'  Coverages = CriticalACTotalEquivCovs
  DelGrossWt = GrossWeight / 100 ' Do not set to be very small or successive thickness calculations may be equal.
  NewtonCoeff = 1#
  J = 0
    
  If MaxGWFlexible Then
    
    Call ACNFlexComp
    CriticalACThick = CBRThickness(1) ' Used only for output.
    FuncM1 = CBRThickness(1) - EvalThick
    
    Do
      J = J + 1
      GrossWt = GrossWeight
      GrossWeight = GrossWeight + DelGrossWt
      LastThick = CBRThickness(1)
      Call ACNFlexComp
      If J >= 50 Then
        SS = "The gross weight iteration cannot converge." & vbCrLf & vbCrLf
        SS = SS & "The last two thickness values were:" & vbCrLf & vbCrLf
        SS = SS & Format(LastThick * UnitsOut.inch, UnitsOut.inchFormat) & " and "
        SS = SS & Format(CBRThickness(1) * UnitsOut.inch, UnitsOut.inchFormat) & " " & UnitsOut.inchName
        MsgBox SS, vbOKOnly, "Cannot Converge"
        Exit Do
      End If
      DelThick = CBRThickness(1) - LastThick
      If DelThick = 0 Then
        SS = "Two successive thickness evaluations gave the same thickness." & vbCrLf
        SS = SS & "The calculation of allowable gross weight cannot converge." & vbCrLf
        SS = SS & "The evaluation thickness may be too large."
        MsgBox SS, vbOKOnly, "Thickness May Be Too Large"
        Exit Do
      End If
      Do
        If (GrossWt - NewtonCoeff * FuncM1 * DelGrossWt / DelThick) < (GrossWt * MinGLFraction) Then
          NewtonCoeff = NewtonCoeff / 2
        Else
          Exit Do
        End If
      Loop
      GrossWeight = GrossWt - NewtonCoeff * FuncM1 * DelGrossWt / DelThick
'      If CallSource = "MGWOnly" Then
'      If chkMGWcovs.Value = vbUnchecked Then
'       Computes MGW based on annual departures because converts to coverages in CoverageToPass().
'        WheelRadius = GrossWeight * PcntOnMainGears / (100 * NMainGears * NWheels)
'        WheelRadius = Sqr(WheelRadius / TirePressure / PI)
'        Call CoverageToPass ' Sets FlexibleCoverages and RigidCoverages, used in ACNFlexComp().
'        ReturnCoverages = FlexibleCoverages
'      ElseIf CallSource = "MGWforPCN" Then
'      ElseIf chkMGWcovs.Value = vbChecked Then ' Do nothing.
'       Computes MGW based on coverages not annual departures.
        ReturnCoverages = FlexibleCoverages
'      End If
      Call ACNFlexComp
      FuncM1 = CBRThickness(1) - EvalThick
      DoEvents
'      Debug.Print J; "GrossWeight = "; GrossWeight; " "; NewtonCoeff
      NewtonCoeff = 1#
    Loop Until Abs(FuncM1) < 0.0001
  
  Else
    
    chkPCAThicknessDesignSave = chkPCAThicknessDesign.Value
    If chkPCAforGrossWeight.Value = vbChecked Then
      chkPCAThicknessDesign.Value = vbChecked
    Else
      chkPCAThicknessDesign.Value = vbUnchecked
    End If
    Call RigidACN
    CriticalACThick = RigidThickness(1) ' Used only for output.
    FuncM1 = RigidThickness(1) - EvalThick
    
    Do
      J = J + 1
      GrossWt = GrossWeight
      GrossWeight = GrossWeight + DelGrossWt
      LastThick = RigidThickness(1)
      Call RigidACN
      If RigidThickness(1) = 0 Then Exit Do ' Occurs in ACNRigComp when very light load for PCA.
      DelThick = RigidThickness(1) - LastThick
      If J >= 50 Then
        SS = "The gross weight iteration cannot converge." & vbCrLf & vbCrLf
        SS = SS & "The last two thickness values were:" & vbCrLf & vbCrLf
        SS = SS & Format(LastThick * UnitsOut.inch, UnitsOut.inchFormat) & " and "
        SS = SS & Format(RigidThickness(1) * UnitsOut.inch, UnitsOut.inchFormat) & " " & UnitsOut.inchName
        MsgBox SS, vbOKOnly, "Cannot Converge"
        Exit Do
      End If
      If DelThick = 0 Then
        SS = "Two successive thickness evaluations gave the same thickness." & vbCrLf
        SS = SS & "The calculation of allowable gross weight cannot converge." & vbCrLf
        SS = SS & "The evaluation thickness may be too large."
        MsgBox SS, vbOKOnly, "Thickness May Be Too Large"
        Exit Do
      End If
      Do
        If (GrossWt - NewtonCoeff * FuncM1 * DelGrossWt / DelThick) < (GrossWt * MinGLFraction) Then
          NewtonCoeff = NewtonCoeff / 2
        Else
          Exit Do
        End If
      Loop
      GrossWeight = GrossWt - NewtonCoeff * FuncM1 * DelGrossWt / DelThick
      
'      If CallSource = "MGWOnly" Then
'      If chkMGWcovs.Value = vbUnchecked Then
'       Computes MGW based on annual departures because converts to coverages in CoverageToPass().
'        WheelRadius = GrossWeight * PcntOnMainGears / (100 * NMainGears * NWheels)
'        WheelRadius = Sqr(WheelRadius / TirePressure / PI)
'        Call CoverageToPass ' Sets FlexibleCoverages and RigidCoverages, used in RigidACN().
'        ReturnCoverages = RigidCoverages
'      ElseIf CallSource = "MGWforPCN" Then
'      ElseIf chkMGWcovs.Value = vbChecked Then
'       Computes MGW based on coverages not annual departures.
'        ReturnCoverages = FlexibleCoverages ' Output error found by Jeff Rapol. Fixed by GFH 03/06/13.
        ReturnCoverages = RigidCoverages
'      End If
      
      Call RigidACN
      If RigidThickness(1) = 0 Then Exit Do
'     The following is required for the H51 program gross weight determination. H51 appears to have fairly
'     large granularity in this mode. Maybe gross weight is converted to an integer, or something similar.
'     The linear interpolation should work ok with the PCA method for the last step.
      GrossWeightM2 = GrossWeightM1
      GrossWeightM1 = GrossWeight
      ThickM4 = ThickM3
      ThickM3 = ThickM2
      ThickM2 = ThickM1
      ThickM1 = RigidThickness(1)
'      Debug.Print J; ThickM4; ThickM3; ThickM2; ThickM1; RigidThickness(1); GrossWeightM2; GrossWeightM1
      If (ThickM3 = ThickM1 And ThickM4 = ThickM2) Or (Abs(EvalThick - ThickM1) < 0.1 And J > 1) Then
        DelThick = ThickM1 - ThickM2
        If Abs(DelThick) > 1E-20 Then  ' Let the J >= 20 test above terminate if necessary.
          GrossWeight = ((GrossWeightM1 - GrossWeightM2) / DelThick) * (EvalThick - ThickM2) + GrossWeightM2
          RigidThickness(1) = EvalThick
'          Debug.Print J; ThickM2; ThickM1; GrossWeightM2; GrossWeightM1; EvalThick; GrossWeight
          Exit Do
        End If
      End If
      FuncM1 = RigidThickness(1) - EvalThick
      DoEvents
'      Debug.Print J; "GrossWeight = "; GrossWeight; "Thickness = "; RigidThickness(1); "Coverages = "; Coverages; " "; NewtonCoeff
      NewtonCoeff = 1#
    Loop Until Abs(FuncM1) < 0.0001
'    Debug.Print J; "GrossWeight = "; GrossWeight; "Thickness = "; RigidThickness(1); "Coverages = "; Coverages
    Debug.Print "Pcnt = "; PcntOnMainGears; "Area = "; TireContactArea
    chkPCAThicknessDesign.Value = chkPCAThicknessDesignSave
  
  End If
  
  cmdFlexibleCompute.Enabled = True
  cmdRigidCompute.Enabled = True
  
  lblMessage.Caption = "MGW = " & Format(GrossWeight * UnitsOut.pounds, UnitsOut.poundsFormat) & " " & UnitsOut.poundsName
'  S = S & "    Critical Airplane Allowable Gross Weight = "
'  S = S & Format(GrossWeight * UnitsOut.pounds, UnitsOut.poundsFormat) & " " & UnitsOut.poundsName & vbCrLf & vbCrLf
  
'  txtMGW(lstLibFile.ListIndex) = GrossWeight
  MGW = GrossWeight
  
'  libGL(libIndex) = GrossWeightSave
'  libCoverages(libIndex) = CoveragesSave
  GrossWeight = GrossWeightSave
  WheelRadius = WheelRadiusSave
  FlexibleCoverages = FlexibleCoveragesSave
  RigidCoverages = RigidCoveragesSave
  AnnualDepartures = AnnualDeparturesSave
  Call WriteParmGrid
  
End Sub
Private Sub cmdRemoveACfromLibrary_Click()

  Dim I As Integer, II As Integer, J As Integer
  Dim S$

  If lstACGroup.ListIndex + 1 <> ExternalLibraryIndex Then
    S$ = JobTitle$ & " was selected" & vbCrLf
    S$ = S$ & "from the internal library." & NL2
    S$ = S$ & "Aircraft cannot be removed" & vbCrLf
    S$ = S$ & "from the internal library."
    Ret = MsgBox(S$, 0, "Removing an Aircraft")
    Exit Sub
  End If
  
  S$ = "All data for " & JobTitle$ & vbCrLf
  S$ = S$ & "will be removed from the external library." & NL2
  S$ = S$ & "Once removed, the data cannot be restored." & NL2
  S$ = S$ & "Do you want to remove the data?"
  Ret = MsgBox(S$, vbYesNo, "Removing an Aircraft")
  If Ret = vbNo Then Exit Sub

' Move all data down one place to current aircraft.
  For I = libIndex To libNAC - 1
  
    II = I + 1
    libACName$(I) = libACName$(II)
    libGL(I) = libGL(II)
    libNMainGears(I) = libNMainGears(II)
    
    'ikawa 02/11/03
    libPcntOnMainGears(I, ACN_mode) = libPcntOnMainGears(II, ACN_mode)
    libPcntOnMainGears(I, Thick_mode) = libPcntOnMainGears(II, Thick_mode)
    
    libNTires(I) = libNTires(II)
    
    For J = 1 To libNTires(I)
      libTY(I, J) = libTY(II, J)
      libTX(I, J) = libTX(II, J)
    Next J

    libCP(I) = libCP(II)
    libXGridOrigin(I) = libXGridOrigin(II)
    libXGridMax(I) = libXGridMax(II)
    libXGridNPoints(I) = libXGridNPoints(II)
    libYGridOrigin(I) = libYGridOrigin(II)
    libYGridMax(I) = libYGridMax(II)
    libYGridNPoints(I) = libYGridNPoints(II)
    libTireContactArea(I) = libTireContactArea(II)
'    libCoverages(I) = libCoverages(II)
    libAnnualDepartures(I) = libAnnualDepartures(II)
  Next I

  IACAddedorRemoved = libIndex
  
  libNAC = libNAC - 1
  Call UpdateDataFromLibrary(libIndex)
  Call WriteExternalFile
  
'  lstACGroupIndex = ExternalLibraryIndex - 1
'  lstACGroup.ListIndex = lstACGroupIndex
'  ILibACGroup = lstACGroupIndex + 1
'  lstACGroup.Selected(lstACGroup.ListIndex) = True
  Call lstACGroup_Click

End Sub

Private Sub cmdRemoveWheel_Click()

EditWheels = True 'Izydor Kawa code
  
  If NWheels = 1 Then
    S$ = "The gear has only one wheel." & vbCrLf
    S$ = S$ & "The wheel cannot be removed."
    Ret = MsgBox(S$, 0, "Removing a Wheel")
  Else
    Operation = RemoveWheel
  End If
  
End Sub

Private Sub cmdRigidCompute_Click()

  Dim MGW As Double, CriticalACThick As Double
  
  lblMessage.Caption = ""
  
'  Coverages = RigidCoverages
  If optCalcMode(6) Then
    Call FlexibleandRigidPCN("Rigid")
  ElseIf ACN_mode_true And Not PCN_mode_true Then
    Call RigidACNforBatch("FromACN")
  ElseIf Not ACN_mode_true And Not PCN_mode_true And Not MaxGrossWeightTrue Then
    Call RigidThicknessEdge ' Not strictly edge now that PCA method is included.
  ElseIf PCN_mode_true Then
    Call FlexibleandRigidPCN("Rigid")
  ElseIf MaxGrossWeightTrue Then
    Call FlexibleandRigidMGW("Rigid")
  End If

End Sub

Private Sub cmdSaveACinLibrary_Click()

  Dim S$, FullFileName$, I As Long
  On Error GoTo SaveFileError
  
'  If lstACGroup.ListIndex + 1 <> ExternalLibraryIndex Then
'  If lstACGroupIndex + 1 <> ExternalLibraryIndex Then
'    S$ = JobTitle$ & " was selected" & vbCrLf
'    S$ = S$ & "from the internal library." & NL2
'    S$ = S$ & "Data in the internal library" & vbCrLf
'    S$ = S$ & "cannot be changed." & NL2
'    S$ = S$ & "Do you want to add the data for the" & vbCrLf
'    S$ = S$ & "current aircraft to the external library?"
'    Ret = MsgBox(S$, vbYesNo, "Saving Current Data")
'    If Ret = vbNo Then
'      Exit Sub
'    Else
'      cmdAddACtoLibrary.Value = True
'      Exit Sub
'    End If
'  End If
  
'  S$ = "The current data for " & JobTitle$ & vbCrLf
'  S$ = S$ & "will replace the data in the external library." & NL2
'  S$ = S$ & "Do you want to change the data for the" & vbCrLf
'  S$ = S$ & "current aircraft in the external library?"
'  Ret = MsgBox(S$, vbYesNo, "Saving Current Data")
'  If Ret = vbNo Then
'    Exit Sub
'  Else
'    Call UpdateLibraryData(libIndex)
'    Call WriteExternalFile
'  End If
  
  CdlFiles.InitDir = ExtFilePath$
  CdlFiles.Filter = "ext files|*.ext"
  CdlFiles.CancelError = True
  CdlFiles.ShowSave  ' Skip rest of sub on Cancel.
  ExternalAircraftFileName$ = CdlFiles.FileTitle
  FullFileName$ = CdlFiles.FileName
  ExtFilePath$ = Left$(FullFileName$, Len(FullFileName$) - Len(ExternalAircraftFileName$))
  Debug.Print FullFileName$; " "; ExtFilePath$; " "; ExternalAircraftFileName$
  CdlFiles.InitDir = ExtFilePath$
'  FileExt$ = Right$(DatFileName$, 4)
  ExternalAircraftFileName$ = Left$(ExternalAircraftFileName$, Len(ExternalAircraftFileName$) - 4)
  I = frmGear.Width / 120 - Len(frmGearCaptionStart) - 5 ' 120 = twips / character.
  If I < Len(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext") Then S = "..." Else S = ""
  frmGear.Caption = frmGearCaptionStart & S & Right(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext", I)
  Call UpdateLibraryData(libIndex)
  Call WriteExternalFile
  
  Exit Sub

SaveFileError:
  Debug.Print "Error No = "; Err
  If Err = cdlCancel Then Exit Sub
  Ret = MsgBox(Err.Description & " occurred writing the external airplane file.", vbOKOnly, "File Error")

End Sub

Private Sub cmdSelectWheel_Click()
  
  'EditWheels = True 'Izydor Kawa code
  
  If ComputingRigid Then
    cmdSelectWheel.Caption = "Dese&lect"
    Exit Sub
  End If
  
  If cmdSelectWheel.Caption <> "Dese&lect" Then
    LastOperation = Operation
    Operation = SelectAWheel
    cmdSelectWheel.Caption = "Dese&lect"
  Else
    LastOperation = NoOperation
    Operation = NoOperation
    cmdSelectWheel.Caption = "Se&lect"
    lblXSelected.Caption = ""
    lblYSelected.Caption = ""
    StartWheelIndex = 0
    Call PlotGear
  End If
  
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)

  If KeyAscii = vbKeyEscape Then
    StopComputation = True
  End If
  KeyAscii = 0

End Sub

Private Sub Form_Load()
  
  If ACNOnly Then
    frmGearCaptionStart = "ACN Comp 1.0, August 26, 2011 - "
  Else
    frmGearCaptionStart = "COMFAA 3.0, August 26, 2011 - "
  End If
  
  picGear.AutoRedraw = True
  picGear.Visible = True
  lblXcoord.BackColor = frmGear.BackColor
  lblYcoord.BackColor = frmGear.BackColor
  lblXSelected.BackColor = frmGear.BackColor
  lblYSelected.BackColor = frmGear.BackColor
  lblMessage.BackColor = frmGear.BackColor
    
  fraCompMode.Visible = False
  fraPCNBatchMode.Visible = True
  fraPCNBatchMode.Top = fraCompMode.Top
  fraPCNBatchMode.Left = fraCompMode.Left
    
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  
  Dim I As Integer
  
  If NWheels <> libNTires(libIndex) Then GoTo ExitDataChanged
  If CSng(GrossWeight) <> libGL(libIndex) Then GoTo ExitDataChanged
  If NMainGears <> libNMainGears(libIndex) Then GoTo ExitDataChanged
  
  If ACN_mode_true Then  'checked 02/14/03 ikawa
    If CSng(PcntOnMainGears) <> libPcntOnMainGears(libIndex, ACN_mode) Then GoTo ExitDataChanged
    'If CSng(TirePressure) <> libCP(libIndex) Then GoTo ExitDataChanged
  Else
    If SamePcntAndPress Then
      If CSng(PcntOnMainGears) <> CSng(libPcntOnMainGears(libIndex, ACN_mode)) Then GoTo ExitDataChanged
    Else
      If CSng(PcntOnMainGears) <> CSng(libPcntOnMainGears(libIndex, Thick_mode)) Then GoTo ExitDataChanged
      'If CSng(TireContactArea) <> CSng(libTireContactArea(libIndex)) Then GoTo DataChanged
    End If
'    If Coverages <> libCoverages(libIndex) Then GoTo ExitDataChanged
    If AnnualDepartures <> libAnnualDepartures(libIndex) Then GoTo ExitDataChanged
  End If
  
  If CSng(TirePressure) <> CSng(libCP(libIndex)) Then GoTo ExitDataChanged
  
  For I = 1 To NWheels
    If XWheels(I) <> libTY(libIndex, I) Then GoTo ExitDataChanged
    If YWheels(I) <> libTX(libIndex, I) Then GoTo ExitDataChanged
  Next I

  Exit Sub

ExitDataChanged:
  
  S$ = "Data for the current gear has changed." & NL2
  S$ = S$ & "Do you want to save the new data" & vbCrLf
  S$ = S$ & "before returning to windows?"
  Ret = MsgBox(S$, vbYesNoCancel, "Save Current Data?")
  If Ret = vbYes Then
    Call UpdateDataFromLibrary(libIndex)
  ElseIf Ret = vbCancel Then
    Cancel = True
  End If

End Sub

Private Sub Form_Resize()

  If Not frmGearStarted Then Exit Sub
  If WindowState = vbMinimized Then Exit Sub
  
  Call MainResize
  Call PlotGear
  
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Dim dwCookie As Long
  Const HH_UNINITIALIZE = &H1D
  Const HH_CLOSE_ALL = &H12        ' Terminate help
'  close the help file
    dwCookie = 0
    Ret = HtmlHelp(CLng(0), vbNullString, HH_CLOSE_ALL, CLng(0))
    Ret = HtmlHelp(CLng(0), vbNullString, HH_UNINITIALIZE, dwCookie)
  DoEvents

  Unload Me
  End
End Sub

Private Sub grdOutput_Click()
  
  Dim I As Integer, ValueChanged As Boolean
  
  If ComputingFlexible Or ComputingRigid Then Exit Sub
  
  If ACN_mode_true Then Exit Sub
  
  If grdOutput.Row = 0 Then
  
    If grdOutput.Col = CBRCol Then
    
      Call ChangeInputCBR(ValueChanged)
      If ValueChanged Then
        For I = 1 To NSubgrades
          ACNFlexCBR(I) = 0
          CBRThickness(I) = 0
          ACNFlex(I) = 0
        Next I
        Call WriteOutputGrid
        Call PlotGear
      End If
      
    ElseIf grdOutput.Col = kCol Then
    
      Call ChangeInputkValue(ValueChanged)
      If ValueChanged Then
      
        Call MainSetGrids 'ik02
      
        For I = 1 To NSubgrades
          ACNRigidk(I) = 0
          RigidThickness(I) = 0
          ACNRigid(I) = 0
        Next I
        StartWheelIndex = 0
        Call WriteOutputGrid
        Call PlotGear
        
      End If
      
    End If
    
  End If

End Sub

Private Sub grdParms_Click()

  Dim I As Integer, ValueChanged As Boolean
  Dim AlphaChanged As Boolean, RigidCutoffChanged As Boolean
  Dim RigidStrengthChanged As Boolean 'Izydor code
  Dim PtoTCChanged As Boolean, PtoTCOld As Double
  
  mode_changed = False 'ikawa 02/14/03
  
  If ComputingFlexible Or ComputingRigid Then Exit Sub
  
  If grdParms.Row = GrossWeightRow Then
    Call ChangeGrossWeight(ValueChanged)
'    If ValueChanged Then
'      WheelRadius = GrossWeight * PcntOnMainGears / (100 * NMainGears * NWheels)
'      WheelRadius = Sqr(WheelRadius / TirePressure / PI)
'      Call CoverageToPass ' Sets FlexibleCoverages and RigidCoverages, used in ACNFlexComp().
'    End If
  ElseIf grdParms.Row = PcntOnMainGearsRow Then
    Call ChangePcntOnMainGears(ValueChanged)
'    If ValueChanged Then Call CoverageToPass
  ElseIf grdParms.Row = NMainGearsRow Then
    Call ChangeNMainGears(ValueChanged)
'    If ValueChanged Then Call CoverageToPass
  ElseIf grdParms.Row = TirePressureRow Then
    If LibACGroupName$(ILibACGroup) = "External Library" Then
      
      If ACN_mode_true Or True Then
        Call ChangeTirePressure(ValueChanged)
      Else
        Call ChangeTireContactArea(ValueChanged)
      End If
    
    End If
  ElseIf grdParms.Row = PtoTCRow Then
    If Not ACN_mode_true Then
      PtoTCOld = PtoTC
      Call ChangeInputAlpha(ValueChanged) ' Now sets PtoTC, GFH 9/16/09.
'      AlphaChanged = ValueChanged
      PtoTCChanged = ValueChanged
    End If
  ElseIf grdParms.Row = AnnualDeparturesRow Then 'CoveragesRow Then
    If Not ACN_mode_true Then
'      Call ChangeCoverages(ValueChanged)  '01.13.03 ikawa
      Call ChangeAnnualDepartures(ValueChanged)
    End If
  ElseIf grdParms.Row = FlexibleCoveragesRow Then 'AnnualDeparturesRow Then
    If Not ACN_mode_true Then
      Call ChangeFlexibleCoverages(ValueChanged)
    End If
  ElseIf grdParms.Row = RigidCoveragesRow Then
    If Not ACN_mode_true Then
      Call ChangeRigidCoverages(ValueChanged)
    End If
  ElseIf grdParms.Row = RigidCutoffRow Then
    Call ChangeRigidCutoff(ValueChanged)
     RigidCutoffChanged = ValueChanged 'Izydor Kawa code
' Izydor Kawa code Begin
  ElseIf grdParms.Row = FlexStrengthOfConcRow Then
    Call ChangeConcreteStrength(ValueChanged)
    RigidStrengthChanged = ValueChanged
' Izydor Kawa code End
  End If
  
  If ValueChanged Then
    For I = 1 To NSubgrades
      If Not RigidCutoffChanged Then  ' Cutoff only applies to rigid.
        ACNFlexCBR(I) = 0
        CBRThickness(I) = 0
        ACNFlex(I) = 0
      End If
      If Not AlphaChanged Then  ' Alpha only applies to flexible.
        ACNRigidk(I) = 0
        RigidThickness(I) = 0
        ACNRigid(I) = 0
        StartWheelIndex = 0
      End If
    Next I
    Call WriteOutputGrid
    If Not (RigidCutoffChanged Or RigidStrengthChanged Or AlphaChanged Or PtoTCChanged) Then
      WheelRadius = GrossWeight * PcntOnMainGears / (100 * NMainGears * NWheels)
      WheelRadius = Sqr(WheelRadius / TirePressure / PI)
      Call CoverageToPass ' Sets FlexibleCoverages and RigidCoverages, used in ACNFlexComp().
    End If
    If PtoTCChanged Then
'      Coverages = FlexibleAnnualDepartures * 20 * PtoTC / PtoCFlex
      FlexibleCoverages = FlexibleCoverages * PtoTC / PtoTCOld
      RigidCoverages = RigidCoverages * PtoTC / PtoTCOld
    End If
    Call PlotGear ' Calls WriteParmGrid.
  End If

'  Call lstLibFile_Click

End Sub

Private Sub lblXSelected_Click()
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  If LastOperation <> SelectAWheel Then Exit Sub
  If ComputingFlexible Or ComputingRigid Then Exit Sub
  
  CurrentValue = XWheels(LastIWheel)
'  MinValue = -1000
'  MaxValue = 1000
  MinValue = -1000 * UnitsOut.inch 'modified by Izydor Kawa
  MaxValue = 1000 * UnitsOut.inch  'modified by Izydor Kawa


  S$ = "The current longitudinal coordinate (X direction)" & vbCrLf
  S$ = S$ & "of the selected wheel is "
  'S$ = S$ & Format(CurrentValue, "#,##0.00") & " inches." & NL2
  S$ = S$ & Format(CurrentValue * UnitsOut.inch, UnitsOut.inchFormat + " ") _
       & UnitsOut.inchName & "." & NL2 'modified by Izydor Kawa
  
  S$ = S$ & "Enter a new value in the range:"
'  S$ = S$ & NL2 & Format(MinValue, "#,###,##0")
  S$ = S$ & NL2 & Format(MinValue, UnitsOut.inchFormat) 'modified by Izydor Kawa
  
'  S$ = S$ & " to " & Format(MaxValue, "#,###,##0") & "."
  S$ = S$ & " to " & Format(MaxValue, UnitsOut.inchFormat) & "."   'modified by Izydor Kawa
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Selected Wheel X"
  
  If GetInputSingle(S$, SS$, SVS) Then
  
    NewValue = SVS

'   Check to See if Value is within range.
    If NewValue < MinValue Or MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "X coordinates cannot be less than "
'      S$ = S$ & Format(MinValue, "0.000") & vbCrLf
      S$ = S$ & Format(MinValue * UnitsOut.inch, UnitsOut.inchFormat) & vbCrLf 'modified by Izydor Kawa
      
      S$ = S$ & "or greater than "
'      S$ = S$ & Format(MaxValue, "0.000") & "." & NL2
      S$ = S$ & Format(MaxValue * UnitsOut.inch, UnitsOut.inchFormat) & "." & NL2 'modified by Izydor Kawa
      
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
    End If
       
'    XWheels(LastIWheel) = NewValue
    XWheels(LastIWheel) = NewValue / UnitsOut.inch 'modified by Izydor Kawa
  
  End If

  LastOperation = ChangeYCoordinate
  lblXSelected.Caption = ""
  lblYSelected.Caption = ""
  cmdSelectWheel.Value = True
  Call PlotGear

End Sub

Private Sub lblYSelected_Click()

  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  If LastOperation <> SelectAWheel Then Exit Sub
  
  CurrentValue = YWheels(LastIWheel)
'  MinValue = -1000
'  MaxValue = 1000
  MinValue = -1000 * UnitsOut.inch 'modified by Izydor Kawa
  MaxValue = 1000 * UnitsOut.inch 'modified by Izydor Kawa


  S$ = "The current lateral coordinate (Y direction)" & vbCrLf
  S$ = S$ & "of the selected wheel is "
'  S$ = S$ & Format(CurrentValue, "#,##0.00") & " inches." & NL2
  S$ = S$ & Format(CurrentValue * UnitsOut.inch, UnitsOut.inchFormat + " ") _
       & UnitsOut.inchName & "." & NL2 'modified by Izydor Kawa
  
  S$ = S$ & "Enter a new value in the range:"
'  S$ = S$ & NL2 & Format(MinValue, "#,###,##0")
  S$ = S$ & NL2 & Format(MinValue, UnitsOut.inchFormat) 'modified by Izydor Kawa
  
'  S$ = S$ & " to " & Format(MaxValue, "#,###,##0") & "."
  S$ = S$ & " to " & Format(MaxValue, UnitsOut.inchFormat) & "." 'modified by Izydor Kawa
  
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Selected Wheel Y"
  
  If GetInputSingle(S$, SS$, SVS) Then
  
    NewValue = SVS

'   Check to See if Value is within range.
    If NewValue < MinValue Or MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "Y coordinates cannot be less than "
'      S$ = S$ & Format(MinValue, "0.000") & vbCrLf
      S$ = S$ & Format(MinValue * UnitsOut.inch, UnitsOut.inchFormat) & vbCrLf 'modified by Izydor Kawa

      S$ = S$ & "or greater than "
'      S$ = S$ & Format(MaxValue, "0.000") & "." & NL2
      S$ = S$ & Format(MaxValue * UnitsOut.inch, UnitsOut.inchFormat) & "." & NL2 'modified by Izydor Kawa
      
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
    End If
    
'    YWheels(LastIWheel) = NewValue
    YWheels(LastIWheel) = NewValue / UnitsOut.inch 'modified by Izydor Kawa

  End If

  LastOperation = ChangeYCoordinate
  lblXSelected.Caption = ""
  lblYSelected.Caption = ""
  cmdSelectWheel.Value = True
  Call PlotGear

End Sub


Public Sub lstACGroup_Click()
  
  Dim I As Integer, J As Integer, FullFileName$
  Static Started As Boolean
  On Error GoTo ReadFileError

  EditWheels = False 'Izydor Kawa code
  mode_changed = False 'ikawa 02/14/03
  
' If data has changed, then changing to another group displays
' the "do you want to save the data" dialog box. Responding
' "Cancel" moves the selection back to the previous group in
' the list, calling this subroutine recursively. Hence the
' following code to skip the subroutine on recursion.

  If ChangeDataRet = vbCancel Then Exit Sub
  If ChangeDataRet = 0 Then
    Call CheckChangedData
      If ChangeDataRet <> 0 Then
      ChangeDataRet = 0
      Exit Sub
    End If
  End If
   
  If InputkValue <> 0 Then 'ik02
    Call MainSetGrids 'ik02
  End If
   
  lstACGroupIndex = lstACGroup.ListIndex
  ILibACGroup = lstACGroupIndex + 1

  For I = lstLibFile.ListCount - 1 To 0 Step -1
    lstLibFile.RemoveItem I
  Next I
  
  If ILibACGroup = NLibACGroups Then
'    J = libNAC - NBelly
    J = libNAC
  Else
    J = LibACGroup(ILibACGroup + 1) - 1
  End If

  For I = LibACGroup(ILibACGroup) To J
    lstLibFile.AddItem libACName$(I)
  Next I

  If IACAddedorRemoved <> 0 Then
    I = IACAddedorRemoved - LibACGroup(ExternalLibraryIndex)
    IACAddedorRemoved = 0
  Else
    I = 0
  End If
  
  If I >= lstLibFile.ListCount Then I = lstLibFile.ListCount - 1
  lstLibFileIndex = I
  If I > -1 Then lstLibFile.Selected(I) = True
  
  lblCriticalAircraftText.Caption = "" ' Critical airplane needs to be reset.
  
  Exit Sub
  
ReadFileError:
  Debug.Print "Error No = "; Err
  If Err = cdlCancel Then Exit Sub
  Ret = MsgBox(Err.Description & " occurred reading the external airplane file.", vbOKOnly, "File Error")
End Sub


Private Sub picGear4_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
  If Button = 2 Then
    Clipboard.Clear
    Clipboard.SetData picGear.Image
  End If
End Sub


Public Sub PlotGear()

  Dim I As Integer, II As Integer, N As Integer, Ilst As Integer
  Dim MaxWidthBy2 As Single, picAspect As Single, L As Long
  Dim xtl As Single, ytl As Single, xbr As Single, ybr As Single
  Dim XMin As Double, XMax As Double, Ymin As Double, YMax As Double
  Dim MaxHeightBy2 As Double, Rad As Double
  Dim XCenter As Double, YCenter As Double
  Dim Xcg As Double, Ycg As Double
  Dim Delta As Double, Add As Double
  Dim SaveFontSize As Single
  Const PI As Double = 3.14159265359

' Gear axes are X +ve forward, Y +ve to the right.
' Gear axes on screen are X +ve upward, Y +ve to the right.
' Screen axes are X +ve to the right, Y +ve upward.
' Therefore, screen coordinates are written (y, x) in gear axes.
' Remember when drawing on screen and returning screen coordinates from mouse.

' Global units are English units.
  
  picGear.Cls
  
  Call GearCG(XWheels(), YWheels(), NWheels, Xcg, Ycg)
  
  XMin = 1E+20: XMax = -1E+20
  Ymin = 1E+20: YMax = -1E+20
  For I = 1 To NWheels
    If XWheels(I) < XMin Then XMin = XWheels(I)
    If XWheels(I) > XMax Then XMax = XWheels(I)
    If YWheels(I) < Ymin Then Ymin = YWheels(I)
    If YWheels(I) > YMax Then YMax = YWheels(I)
  Next I
  XMin = XMin - WheelRadius:  XMax = XMax + WheelRadius
  Ymin = Ymin - WheelRadius:  YMax = YMax + WheelRadius
  
  MaxHeightBy2 = 1.5 * (XMax - XMin) / 2 ' For maximum gear height in inches.
  MaxWidthBy2 = 1.2 * (YMax - Ymin) / 2  ' For maximum gear width in inches.
  XCenter = (XMax + XMin) / 2
  YCenter = (YMax + Ymin) / 2
  
  picAspect = picGear.Height / picGear.Width
  
  If MaxHeightBy2 / MaxWidthBy2 < picAspect Then
    xtl = XCenter + MaxWidthBy2 * picAspect:  ytl = YCenter - MaxWidthBy2
    xbr = XCenter - MaxWidthBy2 * picAspect:  ybr = YCenter + MaxWidthBy2
  Else
    xtl = XCenter + MaxHeightBy2: ytl = YCenter - MaxHeightBy2 / picAspect
    xbr = XCenter - MaxHeightBy2: ybr = YCenter + MaxHeightBy2 / picAspect
  End If

  picGear.Scale (ytl, xtl)-(ybr, xbr)

  SaveFontSize = picGear.FontSize
  picGear.FontSize = 10
  S$ = JobTitle$ ' ACName$(IAC)
  picGear.CurrentX = ytl + (ybr - ytl - picGear.TextWidth(S$)) / 2
  picGear.CurrentY = xtl + picGear.TextHeight(S$) * 0.2
  picGear.Print S$
  S$ = "Main Gear Footprint"
  picGear.CurrentX = ytl + (ybr - ytl - picGear.TextWidth(S$)) / 2
  picGear.CurrentY = xtl + picGear.TextHeight(S$) * 1.2
  picGear.Print S$
  picGear.FontSize = SaveFontSize
  
  For I = 1 To NWheels
    picGear.Circle (YWheels(I), XWheels(I)), WheelRadius
  Next I
  
  If XGridNPoints > 1 Then
    Delta = (XGridMax - XGridOrigin) / (XGridNPoints - 1)
    For I = 0 To XGridNPoints - 1
      Add = I * Delta
      picGear.Line (YGridOrigin, XGridOrigin + Add)-(YGridMax, XGridOrigin + Add)
    Next I
  End If

  If YGridNPoints > 1 Then
    Delta = (YGridMax - YGridOrigin) / (YGridNPoints - 1)
    For I = 0 To YGridNPoints - 1
      Add = I * Delta
      picGear.Line (YGridOrigin + Add, XGridOrigin)-(YGridOrigin + Add, XGridMax)
    Next I
  End If

' Draw the cg symbol with filled / unfilled successive quadrants.
  
  Rad = WheelRadius / 3
  L = picGear.FillColor
  
  picGear.FillColor = picGear.BackColor
  picGear.Circle (Ycg, Xcg), Rad, , -PI / 2, -PI
  picGear.Circle (Ycg, Xcg), Rad, , -3 * PI / 2, -2 * PI
  picGear.FillColor = L
  picGear.Circle (Ycg, Xcg), Rad, , -2 * PI, -PI / 2
  picGear.Circle (Ycg, Xcg), Rad, , -PI, -3 * PI / 2
  
' The circle fill sometimes draws vertical and horizontal quadrant lines
' slightly off-center. Drawing "lines" improves the visual effect somewhat.

  picGear.Line (Ycg - Rad, Xcg)-(Ycg + Rad, Xcg), picGear.BackColor
  picGear.Line (Ycg, Xcg - Rad)-(Ycg, Xcg + Rad), picGear.BackColor
  picGear.Line (Ycg - Rad, Xcg)-(Ycg + Rad, Xcg)
  picGear.Line (Ycg, Xcg - Rad)-(Ycg, Xcg + Rad)
  
' Background circle in single wheel to show cg symbol
' and show wheel at origin for rigid when > one wheel.

  If NWheels = 1 Then
    L = picGear.FillStyle
    picGear.FillStyle = vbFSTransparent
    picGear.Circle (Ycg, Xcg), Rad, picGear.BackColor
    picGear.FillStyle = L
  Else
    If StartWheelIndex > 0 Then
      I = StartWheelIndex
      Rad = WheelRadius * 0.6
      picGear.Line (YWheels(I) - Rad, XWheels(I)) _
                  -(YWheels(I) + Rad, XWheels(I)), vbWhite
      picGear.Line (YWheels(I), XWheels(I) - Rad) _
                  -(YWheels(I), XWheels(I) + Rad), vbWhite
    End If
  End If
      
  If chkPCAThicknessDesign.Value = vbChecked Then ' GFH 09-26-08.
    If StartWheelIndexPCA > 0 Then
      I = StartWheelIndexPCA
      Rad = WheelRadius * 0.6
      picGear.Line (YWheels(I) - Rad, XWheels(I)) _
                  -(YWheels(I) + Rad, XWheels(I)), vbWhite
      picGear.Line (YWheels(I), XWheels(I) - Rad) _
                  -(YWheels(I), XWheels(I) + Rad), vbWhite
    End If
    II = frmGear.picGear.FillStyle
    frmGear.picGear.FillStyle = vbFSTransparent
    frmGear.picGear.Circle (YWheels(I), XWheels(I)), PlotCutoffRad
    frmGear.picGear.Refresh
    frmGear.picGear.FillStyle = II
  End If
  
  Call GraphACN
  Call WriteParmGrid
  
End Sub

Public Sub lstLibFile_Click()
  
  Dim I As Integer, J As Integer
  
  EditWheels = False 'Izydor Kawa code
    
' If data has changed, then changing to another aircraft displays
' the "do you want to save the data" dialog box. Responding
' "Cancel" moves the selection back to the previous aircraft in
' the list, calling this subroutine recursively. Hence the
' following code to skip the subroutine on recursion.

  If ChangeDataRet = vbCancel Then Exit Sub
  If ChangeDataRet = 0 Then
'    If lstLibFileIndex = lstLibFile.ListIndex And GrossWeight > 0# Then GoTo SkipLibRefresh
    Call CheckChangedData
    If ChangeDataRet <> 0 Then
      ChangeDataRet = 0
      Exit Sub
    End If
  End If
  
  If ACN_mode_true Then 'ik02
    Call MainSetGrids 'ik02
  End If
  
  lstLibFileIndex = lstLibFile.ListIndex
  libIndex = LibACGroup(lstACGroupIndex + 1) + lstLibFile.ListIndex ' Library index
  
  JobTitle$ = libACName$(libIndex)
  GrossWeight = libGL(libIndex)
  NWheels = libNTires(libIndex)
  
  For I = 1 To NWheels
    XWheels(I) = libTY(libIndex, I)
    YWheels(I) = libTX(libIndex, I)
'    Debug.Print I; XWheels(I); YWheels(I)
  Next I
  
  TirePressure = libCP(libIndex)
  
  'ikawa 01/24/03
  If ACN_mode_true Then
    PcntOnMainGears = libPcntOnMainGears(libIndex, ACN_mode)
    Coverages = StandardCoverages
  Else
    PcntOnMainGears = libPcntOnMainGears(libIndex, Thick_mode)
'    Coverages = libCoverages(libIndex)
    AnnualDepartures = libAnnualDepartures(libIndex)
    If SamePcntAndPress Then
      PcntOnMainGears = libPcntOnMainGears(libIndex, ACN_mode)
    End If
  End If
  
  NMainGears = libNMainGears(libIndex)
  InputAlpha = libAlpha(libIndex)
  AlphaFactor = InputAlpha
  XGridOrigin = libXGridOrigin(libIndex)
  XGridMax = libXGridMax(libIndex)
  XGridNPoints = libXGridNPoints(libIndex)
  YGridOrigin = libYGridOrigin(libIndex)
  YGridMax = libYGridMax(libIndex)
  YGridNPoints = libYGridNPoints(libIndex)
  
  If RigidCutoff = 0 Then RigidCutoff = StandardRigidCutoff ' GFH 07-11-08.
  If ConcreteFlexuralStrength = 0 Then ' GFH 07-11-08.
    ConcreteFlexuralStrength = StandardConcreteStrength 'Izydor Kawa code
  End If
  TireContactArea = libTireContactArea(libIndex) 'ik03
'  InputCBR = 0     ' Does not change CBR when airplane is changed.
'  InputkValue = 0  ' Same for k value.
  
SkipLibRefresh:
  Call ResetOutputs
  Call PlotGear ' Also calls GearCG and updates the parameter output grid.
  Call WriteOutputGrid
  Call CoverageToPass
    
'  Call WriteParmGrid
    
  ACNFlexibleOutputText = ""
  ACNRigidOutputText = ""
  
End Sub

Private Sub lstLibFile_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
  
  mode_changed = False
  
  Dim Top As Long, ItemHeight As Integer, InsertPos As Long
  
  If Button = vbRightButton Then
    ItemHeight = ScaleY(lstLibFile.Font.Size, vbPoints, vbTwips) * 1.17
    InsertPos = Y \ ItemHeight + lstLibFile.TopIndex ' Top is needed when more items than can fit in the list box.
    If InsertPos < lstLibFile.ListCount Then
'     Highlight the new item. Either .ListIndex or .Selected
'     work. Both cause a click event and the _Click Sub must
'     be guarded to exit immediately if the click operation is not to be executed.
      lstLibFile.ListIndex = InsertPos
      CriticalACIndex = InsertPos
'      lstJobs.Selected(InsertPos) = True
      lblCriticalAircraftText.Caption = lstLibFile.Text
    End If
  End If
  
End Sub

Public Sub optCalcMode_Click(Index As Integer)

  mode_changed = True
  Call CheckChangedData
  
  If Index = 0 Then ' Compute ACN.
  
    ACN_mode_true = True
    PCN_mode_true = False
    Stress_mode = False 'ikawa
    MaxGrossWeightTrue = False
    rowsNumber = ACNrowsNumber
'    Coverages = StandardCoverages
'    PcntOnMainGears = libPcntOnMainGears(libIndex, ACN_mode)
    
  ElseIf Index = 1 Then ' Compute pavement thickness.
  
    ACN_mode_true = False
    PCN_mode_true = False
    MaxGrossWeightTrue = False
    Stress_mode = False 'ikawa
    rowsNumber = ThickrowsNumber
'    If Coverages = StandardCoverages And LibACGroupName$(lstACGroupIndex + 1) = "External Library" Then
'      Coverages = libCoverages(libIndex)
'    End If
'    PcntOnMainGears = libPcntOnMainGears(libIndex, Thick_mode)
'    TirePressure = libCP(libIndex)
    Call UpdateDataFromLibrary(libIndex)
    Call lstLibFile_Click
    
  ElseIf Index = 2 Then ' Compute PCN of the critical aircraft.
  
    PCN_mode_true = True
    ACN_mode_true = False ' Need this to switch in computational and data output subroutines.
    MaxGrossWeightTrue = False
    Stress_mode = False 'ikawa
    rowsNumber = ACNrowsNumber
'    If Coverages = StandardCoverages And LibACGroupName$(lstACGroupIndex + 1) = "External Library" Then
'      Coverages = libCoverages(libIndex)
'    End If
'    PcntOnMainGears = libPcntOnMainGears(libIndex, Thick_mode)
    Call UpdateDataFromLibrary(libIndex)
    Call lstLibFile_Click
    
  ElseIf Index = 3 Then ' Compute maximum gross weight of the list aircraft.
  
    ACN_mode_true = False
    PCN_mode_true = False
    MaxGrossWeightTrue = True
    Stress_mode = False
    MaxGrossWeightTrue = True
    Call UpdateDataFromLibrary(libIndex)
    Call lstLibFile_Click
    
  ElseIf Index = 4 Then ' Compute PCA stress, ikawa.
  
    ACN_mode_true = False
    PCN_mode_true = False
    MaxGrossWeightTrue = False
    Stress_mode = True

    chkPCAThicknessDesign.Value = 1
    Index3StressCalc = True
    lblStress.Visible = True
    txtStress.Visible = True
   
    ACN_mode_true = False
    PCN_mode_true = False
    rowsNumber = ThickrowsNumber
  
  ElseIf Index = 5 Then ' Compute edge stress, ikawa.
    
    chkPCAThicknessDesign.Value = 0
    ACN_mode_true = False
    PCN_mode_true = False
    MaxGrossWeightTrue = False
    Stress_mode = True
    rowsNumber = ThickrowsNumber
    
  ElseIf Index = 6 Then ' Compute Coverages to Failure (Life).
  
    ACN_mode_true = False
    PCN_mode_true = False
    MaxGrossWeightTrue = False
    Stress_mode = False 'ikawa
    rowsNumber = ThickrowsNumber
'    If Coverages = StandardCoverages And LibACGroupName$(lstACGroupIndex + 1) = "External Library" Then
'      Coverages = libCoverages(libIndex)
'    End If
'    PcntOnMainGears = libPcntOnMainGears(libIndex, Thick_mode)
'    TirePressure = libCP(libIndex)

  Else
'   Put a message box here.
  End If

  Call UpdateDataFromLibrary(libIndex)
  Call lstLibFile_Click
  Call MainSetGrids
  Call WriteParmGrid
  
End Sub
Private Sub picGear_DblClick()

  NotShowACNGraph = Not NotShowACNGraph
  Call PlotGear

End Sub

Private Sub picGear_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)
  
  Dim Radius As Double, I As Integer, L As Long
  Dim XX As Double, YY As Double
  
' Izydor Kawa code
  If Operation = SelectAWheel Then
    EditWheels = True
  End If
' Izydor Kawa code
  
  If Button = vbRightButton Then
    Clipboard.Clear
    Clipboard.SetData picGear.Image
    Exit Sub
  End If
  
  If Operation = NoOperation Then Exit Sub
  
  If Operation = SelectAWheel Or Operation = RemoveWheel Then
    XX = X:  YY = Y
    Call SelectWheel(XWheels(), YWheels(), YY, XX, Radius, IWheelSelected)
    LastIWheel = IWheelSelected
    LastXP = XWheels(LastIWheel)
    LastYP = YWheels(LastIWheel)
    
    If Operation = SelectAWheel Then
      lblXSelected.ForeColor = vbBlack
      
      lblXSelected.Caption = "X Sel. = " & Format(LastXP * UnitsOut.inch, "#,##0.00") & " " + UnitsOut.inchName
      lblYSelected.Caption = "Y Sel. = " & Format(LastYP * UnitsOut.inch, "#,##0.00") & " " + UnitsOut.inchName
      
      StartWheelIndex = IWheelSelected
      Call PlotGear
      
    ElseIf Operation = RemoveWheel Then

      If ACN_mode_true Then  'ikawa 02/14/03
        If Operation = RemoveWheel Then
          'TireContactArea = GrossWeight * PcntOnMainGears / (NWheels - 1) / NMainGears / TirePressure / 100 'ik0333
        End If
      Else
        If Operation = RemoveWheel Then
          If Not SamePcntAndPress Then
            TirePressure = GrossWeight * PcntOnMainGears / (NWheels - 1) / NMainGears / TireContactArea / 100 'ik0333
          End If
        End If
      End If
    
      NWheels = NWheels - 1
      For I = IWheelSelected To NWheels
        XWheels(I) = XWheels(I + 1)
        YWheels(I) = YWheels(I + 1)
      Next I
      
      Call ResetOutputs
      Call PlotGear
      Call CoverageToPass
  
    End If
    LastOperation = Operation
    Operation = NoOperation
    Exit Sub
  End If
    
  If Operation = MoveWheel Then
    Call SelectWheel(XWheels(), YWheels(), CSng(Y), CSng(X), Radius, IWheelSelected)
    picGear.ForeColor = picGear.BackColor
    picGear.FillColor = picGear.BackColor
    picGear.Circle (YWheels(IWheelSelected), XWheels(IWheelSelected)), WheelRadius
    picGear.ForeColor = vbBlack
    picGear.FillColor = vbBlack
    LastIWheel = IWheelSelected
    LastXP = XWheels(LastIWheel)
    LastYP = YWheels(LastIWheel)
  End If
  
  DragX = Int(X * CoordResolution) / CoordResolution
  DragY = Int(Y * CoordResolution) / CoordResolution
  picGear.FillStyle = vbFSTransparent
  picGear.ForeColor = vbWhite
  picGear.DrawMode = vbXorPen
  picGear.Circle (DragX, DragY), WheelRadius
  Dragging = True
  
End Sub

Private Sub picGear_MouseMove(Button As Integer, Shift As Integer, X As Single, Y As Single)
  
  Dim XT As Double, YT As Double
  
  XT = CInt(X * CoordResolution) / CoordResolution
  YT = CInt(Y * CoordResolution) / CoordResolution
  
'Izydor Kawa modified code Begin
'  lblXcoord.Caption = "  X = " & Format(YT, "0.0") & " in"
'  lblYcoord.Caption = "  Y = " & Format(XT, "0.0") & " in"
  lblXcoord.Caption = "  X = " & Format(YT * UnitsOut.inch, "0.0") & " " + UnitsOut.inchName
  lblYcoord.Caption = "  Y = " & Format(XT * UnitsOut.inch, "0.0") & " " + UnitsOut.inchName
'Izydor Kawa modified code End
  
  
  If Dragging Then
    picGear.FillStyle = vbFSTransparent
    picGear.DrawMode = vbXorPen
    picGear.Circle (DragX, DragY), WheelRadius
    DragX = XT
    DragY = YT
    picGear.Circle (DragX, DragY), WheelRadius
  End If

End Sub

Private Sub picGear_MouseUp(Button As Integer, Shift As Integer, X As Single, Y As Single)
  
  If Button = 2 Then           ' Right button.
    Clipboard.Clear
    Clipboard.SetData picGear.Image
    Exit Sub
  End If
  
  If Dragging Then
    picGear.FillStyle = vbFSSolid
    picGear.ForeColor = vbBlack
    picGear.DrawMode = vbCopyPen
    picGear.Circle (DragX, DragY), WheelRadius
    Dragging = False
  End If
  
  If ACN_mode_true Then  'ikawa 02/14/03
    If Operation = AddWheel Then
    'TireContactArea = GrossWeight * PcntOnMainGears / (NWheels + 1) / NMainGears / TirePressure / 100 'ik0333
    End If
  Else
    If Operation = AddWheel Then
      If Not SamePcntAndPress Then
        TirePressure = GrossWeight * PcntOnMainGears / (NWheels + 1) / NMainGears / TireContactArea / 100 'ik0333
      End If
    End If
  End If
  
  If Operation = MoveWheel Or Operation = AddWheel Then
    If Operation = AddWheel Then
      NWheels = NWheels + 1
      IWheelSelected = NWheels
    End If
    YWheels(IWheelSelected) = DragX
    XWheels(IWheelSelected) = DragY
    LastOperation = Operation
    Operation = NoOperation
    Call ResetOutputs
    Call PlotGear
    Call CoverageToPass
  
  End If

End Sub



Public Sub GraphACN()

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
  
' Note: if Y becomes more positive from bottom to top, .TextHeight() is -ve.
  
  If NotShowACNGraph Then Exit Sub
  
  NPoints = 4
  ReDim VertPoint(1 To NPoints), HorizPoint(1 To NPoints)
  ReDim HorizText(1 To NPoints)
  
  With picGear
    SaveForeColor = picGear.ForeColor
    picGear.ForeColor = &HC0C0C0
  
    picLeft = .ScaleLeft:    picTop = .ScaleTop
    picWidth = .ScaleWidth:  picHeight = .ScaleHeight
    Tick = 0.01
    VertTicksLength = Tick * picWidth
    HorizTicksLength = Tick * picHeight
    GraphBorder = 0.1
  End With
  
  VertAxisX = picLeft + 1.1 * GraphBorder * picWidth
  VertAxisBottom = picTop + (1 - 1.1 * GraphBorder) * picHeight
  VertAxisTop = picTop + GraphBorder * picHeight
  
  HorizAxisY = VertAxisBottom
  HorizAxisLeft = VertAxisX
  HorizAxisRight = picLeft + (1 - GraphBorder) * picWidth
  
  HorizTicksN = NPoints
  DTemp = (HorizAxisRight - HorizAxisLeft) / 17
  HorizPoint(1) = HorizAxisLeft + DTemp * 3:   HorizPoint(2) = HorizAxisLeft + DTemp * 6
  HorizPoint(3) = HorizAxisLeft + DTemp * 10:  HorizPoint(4) = HorizAxisLeft + DTemp * 15
  HorizText(1) = "D":  HorizText(2) = "C"
  HorizText(3) = "B":  HorizText(4) = "A"
  For I = 1 To HorizTicksN
    DTemp = HorizAxisLeft + HorizPoint(I)
    picGear.Line (HorizPoint(I), HorizAxisY)-(HorizPoint(I), HorizAxisY + HorizTicksLength)
    picGear.CurrentX = HorizPoint(I) - picGear.TextWidth(HorizText(I)) / 2
    picGear.Print HorizText(I)
  Next I
  S$ = "Subgrade Category"
  picGear.CurrentX = HorizAxisLeft + (HorizAxisRight - HorizAxisLeft - picGear.TextWidth(S$)) / 2
  picGear.CurrentY = picGear.CurrentY - VertTicksLength * 0.5
  picGear.Print S$
  
  picGear.Line (VertAxisX, VertAxisBottom)-(VertAxisX, VertAxisTop)
  picGear.Line (HorizAxisLeft, HorizAxisY)-(HorizAxisRight, HorizAxisY)
  
  Max = 0
  For I = 1 To NPoints
    If ACNFlex(I) > Max Then Max = ACNFlex(I)
    If ACNRigid(I) > Max Then Max = ACNRigid(I)
  Next I
  
  picTextHeight = picGear.TextHeight("ABC")
  
  If Max = 0 Then Max = 99
  VertTicksN = (Int(Max / 10) + 1)
  DTemp = VertTicksN * 10
  VertScale = (VertAxisTop - VertAxisBottom) / DTemp
  For I = 1 To VertTicksN
    DTemp = VertAxisBottom + I * 10 * VertScale
    picGear.Line (VertAxisX, DTemp)-(VertAxisX - VertTicksLength, DTemp)
    S$ = Format(I * 10, "0")
    picGear.CurrentX = VertAxisX - VertTicksLength - picGear.TextWidth(S$)
    picGear.CurrentY = DTemp - picTextHeight / 2
    picGear.Print S$
  Next I
  
  S$ = Format((VertTicksN / 2 + 1) * 10, "0")
  TempX = VertAxisX - VertTicksLength * 2 - _
          picGear.TextWidth(S$) - picGear.TextWidth("A")
  DTemp = VertAxisBottom + (VertAxisTop - VertAxisBottom) / 2
  TempY = picTextHeight / 2
  picGear.CurrentX = TempX:  picGear.CurrentY = DTemp - TempY * 3
  picGear.Print "A"
  picGear.CurrentX = TempX:  picGear.CurrentY = DTemp - TempY
  picGear.Print "C"
  picGear.CurrentX = TempX:  picGear.CurrentY = DTemp + TempY
  picGear.Print "N"

  picGear.ForeColor = &H5144C4
  
  IExit = 1
  For I = 1 To NPoints - 1
    If ACNFlex(I + 1) <> 0 Then
      picGear.Line (HorizPoint(I), VertAxisBottom + ACNFlex(I) * VertScale)- _
                   (HorizPoint(I + 1), VertAxisBottom + ACNFlex(I + 1) * VertScale)
      IExit = I + 1
    Else
      Exit For
    End If
  Next I
  If IExit > 1 Then
    S$ = " Flexible"
    picGear.CurrentX = HorizPoint(IExit)
    picGear.CurrentY = VertAxisBottom + ACNFlex(IExit) * VertScale - picTextHeight / 2
'    picGear.Print S$
  End If


  picGear.ForeColor = &HC09736
  
  IExit = 1
  For I = 1 To NPoints - 1
    If ACNRigid(I + 1) <> 0 Then
      picGear.Line (HorizPoint(I), VertAxisBottom + ACNRigid(I) * VertScale)- _
                   (HorizPoint(I + 1), VertAxisBottom + ACNRigid(I + 1) * VertScale)
      IExit = I + 1
    Else
      Exit For
    End If
  Next I
  If IExit > 1 Then
    S$ = " Rigid"
    picGear.CurrentX = HorizPoint(IExit)
    picGear.CurrentY = VertAxisBottom + ACNRigid(IExit) * VertScale - picTextHeight / 2
'    picGear.Print S$
  End If
  
  TempX = picGear.TextWidth("1")
  TempY = Abs(ACNFlex(NPoints) - ACNRigid(NPoints))
  If TempY <= 1# * Abs(picTextHeight) Then
    TempY = TempY / 3
  Else
    TempY = Abs(picTextHeight) / 2
  End If
  If ACNFlex(NPoints) - ACNRigid(NPoints) > 0 Then
    picGear.ForeColor = &H5144C4
    picGear.CurrentX = HorizPoint(NPoints) + TempX
    picGear.CurrentY = VertAxisBottom + ACNFlex(NPoints) * VertScale - picTextHeight - TempY
    picGear.Print "Flexible"
    If ACNRigid(NPoints) <> 0 Then
      picGear.ForeColor = &HC09736
      picGear.CurrentX = HorizPoint(NPoints) + TempX
      picGear.CurrentY = VertAxisBottom + ACNRigid(NPoints) * VertScale + TempY
      picGear.Print "Rigid"
    End If
  ElseIf ACNRigid(NPoints) - ACNFlex(NPoints) > 0 Then
    If ACNFlex(NPoints) <> 0 Then
      picGear.ForeColor = &H5144C4
      picGear.CurrentX = HorizPoint(NPoints) + TempX
      picGear.CurrentY = VertAxisBottom + ACNFlex(NPoints) * VertScale + TempY
      picGear.Print "Flexible"
    End If
    picGear.ForeColor = &HC09736
    picGear.CurrentX = HorizPoint(NPoints) + TempX
    picGear.CurrentY = VertAxisBottom + ACNRigid(NPoints) * VertScale - picTextHeight - TempY
    picGear.Print "Rigid"
  End If
  
  picGear.ForeColor = SaveForeColor

End Sub

Private Sub txtEvaluationThickness_Click()

  Dim ValueChanged As Boolean
  Call ChangeEvaluationThickness(ValueChanged)
      
End Sub


