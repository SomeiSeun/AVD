VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "Msflxgrd.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "Comdlg32.ocx"
Begin VB.Form frmAircraft 
   Caption         =   "Aircraft Data"
   ClientHeight    =   8595
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   9600
   Icon            =   "Aircraft.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   8595
   ScaleWidth      =   9600
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton cmdAppendExtFile 
      Caption         =   "Append an External File to the List"
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
      Left            =   6360
      TabIndex        =   17
      Top             =   6000
      Width           =   1815
   End
   Begin VB.CommandButton cmdPaste 
      Caption         =   "Paste"
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
      Left            =   5280
      TabIndex        =   16
      Top             =   6000
      Width           =   855
   End
   Begin VB.CommandButton cmdCopy 
      Caption         =   "Copy"
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
      Left            =   4320
      TabIndex        =   15
      Top             =   6000
      Width           =   855
   End
   Begin VB.Frame fraInsertPosition 
      Caption         =   "Position to Insert Aircraft"
      Height          =   615
      Left            =   120
      TabIndex        =   10
      Top             =   6000
      Width           =   3615
      Begin VB.OptionButton optAfter 
         Caption         =   "After"
         Height          =   255
         Left            =   2760
         TabIndex        =   14
         Top             =   240
         Width           =   735
      End
      Begin VB.OptionButton optBefore 
         Caption         =   "Before"
         Height          =   255
         Left            =   1800
         TabIndex        =   13
         Top             =   240
         Width           =   855
      End
      Begin VB.OptionButton optEnd 
         Caption         =   "End"
         Height          =   255
         Left            =   960
         TabIndex        =   12
         Top             =   240
         Width           =   735
      End
      Begin VB.OptionButton optStart 
         Caption         =   "Start"
         Height          =   255
         Left            =   120
         TabIndex        =   11
         Top             =   240
         Value           =   -1  'True
         Width           =   1095
      End
   End
   Begin MSComDlg.CommonDialog CdlACWFiles 
      Left            =   8880
      Top             =   7800
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.CommandButton cmdClearList 
      Caption         =   "Clear the List"
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
      Left            =   6360
      TabIndex        =   8
      Top             =   6720
      Width           =   1815
   End
   Begin VB.CommandButton cmdReturnAndReplaceCurrent 
      Caption         =   "Return and Replace the Current External File"
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
      Left            =   120
      TabIndex        =   6
      Top             =   7680
      Width           =   1935
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
      Left            =   2280
      TabIndex        =   5
      Top             =   7680
      Width           =   1815
   End
   Begin VB.CommandButton cmdRemoveAircraft 
      Caption         =   "Remove (Cut) the Selected Aircraft"
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
      Left            =   4320
      TabIndex        =   4
      Top             =   6720
      Width           =   1815
   End
   Begin VB.CommandButton cmdAddAircraft 
      Caption         =   "Add the Selected Aircraft"
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
      Left            =   2280
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
      Left            =   4320
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
      Left            =   120
      TabIndex        =   1
      Top             =   6720
      Width           =   1935
   End
   Begin MSFlexGridLib.MSFlexGrid grdAircraftList 
      Height          =   5535
      Left            =   240
      TabIndex        =   0
      Top             =   360
      Width           =   9135
      _ExtentX        =   16113
      _ExtentY        =   9763
      _Version        =   393216
      WordWrap        =   -1  'True
      ScrollBars      =   2
   End
   Begin VB.CommandButton cmdExit 
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
      Left            =   6360
      TabIndex        =   7
      Top             =   7680
      Visible         =   0   'False
      Width           =   1815
   End
   Begin VB.Label lblACWHelp 
      Alignment       =   2  'Center
      AutoSize        =   -1  'True
      BackColor       =   &H80000009&
      Caption         =   "lblACWHelp"
      Height          =   1035
      Left            =   8280
      TabIndex        =   9
      Top             =   6000
      Width           =   1215
      WordWrap        =   -1  'True
   End
End
Attribute VB_Name = "frmAircraft"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
' Public ACWIACStart as Long, ACWNAC as Long ' In Global module.
Const frmAircraftCaptionStart As String = "Aircraft Data"
Dim ACWGrossWeight As Double
Dim ACWExternalAircraftFileName As String, ACWFullFileName As String
Dim ACWExtFilePath As String
Dim ACWlibNAC As Integer
Dim NGridCols As Integer
Dim ACWLibrary() As ACLibrary, ACWClipBoard(0 To 0) As ACLibrary
Dim ACWClipboardDirty As Boolean, AppendingFile As Boolean
Dim SavingCurrentExtFile As Boolean

Private Sub cmdAddAircraft_Click()

