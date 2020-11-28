Attribute VB_Name = "Global"
Option Explicit

Declare Function HtmlHelp Lib "hhctrl.ocx" Alias "HtmlHelpA" (ByVal hwndCaller As Long, ByVal pszFile As String, ByVal uCommand As Long, ByVal dwData As Long) As Long

Public ACNOnly As Boolean, SavePCNOutputtoFile As Integer
Public WorkingInAircraftWindow As Boolean, ACWNAC As Long, ACWIAStart As Long
Public frmGearCaptionStart As String
Public FilePath$, FileName$, Units$, ExtFilePath$, AppPath$, FileFormat$
Public FirstFileRead As Boolean, ExternalLibraryIndex As Integer
Public Ret As Variant, S$
Public Const NL2$ = vbCrLf & vbCrLf
Public Const PI As Double = 3.14159265359

Public ComputingFlexible As Boolean
Public ComputingRigid    As Boolean
Public StopComputation   As Boolean

Public PCNFlexibleOutput   As String, PCNRigidOutput     As String ' Not used.
Public PCNOutputText       As String, ACNBatchOutputText As String
Public ThicknessOutputText As String, LifeOutputText     As String
Public MGWOutputText       As String, ExtFileText        As String

Public Const StandardCoverages        As Double = 10000
Public Coverages                      As Double
Public FlexibleCoverages              As Double
Public RigidCoverages                 As Double
Public AnnualDepartures               As Double
Public Const DefaultAnnualDepartures  As Double = 1200

Public Const StandardRigidCutoff      As Double = 5 ' Changed from 3 02/17/12 by GFH.
Public RigidCutoff                    As Double ' Radius of relative stiffness cutoff.
' Parameters for plotting the radius cutoff for the PCA computations.
' Set in Module ACNRigidBAS Sub WriteRigidOutputData().
Public PlotCutOffX As Double, PlotCutoffY As Double, PlotCutoffRad As Double
Public Const StandardConcreteStrength As Double = 650 'Izydor Kawa added code. GFH 700 to 650 01/17/07.
Public ConcreteFlexuralStrength       As Double
Public TireContactArea As Double 'ik03

Public JobTitle$, NWheels  As Integer
Public Const NSubs         As Integer = 4
Public Const NMaxWheels    As Integer = 56
Public XWheels(NMaxWheels) As Single 'Double 'ikawa
Public YWheels(NMaxWheels) As Single 'Double 'ikawa
Public XGridOrigin         As Double, XGridMax        As Double, XGridNPoints As Double
Public YGridOrigin         As Double, YGridMax        As Double, YGridNPoints As Double
Public GrossWeight         As Double, TirePressure    As Double
Public PcntOnMainGears     As Double, NMainGears      As Double
Public AlphaFactor         As Double, AlternateAlpha  As Double
Public WheelRadius         As Double, InputAlpha      As Double
Public InputCBR            As Double, InputkValue     As Double
Public EvalThick           As Double, CriticalACIndex As Long
Public CriticalACTotalEquivCovs() As Double
Public MaxGrossWeight()    As Double
Public ACNrtn()            As Double, ACNInputACrtn() As Double

Public GrossWeightRow              As Integer, TirePressureRow          As Integer
Public PcntOnMainGearsRow          As Integer, NMainGearsRow            As Integer
Public InputAlphaRow               As Integer, AlphaFactorRow           As Integer
Public FlexibleCoveragesRow        As Integer, RigidCoveragesRow        As Integer
Public AnnualDeparturesRow         As Integer, PtoTCRow                 As Integer
'Public FlexibleAnnualDeparturesRow As Integer, RigidAnnualDeparturesRow As Integer
Public NWheelsRow                  As Integer, RigidCutoffRow           As Integer
Public FlexStrengthOfConcRow       As Integer 'Izydor Kawa added code

Public Const NSubgrades           As Integer = 4
Public ACNFlex(NSubgrades)        As Double, ACNRigid(NSubgrades)    As Double
Public ACNFlexCBR(NSubgrades)     As Double, ACNRigidk(NSubgrades)   As Double
Public CBRThickness(NSubgrades)   As Double
Public RigidThickness(NSubgrades) As Double, RigidStress(NSubgrades) As Double

Public ACNFlexibleOutputText$, ACNRigidOutputText$

Public Const XINCH  As Double = 2.54           ' inches to cm
Public Const XPRES  As Double = 145.0377438    ' Mpa to psi
Public Const XPOUND As Double = 2.2046225      ' kg to lb

Public NotShowACNGraph As Boolean, CancelChangeAircraft As Boolean
  
Declare Function OSWinHelp% Lib "USER32" Alias "WinHelpA" (ByVal hwnd&, ByVal HelpFile$, ByVal wCommand%, dwData As Any)

