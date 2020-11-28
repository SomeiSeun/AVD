Attribute VB_Name = "modFileProcedures"
Option Explicit


Global Const NUMBOXES = 5
Global Const SAVEFILE = 1, LOADFILE = 2
Global Const REPLACEFILE = 1, READFILE = 2, ADDTOFILE = 3
Global Const RANDOMFILE = 4, BINARYFILE = 5

' Define a data type to hold a record:
' Define global variables to hold the file number and record number
' of the current data file.
' Default file name to show in dialog boxes.
Global Const Err_DeviceUnavailable = 68
Global Const Err_DiskNotReady = 71, Err_FileAlreadyExists = 58
Global Const Err_TooManyFiles = 67, Err_RenameAcrossDisks = 74
Global Const Err_Path_FileAccessError = 75, Err_DeviceIO = 57
Global Const Err_DiskFull = 61, Err_BadFileName = 64
Global Const Err_BadFileNameOrNumber = 52, Err_FileNotFound = 53
Global Const Err_PathDoesNotExist = 76, Err_BadFileMode = 54
Global Const Err_FileAlreadyOpen = 55, Err_InputPastEndOfFile = 62
Global Const MB_EXCLAIM = 48, MB_STOP = 16

Public ExternalAircraftFileName$  ' Set on Startup.
' Public Const ExternalAircraftFileName$ = "AircraftLibrary"
' Public Const ExternalFileFormat$ = "COMFAAFormat1"
Public Const ExternalFileFormat$ = "COMFAAFormat2" ' GFH 06-12-07.

Public IACAddedorRemoved As Integer

Dim FileFormat$, FileHeader$  ' GFH 01/21/03, used in ReadExternalFile and WriteExternalFile.

Sub InsertNewAircraft(InsertName$, DupName As Boolean)
' Inserts a new section in the current job in memory.
' The insertion point is in ASCII order on InsertName$.
' Following this routine with WriteJobFile ensures that
' the sections in the job file will always be sorted and list
' box order will show ASCII order without setting .Sorted = True.
' Sorting removed 06/08/10.
  
  Dim I As Integer, II As Integer, J As Integer
  Dim IAC As Integer, IStart As Integer, S$

' Find insertion point
  DupName = False
  libNAC = libNAC + 1

  libACName$(libNAC) = "ZZZZZZZZZZZZZZZZZZ"   ' End marker.
  IStart = LibACGroup(ExternalLibraryIndex)
' GFH 06/08/10, sorting removed.
  IAC = libNAC ' adds to the end without sort.
  IAC = IStart ' adds to the beginning without sort.
  For I = IStart To -libNAC ' Do not sort before adding, skips loop.
    If StrComp(InsertName$, libACName$(I), 1) <= 0 Then
      If StrComp(InsertName$, libACName$(I), 1) = 0 Then
        S$ = "Name " & InsertName$ & " already exists." & NL2
        S$ = S$ & "No action will be taken."
        Ret = MsgBox(S$, 0, "Inserting Current Aircraft")
        libNAC = libNAC - 1
        DupName = True
        Exit Sub
      End If
      IAC = I
      Exit For
    End If
  Next I
  
' Move all data from insertion point up one place.
  For I = libNAC - 1 To IAC Step -1
  
    II = I + 1
    libACName$(II) = libACName$(I)
    libGL(II) = libGL(I)
    libNMainGears(II) = libNMainGears(I)
    'ikawa 02/11/03
    libPcntOnMainGears(II, ACN_mode) = libPcntOnMainGears(I, ACN_mode)
    libPcntOnMainGears(II, Thick_mode) = libPcntOnMainGears(I, Thick_mode)
    libNTires(II) = libNTires(I)
    libTireContactArea(II) = libTireContactArea(I) 'ik03
    
    For J = 1 To libNTires(I)
      libTY(II, J) = libTY(I, J)
      libTX(II, J) = libTX(I, J)
    Next J

    libCP(II) = libCP(I)
'    libCoverages(II) = libCoverages(I)
    libAnnualDepartures(II) = libAnnualDepartures(I)
    libXGridOrigin(II) = libXGridOrigin(I)
    libXGridMax(II) = libXGridMax(I)
    libXGridNPoints(II) = libXGridNPoints(I)
    libYGridOrigin(II) = libYGridOrigin(I)
    libYGridMax(II) = libYGridMax(I)
    libYGridNPoints(II) = libYGridNPoints(I)
  Next I

