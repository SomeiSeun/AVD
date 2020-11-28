Attribute VB_Name = "modNonstandard"
'**************************************************************
'Module written by Izydor Kawa
'Last update April 12, 2001
'
'Function RTBIS finds the root of a function StressValue
'(the minimum PCC thickness for which the calculated
'edge stress is less or equal to allowable maximum stress
'
'Function StressValue calls either EdgeStress or MaxStressNonStdGear
'depends on type of configuration
'
'Function EdgeStress calculates PCC edge stresses
'for standard aircraft gear configurations
'
'Procedure MaxStressNonStdGear calculates PCC edge stresses
'for nonstandard aircraft gear configurations. It uses
'function GoldenSearch (this calculations take more time)
'
'Function GoldenSearch performs search for the maximum PCC stress
'along PCC edge. It uses function StressNWheels.
'
'Public Function StressNWheels(displ As Double, ZeroDeg As Boolean) As Double
'finds PCC edge stress for a gear
'ZeroDeg = 0 gear longitudinal to PCC edge
'ZeroDeg = 90 gear perpendicular to PCC edge
'displ - location of PCC edge stress along the edge from
'the minimum wheel coordinate
' It uses function StressPosXY.
'
'Public Function Stress1Wheel(trans As Double, longit As Double) As Double
'finds PCC edge stress one wheel located at the coordinates(trans,longit)
'It uses function EdgeStress.
'**************************************************************

Option Explicit

Public Type InputData
  Thickness As Double
  XK As Double
  NOG As Long
  Angle As Double
  GearLoad As Double
  TirePressure As Double
  Delta As Double
  XNA As Double
  XNB As Double
  XNC As Double
  XND As Double
  XLA As Double
  XLB As Double
  XLC As Double
  XLD As Double
End Type

Public DesignInput As InputData ' Used in function EdgeStress (modH51inVB)

Const PI As Double = 3.14159265359
Public StressA As Double, StressB As Double
Public Stress1 As Double, Stress2 As Double
Public YWheelsNew(65) As Double, XWheelsNew(65) As Double
Public S1Max As Double, S2Max As Double

Public Function StressNWheels(displ As Double, ZeroDeg As Boolean) As Double
Dim I As Integer
StressA = 0#

  For I = 1 To NWheels
                    '(transverse distance, longitudinal distance)
    If ZeroDeg Then
      Stress1 = Stress1Wheel(Abs(YWheelsNew(I) - displ), Abs(XWheelsNew(I)))
    Else
      Stress1 = Stress1Wheel(Abs(YWheelsNew(I)), Abs(XWheelsNew(I) - displ))
    End If
    StressA = StressA + Stress1
  Next I

    StressNWheels = StressA
    
    If Not ComputingRigid Then
      Exit Function
    End If
  
End Function

Public Function MaxStressNonStdGear() As Double
Dim Ymin As Double, YMax As Double, YRange As Double
Dim XMin As Double, XMax As Double, XRange As Double
Dim S1 As Double, S2 As Double
Dim I As Integer, Angle As Boolean
Dim AX As Double, BX As Double, CX As Double
Static istatic

  If Not ComputingRigid Then Exit Function

XMin = 100000
XMax = -100000
For I = 1 To NWheels
    If XMin > XWheels(I) Then
    XMin = XWheels(I)
    End If
    If XMax < XWheels(I) Then
    XMax = XWheels(I)
    End If
Next I

XRange = XMax - XMin

Ymin = 100000
YMax = -100000
For I = 1 To NWheels
    If Ymin > YWheels(I) Then
    Ymin = YWheels(I)
    End If
    If YMax < YWheels(I) Then
    YMax = YWheels(I)
    End If
Next I

YRange = YMax - Ymin

If XMin < 0 Then
   For I = 1 To NWheels
   XWheelsNew(I) = XWheels(I) + Abs(XMin)
   Next I
