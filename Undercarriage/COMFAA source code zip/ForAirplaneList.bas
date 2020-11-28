Attribute VB_Name = "modForfrmAirplaneList"
Option Explicit

Public frmAirplaneListLoaded As Boolean
Public lYWheels() As Single

'Public wPtoCFlex As Double, wPtoCRigid As Double
'Public wFlexibleAnnualDepartures       As Double
'Public wRigidAnnualDepartures          As Double


'Global SVS!  ' String variant converted to single float.
Global Min1 As Double
Global Max1 As Double

Global grdNAC As Integer
Global grdJobTitle$(MaxSectAC * 2)
Global grdGrossWeight(MaxSectAC * 2) As Single
Global grdNMainGears(MaxSectAC * 2) As Integer
Global grdPcntOnMainGears(MaxSectAC * 2, 2) As Single

Global grdNWheels(MaxSectAC * 2) As Integer
Global grdXWheels(MaxSectAC * 2, NMaxWheels)
Global grdYWheels(MaxSectAC * 2, NMaxWheels)

Global grdTirePressure(MaxSectAC * 2) As Single
Global grdTireContactArea(MaxSectAC * 2) As Single

Global grdXGridOrigin(MaxSectAC * 2)
Global grdYGridOrigin(MaxSectAC * 2)
Global grdXGridMax(MaxSectAC * 2)
Global grdYGridMax(MaxSectAC * 2)
Global grdXGridNPoints(MaxSectAC * 2)
Global grdYGridNPoints(MaxSectAC * 2)

Global grdStandardCoverages(MaxSectAC * 2)
Global grdCoverages(MaxSectAC * 2)
Global grdFlexibleAnnualDepartures(MaxSectAC * 2)
Global grdPtoCFlex(MaxSectAC * 2)
Global grdRigidAnnualDepartures(MaxSectAC * 2)
Global grdPtoCRigid(MaxSectAC * 2)
'Global grdNX(MaxSectAC)
'Global grdNY(MaxSectAC)

'http://www.vb6.us/tutorials/date-time-functions-visual-basic
'now, date, time
Public AutomaticRun As Boolean

Public txtACname(MaxSectAC% * 2) As String
Public txtOpwt(MaxSectAC% * 2) As Double
Public txtAnnDepsFlex(MaxSectAC% * 2) As Double
Public txtAnnDepsRigid(MaxSectAC% * 2) As Double

Public txtACNatOpwt(MaxSectAC% * 2) As Double
Public txtThick6DFlex(MaxSectAC% * 2) As Double
Public txtThick6DRigid(MaxSectAC% * 2) As Double
Public txtEquivDeps(MaxSectAC% * 2) As Double
Public txtMGW(MaxSectAC% * 2) As Double
Public txtPCN(MaxSectAC% * 2, 4) As Double
Public txtPCN2(MaxSectAC% * 2, 4) As Double

Public txtCriticalACTotalEquivCovs(MaxSectAC% * 2) As Double
Public txtCoverages(MaxSectAC% * 2) As Double
Public txtPtoCFlex(MaxSectAC% * 2) As Double
Public txtPtoCRigid(MaxSectAC% * 2) As Double
Public txtACNStdCov(MaxSectAC% * 2, 4) As Double


Global Const NCodes% = 25
Global LFillColor(NCodes)
Global LFillStyle(NCodes)
Global Const White = &HFFFFFF
Global Const Black = 0, Gray = &H808080, LightGray = &HC0C0C0
Global Const ColorAsphalt = &H494949, ColorPCC = &H7D7D7D
Global Const ColorSTBS = &H909090, ColorSTSBS = &HB0B0B0
Global Const ColorAGBS = &HD0D0D0, ColorAGSBS = &HE0E0E0
Global Const LFillColorHighlight = &H80C0FF, LFillStyleHighlight = 0
Global Const Solid = 0, Cross = 6, Diagonal = 7, Transparent = 1
Global RepsAnnual(20), RepsInc(20), Reps(20) As Integer
Global MGpcnt(20) As Double

Global SectName$
Global NL  ' New Line. See frmStartup.form_load for setting statement.
'Global NL2 ' 2 new lines.