' Inserts a new section in the current job in memory.
' The insertion point is in ASCII order on InsertName$.
' Following this routine with WriteExternalFile ensures that
' the sections in the job file will always be sorted and grid
' list order will show ASCII order without setting .Sorted = True.
' Sorting removed 06/08/10.
  
  Dim I As Long, II As Long, J As Long
  Dim InsertName As String, DupName As Boolean
  Dim IAC As Long, IStart As Long, S$

' Find insertion point
  InsertName = JobTitle
  DupName = False
  ACWNAC = ACWNAC + 1
  ReDim Preserve ACWLibrary(1 To ACWNAC)

'  IStart = LibACGroup(ExternalLibraryIndex)
  IAC = ACWNAC ' If last in ASCII order and insertion is the last row.
' GFH 06/08/10, sorting removed.
' IAC = ACWNAC adds to the end without sort.
  IAC = 1 ' Adds to the beginning without sort. Default.
  If optStart.Value = True Then
    IAC = 1
  ElseIf optEnd.Value = True Then
    IAC = ACWNAC
  ElseIf optBefore.Value = True Then
    IAC = grdAircraftList.Row
  ElseIf optAfter.Value = True Then
    IAC = grdAircraftList.Row + 1
  End If
  
'  ACWLibrary(ACWNAC).ACName$ = "ZZZZZZZZZZZZZZZZZZ"   ' End marker.
  For I = 1 To -ACWNAC - 1 ' Do not sort before adding, skips loop.
    If StrComp(InsertName$, ACWLibrary(I).ACName$, 1) <= 0 Then
      If StrComp(InsertName$, ACWLibrary(I).ACName$, 1) = 0 Then
'       This does not work if the list is not initially ordered. Do it separately.
        S$ = "Name " & InsertName$ & " already exists." & NL2
        S$ = S$ & "No action will be taken."
        Ret = MsgBox(S$, 0, "Inserting Current Aircraft")
        ACWNAC = ACWNAC - 1
        DupName = True
        Exit Sub
      End If
      IAC = I
      Exit For
    End If
  Next I
    
' Move all data from insertion point up one place.
  For I = ACWNAC - 1 To IAC Step -1
  
    II = I + 1
    ACWLibrary(II) = ACWLibrary(I)
    
    If II = ACWNAC Then grdAircraftList.AddItem Format(ACWNAC, "0")
    If II <= ACWNAC Then Call AddACDataToGrid(CInt(II)) ' Don't add the Copy aircraft data to the grid.
    
  Next I
  
  If IAC = ACWNAC And ACWNAC > 1 Then grdAircraftList.AddItem Format(ACWNAC, "0") ' Above loop does not execute.
  Call UpdateACWLibraryData(CInt(IAC))
  Call AddACDataToGrid(CInt(IAC))
  grdAircraftList.Row = IAC

End Sub

 Public Sub UpdateACWLibraryData(IACpassed As Integer)

  Dim J As Integer, NX As Integer, NY As Integer
  Dim IAC As Long
  
  IAC = IACpassed
  
  With ACWLibrary(IAC)
  
    .ACName$ = JobTitle$
    .GL = GrossWeight
    .NMainGears = NMainGears
   
    .PcntOnMainGears(ACN_mode) = PcntOnMainGears
    .PcntOnMainGears(Thick_mode) = PcntOnMainGears
    .CP = TirePressure
    .TireContactArea = TireContactArea
    .CP = TirePressure
    .AnnualDepartures = AnnualDepartures
  
    .NTires = NWheels
       
    For J = 1 To .NTires
      .TY(J) = XWheels(J)
      .TX(J) = YWheels(J)
    Next J

    If .XGridNPoints <> 0 And .XGridNPoints <> 0 Then
      NX = XGridNPoints:  NY = YGridNPoints
    Else
      NX = 0:             NY = 0
    End If
  
    .XGridOrigin = XGridOrigin
    .XGridMax = XGridMax
    .XGridNPoints = NX
    .YGridOrigin = YGridOrigin
    .YGridMax = YGridMax
    .YGridNPoints = NY
    
  End With

End Sub

Private Sub cmdAppendExtFile_Click()

  AppendingFile = True
  Call cmdOpenExternalFile_Click
  AppendingFile = False

End Sub

Private Sub cmdClearList_Click()

  Dim I As Integer

  S = "All aircraft will be removed" & vbCrLf & "from the list." & vbCrLf & vbCrLf
  S = S & "Do you want to do this?"
  
  If MsgBox(S, 4 + 256, "Clearing the List") = vbYes Then
    With grdAircraftList
      For I = 1 To .Rows - 2
        .RemoveItem 1
      Next I
      For I = 0 To .Cols - 1
        .TextMatrix(1, I) = ""
      Next I
      ACWNAC = 0
    End With
  End If
  
End Sub

Private Sub cmdCopy_Click()

  ACWClipboardDirty = True
  ACWClipBoard(0) = ACWLibrary(grdAircraftList.Row)

