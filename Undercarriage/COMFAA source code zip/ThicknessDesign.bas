Attribute VB_Name = "modEdgeThicknessDesign"
'**************************************************************
'Module written by Izydor Kawa
'Procedure ThicknessDesign() finds design thickness for which
' calculated slab edge stress <= adjusted allowable stress
'Last Update April 9, 2001
'**************************************************************
'
Option Explicit
Private AllowableStress As Double, BoxVar As Double
Private Alpha As Double, I As Double, MaxStress As Double, Stress As Double
Private StdConfiguration As Boolean
Public SingleWheel As Double
Public Sub ThicknessDesign111() 'Tests for COMFAA results
I = 13.07
DesignInput.Thickness = I
StdConfiguration = True

'DesignInput.Angle = 0
'DesignInput.NOG = 1
Call InitVar(I, StdConfiguration, DesignInput)
Stress = EdgeStress(DesignInput)
ACNRigidk(1) = InputkValue
RigidThickness(1) = I
RigidThickness(2) = Stress

End Sub

Public Sub ThicknessDesign()

Dim X1 As Double, X2 As Double, XACC As Double
Dim FVal As Double
Dim d1 As Double, D2 As Double, d3 As Double, D4 As Double, d5 As Double, D6 As Double
Dim d7 As Double, D8 As Double, d9 As Double, D10 As Double, d11 As Double
Dim dmax As Double, dmin As Double, i1 As Integer, i2 As Integer, aa As Double

If WheelPosChanged Then
  EditWheels = True
End If

If EditWheels And (Symmetry = NoSymmetry Or Symmetry = XSymmetry _
    Or Symmetry = YSymmetry) Then
    
  StdConfiguration = False

Else

'     libGear$(libIndex) = "N") Or _ GFH 03/13/06. Removed from If statement because
'     libB() replaced with libBF and libBR for later B777s with unequal tandem spacings.
'     libB() is used in Sub InitVar, so, for now, compute stress wheel-by-wheel.

  If (libGear$(libIndex) = "A" Or _
     libGear$(libIndex) = "B" Or _
     libGear$(libIndex) = "D" Or _
     libGear$(libIndex) = "Y" Or _
     libGear$(libIndex) = "E" Or _
     libGear$(libIndex) = "F" Or _
     libGear$(libIndex) = "H" Or _
     libGear$(libIndex) = "J" Or _
     libGear$(libIndex) = "X") And _
     Not EditWheels And _
     Not LibACGroupName$(ILibACGroup) = "External Library" Then

    StdConfiguration = True
  Else

    If (NWheels = 2) And Symmetry = XYSymmetry Then
      d1 = Abs(XWheels(2) - XWheels(1))
      D2 = Abs(YWheels(2) - YWheels(1))

      If D2 > d1 Then
        libGear$(libIndex) = "D"
        libTT(libIndex) = D2
      Else
        libGear$(libIndex) = "E"
        libTY(libIndex, 2) = XWheels(2)
        libTY(libIndex, 1) = XWheels(1)
      End If

      StdConfiguration = True
    Else
      StdConfiguration = False
    End If

    If (NWheels = 6) And Symmetry = XYSymmetry Then
        
      'longitudinal
      d1 = Abs(XWheels(2) - XWheels(1))
      D2 = Abs(XWheels(3) - XWheels(1))
      d3 = Abs(XWheels(4) - XWheels(1))
      D4 = Abs(XWheels(5) - XWheels(1))
      d5 = Abs(XWheels(6) - XWheels(1))
               
      dmax = 0
      If d1 > dmax Then:  dmax = d1:
      If D2 > dmax Then:  dmax = D2:
      If d3 > dmax Then:  dmax = d3:
      If D4 > dmax Then:  dmax = D4:
      If d5 > dmax Then:  dmax = d5:
      If D6 > dmax Then:  dmax = D6:
                                  
      libB(libIndex) = dmax / 2 'Longitudinal spacing between tires
        
      d1 = Abs(YWheels(2) - YWheels(1))
      D2 = Abs(YWheels(3) - YWheels(1))
      d3 = Abs(YWheels(4) - YWheels(1))
      D4 = Abs(YWheels(3) - YWheels(2))
      d5 = Abs(YWheels(4) - YWheels(2))
      D6 = Abs(YWheels(4) - YWheels(3))
                
      dmax = 0
      If d1 > dmax Then:  dmax = d1:
      If D2 > dmax Then:  dmax = D2:
      If d3 > dmax Then:  dmax = d3:
      If D4 > dmax Then:  dmax = D4:
      If d5 > dmax Then:  dmax = d5:
      If D6 > dmax Then:  dmax = D6:
        
      libTT(libIndex) = dmax 'Transverse spacing between tires
        
      If libB(libIndex) > 2 And libTT(libIndex) > 1 Then  'resolution is to 1 inch
        libGear$(libIndex) = "N"
        StdConfiguration = True
      Else
        libGear$(libIndex) = ""
        StdConfiguration = False
      End If
                        
    Else
      If NWheels = 6 Then
        StdConfiguration = False
      End If
    End If

