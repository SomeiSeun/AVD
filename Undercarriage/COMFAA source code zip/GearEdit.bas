Attribute VB_Name = "GearEdit"
Option Explicit

  Dim CtoPmaxFlex As Double, CtoPmaxRigid As Double    ' Needed in ChangeAnnualDapartures and WriteParmGrid.
  Public PtoCFlex As Double, PtoCRigid As Double       ' Needed in ChangeAnnualDapartures and WriteParmGrid.
  Public PtoTC    As Double                            ' GFH 9/16/09. Int to Double 12/14/09.
  
  Public Const ACN_mode As Integer = 1      'ikawa 01/24/03
  Public Const Thick_mode As Integer = 2    'ikawa 01/24/03
  
  Public IWheelSelected        As Integer
  Public Const CoordResolution As Integer = 10
  
  Public Operation  As Integer, LastOperation As Integer
  Public LastXP     As Double, LastYP         As Double
  Public LastIWheel As Integer
  
  Public Const NoOperation       As Integer = 0
  Public Const MoveWheel         As Integer = 1
  Public Const AddWheel          As Integer = 2
  Public Const RemoveWheel       As Integer = 3
  Public Const SelectAWheel      As Integer = 4
  Public Const ChangeXCoordinate As Integer = 5
  Public Const ChangeYCoordinate As Integer = 6
  
  Public Const kPaTopsi As Double = 0.1450377438
  Public Const cmToin As Double = 0.3937008
  Public Const kgTolb As Double = 2.2046225
  
  Public EditWheels As Boolean  'Izydor Kawa added code
    
  Public ChangeDataRet As Integer
  
  Public Const MaxSectAC% = 20
  Global Const MaxLibGroups% = 10
  Global Const MaxLibAC% = 512    ' Total number of aircraft in library.
  Global Const MaxNEval% = 8      ' Maximum number of evaluation points
  Global Const MaxNTires% = 24    ' Maximum number of tires on eval. gear.
  Global Const MaxNTTrack% = 10   ' Maximum number of gear tracks (for CDF).

  Global ViewingAircraft  As Integer
  Global lstLibFileIndex  As Integer     ' See frmParameters.lstAircraft
  Global lstACGroupIndex  As Integer     ' See frmParameters.lstAircraft
  Global lstAircraftIndex As Integer     ' See frmParameters.lstAircraft

  Global ILibACGroup              As Integer
  Global NLibACGroups             As Integer
  Global LibACGroup(MaxLibGroups) As Integer
  Global LibACGroupName$(MaxLibGroups)

  Global libNAC                       As Integer        ' Number of aircraft in library list.
  Global NBelly                       As Integer
  Global Const BellyExt$ = " Belly"
  Global libACName$(MaxLibAC)
  Global libGL(MaxLibAC)               As Single
  Public libNMainGears(MaxLibAC)       As Single
  'Public libPcntOnMainGears(MaxLibAC) As Single    'ikawa 01/24/03
  Public libPcntOnMainGears(MaxLibAC, 2) As Single  'ikawa 01/24/03
  'Global libMGpcnt(MaxLibAC)          As Single    'ikawa 01/24/03
  Global libMGpcnt(MaxLibAC, 2)        As Single   'ikawa 01/24/03
  
  Global libNTires(MaxLibAC)           As Integer
  Global libTX(MaxLibAC, MaxNTires)    As Single
  Global libTY(MaxLibAC, MaxNTires)    As Single
  Global libCP(MaxLibAC)               As Single
  Global libNEVPTS(MaxLibAC)           As Integer
  Global libEVPTX(MaxLibAC, MaxNEval)  As Single
  Global libEVPTY(MaxLibAC, MaxNEval)  As Single
  Global libGear$(MaxLibAC)
  Global libNTTrack(MaxLibAC)          As Integer
  Global libIGear(MaxLibAC)            As Integer
  Global libTT(MaxLibAC)               As Single
  Global libTS(MaxLibAC)               As Single
  Global libTG(MaxLibAC)               As Single
  Global libB(MaxLibAC)                As Single
  Global libBF(MaxLibAC)               As Single ' Front, for large B-777 models. GFH 12-13-05.
  Global libBR(MaxLibAC)               As Single ' Rear, for large B-777 models. GFH 12-13-05.
  Global libXAC(MaxLibAC, MaxNTTrack)  As Single
  Public libAlpha(MaxLibAC)            As Double
  Public libCoverages(MaxLibAC)        As Double
  Public libAnnualDepartures(MaxLibAC) As Double
  Public libXGridOrigin(MaxLibAC)      As Double
  Public libYGridOrigin(MaxLibAC)      As Double
  Public libXGridMax(MaxLibAC)         As Double
  Public libYGridMax(MaxLibAC)         As Double
  Public libXGridNPoints(MaxLibAC)     As Double
  Public libYGridNPoints(MaxLibAC)     As Double
  
  Global libTireContactArea(MaxLibAC) As Double 'ik03

  Global libIndex      As Integer      ' Library index for load index (link).
  Global LI            As Integer      ' Temporary alias for LibIndex(I)

  Global NAC           As Integer      ' Number of aircraft in current section.
  Global ACName$(MaxSectAC)
  Global GL(MaxSectAC) As Single       ' Gross aircraft load for design.
  Global WT(MaxSectAC) As Single
  Global TW(MaxSectAC) As Single

  Global Const MinGLFraction! = 0.1, MaxGLFraction! = 10
  Public Const MaxEvalThickness As Double = 260 ' Set by limitation in the CBR module.
  Public Const MinEvalThickness As Double = 0.1


Public Sub ChangeTireContactArea(ValueChanged As Boolean)

  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear.lstLibFile.ListIndex ' Library index
  
  CurrentValue = TireContactArea
  LibValue = libCP(libIndex)     ' From library file.
  MinValue = GrossWeight * PcntOnMainGears / NWheels / NMainGears / 400 / 100
  MaxValue = GrossWeight * PcntOnMainGears / NWheels / NMainGears / 50 / 100
     

  S$ = "The current value of tire contact area for" & vbCrLf
  S$ = S$ & "this aircraft is "
  S$ = S$ & Format(CurrentValue * UnitsOut.squareInch, UnitsOut.squareInchFormat & " ") _
    & UnitsOut.squareInchName & "." & vbCrLf & vbCrLf  'modified by Izydor Kawa
  
  S$ = S$ & "Enter a new value in the range:"
  S$ = S$ & NL2 & Format(MinValue * UnitsOut.squareInch, UnitsOut.squareInchFormat) 'modified by Izydor Kawa
  
   S$ = S$ & " to " & Format(MaxValue * UnitsOut.squareInch, UnitsOut.squareInchFormat) & "." 'modified by Izydor Kawa
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Tire Contact Area"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS / UnitsOut.squareInch

'   Check to See if value is within range.
    If CSng(NewValue) < CSng(MinValue) Or CSng(MaxValue) < CSng(NewValue) Then
      NewValue = CurrentValue
      S$ = "Tire contact area cannot be less than "
      S$ = S$ & Format(MinValue * UnitsOut.squareInch, UnitsOut.squareInchFormat) & vbCrLf 'modified by Izydor Kawa
      
      
      S$ = S$ & "or greater than "
      S$ = S$ & Format(MaxValue * UnitsOut.squareInch, UnitsOut.squareInchFormat) & "." & NL2 'modified by Izydor Kawa
      
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    If ValueChanged Then                   'modified by Izydor Kawa
      TireContactArea = NewValue 'ikawa 02/17/03
      TirePressure = GrossWeight * PcntOnMainGears / NMainGears / NWheels / TireContactArea / 100 'ik0333
    End If

  End If


End Sub

Sub CoverageToPassCore(SigmaW As Double, TireWidth As Double, NWhls As Integer, YWhls() As Single, CtoPmax As Double, CtoPmaxPoint As Double)
  
' Calculate coverage-to-pass ratio. Modification of the CtoPPCC
' subroutine in CDF.BAS from LEDFAA. Pass-to-coverage is the reciprocal of CtoP.
' Offset = Coordinate of point where coverage-to-pass is required.
  
  Dim I As Long, IOFF As Long, NOFF As Long
  Dim aa As Double, BB As Double, AREA As Double, YOFF As Double
  Dim Offset As Double, OffsetInc As Double, CtoP As Double
  Dim LeftMostY As Double, RightMostY As Double
  
  LeftMostY = 1E+35
  RightMostY = -1E+35
  
  For I = 1 To NWhls
    If YWhls(I) < LeftMostY Then LeftMostY = YWhls(I)
    If YWhls(I) > RightMostY Then RightMostY = YWhls(I)
  Next I
  
  OffsetInc = SigmaW / 30 ' About one inch for standard wander of 30.435
  NOFF = (RightMostY - LeftMostY) / OffsetInc
    
  Offset = LeftMostY
  CtoPmax = 0
  For IOFF = 1 To NOFF + 1

    CtoP = 0!
    For I = 1 To NWhls   ' Do for each wheel.
      YOFF = Abs(YWhls(I) - Offset)
      aa = YOFF - TireWidth / 2!
      BB = YOFF + TireWidth / 2!
      AREA = GaussArea(aa, BB, SigmaW)
      CtoP = CtoP + AREA
    Next I
    If IOFF > 400 Then
      I = I
    End If
    If CtoP > CtoPmax Then
      CtoPmax = CtoP
      CtoPmaxPoint = Offset
    End If
    Offset = Offset + OffsetInc
    
  Next IOFF

End Sub

Public Sub SelectWheel(XW() As Single, YW() As Single, X As Double, Y As Double, MinNorm As Double, ISelected As Integer)

  Dim I As Integer, Norm As Double
  
  MinNorm = 1E+20
  For I = 1 To NWheels
    Norm = Sqr((XW(I) - X) ^ 2 + (YW(I) - Y) ^ 2)
    If Norm < MinNorm Then
      MinNorm = Norm
      ISelected = I
    End If
  Next I

End Sub

Sub GeneralAviation(IA As Integer)

' General aviation aircraft. Called in Sub InitAClib. GFH 10-30-09.
Dim IAStart As Long, IAEnd As Long

  IAStart = IA
  
  libACName$(IA) = "Single Wheel 2"
  libGL(IA) = 2000!:        libMGpcnt(IA, ACN_mode) = 1#
  libCP(IA) = 30#
  libGear$(IA) = "A"
  libIGear(IA) = 1
  libTT(IA) = 0:            libTS(IA) = 0
  libMGpcnt(IA, Thick_mode) = libMGpcnt(IA, ACN_mode)
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA)
  IA = IA + 1

  libACName$(IA) = "Single Wheel 5"
  libGL(IA) = 5000!:        libMGpcnt(IA, ACN_mode) = 1#
  libCP(IA) = 45#
  libGear$(IA) = "A"
  libIGear(IA) = 1
  libTT(IA) = 0:            libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Single Wheel 10"
  libGL(IA) = 10000!:       libMGpcnt(IA, ACN_mode) = 1#
  libCP(IA) = 50#
  libGear$(IA) = "A"
  libIGear(IA) = 1
  libTT(IA) = 0:            libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Single Wheel 12.5"
  libGL(IA) = 12500!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 50#
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 0:            libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Single Wheel 15"
  libGL(IA) = 15000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 50#
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 0:            libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Single Wheel 20"
  libGL(IA) = 20000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 75#
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 0:            libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Single Wheel 25"
  libGL(IA) = 25000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 100#
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 0:            libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Single Wheel 30"
  libGL(IA) = 30000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 125#
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 0:            libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Single Wheel 35"
  libGL(IA) = 35000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 125#
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 0:            libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Single Wheel 40"
  libGL(IA) = 40000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 125#
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 0:            libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Dual Wheel 15"
  libGL(IA) = 15000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 55#
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 11:           libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Dual Wheel 20"
  libGL(IA) = 20000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 65#
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 12:           libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Dual Wheel 25"
  libGL(IA) = 25000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 75#
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 15:           libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Dual Wheel 30"
  libGL(IA) = 30000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 85#
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 15:           libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Dual Wheel 35"
  libGL(IA) = 35000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 90#
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 15:           libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Dual Wheel 40"
  libGL(IA) = 40000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 90#
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 15:           libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Aztec-D"
  libGL(IA) = 5200!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 46!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 136:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Baron-E-55"
  libGL(IA) = 5424!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 56!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 96:           libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "BeechJet-400"
  libGL(IA) = 15500!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 90!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 112:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "BeechJet-400A"
  libGL(IA) = 16300!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 105!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 112:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Bonanza-F-33A"
  libGL(IA) = 3412!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 40!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 115:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Canadair-CL-215"
  libGL(IA) = 33000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 177!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 207:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Centurion-210"
  libGL(IA) = 4100!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 50!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 102:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Challenger-CL-604"
  libGL(IA) = 48200!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 145!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 17.4:         libTS(IA) = 107.6
  IA = IA + 1

  libACName$(IA) = "Chancellor-414"
  libGL(IA) = 6200!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 62!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 175.5:        libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Chk.Arrow-PA-28-200"
  libGL(IA) = 2500!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 50!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 126:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Chk.Six-PA-32"
  libGL(IA) = 3400!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 50!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 127:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Citation-525"
  libGL(IA) = 10500!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 98!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 151:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Citation-550B"
  libGL(IA) = 15000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 130!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 157:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Citation-V"
  libGL(IA) = 16500!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 130!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 151:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Citation-VI/VII"
  libGL(IA) = 23200!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 168!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 9.75:         libTS(IA) = 103.26
  IA = IA + 1

  libACName$(IA) = "Citation-X"
  libGL(IA) = 36000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 189!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 12.25:        libTS(IA) = 114.76
  IA = IA + 1

  libACName$(IA) = "Conquest-441"
  libGL(IA) = 9925!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 95!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 168:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "DC-3"
  libGL(IA) = 26900!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 45!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 222:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Falcon-50"
  libGL(IA) = 38800!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 208!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 14:           libTS(IA) = 143
  IA = IA + 1

  libACName$(IA) = "Falcon-900"
  libGL(IA) = 45500!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 145!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 14:           libTS(IA) = 161
  IA = IA + 1

  libACName$(IA) = "Falcon-2000"
  libGL(IA) = 35000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 197!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 14:           libTS(IA) = 160
  IA = IA + 1
  
  libACName$(IA) = "Fokker-F-28-1000"
  libGL(IA) = 66500!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 96!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 22.8:         libTS(IA) = 175.6
  IA = IA + 1

  libACName$(IA) = "Fokker-F-28-2000"
  libGL(IA) = 65000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 97!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 22.8:         libTS(IA) = 175.6
  IA = IA + 1

  libACName$(IA) = "Fokker-F-28-4000"
  libGL(IA) = 73000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 105!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 22.8:         libTS(IA) = 175.6
  IA = IA + 1

  libACName$(IA) = "GrnCaravan-CE-208B"
  libGL(IA) = 8750!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 75!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 164:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Gulfstream-G-II"
  libGL(IA) = 66000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 160!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 15.75:        libTS(IA) = 148.26
  IA = IA + 1
  
  libACName$(IA) = "Gulfstream-G-III"
  libGL(IA) = 70200!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 175!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 15.75:        libTS(IA) = 148.26
  IA = IA + 1
  
  libACName$(IA) = "Gulfstream-G-IV"
  libGL(IA) = 75000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 185!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 15.75:        libTS(IA) = 148.26
  IA = IA + 1
  
  libACName$(IA) = "Gulfstream-G-V"
  libGL(IA) = 90900!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 188!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 18.5:         libTS(IA) = 153.5
  IA = IA + 1
  
  libACName$(IA) = "Hawker-800"
  libGL(IA) = 27520!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 135!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 13.3:         libTS(IA) = 96.7
  IA = IA + 1

  libACName$(IA) = "Hawker-800XP"
  libGL(IA) = 28120!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 135!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 13.3:         libTS(IA) = 96.7
  IA = IA + 1

  libACName$(IA) = "KingAir-B-100"
  libGL(IA) = 11500!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 52!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 11.58:        libTS(IA) = 180
  IA = IA + 1

  libACName$(IA) = "KingAir-C-90"
  libGL(IA) = 9710!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 58!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 153:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Learjet-35A/65A"
  libGL(IA) = 18000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 171!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 12:           libTS(IA) = 87
  IA = IA + 1

  libACName$(IA) = "Learjet-55"
  libGL(IA) = 21500!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 201!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 12:           libTS(IA) = 87
  IA = IA + 1

  libACName$(IA) = "Malibu-PA-46-350P"
  libGL(IA) = 4118!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 55!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 146:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Navajo-C"
  libGL(IA) = 6536!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 66!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 165:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "RegionalJet-200"
  libGL(IA) = 47450!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 177!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 11.56:        libTS(IA) = 113.4
  IA = IA + 1

  libACName$(IA) = "RegionalJet-700"
  libGL(IA) = 72500!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 183!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 21.6:         libTS(IA) = 140.4
  IA = IA + 1

  libACName$(IA) = "Sabreliner-40"
  libGL(IA) = 19035!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 185!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 86.52:        libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Sabreliner-60"
  libGL(IA) = 20372!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 214!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 86.52:        libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Sabreliner-65"
  libGL(IA) = 24000!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 159!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 86.52:        libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Sabreliner-80"
  libGL(IA) = 23500!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 185!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 11.5:         libTS(IA) = 77
  IA = IA + 1

  libACName$(IA) = "Sarat.PA-32R-301"
  libGL(IA) = 3616!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 38!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 133:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Seneca-II"
  libGL(IA) = 4570!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 55!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 133:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Shorts-330-200"
  libGL(IA) = 22900!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 79!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 167:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Shorts-360"
  libGL(IA) = 27200!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 78!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 167:          libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Skyhawk-172"
  libGL(IA) = 2558!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 50!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 86:           libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Skylane-1-82"
  libGL(IA) = 3110!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 50!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 96:           libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "Stationair-206"
  libGL(IA) = 3612!:        libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 52!
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 98:           libTS(IA) = 0
  IA = IA + 1

  libACName$(IA) = "SuperKingAir-300"
  libGL(IA) = 14100!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 92!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 11.58:        libTS(IA) = 194.42
  IA = IA + 1

  libACName$(IA) = "SuperKingAir-350"
  libGL(IA) = 15100!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 92!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 11.58:        libTS(IA) = 194.42
  IA = IA + 1

  libACName$(IA) = "SuperKingAir-B200"
  libGL(IA) = 12590!:       libMGpcnt(IA, ACN_mode) = 0.475
  libCP(IA) = 98!
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 11.58:        libTS(IA) = 194.42
  
  IAEnd = IA
  For IA = IAStart To IAEnd
    libMGpcnt(IA, Thick_mode) = libMGpcnt(IA, ACN_mode)
    libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA)
  Next IA
  IA = IAEnd

  IA = IA + 1

