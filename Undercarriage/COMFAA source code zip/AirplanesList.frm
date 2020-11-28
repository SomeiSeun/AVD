VERSION 5.00
Object = "{5E9E78A0-531B-11CF-91F6-C2863C385E30}#1.0#0"; "Msflxgrd.ocx"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form frmAirplaneList 
   Appearance      =   0  'Flat
   AutoRedraw      =   -1  'True
   BackColor       =   &H00C0C0C0&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "ACN Comp"
   ClientHeight    =   5790
   ClientLeft      =   1395
   ClientTop       =   2175
   ClientWidth     =   11700
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
   Icon            =   "AirplanesList.frx":0000
   KeyPreview      =   -1  'True
   MaxButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   5790
   ScaleWidth      =   11700
   Begin VB.CommandButton cmdCancel 
      Caption         =   "&Cancel"
      Height          =   450
      Left            =   4440
      TabIndex        =   17
      Top             =   5160
      Width           =   1300
   End
   Begin VB.CommandButton cmdSaveList 
      Caption         =   "Save List"
      Height          =   450
      Left            =   6240
      TabIndex        =   16
      Top             =   3960
      Width           =   1300
   End
   Begin VB.CommandButton cmdClearLoadFile 
      Caption         =   "Clear List"
      Height          =   450
      Left            =   7680
      TabIndex        =   15
      Top             =   3960
      Width           =   1300
   End
   Begin VB.CommandButton cmdSaveFloat 
      Caption         =   "Save to Float"
      Height          =   450
      Left            =   6240
      TabIndex        =   14
      Top             =   4560
      Width           =   1300
   End
   Begin VB.CommandButton cmdBack 
      Caption         =   "&Back"
      Height          =   450
      Left            =   3000
      TabIndex        =   13
      Top             =   5160
      Width           =   1300
   End
   Begin VB.CommandButton cmdAddFloat 
      Caption         =   "Add Float"
      Height          =   450
      Left            =   7680
      TabIndex        =   12
      Top             =   4560
      Width           =   1300
   End
   Begin VB.CommandButton cmdHelp 
      Caption         =   "&Help"
      Height          =   450
      Left            =   7080
      TabIndex        =   11
      Top             =   5160
      Width           =   1095
   End
   Begin VB.ListBox lstFloatAC 
      BackColor       =   &H00FFFFFF&
      Height          =   1425
      Left            =   9360
      TabIndex        =   9
      TabStop         =   0   'False
      Top             =   4200
      Width           =   1935
   End
   Begin VB.CommandButton cmdLoadACfromLibrary 
      Caption         =   "Load Ext File"
      Height          =   450
      Left            =   4440
      TabIndex        =   8
      Top             =   4560
      Width           =   1300
   End
   Begin VB.CommandButton cmdSaveACinLibrary 
      Caption         =   "Save Ext File"
      Height          =   450
      Left            =   3000
      TabIndex        =   7
      Top             =   4560
      Width           =   1300
   End
   Begin VB.CommandButton cmdRemove 
      Caption         =   "&Remove"
      Height          =   450
      Left            =   4440
      TabIndex        =   6
      Top             =   3960
      Width           =   1300
   End
   Begin VB.CommandButton cmdAdd 
      Caption         =   "&Add"
      Height          =   450
      Left            =   3000
      TabIndex        =   5
      Top             =   3960
      Width           =   1300
   End
   Begin MSComDlg.CommonDialog cdlFiles 
      Left            =   11640
      Top             =   4560
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin VB.ListBox lstACGroup 
      BackColor       =   &H00FFFFFF&
      Height          =   1425
      Left            =   150
      TabIndex        =   0
      Top             =   495
      Width           =   2415
   End
   Begin VB.ListBox lstLibFile 
      BackColor       =   &H00FFFFFF&
      ForeColor       =   &H00000000&
      Height          =   3240
      IntegralHeight  =   0   'False
      Left            =   120
      TabIndex        =   1
      Top             =   2280
      Width           =   2415
   End
   Begin MSFlexGridLib.MSFlexGrid grdDesignAC 
      Height          =   3495
      Left            =   2640
      TabIndex        =   4
      Top             =   240
      Width           =   9015
      _ExtentX        =   15901
      _ExtentY        =   6165
      _Version        =   393216
      Cols            =   14
      RowHeightMin    =   275
      WordWrap        =   -1  'True
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      BackColor       =   &H00C0FFFF&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Float Aircraft"
      Height          =   255
      Left            =   9360
      TabIndex        =   10
      Top             =   3960
      Width           =   1935
   End
   Begin VB.Label lblLibAircraft 
      Alignment       =   2  'Center
      BackColor       =   &H00B0FFFF&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Library Aircraft"
      ForeColor       =   &H00000000&
      Height          =   255
      Left            =   150
      TabIndex        =   3
      Top             =   2040
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
      TabIndex        =   2
      Top             =   240
      Width           =   2415
   End
End
Attribute VB_Name = "frmAirplaneList"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Dim LoadDataChanged As Boolean
Dim AddRemoveAC As Boolean
Dim CancelChanges As Boolean
Dim DataSaved As Boolean

Dim fltACName$(40)
Dim fltGL(40) As Double
Dim fltPcntOnMainGears(40) As Double
Dim fltNMainGears(40) As Double
Dim fltNTires(40) As Integer
Dim fltCP(40) As Double
Dim fltCoverages(40) As Double

Dim fltFlexAnnualDep(40) As Double
Dim fltRigAnnualDep(40) As Double

Dim fltNAC As Integer

Dim indexBoolean As Boolean


Dim NM1 As Integer, lstAircraftName$
Dim Temp As Double
Dim Dragging As Boolean, DragX As Single, DragY As Single
' Public frmGearCaptionStart As String In Global.
Dim grdDesignACX As Long, grdDesignACY As Long






Private Sub cmdAddACtoLibrary_Click()

  Dim DupName As Boolean, InsertName$, S$
  
  S$ = "Enter a name for the aircraft." & NL2
  S$ = S$ & "This name will be used as the title" & vbCrLf
  S$ = S$ & "saved in the external library."
  
  InsertName$ = InputBox(S$, "Adding an Aircraft")
  If InsertName$ = "" Then Exit Sub
  
  Call InsertNewAircraft(InsertName$, DupName)
  Call UpdateDataFromLibrary(libIndex)
  
  If DupName Then Exit Sub
  
  'Call WriteExternalFile
  
  lstACGroupIndex = lstACGroup.ListCount - 1
