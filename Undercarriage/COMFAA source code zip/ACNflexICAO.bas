Attribute VB_Name = "ACNFlexBAS"
Option Explicit
  
  Public FlexDesignESWL As Double

'   V = CBR / ESWL     U = t / SQR(A)    Interpolation table in Sub StoreCurveFits().
'  Public U(170)   As Double, V(170)   As Double, SSS$
  Public U(180)   As Double, V(180)   As Double, SSS$ ' GFH 09/10/09.
  Dim X(32)       As Double, Y(32)    As Double
  Dim Rad(32)     As Double, RAD2(32) As Double
  Dim PR(32)      As Double, PRS(32)  As Double
  Dim XG()        As Double, YG()     As Double, S()        As Double
  Dim Z(30)       As Double, Z2(30)   As Double
  Dim XLOC(30, 6) As Double
  Dim YLOC(30, 6) As Double
  Dim SD(30, 6)   As Double
  Dim C(5)        As Double, ESWL(30) As Double, CBR(30, 7) As Double
  Dim SN2(50)     As Double, CS(50)   As Double, KTITLE$
  Dim XINCH       As Double, XPRES    As Double, XPOUND     As Double, PI    As Double
  Dim Continue    As Integer, NW      As Integer
  Dim I           As Integer, J       As Integer
  Dim K           As Integer, L       As Integer, M         As Integer
  Dim XK          As Double, YK       As Double
  Dim XMax        As Double, YMax     As Double, MAXX       As Integer, MAXY As Integer
  Dim GX          As Double, GY       As Double, DGX        As Double, DGY   As Double
  Dim KX          As Integer, KY      As Integer
  Dim IPR         As Integer, IPRS    As Integer
  Dim AMASS       As Double, PRSW     As Double, PMMG       As Double, AMLG  As Double
  Dim WT          As Double, TLMG     As Double, TLSMG      As Double
  Dim WN          As Double, TLSW     As Double, ARESW      As Double
  Dim RESW        As Double, PESW     As Double, CAREA      As Double
  Dim RESW2       As Double, DZ       As Double, NAL        As Integer
  Dim DPE         As Double, ICBR     As Integer, KZ        As Integer
  Dim PID40       As Double, PID20    As Double, PID10      As Double, PID   As Double
  Dim PHI         As Double, SINE     As Double
  Dim YI          As Double, XJ       As Double, Z2K        As Double, SS    As Double
  Dim RADL        As Double, RAD2L    As Double, PRL        As Double
  Dim SJIK        As Double, XLG      As Double, R          As Double
  Dim R2          As Double, RC       As Double
  Dim YLG         As Double, SAR      As Double, ERP        As Double, ERP2  As Double
  Dim ERM         As Double, ERM2     As Double, DW2        As Double
  Dim DW1         As Double, DW3      As Double
  Dim AC          As Double, SPA      As Double, SPA2       As Double
  Dim SSA         As Double, SSA2     As Double
  Dim IX          As Integer, IY      As Integer, IZ        As Integer
  Dim IXM         As Integer, IYM     As Integer
  Dim EMAX        As Double, SRAREA   As Double, KS         As Integer, V1   As Double
  Dim UL          As Double, U1       As Double, Mode       As Integer
  Dim ACN         As Double, Temp     As Double
  
  Dim LengthConvert As Double, PressConvert As Double, WeightConvert As Double


' DIM ITER AS INTEGER, ITCT AS INTEGER
' DECLARE FUNCTION ALOG10! (X!)
' DECLARE SUB CVRG (ITER!, FCTN!, TRGT!, Y111!, MODE!, ITCT!)
'         3-280
'         PROGRAMME LISTING
         
'         COMPUTER PROGRAMME NO. 2
         
'         FLEXIBLE PAVEMENT ACN
         
'     PROGRAM ACNFIT
' PROGRAM ACNFI IS IN INT. UNITS
'
' APRIL 1979 MODIFICATION TO COMPUTE ACN VALUES FOR STANDARD
'   SUBGRADES           ACN/PCN METHOD.
'
'   ********* 1 MAR 69
' WES MOD 41 - G2 - R0 - 144
'   PROG. 41-20-001 GROUND FLOTATI0N DESIGN *** BOEING AIRCRAFT
'   DOCUMENT 06-4088TN TRANSPORT DIVISION, BOX 707, RENTON, WASH.
'
'   NOTE   TO THE ORIGINAL BOEING PROGRAM THE PAVEMENT DESIGN
' DIVISION S+PL, WES HAS MADE SEVERAL CHANGES. THE THICKNESS
' SOLUTION WAS REPLACED WITH AN INTERPOLATION SCHEME. THE
' THICKNESS IS NOW DERIVED FROM CBR/P VS. T/SQR(A) CURVE.
' THE OLD F(PERCENT DESIGN THICKNESS) HAS BEEN REPLACED
' WITH AN ALPHA VALUE. THE TERM COVERAGES IS REPLACED WITH
' PASS LEVELS.
' THIS PROGRAM 'CHANG4' IS IDENTICAL TO 'CHANG2'
' WITH ONE EXCEPTION. AN OPTION IS AVAILABLE TO RUN 1-7
'   PASS LEVELS.
'
'   32        NN NUMBER OF WHEELS
'   32        X(NW)   X COORDINATE CM CM
'   32        Y(NW)   Y COORDINATE CM CM
'   32        RAD(NW) RADIUS CM CM
'   32        RAD2(NW)        RADIUS SQUARED  CM
'   32        PR(NW)          pressure      MPA
'   32        PRS(NW)         PRESSURE      KPA
'   GX X COORD 0F GRID(DISPLC)       DGX DELTA X
'   GX Y COORD OF GRID(DISPLC)       DGY DELTA Y
'   XK=KX NUMBER GRID LINKS (SIZE)
'   YK=KY NUMBER GRID LINKS (SIZE)
'   ZK=KZ NUMBER OF DEPTHS
'   10*                         PHI ANGLE USED IN INTEGRATION
'   10*                         CS COSINE OF PHI
'   10*                         SN2 SQ OF SINE OF PHI
'   10,10,8                     S(I,J,K) DISPLACEMENT
'   6                         KKZ NUMBER OF MAX. ORDERED DISPLACEMENTS/DEPTH
' IPR NUMBER SETS OF MASS AND TYRE PRESSURE
'   5 C ITH COVERAGE VALUE
'   8 Z DEPTH OF ITH WHEEL
'   8 Z2 Z(I) SQUARED
'
'         25 /10 /85
'           No. 1
'         Part 3.- Pavements                              3-281
         