End Sub

Sub Airbus(IA As Integer)

' Airbus aircraft. Called in Sub InitAClib. GFH 03/27/12.
  Dim IAStart As Long, IAEnd As Long

  IAStart = IA
  
  libACName$(IA) = "A300-B2 SB"
  libGL(IA) = 315040.6
  libMGpcnt(IA, ACN_mode) = 0.47
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 185.65
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 35#:         libTS(IA) = 322.953
  libTG(IA) = 0!:          libB(IA) = 55#
  libTireContactArea(IA) = 207.47
  IA = IA + 1
  
  libACName$(IA) = "A300-B2 STD"
  libGL(IA) = 315040.6
  libMGpcnt(IA, ACN_mode) = 0.47
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 185.65
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 321.453
  libTG(IA) = 0!:           libB(IA) = 55#
  libTireContactArea(IA) = 207.47
  IA = IA + 1
  
  libACName$(IA) = "A300-B4 STD"
  libGL(IA) = 365746.9
  libMGpcnt(IA, ACN_mode) = 0.47
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 216.11
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 321.453
  libTG(IA) = 0!:           libB(IA) = 55
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A300-B4 LB"
  libGL(IA) = 365746.9
  libMGpcnt(IA, ACN_mode) = 0.47
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 168.24
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 38.5:         libTS(IA) = 319.453
  libTG(IA) = 0!:           libB(IA) = 60
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A300-600 STD"
  libGL(IA) = 380517.9
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 194.35
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 321.453
  libTG(IA) = 0!:           libB(IA) = 55
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A300-600 LB"
  libGL(IA) = 380517.9
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 194.35
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 38.5:         libTS(IA) = 319.453
  libTG(IA) = 0!:           libB(IA) = 60
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A310-200"
  libGL(IA) = 315040.6
  libMGpcnt(IA, ACN_mode) = 0.466
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 192.9
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 321.453
  libTG(IA) = 0!:           libB(IA) = 55
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
 
  libACName$(IA) = "A310-300"
  libGL(IA) = 315040.6
  libMGpcnt(IA, ACN_mode) = 0.472
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 187.1
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 321.453
  libTG(IA) = 0!:           libB(IA) = 55
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
 
  libACName$(IA) = "A318-100 std"
  libGL(IA) = 124340.7
  libMGpcnt(IA, ACN_mode) = 0.452
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 147.94
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 262.319
  libTG(IA) = 0!:           libB(IA) = 0
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
 
  libACName$(IA) = "A318-100 opt"
  libGL(IA) = 150796.2
  libMGpcnt(IA, ACN_mode) = 0.4458
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 179.85
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 262.319
  libTG(IA) = 0!:           libB(IA) = 0
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
 
  libACName$(IA) = "A319-100 std"
  libGL(IA) = 141977.7
  libMGpcnt(IA, ACN_mode) = 0.463
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 172.6
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 262.319
  libTG(IA) = 0!:           libB(IA) = 0
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
 
  libACName$(IA) = "A319-100 opt"
  libGL(IA) = 150796.2
  libMGpcnt(IA, ACN_mode) = 0.457
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 200.15
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 262.319
  libTG(IA) = 0!:           libB(IA) = 0
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
 
  libACName$(IA) = "A320-100"
  libGL(IA) = 150796.2
  libMGpcnt(IA, ACN_mode) = 0.47
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 200.15
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 262.319
  libTG(IA) = 0!:           libB(IA) = 0
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
 
  libACName$(IA) = "A320-200 Twin std"
  libGL(IA) = 162921.6
  libMGpcnt(IA, ACN_mode) = 0.469
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 200.15
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 262.319
  libTG(IA) = 0!:           libB(IA) = 0
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
 
  libACName$(IA) = "A320 Twin opt"
  libGL(IA) = 172842.4
  libMGpcnt(IA, ACN_mode) = 0.464
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 208.85
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 36.5:        libTS(IA) = 262.319
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A-320 Bogie"
  libGL(IA) = 162921.6
  libMGpcnt(IA, ACN_mode) = 0.469
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 176.95
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 30.7:         libTS(IA) = 268.119
  libTG(IA) = 0!:           libB(IA) = 39.5
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
     
  libACName$(IA) = "A321-100 std"
  libGL(IA) = 183865.5
  libMGpcnt(IA, ACN_mode) = 0.478
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 197.25
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 262.319
  libTG(IA) = 0!:           libB(IA) = 0
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
 
  libACName$(IA) = "A321-100 opt"
  libGL(IA) = 188274.8
  libMGpcnt(IA, ACN_mode) = 0.478
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 201.6
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 262.319
  libTG(IA) = 0!:           libB(IA) = 0
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
 
  libACName$(IA) = "A321-200 std"
  libGL(IA) = 197093.3
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 211.755
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 262.32
  libTG(IA) = 0!:           libB(IA) = 0
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
 
  libACName$(IA) = "A321-200 opt"
  libGL(IA) = 207014.1
  libMGpcnt(IA, ACN_mode) = 0.473
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 217.56
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 36.5:         libTS(IA) = 262.319
  libTG(IA) = 0!:           libB(IA) = 0
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
 
  libACName$(IA) = "A330-200 std"
  libGL(IA) = 509047.4
  libMGpcnt(IA, ACN_mode) = 0.474
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 205.954
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 365.5
  libTG(IA) = 0!:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "A330-200 opt"
  libGL(IA) = 515661.2
  libMGpcnt(IA, ACN_mode) = 0.4738
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 205.954
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 365.5
  libTG(IA) = 0!:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "A330-200 236.9t"
  libGL(IA) = 522275#
  libMGpcnt(IA, ACN_mode) = 0.93399 / 2!
  libMGpcnt(IA, Thick_mode) = 0.93399 / 2!
  libCP(IA) = 205.954
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 365.5
  libTG(IA) = 0!:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "A330-200 238.9t"
  libGL(IA) = 526684#
  libMGpcnt(IA, ACN_mode) = 0.92592 / 2!
  libMGpcnt(IA, Thick_mode) = 0.92592 / 2!
  libCP(IA) = 205.954
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 365.5
  libTG(IA) = 0!:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "A330-200FR 233.9t"
  libGL(IA) = 515661#
  libMGpcnt(IA, ACN_mode) = 0.94633 / 2#
  libMGpcnt(IA, Thick_mode) = 0.94633 / 2!
  libCP(IA) = 205.954
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 365.5
  libTG(IA) = 0!:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "A330-200FP 227.9t"
  libGL(IA) = 502434#
  libMGpcnt(IA, ACN_mode) = 0.94694 / 2#
  libMGpcnt(IA, Thick_mode) = 0.94694 / 2!
  libCP(IA) = 205.954
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 365.5
  libTG(IA) = 0!:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "A330-300 std"
  libGL(IA) = 509047.4
  libMGpcnt(IA, ACN_mode) = 0.4787
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 205.95
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 365.5
  libTG(IA) = 0!:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "A330-300 opt"
  libGL(IA) = 515661.2
  libMGpcnt(IA, ACN_mode) = 0.4785
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 210.3
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 365.5
  libTG(IA) = 0!:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "A330-300 235.9t"
  libGL(IA) = 520071
  libMGpcnt(IA, ACN_mode) = 0.94665 / 2!
  libMGpcnt(IA, Thick_mode) = 0.94665 / 2!
  libCP(IA) = 210.305
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 365.5
  libTG(IA) = 0!:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "A340-200 std"
  libGL(IA) = 568562.6
  libMGpcnt(IA, ACN_mode) = 0.4005
  libMGpcnt(IA, Thick_mode) = 0.78 / 2!
  libCP(IA) = 191.4
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 365.5
' libTG for belly gear aircraft is the wheel spacing for the belly gear.
' libTG is reset to 0 later.
  libTG(IA) = 38!:          libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-200 opt"
  libGL(IA) = 575176.4
  libMGpcnt(IA, ACN_mode) = 0.3999
  libMGpcnt(IA, Thick_mode) = 0.78 / 2!
  libCP(IA) = 191.4
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 365.5
' libTG for belly gear aircraft is the wheel spacing for the belly gear.
' libTG is reset to 0 later.
  libTG(IA) = 38!:          libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-300 std"
  libGL(IA) = 608245.1
  libMGpcnt(IA, ACN_mode) = 0.3979
  libMGpcnt(IA, Thick_mode) = 0.78 / 2!
  libCP(IA) = 206
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
' libTG for belly gear aircraft is the wheel spacing for the belly gear.
' libTG is reset to 0 later.
  libTG(IA) = 38!:         libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-300 opt"
  libGL(IA) = 611552
  libMGpcnt(IA, ACN_mode) = 0.3949
  libMGpcnt(IA, Thick_mode) = 0.78 / 2!
  libCP(IA) = 206
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
' libTG for belly gear aircraft is the wheel spacing for the belly gear.
' libTG is reset to 0 later.
  libTG(IA) = 38!:         libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-500 std" ' Has 2D belly gear.
  libGL(IA) = 369.2 ' tonnes = 813,946.7 lbs
  libMGpcnt(IA, ACN_mode) = 0.3196 ' 92.77% GL on main gear.
' Equation on next line from figure on 7-4-3, page 1, Oct 01/01 of A340-500/600 manual.
  libMGpcnt(IA, Thick_mode) = (0.864 * 0.95 - 59.932 / libGL(IA)) / 2 ' Wing Gear.
'                           = 0.3292 in this case.
  libGL(IA) = libGL(IA) * 2204.6225 ' Convert to lbs.
  libCP(IA) = 233
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
'  IA = IA + 1
  
  libACName$(IA) = "A340-500 opt" ' Has 2D belly gear.
  libGL(IA) = 381.2 ' tonnes = 840402.1 lbs
  libMGpcnt(IA, ACN_mode) = 0.313 ' 90.65% GL on main gear.
' Equation on next line from figure on 7-4-3, page 1, Oct 01/01 of A340-500/600 manual.
  libMGpcnt(IA, Thick_mode) = (0.864 * 0.95 - 59.932 / libGL(IA)) / 2 ' Wing Gear.
'                           = 0.3318 in this case.
  libGL(IA) = libGL(IA) * 2204.6225 ' Convert to lbs.
  libCP(IA) = 233
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
'  IA = IA + 1
  
  libACName$(IA) = "A340-600 std" ' Has 2D belly gear.
  libGL(IA) = 365.2 ' tonnes = 805128.2 lbs
  libMGpcnt(IA, ACN_mode) = 0.3221 ' 93.55% GL on main gear.
' Equation on next line from figure on 7-4-3, page 1, Oct 01/01 of A340-500/600 manual.
  libMGpcnt(IA, Thick_mode) = (0.864 * 0.95 - 59.932 / libGL(IA)) / 2 ' Wing Gear.
'                           = 0.3283 in this case.
  libGL(IA) = libGL(IA) * 2204.6225 ' Convert to lbs.
  libCP(IA) = 233
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
'  IA = IA + 1
  
  libACName$(IA) = "A340-600 opt" ' Has 2D belly gear.
  libGL(IA) = 381.2 ' tonnes = 840402.1 lbs
  libMGpcnt(IA, ACN_mode) = 0.3131 ' 90.67% GL on main gear.
' Equation on next line from figure on 7-4-3, page 1, Oct 01/01 of A340-500/600 manual.
  libMGpcnt(IA, Thick_mode) = (0.864 * 0.95 - 59.932 / libGL(IA)) / 2 ' Wing Gear.
'                           = 0.3318 in this case.
  libGL(IA) = libGL(IA) * 2204.6225 ' Convert to lbs.
  libCP(IA) = 233
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
'  IA = IA + 1
  
  libACName$(IA) = "A340-500 369.2t" ' Has 2D belly gear.
  libGL(IA) = 813947#
  libMGpcnt(IA, ACN_mode) = 0.63937 / 2!   ' Wing Gear.
  libMGpcnt(IA, Thick_mode) = 0.63937 / 2! ' Wing Gear.
  libCP(IA) = 233.511
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-500 373.2t" ' Has 2D belly gear.
  libGL(IA) = 822765#
  libMGpcnt(IA, ACN_mode) = 0.64082 / 2!     ' Wing Gear.
  libMGpcnt(IA, Thick_mode) = 0.64082 / 2!   ' Wing Gear.
  libCP(IA) = 233.511
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-500 375.2t" ' Has 2D belly gear.
  libGL(IA) = 827175#
  libMGpcnt(IA, ACN_mode) = 0.63814 / 2!     ' Wing Gear.
  libMGpcnt(IA, Thick_mode) = 0.63814 / 2!   ' Wing Gear.
  libCP(IA) = 233.511
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-500HGW 381.2t" ' Has 2D belly gear.
  libGL(IA) = 840402#
  libMGpcnt(IA, ACN_mode) = 0.62617 / 2!     ' Wing Gear.
  libMGpcnt(IA, Thick_mode) = 0.62617 / 2!   ' Wing Gear.
  libCP(IA) = 233.511
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-500HGW 373.2t" ' Has 2D belly gear.
  libGL(IA) = 822765#
  libMGpcnt(IA, ACN_mode) = 0.62829 / 2!     ' Wing Gear.
  libMGpcnt(IA, Thick_mode) = 0.62829 / 2!   ' Wing Gear.
  libCP(IA) = 233.511
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-600 366.2t" ' Has 2D belly gear.
  libGL(IA) = 807333#
  libMGpcnt(IA, ACN_mode) = 0.64438 / 2!     ' Wing Gear.
  libMGpcnt(IA, Thick_mode) = 0.64438 / 2!   ' Wing Gear.
  libCP(IA) = 233.511
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-600 369.2t" ' Has 2D belly gear.
  libGL(IA) = 813947#
  libMGpcnt(IA, ACN_mode) = 0.64447 / 2!     ' Wing Gear.
  libMGpcnt(IA, Thick_mode) = 0.64447 / 2!   ' Wing Gear.
  libCP(IA) = 233.511
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-600HGW 381.2t" ' Has 2D belly gear.
  libGL(IA) = 840402#
  libMGpcnt(IA, ACN_mode) = 0.62637 / 2!     ' Wing Gear.
  libMGpcnt(IA, Thick_mode) = 0.62637 / 2!   ' Wing Gear.
  libCP(IA) = 233.511
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A340-600HGW 366.2" ' Has 2D belly gear.
  libGL(IA) = 807333#
  libMGpcnt(IA, ACN_mode) = 0.63217 / 2!     ' Wing Gear.
  libMGpcnt(IA, Thick_mode) = 0.63217 / 2!   ' Wing Gear.
  libCP(IA) = 233.511
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 55!:         libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 78!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A350-900 Preliminary"
  libGL(IA) = 592823#
  libMGpcnt(IA, ACN_mode) = 0.93683 / 2!
  libMGpcnt(IA, Thick_mode) = 0.93683 / 2!
  libCP(IA) = 240.763
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 68.3!:       libTS(IA) = 365.5
  libTG(IA) = 0:           libB(IA) = 80.31
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "A380-800 Basic1 Body"
  libGL(IA) = 1234589
  libMGpcnt(IA, ACN_mode) = 0.9513 * 6 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 6 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -30.1:     libTY(IA, 1) = -66.9
    libTX(IA, 2) = 30.1:      libTY(IA, 2) = -66.9
    libTX(IA, 3) = -30.5:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 30.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -30.1:     libTY(IA, 5) = 66.9
    libTX(IA, 6) = 30.1:      libTY(IA, 6) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1

  libACName$(IA) = "A380-800 Basic1 Wing"
  libGL(IA) = 1234589
  libMGpcnt(IA, ACN_mode) = 0.9513 * 4 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 4 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  libNTires(IA) = 4
    libTX(IA, 1) = -26.55:     libTY(IA, 1) = 0
    libTX(IA, 2) = 26.55:      libTY(IA, 2) = 0
    libTX(IA, 3) = -26.55:     libTY(IA, 3) = 66.9
    libTX(IA, 4) = 26.55:      libTY(IA, 4) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1

  libACName$(IA) = "A380-800 Basic2 Body"
  libGL(IA) = 1254430
  libMGpcnt(IA, ACN_mode) = 0.9433 * 6 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 6 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -30.1:     libTY(IA, 1) = -66.9
    libTX(IA, 2) = 30.1:      libTY(IA, 2) = -66.9
    libTX(IA, 3) = -30.5:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 30.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -30.1:     libTY(IA, 5) = 66.9
    libTX(IA, 6) = 30.1:      libTY(IA, 6) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1

  libACName$(IA) = "A380-800 Basic2 Wing"
  libGL(IA) = 1254430
  libMGpcnt(IA, ACN_mode) = 0.9433 * 4 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 4 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  libNTires(IA) = 4
    libTX(IA, 1) = -26.55:     libTY(IA, 1) = 0
    libTX(IA, 2) = 26.55:      libTY(IA, 2) = 0
    libTX(IA, 3) = -26.55:     libTY(IA, 3) = 66.9
    libTX(IA, 4) = 26.55:      libTY(IA, 4) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1

  libACName$(IA) = "A380-800 WV001 Body"
  libGL(IA) = 1124357
  libMGpcnt(IA, ACN_mode) = 0.9513 * 6 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 6 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -30.1:     libTY(IA, 1) = -66.9
    libTX(IA, 2) = 30.1:      libTY(IA, 2) = -66.9
    libTX(IA, 3) = -30.5:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 30.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -30.1:     libTY(IA, 5) = 66.9
    libTX(IA, 6) = 30.1:      libTY(IA, 6) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1

  libACName$(IA) = "A380-800 WV001 Wing"
  libGL(IA) = 1124357
  libMGpcnt(IA, ACN_mode) = 0.9513 * 4 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 4 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  libNTires(IA) = 4
    libTX(IA, 1) = -26.55:     libTY(IA, 1) = 0
    libTX(IA, 2) = 26.55:      libTY(IA, 2) = 0
    libTX(IA, 3) = -26.55:     libTY(IA, 3) = 66.9
    libTX(IA, 4) = 26.55:      libTY(IA, 4) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1

  libACName$(IA) = "A380-800F Basic Body"
  libGL(IA) = 1300727
  libMGpcnt(IA, ACN_mode) = 0.9505 * 6 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 6 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -30.1:     libTY(IA, 1) = -66.9
    libTX(IA, 2) = 30.1:      libTY(IA, 2) = -66.9
    libTX(IA, 3) = -30.5:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 30.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -30.1:     libTY(IA, 5) = 66.9
    libTX(IA, 6) = 30.1:      libTY(IA, 6) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1

  libACName$(IA) = "A380-800F Basic Wing"
  libGL(IA) = 1300727
  libMGpcnt(IA, ACN_mode) = 0.9505 * 4 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 4 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  libNTires(IA) = 4
    libTX(IA, 1) = -26.55:     libTY(IA, 1) = 0
    libTX(IA, 2) = 26.55:      libTY(IA, 2) = 0
    libTX(IA, 3) = -26.55:     libTY(IA, 3) = 66.9
    libTX(IA, 4) = 26.55:      libTY(IA, 4) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1

  libACName$(IA) = "A380-800F WV001 Body"
  libGL(IA) = 1190496
  libMGpcnt(IA, ACN_mode) = 0.9513 * 6 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 6 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -30.1:     libTY(IA, 1) = -66.9
    libTX(IA, 2) = 30.1:      libTY(IA, 2) = -66.9
    libTX(IA, 3) = -30.5:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 30.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -30.1:     libTY(IA, 5) = 66.9
    libTX(IA, 6) = 30.1:      libTY(IA, 6) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1

  libACName$(IA) = "A380-800F WV001 Wing"
  libGL(IA) = 1190496
  libMGpcnt(IA, ACN_mode) = 0.9513 * 4 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 4 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  libNTires(IA) = 4
    libTX(IA, 1) = -26.55:     libTY(IA, 1) = 0
    libTX(IA, 2) = 26.55:      libTY(IA, 2) = 0
    libTX(IA, 3) = -26.55:     libTY(IA, 3) = 66.9
    libTX(IA, 4) = 26.55:      libTY(IA, 4) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1

  libACName$(IA) = "A380-800F WV002 Body"
  libGL(IA) = 1322774
  libMGpcnt(IA, ACN_mode) = 0.9503 * 6 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 6 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -30.1:     libTY(IA, 1) = -66.9
    libTX(IA, 2) = 30.1:      libTY(IA, 2) = -66.9
    libTX(IA, 3) = -30.5:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 30.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -30.1:     libTY(IA, 5) = 66.9
    libTX(IA, 6) = 30.1:      libTY(IA, 6) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1

  libACName$(IA) = "A380-800F WV002 Wing"
  libGL(IA) = 1322774
  libMGpcnt(IA, ACN_mode) = 0.9503 * 4 / 20
  libMGpcnt(IA, Thick_mode) = 0.95 * 4 / 20
  libCP(IA) = 218
  libGear$(IA) = "Z"
  libIGear(IA) = 3