'  lstACGroup.ListIndex = lstACGroupIndex
'  ILibACGroup = lstACGroupIndex + 1
  If lstACGroupIndex = lstACGroup.ListIndex Then
    Call lstACGroup_Click
  Else
    lstACGroup.Selected(lstACGroupIndex) = True
  End If
  
End Sub

Private Sub cmdExit_Click()
  Unload Me
End Sub



Private Sub cmdAdd_Click()

    Dim InsertName$, S$, N2 As Integer
    Dim I As Integer, J As Integer, N As Integer, I2 As Integer

    If lstLibFile.ListCount = 0 Then
        S$ = "Please, selectect an airplane!" & NL2
        'S$ = S$ & "Do you want to save the new data" & vbCrLf
        Ret = MsgBox(S$, vbOKOnly, "Airplane Not Selected")
            
        Exit Sub
    End If



    N2 = LibACGroup(lstACGroupIndex + 1) + lstLibFile.ListIndex ' Library index
    S$ = "Enter a name for the aircraft." & NL2
    S$ = S$ & "This name will be used as the title" & vbCrLf
    S$ = S$ & "saved in the external library."
  
    InsertName$ = InputBox(S$, "Adding an Aircraft", libACName(N2))
    JobTitle$ = InsertName$
  
    If InsertName$ = "" Then Exit Sub
     
    grdDesignAC.Redraw = False  'grdDesignAC.Redraw = True
    I = grdDesignAC.Rows - 1  ' Row numbering starts at 0. 0 is title row.
    N = LibACGroup(lstACGroupIndex + 1) + lstLibFile.ListIndex ' Library index
    libIndex = N
  
    If I < MaxSectAC Then
        NAC = NAC + 1           ' Load file index
        Call grdUpdateLibraryData(NAC, N2)
        ACName$(NAC) = InsertName$ 'libACName$(N)
    
        If NAC > 1 Then grdDesignAC.AddItem ACName$(NAC)
        Dim i1 As Integer
        i1 = 1
    
        ReDim lYWheels(grdNWheels(NAC))
        For I2 = 1 To grdNWheels(NAC)
            lYWheels(I2) = grdXWheels(NAC, I2)
            lYWheels(I2) = libTX(libIndex, I2)
        Next I2
        
        
        gCoverages = grdCoverages(NAC)
        Call CoverageToPass(CDbl(grdGrossWeight(NAC)), CDbl(grdPcntOnMainGears(NAC, Thick_mode)), _
                                CDbl(grdNMainGears(NAC)), grdNWheels(NAC), lYWheels, CDbl(grdTirePressure(NAC)), CDbl(grdTireContactArea(NAC)))
       grdFlexibleAnnualDepartures(NAC) = gFlexibleAnnualDepartures
       grdRigidAnnualDepartures(NAC) = gRigidAnnualDepartures
    
        'Call AddACDataToGrid(NAC, N2)
        Call AddACDataToGridlib(NAC, N2)
        
        'grdDesignACRow = NAC
        'Call SetGridCell(NAC, 1)
    Else
        'TooManyAC = True
        S$ = "Cannot add this aircraft." & NL2
        S$ = S$ & "The aircraft design list cannot" & NL
        S$ = S$ & "contain more than " & Format$(MaxSectAC, "0") & " aircraft."
        Ret = MsgBoxDQ(S$, 0, "Too Many Aircraft")
    End If
  
  Call SetGridCell(NAC, 1)
  
  grdDesignAC.Redraw = True
  LoadDataChanged = True
  AddRemoveAC = True

End Sub

Private Sub cmdAddFloat_Click()
' Changes to this subroutine may need to be repeated in
' cmdAdd_Click. See comment in cmdAdd_Click.
  
  Dim I As Integer, J As Integer, LI As Integer
  

  If fltNAC = 0 Then
    S$ = "There are no aircraft in" & NL
    S$ = S$ & "the floating aircraft list."
    Ret = MsgBoxDQ(S$, 0, "Adding Float AIrcraft")
    Exit Sub
  End If

  grdDesignAC.Redraw = False

  For I = 1 To fltNAC
    'LI = libIndex(I)
    If NAC >= MaxSectAC - 1 Then
      If NAC >= MaxSectAC Or libGear$(LI) = "H" Then
        S$ = "No more float aircraft can be added" & NL
        S$ = S$ & "to the design list."
        If libGear$(LI) = "H" Then
          S$ = S$ & NL2 & "The wing and belly gear of the " & libACName$(LI) & NL
          S$ = S$ & "count as 2 aircraft for design."
        End If
        Ret = MsgBoxDQ(S$, 0, "Adding from Float")
        Exit For
      End If
    End If
    NAC = NAC + 1
    'libIndex(NAC) = fltLibIndex(I)
    GL(NAC) = fltGL(I)
'    RepsAnnual(NAC) = fltRepsAnnual(I)
'    RepsInc(NAC) = fltRepsInc(I)
    ACName$(NAC) = fltACName$(I)



    If NAC > 1 Then grdDesignAC.AddItem ACName$(NAC)
    Call fltAddACDataToGrid(I, NAC)
  Next I    ' Float aircraft.

  grdDesignAC.Redraw = True

  I = grdDesignAC.Row
  Call SetGridCell(I, 1)

  '???? libNAC = libNAC + fltNAC

  AddRemoveAC = True
  
End Sub

Private Sub cmdBack_Click()

    'Check if data changed
    'Call CheckChangedData

    Unload Me
    
End Sub

Private Sub cmdCancel_Click()

CancelChanges = True

Unload Me

End Sub

Private Sub cmdClearLoadFile_Click()

Dim I As Integer


  If NAC = 0 Then
    I = MsgBox("Aircraft list is empty.", vbOKOnly, "Clearing the Aircraft List")
    Exit Sub
  End If


  S$ = "All aircraft will be" & NL
  S$ = S$ & "cleared from the design list." & NL2
  S$ = S$ & "Do you want to do this?"
  
  If MsgBoxDQ(S$, 4 + 256, "Clearing the Design List") = 6 Then
    With grdDesignAC
      For I = 1 To .Rows - 2
        .RemoveItem 1
      Next I
      .Row = 1
      For I = 0 To .Cols - 1
        .Col = I
        .Text = ""
      Next I
      NAC = 0
    End With
    
    AddRemoveAC = True
    
  End If

  S$ = "      Design" & NL & "   Aircraft ("
  grdDesignAC.TextMatrix(0, 0) = S$ & Format(NAC, "0") & ")"
  