'    X(NW),Y(NW), RAD(NW), RAD2(NW), PR(NW), PRS(NW)
'    XG(XK), YG(YK), S(XK, YK, ZK)
'    Z(ZK), Z2(ZK), XLOC(ZK, KKZ), YLOC(ZK, KKZ), SD(ZK, KKZ)
'    C(5) , ESWL(ZK), CBR(ZK, 7)
  
  Dim SCBR(4)   As Double
  Dim B(7)      As Double, NCC(7)  As Integer
'  Dim U(170), V(170) Public in Declarations.
  Dim TA(30, 7) As Double
  Dim ITER      As Boolean, ITCT   As Integer, FCTN As Double, TRGT As Double
  Dim PESWL(4)  As Double, PCBR(4) As Double, PZ(4) As Double
  Dim PACN(4)  As Double
'  Dim Z(10) As Double
'      Open "CONS:" For Output As #3
'      OPEN "LPT1:" FOR OUTPUT AS #3

'   V = CBR / ESWL     U = t / SQR(A).
  Const ZERO = 2E-20
'     INPUT FORMATS
'     OUTPUT FORMATS
'
'         25 /10/85
'         No. 1
'         3-282                                    Aerodrome Design Manual


Private Static Sub CVRG(ITER As Boolean, FCTN As Double, TRGT As Double, Y111 As Double, Mode, ITCT As Integer)
' DIM ITER AS INTEGER, ITCT AS INTEGER
' SUBROUTINE CVRG CONVERGES ON REFERENCE THICKNESS
  
  Dim X222 As Double, X333 As Double, Y222 As Double, Y333 As Double
  
  If (ITCT = 0) Then GoTo CVRG30
  ITCT = ITCT + 1
  If (ITCT > 100) Then GoTo CVRG40
' Decrease 0.001 for closer match to target CBR. GFH 02/11/04.
' Left at 0.001 to be compatible with other implementations of the program.
  If (Abs((FCTN - TRGT) / TRGT) < 0.001) Then GoTo CVRG40
  If (Abs((Y222 - Y111) / Y111) < 0.001) Then GoTo CVRG40
  If (FCTN < TRGT) Then GoTo CVRG10
  Y222 = Y111
  X222 = FCTN
  GoTo CVRG20
CVRG10:
  Y333 = Y111
  X333 = FCTN
CVRG20:
  Y111 = Y222 + (Y333 - Y222) * (TRGT - X222) / (X333 - X222)
  Y111 = Y222 + (Y333 - Y222) * (ALOG10(TRGT) - ALOG10(X222)) / (ALOG10(X333) - ALOG10(X222))
  ITER = True
'  Debug.Print "ITER = True"
  Exit Sub   ' Not converged.
CVRG30:
  ITCT = 1
  Y222 = 0
  X222 = 0
  X222 = 300
  Y333 = Y111
  X333 = FCTN
  GoTo CVRG20
CVRG40:
  ITCT = 0
'  Debug.Print "ITER = False"
  ITER = False
  
End Sub

Public Sub ACNFlexComp()

  Dim I As Integer, NWMax As Integer, NCBRSubgrades As Integer
  Dim NIter As Integer, NIntegrate As Integer, DTemp As Double
  Dim SS As String
  Const KZStart As Integer = 2
               ' KZ(1 to 2) = indexes for surface and subgrade layers,
               ' only subgrade output, therefore KZStart = 2.
  On Error GoTo ACNFlexCompError

  I = XGridNPoints
  If YGridNPoints > I Then I = YGridNPoints
  ReDim XG(I), YG(I), S(I, I, 30)

  If Not ACN_mode_true Then
    Coverages = FlexibleCoverages
    If Not SamePcntAndPress Then
      TirePressure = GrossWeight * PcntOnMainGears / NWheels / NMainGears / TireContactArea / 100 'ik0333
    End If
  End If
  Call ReadInputData

      WT = AMASS * 9.815 / 1000       ' kg to kN ?  9.80665 ?
'      WT = AMASS * 9.80665 / 1000       ' kg to kN ?  9.80665 ?
      TLMG = WT * PMMG / 100          ' Weight on main gear.
      TLSMG = TLMG / AMLG             ' Weight on one gear.
      WN = NW                         ' Number of wheels on one gear.
      TLSW = TLSMG / WN               ' Weight on one wheel.
      ARESW = TLSW * 10000 / PRSW     ' Single wheel contact area, cm*cm.
'  To check FAA constant area method, DC-10-30 example.
'  ARESW = 331 * XINCH * XINCH
'  PRSW = TLSW * 10000 / ARESW
      RESW = Sqr(ARESW / PI)          ' Single wheel contact radius, cm.
      PESW = PRSW / 1000              ' Tyre pressure, MPa.
      CAREA = RESW * RESW * PI        ' Single wheel contact area, cm*cm.
      RESW2 = RESW * RESW             ' Single wheel radius squared, cm*cm.
      CAREA = CAREA / (XINCH * XINCH) ' Single wheel contact area, in*in.

'         25/10/85
'         No 1
'          3-284                                  Aerodrome Design Manual

      RESW2 = RESW2 / (XINCH * XINCH) ' Single wheel radius squared, in*in.
      For I = 1 To NW                 ' Loop over wheels on one gear.
        PRS(I) = PRSW                 ' Tyre pressure, kPA.
        PR(I) = PESW                  ' Tyre pressure, MPa.
100     Rad(I) = RESW                 ' Contact area, cm.
      Next I
      If (IPRS = 1) Then GoTo 120     ' First a/c.
      For I = 1 To NW
        X(I) = X(I) * XINCH
        Y(I) = Y(I) * XINCH
      Next I
      GX = GX * XINCH
      DGX = DGX * XINCH
      GY = GY * XINCH
      DGY = DGY * XINCH
      DZ = DZ * XINCH
      GoTo 150
 ' FOR ACN CALCULATIONS ONLY THE 10000 COVERAGE VALUE IS USED.
 ' ALPHA factor is defined as a function of PASSES. See note above.
 '                                     READ ND. OF PASS LEVELS.
 '                                   (CARD TYPE '9')