'***********************************************************************************

    If (NWheels = 4) And Symmetry = XYSymmetry Then
         
      'longitudinal
      d1 = Abs(XWheels(2) - XWheels(1))
      D2 = Abs(XWheels(3) - XWheels(1))
      d3 = Abs(XWheels(4) - XWheels(1))
      D4 = Abs(XWheels(3) - XWheels(2))
      d5 = Abs(XWheels(4) - XWheels(2))
      D6 = Abs(XWheels(4) - XWheels(3))
       
      dmax = 0
      If d1 > dmax Then:  dmax = d1:
      If D2 > dmax Then:  dmax = D2:
      If d3 > dmax Then:  dmax = d3:
      If D4 > dmax Then:  dmax = D4:
      If d5 > dmax Then:  dmax = d5:
      If D6 > dmax Then:  dmax = D6:
      
      libB(libIndex) = dmax 'Longitudinal spacing between tires
         
      d1 = Abs(YWheels(2) - YWheels(1))
      D2 = Abs(YWheels(3) - YWheels(1))
      d3 = Abs(YWheels(4) - YWheels(1))
      D4 = Abs(YWheels(3) - YWheels(2))
      d5 = Abs(YWheels(4) - YWheels(2))
      D6 = Abs(YWheels(4) - YWheels(3))
         
      dmax = 0
      If d1 > dmax Then:  dmax = d1:
      If D2 > dmax Then:  dmax = D2:
      If d3 > dmax Then:  dmax = d3:
      If D4 > dmax Then:  dmax = D4:
      If d5 > dmax Then:  dmax = d5:
      If D6 > dmax Then:  dmax = D6:
                  
      libTT(libIndex) = dmax 'Transverse spacing between tires
    
      If libB(libIndex) > 1 And libB(libIndex) > 1 Then  'resolution is to 1 inch
        libGear$(libIndex) = "F"
        StdConfiguration = True
      Else
        If libB(libIndex) = 0 Then
         
          d1 = Abs(YWheels(2) - YWheels(1))
          D2 = Abs(YWheels(3) - YWheels(1))
          d3 = Abs(YWheels(4) - YWheels(1))
          D4 = Abs(YWheels(3) - YWheels(2))
          d5 = Abs(YWheels(4) - YWheels(2))
          D6 = Abs(YWheels(4) - YWheels(3))
         
          dmax = 0
          If d1 > dmax Then:  dmax = d1: i1 = 1
          If D2 > dmax Then:  dmax = D2: i1 = 2
          If d3 > dmax Then:  dmax = d3: i1 = 3
          If D4 > dmax Then:  dmax = D4: i1 = 4
          If d5 > dmax Then:  dmax = d5: i1 = 5
          If D6 > dmax Then:  dmax = D6: i1 = 6
                
          Select Case i1
                Case 1
                    aa = Abs(YWheels(4) - YWheels(3))
                Case 2
                    aa = Abs(YWheels(4) - YWheels(2))
                Case 3
                    aa = Abs(YWheels(3) - YWheels(2))
                Case 4
                    aa = Abs(YWheels(4) - YWheels(1))
                Case 5
                    aa = Abs(YWheels(3) - YWheels(1))
                Case 6
                    aa = Abs(YWheels(2) - YWheels(1))
          End Select
                
          libTX(libIndex, 3) = aa / 2
          libTX(libIndex, 2) = -aa / 2
          libTX(libIndex, 4) = dmax / 2
          libGear$(libIndex) = "Y"
          StdConfiguration = True
            
        Else
          libGear$(libIndex) = ""
          StdConfiguration = False
        End If
      End If
        
    Else
      If NWheels = 4 Then
        StdConfiguration = False
      End If
    End If
      
  End If

End If