End Sub

Private Sub cmdHelp_Click()
    
    SendKeys "{F1}"
    
End Sub

Private Sub cmdLoadACfromLibrary_Click()


  Dim I As Integer, J As Integer, FullFileName$, I2 As Integer
  Static Started As Boolean
  On Error GoTo ReadFileError
  
  cdlFiles.InitDir = ExtFilePath$
  cdlFiles.Filter = "ext files|*.ext"
  cdlFiles.CancelError = True
  cdlFiles.FileName = ExternalAircraftFileName$
  cdlFiles.ShowOpen  ' Skip rest of sub on Cancel.
  
  ExternalAircraftFileName$ = cdlFiles.FileTitle
  FullFileName$ = cdlFiles.FileName
  ExtFilePath$ = Left$(FullFileName$, Len(FullFileName$) - Len(ExternalAircraftFileName$))
  Debug.Print FullFileName$; " "; ExtFilePath$; " "; ExternalAircraftFileName$
  
  cdlFiles.InitDir = ExtFilePath$
'  FileExt$ = Right$(DatFileName$, 4)
  ExternalAircraftFileName$ = Left$(ExternalAircraftFileName$, Len(ExternalAircraftFileName$) - 4)
  libNAC = LibACGroup(ExternalLibraryIndex) - 1 ' Number of aircraft without the external library.
  J = libNAC
  
  Call ReadExternalFile(J) ' Returns with libNAC increased by the number in the external file.
  'frmGear.Caption = frmGearCaptionStart & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext"
  frmAirplaneList.Caption = frmGearCaptionStart & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext"

  'Updates library aircraft display for External Library
  If lstACGroup.ListIndex = ExternalLibraryIndex - 1 Then
    libIndex = J + 1 ' First airplane in the new list, saved above.
    Call UpdateDataFromLibrary(libIndex)
    Call lstACGroup_Click
    
    'Call frmGear.lstACGroup_Click
  End If



     With grdDesignAC
      
      For I = 1 To .Rows - 2
        .RemoveItem 1
      Next I
      
      .Row = 1
      For I = 0 To .Cols - 1
        .Col = I
        .Text = ""
      Next I
      
      NAC = 0
    End With
  
    S$ = "      Design" & NL & "   Aircraft ("
    grdDesignAC.TextMatrix(0, 0) = S$ & Format(NAC, "0") & ")"
  
   For I = LibACGroup(NLibACGroups) To libNAC
     NAC = NAC + 1
     If NAC > 1 Then grdDesignAC.AddItem libACName$(LibACGroup(NLibACGroups) + 1)
     
     'Call CoverageToPassI(I)
        
        ReDim lYWheels(grdNWheels(NAC))
        For I2 = 1 To grdNWheels(NAC)
            lYWheels(I2) = grdXWheels(NAC, I2)
        Next I2
        
        
        gCoverages = grdCoverages(NAC)
        Call CoverageToPass(CDbl(grdGrossWeight(NAC)), CDbl(grdPcntOnMainGears(NAC, Thick_mode)), _
                                CDbl(grdNMainGears(NAC)), grdNWheels(NAC), lYWheels, CDbl(grdTirePressure(NAC)), CDbl(grdTireContactArea(NAC)))
       grdFlexibleAnnualDepartures(NAC) = gFlexibleAnnualDepartures
       grdRigidAnnualDepartures(NAC) = gRigidAnnualDepartures
     
     Call AddACDataToGridlib(NAC, I) 'row ac
   Next I
   
   
   grdNAC = NAC
   
   If lstACGroup.ListIndex = ExternalLibraryIndex - 1 Then
        lstLibFile.ListIndex = 0
   Else
        Call SetGridCell(1, 1)
   End If

   
   'Call SetVal
   
   Refresh
    

  Exit Sub
  
ReadFileError:
  Debug.Print "Error No = "; Err
  If Err = cdlCancel Then Exit Sub
  Ret = MsgBox(Err.Description & " occurred reading the external airplane file.", vbOKOnly, "File Error")

End Sub

Private Sub cmdRemove_Click()

 Dim I, i1, NN As Integer, S$
 Dim N As Integer
    
  If NAC = 0 Then Exit Sub
  
  N = grdDesignAC.Row
  'LI = libIndex
  
  If N > 0 Then
    NAC = NAC - 1
    For I = N To NAC
      NN = I + 1
      
      'libIndex(I) = libIndex
      ACName$(I) = ACName$(NN)
      GL(I) = GL(NN)
      WT(I) = WT(NN)
      TW(I) = TW(NN)
      RepsAnnual(I) = RepsAnnual(NN)
      RepsInc(I) = RepsInc(NN)
    
    'check Sub WriteExternalFile2()
    
    
    grdJobTitle$(I) = grdJobTitle$(NN)
    grdGrossWeight(I) = grdGrossWeight(NN)
    grdNMainGears(I) = grdNMainGears(NN)
    grdPcntOnMainGears(I, ACN_mode) = grdPcntOnMainGears(NN, ACN_mode)
    grdPcntOnMainGears(I, Thick_mode) = grdPcntOnMainGears(NN, Thick_mode)
    grdNWheels(I) = grdNWheels(NN)

    For i1 = 1 To grdNWheels(NN)
        grdXWheels(I, i1) = grdXWheels(NN, i1)
        grdYWheels(I, i1) = grdYWheels(NN, i1)
    Next i1
    
    grdTirePressure(I) = grdTirePressure(NN)
    grdTireContactArea(I) = grdTireContactArea(NN)
    grdXGridOrigin(I) = grdXGridOrigin(NN)
    grdXGridMax(I) = grdXGridMax(NN)
    grdXGridNPoints(I) = grdXGridNPoints(NN)
    grdYGridOrigin(I) = grdYGridOrigin(NN)
    grdYGridMax(I) = grdYGridMax(NN)
    grdYGridNPoints(I) = grdYGridNPoints(NN)
    grdStandardCoverages(I) = grdStandardCoverages(NN)
                        
    
    Next I
    
    With grdDesignAC
      If .Rows <= 2 Then ' Must have at least 1 non-fixed row.
        .Row = 1
        For I = 0 To .Cols - 1
          .Col = I
          .Text = ""
        Next I
      Else
        .RemoveItem N
      End If
    End With
  Else
    S$ = "An aircraft must be selected before removal."
    Ret = MsgBoxDQ(S$, 0, "Removing Design Aircraft")
  End If
  
  If N > NAC Then N = NAC
  If NAC = 0 Then N = 1
  S$ = "      Design" & NL & "   Aircraft ("
  grdDesignAC.TextMatrix(0, 0) = S$ & Format(NAC, "0") & ")"
  'Call UpdateCurrentSectData   ' Set standard flags.
  
  Call SetGridCell(N, 1)
      
  AddRemoveAC = True
  
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
  Next I

  IACAddedorRemoved = libIndex
  
  libNAC = libNAC - 1
  Call UpdateDataFromLibrary(libIndex)
  'Call WriteExternalFile
  
