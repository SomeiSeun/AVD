Attribute VB_Name = "Module1"
Option Explicit
'Global SVS!  ' String variant converted to single float.
Global Min1 As Double
Global Max1 As Double

Global grdJobTitle$(MaxSectAC * 2)
Global grdGrossWeight(MaxSectAC * 2)
Global grdNMainGears(MaxSectAC * 2)
Global grdPcntOnMainGears(MaxSectAC * 2, 2)

Global grdNWheels(MaxSectAC * 2)
Global grdXWheels(MaxSectAC * 2, NMaxWheels)
Global grdYWheels(MaxSectAC * 2, NMaxWheels)

Global grdTirePressure(MaxSectAC * 2)
Global grdTireContactArea(MaxSectAC * 2)

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

Public LoadingfrmAirplaneList As Boolean

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



Public Sub grdUpdateLibraryData(IACpassed As Integer)

  Dim J As Integer, NX As Integer, NY As Integer
  Dim new_libIndex As Integer 'ikawa 02/13/03
  Dim IAC As Long ' GFH 2/6/04.
  
' libIndex is a global. When adding an aircraft to the list the new aircraft
' index is passed to UpdateLibraryData. The data for libIndex is passed to IAC.
  IAC = IACpassed ' GFH 2/6/04.
  
'ik  libACName$(IAC) = JobTitle$
'ik  libGL(IAC) = GrossWeight
'ik  libNMainGears(IAC) = NMainGears
   
  grdJobTitle$(IAC) = JobTitle$
  grdGrossWeight(IAC) = GrossWeight
  grdNMainGears(IAC) = NMainGears
   
   
  'ikawa 02/13/03 begin
  ' Statements commented out by GFH 02/10/04.
'  If frmAirplaneList.Visible = True Then
'  new_libIndex = LibACGroup(frmAirplaneList!lstACGroup.ListIndex + 1) + frmAirplaneList!lstLibFile.ListIndex
'  Else
  new_libIndex = LibACGroup(frmGear!lstACGroup.ListIndex + 1) + frmGear!lstLibFile.ListIndex
'  End If
 
  
'  If ((libIndex = new_libIndex) And ACN_mode_true And (Not mode_changed)) _
'  Or ((libIndex = new_libIndex) And (Not ACN_mode_true) And (mode_changed)) _
'  Or ((libIndex <> new_libIndex) And (ACN_mode_true)) Then
  If ACN_mode_true Then
'ik    libPcntOnMainGears(IAC, ACN_mode) = PcntOnMainGears
'ik    libPcntOnMainGears(IAC, Thick_mode) = libPcntOnMainGears(libIndex, Thick_mode)
'ik    libCP(IAC) = TirePressure
'ik    libTireContactArea(IAC) = libTireContactArea(libIndex)
'ik    libCoverages(IAC) = StandardCoverages
    
    grdPcntOnMainGears(IAC, ACN_mode) = PcntOnMainGears
    grdPcntOnMainGears(IAC, Thick_mode) = libPcntOnMainGears(libIndex, Thick_mode)
    grdTirePressure(IAC) = TirePressure
    grdTireContactArea(IAC) = libTireContactArea(libIndex)
    grdStandardCoverages(IAC) = StandardCoverages
       
  Else
'ik    libPcntOnMainGears(IAC, ACN_mode) = libPcntOnMainGears(libIndex, ACN_mode)
'ik    libPcntOnMainGears(IAC, Thick_mode) = PcntOnMainGears
'ik    libCP(IAC) = libCP(libIndex)
'ik    libTireContactArea(IAC) = TireContactArea
'ik    libCoverages(IAC) = Coverages
    
    grdPcntOnMainGears(IAC, ACN_mode) = libPcntOnMainGears(libIndex, ACN_mode)
    grdPcntOnMainGears(IAC, Thick_mode) = PcntOnMainGears
    grdTirePressure(IAC) = libCP(libIndex)
    grdTireContactArea(IAC) = TireContactArea
    grdStandardCoverages(IAC) = Coverages
    
  End If
  'ikawa 02/13/03 end
  
  mode_changed = False
'ik  libNTires(IAC) = NWheels
  grdNWheels(IAC) = NWheels
       
'ik  For J = 1 To libNTires(IAC)
  For J = 1 To libNTires(new_libIndex)
'ik    libTY(IAC, J) = XWheels(J)
'ik    libTX(IAC, J) = YWheels(J)
    
    grdYWheels(IAC, J) = XWheels(J)
    grdXWheels(IAC, J) = YWheels(J)
  Next J

  If libXGridNPoints(IAC) <> 0 And libXGridNPoints(IAC) <> 0 Then
    NX = XGridNPoints:  NY = YGridNPoints
  Else
    NX = 0:             NY = 0
  End If
  
'ik  libXGridOrigin(IAC) = XGridOrigin
'ik  libXGridMax(IAC) = XGridMax
'ik  libXGridNPoints(IAC) = NX
'ik  libYGridOrigin(IAC) = YGridOrigin
'ik  libYGridMax(IAC) = YGridMax
'ik  libYGridNPoints(IAC) = NY

  grdXGridOrigin(IAC) = XGridOrigin
  grdXGridMax(IAC) = XGridMax
  grdXGridNPoints(IAC) = NX
  
  grdYGridOrigin(IAC) = YGridOrigin
  grdYGridMax(IAC) = YGridMax
  grdYGridNPoints(IAC) = NY

End Sub