If InputkValue > 0 Then

  AllowableStress = ConcreteFlexuralStrength / 1.3 / 0.75
'  AllowableStress = 700 / 1.3 / 0.75
  MaxStress = AllowableStress 'MaxStress - Adjusted Allowable Stress
    
'   ikawa seattle
    If frmGear.optCalcMode(5).Value = True Then
        
      I = frmGear.txtEvaluationThickness.Text
      Call InitVar(I, StdConfiguration, DesignInput)
        
      If StdConfiguration Then
        Stress = EdgeStress(DesignInput)
      Else
        Stress = MaxStressNonStdGear
      End If
        
      frmGear.txtStress.Text = Round(Stress, 2)
      Exit Sub
        
    End If
    
  I = 8

  Do
    I = I + 4
    DesignInput.Thickness = I
    If StdConfiguration Then
        Call InitVar(I, StdConfiguration, DesignInput)
        Stress = EdgeStress(DesignInput)
    Else
        Call InitVar(I, StdConfiguration, DesignInput)
        Stress = MaxStressNonStdGear
    End If
  Loop While (MaxStress < Stress)
' Debug.Print "MaxStress, Stress = "; MaxStress; Stress
  If I > 12 Then
    X1 = I - 4
    X2 = I
  Else
    X1 = 0
    X2 = I
  End If

  XACC = 0.0001 ' 0.01 ' GFH 07/14/08.

  I = RTBIS(X1, X2, XACC, FVal, StdConfiguration, MaxStress)
  DesignInput.Thickness = I        'IK 10/06/08
  Stress = EdgeStress(DesignInput) 'IK 10/06/08

  If Not ComputingRigid Then
    Exit Sub
  End If

  If Coverages >= 5000 Then
    Alpha = 1 + 0.15603 * Log10(Coverages / 5000)
  Else
    Alpha = 1 + 0.07058 * Log10(Coverages / 5000)
  End If
  
  I = I * Alpha
  ACNRigidk(1) = InputkValue
  RigidThickness(1) = I
  RigidStress(1) = MaxStress / XPRES ' Convert to MPa.
'  Debug.Print "Alpha = "; Alpha; "Thick = "; I; "Coverages = "; Coverages; "I = "; I / Alpha

  Call WriteOutputGrid
  Call WriteRigidOutputData
  
  With UnitsOut
    If UnitsOut.Metric Then S = "Metric Units" Else S$ = "English Units"
    SSS$ = JobTitle$ & ", " & S$ & vbCrLf & vbCrLf
    SSS$ = SSS$ & "  WEIGHT    PCNT ON MAIN    NO. OF WHLS.  CONTACT AREA   CONTACT PRESSURE" & vbCrLf
    SSS$ = SSS$ & LPad(9, Format(GrossWeight * .pounds, .poundsFormat))
    SSS$ = SSS$ & LPad(12, Format(PcntOnMainGears, "0.00"))
    SSS$ = SSS$ & LPad(13, Format(NWheels, "0"))
    SSS$ = SSS$ & LPad(17, Format(TireContactArea * .squareInch, .squareInchFormat))
    SSS$ = SSS$ & LPad(17, Format(TirePressure * .psi, .psiFormat)) & vbCrLf & vbCrLf
    SSS$ = SSS$ & "Coordinates of wheels" & vbCrLf
    SSS$ = SSS$ & "           End ACN" & vbCrLf
    SSS$ = SSS$ & " No.      X       Y" & vbCrLf
    For I = 1 To NWheels
      SSS$ = SSS$ & LPad(3, Format(I, "0"))
      SSS$ = SSS$ & LPad(10, Format(XWheels(I) * .inch, .inchFormat))
      SSS$ = SSS$ & LPad(8, Format(YWheels(I) * .inch, .inchFormat)) & vbCrLf
    Next I
    SSS$ = SSS$ & vbCrLf
    SSS$ = SSS$ & " SUPPORT   PAVEMENT   " & vbCrLf
    SSS$ = SSS$ & " K VALUE   THICKNESS  STRESS" & vbCrLf
    SSS$ = SSS$ & LPad(8, Format(InputkValue * .pci, .pciFormat))
    SSS$ = SSS$ & LPad(10, Format(RigidThickness(1) * .inch, .inchFormat))
    SSS$ = SSS$ & LPad(10, Format(Stress * .psi, .psiFormat))
    SSS$ = SSS$ & vbCrLf
    ACNRigidOutputText$ = SSS$
 End With