'  lstACGroupIndex = ExternalLibraryIndex - 1
'  lstACGroup.ListIndex = lstACGroupIndex
'  ILibACGroup = lstACGroupIndex + 1
'  lstACGroup.Selected(lstACGroup.ListIndex) = True
  Call lstACGroup_Click

End Sub

Private Sub cmdSaveACinLibrary_Click()
  
  Dim S$, FullFileName$, J As Integer
  On Error GoTo SaveFileError
  
  cdlFiles.InitDir = ExtFilePath$
  cdlFiles.Filter = "ext files|*.ext"
  cdlFiles.CancelError = True
  
  cdlFiles.FileName = ExternalAircraftFileName$
  cdlFiles.ShowSave  ' Skip rest of sub on Cancel.
  
  
  ExternalAircraftFileName$ = cdlFiles.FileTitle
  FullFileName$ = cdlFiles.FileName
  ExtFilePath$ = Left$(FullFileName$, Len(FullFileName$) - Len(ExternalAircraftFileName$))
  Debug.Print FullFileName$; " "; ExtFilePath$; " "; ExternalAircraftFileName$
  cdlFiles.InitDir = ExtFilePath$
'  FileExt$ = Right$(DatFileName$, 4)
  
  ExternalAircraftFileName$ = Left$(ExternalAircraftFileName$, Len(ExternalAircraftFileName$) - 4)
  'frmGear.Caption = frmGearCaptionStart & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext"
  Call UpdateLibraryData(libIndex)
  Call WriteExternalFile2
  
  J = LibACGroup(ExternalLibraryIndex) - 1  ' Number of aircraft without the external library.
  S$ = libACName$(144) 'P-3 last aircraft in the internal library
  
  
  'ik
  libNAC = LibACGroup(ExternalLibraryIndex) - 1 ' Number of aircraft without the external library.
  J = libNAC
  Call ReadExternalFile(J) ' Returns with libNAC increased by the number in the external file.
  
  frmAirplaneList.Caption = frmGearCaptionStart & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext"
  
  
  If lstACGroupIndex + 1 = NLibACGroups Then
  'lstACgroup.
  Call lstACGroup_Click
  'Call frmGear.lstACGroup_Click
  lstLibFile.Selected(0) = True
  End If
  
  
  LoadDataChanged = False
  AddRemoveAC = False
  Exit Sub

SaveFileError:
  Debug.Print "Error No = "; Err
  If Err = cdlCancel Then Exit Sub
  Ret = MsgBox(Err.Description & " occurred writing the external airplane file.", vbOKOnly, "File Error")
End Sub




Private Sub cmdSaveFloat_Click()

Dim I As Integer, J As Integer


  
  I = NAC
  If I < 1 Then
    S$ = "There are no aircraft in the design" & NL
    S$ = S$ & "list to save to the floating list." & NL2
    S$ = S$ & "Do you want to clear the floating list?"
    Ret = MsgBoxDQ(S$, 4 + 256, "Saving to Float")  ' YesNo
    If Ret = 6 Then
      fltNAC = 0              ' Yes
      For J = lstFloatAC.ListCount - 1 To 0 Step -1
        lstFloatAC.RemoveItem J
      Next J
    End If
  
  Else
    
    fltNAC = I
    For J = lstFloatAC.ListCount - 1 To 0 Step -1
      lstFloatAC.RemoveItem J
    Next J
    
    For J = 1 To I
      fltACName$(J) = grdDesignAC.TextMatrix(J, 0)
      fltGL(J) = grdDesignAC.TextMatrix(J, 1)
      
      fltCoverages(J) = grdDesignAC.TextMatrix(J, 2)
      fltFlexAnnualDep(J) = grdDesignAC.TextMatrix(J, 3)
      fltRigAnnualDep(J) = grdDesignAC.TextMatrix(J, 4)
      
      fltPcntOnMainGears(J) = grdDesignAC.TextMatrix(J, 5)
      fltNMainGears(J) = grdDesignAC.TextMatrix(J, 6)
      fltNTires(J) = grdDesignAC.TextMatrix(J, 7)
      fltCP(J) = grdDesignAC.TextMatrix(J, 8)
      
      
      
      
      'lstFloatAC.AddItem ACName$(J)
    Next J
    
    
    For I = LibACGroup(NLibACGroups) To libNAC
        lstFloatAC.AddItem libACName$(I)
    Next I
        
  End If

End Sub


Private Sub cmdSaveList_Click()

    Dim I, J As Integer

    If NAC = 0 Then
        Ret = MsgBoxDQ("There are no aircraft to save.", 0, "Saving Aircraft")
        Exit Sub
    End If
   
    'Call UpdateLibraryData(libIndex)
    Call WriteExternalFile2
  
    J = LibACGroup(ExternalLibraryIndex) - 1  ' Number of aircraft without the external library.
    S$ = libACName$(144) 'P-3 last aircraft in the internal library
    
    libNAC = LibACGroup(ExternalLibraryIndex) - 1 ' Number of aircraft without the external library.
    J = libNAC
    Call ReadExternalFile(J) ' Returns with libNAC increased by the number in the external file.
  
    frmAirplaneList.Caption = frmGearCaptionStart & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext"
       
'    If lstACGroupIndex + 1 = NLibACGroups Then
'        Call lstACGroup_Click
'        lstLibFile.Selected(0) = True
'    End If
  
    If lstACGroup.ListIndex = ExternalLibraryIndex - 1 Then
        Call lstACGroup_Click
        lstLibFile.ListIndex = 0
    End If
  
'    If frmGear.lstACGroup.ListIndex = ExternalLibraryIndex - 1 Then
'        Call frmGear.lstACGroup_Click
'        lstLibFile.ListIndex = 0
'    End If

    LoadDataChanged = False
    AddRemoveAC = False
    grdNAC = NAC
    DataSaved = True
 