Type SYSTEM_INFO
  dwOemID As Long
  dwPageSize As Long
  lpMinimumApplicationAddress As Long
  lpMaximumApplicationAddress As Long
  dwActiveProcessorMask As Long
  dwNumberOrfProcessors As Long
  dwProcessorType As Long
  dwAllocationGranularity As Long
  dwReserved As Long
End Type
Declare Sub GetSystemInfo Lib "kernel32" (lpSystemInfo As SYSTEM_INFO)

Type TMemoryStatus
  iLength As Long        ' sizeof(MEMORYSTATUS)
  iMemoryLoad As Long    ' percent of memory in use
  iTotalPhys As Long     ' bytes of physical memory
  iAvailPhys As Long     ' free physical memory bytes
  iTotalPageFile As Long ' bytes of paging file
  iAvailPageFile As Long ' free bytes of paging file
  iTotalVirtual As Long  ' user bytes of address space
  iAvailVirtual As Long  ' free user bytes
End Type

Declare Sub GlobalMemoryStatus Lib "kernel32" (lpmem As TMemoryStatus)

'Izydor Kawa added code Begin
Public Type UnitsConversion
  Name As String
  Metric As Boolean
  inch As Double
  inchName As String
  inchFormat As String
  squareInch As Double
  squareInchName As String
  squareInchFormat As String
  pounds As Double
  poundsName As String
  poundsFormat As String
  psi As Double
  psiName As String
  psiFormat As String
  psiMPa As Double
  psiMPaName As String
  psiMPaFormat As String
  pci As Double
  pciName As String
  pciFormat As String
  covFormat As String
End Type

Public UnitsOut As UnitsConversion
'Izydor Kawa added code End

Public Enum SymmetryType
  XYSymmetry = 1
  XSymmetry = 2
  YSymmetry = 3
  NoSymmetry = 4
End Enum

Public Symmetry As Integer

Type ACLibrary
  ACName As String
  GL As Double
  NMainGears As Long
  PcntOnMainGears(1 To 2) As Double
  NTires As Long
  TY(1 To MaxNTires) As Double
  TX(1 To MaxNTires) As Double
  CP As Double
  TireContactArea As Double
  XGridOrigin As Double
  XGridMax As Double
  XGridNPoints As Double
  YGridOrigin As Double
  YGridMax As Double
  YGridNPoints As Double
  AnnualDepartures As Double
End Type


Function GetInputSingle(Prompt$, Title$, SVS As Double) As Boolean
' Get variant input from an InputBox and check for valid number.
' Returns SVS as a double (precision) number.
' Returns True if valid number. Allows commas and periods.
  Dim SV As Variant, S$
  SV = InputBox(Prompt$, Title$)
  If SV = "" Then
    GetInputSingle = False
  ElseIf Not IsNumeric(SV) Then
    S$ = SV & " was entered." & vbCrLf & "It is not a valid number."
    S$ = S$ & vbCrLf & vbCrLf & "Please retry."
    Ret = MsgBox(S$, 0, "Incorrect Data Entry")
    GetInputSingle = False
  Else
    SVS = SV    ' Get rid of string elements (commas).
    GetInputSingle = True
  End If
End Function

Public Function StripDirPath(S$) As String

  Dim I As Long, IP As Long, L As Long

  IP = 0
  L = Len(S$)
  For I = 1 To L
    If Mid$(S$, I, 1) = "\" Then IP = I
  Next I
  
  StripDirPath = Right(S$, L - IP)

End Function

Public Function LPad$(N, SS$)
' Adds leading spaces to variant string SS to make it N characters long.
' Used to format output to a file. #### characters in a Format function
' do not force spaces like QuickBasic.
' Typically, SS = Format(XX, "0.00")
  Dim ITemp As Integer
  ITemp = Len(SS)
  If N - ITemp < 1 Then N = ITemp '+ 1
  LPad$ = Space$(N - ITemp) & SS
End Function

Public Function RPad$(N, SS$)
' Adds traiing spaces to variant string SS to make it N characters long.
' Used to format output to a file. #### characters in a Format function
' do not force spaces like QuickBasic.
' Typically, SS = Format(XX, "0.00")
  Dim ITemp As Integer
  ITemp = Len(SS)
  If N - ITemp < 1 Then N = ITemp '+ 1
  RPad$ = SS & Space$(N - ITemp)
End Function

Public Function CPad$(N As Long, SS$)
  Dim I As Long, II As Long
  I = Len(SS)
  If N - I < 1 Then N = I
  II = (N - I) \ 2
  If (N - I) Mod 2 = 0 Then I = II Else I = II + 1
  CPad$ = Space$(II) & SS & Space$(I)