' Put current section data at insertion point.

  JobTitle$ = InsertName$
  Call UpdateLibraryData(IAC)
  IACAddedorRemoved = IAC

End Sub

Function FileErrors(errVal As Integer, FileName$) As Integer
' Return Value  Meaning     Return Value    Meaning
' 0             Resume      2               Unrecoverable error
' 1             Resume Next 3               Unrecognized error
  Dim MsgType As Integer
  Dim Response As Integer
  Dim Action As Integer
  Dim Msg As String
  MsgType = MB_EXCLAIM
  Select Case errVal
    Case Err_DeviceUnavailable  ' Error #68
        Msg = "The disk appears to be unavailable."
        MsgType = MB_EXCLAIM + 5
    Case Err_DiskNotReady       ' Error #71
        Msg = "The disk is not ready."
    Case Err_DeviceIO
        Msg = "The disk is full."
    Case Err_BadFileName, Err_BadFileNameOrNumber   ' Errors #64 & 52
        Msg = FileName$ & " path or file name is illegal."
    Case Err_PathDoesNotExist                        ' Error #76
        Msg = "The path for " & FileName$ & " doesn't exist."
    Case Err_BadFileMode                            ' Error #54
        Msg = "Can't open " & FileName$ & " for that type of access."
    Case Err_FileAlreadyOpen                        ' Error #55
        Msg = FileName$ & " is already open."
    Case Err_InputPastEndOfFile                     ' Error #62
      Msg = FileName$ & " has a nonstandard end-of-file marker,"
      Msg = Msg & "or an attempt was made to read beyond "
      Msg = Msg & "the end-of-file marker."
    Case Err_FileNotFound
      Msg = "Cannot find " & FileName$ & "."
    Case Else
        FileErrors = 3
        Msg = "Unknown file error"
        Exit Function
    End Select
    Response = MsgBox(Msg, MsgType, "File Error")
    Select Case Response
        Case 4          ' Retry button.
            FileErrors = 0
        Case 5          ' Ignore button.
            FileErrors = 1
        Case 1, 2, 3    ' Ok and Cancel buttons.
            FileErrors = 2
        Case Else
            FileErrors = 3
    End Select
End Function

Sub MakeDecimalPeriod(SN$)

  Dim IP As Long

  Do
    IP = InStr(SN$, ",")
    If IP <> 0 Then
      Mid$(SN$, IP) = "."
    Else
      Exit Do
    End If
  Loop

End Sub