End Sub


Private Sub Form_Load()
  
Dim I As Integer, NGridCols As Integer, I2 As Integer
  
    frmAirplaneListLoaded = True
    CancelChanges = False
    LoadDataChanged = False
    DataSaved = False
    
    NL = Chr(13) & Chr(10)  ' Carriage return & line feed.
    Left = frmGear.Left + 900:  Top = frmGear.Top
    Caption = frmGearCaptionStart & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext"

    For I = 1 To NLibACGroups
        lstACGroup.AddItem LibACGroupName$(I)
    Next I
    
    I = lstLibFileIndex
    lstACGroup.Selected(lstACGroupIndex) = True  ' Sets lstLibFileIndex = 0
    lstLibFileIndex = I                          ' Select last group.
    
    If Not lstLibFile.ListCount = 0 Then
    lstLibFile.Selected(lstLibFileIndex) = True
    End If
   
    'Display floating aircraft list.
    For I = 1 To fltNAC
     lstFloatAC.AddItem fltACName$(I)
    Next I

    With grdDesignAC
    .Cols = 9
    .FocusRect = flexFocusNone 'Heavy
    .AllowBigSelection = False ' Does not select cells when click on fixed rows or cols. GFH 07/01/03.
    NGridCols = .Cols
    '.ColAlignment(3) = flexAlignRightCenter
    .ColAlignment(0) = flexAlignLeftCenter

    'Set aircraft design grid column widths.
    .ColWidth(0) = 1400            ' 1600
    For I = 1 To NGridCols - 1
      .ColWidth(I) = 1250
    Next I

    'Aircraft design grid titles.
    .RowHeight(0) = .RowHeight(0) * 1.75 ' 2
    .Row = 0
    .FixedAlignment(0) = flexAlignLeftCenter
    For I = 1 To NGridCols - 1
      .FixedAlignment(I) = flexAlignCenterCenter
    Next I

  
'   Column 0 title (Design Aircraft) is set in Sub AddACDataToGrid,
'   cmdRemove and cmdClearLoadFile because it also displays NAC.
    If UnitsOut.Metric Then S$ = "tns" Else S$ = "lbs"
    I = 1:     .Col = I:  .Text = "Gross" & NL & "Weight (" & S$ & ")"
    I = I + 1: .Col = I: .Text = "Coverages" & NL & "(20 yr total)"
    I = I + 1: .Col = I: .Text = "Flex Ann Dep" & NL & "P/C"
    I = I + 1: .Col = I: .Text = "Rig Ann Dep" & NL & "P/C"
    I = I + 1: .Col = I:  .Text = "% GW" & NL & "on Main Gear"
    I = I + 1: .Col = I:  .Text = "No. Main" & NL & "Gears"
    I = I + 1: .Col = I:   .Text = "Wheels on" & NL & "Main Gear"
    I = I + 1: .Col = I:  .Text = "Tire" & NL & "Press. (" & UnitsOut.psiName & ")"
        
    For I = 1 To NGridCols - 1
      .ColAlignment(I) = flexAlignCenterCenter
    Next I
             
    End With

    NAC = 0
    S$ = "      Design" & NL & "   Aircraft ("
    grdDesignAC.TextMatrix(0, 0) = S$ & Format(NAC, "0") & ")"
                  
    For I = LibACGroup(NLibACGroups) To libNAC '145 to example 150
        'lstLibFile.AddItem libACName$(I)
      
        NAC = NAC + 1
        If NAC > 1 Then grdDesignAC.AddItem libACName$(LibACGroup(NLibACGroups))
        'frmGear.lstLibFile.Selected(NAC - 1) = True
    
        'Call CoverageToPassI(I)
        
        ReDim lYWheels(grdNWheels(NAC))
        For I2 = 1 To grdNWheels(NAC)
            lYWheels(I2) = grdXWheels(NAC, I2)
        Next I2
        
        
        gCoverages = grdCoverages(NAC)
        Call CoverageToPass(CDbl(grdGrossWeight(NAC)), CDbl(grdPcntOnMainGears(NAC, Thick_mode)), _
                                CDbl(grdNMainGears(NAC)), grdNWheels(NAC), lYWheels, CDbl(grdTirePressure(NAC)), CDbl(grdTireContactArea(NAC)))
       grdFlexibleAnnualDepartures(NAC) = gFlexibleAnnualDepartures
       grdRigidAnnualDepartures(NAC) = gRigidAnnualDepartures
        
        Call AddACDataToGridlib(NAC, I) 'row ac
    
    Next I
    
    If lstACGroup.ListIndex = ExternalLibraryIndex - 1 Then
        Call SetGridCell(lstLibFileIndex + 1, 1)
    Else
        Call SetGridCell(1, 1)
    End If
    
  
    lstLibFileIndex = frmGear.lstLibFile.ListIndex
    libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear.lstLibFile.ListIndex ' Library index
       
   
    'Call CoverageToPass
    'Call SetVal
    grdNAC = NAC
    
End Sub

Private Sub Form_QueryUnload(Cancel As Integer, UnloadMode As Integer)
  
    Dim I As Integer
    Dim libIndex1 As Integer
    
    frmGear.Caption = frmGearCaptionStart & ExtFilePath$ & ExternalAircraftFileName$ & ".Ext"
      
    If CancelChanges Or DataSaved Then
        Call ResetValues
        
        
        Exit Sub
    End If
    
    
    If grdNAC <> NAC Then GoTo ExitDataChanged
  
    For I = 1 To NAC
    
        libIndex1 = LibACGroup(ExternalLibraryIndex) + I - 1
        
        If grdGrossWeight(I) <> libGL(libIndex1) Then GoTo ExitDataChanged
        If grdNMainGears(I) <> libNMainGears(libIndex1) Then GoTo ExitDataChanged
        If grdNWheels(I) <> libNTires(libIndex1) Then GoTo ExitDataChanged

        If grdPcntOnMainGears(I, ACN_mode) <> libPcntOnMainGears(libIndex1, ACN_mode) Then GoTo ExitDataChanged
        If grdPcntOnMainGears(I, Thick_mode) <> libPcntOnMainGears(libIndex1, Thick_mode) Then GoTo ExitDataChanged
        
        If grdTirePressure(I) <> libCP(libIndex1) Then GoTo ExitDataChanged
        If grdTireContactArea(I) <> libTireContactArea(libIndex1) Then GoTo ExitDataChanged
        
        If grdCoverages(I) <> libCoverages(libIndex1) Then GoTo ExitDataChanged

        'grdFlexibleAnnualDepartures()   'grdRigidAnnualDepartures()
    Next I
   
    If AddRemoveAC Or LoadDataChanged Then GoTo ExitDataChanged
  
    Exit Sub