End Sub

Private Sub cmdOpenExternalFile_Click()

  Dim I As Integer, J As Integer, K As Integer, ACWNACold As Long
  Static Started As Boolean
  Dim ExtFilePathSave$, ExternalAircraftFileNameSave$
  Dim ACWExtFilePathSave$, ACWExternalAircraftFileNameSave$
  On Error GoTo ReadFileError
  
  ACWExtFilePathSave$ = ACWExtFilePath$ ' Needed for appending a file.
  ACWExternalAircraftFileNameSave$ = ACWExternalAircraftFileName$ ' Needed for appending a file.
  
  CdlACWFiles.InitDir = ExtFilePath$
  CdlACWFiles.Filter = "ext files|*.ext"
  CdlACWFiles.CancelError = True
  CdlACWFiles.ShowOpen  ' Skip rest of sub on Cancel.
  ACWExternalAircraftFileName$ = CdlACWFiles.FileTitle
  ACWFullFileName$ = CdlACWFiles.FileName
  ACWExtFilePath$ = Left$(ACWFullFileName$, Len(ACWFullFileName$) - Len(ACWExternalAircraftFileName$))
  Debug.Print ACWFullFileName$; " "; ACWExtFilePath$; " "; ACWExternalAircraftFileName$
  CdlACWFiles.InitDir = ACWExtFilePath$
  ACWExternalAircraftFileName$ = Left$(ACWExternalAircraftFileName$, Len(ACWExternalAircraftFileName$) - 4)
  
  ExtFilePathSave$ = ExtFilePath$
  ExternalAircraftFileNameSave$ = ExternalAircraftFileName$
  ExtFilePath$ = ACWExtFilePath$
  ExternalAircraftFileName$ = ACWExternalAircraftFileName$
  
  ACWIAStart = libNAC + 1
  ACWlibNAC = libNAC ' Number of aircraft without the new external library.
  Call ReadExternalFile(ACWlibNAC) ' Returns with ACWlibNAC increased by the number in the external file.
  If ACWlibNAC = ACWIAStart - 1 Then
    Ret = MsgBox("The file selected is empty, or otherwise corrupted. The operation will be aborted", vbOKOnly, "File Error")
    Exit Sub
  End If
' And with the new external file data stored in lib index values libNAC + 1 and ACWlibNAC.
  libNAC = ACWIAStart - 1 ' Reset to its old value.

  If Not AppendingFile Then
    With grdAircraftList
      For I = 1 To .Rows - 2
        .RemoveItem 1
      Next I
      ACWNACold = 0
    End With
  Else
    ACWNACold = ACWNAC
    ACWExtFilePath$ = ACWExtFilePathSave$ ' Restore for saving.
    ACWExternalAircraftFileName$ = ACWExternalAircraftFileNameSave$ ' Restore for saving.
  End If
  
' Keep the file name inside the form caption area.
  I = frmAircraft.Width / 120 - Len(frmAircraftCaptionStart) - 8 ' 120 = twips / character.
  If I < Len(ACWExtFilePath$ & ACWExternalAircraftFileName$ & ".Ext") Then S = " - ..." Else S = " - "
  frmAircraft.Caption = frmAircraftCaptionStart & S & Right(ACWExtFilePath$ & ACWExternalAircraftFileName$ & ".Ext", I)
    
  ExtFilePath$ = ExtFilePathSave$
  ExternalAircraftFileName$ = ExternalAircraftFileNameSave$
  
  ACWNAC = ACWNACold + ACWlibNAC - libNAC
  ReDim Preserve ACWLibrary(1 To ACWNAC)
  For I = ACWNACold + 1 To ACWNAC
    J = libNAC + I - ACWNACold
    With ACWLibrary(I)
      .ACName = libACName(J)
      .GL = libGL(J)
      .NMainGears = libNMainGears(J)
      .PcntOnMainGears(ACN_mode) = libPcntOnMainGears(J, ACN_mode)
      .PcntOnMainGears(Thick_mode) = libPcntOnMainGears(J, Thick_mode)
      .NTires = libNTires(J)
      For K = 1 To libNTires(J)
        .TY(K) = libTY(J, K)
        .TX(K) = libTX(J, K)
      Next K
      .CP = libCP(J)
      .TireContactArea = libTireContactArea(J)
      .XGridOrigin = libXGridOrigin(J)
      .XGridMax = libXGridMax(J)
      .XGridNPoints = libXGridNPoints(J)
      .YGridOrigin = libYGridOrigin(J)
      .YGridMax = libYGridMax(J)
      .YGridNPoints = libYGridNPoints(J)
      .AnnualDepartures = libAnnualDepartures(J)
      Debug.Print I; J; .ACName; .GL
      If I > 1 Then grdAircraftList.AddItem Format(I, "0")
    End With
    Call AddACDataToGrid(I)
  Next I
  
  Exit Sub
  