Else
   For I = 1 To NWheels
   XWheelsNew(I) = XWheels(I) - Abs(XMin)
   Next I
End If

If Ymin < 0 Then
    For I = 1 To NWheels
    YWheelsNew(I) = YWheels(I) + Abs(Ymin)
    Next I
Else
    For I = 1 To NWheels
    YWheelsNew(I) = YWheels(I) - Abs(Ymin)
    Next I
End If

SingleWheel = GrossWeight * PcntOnMainGears / 100 / NMainGears / NWheels
DesignInput.Angle = 0
Angle = True
S1Max = GoldenSearch(YWheelsNew(1), YRange, XMin, Angle)

DesignInput.Angle = 90
Angle = False
S2Max = GoldenSearch(XWheelsNew(1), XRange, XMin, Angle)

If S1Max > S2Max Then
    MaxStressNonStdGear = S1Max
Else
    MaxStressNonStdGear = S2Max
End If

End Function

Public Function Stress1Wheel(trans As Double, longit As Double) As Double
Dim s1a As Double, s2a As Double, s3a As Double
Dim GearLoad As Double

If trans = 0 And longit = 0 Then

'  Single
  DesignInput.GearLoad = SingleWheel
'  DesignInput.libGear = "B"
  DesignInput.Delta = 0
  DesignInput.GearLoad = SingleWheel
  DesignInput.XNA = 1: DesignInput.XNB = 1: DesignInput.XNC = 1: DesignInput.XND = 1
  DesignInput.XLA = 0: DesignInput.XLB = 0: DesignInput.XLC = 0: DesignInput.XLD = 0
  Stress1Wheel = EdgeStress(DesignInput)
  
ElseIf longit = 0 Then

'  Single
  DesignInput.GearLoad = SingleWheel
'  DesignInput.libGear = "B"
  DesignInput.Delta = 0
  DesignInput.XNA = 1: DesignInput.XNB = 1: DesignInput.XNC = 1: DesignInput.XND = 1
  DesignInput.XLA = 0: DesignInput.XLB = 0: DesignInput.XLC = 0: DesignInput.XLD = 0
  s1a = EdgeStress(DesignInput)
'  Twin
  DesignInput.GearLoad = SingleWheel * 2
'  DesignInput.libGear = "D"
  DesignInput.Delta = 0
  DesignInput.XNA = 2: DesignInput.XNB = 1: DesignInput.XNC = 1: DesignInput.XND = 1
  DesignInput.XLA = trans: DesignInput.XLB = 0: DesignInput.XLC = 0: DesignInput.XLD = 0
  s2a = EdgeStress(DesignInput)
  Stress1Wheel = s2a - s1a

ElseIf trans = 0 Then

'  Single
  DesignInput.GearLoad = SingleWheel
'  DesignInput.libGear = "B"
  DesignInput.Delta = 0
  DesignInput.XNA = 1: DesignInput.XNB = 1: DesignInput.XNC = 1: DesignInput.XND = 1
  DesignInput.XLA = 0: DesignInput.XLB = 0: DesignInput.XLC = 0: DesignInput.XLD = 0
  s1a = EdgeStress(DesignInput)
'  Single Tandem
  DesignInput.GearLoad = SingleWheel * 2
'  DesignInput.libGear = "E"
  DesignInput.Delta = 0
  DesignInput.XNA = 1: DesignInput.XNB = 1: DesignInput.XNC = 2: DesignInput.XND = 1
  DesignInput.XLA = 0: DesignInput.XLB = 0: DesignInput.XLC = longit: DesignInput.XLD = 0
  s2a = EdgeStress(DesignInput)
  Stress1Wheel = s2a - s1a

Else '(longit<>0 , trans<>0)

  If DesignInput.Angle = 0 Then
'    Single displaced
    DesignInput.GearLoad = SingleWheel