'  libTT(IA) = 55!:         libTS(IA) = 404.5
'  libTG(IA) = 0!:          libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  libNTires(IA) = 4
    libTX(IA, 1) = -26.55:     libTY(IA, 1) = 0
    libTX(IA, 2) = 26.55:      libTY(IA, 2) = 0
    libTX(IA, 3) = -26.55:     libTY(IA, 3) = 66.9
    libTX(IA, 4) = 26.55:      libTY(IA, 4) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  'IA = IA + 1
  
  libACName$(IA) = "A380 (WLG) 562t"
  libGL(IA) = 1238998#
  libMGpcnt(IA, ACN_mode) = 0.3805 / 2#
  libMGpcnt(IA, Thick_mode) = 0.3805 / 2#
  libCP(IA) = 217.557
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  libNTires(IA) = 4
    libTX(IA, 1) = -26.575:     libTY(IA, 1) = 0
    libTX(IA, 2) = 26.575:      libTY(IA, 2) = 0
    libTX(IA, 3) = -26.575:     libTY(IA, 3) = 66.929
    libTX(IA, 4) = 26.575:      libTY(IA, 4) = 66.929
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1
  
  libACName$(IA) = "A380 (WLG) 512t"
  libGL(IA) = 1128767#
  libMGpcnt(IA, ACN_mode) = 0.3805 / 2#
  libMGpcnt(IA, Thick_mode) = 0.3805 / 2#
  libCP(IA) = 217.557
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  libNTires(IA) = 4
    libTX(IA, 1) = -26.575:     libTY(IA, 1) = 0
    libTX(IA, 2) = 26.575:      libTY(IA, 2) = 0
    libTX(IA, 3) = -26.575:     libTY(IA, 3) = 66.929
    libTX(IA, 4) = 26.575:      libTY(IA, 4) = 66.929
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1
  
  libACName$(IA) = "A380 (WLG) 571t"
  libGL(IA) = 1258840#
  libMGpcnt(IA, ACN_mode) = 0.37729 / 2#
  libMGpcnt(IA, Thick_mode) = 0.37729 / 2#
  libCP(IA) = 217.557
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  libNTires(IA) = 4
    libTX(IA, 1) = -26.575:     libTY(IA, 1) = 0
    libTX(IA, 2) = 26.575:      libTY(IA, 2) = 0
    libTX(IA, 3) = -26.575:     libTY(IA, 3) = 66.929
    libTX(IA, 4) = 26.575:      libTY(IA, 4) = 66.929
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1
  
  libACName$(IA) = "A380 (WLG) 492t"
  libGL(IA) = 1084675#
  libMGpcnt(IA, ACN_mode) = 0.3805 / 2#
  libMGpcnt(IA, Thick_mode) = 0.3805 / 2#
  libCP(IA) = 217.557
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  libNTires(IA) = 4
    libTX(IA, 1) = -26.575:     libTY(IA, 1) = 0
    libTX(IA, 2) = 26.575:      libTY(IA, 2) = 0
    libTX(IA, 3) = -26.575:     libTY(IA, 3) = 66.929
    libTX(IA, 4) = 26.575:      libTY(IA, 4) = 66.929
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1
  
  libACName$(IA) = "A380e (WLG) 575t"
  libGL(IA) = 1267658#
  libMGpcnt(IA, ACN_mode) = 0.37729 / 2#
  libMGpcnt(IA, Thick_mode) = 0.37729 / 2#
  libCP(IA) = 217.557
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  libNTires(IA) = 4
    libTX(IA, 1) = -26.575:     libTY(IA, 1) = 0
    libTX(IA, 2) = 26.575:      libTY(IA, 2) = 0
    libTX(IA, 3) = -26.575:     libTY(IA, 3) = 66.929
    libTX(IA, 4) = 26.575:      libTY(IA, 4) = 66.929
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1
  
  libACName$(IA) = "A380 (BLG) 562t"
  libGL(IA) = 1238998#
  libMGpcnt(IA, ACN_mode) = 0.57076 / 2#
  libMGpcnt(IA, Thick_mode) = 0.57076 / 2#
  libCP(IA) = 217.557
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -30.1:     libTY(IA, 1) = -66.9
    libTX(IA, 2) = 30.1:      libTY(IA, 2) = -66.9
    libTX(IA, 3) = -30.5:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 30.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -30.1:     libTY(IA, 5) = 66.9
    libTX(IA, 6) = 30.1:      libTY(IA, 6) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1

  libACName$(IA) = "A380 (BLG) 512t"
  libGL(IA) = 1128767#
  libMGpcnt(IA, ACN_mode) = 0.57076 / 2#
  libMGpcnt(IA, Thick_mode) = 0.57076 / 2#
  libCP(IA) = 217.557
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -30.1:     libTY(IA, 1) = -66.9
    libTX(IA, 2) = 30.1:      libTY(IA, 2) = -66.9
    libTX(IA, 3) = -30.5:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 30.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -30.1:     libTY(IA, 5) = 66.9
    libTX(IA, 6) = 30.1:      libTY(IA, 6) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1

  libACName$(IA) = "A380 (BLG) 571t"
  libGL(IA) = 1258840#
  libMGpcnt(IA, ACN_mode) = 0.56593 / 2#
  libMGpcnt(IA, Thick_mode) = 0.56593 / 2#
  libCP(IA) = 217.557
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -30.1:     libTY(IA, 1) = -66.9
    libTX(IA, 2) = 30.1:      libTY(IA, 2) = -66.9
    libTX(IA, 3) = -30.5:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 30.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -30.1:     libTY(IA, 5) = 66.9
    libTX(IA, 6) = 30.1:      libTY(IA, 6) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1
  
  libACName$(IA) = "A380 (BLG) 492t"
  libGL(IA) = 1084675#
  libMGpcnt(IA, ACN_mode) = 0.57076 / 2#
  libMGpcnt(IA, Thick_mode) = 0.57076 / 2#
  libCP(IA) = 217.557
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -30.1:     libTY(IA, 1) = -66.9
    libTX(IA, 2) = 30.1:      libTY(IA, 2) = -66.9
    libTX(IA, 3) = -30.5:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 30.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -30.1:     libTY(IA, 5) = 66.9
    libTX(IA, 6) = 30.1:      libTY(IA, 6) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1
  
  libACName$(IA) = "A380e (BLG) 575t"
  libGL(IA) = 1267658#
  libMGpcnt(IA, ACN_mode) = 0.56593 / 2#
  libMGpcnt(IA, Thick_mode) = 0.56593 / 2#
  libCP(IA) = 217.557
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -30.1:     libTY(IA, 1) = -66.9
    libTX(IA, 2) = 30.1:      libTY(IA, 2) = -66.9
    libTX(IA, 3) = -30.5:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 30.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -30.1:     libTY(IA, 5) = 66.9
    libTX(IA, 6) = 30.1:      libTY(IA, 6) = 66.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  
  IA = IA + 1
  
End Sub


Public Sub InitACLib()
  
' IG = aircraft group number.
' IA = aircraft number.
' NBelly = number of dual-wheel belly gear aircraft, like MD-11.
' The aircraft data is accessed by aircraft number, e.g.
' GL(I) = libGL(LibIndex(I))
' where I = index of aircraft within the current list
' and LibIndex(I) = IA
' Aircraft numbers within a group can be found using:
' StartGroupNo = LibACGroup(J):  EndGroupNo = LibACGroup(J + 1) - 1
' IA = StartGroupNo + IOffset - 1
' If IA > EndGroupNo Then NotInCurrentGroup
' where J = current group number = ILibACGroup
' IOffset = offset into current group.
' libNAC = number of aircraft in the library.
' NLibACGroups = number of aircraft groups in the library.

' GL = aircraft gross load (lb) (typically taxi weight).
' TX, TY = wheel coordinates on gear (in), TX = lateral, TY = forward.
' CP = contained (inflation) pressure (psi).
' NEVPTS = number of stress evaluation points.
' EVPTX, EVPTY = coordinates of stress evaluation points (in),
'                X = lateral, Y = forward.
' GEAR$ = military gear type designation.
' IGEAR = LEDNEW gear type designation.
' TT, TS, TG, B = gear dimensions (definitions vary with gear type).
' NTTRACK = number of wheel tracks.
' XAC = lateral coordinates of the wheel tracks.

  Dim I As Integer, IA As Integer, IG As Integer
  Dim C As Single, M As Single ' Linear equation.
  Dim Temp As Single, Temp1 As Single
  
  IA = 1
  IG = 1
  LibACGroup(IG) = IA:  LibACGroupName$(IG) = "Generic"

  libACName$(IA) = "SWL-50"
  libGL(IA) = 50000!
  libMGpcnt(IA, ACN_mode) = 1!
  libMGpcnt(IA, Thick_mode) = 1!
  libCP(IA) = 180!:
  libGear$(IA) = "A"
  libIGear(IA) = 1
  libTT(IA) = 0!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA)
  IA = IA + 1
  
  libACName$(IA) = "S-30"
  libGL(IA) = 30000!
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 75!:
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 150!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA)
  IA = IA + 1
  
  libACName$(IA) = "S-45"
  libGL(IA) = 45000!
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 90!:
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 150!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA)
  IA = IA + 1
  
  libACName$(IA) = "S-50"
  libGL(IA) = 50000!
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 95!:
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 150!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA)
  IA = IA + 1
  
  libACName$(IA) = "S-60"
  libGL(IA) = 60000!
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 105!:
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 150!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA)
  IA = IA + 1
  
  libACName$(IA) = "S-75"
  libGL(IA) = 75000!
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 120!:
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 150!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA)
  IA = IA + 1
  
  libACName$(IA) = "D-50"
  libGL(IA) = 50000!
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 80!:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 20!:          libTS(IA) = 205!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "D-75"
  libGL(IA) = 75000!
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 110!:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 21!:          libTS(IA) = 204!
  libTG(IA) = 0!:           libB(IA) = 0!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "D-100"
  libGL(IA) = 100000!
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 140!:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 23!:          libTS(IA) = 202!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "D-150"
  libGL(IA) = 150000!:
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 160!:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 30!:          libTS(IA) = 199!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "D-200"
  libGL(IA) = 200000!
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 200!:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 34!:          libTS(IA) = 195!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "2D-100"
  libGL(IA) = 100000!:
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 120!:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 20!:        libTS(IA) = 230!
  libTG(IA) = 0!:           libB(IA) = 45!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "2D-150"
  libGL(IA) = 150000!:
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 140!:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 20!:          libTS(IA) = 229!
  libTG(IA) = 0!:           libB(IA) = 45!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "2D-200":
  libGL(IA) = 200000!:
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 160!:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 21!:          libTS(IA) = 229!
  libTG(IA) = 0!:           libB(IA) = 46!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "2D-300":
  libGL(IA) = 300000!:
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 180!:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 26!:          libTS(IA) = 229!
  libTG(IA) = 0!:           libB(IA) = 51!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "2D-400":
  libGL(IA) = 400000!:
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 200!:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 30!:          libTS(IA) = 220!
  libTG(IA) = 0!:           libB(IA) = 55!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  IG = IG + 1
  LibACGroup(IG) = IA:  LibACGroupName$(IG) = "Airbus"

  Call Airbus(IA)

 