Sub ReadExternalFile(IA As Integer)

  Dim I As Integer, J As Integer, IErr As Integer, S$, SS$
  Dim FileName$, EFNo As Integer
  Dim DTemp As Double
  On Error GoTo RExternalFileError
  
  FileName$ = ExtFilePath$ & ExternalAircraftFileName$ & ".Ext"
  EFNo = FreeFile
  
  If Dir(FileName$) = "" Then  ' GFH 01/21/03
    S$ = "An external aircraft library file named ExternalAircraftFileName" & ".ext" & vbCrLf
    S$ = S$ & "does not exist in " & ExtFilePath$ & "."
    Ret = MsgBox(S$, 0, "No External Aircraft Library File")
    Exit Sub
  Else
    Open FileName$ For Input As EFNo Len = 1024
  End If
    
  If EOF(EFNo) Then
    S$ = "File " & FileName$ & " is empty or does not exist." & NL2
    S$ = S$ & "No action will be taken now."
    Exit Sub
  End If
  
  ExtFileText = "File Name = " & FileName$ & vbCrLf
  Do
    Line Input #EFNo, S$
    ExtFileText = ExtFileText & S$ & vbCrLf
  Loop Until EOF(EFNo)
  
  Seek #EFNo, 1
  Line Input #EFNo, FileFormat$
  FileFormat$ = Trim(FileFormat$)  ' GFH 01/21/03 Static in Declarations. Used in WriteExternalFile.
  
  SS$ = ""
  If FileFormat$ <> "Format1" Then
    Do
      Line Input #EFNo, S$
      If S$ = "Start Data" Then Exit Do
      SS$ = SS$ + S$ & vbCrLf
      If EOF(EFNo) Then
        S$ = "The Start Data marker does not exist in " & FileName$ & "." & NL2
        S$ = S$ & "Aircraft data cannot be read."
        Exit Sub
      End If
    Loop
  End If
  FileHeader$ = SS$  ' GFH 01/21/03 Static in Declarations. Used in WriteExternalFile.
  
  Do
    If IA + 1 > MaxLibAC Then
      SS$ = Format$(MaxLibAC, "0")
      S$ = "The maximum number of aircraft allowed is " & SS$ & "." & vbCrLf
      S$ = S$ & "The external library file exceeds this value." & vbCrLf
      S$ = S$ & "No more aircraft will be loaded."
      Ret = MsgBox(S$, 0, "Too Many Sections")
      Exit Do
    End If
    If EOF(EFNo) Then Exit Do
    
    IA = IA + 1
    If FileFormat$ = "Format1" Then Line Input #EFNo, Units$  ' GFH 01/21/03
    Line Input #EFNo, libACName$(IA)
    Input #EFNo, libGL(IA)
    Input #EFNo, libNMainGears(IA)
    If FileFormat$ = "COMFAAFormat2" Then ' GFH 06-12-07.
      Input #EFNo, libPcntOnMainGears(IA, ACN_mode), libPcntOnMainGears(IA, Thick_mode)
    Else
      Input #EFNo, libPcntOnMainGears(IA, ACN_mode)
      libPcntOnMainGears(IA, Thick_mode) = libPcntOnMainGears(IA, ACN_mode)
    End If
    Input #EFNo, libNTires(IA)
    For I = 1 To libNTires(IA)
      If FileFormat$ = "Format1" Then   ' GFH 01/21/03
        Input #EFNo, libTY(IA, I)
        Input #EFNo, libTX(IA, I)
      Else
        Input #EFNo, libTX(IA, I)   ' GFH 01/21/03 For compatibility with
        Input #EFNo, libTY(IA, I)   ' LEDFAA and BackC.
      End If
    Next I
    Input #EFNo, libCP(IA)
    
    Input #EFNo, libTireContactArea(IA) 'Izydor Kawa code
    
    Input #EFNo, libXGridOrigin(IA), libXGridMax(IA), libXGridNPoints(IA)
    Input #EFNo, libYGridOrigin(IA), libYGridMax(IA), libYGridNPoints(IA)
    libAlpha(IA) = 0
    If FileFormat$ = "COMFAAFormat2" Then ' GFH 06-12-07.
'      Input #EFNo, libCoverages(IA)
      Input #EFNo, libAnnualDepartures(IA)
    Else
'      libCoverages(IA) = StandardCoverages ' For FileFormat$ = "COMFAAFormat1"
      libAnnualDepartures(IA) = DefaultAnnualDepartures
    End If
    
    'ikawa 01/24/03
    DTemp = libGL(IA) * libPcntOnMainGears(IA, ACN_mode) / 100 '/
    DTemp = DTemp / libNMainGears(IA) / libNTires(IA) / libCP(IA)  'ik033 uncommented by GFH 01/21/03
    If libTireContactArea(IA) < DTemp * 0.1 Then  ' GFH 01/21/03
      libTireContactArea(IA) = DTemp
    End If

  Loop
  Close EFNo
  
  libNAC = IA
'  If FileFormat$ = "Format1" Then Call WriteExternalFile    ' GFH 01/21/03
  If Not WorkingInAircraftWindow Then
    Call WriteExternalFile  ' Always update.
  End If
'  Call WriteExternalFile  ' Always update.
  
  Debug.Print "Number of aircraft in library = "; IA; " Maximum allowed = "; MaxLibAC
  
  Exit Sub
   
