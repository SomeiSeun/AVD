Attribute VB_Name = "ACNRigBAS"
Option Explicit
  
  Dim A(14)   As Double, AC      As Double, ACN      As Double
  Dim ACNK(4) As Double, ALPH    As Double
  Dim ALPHD   As Double, AMAX    As Double, AMIN     As Double, AQDRT As Double
  Dim AREA    As Double, ASS     As Double
  Dim AX      As Double, B(14)   As Double, BETA()   As Double
  Dim BQDRT   As Double, BX      As Double, C        As Double, COUNT As Double
  Dim CQDRT   As Double, D       As Double, DCOUNT() As Double
  Dim DENOM   As Double, DFWHL() As Double, DIFF0    As Double
  Dim DIFF1   As Double, DISCR   As Double, DTHET    As Double
  Dim DV10    As Double, DV100   As Double, DV14     As Double
  Dim DV2     As Double, DV20    As Double, DV6      As Double, DV60  As Double
  Dim DX(14)  As Double, D10     As Double, D100     As Double
  Dim D12     As Double, D120    As Double, D2       As Double, D20   As Double
  Dim D4      As Double, D40     As Double, D6       As Double, D60   As Double
  Dim D8      As Double, D80     As Double, E(10)    As Double, F()   As Double
  Dim FACC    As Double, FCTN    As Double, FELM     As Double
  Dim FTOT    As Double, FWHL    As Double
  Dim PIE     As Double, PX1     As Double, PX2      As Double
  Dim P1      As Double, P2      As Double, Q        As Double, RA    As Double, RB As Double
  Dim RSLT    As Double, S       As Double, SLP      As Double, SLP1  As Double
  Dim SLP2    As Double, SPCFL   As Double, ST(14)   As Double
  Dim STOR1   As Double, STOR3   As Double, STRS     As Double
  Dim SUBK    As Double, THET    As Double, THET1    As Double, THET2 As Double
  Dim TOTCT   As Double, V1      As Double, V2       As Double
  Dim X()     As Double, XHN     As Double, XKN      As Double, XL    As Double
  Dim XMax    As Double, XN      As Double, XNMR     As Double
  Dim XU()    As Double, XXL     As Double, Y()      As Double, YMax  As Double
  Dim YN      As Double, Y1      As Double, Y6       As Double, Y7    As Double, Y8 As Double
  Dim XINTRM  As Double, XPRES   As Double
  
  Dim XINCH As Double, XINCH2 As Double, XPOUND As Double
  Dim AMASS As Double, PRSW   As Double, PMMG   As Double
  Dim WT    As Double, TLMG   As Double, TLMS   As Double
  Dim TLSMG As Double, WM     As Double
  Dim TLSW  As Double
  Dim AMLG  As Double, Mode   As Integer, MODI  As Integer
  Dim M     As Integer, JBS   As Integer
  
  Dim SUBKI(7) As Double, SUBKII(7) As Double
  
  Dim IDCODE() As Integer, INN As Integer
  
  Dim ITER As Boolean, ITCT As Integer, TRGT As Double, Continue
  Dim SSS$, KTITLE$, Temp As Double
  Dim ACNOut(4) As Double, DOut(4)    As Double
  Dim XLOut(4)  As Double, STRSOut(4) As Double
  Dim NWheelsForStress(1 To 4) As Long, NWheelsForCut(1 To 4) As Long
  
  Public StartWheelIndex As Integer, StartWheelIndexPCA As Integer
  Dim XRigid() As Single, YRigid() As Single

Private Static Sub CNVG(ITER As Boolean, FCTN As Double, TRGT As Double, Y111 As Double, MODI As Integer, ITCT As Integer)

' DIM ITER AS INTEGER, ITCT AS INTEGER
' SUBROUTINE CVRG CONVERGES ON REFERENCE THICKNESS
  
   Dim Y222 As Double, Y333 As Double, X222 As Double, X333 As Double
  
   ITER = True
  
   If (ITCT = 0) Then GoTo 30
   ITCT = ITCT + 1
   If (ITCT > 20) Then GoTo 40
   If (Abs((FCTN - TRGT) / TRGT) < 0.0001) Then GoTo 40
   If (FCTN > TRGT) Then GoTo 10
   Y222 = Y111
   X222 = FCTN
   GoTo 20
10 Y333 = Y111
   X333 = FCTN
20 Y111 = Y222 + (Y333 - Y222) * (TRGT - X222) / (X333 - X222)
'   RETURN 1
   Exit Sub
30 ITCT = 1
   Y222 = 0#
   X222 = 0#
   Y333 = Y111
   X333 = FCTN
   GoTo 20
40 Continue = 0
'   RETURN 2
         
'         25/10/85

'         3-270                                Aerodrome Design Manual
'  Debug.Print "ITER = False"
   ITER = False
  
End Sub

Public Sub ACNRigComp()

  Dim FileError As Boolean, ISUB As Integer
  Dim ISUBI As Integer, SUBKO As Double, L As Integer
  Dim XLO As Double, K As Integer, N As Integer
  Dim I As Integer, J As Integer, DISCR As Double
  Dim PX1 As Double, P1 As Double, STOR1 As Double
  Dim ICODE As Integer, V1 As Double, KA As Integer
  Dim IL As Integer, IH As Integer, ID As Integer
  Dim DOO As Double, STRSO As Double
  Dim IWheels As Long ' Number of wheels in stress calculation.
  Dim StressRatio As Double ' Allowable stress / modulus of rupture.
  Dim AXoverBX As Double ' Contact patch aspect ratio.
  Dim Sout As String, SS As String
  Dim XMaxTemp As Double, YMaxTemp As Double
  Dim PrintDebug As Boolean
  
'  On Error GoTo ACNFlexCompError
  
  PrintDebug = False
  
  Call ReadRigidInputData(FileError)
  If FileError Then Exit Sub

  frmACN.txtOutput.Text = ""
'   117 READ(5,118)SUBKO,D
'        Call RSUBK(SUBK, SUBKO)
' C           SET STANDARD SUBBRADES - ULTRA LOW, LOW, MEDIUM, AND STRONG.
     If (MODI = 6) Then ACNK(1) = 73.679
     If (MODI = 6) Then ACNK(2) = 147.36
     If (MODI = 6) Then ACNK(3) = 294.72
     If (MODI = 6) Then ACNK(4) = 552.58
' C           SET UP COUNTER AND LOOP FOR STANDARD ACN/PCN SUBGRADES.
     ISUB = 0