' 12/20/05 GFH changed Boeing library using data in Boeing table
' Airplane_Characteristics_for_Pavement_Programs_-_FAA_release.xls.

  IG = IG + 1
  LibACGroup(IG) = IA:  LibACGroupName$(IG) = "Boeing"

  libACName$(IA) = "B707-320C"
  libGL(IA) = 336000
  libMGpcnt(IA, ACN_mode) = 0.4673
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 180
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 34.6:        libTS(IA) = 250.9
  libTG(IA) = 0!:          libB(IA) = 56
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "B720B"
  libGL(IA) = 235000
  libMGpcnt(IA, ACN_mode) = 0.4638
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 145
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 32:          libTS(IA) = 247!
  libTG(IA) = 0!:           libB(IA) = 49
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "B717-200 HGW"
  libGL(IA) = 122000
  libMGpcnt(IA, ACN_mode) = 0.4721
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 164
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 26:          libTS(IA) = 179.1
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
  
  libACName$(IA) = "B727-100C Alternate"
  libGL(IA) = 170000
  libMGpcnt(IA, ACN_mode) = 0.4765
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 165
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 34:          libTS(IA) = 208
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
  
  libACName$(IA) = "Adv. B727-200 Basic"
  libGL(IA) = 185200
  libMGpcnt(IA, ACN_mode) = 0.48
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 148
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 34:          libTS(IA) = 208
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
  
  libACName$(IA) = "Adv. B727-200 Option"
  libGL(IA) = 210000
  libMGpcnt(IA, ACN_mode) = 0.4648
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 173
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 34:          libTS(IA) = 208
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
  
  libACName$(IA) = "B737-100"
  libGL(IA) = 111000
  libMGpcnt(IA, ACN_mode) = 0.4595
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 157
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 30.5:        libTS(IA) = 190.8
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "Adv. B737-200"
  libGL(IA) = 128600
  libMGpcnt(IA, ACN_mode) = 0.4596
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 182
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 30.5:        libTS(IA) = 190.8
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "Adv. B737-200 LP"
  libGL(IA) = 117500
  libMGpcnt(IA, ACN_mode) = 0.4638
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 96
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 30.5:        libTS(IA) = 190.8
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "B737-300"
  libGL(IA) = 140000
  libMGpcnt(IA, ACN_mode) = 0.4543
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 201
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 30.5:        libTS(IA) = 190.8
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "B737-400"
  libGL(IA) = 150500
  libMGpcnt(IA, ACN_mode) = 0.4691
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 185
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 30.5:        libTS(IA) = 190.8
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "B737-500"
  libGL(IA) = 134000
  libMGpcnt(IA, ACN_mode) = 0.4612
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 194
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 30.5:        libTS(IA) = 190.8
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "B737-600"
  libGL(IA) = 145000!:
  libMGpcnt(IA, ACN_mode) = 0.4583
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 205
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 34!:         libTS(IA) = 208
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "B737-700"
  libGL(IA) = 155000!:
  libMGpcnt(IA, ACN_mode) = 0.4585
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 205
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 34!:         libTS(IA) = 208
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "B737-800"
  libGL(IA) = 174700!:
  libMGpcnt(IA, ACN_mode) = 0.4678
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 205!:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 34!:        libTS(IA) = 208
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "B737-900 ER"
  libGL(IA) = 188200!:
  libMGpcnt(IA, ACN_mode) = 0.4729
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 220!:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 34!:        libTS(IA) = 225!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "B737 BBJ2"
  libGL(IA) = 174700!:
  libMGpcnt(IA, ACN_mode) = 0.4677
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 204!:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 34!:        libTS(IA) = 225!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "B747-100 SF"
  libGL(IA) = 738000
  libMGpcnt(IA, ACN_mode) = 0.2312
  libMGpcnt(IA, Thick_mode) = 0.95 / 4!
  libCP(IA) = 232
  libGear$(IA) = "J"
  libIGear(IA) = 4
  libTT(IA) = 44
  libTS(IA) = 98!
  libTG(IA) = 106!:         libB(IA) = 58
  libTireContactArea(IA) = 245# ' From -6D.
  IA = IA + 1
  
  libACName$(IA) = "B747-200B Combi Mixed"
  libGL(IA) = 836000
  libMGpcnt(IA, ACN_mode) = 0.2274
  libMGpcnt(IA, Thick_mode) = 0.95 / 4!
  libCP(IA) = 190
  libGear$(IA) = "J"
  libIGear(IA) = 4
  libTT(IA) = 44
  libTS(IA) = 98!
  libTG(IA) = 106!:         libB(IA) = 58
  libTireContactArea(IA) = 245# ' From -6D.
  IA = IA + 1
  
  libACName$(IA) = "B747-300 Combi Mixed"
  libGL(IA) = 836000
  libMGpcnt(IA, ACN_mode) = 0.2274
  libMGpcnt(IA, Thick_mode) = 0.95 / 4!
  libCP(IA) = 190
  libGear$(IA) = "J"
  libIGear(IA) = 4
  libTT(IA) = 44
  libTS(IA) = 98!
  libTG(IA) = 106!:         libB(IA) = 58
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "B747-400"
  libGL(IA) = 877000
  libMGpcnt(IA, ACN_mode) = 0.2333
  libMGpcnt(IA, Thick_mode) = 0.95 / 4!
  libCP(IA) = 200
  libGear$(IA) = "J"
  libIGear(IA) = 4
  libTT(IA) = 44:        libTS(IA) = 98!
  libTG(IA) = 106!:         libB(IA) = 58
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "B747-400ER"
  libGL(IA) = 913000
  libMGpcnt(IA, ACN_mode) = 0.234
  libMGpcnt(IA, Thick_mode) = 0.95 / 4!
  libCP(IA) = 230
  libGear$(IA) = "J"
  libIGear(IA) = 4
  libTT(IA) = 44:          libTS(IA) = 98!
  libTG(IA) = 106!:         libB(IA) = 58
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "B747-8"
  libGL(IA) = 990000
  libMGpcnt(IA, ACN_mode) = 0.23675
  libMGpcnt(IA, Thick_mode) = 0.95 / 4!
  libCP(IA) = 221
  libGear$(IA) = "J"
  libIGear(IA) = 4
  libTT(IA) = 46.8:         libTS(IA) = 84.5!
  libTG(IA) = 106.2:         libB(IA) = 56.5
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "B747-8F"
  libGL(IA) = 990000
  libMGpcnt(IA, ACN_mode) = 0.236
  libMGpcnt(IA, Thick_mode) = 0.95 / 4!
  libCP(IA) = 221
  libGear$(IA) = "J"
  libIGear(IA) = 4
  libTT(IA) = 46.8:         libTS(IA) = 84.5!
  libTG(IA) = 106.2:         libB(IA) = 56.5
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "B747-SP"
  libGL(IA) = 703000
  libMGpcnt(IA, ACN_mode) = 0.2192
  libMGpcnt(IA, Thick_mode) = 0.95 / 4!
  libCP(IA) = 205
  libGear$(IA) = "J"
  libIGear(IA) = 4
  libTT(IA) = 43.25:       libTS(IA) = 99.5!
  libTG(IA) = 106!:         libB(IA) = 54
  libTireContactArea(IA) = 210 ' From -6D.
  IA = IA + 1
  
  libACName$(IA) = "B757-200"
  libGL(IA) = 256000
  libMGpcnt(IA, ACN_mode) = 0.4559
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 183
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 34:          libTS(IA) = 271!
  libTG(IA) = 0!:           libB(IA) = 45
  libTireContactArea(IA) = 168.35 ' From -6D.
  IA = IA + 1

  libACName$(IA) = "B757-300"
  libGL(IA) = 271000
  libMGpcnt(IA, ACN_mode) = 0.4631
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 195
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 34:          libTS(IA) = 271!
  libTG(IA) = 0!:           libB(IA) = 45
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "B767-200"
  libGL(IA) = 317000
  libMGpcnt(IA, ACN_mode) = 0.4615
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 190
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 45:          libTS(IA) = 343.5!
  libTG(IA) = 0!:           libB(IA) = 56
  libTireContactArea(IA) = 202.46 ' From -6D.
  IA = IA + 1

  libACName$(IA) = "B767-200 ER"
  libGL(IA) = 396000
  libMGpcnt(IA, ACN_mode) = 0.4541
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 190
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 45:          libTS(IA) = 343.5
  libTG(IA) = 0!:           libB(IA) = 56
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "B767-300 ER"
  libGL(IA) = 413000
  libMGpcnt(IA, ACN_mode) = 0.462
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 200
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 45:          libTS(IA) = 343.5
  libTG(IA) = 0!:           libB(IA) = 56
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "B767-400 ER"
  libGL(IA) = 451000
  libMGpcnt(IA, ACN_mode) = 0.4697
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 215
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 45.8:        libTS(IA) = 343.1
  libTG(IA) = 0!:           libB(IA) = 54
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "B777-200 Baseline"
  libGL(IA) = 537000!:
  libMGpcnt(IA, ACN_mode) = 0.4771
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 185!:
  libGear$(IA) = "N"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 404.5
  libTG(IA) = 0!:           libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  IA = IA + 1

  libACName$(IA) = "B777-200 ER"
  libGL(IA) = 657000!:
  libMGpcnt(IA, ACN_mode) = 0.459
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 205!:
  libGear$(IA) = "N"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 404.5
  libTG(IA) = 0!:           libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  IA = IA + 1

  libACName$(IA) = "B777-200LR"
  libGL(IA) = 768800!:
  libMGpcnt(IA, ACN_mode) = 0.4584
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 218!:
  libGear$(IA) = "N"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 404.5
  libTG(IA) = 0!:           libBF(IA) = 57.2:  libBR(IA) = 58!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  IA = IA + 1

  libACName$(IA) = "B777-300 Baseline"
  libGL(IA) = 662000!:
  libMGpcnt(IA, ACN_mode) = 0.4742
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 215!
  libGear$(IA) = "N"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 404.5
  libTG(IA) = 0!:           libBF(IA) = 57!:  libBR(IA) = 57!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  IA = IA + 1

  libACName$(IA) = "B777-300 ER"
  libGL(IA) = 777000!:
  libMGpcnt(IA, ACN_mode) = 0.4622
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 221!:
  libGear$(IA) = "N"
  libIGear(IA) = 3
  libTT(IA) = 55!:          libTS(IA) = 404.5
  libTG(IA) = 0!:           libBF(IA) = 57.2:  libBR(IA) = 58!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  IA = IA + 1

  libACName$(IA) = "B787-8"
  libGL(IA) = 503500
  libMGpcnt(IA, ACN_mode) = 0.4565
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 228
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 51:           libTS(IA) = 386.4
  libTG(IA) = 0!:           libB(IA) = 57.5
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "B787-9 (Preliminary)"
  libGL(IA) = 555000
  libMGpcnt(IA, ACN_mode) = 0.46775
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 224
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 60#:        libTS(IA) = 387.4
  libTG(IA) = 0!:           libB(IA) = 59.5
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1 ' GFH 07-28-08. Revived 01-13-12.


' 12/20/05 GFH changed McDonnell Douglas library using data in Boeing table
' Airplane_Characteristics_for_Pavement_Programs_-_FAA_release.xls.

  IG = IG + 1
  LibACGroup(IG) = IA:  LibACGroupName$(IG) = "McDonnell Douglas"

  libACName$(IA) = "DC3"
  libGL(IA) = 11430 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.468
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 310 * kPaTopsi:
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 0!      'Missing  libTT(IA)  value
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 1
  IA = IA + 1

  libACName$(IA) = "DC4"
  libGL(IA) = 33113 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.468
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 530 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 74 * cmToin:      libTS(IA) = 0!      'Missing  libTS(IA)  value
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
  
  
  libACName$(IA) = "DC8-43"
  libGL(IA) = 318000
  libMGpcnt(IA, ACN_mode) = 0.4655
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 177
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 30:          libTS(IA) = 235!
  libTG(IA) = 0!:           libB(IA) = 55
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "DC8-63/73"
  libGL(IA) = 358000
  libMGpcnt(IA, ACN_mode) = 0.4806
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 196
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 32:          libTS(IA) = 234!
  libTG(IA) = 0!:           libB(IA) = 55
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

  libACName$(IA) = "DC9-32"
  libGL(IA) = 109000
  libMGpcnt(IA, ACN_mode) = 0.462
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 155
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 25:        libTS(IA) = 183.5!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "DC9-51"
  libGL(IA) = 122000
  libMGpcnt(IA, ACN_mode) = 0.4697
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 172
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 26:          libTS(IA) = 179!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "DC10-10"
  libGL(IA) = 458000
  libMGpcnt(IA, ACN_mode) = 0.4666
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 195
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 54:          libTS(IA) = 393!
  libTG(IA) = 0!:           libB(IA) = 64
  libTireContactArea(IA) = 294 ' From -6D.
  IA = IA + 1

  libACName$(IA) = "DC10-30/40"
  libGL(IA) = 583000
  libMGpcnt(IA, ACN_mode) = 0.3752
  libMGpcnt(IA, Thick_mode) = 0.78 / 2!
  libCP(IA) = 177
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 54:          libTS(IA) = 393!
  libTG(IA) = 37.5!:        libB(IA) = 64
  libTireContactArea(IA) = 331# ' From -6D.
  IA = IA + 1
  
  libACName$(IA) = "MD11ER"
  libGL(IA) = 633000
  libMGpcnt(IA, ACN_mode) = 0.3877
  libMGpcnt(IA, Thick_mode) = 0.78 / 2!
  libCP(IA) = 206
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 54:          libTS(IA) = 393!
  libTG(IA) = 37.5!:        libB(IA) = 64
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "MD83"
  libGL(IA) = 161000
  libMGpcnt(IA, ACN_mode) = 0.4738
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 195
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 28.125:      libTS(IA) = 186.1375!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

  libACName$(IA) = "MD90-30 ER"
  libGL(IA) = 168500
  libMGpcnt(IA, ACN_mode) = 0.4698
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 193
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 28.125!:      libTS(IA) = 186.1375!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1


  IG = IG + 1
  LibACGroup(IG) = IA:  LibACGroupName$(IG) = "Other Commercial"


  libACName$(IA) = "An-124"
  libGL(IA) = 877430:
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libNMainGears(IA) = 2:
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
  
  libTT(IA) = 39.4
  libB(IA) = 67.3
  libTS(IA) = 26 * 12 + 3 - libTT(IA)
  libTG(IA) = 0!:
  
  libNTires(IA) = 10
  
  libTX(IA, 1) = libTT(IA) / 2:            libTY(IA, 1) = 0!
  libTX(IA, 2) = -libTT(IA) / 2:           libTY(IA, 2) = 0!
  libTX(IA, 3) = libTT(IA) / 2:            libTY(IA, 3) = libB(IA)
  libTX(IA, 4) = -libTT(IA) / 2:           libTY(IA, 4) = libB(IA)
  libTX(IA, 5) = libTT(IA) / 2:            libTY(IA, 5) = 2 * libB(IA)
  libTX(IA, 6) = -libTT(IA) / 2:           libTY(IA, 6) = 2 * libB(IA)
  libTX(IA, 7) = libTT(IA) / 2:            libTY(IA, 7) = 3 * libB(IA)
  libTX(IA, 8) = -libTT(IA) / 2:           libTY(IA, 8) = 3 * libB(IA)
  libTX(IA, 9) = libTT(IA) / 2:            libTY(IA, 9) = 4 * libB(IA)
  libTX(IA, 10) = -libTT(IA) / 2:          libTY(IA, 10) = 4 * libB(IA)
  
  libCP(IA) = 149:
  
  
  libNEVPTS(IA) = 8
  libEVPTX(IA, 1) = libTT(IA) / 2:     libEVPTY(IA, 1) = 0!
  libEVPTX(IA, 2) = libTT(IA) / 2:     libEVPTY(IA, 2) = libB(IA)
  libEVPTX(IA, 3) = libTT(IA) / 2:     libEVPTY(IA, 3) = 2 * libB(IA)
  libEVPTX(IA, 4) = libTT(IA) / 2:     libEVPTY(IA, 4) = 3 * libB(IA)
  libEVPTX(IA, 5) = libTT(IA) / 2:     libEVPTY(IA, 5) = 4 * libB(IA)
  
  libEVPTX(IA, 6) = libTT(IA) / 3:     libEVPTY(IA, 6) = 2 * libB(IA)
  libEVPTX(IA, 7) = libTT(IA) / 4:     libEVPTY(IA, 7) = 2 * libB(IA)
  libEVPTX(IA, 8) = 0:                 libEVPTY(IA, 8) = 2 * libB(IA)
  
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  
  libNTTrack(IA) = 4
  libXAC(IA, 1) = libTS(IA) / 2: libXAC(IA, 2) = -libTS(IA) / 2
  libXAC(IA, 2) = (libTS(IA) / 2 + libTT(IA)): libXAC(IA, 2) = -(libTS(IA) / 2 + libTT(IA))

  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 10
  IA = IA + 1

  libACName$(IA) = "An-225"
  libGL(IA) = 1322750:
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libNMainGears(IA) = 2:
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
  libTT(IA) = 39.4
  libB(IA) = 67.3
  libTS(IA) = 29 * 12 - libTT(IA)
  libTG(IA) = 0!:
  
  libNTires(IA) = 14
  
  libTX(IA, 1) = libTT(IA) / 2:            libTY(IA, 1) = 0!
  libTX(IA, 2) = -libTT(IA) / 2:           libTY(IA, 2) = 0!
  libTX(IA, 3) = libTT(IA) / 2:            libTY(IA, 3) = libB(IA)
  libTX(IA, 4) = -libTT(IA) / 2:           libTY(IA, 4) = libB(IA)
  libTX(IA, 5) = libTT(IA) / 2:            libTY(IA, 5) = 2 * libB(IA)
  libTX(IA, 6) = -libTT(IA) / 2:           libTY(IA, 6) = 2 * libB(IA)
  libTX(IA, 7) = libTT(IA) / 2:            libTY(IA, 7) = 3 * libB(IA)
  libTX(IA, 8) = -libTT(IA) / 2:           libTY(IA, 8) = 3 * libB(IA)
  libTX(IA, 9) = libTT(IA) / 2:            libTY(IA, 9) = 4 * libB(IA)
  libTX(IA, 10) = -libTT(IA) / 2:          libTY(IA, 10) = 4 * libB(IA)
  libTX(IA, 11) = libTT(IA) / 2:          libTY(IA, 11) = 5 * libB(IA)
  libTX(IA, 12) = -libTT(IA) / 2:          libTY(IA, 12) = 5 * libB(IA)
  libTX(IA, 13) = libTT(IA) / 2:          libTY(IA, 13) = 6 * libB(IA)
  libTX(IA, 14) = -libTT(IA) / 2:          libTY(IA, 14) = 6 * libB(IA)
  
  libCP(IA) = 162:
  
  libNEVPTS(IA) = 8
  libEVPTX(IA, 1) = libTT(IA) / 2:     libEVPTY(IA, 1) = 0!
  libEVPTX(IA, 2) = libTT(IA) / 2:     libEVPTY(IA, 2) = libB(IA)
  libEVPTX(IA, 3) = libTT(IA) / 2:     libEVPTY(IA, 3) = 2 * libB(IA)
  libEVPTX(IA, 4) = libTT(IA) / 2:     libEVPTY(IA, 4) = 3 * libB(IA)
  libEVPTX(IA, 5) = libTT(IA) / 2:     libEVPTY(IA, 5) = 4 * libB(IA)
  
  libEVPTX(IA, 6) = libTT(IA) / 3:     libEVPTY(IA, 6) = 2 * libB(IA)
  libEVPTX(IA, 7) = libTT(IA) / 4:     libEVPTY(IA, 7) = 2 * libB(IA)
  libEVPTX(IA, 8) = 0:                 libEVPTY(IA, 8) = 2 * libB(IA)
    
  
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  
  libNTTrack(IA) = 4
  libXAC(IA, 1) = libTS(IA) / 2: libXAC(IA, 2) = -libTS(IA) / 2
  libXAC(IA, 2) = (libTS(IA) / 2 + libTT(IA)): libXAC(IA, 2) = -(libTS(IA) / 2 + libTT(IA))

  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 14
  IA = IA + 1


  libACName$(IA) = "BAe 146"
  libGL(IA) = 40600 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.471
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 880 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 71 * cmToin:        libTS(IA) = 160!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

' Kawa Begin
'(3) Dee Howard
  libACName$(IA) = "BAC 1-11 400"
  libGL(IA) = 39690 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 930 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 53 * cmToin:      libTS(IA) = 0!      'Missing  libTS(IA)  value
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

'(4) Dee Howard
  libACName$(IA) = "BAC 1-11 475"
  libGL(IA) = 44679 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 570 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 62 * cmToin:      libTS(IA) = 0!      'Missing  libTS(IA)  value
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
' Kawa End
  
' Kawa Begin
  '(6)
  libACName$(IA) = "Caravelle 10"
  libGL(IA) = 52000 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.461
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  'ikawa 01/24/03
    libNMainGears(IA) = 2:
    'ikawa 01/24/03
    libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
    libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
  libNTires(IA) = 4
    libTX(IA, 1) = -40 / 2 * cmToin: libTY(IA, 1) = 0!
    libTX(IA, 2) = 40 / 2 * cmToin:   libTY(IA, 2) = 0!
    libTX(IA, 3) = -45 / 2 * cmToin: libTY(IA, 3) = 107 * cmToin
    libTX(IA, 4) = 45 / 2 * cmToin:  libTY(IA, 4) = 107 * cmToin
  libCP(IA) = 1170 * kPaTopsi:
  libGear$(IA) = "Z"
  libIGear(IA) = 6
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
'(7)
  libACName$(IA) = "Caravelle 12"
  libGL(IA) = 55960 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.46
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  'ikawa 01/24/03
  libNMainGears(IA) = 2:
  'ikawa 01/24/03
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
  libNTires(IA) = 4
    libTX(IA, 1) = -41 / 2 * cmToin: libTY(IA, 1) = 0!
    libTX(IA, 2) = -38 / 2 * cmToin: libTY(IA, 2) = 107 * cmToin
    libTX(IA, 3) = 38 / 2 * cmToin:  libTY(IA, 3) = 107 * cmToin
    libTX(IA, 4) = 41 / 2 * cmToin:  libTY(IA, 4) = 0!
  libCP(IA) = 1080 * kPaTopsi:
  libGear$(IA) = "Z"
  libIGear(IA) = 6
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