Function MsgBoxDQ(Caption$, I As Integer, Title$)
  
    If I = 0 Then
      Caption$ = Caption$ & NL2 & "Click OK to continue."
    Else
      Caption$ = Caption$ & NL2 & "Click the appropriate button to continue."
    End If
  
  MsgBoxDQ = MsgBox(Caption$, I, Title$)
  
End Function



Public Sub grdUpdateLibraryData(IACpassed As Integer, N2 As Integer)

  Dim J As Integer, NX As Integer, NY As Integer
  Dim new_libIndex As Integer 'ikawa 02/13/03
  Dim IAC As Long ' GFH 2/6/04.
  
    ' libIndex is a global. When adding an aircraft to the list the new aircraft
    ' index is passed to UpdateLibraryData. The data for libIndex is passed to IAC.
    IAC = IACpassed ' GFH 2/6/04.
   
    grdJobTitle$(IAC) = JobTitle$
    grdGrossWeight(IAC) = libGL(N2)
    grdNMainGears(IAC) = libNMainGears(N2)
      
    ' Statements commented out by GFH 02/10/04.
    ' If frmAirplaneList.Visible = True Then
    ' new_libIndex = LibACGroup(frmAirplaneList!lstACGroup.ListIndex + 1) + frmAirplaneList!lstLibFile.ListIndex
    ' Else
    new_libIndex = LibACGroup(frmGear!lstACGroup.ListIndex + 1) + frmGear!lstLibFile.ListIndex
    '  End If
   
    '  If ((libIndex = new_libIndex) And ACN_mode_true And (Not mode_changed)) _
    '  Or ((libIndex = new_libIndex) And (Not ACN_mode_true) And (mode_changed)) _
    '  Or ((libIndex <> new_libIndex) And (ACN_mode_true)) Then
    
    If ACN_mode_true Then
        
        grdPcntOnMainGears(IAC, ACN_mode) = PcntOnMainGears
        grdPcntOnMainGears(IAC, Thick_mode) = libPcntOnMainGears(libIndex, Thick_mode)
        grdTirePressure(IAC) = TirePressure
        grdTireContactArea(IAC) = libTireContactArea(libIndex)
        grdCoverages(IAC) = libCoverages(N2)
    Else
      
        grdPcntOnMainGears(IAC, ACN_mode) = libPcntOnMainGears(libIndex, ACN_mode)
        grdPcntOnMainGears(IAC, Thick_mode) = PcntOnMainGears
        grdTirePressure(IAC) = libCP(libIndex)
        grdTireContactArea(IAC) = libTireContactArea(N2)
        grdCoverages(IAC) = libCoverages(N2)
    
  End If
  
  mode_changed = False
  grdNWheels(IAC) = libNTires(N2)
       
    For J = 1 To libNTires(libIndex)
    'For J = 1 To libNTires(new_libIndex)
        grdYWheels(IAC, J) = libTY(libIndex, J)
        grdXWheels(IAC, J) = libTX(libIndex, J)
    Next J

    If libXGridNPoints(IAC) <> 0 And libXGridNPoints(IAC) <> 0 Then
        NX = XGridNPoints:  NY = YGridNPoints
    Else
        NX = 0:             NY = 0
    End If
  
    grdXGridOrigin(IAC) = libXGridOrigin(N2)
    grdXGridMax(IAC) = libXGridMax(N2)
    grdXGridNPoints(IAC) = libXGridNPoints(N2)
  
    grdYGridOrigin(IAC) = libYGridOrigin(N2)
    grdYGridMax(IAC) = libYGridMax(N2)
    grdYGridNPoints(IAC) = libYGridNPoints(N2)

End Sub



Sub WriteExternalFile3()
Dim IA As Integer, I As Integer
IA = 1
   
grdJobTitle$(IA) = 1
grdGrossWeight(IA) = 1
grdNMainGears(IA) = 1
grdPcntOnMainGears(IA, ACN_mode) = 1
grdPcntOnMainGears(IA, Thick_mode) = 1
grdNWheels(IA) = 1

For I = 1 To grdNWheels(IA)
    grdXWheels(IA, I) = 1
    grdYWheels(IA, I) = 1
Next I
    
grdTirePressure(IA) = 1
grdTireContactArea(IA) = 1
grdXGridOrigin(IA) = 1
grdXGridMax(IA) = 1
grdXGridNPoints(IA) = 1
grdYGridOrigin(IA) = 1
grdYGridMax(IA) = 1
grdYGridNPoints(IA) = 1
grdStandardCoverages(IA) = 1