ExitDataChanged:
  
  S$ = "Data for the current airplane list has changed." & NL2
  S$ = S$ & "Do you want to save the new data" & vbCrLf
  S$ = S$ & "before returning to windows?"
  Ret = MsgBox(S$, vbYesNoCancel, "Save Current Data?")
  
  If Ret = vbYes Then
    
    Call cmdSaveACinLibrary_Click 'ask for library name confirmation
    'Call cmdSaveList_Click        'saves automatically
  
  ElseIf Ret = vbNo Then
    
    'don't save changes and return
    AddRemoveAC = False
    Call ResetValues
  
  ElseIf Ret = vbCancel Then
    
    Cancel = True
  
  End If


End Sub

Private Sub Form_Resize()

  If Not frmGearStarted Then Exit Sub
  If WindowState = vbMinimized Then Exit Sub
  
  Call MainResize

  
End Sub

Private Sub Form_Unload(Cancel As Integer)

    Unload Me
    libIndex = LibACGroup(frmGear.lstACGroup.ListIndex + 1) + frmGear.lstLibFile.ListIndex
    'Call SetVal
              
    'call after query_unload
    frmGear.lstACGroup.ListIndex = ExternalLibraryIndex - 1
    Call frmGear.lstACGroup_Click
    
    frmAirplaneListLoaded = False
    
End Sub





Private Sub grdDesignAC_Click()
  
    Dim ValueChanged As Boolean
    Dim irow As Integer, ICol As Integer, I As Integer

    If lstACGroup.ListIndex = ExternalLibraryIndex - 1 Then
        indexBoolean = True
        lstLibFileIndex = grdDesignAC.Row - 1
        indexBoolean = False
    End If
   
    If NAC = 0 Then Exit Sub
  
    With grdDesignAC
        If .MouseRow = 0 Or .MouseCol = 0 Then
            Exit Sub
        End If
        If grdDesignACY > .RowPos(.Rows - 1) + .RowHeight(.Rows - 1) Then
            Exit Sub
        End If
        irow = .Row
        ICol = .Col
    End With
  
    ReDim lYWheels(grdNWheels(irow))
    For I = 1 To grdNWheels(irow)
        lYWheels(I) = grdXWheels(irow, I)
    Next I

  
    
    If Not (1 <= ICol And ICol <= 8) Then Exit Sub
    
    LI = grdDesignAC.Row
  
    If grdDesignAC.Col = 1 Then 'Gross Weight
        Call ChangeGrossWeightAirplaneList(ValueChanged)
        If ValueChanged Then
            LoadDataChanged = True
            grdDesignAC.TextMatrix(irow, ICol) = Format(grdGrossWeight(irow) * UnitsOut.pounds, UnitsOut.poundsFormat)
            
            gCoverages = grdCoverages(irow)
            Call CoverageToPass(CDbl(grdGrossWeight(irow)), CDbl(grdPcntOnMainGears(irow, Thick_mode)), _
                                CDbl(grdNMainGears(irow)), grdNWheels(irow), lYWheels, CDbl(grdTirePressure(NAC)), CDbl(grdTireContactArea(irow)))
                  
            grdDesignAC.TextMatrix(irow, 3) = Format(gFlexibleAnnualDepartures, UnitsOut.covFormat)
            grdDesignAC.TextMatrix(irow, 4) = Format(gRigidAnnualDepartures, UnitsOut.covFormat)
            
        End If
    
    ElseIf grdDesignAC.Col = 2 Then 'Changing Coverages
        Call ChangeCoveragesAirplaneList(ValueChanged)  '01.13.03 ikawa
        If ValueChanged Then
            LoadDataChanged = True
                  
            gCoverages = grdCoverages(irow)
            Call CoverageToPass(CDbl(grdGrossWeight(irow)), CDbl(grdPcntOnMainGears(irow, Thick_mode)), _
                                CDbl(grdNMainGears(irow)), grdNWheels(irow), lYWheels, CDbl(grdTirePressure(NAC)), CDbl(grdTireContactArea(irow)))
        
                                      
            grdDesignAC.TextMatrix(irow, 2) = Format(grdCoverages(irow), UnitsOut.covFormat)
            grdDesignAC.TextMatrix(irow, 3) = Format(gFlexibleAnnualDepartures, UnitsOut.covFormat)
            grdDesignAC.TextMatrix(irow, 4) = Format(gRigidAnnualDepartures, UnitsOut.covFormat)
                       
        End If
    
    ElseIf grdDesignAC.Col = 3 Then 'Flexible Annual Departures
           gCoverages = grdCoverages(irow)
           Call CoverageToPass(CDbl(grdGrossWeight(irow)), CDbl(grdPcntOnMainGears(irow, Thick_mode)), _
                                CDbl(grdNMainGears(irow)), grdNWheels(irow), lYWheels, CDbl(grdTirePressure(NAC)), CDbl(grdTireContactArea(irow)))
    
        Call ChangeFlexibleAnnualDeparturesAirplaneList(ValueChanged)
        
        If ValueChanged Then
            grdDesignAC.TextMatrix(irow, 2) = Format(grdCoverages(irow), UnitsOut.covFormat)
            grdDesignAC.TextMatrix(irow, 3) = Format(grdFlexibleAnnualDepartures(irow), UnitsOut.covFormat)
            grdDesignAC.TextMatrix(irow, 4) = Format(grdRigidAnnualDepartures(irow), UnitsOut.covFormat)
            LoadDataChanged = True
        End If
    
    ElseIf grdDesignAC.Col = 4 Then 'Rigid Annual Departures
           gCoverages = grdCoverages(irow)
           Call CoverageToPass(CDbl(grdGrossWeight(irow)), CDbl(grdPcntOnMainGears(irow, Thick_mode)), _
                                CDbl(grdNMainGears(irow)), grdNWheels(irow), lYWheels, CDbl(grdTirePressure(NAC)), CDbl(grdTireContactArea(irow)))
        
        Call ChangeRigidAnnualDeparturesAirplaneList(ValueChanged)
        
        If ValueChanged Then
            grdDesignAC.TextMatrix(irow, 2) = Format(grdCoverages(irow), UnitsOut.covFormat)
            grdDesignAC.TextMatrix(irow, 3) = Format(grdFlexibleAnnualDepartures(irow), UnitsOut.covFormat)
            grdDesignAC.TextMatrix(irow, 4) = Format(grdRigidAnnualDepartures(irow), UnitsOut.covFormat)
            LoadDataChanged = True
        End If
        
    ElseIf grdDesignAC.Col = 5 Then 'Percent on Main Gears
        Call ChangePcntOnMainGearsAirplaneList(ValueChanged)
        If ValueChanged Then
            grdDesignAC.TextMatrix(irow, ICol) = Format(grdPcntOnMainGears(irow, Thick_mode), "##0.00")
            LoadDataChanged = True
            
            Call CoverageToPass(CDbl(grdGrossWeight(irow)), CDbl(grdPcntOnMainGears(irow, Thick_mode)), _
                                CDbl(grdNMainGears(irow)), grdNWheels(irow), lYWheels, CDbl(grdTirePressure(NAC)), CDbl(grdTireContactArea(irow)))
                  
            grdDesignAC.TextMatrix(irow, 3) = Format(gFlexibleAnnualDepartures, UnitsOut.covFormat)
            grdDesignAC.TextMatrix(irow, 4) = Format(gRigidAnnualDepartures, UnitsOut.covFormat)
                        
        End If
    
    ElseIf grdDesignAC.Col = 6 Then 'Number of Main Gears
        Call ChangeNMainGearsAirplaneList(ValueChanged)
        If ValueChanged Then
            grdDesignAC.TextMatrix(irow, ICol) = Format(grdNMainGears(irow), "#0")
            LoadDataChanged = True
            
            Call CoverageToPass(CDbl(grdGrossWeight(irow)), CDbl(grdPcntOnMainGears(irow, Thick_mode)), _
                                CDbl(grdNMainGears(irow)), grdNWheels(irow), lYWheels, CDbl(grdTirePressure(NAC)), CDbl(grdTireContactArea(irow)))
                  
            grdDesignAC.TextMatrix(irow, 3) = Format(gFlexibleAnnualDepartures, UnitsOut.covFormat)
            grdDesignAC.TextMatrix(irow, 4) = Format(gRigidAnnualDepartures, UnitsOut.covFormat)
            
        End If
    
    ElseIf grdDesignAC.Col = 7 Then 'Wheels on Main Gear
    ElseIf grdDesignAC.Col = 8 Then 'Tire Pressure
    
    End If