120   NAL = 1
 '  READ PASSES.      (CARD TYPE '10')
 '                                     READ ALPHAS       (CARD TYPE '11')
 ' FOR ACN CALCULATIONS SET ALPHA TO 10000 (COVERAGE) PASS VALUE.
      If frmGear.chkNew07Alphas.Value = vbChecked Then ' GFH 09/26/06.
        B(1) = New06AlphaFactorFromCurve(NW, Coverages)
      Else ' Old system.
        If Coverages = StandardCoverages Then
          If (NW = 1) Then          ' Default ALPHAs for ACN.
            B(1) = 0.995
          ElseIf (NW = 2) Then
            B(1) = 0.9
          ElseIf (NW = 4) Then
            B(1) = 0.825
          ElseIf (NW = 6) Then
              If ACN_mode_true Then  'ikawa 01/29/03
                 B(1) = 0.72
              Else
                 B(1) = 0.788
              End If
          ElseIf (NW = 8) Then
            B(1) = 0.755
          ElseIf (NW = 12) Then
            B(1) = 0.722
          ElseIf (NW = 16) Then
            B(1) = 0.705
          ElseIf (NW = 18) Then
            B(1) = 0.7
          ElseIf (NW = 24) Then
            B(1) = 0.689
          Else
            B(1) = AlphaFactorFromCurve(NW, Coverages, NWMax)
          End If
        Else
          B(1) = AlphaFactorFromCurve(NW, Coverages, NWMax)
        End If
      End If
      
      If InputAlpha > 0 Then B(1) = InputAlpha
      NCC(1) = 10000                    ' Default for ACN.
      SCBR(1) = 3                       ' Default CBRs for ACN.
      SCBR(2) = 6
      SCBR(3) = 10
      SCBR(4) = 15
150
' All printing moved to the end of the loop.
'        IF (IPRS.NE.1) THEN GOTO 160   Only one depth for ACN.
'          WRITE(6,907) ZK,DZ
'         25/10/85
'           No. 1
'         Part 3.- Pavements                         3-285
         
      For I = 1 To NW
        X(I) = X(I) / XINCH         ' Tire coordinates, in.
        Y(I) = Y(I) / XINCH
        PR(I) = PR(I) * XPRES       ' Tire pressure, psi.
        Rad(I) = Rad(I) / XINCH     ' Tire radius, in.
      Next I
      GX = GX / XINCH               ' Grid coordinates, in.
      DGX = DGX / XINCH
      GY = GY / XINCH
      DGY = DGY / XINCH
      RESW = RESW / XINCH           ' Double wheel contact radius, in.
      PESW = PESW * XPRES           ' Double wheel tire pressure, psi.
      DZ = DZ / XINCH               '
      DPE = 3 / (2 * PI * RESW * PESW)
      If InputCBR <> 0 Then
        NCBRSubgrades = 1
        SCBR(1) = InputCBR
      Else
        NCBRSubgrades = 4
      End If
180   For ICBR = 1 To NCBRSubgrades
        TRGT = SCBR(ICBR)
        frmACN!txtOutput.Text = "Computing ACN for CBR = " & Format(TRGT, "0")
        ITCT = 0             ' Initialized for use in SUB CVRG.
 '      FOR 'T' USE TWO DEPTHS - ZERO AND INCREMENT. INCREMENT WILL BE
 '      ESTIMATED, AND USED AS THE FIRST TRIAL IN THE ITERATION.
        KZ = 2
'  DZ = estimate of design depth from abbreviated CBR equation?
        DZ = Sqr(CAREA * PESW / 10 / SCBR(ICBR))
'       GFH 10-19-09, changed to better approximate the CBR equation. Now assumes that
'       the ESWL is equal to the individual wheel load times the number of wheels. Always
'       too high, but close for thick pavements. Also added the Alpha Factor, which is
'       known by now. May help convergence with the new Alphas because they curl over at
'       high coverages (thick pavements), unlike the old ones. Only missing the second
'       term under the square root sign.
'       This would be better but gives different answers under some circumstances.
'       So not as the standard and not used.
'        DZ = B(1) * Sqr(CAREA * PESW * CDbl(NW) / 8.1 / SCBR(ICBR))
 '      SET-UP OF GRID DEPTHS
        Z(1) = 0
        Z2(1) = 0
'        For I = 1 To KZ
        For I = KZStart To KZ        ' 2 to 2
          Z(I) = Z(I - 1) + DZ ' Z(2)  = 0.0 + DZ = DZ
          Z2(I) = Z(I) * Z(I)  ' Z2(2) = DZ * DZ
        Next I
        NIter = 0
        GoTo 210
200         ' Branch to here from SUB CVRG. New Z is computed
        NIter = NIter + 1
'        Debug.Print "Number of iterations = "; NIter; Z(KZ)
        Z2(KZ) = Z(KZ) * Z(KZ)   ' in CVRG. Iterate until converges.
210
        PID40 = 7.85398163397448E-02      ' Variable not used.
        PID20 = 0.15707963267949          ' Variable not used.
        PID10 = 0.314159265358979         ' Variable not used.
        NIntegrate = 10              ' Very accurate when = 2.
        PI = 3.14159265358979
        PID = 0.157079633
        PHI = -0.0785398163
        PID = PI / 2 / NIntegrate
        PHI = -PID / 2
'        PHI = -PID
 '      SET UP SIN(PHI) SQ AND COS(PHI)
        For I = 1 To NIntegrate ' 10
          PHI = PHI + PID      ' PID = PI / (2 * NIntegrate)   PI/20
          SINE = Sin(PHI)      ' Angles over one half of a quadrant (PI / 2).
          SN2(I) = SINE * SINE ' For deflection integration.
          CS(I) = Cos(PHI)
        Next I
 '      SET-UP RADII SQUARED
        For I = 1 To NW
         