ReadFileError:
  Debug.Print "Error No = "; Err
  If Err = cdlCancel Then Exit Sub
  Ret = MsgBox(Err.Description & " occurred reading the external airplane file.", vbOKOnly, "File Error")

End Sub

Private Sub cmdPaste_Click()

  Dim I As Long

  If ACWClipboardDirty = False Then Exit Sub
  
  Call cmdAddAircraft_Click ' Add the currently selected aircraft.

  I = grdAircraftList.Row
  
' Paste the clipboard data over the current aircraft data.
  ACWLibrary(I) = ACWClipBoard(0)
  Call AddACDataToGrid(CInt(I))

End Sub

Private Sub cmdRemoveAircraft_Click()
' Removes an aircraft from the ACW library and puts it in the ACW clipboard.

  Dim I As Long, II As Long, J As Integer
  Dim InsertName As String, DupName As Boolean
  Dim IAC As Long, IStart As Long, S$

  Call cmdCopy_Click ' Move data to Copy position and set dirty flag.
  
  ACWNAC = ACWNAC - 1

  If ACWNAC = 0 Then
    For I = 0 To grdAircraftList.Cols - 1
      grdAircraftList.TextMatrix(1, I) = ""
    Next I
    Exit Sub
  End If
  
' Move all data down one place to the current aircraft.
  IAC = grdAircraftList.Row
  For I = IAC To ACWNAC
  
    II = I + 1
    ACWLibrary(I) = ACWLibrary(II)
    Call AddACDataToGrid(CInt(I))
    
  Next I
  
  grdAircraftList.RemoveItem Format(ACWNAC + 1, "0")

End Sub

Private Sub cmdReturnAndDiscard_Click()

  Unload Me
  Set frmAircraft = Nothing

End Sub