'    DesignInput.libGear = "B"
    DesignInput.Delta = trans
    DesignInput.XNA = 1: DesignInput.XNB = 1: DesignInput.XNC = 1: DesignInput.XND = 1
    DesignInput.XLA = 0: DesignInput.XLB = 0: DesignInput.XLC = 0: DesignInput.XLD = 0
    s1a = EdgeStress(DesignInput)
'    Single Tandem
    DesignInput.GearLoad = SingleWheel * 2
'    DesignInput.libGear = "E"
    DesignInput.Delta = 0
    DesignInput.XNA = 1: DesignInput.XNB = 1: DesignInput.XNC = 2: DesignInput.XND = 1
    DesignInput.XLA = 0: DesignInput.XLB = 0: DesignInput.XLC = longit: DesignInput.XLD = 0
    s2a = EdgeStress(DesignInput)

  Else
  
'    Single displaced
    DesignInput.GearLoad = SingleWheel
'    DesignInput.libGear = "B"
    DesignInput.Delta = longit
    DesignInput.XNA = 1: DesignInput.XNB = 1: DesignInput.XNC = 1: DesignInput.XND = 1
    DesignInput.XLA = 0: DesignInput.XLB = 0: DesignInput.XLC = 0: DesignInput.XLD = 0
    s1a = EdgeStress(DesignInput)
'    Twin
    DesignInput.GearLoad = SingleWheel * 2
'    DesignInput.libGear = "D"
    DesignInput.Delta = 0
    DesignInput.XNA = 2: DesignInput.XNB = 1: DesignInput.XNC = 1: DesignInput.XND = 1
    DesignInput.XLA = trans: DesignInput.XLB = 0: DesignInput.XLC = 0: DesignInput.XLD = 0
    s2a = EdgeStress(DesignInput)
  
  End If

'  Twin Tandem (OK!)
  DesignInput.GearLoad = SingleWheel * 4
'  DesignInput.libGear = "F"
  DesignInput.Delta = 0
  DesignInput.XNA = 2: DesignInput.XNB = 1: DesignInput.XNC = 2: DesignInput.XND = 1
  DesignInput.XLA = trans: DesignInput.XLB = 0: DesignInput.XLC = longit: DesignInput.XLD = 0
  s3a = EdgeStress(DesignInput)
  Stress1Wheel = s3a - s2a - s1a
  
End If

End Function
Public Function GoldenSearch(WheelCord As Double, Range As Double, XMin As Double, ZeroDeg As Boolean) As Double
'adopted from Numerical Recipes - The Art of Scientific Computing, 1986 page 282
Dim X0 As Double, X1 As Double, X2 As Double, X3 As Double
Dim F0 As Double, F1 As Double, F2 As Double, F3 As Double
Dim tempX2 As Double
Const R As Double = 0.61803399
Const C As Double = 1 - R
Const TOL As Double = 0.01
Dim AX As Double, BX As Double, CX As Double

AX = -Range * 0.25
BX = WheelCord
CX = Range * 1.25

X0 = AX
X3 = CX

If (Abs(CX - BX) > Abs(BX - AX)) Then
    X1 = BX
    X2 = BX + C * (CX - BX)
Else
    X2 = BX
    X1 = BX - C * (BX - AX)
End If

F1 = -StressNWheels(X1, ZeroDeg)
F2 = -StressNWheels(X2, ZeroDeg)
   
1:   If (Abs(X3 - X0) > TOL * (Abs(X1) + Abs(X2))) Then
       If (F2 < F1) Then
       X0 = X1
       X1 = X2
       X2 = R * X1 + C * X3
       F0 = F1
       F1 = F2
       F2 = -StressNWheels(X2, ZeroDeg)
       Else
       X3 = X2
       X2 = X1
       X1 = R * X2 + C * X0
       F3 = F2
       F2 = F1
       F1 = -StressNWheels(X1, ZeroDeg)
    End If
GoTo 1
End If
       