End Sub



Public Sub ChangeGrossWeightAirplaneList(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  Dim irow As Integer
  irow = frmAirplaneList.grdDesignAC.Row
  
  'libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  libIndex = LibACGroup(ExternalLibraryIndex) + irow - 1
  
  CurrentValue = grdGrossWeight(irow)
   
  If libGL(libIndex) <> 0 Then
    LibValue = libGL(libIndex)     ' From library file.
  Else
     LibValue = grdGrossWeight(irow)
  End If
  
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
      grdGrossWeight(irow) = NewValue
    End If
    
  End If

End Sub


Public Sub ChangePcntOnMainGearsAirplaneList(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  Dim irow As Integer
  irow = frmAirplaneList.grdDesignAC.Row
  
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = grdPcntOnMainGears(irow, Thick_mode)
  LibValue = libPcntOnMainGears(libIndex, Thick_mode)    ' From library file.
 
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
    
    grdPcntOnMainGears(irow, Thick_mode) = NewValue 'ikawa 02/17/03
    
  End If

End Sub



Public Sub ChangeNMainGearsAirplaneList(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  Dim irow As Integer
  irow = frmAirplaneList.grdDesignAC.Row
   
  
'  If lstACGroupIndex + 1 <> ExternalLibraryIndex Then
'    S$ = "The current aircraft is in the internal library." & NL2
'    S$ = S$ & "The number of main gears cannot be" & vbCrLf
'    S$ = S$ & "changed for aircraft in the internal library."
'    Ret = MsgBox(S$, 0, "Changing Number of Main Gears")
'    Exit Sub
'  End If
  
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = grdNMainGears(irow)
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
    
    grdNMainGears(irow) = NewValue 'ikawa 02/17/03
       

  End If

End Sub




Public Sub ChangeCoveragesAirplaneList(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, LibValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  Dim irow As Integer
  irow = frmAirplaneList.grdDesignAC.Row
 
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = grdCoverages(irow)
  LibValue = libCoverages(libIndex)     ' From library file.
  MinValue = Min1
  MaxValue = Max1

  S$ = "The default value for coverages is "
  S$ = S$ & Format(StandardCoverages, "#,##0") & vbCrLf
  S$ = S$ & "to comply with the ICAO standard." & NL2
  S$ = S$ & "ACNs are not computed when coverages is" & vbCrLf
  S$ = S$ & "set to anything other than the standard." & NL2
  S$ = S$ & "Enter a new value in the range:"
  S$ = S$ & NL2 & Format(MinValue, "#,###,##0")
  S$ = S$ & " to " & Format(MaxValue, "#,###,##0") & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Coverages"
  
  ValueChanged = GetInputSingle(S$, SS$, SVS)
  If ValueChanged Then
  
    NewValue = SVS

'   Check to See if Value is within range.
    If NewValue < MinValue Or MaxValue < NewValue Then
      NewValue = CurrentValue
      S$ = "Coverages cannot be less than "
      S$ = S$ & Format(MinValue, "0.000") & vbCrLf
      S$ = S$ & "or greater than "
      S$ = S$ & Format(MaxValue, "0.000") & "." & NL2
      S$ = S$ & "The old value has been retained."
      Ret = MsgBox(S$, 0, "")
      ValueChanged = False
    End If
    
    grdCoverages(irow) = NewValue

  End If

End Sub


Public Sub ResetValues()
    
    Dim I As Integer, J As Integer
    J = LibACGroup(ExternalLibraryIndex) - 1 ' Number of aircraft without the external library.

    For I = 1 To NAC
    
        grdGrossWeight(I) = libGL(J + I)
        grdCoverages(I) = libCoverages(J + I)
        grdNMainGears(I) = libNMainGears(J + I)
        'grdNWheels(I) = libNTires(libIndex1)
        grdPcntOnMainGears(I, ACN_mode) = libPcntOnMainGears(J + I, ACN_mode)
        grdPcntOnMainGears(I, Thick_mode) = libPcntOnMainGears(J + I, Thick_mode)
        'grdTirePressure(I) = libCP(J + I)
        'grdTireContactArea(I) = libTireContactArea(J + I)
        
    Next I

End Sub



Public Sub ChangeFlexibleAnnualDeparturesAirplaneList(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, CoveragesValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  Dim irow As Integer
  irow = frmAirplaneList.grdDesignAC.Row
    
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = grdFlexibleAnnualDepartures(irow)
  MinValue = Min1
  MaxValue = Max1
  
  S$ = "For the current aircraft, the default value of Annual Departures"
  S$ = S$ & " on flexible pavement is "
  S$ = S$ & Format(StandardCoverages * PtoCFlex / 20, "#,##0") & "." & NL2
  S$ = S$ & "The default value is determined from the following equation:" & NL2
  S$ = S$ & "Annual Departures = Coverages x P/C / 20 years," & NL2
  S$ = S$ & "where the value of Coverages is a number stored in the aircraft library"
  S$ = S$ & " and P/C is the Pass-to-Coverage ratio for the current aircraft on flexible pavement." & NL2
  S$ = S$ & "Enter a new value of Flexible Annual Departures in the range:"
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
    
    grdFlexibleAnnualDepartures(irow) = NewValue
    grdCoverages(irow) = grdFlexibleAnnualDepartures(irow) * 20 / gPtoCFlex
    grdRigidAnnualDepartures(irow) = grdCoverages(irow) * gPtoCRigid / 20

  End If

End Sub




Public Function CalculateWheelRadius(GrossWeight As Double, PcntOnMainGears As Double, _
       NMainGears As Double, NWheels As Integer, TirePressure As Double, TireContactArea As Double) As Single

' Added contact area option for thickness mode. GFH 02/10/04.
    If ACN_mode_true Or True Then
        WheelRadius = GrossWeight * PcntOnMainGears / (100 * NMainGears * NWheels)
        WheelRadius = Sqr(WheelRadius / TirePressure / PI)
    Else
        WheelRadius = Sqr(TireContactArea / PI)
    End If

    CalculateWheelRadius = WheelRadius
End Function





Public Sub ChangeRigidAnnualDeparturesAirplaneList(ValueChanged As Boolean)
  
  Dim S$, SS$, SVS As Double, CoveragesValue As Double
  Dim CurrentValue As Double, NewValue As Double
  Dim MinValue As Double, MaxValue As Double
  
  Dim irow As Integer
  irow = frmAirplaneList.grdDesignAC.Row
    
  libIndex = LibACGroup(lstACGroupIndex + 1) + frmGear!lstLibFile.ListIndex ' Library index
  
  CurrentValue = grdRigidAnnualDepartures(irow)
  MinValue = Min1
  MaxValue = Max1
  
   
  S$ = "For the current aircraft, the default value of Annual Departures"
  S$ = S$ & " on rigid pavement is "
  S$ = S$ & Format(StandardCoverages * PtoCRigid / 20, "#,##0") & "." & NL2
  S$ = S$ & "The default value is determined from the following equation:" & NL2
  S$ = S$ & "Annual Departures = Coverages x P/C / 20 years," & NL2
  S$ = S$ & "where the value of Coverages is a number stored in the aircraft library"
  S$ = S$ & " and P/C is the Pass-to-Coverage ratio for the current aircraft on rigid pavement." & NL2
  S$ = S$ & "Enter a new value of Rigid Annual Departures in the range:"
  S$ = S$ & NL2 & Format(MinValue, "#,###,##0")
  S$ = S$ & " to " & Format(MaxValue, "#,###,##0") & "."
  S$ = S$ & NL2 & "Click Cancel at any time to retain the old value."
  SS$ = "Changing Rigid Annual Departures"
  
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
    
'    RigidAnnualDepartures = NewValue
'    'FlexibleAnnualDepartures = RigidAnnualDepartures * PtoCRigid / PtoCFlex
'    Coverages = RigidAnnualDepartures * 20 / PtoCRigid
'    FlexibleAnnualDepartures = Coverages * PtoCFlex / 20
    
    
    grdRigidAnnualDepartures(irow) = NewValue
    grdCoverages(irow) = grdRigidAnnualDepartures(irow) * 20 / gPtoCRigid
    grdFlexibleAnnualDepartures(irow) = grdCoverages(irow) * gPtoCFlex / 20
    
    
  End If

End Sub