Private Sub cmdReturnAndReplaceCurrent_Click()
  Dim I As Integer, J As Integer, K As Integer
  Dim ExtFilePathSave$, ExternalAircraftFileNameSave$
  
  If ACWNAC = 0 Then
    Ret = MsgBox("The aircraft list is empty. The operation will be aborted", vbOKOnly, "Cannot Save File")
    Exit Sub
  End If
  
  ExtFilePath$ = ACWExtFilePath$
  ExternalAircraftFileName$ = ACWExternalAircraftFileName$
  
  For I = 1 To ACWNAC
    J = libNAC + I
    With ACWLibrary(I)
      libACName(J) = .ACName
      libGL(J) = .GL
      libNMainGears(J) = .NMainGears
      libPcntOnMainGears(J, ACN_mode) = .PcntOnMainGears(ACN_mode)
      libPcntOnMainGears(J, Thick_mode) = .PcntOnMainGears(Thick_mode)
      libNTires(J) = .NTires
      For K = 1 To libNTires(J)
        libTY(J, K) = .TY(K)
        libTX(J, K) = .TX(K)
      Next K
      libCP(J) = .CP
      libTireContactArea(J) = .TireContactArea
      libXGridOrigin(J) = .XGridOrigin
      libXGridMax(J) = .XGridMax
      libXGridNPoints(J) = .XGridNPoints
      libYGridOrigin(J) = .YGridOrigin
      libYGridMax(J) = .YGridMax
      libYGridNPoints(J) = .YGridNPoints
      libAnnualDepartures(J) = .AnnualDepartures
    End With
  Next I
  
  Call WriteExternalFile

  libNAC = LibACGroup(ExternalLibraryIndex) - 1 ' Number of aircraft without the external library.
  J = libNAC
  WorkingInAircraftWindow = False
  Call ReadExternalFile(libNAC) ' Returns with libNAC increased by the number in the external file.
  WorkingInAircraftWindow = True
  
  I = frmGear.Width / 120 - Len(frmGearCaptionStart) - 5 ' 120 = twips / character.
  If I < Len(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext") Then S = "..." Else S = ""
  frmGear.Caption = frmGearCaptionStart & S & Right(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext", I)
    
  If frmGear.lstACGroup.ListIndex = ExternalLibraryIndex - 1 Then
    libIndex = J + 1 ' First airplane in the new list, saved above.
    Call UpdateDataFromLibrary(libIndex)
    Call frmGear.lstACGroup_Click
  End If

  Refresh
  
  ACNFlexibleOutputText$ = ""
  ACNRigidOutputText$ = ""
  ACNBatchOutputText = ""
  PCNOutputText$ = ""
  ThicknessOutputText = ""
  LifeOutputText = ""
  MGWOutputText = ""
  
  Unload Me
  Set frmAircraft = Nothing

End Sub

Private Sub cmdSaveAsExternalFile_Click()
  
  Dim I As Integer, J As Integer, K As Integer
  Dim ExtFilePathSave$, ExternalAircraftFileNameSave$
  On Error GoTo ReadFileError
  
  If ACWNAC = 0 Then
    Ret = MsgBox("The aircraft list is empty. The operation will be aborted", vbOKOnly, "Cannot Save File")
    Exit Sub
  End If
  
  CdlACWFiles.InitDir = ACWExtFilePath$
  CdlACWFiles.Filter = "ext files|*.ext"
  CdlACWFiles.CancelError = True
  CdlACWFiles.ShowSave  ' Skip rest of sub on Cancel.
  ACWExternalAircraftFileName$ = CdlACWFiles.FileTitle
  ACWFullFileName$ = CdlACWFiles.FileName
  ACWExtFilePath$ = Left$(ACWFullFileName$, Len(ACWFullFileName$) - Len(ACWExternalAircraftFileName$))
  Debug.Print ACWFullFileName$; " "; ACWExtFilePath$; " "; ACWExternalAircraftFileName$
  CdlACWFiles.InitDir = ACWExtFilePath$
  ACWExternalAircraftFileName$ = Left$(ACWExternalAircraftFileName$, Len(ACWExternalAircraftFileName$) - 4)
  ExtFilePathSave$ = ExtFilePath$
  ExternalAircraftFileNameSave$ = ExternalAircraftFileName$
  ExtFilePath$ = ACWExtFilePath$
  ExternalAircraftFileName$ = ACWExternalAircraftFileName$
  
  For I = 1 To ACWNAC
    J = libNAC + I
    With ACWLibrary(I)
      libACName(J) = .ACName
      libGL(J) = .GL
      libNMainGears(J) = .NMainGears
      libPcntOnMainGears(J, ACN_mode) = .PcntOnMainGears(ACN_mode)
      libPcntOnMainGears(J, Thick_mode) = .PcntOnMainGears(Thick_mode)
      libNTires(J) = .NTires
      For K = 1 To libNTires(J)
        libTY(J, K) = .TY(K)
        libTX(J, K) = .TX(K)
      Next K
      libCP(J) = .CP
      libTireContactArea(J) = .TireContactArea
      libXGridOrigin(J) = .XGridOrigin
      libXGridMax(J) = .XGridMax
      libXGridNPoints(J) = .XGridNPoints
      libYGridOrigin(J) = .YGridOrigin
      libYGridMax(J) = .YGridMax
      libYGridNPoints(J) = .YGridNPoints
      libAnnualDepartures(J) = .AnnualDepartures
    End With
  Next I
  
  Call WriteExternalFile

  I = frmAircraft.Width / 120 - Len(frmAircraftCaptionStart) - 8 ' 120 = twips / character.
  If I < Len(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext") Then S = " - ..." Else S = " - "
  frmAircraft.Caption = frmAircraftCaptionStart & S & Right(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext", I)
    
  ExtFilePath$ = ExtFilePathSave$
  ExternalAircraftFileName$ = ExternalAircraftFileNameSave$
  
  Exit Sub
  
ReadFileError:
  Debug.Print "Error No = "; Err
  If Err = cdlCancel Then Exit Sub
  Ret = MsgBox(Err.Description & " occurred reading the external airplane file.", vbOKOnly, "File Error")

End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)

'  Debug.Print Asc("C"); KeyAscii
  If KeyAscii = 3 Then ' CNTRL-c
    Call cmdCopy_Click
    KeyAscii = 0 ' Character is not passed on.
  ElseIf KeyAscii = 22 Then ' CNTRL-v
    Call cmdPaste_Click
    KeyAscii = 0
  ElseIf KeyAscii = 24 Then
    Call cmdRemoveAircraft_Click ' CNTRL-x
    KeyAscii = 0
  End If
'  Debug.Print Asc("c"); KeyAscii

End Sub

Private Sub Form_Load()

  Dim I As Integer, J As Long, K As Long, IStart As Long
  
  WorkingInAircraftWindow = True
  ACWIAStart = libNAC + 1

  Me.Left = frmGear.Left + frmGear.lstLibFile.Width * 1.14
  Me.Top = frmGear.Top + 450
  Me.Width = frmGear.Width - frmGear.lstLibFile.Width * 1.2
  Me.Height = frmGear.Height - 450
  Me.Caption = frmAircraftCaptionStart
  Me.KeyPreview = True ' Forces keypress to be handled by the form first.
  
  frmGear.grdParms.Enabled = False
  frmGear.fraEditWheels.Enabled = False
  frmGear.fraLibraryFunctions.Enabled = False
  frmGear.fraOptions.Enabled = False
  frmGear.fraPCNBatchMode.Enabled = False
  frmGear.fraCompMode.Enabled = False
  
  With grdAircraftList

    .Rows = 2
    .Cols = 8
    .FixedCols = 1
    
    .FocusRect = flexFocusNone ' Heavy
    .AllowBigSelection = False ' Does not select cells when click on fixed rows or cols. GFH 07/01/03.
    
    NGridCols = .Cols
'    .ColAlignment(3) = flexAlignRightCenter

'   Set aircraft design grid column widths.
    .ColWidth(0) = 400
    .ColWidth(1) = 2200
    .ColWidth(2) = 1310
    .ColWidth(3) = 1100
    .ColWidth(4) = 1000
    .ColWidth(5) = 1000
    .ColWidth(6) = 1000
    .ColWidth(7) = 1000
'    For I = 2 To NGridCols - 1
'      .ColWidth(I) = 1250
'    Next I

'   Aircraft design grid titles.
    .RowHeight(0) = .RowHeight(0) * 2
    .Row = 0
    For I = 0 To NGridCols - 1
      .ColAlignment(I) = flexAlignCenterCenter
    Next I
    .ColAlignment(1) = flexAlignLeftCenter
    .Col = 1
    .CellAlignment = flexAlignCenterCenter

    If UnitsOut.Metric Then S$ = "tns" Else S$ = "lbs"
    I = 0
    .Col = I:  .Text = "" & vbCrLf & "No."
    I = I + 1
    .Col = I:  .Text = "Aircraft" & vbCrLf & "Name"
    I = I + 1
    .Col = I:  .Text = "Gross" & vbCrLf & "Weight (" & S$ & ")"
    I = I + 1
    .Col = I:  .Text = "Percent" & vbCrLf & "GW on Gears"
    I = I + 1
    .Col = I:  .Text = "Tire" & vbCrLf & "Press. (" & UnitsOut.psiName & ")"
    I = I + 1
    .Col = I:  .Text = "Annual" & vbCrLf & "Departures"
    I = I + 1
    .Col = I:  .Text = "No. of Tires" & vbCrLf & "on Gear"
    I = I + 1
    .Col = I:  .Text = "Number" & vbCrLf & "of Gears"
    
    .Col = 2
    
  End With
  
  IStart = LibACGroup(ExternalLibraryIndex)
  ACWNAC = libNAC - IStart + 1
  ReDim ACWLibrary(1 To ACWNAC)
  For I = 1 To ACWNAC
    J = IStart + I - 1
    With ACWLibrary(I)
      .ACName = libACName(J)
      .GL = libGL(J)
      .NMainGears = libNMainGears(J)
      .PcntOnMainGears(ACN_mode) = libPcntOnMainGears(J, ACN_mode)
      .PcntOnMainGears(Thick_mode) = libPcntOnMainGears(J, Thick_mode)
      .NTires = libNTires(J)
      For K = 1 To libNTires(J)
        .TY(K) = libTY(J, K)
        .TX(K) = libTX(J, K)
      Next K
      .CP = libCP(J)
      .TireContactArea = libTireContactArea(J)
      .XGridOrigin = libXGridOrigin(J)
      .XGridMax = libXGridMax(J)
      .XGridNPoints = libXGridNPoints(J)
      .YGridOrigin = libYGridOrigin(J)
      .YGridMax = libYGridMax(J)
      .YGridNPoints = libYGridNPoints(J)
      .AnnualDepartures = libAnnualDepartures(J)
      Debug.Print I; J; .ACName; .GL
      If I > 1 Then grdAircraftList.AddItem Format(I, "0")
    End With
    Call AddACDataToGrid(I)
  Next I

  ACWExtFilePath$ = ExtFilePath$
  ACWExternalAircraftFileName$ = ExternalAircraftFileName$
  
  I = frmAircraft.Width / 120 - Len(frmAircraftCaptionStart) - 8 ' 120 = twips / character.
  If I < Len(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext") Then S = " - ..." Else S = " - "
  frmAircraft.Caption = frmAircraftCaptionStart & S & Right(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext", I)
  
  lblACWHelp.Caption = "To add, select from the lists on the far left. To remove, select by clicking the No. column in the table above. "
  lblACWHelp.Caption = lblACWHelp.Caption & "To change the contents of a cell click the appropriate cell in the table."

End Sub

Private Sub AddACDataToGrid(I As Integer)
  
  Dim II As Integer, J As Integer
  
  With grdAircraftList
    II = 0
    .TextMatrix(I, II) = Format(I, "0")
    II = II + 1
    .TextMatrix(I, II) = ACWLibrary(I).ACName
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).GL * UnitsOut.pounds, UnitsOut.poundsFormat)
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).PcntOnMainGears(ACN_mode), "##0.00")
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).CP * UnitsOut.psi, UnitsOut.psiFormat)
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).AnnualDepartures, "#,###,##0")
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).NTires, "0")
    II = II + 1
    .TextMatrix(I, II) = Format(ACWLibrary(I).NMainGears, "0")
  End With