RExternalFileError:
  IErr = Err
  If IErr = 62 Then
    IA = IA - 1
    Exit Sub
  End If
  Ret = FileErrors(IErr, FileName$)
  If Ret = 0 Then Resume 0
  If Ret = 3 Then
    S$ = "Error # " & Format(IErr, "0") & " occurred reading" & vbCrLf
    S$ = S$ & "file " & FileName$ & "." & NL2
    S$ = S$ & "It may have been caused by a corrupted file or by" & vbCrLf
    S$ = S$ & "a file with incorrect format. Please check the file." & NL2
    S$ = S$ & "If the error occurred during startup, try loading" & vbCrLf
    S$ = S$ & "another file or create a new file from scratch."
    Ret = MsgBox(S$, 0, "File Error")
  End If
  Close EFNo
  Exit Sub

End Sub

Sub WriteExternalFile()
  
  Dim IA As Integer, J As Integer, IErr As Integer, S$
  Dim FileName$, EFNo As Integer, I As Integer, IStart As Integer, IEnd As Integer
  On Error GoTo WExternalFileError
  
  FileName$ = ExtFilePath$ & ExternalAircraftFileName$ & ".Ext"
  If Dir(FileName$) <> "" Then Kill (FileName$)  ' GFH 01/21/03

  EFNo = FreeFile
  Open FileName$ For Output As EFNo Len = 1024
    
  If FileFormat$ <> ExternalFileFormat$ Then
  
    S$ = "This line, and all lines up to, but not including, the Start Data marker" & vbCrLf
    S$ = S$ & "are for information and are not required. All other lines must be provided" & vbCrLf
    S$ = S$ & "in the given format, including the first line above this message and the" & vbCrLf
    S$ = S$ & "line with ""Start Data"" on it, or the file will not be read correctly." & vbCrLf
    S$ = S$ & "The routine which reads the file has very little error checking." & vbCrLf & vbCrLf
    
    S$ = S$ & "Y coordinate is longitudinal and X is transverse." & vbCrLf & vbCrLf
    
    S$ = S$ & "The fields below are required for each aircraft." & vbCrLf
    S$ = S$ & "All fields must contain valid data except where noted." & vbCrLf & vbCrLf
    
    S$ = S$ & "Aircraft Name" & vbCrLf
    S$ = S$ & "Gross Weight of Aircraft, lbs" & vbCrLf
    S$ = S$ & "Number of main gears" & vbCrLf
    S$ = S$ & "Percent of Gross Weight on all of the main gears" & vbCrLf
    S$ = S$ & "Number of tires on the evaluation gear (shown in the display), NTires" & vbCrLf
    S$ = S$ & "  TX TY (for NTires), two numbers in inches" & vbCrLf
    S$ = S$ & "Tire pressure, psi (used in ACN calculations)" & vbCrLf
    S$ = S$ & "Tire contact area, in^2 (used in thickness calculations)" & vbCrLf
    S$ = S$ & "For the X direction: (grid origin) (maximum grid dimension) (number of grid points), three numbers in inches" & vbCrLf
    S$ = S$ & "For the Y direction: (grid origin) (maximum grid dimension) (number of grid points), three numbers in inches" & vbCrLf
    S$ = S$ & "Data from the last two lines is only used when (number of grid points) is greater than zero." & vbCrLf
    S$ = S$ & "When this is true, the field values define the grid. Otherwise, a default grid is computed." & vbCrLf
    S$ = S$ & "The grid is used for flexible pavements only." & vbCrLf
    S$ = S$ & "Coverages." & vbCrLf
    S$ = S$ & vbCrLf & vbCrLf
  
  Else
  
    S$ = FileHeader$
    
  End If
  
  S$ = S$ & "Start Data"
    
  Print #EFNo, ExternalFileFormat$
  Print #EFNo, S$
 
  If WorkingInAircraftWindow Then
    IStart = ACWIAStart
    IEnd = ACWIAStart + ACWNAC - 1
  Else
    IStart = LibACGroup(ExternalLibraryIndex)
    IEnd = libNAC
  End If
  
  For IA = IStart To IEnd
    
'    Print #EFNo, Units$        ' GFH 01/21/03
    Print #EFNo, libACName$(IA)
    S$ = LPad$(12, Format$(libGL(IA), "0"))
    Call MakeDecimalPeriod(S$)
    Print #EFNo, S$
    S$ = LPad$(12, Format(libNMainGears(IA), "0"))
    Call MakeDecimalPeriod(S$)
    Print #EFNo, S$
    'ikawa 01/24/03
    S$ = LPad$(12, Format(libPcntOnMainGears(IA, ACN_mode), "0.000"))
    S$ = S$ & LPad$(12, Format(libPcntOnMainGears(IA, Thick_mode), "0.000"))
    Call MakeDecimalPeriod(S$)
    Print #EFNo, S$
    S$ = LPad$(12, Format(libNTires(IA), "0"))
    Call MakeDecimalPeriod(S$)
    Print #EFNo, S$
    For I = 1 To libNTires(IA)