'(8)
  libACName$(IA) = "Canadair CL 44"
  libGL(IA) = 95708 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  'ikawa 01/24/03
  libNMainGears(IA) = 2:
  'ikawa 01/24/03
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
  libNTires(IA) = 4
    libTX(IA, 1) = -76 / 2 * cmToin:   libTY(IA, 1) = 0!
    libTX(IA, 2) = 76 / 2 * cmToin:   libTY(IA, 2) = 0!
    libTX(IA, 3) = -51 / 2 * cmToin:  libTY(IA, 3) = 122 * cmToin
    libTX(IA, 4) = 51 / 2 * cmToin:    libTY(IA, 4) = 122 * cmToin
  libCP(IA) = 1120 * kPaTopsi:
  libGear$(IA) = "Z"
  libIGear(IA) = 6
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
' Kawa End
  
  libACName$(IA) = "Concorde"
  libGL(IA) = 185066 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.48
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 1260 * kPaTopsi:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 68 * cmToin:      libTS(IA) = 277.28
  libTG(IA) = 0!:           libB(IA) = 167 * cmToin
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
' Kawa Begin
'(9)
  libACName$(IA) = "CV 880M"
  libGL(IA) = 87770 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.466
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 1030 * kPaTopsi:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 55 * cmToin:        libTS(IA) = 0!   'Missing  libTS(IA)  value
  libTG(IA) = 0!:           libB(IA) = 114 * cmToin
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

'(10)
  libACName$(IA) = "CV 990"
  libGL(IA) = 115666 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.485
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 1280 * kPaTopsi:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 61 * cmToin:          libTS(IA) = 0!      'Missing  libTS(IA)  value
  libTG(IA) = 0!:           libB(IA) = 118 * cmToin
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
' Kawa End
  
' Kawa Begin
  '(15) Commercial
  libACName$(IA) = "Dash 7"
  libGL(IA) = 19867 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.468
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 740 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 42 * cmToin:      libTS(IA) = 265.5!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

'(16) Commercial
  libACName$(IA) = "F27 Friendship Mk500"
  libGL(IA) = 19777 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 540 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 45 * cmToin:      libTS(IA) = 265.3!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

'(17) Commercial
  libACName$(IA) = "F28 Friendship Mk1000LPT"
  libGL(IA) = 29484 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.463
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 580 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 58 * cmToin:      libTS(IA) = 211.2!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

'(18) Commercial
  libACName$(IA) = "F28 Friendship Mk1000HTP"
  libGL(IA) = 29484 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.463
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 690 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 55 * cmToin:       libTS(IA) = 212.3!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
'Kawa end

  libACName$(IA) = "Fokker 50 HTP"
  libGL(IA) = 20820 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.478
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 590 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 52 * cmToin:       libTS(IA) = 175.9
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

'Kawa begin
'(19) Commercial
  libACName$(IA) = "Fokker 100"
  libGL(IA) = 44680 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.478
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 980 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 59 * cmToin:      libTS(IA) = 174.8!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

'(20)
  libACName$(IA) = "HS125"
  libGL(IA) = 11340 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.455
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 830 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 32 * cmToin:      libTS(IA) = 0!      'Missing  libTS(IA)  value
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

'(21)
  libACName$(IA) = "HS748"
  libGL(IA) = 21092 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.436
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 590 * kPaTopsi:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 48 * cmToin:      libTS(IA) = 0!      'Missing  libTS(IA)  value
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1

'(22) Commercial
  libACName$(IA) = "IL62"
  libGL(IA) = 162600 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.47
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 1080 * kPaTopsi:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 80 * cmToin:        libTS(IA) = 207.5!
  libTG(IA) = 0!:           libB(IA) = 165 * cmToin
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
'(23) Commercial
  libACName$(IA) = "IL76T" ' (2Q)"
  libGL(IA) = 171000 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.47
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
'  libGL(IA) = 377000!:      libMGpcnt(IA,ACN_mode) = 0.47
'ikawa 01/24/03
  libNMainGears(IA) = 2:
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
'  libNMainGears(IA) = 2:    libPcntOnMainGears(IA) = libMGpcnt(IA,ACN_mode) * 200
  libNTires(IA) = 8
    libTX(IA, 1) = -103 * cmToin:   libTY(IA, 1) = 0!
    libTX(IA, 2) = -41 * cmToin:   libTY(IA, 2) = 0!
    libTX(IA, 3) = 41 * cmToin:    libTY(IA, 3) = 0!
    libTX(IA, 4) = 103 * cmToin:    libTY(IA, 4) = 0!
    libTX(IA, 5) = -103 * cmToin:   libTY(IA, 5) = 258 * cmToin
    libTX(IA, 6) = -41 * cmToin:   libTY(IA, 6) = 258 * cmToin
    libTX(IA, 7) = 41 * cmToin:    libTY(IA, 7) = 258 * cmToin
    libTX(IA, 8) = 103 * cmToin:    libTY(IA, 8) = 258 * cmToin
  libCP(IA) = 530 * kPaTopsi:
  libGear$(IA) = "X"
  libIGear(IA) = 6
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / libNTires(IA)
  IA = IA + 1

'(23) Commercial
  libACName$(IA) = "IL76T (Q2)"
  libGL(IA) = 171000 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.235
  libMGpcnt(IA, Thick_mode) = 0.95 / 4!
'  libGL(IA) = 377000!:      libMGpcnt(IA,ACN_mode) = 0.47
'ikawa 01/24/03
  libNMainGears(IA) = 4:
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200 * 2
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200 * 2
'  libNMainGears(IA) = 2:    libPcntOnMainGears(IA) = libMGpcnt(IA,ACN_mode) * 200
  libNTires(IA) = 4
    libTX(IA, 1) = -103 * cmToin:   libTY(IA, 1) = 0!
    libTX(IA, 2) = -41 * cmToin:   libTY(IA, 2) = 0!
    libTX(IA, 3) = 41 * cmToin:    libTY(IA, 3) = 0!
    libTX(IA, 4) = 103 * cmToin:    libTY(IA, 4) = 0!
  libCP(IA) = 530 * kPaTopsi:
  libGear$(IA) = "X"
  libIGear(IA) = 6
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / libNTires(IA)
'  IA = IA + 1

'(24) Commercial
  libACName$(IA) = "IL86"
  libGL(IA) = 211500 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.312
  libMGpcnt(IA, Thick_mode) = 0.95 / 3!
  'ikawa 01/24/03
  libNMainGears(IA) = 3:
  'ikawa 01/24/03
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 300
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 300
  libNTires(IA) = 4
    libTX(IA, 1) = -125 / 2 * cmToin: libTY(IA, 1) = 0!
    libTX(IA, 2) = -125 / 2 * cmToin: libTY(IA, 2) = 149 * cmToin
    libTX(IA, 3) = 125 / 2 * cmToin:  libTY(IA, 3) = 149 * cmToin
    libTX(IA, 4) = 125 / 2 * cmToin:  libTY(IA, 4) = 0!
  libCP(IA) = 880 * kPaTopsi:
  libGear$(IA) = "Z"
  libIGear(IA) = 6
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
'Kawa end
 
'Kawa begin
'(25)
  libACName$(IA) = "L-100-20"
  libGL(IA) = 70670 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.482
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  'ikawa 01/24/03
  libNMainGears(IA) = 2:
  'ikawa 01/24/03
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
  libNTires(IA) = 2
    libTX(IA, 1) = 0!:        libTY(IA, 1) = 0!
    libTX(IA, 2) = 0!:        libTY(IA, 2) = 154 * cmToin
  libCP(IA) = 720 * kPaTopsi:
  libNEVPTS(IA) = 4
    libEVPTX(IA, 1) = 0!:     libEVPTY(IA, 1) = 0!
    libEVPTX(IA, 2) = 0!:     libEVPTY(IA, 2) = 10.1!
    libEVPTX(IA, 3) = 0!:     libEVPTY(IA, 3) = 20.2!
    libEVPTX(IA, 4) = 0!:     libEVPTY(IA, 4) = 30.3!
  libGear$(IA) = "E"
  libIGear(IA) = 2
  libTT(IA) = 0!:         libTS(IA) = 0!      'Missing  libTS(IA)  value
  libTG(IA) = 0!:           libB(IA) = 60.6!
  libNTTrack(IA) = 2
    libXAC(IA, 1) = -86!:     libXAC(IA, 2) = 86!   '?????
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2
  IA = IA + 1
  
'(26)
  libACName$(IA) = "L-1011-1"
  libGL(IA) = 195952 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.474
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 1330 * kPaTopsi:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 132 * cmToin:          libTS(IA) = 0!      'Missing  libTS(IA)  value
  libTG(IA) = 0!:           libB(IA) = 178 * cmToin
  libTireContactArea(IA) = 285#
  IA = IA + 1
  
'(27)
  libACName$(IA) = "Trident 1E"
  libGL(IA) = 61160 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.46
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  'ikawa 01/24/03
  libNMainGears(IA) = 2:
  'ikawa 01/24/03
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
  libNTires(IA) = 4
    libTX(IA, 1) = -(94 / 2 + 32 / 2) * cmToin: libTY(IA, 1) = 0!
    libTX(IA, 2) = -(94 / 2 - 32 / 2) * cmToin:     libTY(IA, 2) = 0!
    libTX(IA, 3) = (94 / 2 - 32 / 2) * cmToin:      libTY(IA, 3) = 0!
    libTX(IA, 4) = (94 / 2 + 32 / 2) * cmToin:      libTY(IA, 4) = 0!
  libCP(IA) = 1030 * kPaTopsi
  libGear$(IA) = "Y"
  libIGear(IA) = 6
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
' Kawa End
  
' Kawa Begin
'(28)
  libACName$(IA) = "TU134A"
  libGL(IA) = 49000 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.456
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 830 * kPaTopsi:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 56 * cmToin:          libTS(IA) = 350!
  libTG(IA) = 0!:           libB(IA) = 99 * cmToin
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1

'(29)
  libACName$(IA) = "TU154B"
  libGL(IA) = 98000 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.451
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 930 * kPaTopsi:
'  libGear$(IA) = "N"
'  libIGear(IA) = 3
'  libTT(IA) = 24.4!:          libTS(IA) = 0!      'Missing  libTS(IA)  value
'  libTG(IA) = 0!:           libB(IA) = 38.6!
    
  'ikawa 01/24/03
  libNMainGears(IA) = 2:
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
  libNTires(IA) = 6
  
  libGear$(IA) = "Z"
  libIGear(IA) = 6
    libTX(IA, 1) = 0:           libTY(IA, 1) = 0
    libTX(IA, 2) = 62 * cmToin:  libTY(IA, 2) = 0
    libTX(IA, 3) = 0:            libTY(IA, 3) = 98 / 2.54
    libTX(IA, 4) = 62 * cmToin:   libTY(IA, 4) = 98 / 2.54
    libTX(IA, 5) = 0:             libTY(IA, 5) = 201 / 2.54
    libTX(IA, 6) = 62 * cmToin:    libTY(IA, 6) = 201 / 2.54
' modified by Izydor May 31, 2001
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  IA = IA + 1

'(30)
  libACName$(IA) = "VC10-1150"
  libGL(IA) = 151953 * kgTolb:
  libMGpcnt(IA, ACN_mode) = 0.483
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 1010 * kPaTopsi:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 86 * cmToin:        libTS(IA) = 223.1!
  libTG(IA) = 0!:                 libB(IA) = 155 * cmToin
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  IG = IG + 1
  LibACGroup(IG) = IA:  LibACGroupName$(IG) = "General Aviation" ' GFH 06-23-04.

  Call GeneralAviation(IA)

  IG = IG + 1
  LibACGroup(IG) = IA:  LibACGroupName$(IG) = "Military"

  libACName$(IA) = "A400M TLL1"
  libGL(IA) = 289687#
  libMGpcnt(IA, ACN_mode) = 0.94124 / 2#
  libMGpcnt(IA, Thick_mode) = 0.94124 / 2#
  libCP(IA) = 133#
  libGear$(IA) = "Z" ' Wheel coordinates are explicitly set here.
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -16.85:     libTY(IA, 1) = -61.5
    libTX(IA, 2) = 16.85:      libTY(IA, 2) = -61.5
    libTX(IA, 3) = -16.85:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 16.85:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -16.85:     libTY(IA, 5) = 61.9
    libTX(IA, 6) = 16.85:      libTY(IA, 6) = 61.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1
  
  libACName$(IA) = "A400M TLL2"
  libGL(IA) = 254413#
  libMGpcnt(IA, ACN_mode) = 0.94504 / 2#
  libMGpcnt(IA, Thick_mode) = 0.94504 / 2#
  libCP(IA) = 133#
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -16.85:     libTY(IA, 1) = -61.5
    libTX(IA, 2) = 16.85:      libTY(IA, 2) = -61.5
    libTX(IA, 3) = -16.85:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 16.85:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -16.85:     libTY(IA, 5) = 61.9
    libTX(IA, 6) = 16.85:      libTY(IA, 6) = 61.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1
  
  libACName$(IA) = "A400M LH"
  libGL(IA) = 311734#
  libMGpcnt(IA, ACN_mode) = 0.93868 / 2#
  libMGpcnt(IA, Thick_mode) = 0.93868 / 2#
  libCP(IA) = 133#
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -16.85:     libTY(IA, 1) = -61.5
    libTX(IA, 2) = 16.85:      libTY(IA, 2) = -61.5
    libTX(IA, 3) = -16.85:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 16.85:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -16.85:     libTY(IA, 5) = 61.9
    libTX(IA, 6) = 16.85:      libTY(IA, 6) = 61.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1
  
  libACName$(IA) = "A400M LN1"
  libGL(IA) = 304018#
  libMGpcnt(IA, ACN_mode) = 0.93954 / 2#
  libMGpcnt(IA, Thick_mode) = 0.93954 / 2#
  libCP(IA) = 133#
  libGear$(IA) = "Z"
  libIGear(IA) = 3
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  libNTires(IA) = 6
    libTX(IA, 1) = -16.85:     libTY(IA, 1) = -61.5
    libTX(IA, 2) = 16.85:      libTY(IA, 2) = -61.5
    libTX(IA, 3) = -16.85:     libTY(IA, 3) = 0!
    libTX(IA, 4) = 16.85:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -16.85:     libTY(IA, 5) = 61.9
    libTX(IA, 6) = 16.85:      libTY(IA, 6) = 61.9
  libNMainGears(IA) = 2
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
  IA = IA + 1
  
  libACName$(IA) = "C-5"
  libGL(IA) = 769000!:
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libNMainGears(IA) = 2:
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
  libNTires(IA) = 12
    libTX(IA, 1) = -60.5:     libTY(IA, 1) = 0!
    libTX(IA, 2) = -26.5:     libTY(IA, 2) = 0!
    libTX(IA, 3) = 26.5:      libTY(IA, 3) = 0!
    libTX(IA, 4) = 60.5:      libTY(IA, 4) = 0!
    libTX(IA, 5) = -24!:      libTY(IA, 5) = 65!
    libTX(IA, 6) = 24!:       libTY(IA, 6) = 65!
    libTX(IA, 7) = -60.5:     libTY(IA, 7) = 220!
    libTX(IA, 8) = -26.5:     libTY(IA, 8) = 220!
    libTX(IA, 9) = 26.5:      libTY(IA, 9) = 220!
    libTX(IA, 10) = 60.5:     libTY(IA, 10) = 220!
    libTX(IA, 11) = -24!:     libTY(IA, 11) = 285!
    libTX(IA, 12) = 24!:      libTY(IA, 12) = 285!
  libCP(IA) = 106!:
  libNEVPTS(IA) = 4
    libEVPTX(IA, 1) = 28.5:   libEVPTY(IA, 1) = 3!
    libEVPTX(IA, 2) = 26.5:   libEVPTY(IA, 2) = 0!
    libEVPTX(IA, 3) = 24.5:   libEVPTY(IA, 3) = 4!
    libEVPTX(IA, 4) = 24.5:   libEVPTY(IA, 4) = 8!
  libGear$(IA) = "K"
  libIGear(IA) = 4
  libTT(IA) = 34!:          libTS(IA) = 48!
  libTG(IA) = 189.5:        libB(IA) = 65!
   libNTTrack(IA) = 8
    libXAC(IA, 1) = -215.75:  libXAC(IA, 2) = -181.75
    libXAC(IA, 3) = -128.75:  libXAC(IA, 4) = -94.75
    libXAC(IA, 5) = 94.75:    libXAC(IA, 6) = 128.75
    libXAC(IA, 7) = 181.75:   libXAC(IA, 8) = 215.75
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 12
  IA = IA + 1
  
  libACName$(IA) = "C-17A"
  libGL(IA) = 585000!:
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libNMainGears(IA) = 2:
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
  libNTires(IA) = 6
  
  libTX(IA, 1) = -103 / 2.54:   libTY(IA, 1) = 0!
  libTX(IA, 2) = 0!:            libTY(IA, 2) = 0!
  libTX(IA, 3) = 108 / 2.54:    libTY(IA, 3) = 25 / 2.54
  libTX(IA, 4) = -103 / 2.54:   libTY(IA, 4) = 246 / 2.54
  libTX(IA, 5) = 0!:            libTY(IA, 5) = 246 / 2.54
  libTX(IA, 6) = 108 / 2.54:    libTY(IA, 6) = (246 + 25) / 2.54
        
  libCP(IA) = 138!:
  libNEVPTS(IA) = 7
    libEVPTX(IA, 1) = 0!:     libEVPTY(IA, 1) = 0!
    libEVPTX(IA, 2) = 0!:     libEVPTY(IA, 2) = 5!
    libEVPTX(IA, 3) = 0!:     libEVPTY(IA, 3) = 10!
    libEVPTX(IA, 4) = 0!:     libEVPTY(IA, 4) = 15!
    libEVPTX(IA, 5) = 0!:     libEVPTY(IA, 5) = 25!
    libEVPTX(IA, 6) = 0!:     libEVPTY(IA, 6) = 35!
    libEVPTX(IA, 7) = 0!:     libEVPTY(IA, 7) = 50!
  libGear$(IA) = "M"
  libIGear(IA) = 3
  libTT(IA) = 41.5:         libTS(IA) = 214.06
  libTG(IA) = 0!:           libB(IA) = 97!
  libNTTrack(IA) = 6
    libXAC(IA, 1) = -190.78:  libXAC(IA, 2) = -150.28
    libXAC(IA, 3) = -107.78:  libXAC(IA, 4) = 107.78
    libXAC(IA, 5) = 150.28:   libXAC(IA, 6) = 190.78
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 6
  IA = IA + 1
  
  libACName$(IA) = "C-123"
  libGL(IA) = 60000!:
  libMGpcnt(IA, ACN_mode) = 0.475!
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 100!:
  libGear$(IA) = "B"
  libIGear(IA) = 2
  libTT(IA) = 150!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 1
  IA = IA + 1

  libACName$(IA) = "C-130"
  libGL(IA) = 155000!:
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libNMainGears(IA) = 2:
  libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 200
  libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 200
  libNTires(IA) = 2
    libTX(IA, 1) = 0!:        libTY(IA, 1) = 0!
    libTX(IA, 2) = 0!:        libTY(IA, 2) = 60!
  libCP(IA) = 105!:
  libNEVPTS(IA) = 4
    libEVPTX(IA, 1) = 0!:     libEVPTY(IA, 1) = 0!
    libEVPTX(IA, 2) = 0!:     libEVPTY(IA, 2) = 10!
    libEVPTX(IA, 3) = 0!:     libEVPTY(IA, 3) = 20!
    libEVPTX(IA, 4) = 0!:     libEVPTY(IA, 4) = 30!
  libGear$(IA) = "E"
  libIGear(IA) = 2
  libTT(IA) = 172!:         libTS(IA) = 171!
  libTG(IA) = 0!:           libB(IA) = 60!
  libNTTrack(IA) = 2
    libXAC(IA, 1) = -86!:     libXAC(IA, 2) = 86!
  libTireContactArea(IA) = 350# ' GFH 07-28-08 in response to email from K. DeBord 05-18-06.
  IA = IA + 1

  libACName$(IA) = "C-141"
  libGL(IA) = 345000!:
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 190!:
  libGear$(IA) = "F"
  libIGear(IA) = 3
  libTT(IA) = 32.5!:          libTS(IA) = 177.5!
  libTG(IA) = 0!:             libB(IA) = 48!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "KC-10"
  libGL(IA) = 583000!:
  libMGpcnt(IA, ACN_mode) = 0.39
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 177!:
  libGear$(IA) = "H"
  libIGear(IA) = 3
  libTT(IA) = 54!:          libTS(IA) = 366!
  libTG(IA) = 37.5!:        libB(IA) = 64!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 4
  IA = IA + 1
  
  libACName$(IA) = "P-3"
  libGL(IA) = 142000!:
  libMGpcnt(IA, ACN_mode) = 0.475
  libMGpcnt(IA, Thick_mode) = 0.95 / 2!
  libCP(IA) = 190!:
  libGear$(IA) = "D"
  libIGear(IA) = 3
  libTT(IA) = 26!:          libTS(IA) = 348!
  libTireContactArea(IA) = libGL(IA) * libMGpcnt(IA, Thick_mode) / libCP(IA) / 2

  libNAC = IA
  NLibACGroups = IG
  NBelly = 0