1117 ISUB = ISUB + 1
       If (ISUB > 4) Then GoTo 350
       If Not ACN_mode_true Then ' GFH 01/28/08. Allows use of interior stress for design.
         If ISUB > 1 Then GoTo 350
         ACNK(ISUB) = InputkValue
         SUBK = ACNK(ISUB)
       End If
       If (MODI = 6) Then SUBK = ACNK(ISUB)
       ISUBI = (ISUB - 1) * 2 + 1
       If (MODI = 6) Then SUBKO = SUBKI(ISUBI)
       ITCT = 0
'   118 FORMAT(F8.2,F5.1)
' C           START THICKNESS CONVERGENCE LOOP.
1118   Continue = 0
' C           DELAY OUTPUTS UNTIL CONVERGENCE IS COMPLETE.
         If (MODI > 4) Then GoTo 128
'         WRITE(IOUT,119)MODE,SUBKO,D
         D = D / XINCH
         
'         25/10/85
'         No. 1

'         Part ~.- Pavement~                                      ~-2f.3
         
'   119 FORMAT(' '/' MODE    K SUBBASE SUBGRADE     PAVEMENT THICKNESS'/'
'1 ',I3,F17.2,F21.1/)

         GoTo 128
'        120 WRITE(IOUT,121)MODE
'        121 FORMAT(' '/' MODE'/' ',I3/)
         If (Mode - 3) <= 0 Then GoTo 122 Else GoTo 124
122      SPCFL = 0#
123      AMAX = 0#
         GoTo 129
124      'READ(5,125)SPCFL,AMIN,AMAX
         SPCFL = SPCFL / XINCH
'        125 FORMAT(F6.2,2(F6.1))
         ALPHD = AMIN
         ALPH = AMIN / 180# * PIE
'        WRITE(IOUT,126)AMIN,AMAX
'        126 FORMAT(' ROTATE FROM',F6.1,' TO',F6.l,' DEGREES'/)
         GoTo 130