'         25/10/85
'         No. 1
'         3-286                                  Aerodrome Design Manual
         
          RAD2(I) = Rad(I) * Rad(I)
        Next I
 '                                    SET-UP X-COORDS FOR GRID
        XG(1) = GX
        For I = 2 To KX
          XG(I) = XG(I - 1) + DGX
        Next I
 '                                    SET-UP Y-C00RDS FOR GRID
        YG(1) = GY
        For I = 2 To KY
          YG(I) = YG(I - 1) + DGY
        Next I
 '                                    ***********************************
        For I = 1 To KY       ' Loop over Y grid points.
          DoEvents
          YI = YG(I)          ' Y grid coordinate.
          For J = 1 To KX     ' Loop over X grid points.
            XJ = XG(J)        ' X grid coordinate.
'            For K = 1 To KZ   ' Loop over depths.
            For K = KZStart To KZ   ' Loop over depths.
              Z2K = Z2(K)     ' Z2(1) = 0.0; Z2(2) = DZ * DZ
              SS = 0
              For L = 1 To NW     ' Loop over wheels on one gear.
                RAD2L = RAD2(L)   ' Tire contact radius squared.
                RADL = Rad(L)     ' Tire contact radius.
                PRL = PR(L)       ' Tire contact pressure.
                SJIK = 0
                XLG = X(L) - XJ ' X distance from wheel to grid point.
                R2 = XLG * XLG
                YLG = Y(L) - YI ' Y distance from wheel to grid point.
                R2 = YLG * YLG + R2
                R = Sqr(R2) ' (Norm) distance from wheel to grid point.
                If (R - RADL) > 0 Then GoTo 290 ' 260,260,290
 ' SUM DISPLACEMENT DUE TO ONE WHEEL RAD. GREATER (THEN) THAN R
260             For M = 1 To NIntegrate '10      ' Grid inside contact area.
                  SAR = Sqr(RAD2L - R2 * SN2(M)) ' Deflection times a
                  RC = R * CS(M)              ' constant at an arbitrary
                  ERP = RC + SAR              ' point in a Bousinesq
                  ERP2 = ERP * ERP            ' half space with circular
                  ERM = SAR - RC              ' load. Computed directly
                  ERM2 = ERM * ERM            ' from elliptic integrals.
                  DW2 = 0
                  DW1 = Sqr(ERP2 + Z2K)
                  If (DW1 = 0) Then GoTo 270
                    DW2 = ERP2 / DW1
270               DW3 = 0
                  DW1 = Sqr(ERM2 + Z2K)
                  If (DW1 = 0) Then GoTo 280
                    DW3 = ERM2 / DW1
280               SJIK = SJIK + (DW2 + DW3) * PID
                Next M
                DoEvents
                If StopComputation Then
                  StopComputation = False
                  GoTo 4500
                End If
                GoTo 310
 ' SUM DISPLACEMENT DUE TO ONE WHEEL RAD. LESS THAN R
290             For M = 1 To NIntegrate '10
                  SAR = Sqr(R2 - RAD2L * SN2(M))  ' Bousinesq half-space
                  AC = RADL * CS(M)               ' again, but grid
                  SPA = AC + SAR                  ' point outside tire
                  SPA2 = SPA * SPA                ' contact area.
                  SSA = SAR - AC
                  SSA2 = SSA * SSA
300               SJIK = SJIK + AC / SAR * (SPA2 / Sqr(SPA2 + Z2K) - SSA2 / Sqr(SSA2 + Z2K)) * PID
                Next M
      
'         25/10/85
'         No 1
'         Part 3.- Pavements                         3-287
         
310             SJIK = SJIK * PRL
320             SS = SS + SJIK
330           Next L
'340             ' L, Wheel No.
              S(J, I, K) = SS ' Deflection, grid points J, I, and depth K.
350         Next K          ' K, Z
360       Next J          ' J, X
370     Next I          ' I, Y
 '        *******************************
'        For IZ = 1 To KZ             ' Now find maximum over all points.
        For IZ = KZStart To KZ             ' Now find maximum over all points.
          EMAX = -9.999999E-39
          For IX = 1 To KX
            For IY = 1 To KY
              If (S(IX, IY, IZ) - EMAX) > 0 Then ' 390,390,380
380             EMAX = S(IX, IY, IZ)
                IXM = IX
                IYM = IY
                SD(IZ, 1) = S(IX, IY, IZ) ' Maximum deflection at depth IZ.
              End If
390         Next IY
          Next IX
          S(IXM, IYM, IZ) = 9.999999E-39
400     Next IZ
 '      CALCULATE EQUIV. Double WHEEL LOAD
'        For I = 1 To KZ
        For I = KZStart To KZ
 ' This ESWL is not the ACN DSWL. Only used to find pavement thickness.
410       ESWL(I) = SD(I, 1) * Sqr(RESW2 + Z2(I)) ' Bous. for point under center
        Next I
        SRAREA = Sqr(CAREA) ' ESWL and a/c Double wheel areas the same.
        KS = 2
'        For J = 1 To KZ
        For J = KZStart To KZ
          TA(J, 1) = Z(J) / B(1)   ' From t = ALPHA * F(CBR, ESWL, A)
          V1 = TA(J, 1) / SRAREA   ' t(equiv) / SQR(A)
'    Debug.Print "J = "; J; Z(J); B(1); TA(J, 1); CAREA; PRSW
          If (V1 <> 0) Then GoTo 420
            CBR(J, 1) = U(1) * (ESWL(J) / CAREA)
            GoTo 470
420
'          For K = KS To 170           ' Find operating point on curve.
          For K = KS To 180           ' Find operating point on curve. GFH 09/10/09.
            If (V(K) > V1) Then GoTo 450
430       Next K
          Debug.Print "***** THICKNESS VALUE CONSIDERED EXCEEDS LIMITS OF CURVE *****  " & frmGear.lstLibFile.Text; V1; (ESWL(J) / CAREA)
'          GoTo 4500 ' GFH 09-10-09.
          CBR(J, 1) = U(180) * (ESWL(J) / CAREA) ' GFH 09-10-09.
          GoTo 470 ' GFH 09-10-09.