End Sub

Private Sub grdDesignAC_DblClick()

    If NAC = 0 Then Exit Sub
  
    With grdDesignAC
        If .MouseCol = 0 Then
        Call cmdRemove_Click
        End If
    End With

End Sub

Public Sub lstACGroup_Click()
  
  Dim I As Integer, J As Integer, FullFileName$
  Static Started As Boolean
  On Error GoTo ReadFileError

    
  lstACGroupIndex = lstACGroup.ListIndex
  ILibACGroup = lstACGroupIndex + 1

  For I = lstLibFile.ListCount - 1 To 0 Step -1
    lstLibFile.RemoveItem I
  Next I
  
  If ILibACGroup = NLibACGroups Then
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
  
  'If I > -1 Then lstLibFile.Selected(I) = True
  

  If NAC > 0 And I > 0 Then lstLibFile.Selected(I) = True
  
  If Not lstLibFile.ListCount = 0 Then
  lstLibFile.ListIndex = 0
  End If
  
  Exit Sub
  
ReadFileError:
  Debug.Print "Error No = "; Err
  If Err = cdlCancel Then Exit Sub
  Ret = MsgBox(Err.Description & " occurred reading the external airplane file.", vbOKOnly, "File Error")
End Sub


Public Sub lstLibFile_Click()
  
  Dim I As Integer, J As Integer
  
  EditWheels = False 'Izydor Kawa code
    
' If data has changed, then changing to another aircraft displays
' the "do you want to save the data" dialog box. Responding
' "Cancel" moves the selection back to the previous aircraft in
' the list, calling this subroutine recursively. Hence the
' following code to skip the subroutine on recursion.

'  If ChangeDataRet = vbCancel Then Exit Sub
'  If ChangeDataRet = 0 Then
'    Call CheckChangedData
'    If ChangeDataRet <> 0 Then
'      ChangeDataRet = 0
'      Exit Sub
'    End If
'  End If
  
  If ACN_mode_true Then 'ik02
    Call MainSetGrids 'ik02
  End If
  
  lstLibFileIndex = lstLibFile.ListIndex
  libIndex = LibACGroup(lstACGroupIndex + 1) + lstLibFile.ListIndex ' Library index
  
'  Units$ = "English Units"
'  JobTitle$ = libACName$(libIndex)
'  GrossWeight = libGL(libIndex)
'  NWheels = libNTires(libIndex)
  
'  For I = 1 To NWheels
'    XWheels(I) = libTY(libIndex, I)
'    YWheels(I) = libTX(libIndex, I)
'  Next I
  
 ' TirePressure = libCP(libIndex)

'  If ACN_mode_true Then
'    PcntOnMainGears = libPcntOnMainGears(libIndex, ACN_mode)
'    Coverages = StandardCoverages
'  Else
'    PcntOnMainGears = libPcntOnMainGears(libIndex, Thick_mode)
'    Coverages = libCoverages(libIndex)
'  End If
  
'  NMainGears = libNMainGears(libIndex)
'  InputAlpha = libAlpha(libIndex)
'  AlphaFactor = InputAlpha
'  XGridOrigin = libXGridOrigin(libIndex)
'  XGridMax = libXGridMax(libIndex)
'  XGridNPoints = libXGridNPoints(libIndex)
'  YGridOrigin = libYGridOrigin(libIndex)
'  YGridMax = libYGridMax(libIndex)
'  YGridNPoints = libYGridNPoints(libIndex)
'  If RigidCutoff = 0 Then RigidCutoff = StandardRigidCutoff ' GFH 07-11-08.
'  If ConcreteFlexuralStrength = 0 Then ' GFH 07-11-08.
'    ConcreteFlexuralStrength = StandardConcreteStrength 'Izydor Kawa code
'  End If
'  TireContactArea = libTireContactArea(libIndex) 'ik03
  
  
'  InputCBR = 0     ' Does not change CBR when airplane is changed.
'  InputkValue = 0  ' Same for k value.
  
  Call ResetOutputs
  Call WriteOutputGrid
  'Call CoverageToPass
    
  FlexibleOutputText = ""
  RigidOutputText = ""
  
  If Not indexBoolean Then
  
  
  'If LoadingfrmAirplaneList Then