End Function

Public Function ALOG10(X As Double) As Double
  Const Log10BaseE As Double = 2.30258509299405
  ALOG10 = Log(X) / Log10BaseE
End Function

Public Sub ReadDataFile()
  
  Dim DFNo As Integer, I As Integer
  Dim XINCH As Double, XPRES As Double
  Dim XPOUND As Double, Xcg As Double, Ycg As Double
  
' Keep global variables in English units (inch, lb, psi).
' Convert to Metric (cm, kg, kPa) in ICAO read routines.
  
  XINCH = 2.54          ' inches to cm
  XPRES = 145.0377438   ' Mpa to psi
  XPOUND = 2.2046225    ' kg to lb
  
  If Not FirstFileRead Then
    Ret = MsgBox("A file must be opened before running.", , "Run File Error")
    Exit Sub
  End If

  DFNo = FreeFile
  Open FilePath$ & FileName$ For Input As DFNo
  
  If EOF(DFNo) Then
    Close DFNo
    Exit Sub
  End If
 '    READ CURRENT TITLE CARD   (CARD TYPE '1')
  Line Input #DFNo, Units$
  Units$ = Trim$(Units$)
  Line Input #DFNo, SSS$   ' Info. line first.
  Line Input #DFNo, JobTitle$
  
  Line Input #DFNo, SSS$
  Input #DFNo, NWheels       ' Number of wheels, ACN only, MODE = 11 always.
 '                                       (CARD TYPE '3')
  Line Input #DFNo, SSS$
  For I = 1 To NWheels
    Input #DFNo, YWheels(I)              ' Wheel coordinates, lateral.
    If Units$ <> "English Units" Then
      YWheels(I) = YWheels(I) / XINCH
    End If
  Next I

  Line Input #DFNo, SSS$
  For I = 1 To NWheels
    Input #DFNo, XWheels(I)              ' Wheel coordinates, longitudinal.
    If Units$ <> "English Units" Then
      XWheels(I) = XWheels(I) / XINCH
    End If
  Next I

' READ IN GRID DISPLACEMENT,INCREMENT AND SIZE FOR X AND Y-AXIS
'                   (CARD TYPE '5')
' Only used for flexible ACNs.
'     READ(5,940)GX,DGX,XK,GY,DGY,YK
  
  Line Input #DFNo, SSS$
  Input #DFNo, YGridOrigin, YGridMax, YGridNPoints
  Line Input #DFNo, SSS$
  Input #DFNo, XGridOrigin, XGridMax, XGridNPoints
  
  If Units <> "English Units" Then
    XGridOrigin = XGridOrigin / XINCH:  XGridMax = XGridMax / XINCH
    YGridOrigin = YGridOrigin / XINCH: YGridMax = YGridMax / XINCH
  End If

' READ AIRCRAFT MASS, TYRE PRESS., Percent MASS ON MAIN GEAR, NO.OF LEGS
'                   (CARD TYPE '8')
  Line Input #DFNo, SSS$
  Input #DFNo, GrossWeight
  Line Input #DFNo, SSS$
  Input #DFNo, TirePressure
  Line Input #DFNo, SSS$
  Input #DFNo, PcntOnMainGears
  Line Input #DFNo, SSS$
  Input #DFNo, NMainGears
  Line Input #DFNo, SSS$
  Input #DFNo, InputAlpha
  If Units$ <> "English Units" Then
    GrossWeight = GrossWeight * XPOUND             ' Convert from kg to lb.
    TirePressure = (TirePressure * XPRES) / 1000   ' Convert PRSW from kPa to psi.
  End If
      
  Close DFNo
  
  Call GearCG(XWheels(), YWheels(), NWheels, Xcg, Ycg)
  
End Sub

Public Sub GearCG(XW() As Single, YW() As Single, N As Integer, Xcg As Double, Ycg As Double)

  Dim I As Integer, J As Integer
  Dim XRcg() As Double, YRcg() As Double
  Dim IXRcg() As Double, IYRcg() As Double
  Dim NXSymmetric As Integer, NYSymmetric As Integer
  Dim GridInterval As Double
  
  ReDim XRcg(N), YRcg(N), IXRcg(N), IYRcg(N)