End Sub

Private Sub Form_Unload(Cancel As Integer)

  WorkingInAircraftWindow = False
  ACWIAStart = 0
  ACWNAC = 0

  frmGear.grdParms.Enabled = True
  frmGear.fraEditWheels.Enabled = True
  frmGear.fraLibraryFunctions.Enabled = True
  frmGear.fraOptions.Enabled = True
  frmGear.fraPCNBatchMode.Enabled = True
  frmGear.fraCompMode.Enabled = True
  frmGear.SetFocus
  
End Sub

Private Sub grdAircraftList_DblClick()
  
  If grdAircraftList.MouseCol = 0 Then
    Call cmdRemoveAircraft_Click
  End If
  
End Sub

Private Sub grdAircraftList_MouseDown(Button As Integer, Shift As Integer, X As Single, Y As Single)

  Dim ValueChanged As Boolean

  With grdAircraftList
      
    If .MouseRow = 0 Or .MouseCol = 0 Then
      Exit Sub
    End If
    If Y > .RowPos(.Rows - 1) + .RowHeight(.Rows - 1) Then
'     Below grid if not enough aircraft to fill control area.
'     Works best if a whole row is the last visible row. Otherwise does not get selected.
      Exit Sub
    End If
      
    If .Col = 1 Then
  
      Call ChangeACWACName(ValueChanged)
    
    ElseIf .Col = 2 Then
  
      Call ChangeACWGrossWeight(ValueChanged)
    
    ElseIf .Col = 3 Then

      Call ChangeACWPcntOnMainGears(ValueChanged)
    
    ElseIf .Col = 4 Then

      Call ChangeACWTirePressure(ValueChanged)
    
    ElseIf .Col = 5 Then

      Call ChangeACWAnnualDepartures(ValueChanged)
    
    End If
    
  End With