127      D = 10#
128      If D <= 0 Then D = 0 ' D = Thickness  ' GFH 07/06/08.
' 128      XXL = Sqr(D ^ 3 / SUBK) ' Error if D is negative.
         XXL = Sqr(D ^ 3 / SUBK)
         If (XXL < 0#) Then XXL = 0#
         SPCFL = 24.1652 * Sqr(XXL) ' Radius of relative stiffness.
'                24.1652 = (4,000,000 / (12 * (1.0 - 0.15 * 0.15))) ^ 0.25
         GoTo 123
129      ALPH = 0#
         ALPHD = 0#
         If (Mode - 3) <= 0 Then GoTo 134 Else GoTo 130
130      'WRITE(IOUT,131)ALPHD
'       131 FORMAT(' ROTATION ANGLE',F7.1/)
'       134  DO 320 L=20,100,10
134     For L = 20 To 100 Step 10
          XL = L
          If (SPCFL <> 0) Then XL = SPCFL
          If (MODI > 4) Then GoTo 138
135       If (Mode - 2) < 0 Then GoTo 138 Else GoTo 136
136       XLO = XL * XINCH
'         WRITE(IOUT,137)XLO
'         137 FORMAT(' RAD. REL. STIFF.', F7.2,/)
138       AX = 0.5 * (Sqr(AREA / 0.5227)) / XL
          BX = AREA / (PIE * AX * XL * XL)
          AXoverBX = PIE / (4# * 0.5227) ' GFH 08/25/08. Set ellipse aspect ratio.
'          AXoverBX = 1# '/ AXoverBX
          AX = Sqr(AREA * AXoverBX / PIE) / XL
          BX = AX / AXoverBX ' End set aspect ratio.
          FWHL = 0#
          FTOT = 0#
          FACC = 0#
          K = 1
          NWheelsForCut(ISUB) = M
          IWheels = M ' GFH ** 02/06/06.
'         139 DO 196 N=1,M
139       For N = 1 To M
            YN = Y(N)
            XN = X(N)
'            GO TO (140,140,140,148),MODE
            If Mode = 1 Or Mode = 2 Or Mode = 3 Then GoTo 140
            If Mode = 4 Then GoTo 148
140         If (K - 2) < 0 Then
              GoTo 141
            ElseIf (K - 2) = 0 Then
              GoTo 147
            ElseIf (K - 2) > 0 Then
              GoTo 148
            End If
141         If (Y(N) * X(N)) = 0 Then GoTo 142 Else GoTo 145
142         If (Y(N)) = 0 Then GoTo 143 Else GoTo 144
143         BETA(N) = 0#
            GoTo 146
144         BETA(N) = PIE / 2#
            GoTo 146
145         BETA(N) = Atn(Y(N) / X(N))
146         ALPH = -BETA(N)
            GoTo 148
147         ALPH = PIE / 2# - BETA(N)
         
'         25/10/85
'         No. 1

'         3-264                                  Aerodrome Design Manual
         
148         XHN = Abs(XN / XL)
            XKN = Abs(YN / XL)
            C = (AX * XKN) ^ 2 + (BX * XHN) ^ 2 - (AX * BX) ^ 2
            If (C) <= 0 Then GoTo 160 Else GoTo 149
149         If (AX - Abs(XHN)) = 0 Then GoTo 159 Else GoTo 150
150         SLP1 = (-(XHN * XKN) - Sqr(C)) / (AX ^ 2 - XHN ^ 2)
            SLP2 = (-(XHN * XKN) + Sqr(C)) / (AX ^ 2 - XHN ^ 2)
            If (SLP2 - SLP1) < 0 Then GoTo 151 Else GoTo 152
151         STOR3 = SLP2
            SLP2 = SLP1
            SLP1 = STOR3
152         THET2 = Atn(SLP2)
            If (XHN) = 0 Then GoTo 155 Else GoTo 153
153         If (SLP2 - XKN / XHN) < 0 Then GoTo 155 Else GoTo 154
154         If (SLP1) < 0 Then GoTo 157 Else GoTo 156
155         THET1 = PIE - Atn(Abs(SLP1))
            GoTo 158
156         THET1 = Atn(SLP1)
            GoTo 158
157         THET1 = -Atn(Abs(SLP1))
158         DTHET = (THET2 - THET1) / 20#
            THET = THET1 + DTHET / 2#
            GoTo 161
159         SLP1 = (XKN ^ 2 - BX ^ 2) / (2# * XHN * XKN)
            THET2 = PIE / 2#
            GoTo 154
160         THET1 = (-2# * PIE) / 88#
            DTHET = (2# * PIE) / 88#
            J = 44
            S = -1#
            THET = THET1 + DTHET
            GoTo 162
161         J = 20
            S = 1#
'           162 DO 186 I=1,J
162         For I = 1 To J
'              DoEvents
                DoEvents
                If StopComputation Then
                  StopComputation = False
                  GoTo 370
                End If
              If (THET - (PIE / 2#)) = 0 Then GoTo 165 Else GoTo 163
163           If (THET - (3# * PIE / 2#)) = 0 Then GoTo 165 Else GoTo 164
164           SLP = Sin(THET) / Cos(THET)
              AQDRT = BX ^ 2 + (AX * SLP) ^ 2
              BQDRT = -(2# * XHN * BX ^ 2 + 2# * XKN * SLP * AX ^ 2)
              CQDRT = (BX * XHN) ^ 2 + (AX * XKN) ^ 2 - (AX * BX) ^ 2
              DISCR = BQDRT ^ 2 - 4# * AQDRT * CQDRT
              If (DISCR < 0#) Then DISCR = 0#
              PX1 = (-BQDRT - Sqr(DISCR)) / (2# * AQDRT)
              PX2 = (-BQDRT + Sqr(DISCR)) / (2# * AQDRT)
              P1 = PX1 / Cos(THET)
              P2 = PX2 / Cos(THET)
              GoTo 166
165           RSLT = AX ^ 2 - XHN ^ 2
              If (RSLT < 0#) Then RSLT = 0#
              P1 = XKN - (BX / AX) * Sqr(RSLT)
              P2 = XKN + (BX / AX) * Sqr(RSLT)
166           If (P2 - P1) < 0 Then GoTo 167 Else GoTo 168
167           STOR1 = P2
              P2 = P1
              P1 = STOR1

'         25 /10/85
'         No. 1

'         Part 3.- Pavements                         3-265
'168           If (P2 - 3#) < 0 Then GoTo 171 Else GoTo 169
'169           If (P1 - 3#) <= 0 Then GoTo 170 Else GoTo 180
'170           P2 = 3#
168           If (P2 - RigidCutoff) < 0 Then GoTo 171 Else GoTo 169
169           If (P1 - RigidCutoff) <= 0 Then GoTo 170 Else GoTo 180
170           P2 = RigidCutoff
'             The cutoff radius passes through the tire contact patch.
              NWheelsForCut(ISUB) = N * 2
171           FELM = 0#
              If (I - J / 2) = 0 Then GoTo 172 Else GoTo 175
'172           If (P2 - 3#) < 0 Then GoTo 174 Else GoTo 173
172           If (P2 - RigidCutoff) < 0 Then GoTo 174 Else GoTo 173
173           ICODE = 1
              GoTo 175
174           ICODE = 0
175           Continue = 0
              If (P1) = 0 Then GoTo 176 Else GoTo 177
176           V1 = 0#
              GoTo 181
177           If (P2) = 0 Then GoTo 178 Else GoTo 179
178           V2 = 0#
              GoTo 181
179           V2 = (2# / PIE) * Log(Abs(P2 / 2#))
              V1 = (2# / PIE) * Log(Abs(P1 / 2#))
              GoTo 181
180           FWHL = 0#
'             The tire footprint is completely outside the cutoff radius.
              ICODE = 2
'              IWheels = IWheels - 1 ' This does not count wheels. Don't know why.
              NWheelsForStress(ISUB) = N * 2
              GoTo 187
'             Computation of the Hankel functions.
181           B(2) = (P2 / 3#) ^ 2
              A(2) = (P1 / 3#) ^ 2
              For KA = 4 To 14 Step 2
                B(KA) = B(KA - 2) * B(2)
182             A(KA) = A(KA - 2) * A(2)
              Next KA
              D2 = (B(2) - S * A(2)) * (-0.222121)
              D4 = (B(4) - S * A(4)) * 2.53125
              D6 = (B(6) - S * A(6)) * (-1.31648)
              D8 = (B(8) - S * A(8)) * (-0.177944)
              D10 = (B(10) - S * A(10)) * 0.0401
              D12 = (B(12) - S * A(12)) * 0.001429
              DV2 = (V2 * B(2) - S * V1 * A(2)) * (-4.5)
              DV6 = (V2 * B(6) - S * V1 * A(6)) * 1.89846
              DV10 = -0.0399 * (V2 * B(10) - S * V1 * A(10))
              DV14 = (V2 * B(14) - S * V1 * A(14)) * 0.000099
              D20 = (B(2) - S * A(2)) * (-0.6056)
              D40 = (B(4) - S * A(4)) * (-0.63281)
              D60 = (B(6) - S * A(6)) * 0.253
              D80 = (B(8) - S * A(8)) * 0.022224
              D100 = (B(10) - S * A(10)) * (-0.00428)
              D120 = (B(12) - S * A(12)) * (-0.000105)
              DV20 = (V2 * B(2) - S * V1 * A(2)) * 2.25
              DV60 = (V2 * B(6) - S * V1 * A(6)) * (-0.31639)
              DV100 = (V2 * B(10) - S * V1 * A(10)) * 0.003944
              DIFF0 = D120 + DV100 + D100 + D80 + DV60 + D60 + D40 + D20 + DV20 + 0.5 - 0.5 * S
              DIFF1 = DV14 + D12 + DV10 + D10 + D8 + DV6 + D6 + D4 + D2 + DV2
              Y6 = Sin(Abs(DTHET))
              If (Y(N) * X(N)) < 0 Then GoTo 183 Else GoTo 184
183           XU(N) = -1#
              GoTo 185
184           XU(N) = 1#
185           Y7 = 2# * (THET + ALPH * XU(N))
              Y8 = Cos(Y7)
              Y1 = Y6 * Y8
         
'         25/10/85
'         No 1

'           3-266                                                              Aerodrome Design Manual
         
'             Moment due to current slice from current wheel.
              FELM = XL ^ 2 / 8# * (1.15 * Abs(DTHET) * DIFF1 + 1.7 * Y1 * (DIFF1 / 2# + DIFF0 - 0.5 + 0.5 * S))
              THET = THET + DTHET
186           FWHL = FWHL + FELM ' Accumulated moment.
            Next I
            DFWHL(N) = FWHL ' Total moment due to current wheel.
'            Debug.Print N; FWHL
'   187 GO TO (188,188,188,192),MODE
187         If Mode = 1 Or Mode = 2 Or Mode = 3 Then GoTo 188
            If Mode = 4 Then GoTo 192
188         If (K - 2) <= 0 Then GoTo 189 Else GoTo 190
189         F(N, K) = FWHL
            GoTo 192
190         If (K - 5) <= 0 Then GoTo 191 Else GoTo 192
191         F(N, K - 2) = FWHL
192         COUNT = FWHL * 10000# / (XL) ^ 2
            DCOUNT(N) = COUNT
            IDCODE(N) = ICODE
            FACC = FWHL + FACC
            If (MODI > 4) Then GoTo 196
'           GO TO (196,193,193,194),MODE
            If Mode = 1 Then
              GoTo 196
            ElseIf Mode = 2 Or Mode = 3 Then
              GoTo 193
            ElseIf Mode = 4 Then
              GoTo 194
            End If
193         If (K - 8) <= 0 Then GoTo 196 Else GoTo 194
194 'WRITE(IOUT,195)N,FWHL,ICODE,COUNT
'           195 FORMAT(' ',10X,'WHL. NO.',I3,5X,'F',F9.4,3X,'CODE',I2,5X,'COUNT',
'           1F7.1)
196         FWHL = 0#
'            Debug.Print N; P1 * XL; P2 * XL ' GFH ** 02/06/06.
          Next N
'          NWheelsForStress(ISUB) = IWheels
'          Debug.Print "IWheels = "; IWheels; P1 * XL; P2 * XL ' GFH ** 02/06/06.
          FTOT = FTOT + FACC
          E(K) = FTOT
          TOTCT = FTOT * 10000# / (XL) ^ 2
          If (MODI > 4) Then GoTo 200
'         GO TO (200,197,197,198),MODE
          If Mode = 1 Then
            GoTo 200
          ElseIf Mode = 2 Or Mode = 3 Then
            GoTo 197
          ElseIf Mode = 4 Then
            GoTo 198
          End If
197       If (K - 8) <= 0 Then GoTo 200 Else GoTo 198
198       'WRITE(IOUT,199)FTOT,TOTCT
'         199 FORMAT(' ',20X,'TOTAL F',F9.4,8X,'TOTAL COUNT',F7.1/)
'         200 GO TO (201,201,201,310),MODE
200       If Mode = 1 Or Mode = 2 Or Mode = 3 Then
            GoTo 201
          ElseIf Mode = 4 Then
            GoTo 310
          End If
'         201 GO TO (215,202,213,213,213,214,214,214,216),K
201       If K = 1 Then
            GoTo 215
          ElseIf K = 2 Then
            GoTo 202
          ElseIf K = 3 Or K = 4 Or K = 5 Then
            GoTo 213
          ElseIf K = 6 Or K = 7 Or K = 8 Then
            GoTo 214
          ElseIf K = 9 Then
            GoTo 216
          End If
202       XNMR = 0#
          DENOM = 0#
'         DO 207 N=1,M
          For N = 1 To M
            ASS = Sin(2# * BETA(N))
            AC = Cos(2# * BETA(N))
            If (Abs(ASS) - 0.0001) < 0 Then GoTo 203 Else GoTo 204
203         ASS = 0#
204         If (Abs(AC) - 0.0001) < 0 Then GoTo 205 Else GoTo 206
205         AC = 0#
206         XNMR = XNMR - Abs(F(N, 1) - F(N, 2)) * ASS
            DENOM = DENOM + Abs(F(N, 1) - F(N, 2)) * AC
207         Continue = 0
          Next N
          If (XNMR) = 0 Then GoTo 208 Else GoTo 209
'208       ALPH = PIE / 4# * (1# + DSIGN(1#, DENOM))
208       ALPH = PIE / 4# * (1# + Sgn(DENOM))
          GoTo 212
209       If (DENOM) = 0 Then GoTo 210 Else GoTo 211
210       ALPH = 0.5 * PIE * (1# + 0.5 * Sgn(XNMR))
          GoTo 212
211       ALPH = PIE / 4# * (1# + Sgn(DENOM)) + 0.5 * Atn(XNMR / DENOM)
212       ALPHD = 180# * ALPH / PIE
          GoTo 215
213       Call XYMAX(M, XL, E(4), E(3), E(5), K, Y, YMax)
          GoTo 215
214       Call XYMAX(M, XL, E(7), E(6), E(8), K, X, XMax)

'         25/10/85
'         No. 1

'          P ~ r t                 '1 -- P:l ~r~ m~ n t c        ~    7
         
215       K = K + 1
          FTOT = 0#
          FACC = 0#
          GoTo 139
216       For N = 1 To M
            Y(N) = Y(N) - YMax
217         X(N) = X(N) - XMax
          Next N
          If (MODI > 4 And ALPHD >= 0#) Then GoTo 240
          If (Mode - 2) < 0 Then GoTo 218 Else GoTo 232
218       STRS = 6# * Q * FTOT / D ^ 2
          ST(INN) = STRS
          DX(INN) = D
          If (D - 10#) <= 0 Then GoTo 219 Else GoTo 222
219       If (STRS - 620#) <= 0 Then GoTo 220 Else GoTo 221
220       INN = INN - 1
          D = D / 1.3
          GoTo 128
221       IL = INN
          INN = 8
          D = 13#
          GoTo 128
222       If (STRS - 620#) <= 0 Then GoTo 224 Else GoTo 223
223       IL = INN
224       If (STRS - 280#) <= 0 Then GoTo 226 Else GoTo 225
225       INN = INN + 1
          D = 1.3 * D
          GoTo 128
226       IH = INN
          INN = IL + 1
          ID = DX(INN - 1)
          D = ID
          D = D + 1#
'         WRITE(IOUT,227)
'         227 FORMAT(' '//' ',24X,'THICKNESS',3X,'MAX. STRESS')
228       RA = Log(ST(INN - 1) / ST(INN)) / 0.262363
          RB = Log(ST(INN - 1)) + RA * Log(DX(INN - 1))
          STRS = Exp(RB - RA * Log(D))
          DOO = D * XINCH
          STRSO = STRS / XPRES
'         WRITE(IOUT,229)DOO,STRSO
'         229 FORMAT(' ',25X,F5.1,F13.1)
          If (STRS - 280#) <= 0 Then GoTo 310 Else GoTo 230
230       D = D + 0.5
          If (D - DX(INN)) <= 0 Then GoTo 228 Else GoTo 231
231       INN = INN + 1
          If (INN - IH) <= 0 Then GoTo 228 Else GoTo 310
232       If (ALPHD) < 0 Then GoTo 233 Else GoTo 234
233       ALPHD = 180# + ALPHD
          If (MODI > 4) Then GoTo 240
234       'WRITE(IOUT,235)XMAX,YMAX,ALPHD
'         235 FORMAT(' ',10X,'XMAX',F5.1,5X,'YMAX',F5.1,3X,'MAX. ANGLE',F7.1/)
240       Continue = 0
          If (Mode - 3) < 0 Then GoTo 250 Else GoTo 310
250       STRS = 6# * Q * FTOT / (D ^ 2 + 1E-20) ' GFH 07/06/08.
' C          CONVERGE ON REQUIRED THICKNESS.
          XINTRM = AREA * Q
          
'         25/10/85
'         No. 1

'          3-268                                   Aerodrome Design Manual
         
          If (MODI = 5) Then FCTN = XINTRM * 400# / STRS
'          If STRS = 0 Then ' GFH *** 02/06/06
'            FCTN = 0
'          Else

'         Start GFH 06/12/08.
          If (MODI = 6) Then
            If ACN_mode_true Then ' execute the ICAO program statement.
              FCTN = XINTRM * 398.85 / STRS
'             398.85378 psi = 2.75 MPa = flexural strength of 620.96 psi times the
'             stress ratio from the PCA fatigue equation at 10,000 coverages.
'             Flexural strength = 4.281426 MPa.
            Else ' PCA fatigue equation.
'              StressRatio = 0.970381 - 0.035661 * Log(Coverages) ' PCA fatigue equation from FAA curve fit.
              StressRatio = 0.9725 - 0.03585 * Log(Coverages) ' PCA fatigue equation from Boeing.
'                         = 0.642309 for 10,000 Coverages. Log is natural logarithm in VB.
              FCTN = XINTRM * ConcreteFlexuralStrength * StressRatio / STRS
            End If
          End If
'         End GFH 06/12/08.

          If (MODI > 4) Then Call CNVG(ITER, FCTN, XINTRM, D, MODI, ITCT)
          If ITER Then GoTo 1118
260       If (MODI <= 4) Then GoTo 270
' C       WRITE OUTPUTS(DELAYED UNTIL CONVERGENCE WAS COMPLETE).
          DOO = D * XINCH
          XLO = XL * XINCH
'          WRITE(IOUT,119) MODI, SUBO, DOO
'   119 FORMAT(' '/' MODE    K SUBBASE SUBGRADE     PAVEMENT THICKNESS'/'
'          WRITE(IOUT,137) XLO
'         137 FORMAT(' RAD. REL. STIFF.', F7.2,/)
'          WRITE(IOUT,195)(N,DFWHL(N),IDCODE(N), DCOUNT(N), N=l,M)
'           195 FORMAT(' ',10X,'WHL. NO.',I3,5X,'F',F9.4,3X,'CODE',I2,5X,'COUNT',
'          WRITE(IOUT,199) FTOT, TOTCT
'         199 FORMAT(' ',20X,'TOTAL F',F9.4,8X,'TOTAL COUNT',F7.1/)
'          WRITE(IOUT,235) XMAX, YMAX, ALPHD
'         235 FORMAT(' ',10X,'XMAX',F5.1,5X,'YMAX',F5.1,3X,'MAX. ANGLE',F7.1/)
          If PrintDebug Then
            Debug.Print
            Debug.Print "Mode = " & Format(MODI, "0") & " K Support = " & Format(SUBK, "0.00") & " Thick = " & Format(DOO, "0.00")
            Debug.Print "Rad.Rel.Stiffness = " & Format(XL, "0")
            Debug.Print " No. Whls F (Moment?)  IDCODE(N)  DCOUNT(N)"
            For N = 1 To M
              Debug.Print "    " & Format(N, "0") & "     " & Format(DFWHL(N), "0.0000") & "  " & "Stress = " & Format(DFWHL(N) * 6# * Q / (D ^ 2 + 1E-20), "0.000") & "  " & Format(IDCODE(N), "0.00") & "  " & Format(DCOUNT(N), "0.00")
            Next N
            Debug.Print "Total F = " & Format(FTOT, "0.000") & " Total Stress = " & Format(FTOT * 6# * Q / (D ^ 2 + 1E-20), "0.000") & " Total Count = " & Format(TOTCT, "0")
            Debug.Print "XMAX = " & Format(XMax, "0.000") & " YMAX = " & Format(YMax, "0.000") & " MAX. ANGLE = " & Format(ALPHD, "0.000")
            Debug.Print
          End If
270       Continue = 0
          STRSO = STRS / XPRES ' XPRES = 145.0377 = psi/MPa.
          If PrintDebug Then
            Debug.Print
            Debug.Print "Mode = " & Format(MODI, "0") & " K Support = " & Format(SUBK, "0.00") & " Thick = " & Format(D, "0.00")
            Debug.Print "Rad.Rel.Stiffness = " & Format(XL, "0")
            Debug.Print " Whl No. X(N)  Y(N)   F (Moment?)  IDCODE(N)  DCOUNT(N)"
            For N = 1 To M
              Sout = "    " & Format(N, "0") & "  " & Format(X(N), "0.00") & "  " & Format(Y(N), "0.00")
              Sout = Sout & "    " & Format(N, "0") & "     " & Format(DFWHL(N), "0.0000") & "  " & "Stress = " & Format(DFWHL(N) * 6# * Q / (D ^ 2 + 1E-20), "0.000") & "  " & Format(IDCODE(N), "0.00") & "  " & Format(DCOUNT(N), "0.00")
              Debug.Print Sout
            Next N
            Debug.Print "Total F = " & Format(FTOT, "0.000") & " Total Stress = " & Format(FTOT * 6# * Q / (D ^ 2 + 1E-20), "0.000") & " Total Count = " & Format(TOTCT, "0")
            Debug.Print "XMAX = " & Format(XMax, "0.000") & " YMAX = " & Format(YMax, "0.000") & " MAX. ANGLE = " & Format(ALPHD, "0.000")
            Debug.Print
          End If
          
          'ikawa seattle
          If Index3StressCalc Then
          frmGear.txtStress.Text = Format(FTOT * 6# * Q / (D ^ 2 + 1E-20), "0.00")
          End If
          
'          WRITE(IOUT,280)STRSO
'          280 FORMAT(' ',10X,'MAX. STRESS',F7.1)
' C       SAVE NUMBER OF ITERATIONS REQUIRED FOR CONVERGENCE.
'          IF(MODI .GT. 4) WRITE(IOUT,290) ITCT
'          290 FORMAT('+', 36X, 'ITERATIONS', I5)
' C       COMPUTE AND WRITE ACN, AND RETURN TO START OF LOOP.
          If (MODI = 6) Then Call CACN(D, ACN, ISUB)
          DOut(ISUB) = D
          XLOut(ISUB) = XLO
          STRSOut(ISUB) = STRSO
          If ACN_mode_true Then
'          If Coverages = StandardCoverages And InputkValue = 0 Then
            ACNOut(ISUB) = ACN
          Else
            ACNOut(ISUB) = 0
          End If
          ACNRigid(ISUB) = ACNOut(ISUB)
          ACNRigidk(ISUB) = ACNK(ISUB)
          RigidThickness(ISUB) = D
          RigidStress(ISUB) = STRSOut(ISUB)
          SSS$ = frmACN.txtOutput.Text
          SSS$ = SSS$ & LPad(6, Format(ACNK(ISUB), "#,##0.00"))
          SSS$ = SSS$ & LPad(6, Format(D, "#,##0.00"))
          SSS$ = SSS$ & LPad(6, Format(ACNOut(ISUB), "#,##0.00"))
          SSS$ = SSS$ & LPad(6, Format(STRSOut(ISUB), "#,##0.00")) & vbCrLf
          frmACN.txtOutput.Text = SSS$
          Call WriteOutputGrid
          DoEvents
'         IF(MODI .EQ. 6) WRITE(IOUT,300) ACN
'         300 FORMAT('+', 57X, 'ACN , F6.1, //)
310       XMaxTemp = XMax ' GFH 09/28/08. To plot the correct values.
          YMaxTemp = YMax
'310       XMax = 0#
          XMax = 0#
          YMax = 0#
          If (MODI = 6) Then GoTo 1117
          If (SPCFL) = 0 Then GoTo 320 Else GoTo 330
320       Continue = 0
        Next L
330     If (Mode - 3) <= 0 Then GoTo 350 Else GoTo 340
340     ALPHD = ALPHD + 5#
        ALPH = ALPHD / 180# * PIE
        If (ALPHD - AMAX) <= 0 Then GoTo 130 Else GoTo 350
350     'JBS = JBS + 1
'        WRITE(IOUT,360)
'        360 FORMAT(' '////)
'        If (JOBS - JBS) <= 0 Then GoTo 370 Else GoTo 102
370     Continue = 0

      XMax = XMaxTemp
      YMax = YMaxTemp
      Call WriteRigidOutputData
      
      Exit Sub

ACNFlexCompError:
  SS$ = "An unexpected error has occurred in Sub ACNRigComp:" & vbCrLf & vbCrLf
  SS$ = SS$ & "Number =" & Str(Err.Number) & vbCrLf
  SS$ = SS$ & "Source = " & Err.Source & vbCrLf
  SS$ = SS$ & "Description = " & Err.Description & vbCrLf & vbCrLf
  SS$ = SS$ & "Further calculations following this error may be incorrect." & vbCrLf
  SS$ = SS$ & "Please check to see if they are reasonable" & vbCrLf
  I = MsgBox(SS$, vbOKOnly, "Unexpected Error")
      
End Sub

Private Sub ReadRigidInputData(FileError As Boolean)
  
     Dim I As Integer, NearestWheel As Integer
     Dim Xcg As Double, Ycg As Double
     Dim PCAStressOnly As Boolean
     
     I = NWheels
     ReDim BETA(I), DCOUNT(I), DFWHL(I), F(I, 3), IDCODE(I)
     ReDim X(I), XU(I), Y(I), XRigid(I), YRigid(I)
     
     SUBKI(1) = 20:  SUBKI(2) = 25:  SUBKI(3) = 40
     SUBKI(4) = 60:  SUBKI(5) = 80:  SUBKI(6) = 120:  SUBKI(7) = 150
  
     XINCH2 = 6.4516
     XINCH = 2.54           ' inches to cm
     XPRES = 145.0377438    ' Mpa to psi
     XPOUND = 2.2046225     ' kg to lb
     PIE = 3.1415926535898
  
     JBS = 1       ' Allow only 1 job.
102  INN = 7
     Mode = 6      ' Compute ACNs.
     
     D = 60
     PCAStressOnly = False 'True
     
     'ikawa seattle
     If Not Index3StressCalc Then
        PCAStressOnly = False 'True
     Else
        PCAStressOnly = True  'ikawa
     End If

     
     
     If PCAStressOnly Then
       If Not ACN_mode_true And Not PCN_mode_true And frmGear.chkPCAThicknessDesign = vbChecked Then
         Mode = 2
         D = CDbl(frmGear.txtEvaluationThickness.Text) * XINCH
       Else
'      Message or set above check box.
       End If
     End If
     
     MODI = Mode
     If MODI > 4 Then Mode = 2
'     GO TO (104, 104, 107, 107)  ' Always 104
'     104 READ(5,105)AIRCR,GEAR,M,AMASS,PRSW,PMMG,AMLG
  
     KTITLE$ = JobTitle$
  
     M = NWheels
     
     For I = 1 To M
       XRigid(I) = XWheels(I)
       YRigid(I) = YWheels(I)
     Next I
     
'    Set origin at first index in wheel arrays.
     Call FindStartWheel(XRigid(), YRigid(), StartWheelIndex)
     StartWheelIndexPCA = StartWheelIndex
     Call frmGear.PlotGear
     frmGear.cmdSelectWheel.Value = True
     frmGear.lblXSelected.Caption = ""
     frmGear.lblYSelected.Caption = ""
     
     For I = 1 To M
       Y(I) = YRigid(I) * XINCH    ' Lateral (opposite to flexible).
     Next I

     For I = 1 To M
       X(I) = XRigid(I) * XINCH    ' Longitudinal.
     Next I
     
     AMASS = GrossWeight / XPOUND
     PRSW = (TirePressure / XPRES) * 1000
     PMMG = PcntOnMainGears
     AMLG = NMainGears
    
     WT = AMASS * 9.815 / 1000
'     WT = AMASS * 9.80665 / 1000
     TLMG = WT * PMMG / 100#
     TLSMG = TLMG / AMLG
     WM = M
     TLSW = TLSMG / WM
     AREA = TLSW * 10000# / PRSW
     Q = PRSW / 1000#
     AREA = AREA / XINCH2
     Q = Q * XPRES
     
     ' Convert back to inches for compatibility with ICAO program.
     For I = 1 To M
       Y(I) = Y(I) / XINCH
       X(I) = X(I) / XINCH
     Next I
     
'      D = 60 ' Moved to start of sub for PCAStressOnly

End Sub

Public Sub WriteRigidOutputData()
      
      Dim LengthConvert As Double, PressConvert As Double
      Dim WeightConvert As Double, KConvert As Double
      Dim InputWheelConvert As Double
      Dim I As Integer, ITemp As Integer, S$
      
'     These need to be set here if thickness design is selected before running ACN.
'     Otherwise they are set in Sub ReadRigidInputData(). Not standard output
'     units conversion because of the exit from the ICOA program in metric units.

      XINCH2 = 6.4516
      XINCH = 2.54           ' inches to cm
      XPRES = 145.0377438    ' Mpa to psi
      XPOUND = 2.2046225     ' kg to lb
      PIE = 3.1415926535898
     
      If UnitsOut.Metric Then
        LengthConvert = XINCH
        InputWheelConvert = 1 * XINCH
        PressConvert = 1 / XPRES
        WeightConvert = 1
        KConvert = 9.815 / (XINCH * XINCH2 * XPOUND)
      Else
        LengthConvert = 1
        InputWheelConvert = 1
        PressConvert = 1
        WeightConvert = 1 * XPOUND
        KConvert = 1
      End If
        
      If UnitsOut.Metric Then S = "Metric Units" Else S$ = "English Units"
      
      SSS$ = ""
      SSS$ = SSS$ & KTITLE$ & ", " & S$ & vbCrLf & vbCrLf
      SSS$ = SSS$ & "  WEIGHT    PCNT ON MAIN    NO. OF WHLS.  CONTACT AREA   CONTACT PRESSURE" & vbCrLf
      If UnitsOut.Metric Then
        SSS$ = SSS$ & "    kg                                        cm^2              MPa" & vbCrLf
      Else
        SSS$ = SSS$ & "    lb                                        in^2              psi" & vbCrLf
      End If
      SSS$ = SSS$ & LPad(9, Format(AMASS * WeightConvert, "#,###,##0"))
      SSS$ = SSS$ & LPad(12, Format(PMMG, "0.00"))
      SSS$ = SSS$ & LPad(13, Format(M, "0"))
      SSS$ = SSS$ & LPad(17, Format(AREA * LengthConvert * LengthConvert, "0.00"))
      SSS$ = SSS$ & LPad(17, Format(Q * PressConvert, "0.00")) & vbCrLf & vbCrLf
      SSS$ = SSS$ & "Coordinates of wheels" & vbCrLf
      SSS$ = SSS$ & "           End ACN          Start ACN           Input" & vbCrLf
      SSS$ = SSS$ & " No.      X       Y         X       Y         X       Y" & vbCrLf
      
      For I = 1 To M
        SSS$ = SSS$ & LPad(3, Format(I, "0"))
        SSS$ = SSS$ & LPad(10, Format(X(I) * LengthConvert, "0.00"))
        SSS$ = SSS$ & LPad(8, Format(Y(I) * LengthConvert, "0.00"))
        SSS$ = SSS$ & LPad(10, Format(XRigid(I) * InputWheelConvert, "0.00"))
        SSS$ = SSS$ & LPad(8, Format(YRigid(I) * InputWheelConvert, "0.00"))
        SSS$ = SSS$ & LPad(10, Format(XWheels(I) * InputWheelConvert, "0.00"))
        SSS$ = SSS$ & LPad(8, Format(YWheels(I) * InputWheelConvert, "0.00")) & vbCrLf
      Next I
      
'     For plotting the cutoff radius in frmGear.picGear from frmGear.Sub RigidACN.
      If frmGear.chkPCAThicknessDesign = vbChecked Then
        PlotCutOffX = X(1) - XMax
        PlotCutoffY = Y(1) - YMax
        PlotCutoffRad = XL * RigidCutoff
      End If
      
      SSS$ = SSS$ & vbCrLf
      SSS$ = SSS$ & " SUPPORT   PAVEMENT   RAD. REL.                      WHEEL" & vbCrLf
      SSS$ = SSS$ & " K VALUE   THICKNESS  STIFFNESS    ACN     STRESS    FACTOR" & vbCrLf
'      SSS$ = SSS$ & "K SUBBASE SUBGRADE    PAVEMENT THICKNESS    RAD. REL. STIFF.    ACN" & vbCrLf
      If ACN_mode_true Then ITemp = NSubs Else ITemp = 1 ' GFH 01/28/08. Allows use of interior stress for design.
'      If InputkValue = 0 Then ITemp = NSubs Else ITemp = 1
      For I = 1 To ITemp
        SSS$ = SSS$ & LPad(8, Format(ACNK(I) * KConvert, "0.00"))
        SSS$ = SSS$ & LPad(10, Format(DOut(I) * LengthConvert, "0.00"))
        If UnitsOut.Metric Then Temp = 1 Else Temp = 1 / XINCH
        SSS$ = SSS$ & LPad(11, Format(XLOut(I) * Temp, "0.00"))
        SSS$ = SSS$ & LPad(10, Format(ACNOut(I), "0.00"))
        If UnitsOut.Metric Then Temp = 1 Else Temp = XPRES
        SSS$ = SSS$ & LPad(10, Format(RigidStress(I) * Temp, "0.00"))
        SSS$ = SSS$ & LPad(7, Format(NWheelsForStress(I), "0"))
        SSS$ = SSS$ & "/" & Trim(Format(NWheelsForCut(I), "0")) & vbCrLf
      Next I
      
      SSS$ = SSS$ & vbCrLf
      
      ACNRigidOutputText$ = SSS$
      frmACN.optPavementType(1).Value = True
      
End Sub

Private Sub PARAB(A As Double, B As Double, C As Double, D As Double, S As Double, XL As Double, G As Double)
    G = D + ((A - B) / (2# * C - A - B) + 2# * S) * 0.025 * XL
End Sub

Private Sub XYMAX(M As Integer, XL As Double, B As Double, A As Double, C As Double, K As Integer, Y() As Double, YMax As Double)

'      DIMENSION Y(20)
    Dim AB As Double, N As Integer
'       GO TO (230,215,215,217,220,215,217,220),K
    If K = 1 Then
      GoTo 230
    ElseIf K = 2 Or K = 3 Then
      GoTo 215
    ElseIf K = 4 Then
      GoTo 217
    ElseIf K = 5 Then
      GoTo 220
    ElseIf K = 6 Then
      GoTo 215
    ElseIf K = 7 Then
      GoTo 217
    ElseIf K = 8 Then
      GoTo 220
    End If
    
215 For N = 1 To M
         
'         25/l0/85
'         No 1

'         Part 3.- Pavements                                    3-269
         
216   Y(N) = Y(N) - XL / 20#
    Next N
    GoTo 230
    
'   217 IF(B-A)218,215,215
217 If (B - A) < 0 Then GoTo 218 Else GoTo 215
    
218 For N = 1 To M
219   Y(N) = Y(N) + XL / 10#
    Next N
    GoTo 230
    
'   220 IF(Y(1))221,226,226
220 If Y(1) < 0 Then GoTo 221 Else GoTo 226
    
'   221 IF(2.*B-A-C)222,222,223
221 If (2 * B - A - C) <= 0 Then GoTo 222 Else GoTo 223

222 A = B
    B = C
    K = K - 1
    GoTo 215
    
223 Call PARAB(A, C, B, Y(1), 1#, XL, YMax)
224 AB = Y(1)
    For N = 1 To M
225   Y(N) = Y(N) + YMax - AB
    Next N
    GoTo 230
    
'   226 IF(2.*A-B-C)227,227,229
226 If (2 * A - B - C) <= 0 Then GoTo 227 Else GoTo 229
    
227 For N = 1 To M
228   Y(N) = Y(N) + XL / 20#
    Next N
    
    A = C
    B = A
    K = K - 1
    GoTo 230
    
229 Call PARAB(C, B, A, Y(1), -1#, XL, YMax)
    GoTo 224
    
230 Continue = 0

End Sub

Private Sub CACN(D As Double, ACN As Double, ISUB As Integer)
  
  Dim DACN(6, 4) As Double, SSW As Double, IACN As Integer
  
  DACN(1, 1) = -3.67886361:  DACN(2, 1) = -35.8015782:  DACN(3, 1) = 246.548051
  DACN(4, 1) = 5.37926926:   DACN(5, 1) = -0.141694493: DACN(6, 1) = 0.0019040826
  DACN(1, 2) = -0.899203216: DACN(2, 2) = -41.4577103:  DACN(3, 2) = 263.831975
  DACN(4, 2) = 6.66320153:   DACN(5, 2) = -0.18048103:  DACN(6, 2) = 0.00256828585
  DACN(1, 3) = 2.34293179:   DACN(2, 3) = -52.9601013:  DACN(3, 3) = 286.217274
  DACN(4, 3) = 8.03398385:   DACN(5, 3) = -0.209875377: DACN(6, 3) = 0.00305236166
  DACN(1, 4) = 13.9960077:   DACN(2, 4) = -88.4754059:  DACN(3, 4) = 319.839693
  DACN(4, 4) = 8.25962325:   DACN(5, 4) = -0.150019427: DACN(6, 4) = 0.00160530363
  
  SSW = DACN(1, ISUB)
  
  For IACN = 2 To 6
    SSW = SSW + DACN(IACN, ISUB) * D ^ (IACN - 1)
  Next IACN
  
  ACN = SSW * 2# / 1000# / 2.20462

End Sub

Private Sub RSUBK(SUBK As Double, SUBKO As Double)

    Dim SUBKI(7) As Double, SUBKII(7) As Double
    Dim NSave As Integer
    
    SUBKI(1) = 20#: SUBKI(2) = 25#: SUBKI(3) = 40#: SUBKI(4) = 60#
    SUBKI(5) = 80#: SUBKI(6) = 120#: SUBKI(7) = 150#
    SUBKII(1) = 75#: SUBKII(2) = 100#: SUBKII(3) = 150#: SUBKII(4) = 200#
    SUBKII(5) = 300#: SUBKII(6) = 400#: SUBKII(7) = 550#
    
    For NSave = 1 To 7
      If (SUBKO = SUBKI(NSave)) Then GoTo 20
    Next NSave
    
    Debug.Print "Invalid SUBK = "; SUBKO
    Stop

20  SUBK = SUBKII(NSave)
         
'         25/10/85
'         No. 1

End Sub

Private Sub FindStartWheel(XW() As Single, YW() As Single, ISelected As Integer)

  Dim I As Integer, J As Integer, N As Integer
  Dim Norm As Double, MinNorm As Double
  Dim NormL As Long, MinNormL As Long
  Dim MinNormX As Double, MinNormY As Double
  Dim Xcg As Double, Ycg As Double
  Dim X() As Double, Y() As Double
  Dim Res As Double, IPair As Integer, Index() As Integer
  
'  Res = 10
  Res = 10

  N = NWheels
  ReDim X(1 To N), Y(1 To N), Index(1 To N * N)
  
  If ISelected = 0 Then ' ISelected not set manually.
  
  If N > 1 Then

'     Find the minimum distance between two wheels.
      MinNorm = 1E+20
      For I = 1 To N
        For J = 1 To N
          If I <> J Then
            Norm = (XW(I) - XW(J)) ^ 2 + (YW(I) - YW(J)) ^ 2
            If Norm < MinNorm Then MinNorm = Norm
          End If
        Next J
      Next I
      MinNormL = Int(Res * MinNorm)
    
'     Find the wheel indexes for all wheel pairs with the same
'     separation distance as the minimum, to resolution Res.
      IPair = 0
      For I = 1 To N
        For J = 1 To N
          If I <> J Then
            NormL = Int(Res * ((XW(I) - XW(J)) ^ 2 + (YW(I) - YW(J)) ^ 2))
'            If NormL = MinNormL Then
            If NormL < 1.1 * MinNormL Then ' GFH 02-02-07 Temporary fix for the A380.
              IPair = IPair + 2
              Index(IPair - 1) = I
              Index(IPair) = J
            End If
          End If
        Next J
      Next I
      
    Else
    
      IPair = 1
      Index(IPair) = IPair
      
    End If
    
    Call GearCG(XW(), YW(), N, Xcg, Ycg)
    
'   Find the wheel in a minimum separation pair closest to the cg.
    MinNorm = 1E+20
    For I = 1 To IPair
      Norm = (XW(Index(I)) - Xcg) ^ 2 + (YW(Index(I)) - Ycg) ^ 2
      If Norm < MinNorm Then
        MinNorm = Norm
        ISelected = Index(I)
      End If
    Next I
    
' Else    Iselected set manually on plot.
  End If
  
  MinNormX = XW(ISelected)
  MinNormY = YW(ISelected)
    
  For I = 1 To N
    XW(I) = XW(I) - MinNormX
    YW(I) = YW(I) - MinNormY
  Next I
  
' Move origin to first index in wheel array.
  For I = 1 To N
    X(I) = XW(I)
    Y(I) = YW(I)
  Next I
' Debug.Print ISelected; (I + ISelected - 2) Mod N
  For I = 1 To N
    XW(I) = X(((I + ISelected - 2) Mod N) + 1)
    YW(I) = Y(((I + ISelected - 2) Mod N) + 1)
  Next I
 
'  Xcg = Xcg - MinNormX
'  Ycg = Ycg - MinNormY
    
'  XGridOrigin = XGridOrigin - MinNormX
'  XGridMax = XGridMax - MinNormX
'  YGridOrigin = YGridOrigin - MinNormY
'  YGridMax = YGridMax - MinNormY

End Sub
