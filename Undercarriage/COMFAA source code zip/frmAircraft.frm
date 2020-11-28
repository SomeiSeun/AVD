VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "Msflxgrd.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "Comdlg32.ocx"
Begin VB.Form frmAircraft 
   Caption         =   "Aircraft Data Entry"
   ClientHeight    =   8640
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   9600
   LinkTopic       =   "Form1"
   ScaleHeight     =   8640
   ScaleWidth      =   9600
   StartUpPosition =   3  'Windows Default
   Begin MSComDlg.CommonDialog cdlACWFiles 
      Left            =   8880
      Top             =   7800
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdSaveList 
      Caption         =   "Save the List in the Current External File"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   6840
      TabIndex        =   7
      Top             =   7680
      Width           =   1815
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Return and Make the List the Current External File"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   720
      TabIndex        =   6
      Top             =   7680
      Width           =   1815
   End
   Begin VB.CommandButton cmdReturnAndDiscard 
      Caption         =   "Return and Discard the List"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   2760
      TabIndex        =   5
      Top             =   7680
      Width           =   1815
   End
   Begin VB.CommandButton cmdRemoveAircraft 
      Caption         =   "Remove the Currently SelectedAircraft"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   4800
      TabIndex        =   4
      Top             =   6720
      Width           =   1815
   End
   Begin VB.CommandButton cmdAddAircraft 
      Caption         =   "Add an Aircraft"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   2760
      TabIndex        =   3
      Top             =   6720
      Width           =   1815
   End
   Begin VB.CommandButton cmdSaveAsExternalFile 
      Caption         =   "Save the List as a New External File"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   4800
      TabIndex        =   2
      Top             =   7680
      Width           =   1815
   End
   Begin VB.CommandButton cmdOpenExternalFile 
      Caption         =   "Open an External File"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   720
      TabIndex        =   1
      Top             =   6720
      Width           =   1815
   End
   Begin MSFlexGridLib.MSFlexGrid grdAircraftList 
      Height          =   6015
      Left            =   240
      TabIndex        =   0
      Top             =   360
      Width           =   9135
      _ExtentX        =   16113
      _ExtentY        =   10610
      _Version        =   393216
      WordWrap        =   -1  'True
   End
End
Attribute VB_Name = "frmAircraft"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Const frmAircraftCaptionStart As String = "Aircraft Data"
Dim ACWGrossWeight As Double
Dim ACWExternalAircraftFileName As String, ACWFullFileName As String
Dim ACWExtFilePath As String
Dim ACWlibNAC As Integer, ACWNAC As Integer
Dim NGridCols
Dim ACWLibrary() As ACLibrary

Private Sub cmdOpenExternalFile_Click()

  Dim I As Integer, J As Integer, K As Integer
  Static Started As Boolean
  Dim ExtFilePathSave$, ExternalAircraftFileNameSave$
  On Error GoTo ReadFileError
  
  cdlACWFiles.InitDir = ExtFilePath$
  cdlACWFiles.Filter = "ext files|*.ext"
  cdlACWFiles.CancelError = True
  cdlACWFiles.ShowOpen  ' Skip rest of sub on Cancel.
  ACWExternalAircraftFileName$ = cdlACWFiles.FileTitle
  ACWFullFileName$ = cdlACWFiles.FileName
  ACWExtFilePath$ = Left$(ACWFullFileName$, Len(ACWFullFileName$) - Len(ACWExternalAircraftFileName$))
  Debug.Print ACWFullFileName$; " "; ACWExtFilePath$; " "; ACWExternalAircraftFileName$
  cdlACWFiles.InitDir = ACWExtFilePath$
  ACWExternalAircraftFileName$ = Left$(ACWExternalAircraftFileName$, Len(ACWExternalAircraftFileName$) - 4)
  ExtFilePathSave$ = ExtFilePath$
  ExternalAircraftFileNameSave$ = ExternalAircraftFileName$
  ExtFilePath$ = ACWExtFilePath$
  ExternalAircraftFileName$ = ACWExternalAircraftFileName$
  ACWIAStart = libNAC + 1
  ACWlibNAC = libNAC ' Number of aircraft without the new external library.
  Call ReadExternalFile(ACWlibNAC) ' Returns with ACWlibNAC increased by the number in the external file.
' And with the new external file data stored in lib index values libNAC + 1 and ACWlibNAC.
  libNAC = ACWIAStart - 1 ' Reset to its old value.