450       UL = ALOG10(U(K - 1)) - ((V1 - V(K - 1)) * (ALOG10(U(K - 1)) - ALOG10(U(K)))) / (V(K) - V(K - 1)) ' Interpolate .
'          If UL > 300 Then ' For checking.
'            DTemp = 1 / 0#
'          End If
'         GFH 10-19-09, seems to recover ok. Also converges better since the initial
'         thickness DZ above was changed. Changed back because not standard.
'         The following is not standard, but avoids overflow so cannot be
'         checked against the standard and is therefore ok.
          If UL > 300 Then
            UL = 300
          End If
          U1 = 10 ^ UL
          CBR(J, 1) = U1 * (ESWL(J) / CAREA) ' and solve for CBR.
          FCTN = CBR(J, 1) ' Check if computed CBR same as pavement CBR.
'Debug.Print USING "####.### "; ITER; FCTN; TRGT; Z(KZ); MODE; ITCT
          Call CVRG(ITER, FCTN, TRGT, Z(KZ), Mode, ITCT)
          If ITER = True Then GoTo 200   ' Not converged.
460          ' Success, CBR from curve is same as target CBR.
          KS = K     ' Otherwise jump to 200 for next iteration.
470
480     Next J
 ' ************ PRINT PAGE 3    ' All done. Calculate ACN.
        ACN = (Z(KZ) * 2.54) * (Z(KZ) * 2.54) / 1000 / (0.878 / FCTN - 0.01249)
'        If ICBR = 2 Then ACN = (Z(KZ) * 2.54) * (Z(KZ) * 2.54) / (37.47 * 2.54 * 0.1) ^ 2
'        For I = 1 To KZ
        For I = KZStart To KZ
         
'         25/10/85
'         No. 1
'         3-288                                   Aerodrome Design Manual
         
          ESWL(I) = ESWL(I) / XPOUND
          Z(I) = Z(I) * XINCH
        Next I
'  Output format the same as the ICAO program in following statements.
'          Debug.Print : Debug.Print
'          Debug.Print "                CBR        -T-"
'          Debug.Print "    ESWL     PASSES      DEPTH      ACN    2*ESWL/1000   RATIO"
'          Debug.Print USING "     KG   #,###,###       CM"; NCC(1)
'          Debug.Print
'          FOR I = 1 TO KZ
'            Debug.Print USING "#,###,###  #,###.##   #,###.##"; ESWL(1); CBR(1, 1); Z(1)
'        Debug.Print ESWL(2); CBR(2, 1); Z(2); ACN
'        Debug.Print "Area, Pressure "; CAREA; PESW
'          NEXT I
'          TEMP = ESWL(2) * 2 / 1000
'        Debug.Print USING "The ACN for a subgrade CBR of ##.# is ###.##"; TRGT; ACN
' Save results for printing later.
        PESWL(ICBR) = ESWL(2)
        PCBR(ICBR) = CBR(2, 1)
        PZ(ICBR) = Z(2)
        If Coverages = StandardCoverages And InputCBR = 0 Then
          PACN(ICBR) = ACN
        Else
          PACN(ICBR) = ACN '0
        End If
        ACNFlex(ICBR) = PACN(ICBR)
        ACNFlexCBR(ICBR) = PCBR(ICBR)
        CBRThickness(ICBR) = Z(2) / XINCH
        AlphaFactor = B(1)
        If ICBR = 1 Then Call WriteParmGrid
'        Call WriteOutputGrid
      Next ICBR
4500
      Call WriteOutputGrid ' GFH moved out of For loop 12-21-05.
      Call WriteFlexibleOutputData
      
      Exit Sub

ACNFlexCompError:
  SS$ = "An unexpected error has occurred in Sub ACNFlexComp:" & vbCrLf & vbCrLf
  SS$ = SS$ & "Number =" & Str(Err.Number) & vbCrLf
  SS$ = SS$ & "Source = " & Err.Source & vbCrLf
  SS$ = SS$ & "Description = " & Err.Description & vbCrLf & vbCrLf
  SS$ = SS$ & "Further calculations following this error may be incorrect." & vbCrLf
  SS$ = SS$ & "Please check to see if they are reasonable" & vbCrLf
  I = MsgBox(SS$, vbOKOnly, "Unexpected Error")
      
End Sub

Public Sub StoreFlexCurveFits()

' U = CBR / (ESWL / A)    V = t / SQR(A)    Interpolation table below.

  U(1) = 1.33
  U(2) = 1
  U(3) = 0.98
  U(4) = 0.96
  U(5) = 0.94
  U(6) = 0.92
  U(7) = 0.9
  U(8) = 0.88
  U(9) = 0.86
  U(10) = 0.84
  U(11) = 0.82
  U(12) = 0.8
  U(13) = 0.78
  U(14) = 0.76
  U(15) = 0.74
  U(16) = 0.72
  U(17) = 0.7
  U(18) = 0.68
  U(19) = 0.66
  U(20) = 0.64
  U(21) = 0.62
  U(22) = 0.6
  U(23) = 0.59
  U(24) = 0.58
  U(25) = 0.57
  U(26) = 0.56
  U(27) = 0.55
  U(28) = 0.54
  U(29) = 0.53
  U(30) = 0.52
  U(31) = 0.51
  U(32) = 0.5
  U(33) = 0.49
  U(34) = 0.48
  U(35) = 0.47
  U(36) = 0.46
  U(37) = 0.45
  U(38) = 0.44
  U(39) = 0.43
  U(40) = 0.42
  U(41) = 0.41
  U(42) = 0.4
  U(43) = 0.39
  U(44) = 0.38
  U(45) = 0.37
  U(46) = 0.36
  U(47) = 0.35
  U(48) = 0.34
  U(49) = 0.33
  U(50) = 0.32
  U(51) = 0.31
  U(52) = 0.3
  U(53) = 0.29
  U(54) = 0.28
  U(55) = 0.27
  U(56) = 0.26
  U(57) = 0.25
  U(58) = 0.24
  U(59) = 0.23
  U(60) = 0.22
  U(61) = 0.21
  U(62) = 0.2
  U(63) = 0.195
  U(64) = 0.19
  U(65) = 0.185
  U(66) = 0.18
  U(67) = 0.175
  U(68) = 0.17
  U(69) = 0.165
  U(70) = 0.16
  U(71) = 0.165
  U(72) = 0.15
  U(73) = 0.145
  U(74) = 0.14
  U(75) = 0.135