'  If lstACGroup.ListIndex = ExternalLibraryIndex - 1 And frmAirplaneListLoaded Then
'      Dim i123 As Integer
'
'            i123 = grdDesignAC.Rows
'      If lstLibFileIndex + 1 < i123 Then
'            Call SetGridCell(lstLibFileIndex + 1, 1)
'      End If
'  End If
 'End If
 
  End If
  
   
End Sub

Private Sub lstLibFile_DblClick()

 Call cmdAdd_Click

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
'      lblCriticalAircraftText.Caption = lstLibFile.Text
    End If
  End If
  
End Sub



Private Sub AddACDataToGrid(I As Integer, N2 As Integer)
  
    Dim II As Integer
  
    With grdDesignAC
  
        S$ = "      Design" & NL & "   Aircraft ("
        .TextMatrix(0, 0) = S$ & Format(NAC, "0") & ")"
        .RowHeight(I) = .RowHeightMin
        
        II = 0:  .TextMatrix(I, II) = ACName$(I)
        II = II + 1: .TextMatrix(I, II) = Format(libGL(N2) * UnitsOut.pounds, UnitsOut.poundsFormat)
        II = II + 1: .TextMatrix(I, II) = Format(libCoverages(N2), UnitsOut.covFormat)
        II = II + 1: .TextMatrix(I, II) = Format(FlexibleAnnualDepartures * UnitsOut.psi, UnitsOut.covFormat)
        II = II + 1: .TextMatrix(I, II) = Format(RigidAnnualDepartures * UnitsOut.psi, UnitsOut.covFormat)
        II = II + 1: .TextMatrix(I, II) = Format(libPcntOnMainGears(N2, Thick_mode), "##0.00")
        II = II + 1: .TextMatrix(I, II) = Format(libNMainGears(N2), "#0")
        II = II + 1: .TextMatrix(I, II) = Format(libNTires(N2), "#,###,##0")
        II = II + 1: .TextMatrix(I, II) = Format(libCP(N2) * UnitsOut.psi, UnitsOut.psiFormat)
 
    End With

End Sub


Private Sub fltAddACDataToGrid(J As Integer, I As Integer)
  
  Dim II As Integer, LI As Integer
  Dim DTemp As Double
  
  With grdDesignAC
    S$ = "      Design" & NL & "   Aircraft ("
    .TextMatrix(0, 0) = S$ & Format(NAC, "0") & ")"
    LI = libIndex
    .RowHeight(I) = .RowHeightMin
    II = 0:       .TextMatrix(I, II) = fltACName$(J)
    II = II + 1:     .TextMatrix(I, II) = Format(fltGL(J) * UnitsOut.pounds, UnitsOut.poundsFormat)
    II = II + 1:     .TextMatrix(I, II) = Format(fltCoverages(J) * UnitsOut.psi, UnitsOut.covFormat)
    II = II + 1:     .TextMatrix(I, II) = Format(fltFlexAnnualDep(J) * UnitsOut.psi, UnitsOut.covFormat)
    II = II + 1:     .TextMatrix(I, II) = Format(fltRigAnnualDep(J) * UnitsOut.psi, UnitsOut.covFormat)
    II = II + 1:     .TextMatrix(I, II) = Format(fltPcntOnMainGears(J), "##0.00")
    II = II + 1:     .TextMatrix(I, II) = Format(fltNMainGears(J), "#0")
    II = II + 1:     .TextMatrix(I, II) = Format(fltNTires(I), "#,###,##0")
    II = II + 1:     .TextMatrix(I, II) = Format(fltCP(J) * UnitsOut.psi, UnitsOut.psiFormat)
    
  End With

End Sub



Private Sub AddACDataToGridlib(I As Integer, N As Integer)
  
  Dim II As Integer, LI As Integer
  Dim DTemp As Double
  
  With grdDesignAC
    S$ = "      Design" & NL & "   Aircraft ("
    .TextMatrix(0, 0) = S$ & Format(NAC, "0") & ")"
    LI = libIndex
    If Len(libACName$(N)) > 13 Then
        .RowHeight(I) = .RowHeightMin * 1.5
    Else
        .RowHeight(I) = .RowHeightMin
    End If
    
    II = 0:         .TextMatrix(I, II) = libACName$(N)
    II = II + 1:    .TextMatrix(I, II) = Format(libGL(N) * UnitsOut.pounds, UnitsOut.poundsFormat)
    II = II + 1:    .TextMatrix(I, II) = Format(libCoverages(N), UnitsOut.covFormat)
    II = II + 1:    .TextMatrix(I, II) = Format(gFlexibleAnnualDepartures * UnitsOut.psi, UnitsOut.covFormat)
    II = II + 1:    .TextMatrix(I, II) = Format(gRigidAnnualDepartures * UnitsOut.psi, UnitsOut.covFormat)
    II = II + 1:    .TextMatrix(I, II) = Format(libPcntOnMainGears(N, Thick_mode), "##0.00")
    II = II + 1:    .TextMatrix(I, II) = Format(libNMainGears(N), "#0")
    II = II + 1:    .TextMatrix(I, II) = Format(libNTires(N), "#0")
    II = II + 1:    .TextMatrix(I, II) = Format(libCP(N) * UnitsOut.psi, UnitsOut.psiFormat)
    
'    .TextMatrix(I, II) = Format(libAlpha(libIndex), "0.000")
'    Temp = libTT(LI)
'    If libGear$(LI) = "B" Or libGear$(LI) = "E" Then Temp = 0!
'    II = II + 1:   .TextMatrix(I, II) = Format(Temp * UnitsOut.inch, UnitsOut.inchFormat)
'    II = II + 1:   .TextMatrix(I, II) = Format(libB(LI) * UnitsOut.inch, UnitsOut.inchFormat)
'    II = II + 1:   .TextMatrix(I, II) = Format(WT(I) * UnitsOut.inch, UnitsOut.inchFormat)
'    II = II + 1:   .TextMatrix(I, II) = Format(TW(I) * UnitsOut.inch, UnitsOut.inchFormat)

  End With

End Sub

Private Sub SetGridCell(irow As Integer, ICol As Integer)
  
  With grdDesignAC
    .Row = irow
    .Col = ICol
  End With

End Sub