' Set derived data where possible.

  For IA = 1 To libNAC
    
    If libGear$(IA) = "A" Or libGear$(IA) = "B" Then

      libNTires(IA) = 1
      libTX(IA, 1) = 0!:      libTY(IA, 1) = 0!
      libTS(IA) = 0!:         libTG(IA) = 0!
      libB(IA) = 0!
      If libGear$(IA) = "A" Then     ' 1 wheel, 1 gear.
        libNMainGears(IA) = 1
        'ikawa 01/24/03
        libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 100
        libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 100
        libNTTrack(IA) = 1
        libXAC(IA, 1) = 0!
      Else                           ' 1 wheel, 2 gears.
        libNMainGears(IA) = 2
        'ikawa 01/24/03
        libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
        libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
        libNTTrack(IA) = 2
        libXAC(IA, 1) = -libTT(IA) * 0.5
        libXAC(IA, 2) = -libXAC(IA, 1)
      End If
      libNEVPTS(IA) = 1
      libEVPTX(IA, 1) = 0!:   libEVPTY(IA, 1) = 0!
    
    ElseIf libGear$(IA) = "D" Then   ' Dual-wheel, 2 gears.

      libNTires(IA) = 2
      libTX(IA, 1) = -libTT(IA) * 0.5: libTY(IA, 1) = 0!
      libTX(IA, 2) = -libTX(IA, 1):    libTY(IA, 2) = 0!
      libTG(IA) = 0!:         libB(IA) = 0!
      libNMainGears(IA) = 2
      'ikawa 01/24/03
      libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
      libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
      libNTTrack(IA) = 4
        libXAC(IA, 1) = -libTS(IA) * 0.5 - libTT(IA)
        libXAC(IA, 2) = -libTS(IA) * 0.5
        libXAC(IA, 3) = -libXAC(IA, 2)
        libXAC(IA, 4) = -libXAC(IA, 1)
      libNEVPTS(IA) = 4
        libEVPTX(IA, 1) = libTT(IA) * 0.5
        libEVPTX(IA, 2) = libTT(IA) * 0.375
        libEVPTX(IA, 3) = libTT(IA) * 0.25
        libEVPTX(IA, 4) = 0!
      For I = 1 To libNEVPTS(IA)
        libEVPTY(IA, I) = 0!
      Next I

'      Dual-tandem, 2 gears; dual-tandem, 2 gears + 1 dual belly gear.
'      See after the current If block for belly gear data.
    ElseIf libGear$(IA) = "F" Or libGear$(IA) = "H" Then

      libNTires(IA) = 4
        libTX(IA, 1) = -libTT(IA) * 0.5: libTY(IA, 1) = 0!
        libTX(IA, 2) = libTT(IA) * 0.5: libTY(IA, 2) = 0!
        libTX(IA, 3) = libTX(IA, 1):    libTY(IA, 3) = libB(IA)
        libTX(IA, 4) = libTX(IA, 2):    libTY(IA, 4) = libB(IA)
      libNMainGears(IA) = 2
      'ikawa 01/24/03
      libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
      libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
      libNTTrack(IA) = 4
        libXAC(IA, 1) = -libTS(IA) * 0.5 - libTT(IA)
        libXAC(IA, 2) = -libTS(IA) * 0.5
        libXAC(IA, 3) = -libXAC(IA, 2)
        libXAC(IA, 4) = -libXAC(IA, 1)
      libNEVPTS(IA) = 8
        Temp = libTT(IA) * 0.5
        C = 0.5604 * libTT(IA) - 0.2637 * libB(IA)
        If C < 0! Then C = 0!
        M = -C / Temp
        libEVPTX(IA, 1) = Temp
        libEVPTY(IA, 1) = 0!
        libEVPTX(IA, 2) = Temp * 0.8
        libEVPTY(IA, 2) = C + M * libEVPTX(IA, 2)
        libEVPTX(IA, 3) = Temp * 0.6
        libEVPTY(IA, 3) = C + M * libEVPTX(IA, 3)
        libEVPTX(IA, 4) = Temp * 0.4
        libEVPTY(IA, 4) = C + M * libEVPTX(IA, 4)
        libEVPTX(IA, 5) = Temp * 0.2
        libEVPTY(IA, 5) = C + M * libEVPTX(IA, 5)
        libEVPTX(IA, 6) = 0!
        libEVPTY(IA, 6) = C
        libEVPTX(IA, 7) = 0!
        libEVPTY(IA, 7) = (libB(IA) * 0.5 - C) * 0.5 + C
        libEVPTX(IA, 8) = 0!
        libEVPTY(IA, 8) = libB(IA) * 0.5

    ElseIf libGear$(IA) = "J" Then  ' 747 configuration.
  
      libNTires(IA) = 4
        libTX(IA, 1) = -libTT(IA) * 0.5: libTY(IA, 1) = 0!
        libTX(IA, 2) = libTT(IA) * 0.5: libTY(IA, 2) = 0!
        libTX(IA, 3) = libTX(IA, 1):    libTY(IA, 3) = libB(IA)
        libTX(IA, 4) = libTX(IA, 2):    libTY(IA, 4) = libB(IA)
      libNMainGears(IA) = 4
      'ikawa 01/24/03
      libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 4 * 100
      libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 4 * 100
      libNTTrack(IA) = 8
        libXAC(IA, 1) = -libTG(IA) * 0.5 - 2! * libTT(IA) - libTS(IA)
        libXAC(IA, 2) = libXAC(IA, 1) + libTT(IA)
        libXAC(IA, 3) = libXAC(IA, 2) + libTS(IA)
        libXAC(IA, 4) = libXAC(IA, 3) + libTT(IA)
        libXAC(IA, 5) = -libXAC(IA, 4)
        libXAC(IA, 6) = -libXAC(IA, 3)
        libXAC(IA, 7) = -libXAC(IA, 2)
        libXAC(IA, 8) = -libXAC(IA, 1)
      libNEVPTS(IA) = 8
        Temp = libTT(IA) * 0.5
        C = 0.5604 * libTT(IA) - 0.2637 * libB(IA)
        If C < 0! Then C = 0!
        M = -C / Temp
        libEVPTX(IA, 1) = Temp
        libEVPTY(IA, 1) = 0!
        libEVPTX(IA, 2) = Temp * 0.8
        libEVPTY(IA, 2) = C + M * libEVPTX(IA, 2)
        libEVPTX(IA, 3) = Temp * 0.6
        libEVPTY(IA, 3) = C + M * libEVPTX(IA, 3)
        libEVPTX(IA, 4) = Temp * 0.4
        libEVPTY(IA, 4) = C + M * libEVPTX(IA, 4)
        libEVPTX(IA, 5) = Temp * 0.2
        libEVPTY(IA, 5) = C + M * libEVPTX(IA, 5)
        libEVPTX(IA, 6) = 0!
        libEVPTY(IA, 6) = C
        libEVPTX(IA, 7) = 0!
        libEVPTY(IA, 7) = (libB(IA) * 0.5 - C) * 0.5 + C
        libEVPTX(IA, 8) = 0!
        libEVPTY(IA, 8) = libB(IA) * 0.5

    ElseIf libGear$(IA) = "N" Then  ' 777 configuration.

      libNTires(IA) = 6
        Temp = libTT(IA) * 0.5:   Temp1 = libB(IA)
        libTX(IA, 1) = -Temp:     libTY(IA, 1) = -libBR(IA)
        libTX(IA, 2) = Temp:      libTY(IA, 2) = -libBR(IA)
        libTX(IA, 3) = -Temp:     libTY(IA, 3) = 0!
        libTX(IA, 4) = Temp:      libTY(IA, 4) = 0!
        libTX(IA, 5) = -Temp:     libTY(IA, 5) = libBF(IA)
        libTX(IA, 6) = Temp:      libTY(IA, 6) = libBF(IA)
      libNMainGears(IA) = 2
      'ikawa 01/24/03
      libPcntOnMainGears(IA, ACN_mode) = libMGpcnt(IA, ACN_mode) * 2 * 100
      libPcntOnMainGears(IA, Thick_mode) = libMGpcnt(IA, Thick_mode) * 2 * 100
      libNEVPTS(IA) = 6
        Temp = libTT(IA)
        libEVPTX(IA, 1) = Temp * 0.5:   libEVPTY(IA, 1) = 0!
        libEVPTX(IA, 2) = Temp * 0.4:   libEVPTY(IA, 2) = 0!
        libEVPTX(IA, 3) = Temp * 0.3:   libEVPTY(IA, 3) = 0!
        libEVPTX(IA, 4) = Temp * 0.2:   libEVPTY(IA, 4) = 0!
        libEVPTX(IA, 5) = Temp * 0.1:   libEVPTY(IA, 5) = 0!
        libEVPTX(IA, 6) = 0!:           libEVPTY(IA, 6) = 0!
      libNTTrack(IA) = 4
        libXAC(IA, 1) = -libTS(IA) * 0.5 - libTT(IA)
        libXAC(IA, 2) = -libTS(IA) * 0.5
        libXAC(IA, 3) = -libXAC(IA, 2)
        libXAC(IA, 4) = -libXAC(IA, 1)

    End If

    If libGear$(IA) = "H" Then  ' Set belly gear data.
      NBelly = NBelly + 1
      I = libNAC + NBelly
      libACName$(I) = libACName$(IA) & BellyExt$
      libGL(I) = libGL(IA)
      libMGpcnt(I, ACN_mode) = 0.95 - 2! * libMGpcnt(IA, ACN_mode)
      If libACName$(IA) = "DC-10-30" Or libACName$(IA) = "KC-10" Then
        libCP(I) = 153!
      ElseIf libACName$(IA) = "MD-11" Then
        libCP(I) = 180!
      Else
        libCP(I) = libCP(IA) * 2! * libMGpcnt(I, ACN_mode) / libMGpcnt(IA, ACN_mode)
      End If
      libGear$(I) = "HB"
      libIGear(I) = 2      ' Same as single-wheel, two gears, for coverage to pass.
      libTT(I) = libTG(IA):     libTS(I) = 0!
      libTG(IA) = 0!
      libTG(I) = 0!:            libB(I) = 0!
      libNTires(I) = 2
      libTX(I, 1) = -libTT(I) * 0.5: libTY(I, 1) = 0!
      libTX(I, 2) = -libTX(I, 1):    libTY(I, 2) = 0!
      libNTTrack(I) = 2
        libXAC(I, 1) = -libTT(I) * 0.5
        libXAC(I, 2) = libTT(I) * 0.5
      libNEVPTS(I) = 4
        libEVPTX(I, 1) = libTT(I) * 0.5:    libEVPTY(I, 1) = 0!
        libEVPTX(I, 2) = libTT(I) * 0.375:  libEVPTY(I, 2) = 0!
        libEVPTX(I, 3) = libTT(I) * 0.25:   libEVPTY(I, 3) = 0!
        libEVPTX(I, 4) = 0!:                libEVPTY(I, 4) = 0!
    End If

    libXGridOrigin(IA) = 0
    libXGridMax(IA) = 0
    libXGridNPoints(IA) = 0
    libAlpha(IA) = 0
'    libCoverages(IA) = StandardCoverages
    libAnnualDepartures(IA) = DefaultAnnualDepartures
  
  Next IA

  IA = libNAC + 1
  IG = NLibACGroups + 1
  ExternalLibraryIndex = IG
  LibACGroup(IG) = IA:  LibACGroupName$(IG) = "External Library"
  
  NLibACGroups = IG
  Call ReadExternalFile(libNAC)

  Const WriteAircraftLibraryWithTracksandEvals As Boolean = False
  Dim FNo As Integer
  If True Then 'WriteAircraftLibrary Then
  
    FileName$ = AppPath$ & "COMFAA Aircraft Data.txt"
    If WriteAircraftLibraryWithTracksandEvals Then
      FileName$ = AppPath$ & "COMFAA Aircraft All.txt"
    End If
    If Dir(FileName$) <> "" Then Kill FileName$
    FNo = FreeFile
    Open FileName$ For Output As FNo
    
    S$ = "Internal and external aircraft libraries for COMFAA," & vbCrLf
    If WriteAircraftLibraryWithTracksandEvals Then
      S$ = S$ & "with wheel-track and evaluation point data." & vbCrLf & vbCrLf
    Else
      S$ = S$ & "with base data only." & vbCrLf & vbCrLf
    End If
    S$ = S$ & "The format is as follows." & vbCrLf & vbCrLf
    S$ = S$ & "Aircraft Name" & vbCrLf
    S$ = S$ & "Gross Weight of Aircraft, lbs" & vbCrLf
    S$ = S$ & "Percent of Gross Weight on evaluation gear" & vbCrLf
    S$ = S$ & "tire pressure, psi" & vbCrLf
    S$ = S$ & "Gear ID letter, military designation" & vbCrLf
    S$ = S$ & "Gear ID number" & vbCrLf
    S$ = S$ & "TT, Dual Spacing, inches" & vbCrLf
    S$ = S$ & "TS, Gear track between inside wheels, inches" & vbCrLf
    S$ = S$ & "TG, Four-gear spacing, inches" & vbCrLf
    S$ = S$ & "B, Tandem spacing, inches" & vbCrLf
    S$ = S$ & "Number of tires on evaluation gear, NTires" & vbCrLf
    S$ = S$ & "  TX TY (for NTires) in inches" & vbCrLf
    If WriteAircraftLibraryWithTracksandEvals Then
      S$ = S$ & "Number of tire tracks, NTTrack" & vbCrLf
      S$ = S$ & "  XAC (for NTTracks) in inches" & vbCrLf
      S$ = S$ & "Number of response evaluation points, NEVPTS" & vbCrLf
      S$ = S$ & "  EVPTX EVPTY (for NEVPTS) in inches" & vbCrLf
    End If
    Print #FNo, S$
    
    For IA = 1 To libNAC
      Print #FNo, LPad(8, libACName$(IA))
      Print #FNo, LPad(8, Format(libGL(IA), "0"))
'      Print #FNo, LPad(12, Format(libMGpcnt(IA), "0.000")) ' GFH 06-23-04.
      Print #FNo, LPad(12, Format(libMGpcnt(IA, ACN_mode) * 100, "0.000")) ' GFH 06-23-04.
      Print #FNo, LPad(12, Format(libCP(IA), "0.000"))
      Print #FNo, LPad(8, libGear$(IA))
      Print #FNo, LPad(8, Format(libIGear(IA), "0"))
      Print #FNo, LPad(12, Format(libTT(IA), "0.000"))
      Print #FNo, LPad(12, Format(libTS(IA), "0.000"))
      Print #FNo, LPad(12, Format(libTG(IA), "0.000"))
      Print #FNo, LPad(12, Format(libB(IA), "0.000"))
      Print #FNo, libNTires(IA)
      For I = 1 To libNTires(IA)
        Print #FNo, LPad(12, Format(libTX(IA, I), "0.000")); LPad(12, Format(libTY(IA, I), "0.000"))
      Next I
      If WriteAircraftLibraryWithTracksandEvals Then
        Print #FNo, libNTTrack(IA)
        For I = 1 To libNTTrack(IA)
          Print #FNo, LPad(12, Format(libXAC(IA, I), "0.000"))
        Next I
        Print #FNo, libNEVPTS(IA)
        For I = 1 To libNEVPTS(IA)
          Print #FNo, LPad(12, Format(libEVPTX(IA, I), "0.000")); LPad(12, Format(libEVPTY(IA, I), "0.000"))
        Next I
      End If
    Next IA
  
  Close FNo
  End If


End Sub