'      S$ = LPad$(12, Format(libTY(IA, I), "0.000"))
'      S$ = S$ & LPad$(12, Format(libTX(IA, I), "0.000"))
      S$ = LPad$(12, Format(libTX(IA, I), "0.000"))        ' GFH 01/21/03 For compatibility with
      S$ = S$ & LPad$(12, Format(libTY(IA, I), "0.000"))   ' LEDFAA and BackC.
      Call MakeDecimalPeriod(S$)
      Print #EFNo, S$
    Next I
    
    S$ = LPad$(12, Format(libCP(IA), "0.000"))
    Call MakeDecimalPeriod(S$)
    Print #EFNo, S$
   
    S$ = LPad$(12, Format(libTireContactArea(IA), "0.000")) 'Izydor Kawa code
    Call MakeDecimalPeriod(S$)
    Print #EFNo, S$
    
    S$ = LPad$(12, Format(libXGridOrigin(IA), "0.000"))
    S$ = S$ & LPad$(12, Format(libXGridMax(IA), "0.000"))
    S$ = S$ & LPad$(12, Format(libXGridNPoints(IA), "0"))
    Call MakeDecimalPeriod(S$)
    Print #EFNo, S$
    S$ = LPad$(12, Format(libYGridOrigin(IA), "0.000"))
    S$ = S$ & LPad$(12, Format(libYGridMax(IA), "0.000"))
    S$ = S$ & LPad$(12, Format(libYGridNPoints(IA), "0"))
    Call MakeDecimalPeriod(S$)
    Print #EFNo, S$
'    S$ = LPad$(12, Format(libCoverages(IA), "0.000")) ' GFH 06-12-07.
    S$ = LPad$(12, Format(libAnnualDepartures(IA), "0.000"))
    Call MakeDecimalPeriod(S$)
    Print #EFNo, S$

  Next IA
  Close EFNo
  
  If Not WorkingInAircraftWindow Then
    Open FileName$ For Input As EFNo Len = 1024
    ExtFileText = "File Name = " & FileName$ & vbCrLf
    Do
      Line Input #EFNo, S$
      ExtFileText = ExtFileText & S$ & vbCrLf
    Loop Until EOF(EFNo)
    Close EFNo
  End If
  
  Exit Sub
      
WExternalFileError:

  IErr = Err
  Ret = FileErrors(IErr, FileName$)
  If Ret = 0 Then Resume 0
  If Ret = 3 Then
    S$ = "Error # " & Format(IErr, "0") & " occurred writing" & vbCrLf
    S$ = S$ & "file " & FileName$ & "."
    Ret = MsgBox(S$, 0, "File Error")
  End If
  Close EFNo
  Exit Sub

End Sub

 Public Sub UpdateLibraryData(IACpassed As Integer)

  Dim J As Integer, NX As Integer, NY As Integer
  Dim new_libIndex As Integer 'ikawa 02/13/03
  Dim IAC As Long ' GFH 2/6/04.
  
' libIndex is a global. When adding an aircraft to the list the new aircraft
' index is passed to UpdateLibraryData. The data for libIndex is passed to IAC.
  IAC = IACpassed ' GFH 2/6/04.
  
  libACName$(IAC) = JobTitle$
  libGL(IAC) = GrossWeight
  libNMainGears(IAC) = NMainGears
   
  'ikawa 02/13/03 begin
  ' Statements commented out by GFH 02/10/04.
  new_libIndex = LibACGroup(frmGear!lstACGroup.ListIndex + 1) + frmGear!lstLibFile.ListIndex
  
'  If ((libIndex = new_libIndex) And ACN_mode_true And (Not mode_changed)) _
'  Or ((libIndex = new_libIndex) And (Not ACN_mode_true) And (mode_changed)) _
'  Or ((libIndex <> new_libIndex) And (ACN_mode_true)) Then
  If ACN_mode_true Then
    libPcntOnMainGears(IAC, ACN_mode) = PcntOnMainGears