'       5
  U(76) = 0.13
  U(77) = 0.125
  U(78) = 0.12
  U(79) = 0.115
  U(80) = 0.11
  U(81) = 0.105
  U(82) = 0.1
  U(83) = 0.098
  U(84) = 0.096
  U(85) = 0.094
  U(86) = 0.092
  U(87) = 0.09
  U(88) = 0.088
  U(89) = 0.086
  U(90) = 0.084
  U(91) = 0.082
  U(92) = 0.08
  U(93) = 0.078
  U(94) = 0.076
  U(95) = 0.074
  U(96) = 0.072
  U(97) = 0.07
  U(98) = 0.068
  U(99) = 0.066
  U(100) = 0.064
  U(101) = 0.062
  U(102) = 0.06
  U(103) = 0.059
  U(104) = 0.058
  U(105) = 0.057
  U(106) = 0.056
  U(107) = 0.055
  U(108) = 0.054
  U(109) = 0.053
  U(110) = 0.052
  U(111) = 0.051
  U(112) = 0.05
  U(113) = 0.049
  U(114) = 0.048
  U(115) = 0.047
  U(116) = 0.046
  U(117) = 0.045
  U(118) = 0.044
  U(119) = 0.043
  U(120) = 0.042
  U(121) = 0.041
  U(122) = 0.04
  U(123) = 0.039
  U(124) = 0.038
  U(125) = 0.037
  U(126) = 0.036
  U(127) = 0.034
  U(128) = 0.032
  U(129) = 0.03
  U(130) = 0.029
  U(131) = 0.028
  U(132) = 0.027
  U(133) = 0.026
  U(134) = 0.025
  U(135) = 0.024
  U(136) = 0.023
  U(137) = 0.022
  U(138) = 0.021
  U(139) = 0.02
  U(140) = 0.019
  U(141) = 0.018
  U(142) = 0.017
  U(143) = 0.016
  U(144) = 0.015
  U(145) = 0.014
  U(146) = 0.013
  U(147) = 0.012
  U(148) = 0.011
  U(149) = 0.01
  U(150) = 0.009
  U(151) = 0.008
  U(152) = 0.007
  U(153) = 0.0065
  U(154) = 0.006
  U(155) = 0.0055
  U(156) = 0.005
  U(157) = 0.0045
  U(158) = 0.004
  U(159) = 0.0035
  U(160) = 0.003
  U(161) = 0.0025
  U(162) = 0.002
  U(163) = 0.00175
  U(164) = 0.0015
  U(165) = 0.00125
  U(166) = 0.001
  U(167) = 0.000875
  U(168) = 0.00075
  U(169) = 0.000625
  U(170) = 0.0005
' Added by GFH 09/10/09 to allow CBR calculation at line
  U(171) = 0.00045
  U(172) = 0.0004
  U(173) = 0.00035
  U(174) = 0.0003
  U(175) = 0.00025
  U(176) = 0.0002
  U(177) = 0.00015
  U(178) = 0.0001
  U(179) = 0.00005
  U(180) = 0.000000000001

' For I = 1 To 170
'   READ U(I)
'   PRINT #3  USING "###.#####  "; I; U(I)
' Next I

' Now V

  V(1) = 0
  V(2) = 0.048
  V(3) = 0.05
  V(4) = 0.055
  V(5) = 0.06
  V(6) = 0.061
  V(7) = 0.065
  V(8) = 0.07
  V(9) = 0.078
  V(10) = 0.08
  V(11) = 0.085
  V(12) = 0.099
  V(13) = 0.1
  V(14) = 0.103
  V(15) = 0.11
  V(16) = 0.118
  V(17) = 0.12
  V(18) = 0.127
  V(19) = 0.13
  V(20) = 0.14
  V(21) = 0.15
  V(22) = 0.158
  V(23) = 0.164
  V(24) = 0.168
  V(25) = 0.17
  V(26) = 0.178
  V(27) = 0.18
  V(28) = 0.185
  V(29) = 0.19
  V(30) = 0.194
  V(31) = 0.2
  V(32) = 0.205
  V(33) = 0.21
  V(34) = 0.218
  V(35) = 0.22
  V(36) = 0.23
  V(37) = 0.24
  V(38) = 0.242
  V(39) = 0.25
  V(40) = 0.255
  V(41) = 0.26
  V(42) = 0.27
  V(43) = 0.278
  V(44) = 0.287
  V(45) = 0.297
  V(46) = 0.302
  V(47) = 0.312
  V(48) = 0.321
  V(49) = 0.33
  V(50) = 0.342
  V(51) = 0.355
  V(52) = 0.37
  V(53) = 0.38
  V(54) = 0.395
  V(55) = 0.41
  V(56) = 0.428
  V(57) = 0.44
  V(58) = 0.46
  V(59) = 0.48
  V(60) = 0.5
  V(61) = 0.521
  V(62) = 0.55
  V(63) = 0.56
  V(64) = 0.572
  V(65) = 0.59
  V(66) = 0.601
  V(67) = 0.62
  V(68) = 0.63
  V(69) = 0.65
  V(70) = 0.67
  V(71) = 0.69
  V(72) = 0.708
  V(73) = 0.728
  V(74) = 0.742
  V(75) = 0.765
  V(76) = 0.785
  V(77) = 0.815
  V(78) = 0.84
  V(79) = 0.87
  V(80) = 0.9
  V(81) = 0.93
  V(82) = 0.958
  V(83) = 0.97
  V(84) = 0.985
  V(85) = 1
  V(86) = 1.02
  V(87) = 1.032
  V(88) = 1.045
  V(89) = 1.065
  V(90) = 1.08
  V(91) = 1.1
  V(92) = 1.115
  V(93) = 1.13
  V(94) = 1.15
  V(95) = 1.178
  V(96) = 1.19
  V(97) = 1.21
  V(98) = 1.23
  V(99) = 1.25
  V(100) = 1.27
  V(101) = 1.29
  V(102) = 1.318
  V(103) = 1.331
  V(104) = 1.34
  V(105) = 1.355
  V(106) = 1.37
  V(107) = 1.382
  V(108) = 1.4
  V(109) = 1.412
  V(110) = 1.43
  V(111) = 1.445
  V(112) = 1.46
  V(113) = 1.475
  V(114) = 1.495
  V(115) = 1.513
  V(116) = 1.53
  V(117) = 1.55
  V(118) = 1.57
  V(119) = 1.59
  V(120) = 1.612
  V(121) = 1.632
  V(122) = 1.65
  V(123) = 1.678
  V(124) = 1.71
  V(125) = 1.73
  V(126) = 1.76
  V(127) = 1.82
  V(128) = 1.881
  V(129) = 1.95
  V(130) = 1.985
  V(131) = 2.023
  V(132) = 2.063
  V(133) = 2.105
  V(134) = 2.149
  V(135) = 2.197
  V(136) = 2.247
  V(137) = 2.298
  V(138) = 2.358
  V(139) = 2.42
  V(140) = 2.486
  V(141) = 2.557
  V(142) = 2.635
  V(143) = 2.72
  V(144) = 2.813
  V(145) = 2.915
  V(146) = 3.029
  V(147) = 3.157
  V(148) = 3.302
  V(149) = 3.468
  V(150) = 3.66
  V(151) = 3.888
  V(152) = 4.162
  V(153) = 4.321
  V(154) = 4.501
  V(155) = 4.704
  V(156) = 4.938
  V(157) = 5.208
  V(158) = 5.528
  V(159) = 5.913
  V(160) = 6.39
  V(161) = 7.007
  V(162) = 7.837
  V(163) = 8.381
  V(164) = 9.056
  V(165) = 9.924
  V(166) = 11.098
  V(167) = 11.87
  V(168) = 12.82
  V(169) = 14.05
  V(170) = 15.7