If (F1 < F2) Then
   GoldenSearch = -F1
   XMin = X1
Else
   GoldenSearch = -F2
   XMin = X2
End If

End Function
Public Function RTBIS(X1 As Double, X2 As Double, XACC As Double, FVal As Double, Conf As Boolean, MaxStress As Double)
'adopted from Numerical Recipes - The Art of Scientific Computing, 1986 page 247
Dim JMAX As Integer, J As Integer
Dim FMID As Double, F As Double, DX As Double, XMID As Double

  JMAX = 200 ' 40 ' GFH 07/14/08.
  RTBIS = X1
  DX = X2 - X1
  DX = DX * 0.5
  XMID = RTBIS + DX
  FMID = StressValue(XMID, Conf)
  RTBIS = XMID

  For J = 1 To JMAX

    If Not ComputingRigid Then Exit Function

    DX = DX * 0.5
    
    If (FMID > MaxStress) Then
      XMID = RTBIS + DX
    Else
      XMID = RTBIS - DX
    End If

    FMID = StressValue(XMID, Conf)
    RTBIS = XMID

'   Debug.Print "J=", J, "  XMID=", Round(XMID, 3)

    If (Abs(DX) <= XACC Or FMID = 0) Then 'quit
      J = JMAX
    End If

  Next J

  FVal = FMID

End Function

Public Function StressValue(Thickness As Double, StdConfiguration As Boolean) As Double

   DesignInput.Thickness = Thickness

    If StdConfiguration Then
        StressValue = EdgeStress(DesignInput)
    Else
        StressValue = MaxStressNonStdGear()
    End If

End Function


Public Sub disclaimerACNComp()
    Dim NL As String
    Dim S$

    NL = Chr(13) & Chr(10)  ' Carriage return & line feed.
    S$ = "This software is provided as a tool for computing flexible and rigid Aircraft"
    S$ = S$ + NL + "Classification Numbers (ACNs) quickly, using the International Civil Aviation"
    S$ = S$ + NL + "Organization (ICAO) methodology. It is not an official FAA standard, specification or"
    S$ = S$ + NL + "regulation, nor is it intended as a substitute for official guidance on reporting ACNs"
    S$ = S$ + NL + "contained in ICAO publications. It is believed that the ACNs computed by this program"
    S$ = S$ + NL + "are generally consistent with those reported by ICAO for specific aircraft, but in the"
    S$ = S$ + NL + "event of conflict, the latter shall be considered authoritative."
    
    S$ = S$ + NL + ""
    
    S$ = S$ + NL + "In 1997, ICAO's ACN/PCN Study Group recommended that an interim alpha factor of"
    S$ = S$ + NL + "0.72 at 10,000 coverages be used for computing ACN for 6-wheeled landing gears."
    S$ = S$ + NL + "By default, the ACN values for 6-wheel aircraft gear configuration including"
    S$ = S$ + NL + "the Boeing B-777 airplane are computed using this interim modified alpha factor."

    MsgBox S$, 0, "DISCLAIMER"

End Sub

Public Sub disclaimerPvmtThick()
    Dim NL As String
    Dim S$

    NL = Chr(13) & Chr(10)  ' Carriage return & line feed.
    S$ = "Default alpha factors used to compute flexible pavement thicknesses"
    S$ = S$ + NL + "are taken from the chart in Figure 3, ""Load Repetitions Factors"
    S$ = S$ + NL + "vs. Coverages,"" in Appendix 2 of FAA AC 150/5320-6D, "
    S$ = S$ + NL + """Airport Pavement Design and Evaluation."""
    
    S$ = S$ + NL + ""
    
    S$ = S$ + NL + "This gives conservative thickness designs compared to using"
    S$ = S$ + NL + "the interim alpha factor of 0.72 for computing 6-wheel ACN values."

    MsgBox S$, 0, "DISCLAIMER"
    
End Sub