' Keep the file name inside the form caption area.
  I = frmAircraft.Width / 120 - Len(frmAircraftCaptionStart) - 5 ' 120 = twips / character.
  If I < Len(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext") Then S = "..." Else S = ""
  frmAircraft.Caption = frmAircraftCaptionStart & S & Right(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext", I)
    
  ExtFilePath$ = ExtFilePathSave$
  ExternalAircraftFileName$ = ExternalAircraftFileNameSave$
  
  ACWNAC = ACWlibNAC - libNAC
  ReDim ACWLibrary(1 To ACWNAC)
    For I = 1 To ACWNAC
      J = libNAC + I
      ACWLibrary(I).ACName = libACName(J)
      ACWLibrary(I).GL = libGL(J)
      ACWLibrary(I).NMainGears = libNMainGears(J)
      ACWLibrary(I).PcntOnMainGears(ACN_mode) = libPcntOnMainGears(J, ACN_mode)
      ACWLibrary(I).PcntOnMainGears(Thick_mode) = libPcntOnMainGears(J, Thick_mode)
      ACWLibrary(I).NTires = libNTires(J)
      For K = 1 To libNTires(J)
        ACWLibrary(I).TY(K) = libTY(J, K)
        ACWLibrary(I).TX(K) = libTX(J, K)
      Next K
      ACWLibrary(I).CP = libCP(J)
      ACWLibrary(I).TireContactArea = libTireContactArea(J)
      ACWLibrary(I).XGridOrigin = libXGridOrigin(J)
      ACWLibrary(I).XGridMax = libXGridMax(J)
      ACWLibrary(I).XGridNPoints = libXGridNPoints(J)
      ACWLibrary(I).YGridOrigin = libYGridOrigin(J)
      ACWLibrary(I).YGridMax = libYGridMax(J)
      ACWLibrary(I).YGridNPoints = libYGridNPoints(J)
      ACWLibrary(I).AnnualDepartures = libAnnualDepartures(J)
      Debug.Print I; J; ACWLibrary(I).ACName
    Next I
  
  Exit Sub
  
ReadFileError:
  Debug.Print "Error No = "; Err
  If Err = cdlCancel Then Exit Sub
  Ret = MsgBox(Err.Description & " occurred reading the external airplane file.", vbOKOnly, "File Error")

End Sub

Private Sub Form_Load()

  Dim I
  
  WorkingInAircraftWindow = True
  ACWIAStart = libNAC

  Me.Left = frmGear.Left + frmGear.lstLibFile.Width * 1.14
  Me.Top = frmGear.Top + 450
  Me.Width = frmGear.Width - frmGear.lstLibFile.Width * 1.2
  Me.Height = frmGear.Height - 450
  Me.Caption = frmAircraftCaptionStart
  
  With grdAircraftList

    .Cols = 8
    
    .FocusRect = flexFocusNone 'Heavy
    .AllowBigSelection = False ' Does not select cells when click on fixed rows or cols. GFH 07/01/03.
    
    NGridCols = .Cols
'    .ColAlignment(3) = flexAlignRightCenter

'   Set aircraft design grid column widths.
    .ColWidth(0) = 1400            ' 1600
    For I = 1 To NGridCols - 1
      .ColWidth(I) = 1250
    Next I

'   Aircraft design grid titles.
    .RowHeight(0) = .RowHeight(0) * 1.75 ' 2
    .Row = 0
    .FixedAlignment(0) = flexAlignLeftCenter
    For I = 1 To NGridCols - 1
      .FixedAlignment(I) = flexAlignCenterCenter
    Next I

'   Column 1 title (Aircraft Name) is set in Sub AddACDataToGrid,
'   cmdRemove and cmdClearLoadFile because it also displays NAC.
    If UnitsOut.Metric Then S$ = "tns" Else S$ = "lbs"
    I = 0
    .Col = I:  .Text = "" & vbCrLf & "No."
    I = I + 2
    .Col = I:  .Text = "Gross" & vbCrLf & "Weight (" & S$ & ")"
    I = I + 1
    .Col = I:  .Text = "Percent GW" & vbCrLf & "on Gear"
    I = I + 1
    .Col = I:  .Text = " Tire" & vbCrLf & "Press.(" & UnitsOut.psiName & ")"
    I = I + 1
    .Col = I:  .Text = "Annual" & vbCrLf & "Departures"
    I = I + 1
    .Col = I:  .Text = "No. Tires" & vbCrLf & "on Gear"
    I = I + 1
    .Col = I:  .Text = "Number" & vbCrLf & "of Gears"
    
    For I = 1 To NGridCols - 1
      .ColAlignment(I) = flexAlignCenterCenter
    Next I
    
'    If ACWNAC > 0 Then
'      .Col = 0
'      For I = 1 To ACWNAC
'        If I > 1 Then
'         Start rows must be 1 more than fixed rows, so start with
'         2 rows and fill the first non-fixed before adding.
'          .AddItem ACName$(I)
'        End If
'        Call AddACDataToGrid(I)  moved to Activate
'        Required there when returning from frmParam with load changed.
'      Next I
'    End If
    
  End With


End Sub

Private Sub AddACDataToGrid(I As Integer)
  
  Dim II As Integer, LI As Integer
  Dim DTemp As Double
  
  With grdAircraftList
    S$ = "      Design" & vbCrLf & "   Aircraft ("
    .TextMatrix(0, 0) = S$ & Format(ACWNAC, "0") & ")"
    LI = libIndex(I)
    .RowHeight(I) = .RowHeightMin
    II = 0
    .TextMatrix(I, II) = ACWLibrary(I).ACName
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).GL * UnitsOut.pounds, UnitsOut.poundsFormat) & "   "
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).PcntOnMainGears, "##0") & "     "
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).CP * UnitsOut.psi, UnitsOut.psiFormat) & "   "
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).AnnualDepartures, "#,###,##0") & "     "
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).NTires, "0") & "     "
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).NMainGears, "0") & "     "
  End With

End Sub

Private Sub Form_Unload(Cancel As Integer)

WorkingInAircraftWindow = False
ACWIAStart = 0

End Sub