End If 'InputkValue > 0 Then

End Sub

Function WheelPosChanged() As Boolean
Dim I As Integer

WheelPosChanged = False

If NWheels <> libNTires(libIndex) Then WheelPosChanged = True

For I = 1 To NWheels
  If XWheels(I) <> libTY(libIndex, I) Then WheelPosChanged = True
  If YWheels(I) <> libTX(libIndex, I) Then WheelPosChanged = True
Next I

End Function

Sub InitVar(Thick As Double, stdconfig As Boolean, DesignInput As InputData)

DesignInput.Thickness = Thick
DesignInput.XK = InputkValue
DesignInput.Angle = 0
DesignInput.TirePressure = TirePressure
DesignInput.Delta = 0

If stdconfig Then
    DesignInput.NOG = 2
    DesignInput.GearLoad = GrossWeight * PcntOnMainGears / 100 / NMainGears

Select Case libGear$(libIndex)
Case "A", "B" 'Single Wheel (OK!)
    DesignInput.XNA = 1#
    DesignInput.XNB = 1#
    DesignInput.XNC = 1#
    DesignInput.XND = 1#
    DesignInput.XLA = 0#
    DesignInput.XLB = 0#
    DesignInput.XLC = 0#
    DesignInput.XLD = 0#
Case "D"     'Twin (OK!)
    DesignInput.XNA = 2#
    DesignInput.XNB = 1#
    DesignInput.XNC = 1#
    DesignInput.XND = 1#
    DesignInput.XLA = libTT(libIndex)  'Spacing between two tires in a dual
    DesignInput.XLB = 0#
    DesignInput.XLC = 0#
    DesignInput.XLD = 0#
Case "Y"    'Dual Twin
    DesignInput.XNA = 2#
    DesignInput.XNB = 2#
    DesignInput.XNC = 1#
    DesignInput.XND = 1#
    'Transverse center to center distance between two inside tires
    DesignInput.XLA = libTX(libIndex, 3) - libTX(libIndex, 2)
    'Transverse center to center spacing between tires in a dual
    DesignInput.XLB = libTX(libIndex, 4) - libTX(libIndex, 3)
    DesignInput.XLC = 0#
    DesignInput.XLD = 0#
Case "E" 'Single Tandem
    DesignInput.XNA = 1#
    DesignInput.XNB = 1#
    DesignInput.XNC = 2#
    DesignInput.XND = 1#
    DesignInput.XLA = 0#
    DesignInput.XLB = 0#
    ' Distance between tires
    DesignInput.XLC = Abs(libTY(libIndex, 2) - libTY(libIndex, 1))
    DesignInput.XLD = 0#
Case "F", "H", "J" 'Twin Tandem (OK!)
    DesignInput.XNA = 2#
    DesignInput.XNB = 1#
    DesignInput.XNC = 2#
    DesignInput.XND = 1#
    DesignInput.XLA = libTT(libIndex)  'Transverse spacing between tires
    DesignInput.XLB = 0#
    DesignInput.XLC = libB(libIndex)  'Longitudinal spacing between tires
    DesignInput.XLD = 0#
Case "X" 'Dual Twin Tandem
    DesignInput.XNA = 2#
    DesignInput.XNB = 2#
    DesignInput.XNC = 2#
    DesignInput.XND = 1#
     'Transverse spacing between inside tires in the gear
    DesignInput.XLA = libTX(libIndex, 3) - libTX(libIndex, 2)
     'Transverse spacing between tires in a dual set
    DesignInput.XLB = libTX(libIndex, 4) - libTX(libIndex, 3)
     'Longitudinal spacing between tires in a dual set
    DesignInput.XLC = libTY(libIndex, 5) - libTY(libIndex, 1)
    DesignInput.XLD = 0#
Case "N" 'Triple Twin Tandem (OK!)
    DesignInput.XNA = 2#
    DesignInput.XNB = 1#
    DesignInput.XNC = 3#
    DesignInput.XND = 1#
    DesignInput.XLA = libTT(libIndex) 'Tranvser spacing between tires
    DesignInput.XLB = 0#
    DesignInput.XLC = libB(libIndex)  'Longitudinal spacing between tires
    DesignInput.XLD = 0#
Case "OTHERS" 'Others
'ACNComp calculates slab edge stress for "others" gear configurations
'using the concept of superposition
End Select

Else
    DesignInput.NOG = 1
End If

End Sub