' Added contact area option for thickness mode. GFH 02/10/04.
  If ACN_mode_true Or True Then
    WheelRadius = GrossWeight * PcntOnMainGears / (100 * NMainGears * NWheels)
    WheelRadius = Sqr(WheelRadius / TirePressure / PI)
  Else
    WheelRadius = Sqr(TireContactArea / PI)
  End If
  
  Xcg = 0:  Ycg = 0
  For I = 1 To N
    Xcg = Xcg + XW(I)
    Ycg = Ycg + YW(I)
  Next I
  Xcg = Xcg / N
  Ycg = Ycg / N
  
  If libXGridNPoints(libIndex) <> 0 And libYGridNPoints(libIndex) <> 0 Then
    Exit Sub
  End If
  
  For I = 1 To N
    XRcg(I) = XW(I) - Xcg
    YRcg(I) = YW(I) - Ycg
    IXRcg(I) = Fix(XRcg(I))     ' Test symmetry to the nearest inch.
    IYRcg(I) = Fix(YRcg(I))
  Next I
  
  NXSymmetric = 0:  NYSymmetric = 0
  For I = 1 To N
    For J = 1 To N
      ' Test symmetry about the X axis.
      If IXRcg(I) = IXRcg(J) And IYRcg(I) = -IYRcg(J) And I <> J Then
        NXSymmetric = NXSymmetric + 1
      End If
      ' Test symmetry about the Y axis.
      If IYRcg(I) = IYRcg(J) And IXRcg(I) = -IXRcg(J) And I <> J Then
        NYSymmetric = NYSymmetric + 1
      End If
    Next J
    ' Wheels on an axis are symmetric but not found above.
    If IYRcg(I) = 0 Then NXSymmetric = NXSymmetric + 1
    If IXRcg(I) = 0 Then NYSymmetric = NYSymmetric + 1
  Next I

  XGridOrigin = 1E+35: XGridMax = -1E+35
  YGridOrigin = 1E+35: YGridMax = -1E+35
  If NXSymmetric = N And NYSymmetric = N Then      ' Symmetric about both axes.
    Symmetry = XYSymmetry
    For I = 1 To N
      If XRcg(I) < XGridOrigin Then XGridOrigin = XRcg(I)
      If YRcg(I) < YGridOrigin Then YGridOrigin = YRcg(I)
    Next I
    XGridOrigin = XGridOrigin + Xcg
    XGridMax = Xcg
    YGridOrigin = YGridOrigin + Ycg
    YGridMax = Ycg
  ElseIf NXSymmetric = N And NYSymmetric < N Then  ' Symmetric about X axis.
    Symmetry = XSymmetry
    For I = 1 To N
      If XRcg(I) < XGridOrigin Then XGridOrigin = XRcg(I)
      If YRcg(I) < YGridOrigin Then YGridOrigin = YRcg(I)
      If XRcg(I) > XGridMax Then XGridMax = XRcg(I)
    Next I
    XGridOrigin = XGridOrigin + Xcg
    XGridMax = XGridMax + Xcg
    YGridOrigin = YGridOrigin + Ycg
    YGridMax = Ycg
  ElseIf NXSymmetric < N And NYSymmetric = N Then  ' Symmetric about Y axis.
    Symmetry = YSymmetry
    For I = 1 To N
      If XRcg(I) < XGridOrigin Then XGridOrigin = XRcg(I)
      If YRcg(I) < YGridOrigin Then YGridOrigin = YRcg(I)
      If YRcg(I) > YGridMax Then YGridMax = YRcg(I)
    Next I
    XGridOrigin = XGridOrigin + Xcg
    XGridMax = Xcg
    YGridOrigin = YGridOrigin + Ycg
    YGridMax = YGridMax + Ycg
  ElseIf NXSymmetric < N And NYSymmetric < N Then  ' No symmetry.
    Symmetry = NoSymmetry
    For I = 1 To N
      If XRcg(I) < XGridOrigin Then XGridOrigin = XRcg(I)
      If XRcg(I) > XGridMax Then XGridMax = XRcg(I)
      If YRcg(I) < YGridOrigin Then YGridOrigin = YRcg(I)
      If YRcg(I) > YGridMax Then YGridMax = YRcg(I)
    Next I
    XGridOrigin = XGridOrigin + Xcg
    XGridMax = XGridMax + Xcg
    YGridOrigin = YGridOrigin + Ycg
    YGridMax = YGridMax + Ycg
  Else                                             ' Two tires in the same place.
'    Error recovery here
  End If

  GridInterval = WheelRadius / 3
  XGridNPoints = CInt((XGridMax - XGridOrigin) / GridInterval)
  YGridNPoints = CInt((YGridMax - YGridOrigin) / GridInterval)
  
  I = 9 ' Changed from 3 to be compatible with Boeing. GFH 04/17/06.
  If XGridNPoints < I Then XGridNPoints = I
  If YGridNPoints < I Then YGridNPoints = I
  I = 35
  If XGridNPoints > I Then XGridNPoints = I
  If YGridNPoints > I Then YGridNPoints = I
  
End Sub