End Sub

Sub ChangeACWACName(ValueChanged As Boolean)

  Dim DupName As Boolean, InsertName$, S$
  Dim CurrentName As String, IAC As Integer, I As Long
  
  IAC = grdAircraftList.Row
  CurrentName = ACWLibrary(IAC).ACName
  
  S$ = "Enter a new name for the aircraft." & NL2
  S$ = S$ & "This will be used as the name" & vbCrLf
  S$ = S$ & "saved in the external library."
  
  InsertName$ = InputBox(S$, "Changin Aircraft Name", CurrentName)
  If InsertName$ = "" Then Exit Sub
  
  For I = 1 To IAC - 1
    If ACWLibrary(IAC).ACName = InsertName Then DupName = True
  Next I
  For I = IAC + 1 To ACWNAC
    If ACWLibrary(IAC).ACName = InsertName Then DupName = True
  Next I
  
  If DupName Then Exit Sub
  
  ACWLibrary(IAC).ACName = InsertName
  Call AddACDataToGrid(IAC)

End Sub
Public Sub ChangeACWGrossWeight(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, IAC As Integer
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  IAC = grdAircraftList.Row
  CurrentValue = ACWLibrary(IAC).GL
'  LibValue = libGL(libIndex)     ' From library file.
  MinValue = 100#  'MinGLFraction * LibValue 'ikawa 02/12/03
  MaxValue = 10000000#  'MaxGLFraction * LibValue 'ikawa 02/12/03

  S$ = "The current value of gross load for" & vbCrLf
  S$ = S$ & "this aircraft is " & Format(CurrentValue * UnitsOut.pounds, _
   UnitsOut.poundsFormat & " ") & UnitsOut.poundsName & "." & NL2
  S$ = S$ & "Enter a new value in the range:"
  S$ = S$ & NL2 & Format(MinValue * UnitsOut.pounds, UnitsOut.poundsFormat)
  S$ = S$ & " to " & Format(MaxValue * UnitsOut.pounds, UnitsOut.poundsFormat & ".") '&
  SS$ = "Changing Aircraft Gross Load"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS / UnitsOut.pounds

'   Check to See if value is within range.
    If CSng(NewValue) < CSng(MinValue) Or CSng(MaxValue) < CSng(NewValue) Then
      NewValue = CurrentValue
      S$ = "Gross load cannot be less than "
'      S$ = S$ & Format(MinGLFraction, "0.00")
'      S$ = S$ & " x " & Format(LibValue * UnitsOut.pounds, _
'          UnitsOut.poundsFormat) & vbCrLf
      S$ = S$ & Format(MinValue * UnitsOut.pounds, _
          UnitsOut.poundsFormat) & vbCrLf
      S$ = S$ & "or greater than "
'      S$ = S$ & Format(MaxGLFraction, "0.00")
'      S$ = S$ & " x " & Format(LibValue * UnitsOut.pounds, _
'       UnitsOut.poundsFormat) & "." & NL2
'      S$ = S$ & Format(MaxGLFraction, "0.00")
      S$ = S$ & Format(MaxValue * UnitsOut.pounds, _
           UnitsOut.poundsFormat) & "." & NL2
      S$ = S$ & "The old value of gross load has been selected."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    If ValueChanged Then
      ACWLibrary(IAC).GL = NewValue
      Call AddACDataToGrid(IAC)
    End If
    
  End If

End Sub

Public Sub ChangeACWPcntOnMainGears(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, IAC As Integer
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  IAC = grdAircraftList.Row
  CurrentValue = ACWLibrary(IAC).PcntOnMainGears(ACN_mode)
  
'  If ACN_mode_true Then
'    LibValue = libPcntOnMainGears(libIndex, ACN_mode)    ' From library file.
'  Else
'    LibValue = libPcntOnMainGears(libIndex, Thick_mode)    ' From library file.
'  End If
  
  MinValue = 5
  MaxValue = 100

  S$ = "The current value of percent gross weight on" & vbCrLf
  S$ = S$ & "all of the main gears for this aircraft is "
  S$ = S$ & Format(CurrentValue, "#,###,##0.00") & "." & vbCrLf & vbCrLf
  S$ = S$ & "Enter a new value in the range:"
  S$ = S$ & NL2 & Format(MinValue, "#,###,##0.00")
  S$ = S$ & " to " & Format(MaxValue, "#,###,##0.00") & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Percent on Main Gears"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS

'   Check to See if value is within range.
    If NewValue < MinValue Or MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "Percent gross weight cannot be less than "
      S$ = S$ & Format(MinValue, "0.00") & vbCrLf
      S$ = S$ & "or greater than "
      S$ = S$ & Format(MaxValue, "0.00") & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    If ValueChanged Then
      ACWLibrary(IAC).PcntOnMainGears(ACN_mode) = NewValue
      ACWLibrary(IAC).PcntOnMainGears(Thick_mode) = NewValue
      Call AddACDataToGrid(IAC)
    End If
    
  End If

End Sub

Public Sub ChangeACWTirePressure(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, IAC As Integer
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  IAC = grdAircraftList.Row
  CurrentValue = ACWLibrary(IAC).PcntOnMainGears(ACN_mode)
'  LibValue = libCP(libIndex)     ' From library file.
  MinValue = 50
  MaxValue = 500

  S$ = "The current value of tire pressure for" & vbCrLf
  S$ = S$ & "this aircraft is "
  S$ = S$ & Format(CurrentValue * UnitsOut.psi, UnitsOut.psiFormat & " ") _
    & UnitsOut.psiName & "." & vbCrLf & vbCrLf
  
  S$ = S$ & "Enter a new value in the range:"
  S$ = S$ & NL2 & Format(MinValue * UnitsOut.psi, UnitsOut.psiFormat)
   S$ = S$ & " to " & Format(MaxValue * UnitsOut.psi, UnitsOut.psiFormat) & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Tire Pressure"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS / UnitsOut.psi

'   Check to See if value is within range.
    If CSng(NewValue) < CSng(MinValue) Or CSng(MaxValue) < CSng(NewValue) Then
      NewValue = CurrentValue
      S$ = "Tire pressure cannot be less than "
      S$ = S$ & Format(MinValue * UnitsOut.psi, UnitsOut.psiFormat) & vbCrLf
      
      
      S$ = S$ & "or greater than "
      S$ = S$ & Format(MaxValue * UnitsOut.psi, UnitsOut.psiFormat) & "." & NL2
      
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    If ValueChanged Then
      ACWLibrary(IAC).CP = NewValue
      Call AddACDataToGrid(IAC)
    End If

  End If

End Sub

Public Sub ChangeACWAnnualDepartures(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, IAC As Integer
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  IAC = grdAircraftList.Row
  CurrentValue = ACWLibrary(IAC).AnnualDepartures
  
'  LibValue = libAnnualDepartures(libIndex)     ' From library file.
  MinValue = 1
  MaxValue = 1000000

  S$ = "The default value for annual departures is 1,200." & NL2
  S$ = S$ & "Enter a new value in the range:"
  S$ = S$ & NL2 & Format(MinValue, "#,###,##0")
  S$ = S$ & " to " & Format(MaxValue, "#,###,##0") & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Annual Departures"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS

'   Check to See if Value is within range.
    If NewValue < MinValue Or MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "Annual Departures cannot be less than "
      S$ = S$ & Format(MinValue, "0.000") & vbCrLf
      S$ = S$ & "or greater than "
      S$ = S$ & Format(MaxValue, "0.000") & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    If ValueChanged Then
      ACWLibrary(IAC).AnnualDepartures = NewValue
      Call AddACDataToGrid(IAC)
    End If
  End If

End Sub