Public Sub WriteOutputGrid()

  Dim I As Integer, J As Integer, K As Integer
  
  With frmGear!grdOutput
  
    .Redraw = False
    
    .Col = SGCol
    If ACN_mode_true Then
      .Row = 1: .Text = "D":  .Row = 2: .Text = "C"
      .Row = 3: .Text = "B":  .Row = 4: .Text = "A"
    Else
      .Row = 1: .Text = "":    .Row = 2: .Text = ""
      .Row = 3: .Text = "":    .Row = 4: .Text = ""
    End If
    
    For I = 1 To NSubgrades
    
      .Row = NSubgrades - I + 1
      .Col = CBRCol
      If ACN_mode_true Then
        If ACNFlexCBR(I) = 0 Then
          .Text = ""
        Else
          .Text = LPad(4, Format(ACNFlexCBR(NSubgrades - I + 1), "0.0")) ' GFH Reversed order 12/19/05.
        End If
      Else ' 02/11/04 GFH.
        If I = 1 Then
          .Text = LPad(5, Format(InputCBR, "0.00"))  ' Input CBR.
          .Text = Format(InputCBR, "0.00")  ' Input CBR.
        ElseIf I = 2 Then
          .Text = Format(ACNFlexCBR(1), "0.00") ' Value of CBR at end of iteration.
'          (InputCBR - ACNFlexCBR(1)) is the final iteration error.
          .Text = "" ' Remove to print CBR in grid.
        Else
          .Text = ""
        End If
      End If
      .Col = CBRtCol
'      If CBRThickness(I) = 0 Then .Text = "" Else .Text = Format(CBRThickness(I), "0.00")
      If CBRThickness(I) = 0 Then
        .Text = ""
      Else
        If UnitsOut.Metric Then J = 9 Else J = 7
        If ACN_mode_true Then K = NSubgrades - I + 1 Else K = I
        .Text = LPad(J, Format(CBRThickness(K) * UnitsOut.inch, UnitsOut.inchFormat))
        .Text = Format(CBRThickness(K) * UnitsOut.inch, UnitsOut.inchFormat)
'        .Text = Format(CBRThickness(K) * UnitsOut.inch, "0.00000")
      End If
      
      .Col = ACNFlexCol
      If ACN_mode_true Then
        K = NSubgrades - I + 1 ' Else K = I
        If ACNFlex(I) = 0 Then
          .Text = ""
        Else
          .Text = LPad(7, Format(ACNFlex(K), "0.0"))
          .Text = Format(ACNFlex(K), "0.0")
        End If
      Else
        .Text = ""
      End If
      
      .Col = kCol
      If ACNRigidk(I) = 0 Then
        .Text = ""
      Else
        If ACN_mode_true Then K = NSubgrades - I + 1 Else K = I
        .Text = LPad(7, Format(ACNRigidk(K) * UnitsOut.pci, UnitsOut.pciFormat))
'        .Text = Format(ACNRigidk(K) * UnitsOut.pci, UnitsOut.pciFormat)
      End If
      If Not ACN_mode_true And I = 1 Then ' GFH 06/08/04.
        .Text = LPad(9, Format(InputkValue * UnitsOut.pci, UnitsOut.pciFormat))
        .Text = Format(InputkValue * UnitsOut.pci, UnitsOut.pciFormat)
      End If
      
      .Col = RigtCol
      If RigidThickness(I) = 0 Then
        .Text = ""
      Else
        If UnitsOut.Metric Then J = 8 Else J = 6
        If ACN_mode_true Then K = NSubgrades - I + 1 Else K = I
        If Not Stress_mode Then 'ikawa seattle
          .Text = LPad(J, Format(RigidThickness(K) * UnitsOut.inch, UnitsOut.inchFormat))
          .Text = Format(RigidThickness(K) * UnitsOut.inch, UnitsOut.inchFormat)
'          .Text = Format(RigidThickness(K) * UnitsOut.inch, "0.00000")
        End If
      End If
      
      .Col = ACNRigCol
      If ACNRigid(I) = 0 Then
        .Text = ""
      Else
        If ACN_mode_true Then K = NSubgrades - I + 1 Else K = I
        .Text = LPad(7, Format(ACNRigid(K), "0.0"))
        .Text = Format(ACNRigid(K), "0.0")
      End If
      
    Next I
    .Redraw = True
  
  End With
'  DoEvents

End Sub

Public Sub WriteParmGrid()
  
  With frmGear.grdParms
    .Redraw = False
    .Col = 1
    .Row = GrossWeightRow:     .Text = Format(GrossWeight * UnitsOut.pounds, _
          UnitsOut.poundsFormat) 'modified by Izydor Kawa
    .Row = PcntOnMainGearsRow: .Text = Format(PcntOnMainGears, "0.00")
    .Row = NMainGearsRow:      .Text = Format(NMainGears, "0")
    .Row = NWheelsRow:         .Text = Format(NWheels, "0")

    If ACN_mode_true Or SamePcntAndPress Then
        .Row = TirePressureRow
        .Text = Format(TirePressure * UnitsOut.psi, UnitsOut.psiFormat) 'modified by Izydor Kawa
    Else
        .Row = TirePressureRow
        .Text = Format(TireContactArea * UnitsOut.squareInch, UnitsOut.squareInchFormat) 'modified by Izydor Kawa
    End If
    
    .Row = AlphaFactorRow:              .Text = Format(AlphaFactor, "0.000")
    If PtoTC = 0 Then PtoTC = 1 ' For startup initialization. GFH 9/16/09.
    .Row = PtoTCRow:                    .Text = Format(PtoTC, "0.00") ' GFH 9/16/09.
    If ACN_mode_true Then
      .Row = PtoTCRow:                  .Text = "Not Appl."
      .Row = AnnualDeparturesRow:       .Text = "Not Appl."
      .Row = FlexibleCoveragesRow:      .Text = Format(StandardCoverages, "#,###,##0")
      .Row = RigidCoveragesRow:         .Text = Format(StandardCoverages, "#,###,##0")
    Else
      .Row = PtoTCRow:                  .Text = Format(PtoTC, "0.00") ' GFH 9/16/09.
      .Row = AnnualDeparturesRow:       .Text = Format(AnnualDepartures, "#,###,##0")
      .Row = FlexibleCoveragesRow:      .Text = Format(FlexibleCoverages, "#,###,##0")
      .Row = RigidCoveragesRow:         .Text = Format(RigidCoverages, "#,###,##0")
    End If
    .Row = RigidCutoffRow:              .Text = Format(RigidCutoff, "0.00")
    If PtoCFlex <> 0 And PtoCRigid <> 0 Then  ' Only zero before first aircraft selected.
      .Col = 0
      .Row = FlexibleCoveragesRow:      .Text = " Flex 20yr Covs, P/C = " & Format(PtoCFlex, "0.00")
      .Row = RigidCoveragesRow:         .Text = " Rig 20yr Covs,  P/C = " & Format(PtoCRigid, "0.00")
    End If

    If ACNOnly Then
        Call MainSetGrids
      Else
        If Not ACN_mode_true Then ' GFH 11/27/06.
        Call MainSetGrids
        .Col = 1
        .Row = FlexStrengthOfConcRow
        .Text = Format(ConcreteFlexuralStrength * UnitsOut.psi, UnitsOut.psiFormat)
      End If 'ik02
    End If

    .Redraw = True
  End With
  
  DoEvents
  
End Sub

Sub CoverageToPass()

' Added by GFH 04/18/06.
' Calculate coverage-to-pass ratio. Modification of the CtoPPCC
' subroutine in CDF.BAS from LEDFAA. Pass-to-coverage is the
' reciprocal of CtoP.

' Annual departures calculation added by GFH 11/29/06.

' Called by frmGear.lstLibFile when reading new aircraft data.
' Called by frmGear.grdParms_Click when Changing parameters.
' Called by frmGear.picGear_MouseDown and _MouseUp when editing gear configuration.
  
  Dim I As Long, J As Long, K As Long, IG As Long
  Dim S$
  Dim Offset As Double, SigmaW As Double
'  Dim CtoPmaxFlex As Double, CtoPmaxRigid As Double ' GFH 11/27/06. Moved to Declarations.
  Dim CtoPmaxPointFlex As Double, CtoPmaxPointRigid As Double
  Dim AspectRatio As Double, TireWidth As Double
  Dim NRWheels As Integer
  Dim XRWheels() As Double, YRWheels() As Single
  Dim KeepForRigid() As Boolean
  
' From AC 150/5320-6C
' DC-10-10  WT = 19.35, XAC = +/- 27, P/C = 3.64
' DC-10-30  WT = 20.53, XAC = +/- 27, P/C = 3.38
' L-1011    WT = 19.05, XAC = +/- 26, P/C = 3.62
' From MWHGL (17.4 inch wander sigma)
' B-747     WT = 12.90, XAC = +/- 22, P/C = 3.24 (= 1.62 * 2)

' Checks don't agree exactly. May be because of rounding and graphical
' methods. Don't know the wander used in -6C. Estimated as 38.5 inches.
' The LEDFAA routines checked out exactly with LEDNEW routines.
' LEDFAA tire width from an eliptical approximation to the tire contact
' patch. See the tire width column in the aircraft grid in LEDFAA.

' WheelRadius is set in Global Sub GearCG.
' Convert to length of the minor axis of an ellipse of the
' same area as the circular contact patch.
' Area of ellipse = a * b * pi = r * r * pi if a = b = r.
' a = b / AspectRatio and b^2 = r^2 * AspectRatio

  AspectRatio = 0.625 ' = 1 / 1.6
  TireWidth = 2 * WheelRadius * Sqr(AspectRatio)   ' Minor axis.
    
  SigmaW = 17.4            ' MWHGL wander sigma for a wander width of 40 inches.
  SigmaW = 30.435          ' Wander width of 70 inches.
    
  If NWheels = 0 Then
    CtoPmaxFlex = 0
    CtoPmaxRigid = 0
    CtoPmaxPointFlex = 0
    CtoPmaxPointRigid = 0
    Debug.Print "NWheels = 0"
    Exit Sub
  End If
  
' First find the flexible pass-to-coverage ratio. All wheels
' in tandem contribute to the pass-to-coverage ratio.

  Call CoverageToPassCore(SigmaW, TireWidth, NWheels, YWheels(), CtoPmaxFlex, CtoPmaxPointFlex)
'  PtoCFlex = Round(1 / CtoPmaxFlex, 2)
  PtoCFlex = 1 / CtoPmaxFlex
  
' Now find the rigid pass-to-coverage ratio. Only wheels in tandem which
' are further apart than 72 inches contribute to the pass-to-coverage ratio.
' Two wheels are defined to be in tandem when the transverse coordinates of
' the wheel centers are closer than, or equal to, one half the tire width.

  ReDim XRWheels(NWheels + 1), YRWheels(NWheels + 1), KeepForRigid(NWheels + 1)
  For I = 1 To NWheels
    XRWheels(I) = XWheels(I)
    YRWheels(I) = YWheels(I)
    KeepForRigid(I) = True
  Next I
    
' Must identify all of the wheels to be removed before
' assembling the list of wheels to keep.
  For I = 1 To NWheels
    For J = I + 1 To NWheels
      If Abs(YRWheels(J) - YRWheels(I)) <= TireWidth / 2 And _
         Abs(XRWheels(J) - XRWheels(I)) <= 72 Then ' 72 inches tandem spacing cutoff is from LEDFAA.
        KeepForRigid(J) = False
      End If
    Next J
  Next I
  
  NRWheels = 0
  For I = 1 To NWheels
    If KeepForRigid(I) Then
      NRWheels = NRWheels + 1
      XRWheels(NRWheels) = XWheels(I) ' Don't need these for CtoP, just for record.
      YRWheels(NRWheels) = YWheels(I)
    End If
  Next I
  
'  Debug.Print "NRWHeels = "; NRWheels
  For I = 1 To -NWheels
    Debug.Print I; " "; KeepForRigid(I); " "; XWheels(I); " "; YWheels(I); " "; YRWheels(I)
  Next I
  
  Call CoverageToPassCore(SigmaW, TireWidth, NRWheels, YRWheels(), CtoPmaxRigid, CtoPmaxPointRigid)
'  PtoCRigid = Round(1 / CtoPmaxRigid, 2)
  PtoCRigid = 1 / CtoPmaxRigid
    
  S$ = "CtoPmaxPoint = " & Format(CtoPmaxPointFlex, "0.00") & " " & Format(CtoPmaxPointRigid, "0.00") & vbCrLf
  S$ = S$ & "Tire Width = " & TireWidth & vbCrLf
'  S$ = S$ & "sigma = " & SigmaW & " " & "NRWheels = " & Format(NRWheels, "0") & " " & Format(IG, "0") & vbCrLf
  S$ = S$ & "Max Pass-to-Coverage = " & Format(1 / CtoPmaxFlex, "0.000000") & " " & Format(1 / CtoPmaxRigid, "0.000000") & vbCrLf
      
'  Debug.Print S$
  
  FlexibleCoverages = AnnualDepartures * 20 * PtoTC / PtoCFlex
  RigidCoverages = AnnualDepartures * 20 * PtoTC / PtoCRigid
'  FlexibleAnnualDepartures = Coverages * PtoCFlex / 20 / PtoTC
'  RigidAnnualDepartures = Coverages * PtoCRigid / 20 / PtoTC
  
  Call WriteParmGrid

End Sub
'
'
Static Function GaussArea(AP As Double, BP As Double, SIGMA As Double) As Double
' Compute the area under Gauss curve between A and B.
' Uses Euler-McLaurin between 0 and B and 0 and A.
' See 6.7 in Numerical Methods by Irons.

  Const INTMUL! = 0.3989423 ' 1. / Sqr(2 * PI)
  Const N% = 4, HALF! = 1! / 2!, CORREC! = 1! / 24!
  Dim A As Double, B As Double, ZA As Double, ZB As Double
  Dim Temp As Double, HA As Double, HB As Double
  Dim INTA As Double, INTB As Double, I As Long

  If SIGMA < 0.000001 Then         ' If the tire touches the point
    If AP <= 0! And 0! <= BP Then  ' on the runway when SIGMA is
      GaussArea = 1!               ' zero, then the point is
    Else                           ' always covered.
      GaussArea = 0!
    End If
    Exit Function
  End If

DoEvents

  A = AP / SIGMA:    B = BP / SIGMA
  If A > B Then                           ' Just in case.
    Temp = A:  A = B:  B = Temp
  End If
  HA = A / N:        HB = B / N           ' Same signs as A and B.
  ZA = -HA * HALF:   ZB = -HB * HALF
  INTA = 0!:         INTB = 0!
  
  For I = 1 To N
    ZA = ZA + HA:    ZB = ZB + HB         ' Backwards for negative A or B.
    INTA = INTA + Exp(-HALF * ZA * ZA)    ' Always positive.
    INTB = INTB + Exp(-HALF * ZB * ZB)
  Next I

  ZA = ZA + HA * HALF:  ZB = ZB + HB * HALF
  ' CORREC = 1! / 24! + (3! - X * X) * H * H * 7! / 5760! ' Full correction.
  ' Signs of integrals now take the signs of A and B
  INTA = HA * (INTA - (HA * ZA * Exp(-HALF * ZA * ZA)) * CORREC)
  INTB = HB * (INTB - (HB * ZB * Exp(-HALF * ZB * ZB)) * CORREC)
  If Abs(A) > 5! Then INTA = HALF * Sgn(A) / INTMUL
  If B > 5! Then INTB = HALF / INTMUL
  ' Negative values for A and B are handled correctly. Area is always positive.
  GaussArea = (INTB - INTA) * INTMUL

End Function