'    libPcntOnMainGears(IAC, Thick_mode) = libPcntOnMainGears(libIndex, Thick_mode)
    libCP(IAC) = TirePressure
'    libTireContactArea(IAC) = libTireContactArea(libIndex)
'    libCoverages(IAC) = StandardCoverages
  Else
    If SamePcntAndPress Then
      libPcntOnMainGears(IAC, ACN_mode) = PcntOnMainGears ' libPcntOnMainGears(libIndex, ACN_mode)
      libPcntOnMainGears(IAC, Thick_mode) = PcntOnMainGears
      'libCP(IAC) = libCP(libIndex)
      libTireContactArea(IAC) = TireContactArea
      libCP(IAC) = TirePressure
'      libTireContactArea(IAC) = libTireContactArea(libIndex)
'      libCoverages(IAC) = Coverages
      libAnnualDepartures(IAC) = AnnualDepartures
    Else
      libPcntOnMainGears(IAC, Thick_mode) = PcntOnMainGears
      libTireContactArea(IAC) = TireContactArea
'      libCoverages(IAC) = Coverages
      libAnnualDepartures(IAC) = AnnualDepartures
    End If
  End If
  
  mode_changed = False
  libNTires(IAC) = NWheels
       
  For J = 1 To libNTires(IAC)
    libTY(IAC, J) = XWheels(J)
    libTX(IAC, J) = YWheels(J)
  Next J

  If libXGridNPoints(IAC) <> 0 And libXGridNPoints(IAC) <> 0 Then
    NX = XGridNPoints:  NY = YGridNPoints
  Else
    NX = 0:             NY = 0
  End If
  
  libXGridOrigin(IAC) = XGridOrigin
  libXGridMax(IAC) = XGridMax
  libXGridNPoints(IAC) = NX
  libYGridOrigin(IAC) = YGridOrigin
  libYGridMax(IAC) = YGridMax
  libYGridNPoints(IAC) = NY

End Sub

Public Sub UpdateDataFromLibrary(IAC As Integer)

  Dim J As Integer, NX As Integer, NY As Integer
  
  JobTitle$ = libACName$(IAC)
  GrossWeight = libGL(IAC)
  NMainGears = libNMainGears(IAC)
  'ikawa 01/24/03
  If ACN_mode_true Then
    PcntOnMainGears = libPcntOnMainGears(IAC, ACN_mode)
    TirePressure = libCP(IAC)
    Coverages = StandardCoverages
  Else
    If SamePcntAndPress Then
      PcntOnMainGears = libPcntOnMainGears(IAC, ACN_mode)
      TirePressure = libCP(IAC)
'      Coverages = libCoverages(IAC)
      AnnualDepartures = libAnnualDepartures(IAC)
    Else
      PcntOnMainGears = libPcntOnMainGears(IAC, Thick_mode)
      TireContactArea = libTireContactArea(IAC)
'      Coverages = libCoverages(IAC)
      AnnualDepartures = libAnnualDepartures(IAC)
    End If
  End If
  NWheels = libNTires(IAC)
    
  For J = 1 To libNTires(IAC)
    XWheels(J) = libTY(IAC, J)
    YWheels(J) = libTX(IAC, J)
  Next J

  If libXGridNPoints(IAC) <> 0 And libXGridNPoints(IAC) <> 0 Then
    NX = XGridNPoints:  NY = YGridNPoints
  Else
    NX = 0:             NY = 0
  End If
  
'  TirePressure = libCP(IAC)
'  Coverages = libCoverages(IAC)
  XGridOrigin = libXGridOrigin(IAC)
  XGridMax = libXGridMax(IAC)
  XGridNPoints = libXGridNPoints(IAC)
  YGridOrigin = libYGridOrigin(IAC)
  YGridMax = libYGridMax(IAC)
  YGridNPoints = libYGridNPoints(IAC)
'  TireContactArea = libTireContactArea(IAC) 'ik033
  
'  RigidCutoff = StandardRigidCutoff ' Let the user control the cutoff value.

End Sub