' GFH 09/10/09.
  V(171) = 16.27518
  V(172) = 16.93855
  V(173) = 17.7171
  V(174) = 18.65155
  V(175) = 22
  V(176) = 29
  V(177) = 39
  V(178) = 56
  V(179) = 90
  V(180) = 1000

' For I = 1 To 170
'   READ V(I)
'   PRINT #3  USING "###.#####  "; I; V(I)
' Next I

End Sub


Private Sub ReadInputData()
  
  
  XINCH = 2.54        ' inches to cm
  XPRES = 145.0377438 ' Mpa to psi
  XPOUND = 2.2046225 ' kg to lb
  PI = 3.1415926535898
  
  KTITLE$ = JobTitle$
 '                                       (CARD TYPE '2')
 '  ACNs for standard subgrades when MODE = 11.
'  Line Input #1, SSS$
'  Input #1, NW             ' Number of wheels, ACN only, MODE = 11 always.
  NW = NWheels
 '                                       (CARD TYPE '3')
  For I = 1 To NW
    X(I) = YWheels(I) * XINCH
  Next I

'         25 /10/85
'         No 1
'         Part 3.- Pavements                                     3-283
         
  For I = 1 To NW
    Y(I) = XWheels(I) * XINCH
  Next I

' READ IN GRID DISPLACEMENT,INCREMENT AND SIZE FOR X AND Y-AXIS
'                   (CARD TYPE '5')
'     READ(5,940)GX,DGX,XK,GY,DGY,YK

  XK = 0:  YK = 0
  GX = YGridOrigin * XINCH:  XMax = YGridMax * XINCH:  XK = YGridNPoints
  GY = XGridOrigin * XINCH:  YMax = XGridMax * XINCH:  YK = XGridNPoints
  
  DGX = (XMax - GX) / (XK - 1)
  DGY = (YMax - GY) / (YK - 1)
  
' IF THE NUMBER OF LINES (XK OR YK) IS NOT INPUT, SET DEFAULTS.
  If (XK > ZERO) Then GoTo 70
  XMax = 0
  For MAXX = 1 To NW
    If (X(MAXX) > XMax) Then XMax = X(MAXX)
  Next MAXX
  GX = 0
  XK = 10
  DGX = (XMax - GX) / 2 / (XK - 1)
70
  If (YK > ZERO) Then GoTo 90
    YMax = 0
    For MAXY = 1 To NW
      If (Y(MAXY) > YMax) Then YMax = Y(MAXY)
    Next MAXY
    GY = 0
    YK = 10
    DGY = (YMax - GY) / 2 / (XK - 1)
90
    KX = XK
    KY = YK
 ' READ NUMBER OF DEPTHS AND DEPTH INCREMENT    (CARD TYPE '6')
'     READ(5,940) ZK,DZ
'     KZ = ZK
'     M = 0
 '                   ************
' READ NO. OF SETS OF MASS,TYRE PRESS., MASS ON MAIN GEAR, NO.OF LEGS
 '                   (CARD TYPE '7')
    IPR = 1
    IPRS = 1
'    For IPRS = 1 To IPR   ' One a/c per loop.
' READ AIRCRAFT MASS, TYRE PRESS., Percent MASS ON MAIN GEAR, NO.OF LEGS
 '                   (CARD TYPE '8')
  AMASS = GrossWeight / XPOUND
  PRSW = (TirePressure / XPRES) * 1000
  PMMG = PcntOnMainGears
  AMLG = NMainGears
  AlternateAlpha = InputAlpha
'  Debug.Print "TirePressure = "; TirePressure

End Sub

Private Sub WriteFlexibleOutputData()
      
  Dim I As Integer, ITemp As Integer
  Dim DTemp As Double
  Dim S As String
      
      If Units$ = "English Units" Then
        LengthConvert = 1
        PressConvert = 1 * XPRES / 1000
        WeightConvert = 1
      Else
        LengthConvert = XINCH
        PressConvert = 1
        WeightConvert = 1 / XPOUND
      End If
        
' Print everything at once.
      SSS$ = ""
      SSS$ = SSS$ & "Ground Flotation Program Results, " & KTITLE$ & vbCrLf & vbCrLf
      