Public Sub ChangeGrossWeight(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = GrossWeight
  LibValue = libGL(libIndex)     ' From library file.
  MinValue = MinGLFraction * LibValue 'ikawa 02/12/03
  MaxValue = MaxGLFraction * LibValue 'ikawa 02/12/03

  S$ = "The default value of gross load for" & vbCrLf
  S$ = S$ & "this aircraft is " & Format(LibValue * UnitsOut.pounds, _
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
      S$ = S$ & Format(MinGLFraction, "0.00")
      S$ = S$ & " x " & Format(LibValue * UnitsOut.pounds, _
          UnitsOut.poundsFormat) & vbCrLf
      S$ = S$ & "or greater than "
      S$ = S$ & Format(MaxGLFraction, "0.00")
      S$ = S$ & " x " & Format(LibValue * UnitsOut.pounds, _
       UnitsOut.poundsFormat) & "." & NL2
      S$ = S$ & "The old value of gross load has been selected."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    If ValueChanged Then
      GrossWeight = NewValue
    End If
    
  End If

End Sub

Public Sub ChangePcntOnMainGears(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = PcntOnMainGears
  
  'ikawa 02/17/03
  If ACN_mode_true Then
    LibValue = libPcntOnMainGears(libIndex, ACN_mode)    ' From library file.
  Else
    LibValue = libPcntOnMainGears(libIndex, Thick_mode)    ' From library file.
  End If
  
  MinValue = 5    'ikawa 02/17/03
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
    
    PcntOnMainGears = NewValue 'ikawa 02/17/03
    
  End If

End Sub

Public Sub ChangeTirePressure(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = TirePressure
  LibValue = libCP(libIndex)     ' From library file.
  MinValue = 50
  MaxValue = 500

  S$ = "The current value of tire pressure for" & vbCrLf
  S$ = S$ & "this aircraft is "
'  S$ = S$ & Format(CurrentValue, "#,###,##0.00") & " psi." & vbCrLf & vbCrLf
  S$ = S$ & Format(CurrentValue * UnitsOut.psi, UnitsOut.psiFormat & " ") _
    & UnitsOut.psiName & "." & vbCrLf & vbCrLf  'modified by Izydor Kawa
  
  S$ = S$ & "Enter a new value in the range:"
'  S$ = S$ & NL2 & Format(MinValue, "#,###,##0")
  S$ = S$ & NL2 & Format(MinValue * UnitsOut.psi, UnitsOut.psiFormat) 'modified by Izydor Kawa
  
'  S$ = S$ & " to " & Format(MaxValue, "#,###,##0") & "."
   S$ = S$ & " to " & Format(MaxValue * UnitsOut.psi, UnitsOut.psiFormat) & "." 'modified by Izydor Kawa
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Tire Pressure"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS / UnitsOut.psi

'   Check to See if value is within range.
    If CSng(NewValue) < CSng(MinValue) Or CSng(MaxValue) < CSng(NewValue) Then
      NewValue = CurrentValue
      S$ = "Tire pressure cannot be less than "
'      S$ = S$ & Format(MinValue, "0.00") & vbCrLf
      S$ = S$ & Format(MinValue * UnitsOut.psi, UnitsOut.psiFormat) & vbCrLf 'modified by Izydor Kawa
      
      
      S$ = S$ & "or greater than "
'      S$ = S$ & Format(MaxValue, "0.00") & "." & NL2
      S$ = S$ & Format(MaxValue * UnitsOut.psi, UnitsOut.psiFormat) & "." & NL2 'modified by Izydor Kawa
      
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
'    TirePressure = NewValue
    If ValueChanged Then
      TirePressure = NewValue  'ikawa 02/17/03
    End If

  End If

End Sub

Public Sub ChangeInputAlpha(ValueChanged As Boolean)

  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
' Changed from InputAlpha to PtoTC by GFH on 9/16/09.

  CurrentValue = PtoTC
  MinValue = 0.01
  MaxValue = 10#

  S$ = "Enter a value for the Pass to Traffic Cycle" & vbCrLf
  S$ = S$ & "Ratio (P/TC) in the range: "
  S$ = S$ & Format(MinValue, "#,###,##0.00")
  S$ = S$ & " to " & Format(MaxValue, "#,###,##0.00") & "."
  S$ = S$ & NL2 & "P/TC values should be selected according" & vbCrLf
  S$ = S$ & "to the operational conditions given below" & vbCrLf
  S$ = S$ & "except when performing a sensitivity analysis" & vbCrLf
  S$ = S$ & "based on traffic." & NL2
  S$ = S$ & "Parallel taxiway with fuel loaded, P/TC = 1" & vbCrLf
  S$ = S$ & "Parallel taxiway with no fuel loaded, P/TC = 2" & vbCrLf
  S$ = S$ & "Central taxiway with fuel loaded, P/TC = 2" & vbCrLf
  S$ = S$ & "Central taxiway with no fuel loaded, P/TC = 3" & NL2
  S$ = S$ & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Pass to Traffic Cycle Ratio (P/TC)"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS

'   Check to See if value is within range.
    If NewValue < MinValue Or MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "P/TC cannot be less than "
      S$ = S$ & Format(MinValue, "0.0") & vbCrLf
      S$ = S$ & "or greater than "
      S$ = S$ & Format(MaxValue, "0.0") & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    PtoTC = NewValue

  End If

  Exit Sub
  
  CurrentValue = InputAlpha
  LibValue = libAlpha(libIndex)     ' From library file.
  MinValue = 0
  MaxValue = 1

  S$ = "Entering a value of zero for alpha forces" & vbCrLf
  S$ = S$ & "the use of a computed default value." & NL2
  S$ = S$ & "To overide the default value," & vbCrLf
  S$ = S$ & "enter a value greater than zero." & NL2
  S$ = S$ & "Enter a new value in the range:"
  S$ = S$ & NL2 & Format(MinValue, "#,###,##0.000")
  S$ = S$ & " to " & Format(MaxValue, "#,###,##0.000") & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Alpha Factor"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS

'   Check to See if value is within range.
    If NewValue < MinValue Or MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "Alpha cannot be less than "
      S$ = S$ & Format(MinValue, "0.000") & vbCrLf
      S$ = S$ & "or greater than "
      S$ = S$ & Format(MaxValue, "0.000") & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    InputAlpha = NewValue

  End If

End Sub

Public Sub ChangeAnnualDepartures(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = AnnualDepartures
  LibValue = libAnnualDepartures(libIndex)     ' From library file.
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
    
    AnnualDepartures = NewValue

  End If

End Sub

Public Sub ChangeFlexibleCoverages(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = FlexibleCoverages
  MinValue = 1
  MaxValue = 1000000
  
  S$ = "The current value of coverages"
  S$ = S$ & " on flexible pavement is "
  S$ = S$ & Format(FlexibleCoverages, "#,##0") & "." & NL2
'  S$ = S$ & "The default value is determined from the following equation:" & NL2
'  S$ = S$ & "Annual Departures = Coverages x P/C / 20 years," & NL2
'  S$ = S$ & "where the value of Coverages is 10,000"
'  S$ = S$ & " and P/C is the Pass-to-Coverage ratio for the current aircraft on flexible pavement." & NL2
  S$ = S$ & "Enter a new value of Flexible Coverages in the range:"
  S$ = S$ & NL2 & Format(MinValue, "#,###,##0")
  S$ = S$ & " to " & Format(MaxValue, "#,###,##0") & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Flexible Annual Departures"
  
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
    
    FlexibleCoverages = NewValue
    AnnualDepartures = FlexibleCoverages * PtoCFlex / 20 / PtoTC
    RigidCoverages = FlexibleCoverages * PtoCFlex / PtoCRigid

  End If

End Sub

Public Sub ChangeRigidCoverages(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = RigidCoverages
  MinValue = 1
  MaxValue = 1000000
  
  S$ = "The current value of coverages"
  S$ = S$ & " on rigid pavement is "
  S$ = S$ & Format(RigidCoverages, "#,##0") & "." & NL2
'  S$ = S$ & "The default value is determined from the following equation:" & NL2
'  S$ = S$ & "Annual Departures = Coverages x P/C / 20 years," & NL2
'  S$ = S$ & "where the value of Coverages is 10,000"
'  S$ = S$ & " and P/C is the Pass-to-Coverage ratio for the current aircraft on rigid pavement." & NL2
  S$ = S$ & "Enter a new value of Rigid Coverages in the range:"
  S$ = S$ & NL2 & Format(MinValue, "#,###,##0")
  S$ = S$ & " to " & Format(MaxValue, "#,###,##0") & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Rigid Coverages"
  
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
    
    RigidCoverages = NewValue
    FlexibleCoverages = RigidCoverages * PtoCRigid / PtoCFlex
    AnnualDepartures = RigidCoverages * PtoCRigid / 20 / PtoTC ' GFH 9/16/09.

  End If

End Sub


Public Sub ChangeNMainGears(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
'  If lstACGroupIndex + 1 <> ExternalLibraryIndex Then
'    S$ = "The current aircraft is in the internal library." & NL2
'    S$ = S$ & "The number of main gears cannot be" & vbCrLf
'    S$ = S$ & "changed for aircraft in the internal library."
'    Ret = MsgBox(S$, 0, "Changing Number of Main Gears")
'    Exit Sub
'  End If
  
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = NMainGears
  LibValue = libNMainGears(libIndex)     ' From library file.
  MinValue = 1
  MaxValue = 16

  S$ = "The current number of main" & vbCrLf
  S$ = S$ & "gears for this aircraft is "
  S$ = S$ & Format(CurrentValue, "#,###,##0") & "." & vbCrLf & vbCrLf
  S$ = S$ & "Enter a new value in the range:"
  S$ = S$ & NL2 & Format(MinValue, "#,###,##0")
  S$ = S$ & " to " & Format(MaxValue, "#,###,##0") & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Number of Main Gears"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS

'   Check to See if value is within range.
    If NewValue < MinValue Or MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "The number of main gears cannot be less than "
      S$ = S$ & Format(MinValue, "0.00") & vbCrLf
      S$ = S$ & "or greater than "
      S$ = S$ & Format(MaxValue, "0.00") & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    NMainGears = NewValue 'ikawa 02/17/03
       

  End If

End Sub

Public Sub ChangeInputCBR(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  CurrentValue = InputCBR
'  LibValue = libAlpha(LibIndex)     ' From library file.
  MinValue = 1 ' 2 ' GFH 06-12-07.
  MaxValue = 80

  S$ = "Enter a new value of CBR in the range:"
  S$ = S$ & NL2 & Format(MinValue, "#,###,##0.00")
  S$ = S$ & " to " & Format(MaxValue, "#,###,##0.00") & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing CBR"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS

'   Check to See if value is within range.
    If NewValue < MinValue Then
      NewValue = CurrentValue
      S$ = S$ & "CBR cannot be less than "
      S$ = S$ & Format(MinValue, "0.00") & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    ElseIf MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = S$ & "CBR cannot be greater than "
      S$ = S$ & Format(MaxValue, "0.00") & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
  End If
    
  InputCBR = NewValue

End Sub

Public Sub ChangeInputkValue(ValueChanged As Boolean)

  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  CurrentValue = InputkValue
  MinValue = 10 * UnitsOut.pci
  MaxValue = 1000 * UnitsOut.pci

  S$ = "Enter a new k value in the range:"
  S$ = S$ & NL2 & Format(MinValue, UnitsOut.pciFormat)
  S$ = S$ & " to " & Format(MaxValue, UnitsOut.pciFormat) & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing k Value"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS

'   Check to See if value is within range.
    If NewValue < MinValue Then
      NewValue = CurrentValue
      S$ = "k value cannot be less than "
      S$ = S$ & Format(MinValue, UnitsOut.pciFormat) & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    ElseIf MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "k value cannot be greater than "
      S$ = S$ & Format(MaxValue, UnitsOut.pciFormat) & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    If ValueChanged Then
      InputkValue = NewValue / UnitsOut.pci
    End If
    
  End If

End Sub

Public Sub ChangeEvaluationThickness(ValueChanged As Boolean)

  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  Dim SV As Variant
  
  SV = frmGear.txtEvaluationThickness.Text
  If IsNumeric(SV) Then CurrentValue = SV
  MinValue = MinEvalThickness * UnitsOut.inch
  MaxValue = MaxEvalThickness * UnitsOut.inch

  S$ = "Enter a value for evaluation thickness in the range "
  S$ = S$ & NL2 & Format(MinValue, UnitsOut.inchFormat) & " " & UnitsOut.inchName
  S$ = S$ & " to " & Format(MaxValue, UnitsOut.inchFormat) & " " & UnitsOut.inchName & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Evaluation Thickness"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS

'   Check to See if value is within range.
    If NewValue < MinValue Then
      NewValue = CurrentValue
      S$ = "Evaluation thickness cannot be less than "
      S$ = S$ & Format(MinValue, UnitsOut.inchFormat) & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    ElseIf MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "Evaluation thickness cannot be greater than "
      S$ = S$ & Format(MaxValue, UnitsOut.inchFormat) & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    If ValueChanged Then
      EvalThick = NewValue / UnitsOut.inch
      frmGear.txtEvaluationThickness.Text = Format(NewValue, "0.00")
    End If
    
  End If

End Sub

Public Sub ResetOutputs()
  
  Dim I As Integer
  
  For I = 1 To NSubgrades
    ACNFlexCBR(I) = 0
    CBRThickness(I) = 0
    ACNFlex(I) = 0
    ACNRigidk(I) = 0
    RigidThickness(I) = 0
    ACNRigid(I) = 0
  Next I
  StartWheelIndex = 0  ' Don't plot cross for rigid origin.
  frmGear!cmdSelectWheel.Caption = "Se&lect"
  frmGear!lblXSelected.Caption = ""
  frmGear!lblYSelected.Caption = ""
  Operation = NoOperation
  LastOperation = NoOperation

End Sub

Public Sub CheckChangedData()

  Dim I As Integer, CurrentlstLibFileIndex As Integer
  Dim CurrentlstACGroupIndex As Integer, new_libIndex As Integer
  
  ChangeDataRet = 0
    
  If NWheels <> libNTires(libIndex) Then GoTo DataChanged
  If CSng(GrossWeight) <> libGL(libIndex) Then GoTo DataChanged
  If NMainGears <> libNMainGears(libIndex) Then GoTo DataChanged
  
  'ikawa 02/13/03 begin
  new_libIndex = LibACGroup(frmGear.lstACGroup.ListIndex + 1) + frmGear.lstLibFile.ListIndex

'  If ((libIndex = new_libIndex) And ACN_mode_true And (Not mode_changed)) _
'    Or ((libIndex = new_libIndex) And (Not ACN_mode_true) And (mode_changed)) _
'    Or ((libIndex <> new_libIndex) And (ACN_mode_true)) Then
  
  If ACN_mode_true Then
    If CSng(PcntOnMainGears) <> CSng(libPcntOnMainGears(libIndex, ACN_mode)) Then GoTo DataChanged
    'If CSng(TirePressure) <> CSng(libCP(libIndex)) Then GoTo DataChanged
  Else
    If SamePcntAndPress Then
      If CSng(PcntOnMainGears) <> CSng(libPcntOnMainGears(libIndex, ACN_mode)) Then GoTo DataChanged
    Else
      If CSng(PcntOnMainGears) <> CSng(libPcntOnMainGears(libIndex, Thick_mode)) Then GoTo DataChanged
      'If CSng(TireContactArea) <> CSng(libTireContactArea(libIndex)) Then GoTo DataChanged
    End If
'    If Coverages <> libCoverages(libIndex) Then GoTo DataChanged
    If AnnualDepartures <> libAnnualDepartures(libIndex) Then GoTo DataChanged
  End If
  
  If CSng(TirePressure) <> CSng(libCP(libIndex)) Then GoTo DataChanged
  'ikawa 02/13/03 end
 
  For I = 1 To NWheels
    If XWheels(I) <> libTY(libIndex, I) Then GoTo DataChanged
    If YWheels(I) <> libTX(libIndex, I) Then GoTo DataChanged
  Next I
  
  Exit Sub

DataChanged:

  S$ = "Data for the current gear has changed." & NL2
  S$ = S$ & "Do you want to save the new data?"
  Ret = MsgBox(S$, vbYesNoCancel, "Save Current Data?")
  If Ret = vbNo Or Ret = vbYes Then
  
    ChangeDataRet = Ret
    CurrentlstLibFileIndex = frmGear.lstLibFile.ListIndex
    CurrentlstACGroupIndex = frmGear.lstACGroup.ListIndex
    ChangeDataRet = vbYes
    If Ret = vbYes Then
      Call UpdateLibraryData(libIndex)
      Call WriteExternalFile
    End If
    Call UpdateDataFromLibrary(libIndex)
    If CurrentlstACGroupIndex = frmGear.lstACGroup.ListIndex Then
      Call frmGear.lstACGroup_Click
    Else
      frmGear.lstACGroup.ListIndex = CurrentlstACGroupIndex
    End If
    If CurrentlstLibFileIndex = frmGear.lstLibFile.ListIndex Then
      Call frmGear.lstLibFile_Click
    Else
      If CurrentlstLibFileIndex >= frmGear.lstLibFile.ListCount Then
        CurrentlstLibFileIndex = frmGear.lstLibFile.ListCount - 1
      End If
      frmGear.lstLibFile.ListIndex = CurrentlstLibFileIndex
    End If
    
  ElseIf Ret = vbCancel Then
  
    If ACN_mode_true Then
      InputkValue = 0
      InputCBR = 0
    End If
  
    ChangeDataRet = vbCancel
    CurrentlstLibFileIndex = lstLibFileIndex
    CurrentlstACGroupIndex = lstACGroupIndex
    If CurrentlstACGroupIndex = frmGear.lstACGroup.ListIndex Then
      Call frmGear.lstACGroup_Click
    Else
      frmGear.lstACGroup.ListIndex = CurrentlstACGroupIndex
    End If
      If CurrentlstLibFileIndex = frmGear.lstLibFile.ListIndex Then
      Call frmGear.lstLibFile_Click
    Else
      frmGear.lstLibFile.ListIndex = CurrentlstLibFileIndex
    End If
  End If
  
End Sub

Public Sub ChangeRigidCutoff(ValueChanged As Boolean)

  Dim S$, SS$, SVS As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  CurrentValue = RigidCutoff
  
  MinValue = 0.1
  MaxValue = 100

  S$ = "The default value for rigid cutoff is "
  S$ = S$ & Format(StandardRigidCutoff, "0.00") & vbCrLf
  S$ = S$ & "to comply with the ICAO standard." & NL2
  S$ = S$ & "Enter a new value in the range:"
  S$ = S$ & NL2 & Format(MinValue, "#,###,##0.0")
  S$ = S$ & " to " & Format(MaxValue, "#,###,##0") & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Rigid Cutoff"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS

'   Check to See if Value is within range.
    If NewValue < MinValue Or MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "Rigid cutoff cannot be less than "
      S$ = S$ & Format(MinValue, "0.000") & vbCrLf
      S$ = S$ & "or greater than "
      S$ = S$ & Format(MaxValue, "0.000") & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    RigidCutoff = NewValue

  End If

End Sub

'Izydor Kawa code Begin
Public Sub ChangeConcreteStrength(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  CurrentValue = ConcreteFlexuralStrength
'  MinValue = 500# * UnitsOut.psi
'  MaxValue = 900# * UnitsOut.psi
  MinValue = 200# * UnitsOut.psi        ' GFH 02/01/08. Response to Tim email on 11/19/07 and subsequent R. Joel comment on 11/21/07.
  MaxValue = 2000# * UnitsOut.psi       ' Also see changed message below.

  S$ = "The default value for concrete strength is "
  S$ = S$ & Format(StandardConcreteStrength * UnitsOut.psi, UnitsOut.psiFormat) _
  & " " & UnitsOut.psiName & "."
  S$ = S$ & NL2
  S$ = S$ & "The FAA recommends a range of "
  S$ = S$ & Format(500 * UnitsOut.psi, UnitsOut.psiFormat) _
  & " " & UnitsOut.psiName & " to "
  S$ = S$ & Format(900 * UnitsOut.psi, UnitsOut.psiFormat) _
  & " " & UnitsOut.psiName & " for concrete flexural strength "
  S$ = S$ & "when using this software. Concrete flexural strength outside this range "
  S$ = S$ & "is not supported by the FAA and may lead to pavement thickness requirements "
  S$ = S$ & "inconsistent with FAA design procedures. However, an input range has been "
  S$ = S$ & "provided which will accomodate almost any type of structural concrete."
  S$ = S$ & NL2
  S$ = S$ & "Enter a new value in the range:"
  S$ = S$ & NL2 & Format(MinValue, UnitsOut.psiFormat)
  S$ = S$ & " to " & Format(MaxValue, UnitsOut.psiFormat) & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Concrete Strength"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS

'   Check to See if Value is within range.
    If NewValue < MinValue Or MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "Concrete strength cannot be less than "
      S$ = S$ & Format(MinValue, UnitsOut.psiFormat) & vbCrLf
      S$ = S$ & "or greater than "
      S$ = S$ & Format(MaxValue, UnitsOut.psiFormat) & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    If ValueChanged Then
      ConcreteFlexuralStrength = NewValue / UnitsOut.psi
    End If

  End If

End Sub
'Izydor Kawa code End