' ACN Outputs, Metric units.
      SSS$ = SSS$ & "   ESWL, kg     CBR    DEPTH, cm    ACN" & vbCrLf '    2*ESWL/1000   RATIO" & vbCrLf
      If ACN_mode_true Then ITemp = 4 Else ITemp = 1
      For I = 1 To ITemp   ' Standard CBRs.
        SSS$ = SSS$ & LPad(10, Format(PESWL(I), "#,###,##0"))
        SSS$ = SSS$ & LPad(10, Format(SCBR(I), "#,##0.00"))
        SSS$ = SSS$ & LPad(10, Format(PZ(I), "#,##0.00"))
        SSS$ = SSS$ & LPad(10, Format(PACN(I), "0.00")) & vbCrLf
      Next I
      SSS$ = SSS$ & vbCrLf
      
' ACN Outputs, English units.
      SSS$ = SSS$ & "   ESWL, lb     CBR    DEPTH, in    ACN" & vbCrLf
      For I = 1 To ITemp   ' Standard CBRs.
        SSS$ = SSS$ & LPad(10, Format(PESWL(I) * XPOUND, "#,###,##0"))
        SSS$ = SSS$ & LPad(10, Format(SCBR(I), "#,##0.00"))  ' GFH 02/11/04.
        SSS$ = SSS$ & LPad(10, Format(PZ(I) / XINCH, "#,##0.00"))
        SSS$ = SSS$ & LPad(10, Format(PACN(I), "0.00")) & vbCrLf
      Next I
      SSS$ = SSS$ & vbCrLf
      
      SSS$ = SSS$ & "Number of wheels = " & Format(NW, "0") & vbCrLf
      SSS$ = SSS$ & "X (lateral) coordinates of wheels:" & vbCrLf
      For I = 1 To NW
        SSS$ = SSS$ & LPad(8, Format(X(I) * XINCH, "0.00"))
      Next I
      SSS$ = SSS$ & " cm" & vbCrLf
      For I = 1 To NW
        SSS$ = SSS$ & LPad(8, Format(X(I) * 1#, "0.00"))
      Next I
      SSS$ = SSS$ & " in" & vbCrLf
      SSS$ = SSS$ & "Y (longitudinal) coordinates of wheels:" & vbCrLf
      For I = 1 To NW
        SSS$ = SSS$ & LPad(8, Format(Y(I) * XINCH, "0.00"))
      Next I
      SSS$ = SSS$ & " cm" & vbCrLf
      For I = 1 To NW
        SSS$ = SSS$ & LPad(8, Format(Y(I) * 1#, "0.00"))
      Next I
      SSS$ = SSS$ & " in" & vbCrLf & vbCrLf
      
      SSS$ = SSS$ & "   No. of grid points (X, Y)  = " & Format(XK, "0") & "  " & Format(YK, "0") & vbCrLf
      SSS$ = SSS$ & "   Grid origin (X, Y), cm     = " & LPad(7, Format(GX * XINCH, "0.00")) & LPad(7, Format(GY * XINCH, "0.00")) & vbCrLf
      SSS$ = SSS$ & "   Grid increments (X, Y), cm = " & LPad(7, Format(DGX * XINCH, "0.00")) & LPad(7, Format(DGY * XINCH, "0.00")) & vbCrLf
      SSS$ = SSS$ & "   Grid origin (X, Y), in     = " & LPad(7, Format(GX * 1#, "0.00")) & LPad(7, Format(GY * 1#, "0.00")) & vbCrLf
      SSS$ = SSS$ & "   Grid increments (X, Y), in = " & LPad(7, Format(DGX * 1#, "0.00")) & LPad(7, Format(DGY * 1#, "0.00")) & vbCrLf
'      IF (IPRS.NE.1) THEN GOTO 160   Only one depth for ACN.
'          WRITE(6,907) ZK,DZ
      SSS$ = SSS$ & vbCrLf & "Number of sets of mass and tire pressure = " & Format(IPR, "0") & vbCrLf
        
      SSS$ = SSS$ & "Aircraft Mass (kg, lb) = " & Format(AMASS, "#,###,##0")
      SSS$ = SSS$ & "  " & Format(AMASS * XPOUND, "#,###,##0") & vbCrLf
      SSS$ = SSS$ & "Tire Pressures:" & vbCrLf & "   "
      For I = 1 To NW
        SSS$ = SSS$ & LPad(7, Format(PRS(I) * 1#, "0.0"))
      Next I
      SSS$ = SSS$ & " kPa" & vbCrLf & "   "
      For I = 1 To NW
        SSS$ = SSS$ & LPad(7, Format(PRS(I) * XPRES / 1000#, "0.00"))
      Next I
      SSS$ = SSS$ & " psi" & vbCrLf & vbCrLf
      SSS$ = SSS$ & "Percent Mass on Main Gear = " & LPad(5, Format(PMMG, "0.00")) & vbCrLf
      SSS$ = SSS$ & "Number of Main Gears = " & LPad(3, Format(AMLG, "0")) & vbCrLf
      DTemp = AMASS * PMMG / CDbl(AMLG * NW) / 100 ' Single tire load added GFH 02/11/04.
      SSS$ = SSS$ & "Load on One Tire (kg, lb) = " & Format(DTemp, "#,###,##0")
      SSS$ = SSS$ & ",  " & Format(DTemp * XPOUND, "#,###,##0") & vbCrLf
      SSS$ = SSS$ & "Tire Contact Radii:" & vbCrLf & "  "
      For I = 1 To NW
        SSS$ = SSS$ & LPad(7, Format(Rad(I) * XINCH, "0.00"))
      Next I
      SSS$ = SSS$ & " cm" & vbCrLf & "  "
      For I = 1 To NW
        SSS$ = SSS$ & LPad(7, Format(Rad(I) * 1#, "0.00"))
      Next I
      SSS$ = SSS$ & " in" & vbCrLf & vbCrLf
      SSS$ = SSS$ & "Coverages for ACN    = " & Format(NCC(1), "#,###,##0") & vbCrLf
      SSS$ = SSS$ & "Alpha Value for Gear = " & Format(B(1), "0.0000") & vbCrLf
      SSS$ = SSS$ & vbCrLf
      
      ACNFlexibleOutputText$ = SSS$
      frmACN.optPavementType(0).Value = True
      
'    Next IPRS       ' Aircraft
'    GoTo 10
'    Close 1
    
'         Note.- Pages 3-291 to 3-298 deleted by Amendment No. 1.
         
 '        25/1O/85
 '        No. 1
 
  FlexDesignESWL = PESWL(1) * XPOUND

End Sub
