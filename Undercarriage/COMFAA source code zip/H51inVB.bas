Attribute VB_Name = "modH51inVB"
'**************************************************************
'Module adopting H51 program
'Adopted by Izydor Kawa Last Update: April 10, 2001
'**************************************************************

Option Explicit
'DefInt I-N

Const PI As Double = 3.14159265359
Dim StopBtn As Boolean, PauseBtn As Boolean
Dim A As Double, AP(10) As Double, AH(10) As Double, AK(10) As Double
Dim ASIG(10) As Double, AG(10) As Double
Dim BIGX As Double, BIGY As Double, B As Double
Dim DPR As Double, Delta(10) As Double, DELTAR(10) As Double
Dim E As Double, ER(100) As Double
Dim FG(10) As Double
Dim G As Double, Gamma(10) As Double, GPRINT(100, 10) As Double
Dim H(10) As Double
'      COMMON /IBLK/
Dim TITL, ILH As Long, IPT As Long, IT As Long, ILD As Long
Dim ISG As Long, INOG As Long, KBP As Long
'      COMMON /NBLK/
Dim NOG As Long, NOH As Long, NPT As Long, NX As Long
Dim NY As Long, NOD As Long, NOSG As Long
'      COMMON /PBLK/
Dim P As Double, PIii, PVMTST(10) As Double, PHIE As Double
'      COMMON /RBLK/
Dim RPD As Double, RZERO As Double
'      COMMON /SBLK/

'Izydor Kawa code Begin
'Dim SIGMA(10) As Double, S As Double, SR As Double
Dim SIGMA(10) As Double, S1 As Double, SR As Double
'Izydor Kawa code End

'      COMMON /TBLK/
Dim T As Double, TR As Double
'      COMMON /WBLK/
Dim WR As Double, WR2 As Double
'      COMMON /XBLK/
Dim XK As Double, XLA As Double, XLB As Double, XLC As Double
Dim XLD As Double, XLAR As Double, XLBR As Double, XLCR As Double
Dim XLDR As Double, XLR As Double, XLR2 As Double
Dim XMU As Double, XNA As Double, XNB As Double, XNC As Double
Dim XND As Double, XNT As Double, XOP1 As Double
Dim XOP2 As Double, XOP3 As Double, XOP4 As Double, XOP5 As Double
Dim XOP6 As Double, ZP(100, 10) As Double, XPZ(4097) As Double
Dim XZERO As Double, XZEROP As Double
'      COMMON /YBLK/
Dim YMN(10) As Double, WP(100, 10) As Double
Dim YPZ(4097) As Double, YZERO As Double, YZEROP As Double
'      COMMON /BLK1/
Dim NW As Long, NZ As Long, CV(700) As Double

Dim IGEAR As Long, ETEMP As Double, XMUTEM As Double

Public Function EdgeStress(DesignData As InputData) As Double
  Dim FNo As Integer, J As Integer, I As Integer
  
    H(1) = DesignData.Thickness
    XK = DesignData.XK
    NOG = DesignData.NOG
  
    If NOG = 1 Then
      Gamma(1) = DesignData.Angle
    Else
      Gamma(1) = 0
      Gamma(2) = 90
    End If
    
  
    G = DesignData.GearLoad
    P = DesignData.TirePressure
  
    Delta(1) = DesignData.Delta
  
    XNA = DesignData.XNA
    XNB = DesignData.XNB
    XNC = DesignData.XNC
    XND = DesignData.XND
  
    XLA = DesignData.XLA
    XLB = DesignData.XLB
    XLC = DesignData.XLC
    XLD = DesignData.XLD
  
    
'  FNo = FreeFile
'  Open "H51.SDK" For Input As FNo
'  Input #FNo, NW, NZ
   
   NW = 25
   NZ = 25
  
   Call init_cv
   
'  For J = 1 To 675:
'  Input #FNo, CV(J):
'  Next J
'  Close (FNo)

  E = 4000000#
  XMU = 0.15
  Call PROBRD
  For ILH = 1 To NOH
    Call GEOM
    Call OUTLNE
  Next ILH
100   Continue

If NOG = 1 Then
EdgeStress = SIGMA(1)
Else
    If SIGMA(1) > SIGMA(2) Then
      EdgeStress = SIGMA(1)
    Else
      EdgeStress = SIGMA(2)
    End If
End If
' Debug.Print "H = "; H(1); "G = "; G; "P = "; P; "EdgeStress = "; EdgeStress
End Function

    Sub FINISH()
  Dim HHH As Double, J As Long, I As Long
  Dim DISTY As Double, DISTX As Double, Stress As Double
  Dim PrintResults As Boolean
  PrintResults = False ' GFH 01-28-08.
'      WRITE (6,10) TITL
'   10 FORMAT(1H1,10X,A)
  If PrintResults Then Debug.Print TITL
  HHH = H(ILH)
'      WRITE (6,20) H(ILH), XK, E, XMU, RZERO, DELTA(ILD)
'   20 FORMAT (1H0,10X,22HRUNWAY CHARACTERISTICS / 11X,3HH =,F8.3,
'     1 4H(IN),5X,3HK =,F8.1,11H(LBF/IN**3),5X,3HE =,F10.1 /
'     2 11X,4HMU =,F6.3,5X,4HRO =,F8.2,4H(IN),5X,7HDELTA =,F7.3 )
  If PrintResults Then Debug.Print "Runway Characteristics: ---------------------------------------------"
  If PrintResults Then Debug.Print "H      K      E      MU     RO     DELTA"
  If PrintResults Then Debug.Print Round(H(ILH), 3); XK; E; XMU; Round(RZERO, 3); Delta(ILD)
'      WRITE (6,30) XLA,XLB,XLC,XLD
'   30 FORMAT(1H0,10X, 4HGEAR /
'     1       1H ,10X,3HA =,F7.2,8H(IN) B =,F7.2,8H(IN) C =,F7.2,
'     2       8H(IN) D =,F7.2,4H(IN) )
  If PrintResults Then Debug.Print "XLA, XLB, XLC, XLD = "; XLA; XLB; XLC; XLD
'      WRITE (6,40) XNA,XNB,XNC,XND
'   40 FORMAT(1H ,10X,4HNA =,F5.1,6X,4HNB =,F5.1,6X,4HNC =,F5.1,6X,4HND =
'     1 , F5.1 )
'      WRITE (6,50) A,PHIE
  If PrintResults Then Debug.Print "XNA, XNB, XNC, XND = "; XNA; XNB; XNC; XND
'   50 FORMAT(1H0,10X,26HCONTACT AREA OF ONE TIRE =,F9.2,8H(SQ.IN.),
'     1 10X, 6HPHIE =,F5.3)
  If PrintResults Then Debug.Print "Contact area of one tire = "; Round(A, 3); "PHIE = "; PHIE
'      WRITE (6,60) P
'   60 FORMAT(1H0, 10X,20HINFLATION PRESSURE =,F7.1,5H(PSI) )
  If PrintResults Then Debug.Print "Inflation Pressure = "; P; " psi."
'      WRITE (6,70) G,B
'   70 FORMAT(1H0, 10X,11HGEAR LOAD =,F10.1,5H(LBF),10H       B =,F8.1//)
  If PrintResults Then Debug.Print "Gear Load = "; G; " lb"; " B = "; B
'      DO 500 INOG = 1,NOG
  For INOG = 1 To NOG
    Gamma(INOG) = Gamma(INOG) * DPR
'      WRITE (6,90) INOG,GAMMA(INOG),PVMTST(INOG),YMN(INOG),SIGMA(INOG)
'   90 FORMAT(1H ,10X,6HGAMMA(,I2,3H) =,F8.3,9H(DEG) N =,F7.2,5H MN =,
'     1 F9.2,8H(IN.LB.) /
'     2 1H ,10X,17HPAVEMENT STRESS =,F11.3,5H(PSI)//)
    If PrintResults Then Debug.Print "INOG   GAMMA   PVMTST (N)   MN   SIGMA"
    If PrintResults Then Debug.Print INOG; Gamma(INOG); Round(PVMTST(INOG), 3); Round(YMN(INOG), 3); " *** "; Round(SIGMA(INOG), 3); " *** "
  Next INOG
500   Continue
310   If (XOP3 - 0.5) <= 0 Then GoTo 160 Else GoTo 110
'  110 WRITE (6,120)
'  120 FORMAT (1H0,14X,1HZ,14X,1HW,10X,8HSUBTOTAL,10X,5HGAMMA)
110 Continue
  If PrintResults Then Debug.Print "Z      W       Subtotal       Gamma"
'      DO 150 J=1,NOG
      For J = 1 To NOG
'        DO 150 I=1,NPT
        For I = 1 To NPT
          DISTY = RZERO * ZP(I, J)
          DISTX = RZERO * WP(I, J)
          Stress = (RZERO * RZERO / 10000#) * P * GPRINT(I, J)
          Stress = 6# * Stress / (HHH * HHH)
'      WRITE(6,130) DISTY,DISTX,STRESS ,GAMMA(J)
'  130 FORMAT ((10H          ,2(F10.4,5X),2(F10.3,5X)))
          If PrintResults Then Debug.Print DISTY; DISTX; Stress; Gamma(J)
        Next I
      Next J
150   Continue
160   Continue
'      DO 600 INOG = 1, NOG
      For INOG = 1 To NOG
600     Gamma(INOG) = Gamma(INOG) * RPD
      Next INOG
'      Return
      End Sub


    Sub GEOM()
    
    Dim I As Long, J As Long, N1 As Long, N2 As Long
    Dim NX1 As Long, NY1 As Long

'
'
      RZERO = Sqr(Sqr((E * H(ILH) ^ 3) / (12# * (1# - XMU ^ 2) * XK)))
      XLAR = XLA / RZERO
      XLBR = XLB / RZERO
      XLCR = XLC / RZERO
      XLDR = XLD / RZERO
      WR = (XNA - 1#) * XLAR + XNA * (XNB - 1#) * XLBR
      XLR = (XNC - 1#) * XLCR + XNC * (XND - 1#) * XLDR

'IZYDOR KAWA code Begin
'      NX = (XNA * XNB + 1#) / 2# + 0.0001
'      NY = (XNC * XND + 1#) / 2# + 0.0001
      NX = Fix((XNA * XNB + 1#) / 2# + 0.0001)   'new version
      NY = Fix((XNC * XND + 1#) / 2# + 0.0001)   'new version
'IZYDOR KAWA code End
       
      WR2 = WR / 2#
      ER(2) = XLAR - XLBR
      XLR2 = XLR / 2#
      ER(5) = XLCR - XLDR
      N1 = XNB + 0.0001
'      DO 10 I = 1,NX
      For I = 1 To NX
        ER(3) = I - 1
        
'IZYDOR KAWA code Begin
'       ER(I + 50) = WR2 - ER(3) * XLBR - ER(2) * CDbl((I - 1) / N1)  old version
     ER(I + 50) = WR2 - ER(3) * XLBR - ER(2) * CDbl(Fix((I - 1) / N1)) 'new version
'IZYDOR KAWA code End

      Next I
10    Continue
      N2 = XND + 0.0001
'      DO 20 J = 1,NY
      For J = 1 To NY
        ER(6) = J - 1
        
'IZYDOR KAWA code Begin
'       ER(J + 7) = XLR2 - ER(6) * XLDR - ER(5) * CDbl((J - 1) / N2)  old version
     ER(J + 7) = XLR2 - ER(6) * XLDR - ER(5) * CDbl(Fix((J - 1) / N2)) 'new version
'IZYDOR KAWA code End

      Next J
20    Continue
      NX1 = NX
      NY1 = NY
      If (Abs(ER(NX + 50)) - 0.0000001) <= 0 Then GoTo 30 Else GoTo 40
30    ER(NX + 50) = 0#
      NX1 = NX - 1
40    NPT = 0
'      DO 60 J = 1,NY
      For J = 1 To NY
'        DO 50 I = 1,NX
        For I = 1 To NX
          NPT = NPT + 1
          XPZ(NPT) = ER(I + 50)
          YPZ(NPT) = ER(J + 7)
        Next I
      Next J
50    Continue
60    Continue
      If (Abs(ER(NY + 7)) - 0.0000001) <= 0 Then GoTo 70 Else GoTo 75
70    ER(NY + 7) = 0#
      NY1 = NY - 1
75    If (NY1) <= 0 Then GoTo 105 Else GoTo 80
'   80 DO 100 J = 1,NY1
80    Continue
      For J = 1 To NY1
'      DO 90  I = 1,NX
        For I = 1 To NX
          NPT = NPT + 1
          XPZ(NPT) = ER(I + 50)
          YPZ(NPT) = -ER(J + 7)
        Next I
      Next J
90    Continue
100   Continue
105   If (NX1) <= 0 Then GoTo 123 Else GoTo 107
'  107 DO 120 J = 1,NY
107   For J = 1 To NY
'        DO 110 I = 1,NX1
        For I = 1 To NX1
          NPT = NPT + 1
          XPZ(NPT) = -ER(I + 50)
          YPZ(NPT) = ER(J + 7)
        Next I
      Next J
110   Continue
120   Continue
123   If (NX1) <= 0 Then GoTo 200 Else GoTo 125
125   If (NY1) <= 0 Then GoTo 200 Else GoTo 128
'  128 DO 140 J = 1,NY1
128   For J = 1 To NY1
'       DO 130 I = 1,NX1
        For I = 1 To NX1
          NPT = NPT + 1
          XPZ(NPT) = -ER(I + 50)
          YPZ(NPT) = -ER(J + 7)
        Next I
      Next J
130   Continue
140   Continue
' 145 IF (DP(1)-0.5) 170,170,150
' CC150 WRITE (6,160) RZERO,XLAR,XLBR,XLCR,XLDR,WR,XLR
' 160 FORMAT (1H0,2X,32HRZERO,XLAR,XLBR,XLCR,XLDR,WR,XLR /
'    1 1H ,10E12.4)
' 170 IF (DP(2)-0.5) 200,200,180
' 180 WRITE (6,185) NX,NY,NPT,NX1,NY1,ILH
' 185 FORMAT (1H0,35H   NX   NY  NPT  NX1  NY1  ILH      / 1H ,10I5 )
'     WRITE (6,190) ER , (XPZ(I),YPZ(I),I=1,NPT)
' 190 FORMAT(1H0,2X,37HER(1)-ER(100),(XPZ(I),YPZ(I),I=1,NPT) /
'    1  (1H , 10E12.4 ) )
200   Continue
'      Return
'      End
    End Sub

    Sub OUTLNE()
    
    Dim J As Long, K As Long, GETAN As Double, M As Long
    Dim IE1 As Double, IE2 As Double, IE3 As Double, IE4 As Double
    Dim ZZERO As Double, WZERO As Double, DM As Double, DJ As Double
    Dim PX As Double, SAM As Double, XI As Double, YI As Double
    Dim ZI As Double, WI As Double, ZINT As Double, TNA As Double
    Dim IND As Long, TNB As Double, AZINT As Double, TSA As Double
'IZYDOR KAWA code Begin
'    Dim TSB As Double, TANS As Double, NOG As Long  old version
    Dim TSB As Double, TANS As Double 'new version
    Dim PrintResults As Boolean
    PrintResults = False
'IZYDOR KAWA code End
'
'IZYDOR KAWA code Begin
'      S = Sqr(A / (PI * PHIE))
      S1 = Sqr(A / (PI * PHIE))
      T = Sqr(A * PHIE / PI)
'      SR = S / RZERO
      SR = S1 / RZERO
'IZYDOR KAWA code End

      TR = T / RZERO
      ILD = 1
      If (NOD = 0) Then GoTo 8
7     DELTAR(ILD) = Delta(ILD) / RZERO
'     8 DO 50 K = 1,10
8     Continue
      For K = 1 To 10
        PVMTST(K) = 0#
'       DO 51 J = 1,100
        For J = 1 To 100
          GPRINT(J, K) = 0#
        Next J
      Next K
51    Continue
50    Continue
'      DO 305 INOG=1,NOG
      For INOG = 1 To NOG
        If (XOP6 = 1#) Then GoTo 10
        If (Gamma(INOG) = 0#) Then GoTo 20
        If (Abs(Gamma(INOG) - 90# * RPD) < 0.0000001) Then GoTo 30
        GETAN = Sin(Gamma(INOG)) / Cos(Gamma(INOG))
        XZEROP = -(XPZ(1) + SR * GETAN / Sqr((GETAN) ^ 2 _
               + PHIE ^ 2) + DELTAR(ILD) * Cos(Gamma(INOG)))
        YZEROP = -(YPZ(1) + TR * PHIE / Sqr((GETAN) ^ 2 + _
                PHIE ^ 2) - DELTAR(ILD) * Sin(Gamma(INOG)))
        GoTo 40
10      XZEROP = BIGX / RZERO
        YZEROP = BIGY / RZERO
        GoTo 40
20      XZEROP = -(DELTAR(ILD) + XPZ(NX))
        YZEROP = -(YPZ(1) + TR)
        GoTo 40
30      XZEROP = -(XPZ(1) + SR)
        YZEROP = (DELTAR(ILD) + YPZ(NY))
40      M = B / 4# + 0.99999999
        KBP = 4 * M
'                  START LOOP ON TIRE POINTS
        IE1 = 0
        IE2 = 0
        IE3 = 0
        IE4 = 0
'        DO 250 IPT = 1,NPT
        For IPT = 1 To NPT
          XZERO = XPZ(IPT) + SR - XZEROP
          YZERO = YPZ(IPT) - YZEROP
          ZZERO = XZERO * Cos(Gamma(INOG)) - YZERO * Sin(Gamma(INOG))
          WZERO = XZERO * Sin(Gamma(INOG)) + YZERO * Cos(Gamma(INOG))
'                   START LOOP ON TIRE PERIMETER
'          DO 200 J=1,KBP
          For J = 1 To KBP
            DM = M
            DJ = J
            If (1 <= J And J <= M) Then GoTo 60
            If (M + 1 <= J And J <= 2 * M) Then GoTo 70
            If (2 * M + 1 <= J And J <= 3 * M) Then GoTo 80
            PX = (4# * DM - DJ) / DM
            SAM = (1# + (PHIE - 1#) * PX ^ 3) * (Sin(PI * PX / 2#)) / PHIE
            XI = XPZ(IPT) - XZEROP + SR * Sqr(1# - SAM ^ 2)
            YI = YPZ(IPT) - YZEROP - TR * SAM
            GoTo 90
60          PX = (DJ / DM)
            SAM = (1# + (PHIE - 1#) * PX ^ 3) * (Sin(PI * PX / 2#)) / PHIE
            XI = XPZ(IPT) - XZEROP + SR * Sqr(1# - SAM ^ 2)
            YI = YPZ(IPT) - YZEROP + TR * SAM
            GoTo 90
70          PX = (2# * DM - DJ) / DM
            SAM = (1# + (PHIE - 1#) * PX ^ 3) * (Sin(PI * PX / 2#)) / PHIE
            XI = XPZ(IPT) - XZEROP - SR * Sqr(1# - SAM ^ 2)
            YI = YPZ(IPT) - YZEROP + TR * SAM
            GoTo 90
80          PX = (DJ - 2# * DM) / DM
            SAM = (1# + (PHIE - 1#) * PX ^ 3) * (Sin(PI * PX / 2#)) / PHIE
            XI = XPZ(IPT) - XZEROP - SR * Sqr(1# - SAM ^ 2)
            YI = YPZ(IPT) - YZEROP - TR * SAM
90          ZI = XI * Cos(Gamma(INOG)) - YI * Sin(Gamma(INOG))
            WI = XI * Sin(Gamma(INOG)) + YI * Cos(Gamma(INOG))
            ZINT = (ZI + ZZERO) / 2#
            If (ZINT < 0#) Then GoTo 110
            Call TABINT(ZINT, TNA, WI, NZ, NW, CV, IND)
            If (IND < 2) Then GoTo 100
            If (Abs(WI) < 0.00001) Then GoTo 100
            IE1 = IE1 + 1
            If (IE1 > 2) Then GoTo 400
'      WRITE (6,198) IND, ZINT, WI
'  198 FORMAT (1H0,32HDATA IS OUTSIDE LIMITS OF TABLE. / 10H     IND =,I2
'     1 ,5X,6HZINT =,E15.7,5X,4HWI =,E15.7)
     If PrintResults Then Debug.Print "Data is outside limits of the table"
     If PrintResults Then Debug.Print "IND, ZINT, WI = "; IND; ZINT; WI
400         Continue
            TNA = 0#
100         Call TABINT(ZINT, TNB, WZERO, NZ, NW, CV, IND)
            If (IND < 2) Then GoTo 130
            If (Abs(WZERO) < 0.00001) Then GoTo 130
            IE2 = IE2 + 1
            If (IE2 > 2) Then GoTo 500
'      WRITE (6,199) IND, ZINT, WZERO
'  199 FORMAT (1H0,32HDATA IS OUTSIDE LIMITS OF TABLE. / 10H     IND =,I2
'     1 ,5X,6HZINT =,E15.7,5X,7HWZERO =,E15.7)
     If PrintResults Then Debug.Print "Data is outside limits of the table"
     If PrintResults Then Debug.Print "IND, ZINT, WZERO = "; IND; ZINT; WZERO
500         Continue
            TNB = 0#
            GoTo 130
110         AZINT = -ZINT
            Call TABINT(AZINT, TSA, WI, NZ, NW, CV, IND)
            TNA = -TSA
            If (IND < 2) Then GoTo 120
            If (Abs(WI) < 0.00001) Then GoTo 120
            IE3 = IE3 + 1
            If (IE3 > 2) Then GoTo 600
'      WRITE (6,191) IND, AZINT, WI
'  191 FORMAT (1H0,32HDATA IS OUTSIDE LIMITS OF TABLE. / 10H     IND =,I2
'     1 ,5X,7HAZINT =,E15.7,5X,4HWI =,E15.7)
     If PrintResults Then Debug.Print "Data is outside limits of the table"
     If PrintResults Then Debug.Print "IND, AZINT, WI = "; IND; AZINT; WI
600         Continue
            TNA = 0#
120         Call TABINT(AZINT, TSB, WZERO, NZ, NW, CV, IND)
            TNB = -TSB
            If (IND < 2) Then GoTo 130
            If (Abs(WZERO) < 0.00001) Then GoTo 130
            IE4 = IE4 + 1
            If (IE4 > 2) Then GoTo 700
'      WRITE (6,192) IND, AZINT, WZERO
'  192 FORMAT (1H0,32HDATA IS OUTSIDE LIMITS OF TABLE. /
'     1 4X,5HIND =,I2,5X,7HAZINT =,E15.7,5X,7HWZERO =,E15.7)
     If PrintResults Then Debug.Print "Data is outside limits of the table"
     If PrintResults Then Debug.Print "IND, AZINT, WZERO = "; IND; AZINT; WZERO
700         Continue
            TNB = 0#
130         TANS = TNA - TNB
'     IF (DP(3) - 0.5) 150, 150, 140
' CC140 WRITE (6,95) XI, YI, ZI, WI, XZERO, YZERO, ZZERO, WZERO,
'    1 ZINT, GAMMA(INOG), TNA, TNB
'  95 FORMAT (1H0,6X,2HXI,13X,2HYI,13X,2HZI,13X,2HWI/    4(E15.7)//
'    1  5X,5HXZERO,10X,5HYZERO,10X,5HZZERO,10X,5HWZERO/    4(E15.7)//
'    2 6X,4HZINT,6X,11HGAMMA(INOG),9X,3HTNA,12X,3HTNB/ 4(E15.7))
            GPRINT(IPT, INOG) = GPRINT(IPT, INOG) + TANS
197         XZERO = XI
            YZERO = YI
            ZZERO = ZI
            WZERO = WI
          Next J
200       Continue
          PVMTST(INOG) = PVMTST(INOG) + GPRINT(IPT, INOG)
          If (XOP3 - 0.5) <= 0 Then GoTo 250 Else GoTo 230
230       ZP(IPT, INOG) = Cos(Gamma(INOG)) * (XPZ(IPT) - XZEROP) - Sin(Gamma(INOG) _
          ) * (YPZ(IPT) - YZEROP)
          WP(IPT, INOG) = Sin(Gamma(INOG)) * (XPZ(IPT) - XZEROP) + Cos(Gamma(INOG) _
          ) * (YPZ(IPT) - YZEROP)
' Izydor Kawa code begins
'        Next IPT  'old code
'250     Continue  'old code
250      Next IPT  'new code
' Izydor Kawa code ends

        YMN(INOG) = RZERO * RZERO / 10000# * P * PVMTST(INOG)
        SIGMA(INOG) = 6# * YMN(INOG) / H(ILH) ^ 2
        If (NOSG = 0) Then GoTo 305
'        DO 280 ISG=1,NOSG
        For ISG = 1 To NOSG
          AP(ISG) = AG(ISG) / (XNT * A)
          AH(ISG) = RZERO * Sqr(Abs((6# * AP(ISG) * PVMTST(INOG)) / (10000# * ASIG _
                  (ISG))))
          AK(ISG) = (34.1 / AH(ISG)) * (10# * AH(ISG) / RZERO) ^ 4
        Next ISG
280     Continue
290     Call CURVE
      
' Izydor Kawa code begins
305    Next INOG ' new code
'      Next INOG ' old code
'305   Continue  ' old code
' Izydor Kawa code ends

      Call FINISH
      If (NOD = 0) Then GoTo 320
      ILD = ILD + 1
      If (ILD <= NOD) Then GoTo 7
320   'Return
      End Sub

    Sub PROBRD()
'
'
'      PI = 3.1415927
  Dim XMUTEM  As Double, I As Long
  Dim PrintResults As Boolean
  PrintResults = False
      DPR = 180# / PI
      RPD = PI / 180#
'      READ(5,10) TITL
'  TITL = "A-300-600"
  TITL = libACName$(libIndex) 'Izydor Kawa added code

10    Format (A)
'      WRITE (6,20)
'   20 FORMAT(19X,'P R O B L E M  I N P U T  D A T A'  )
   If PrintResults Then Debug.Print "P R O B L E M  I N P U T  D A T A"
'      WRITE (6,30) TITL
'   30 FORMAT (11X, A60 )
   If PrintResults Then Debug.Print TITL
'------------------ CHANGED TO READ TYPE OF GEAR ----------------------
'      READ(5,*) IGEAR
'      IGEAR = 5 IZYDOR IGEAR not used in the program
'----------------------------------------------------------------------
'      READ(5,* ) XK,G,P,A,NOH,NOG,ETEMP,XMUTEM
' Izydor Kawa code Begin
'      XK = 200
'      XK = InputkValue 'Izydor Kawa added code
      
'      G = 167348
'      G = GrossWeight * PcntOnMainGears / 100 / NMainGears 'Izydor Kawa added code
'      P = 180
'      P = TirePressure 'Izydor Kawa added code
      A = 0
'Izydor Kawa code Begin
'      NOH = 10
      NOH = 1         'Izydor Kawa added code
'Izydor Kawa code Eng
      
'      NOG = 3
      'NOG = 1   'Izydor Kawa added code
      ETEMP = 4000000#
      XMUTEM = 0.15
      
       If (ETEMP <= 0#) Then GoTo 17
       E = ETEMP
       XMU = XMUTEM
17     Continue
'      WRITE (6,45)
'   45 FORMAT (1H0,3X,11HK(LB/CU IN),5X,5HG(LB),8X,6HP(PSI),6X,8HA(SQ IN)
'     1,4X, 8HNO. H(I),2X,12HNO. GAMMA(I) )
     If PrintResults Then Debug.Print "K, lb/in^3   G, lb     P, psi    A, in^2     NO. H(I)  NO. GAMMA(I)"
'      WRITE (6,50) XK, G, P, A, NOH, NOG
'   50 FORMAT (1H ,5X,F7.1,5X,F10.1,5X,F7.1,5X,F9.1,2(5X,I4) )
   If PrintResults Then Debug.Print XK; G; P; A; NOH; NOG


'Izydor Kawa code Begin
' IGEAR
' 1 - Single Wheel
' 2 - Twin
' 3 - Dual Twin
' 4 - Single Tandem
' 5 - Twin Tandem
' 6 - Dual Twin Tandem
' 7 - Triple Twin Tandem
' 8 - Others

'IGEAR = libIGear(libIndex)

'Select Case libGear$(libIndex)
'Case "A", "B" 'Single Wheel (OK!)
'    XNA = 1#
'    XNB = 1#
'    XNC = 1#
'    XND = 1#
'    XLA = 0#
'    XLB = 0#
'    XLC = 0#
'    XLD = 0#
'Case "D"     'Twin (OK!)
'    XNA = 2#
'    XNB = 1#
'    XNC = 1#
'    XND = 1#
'    XLA = libTT(libIndex)  'Spacing between two tires in a dual
'    XLB = 0#
'    XLC = 0#
'    XLD = 0#
'Case "Y"    'Dual Twin
'    XNA = 2#
'    XNB = 2#
'    XNC = 1#
'    XND = 1#
'    'Transverse center to center distance between two inside tires
'    XLA = libTX(libIndex, 3) - libTX(libIndex, 2)
'    'Transverse center to center spacing between tires in a dual
'    XLB = libTX(libIndex, 4) - libTX(libIndex, 3)
'    XLC = 0#
'    XLD = 0#
'Case "E" 'Single Tandem
'    XNA = 1#
'    XNB = 1#
'    XNC = 2#
'    XND = 1#
'    XLA = 0#
'    XLB = 0#
'    ' Distance between tires
'    XLC = libTY(libIndex, 2) - libTY(libIndex, 1)
'    XLD = 0#
'Case "F", "H", "J" 'Twin Tandem (OK!)
'    XNA = 2#
'    XNB = 1#
'    XNC = 2#
'    XND = 1#
'    XLA = libTT(libIndex)  'Transverse spacing between tires
'    XLB = 0#
'    XLC = libB(libIndex)  'Longitudinal spacing between tires
'    XLD = 0#
'Case "X" 'Dual Twin Tandem
'    XNA = 2#
'    XNB = 2#
'    XNC = 2#
'    XND = 1#
'     'Transverse spacing between inside tires in the gear
'    XLA = libTX(libIndex, 3) - libTX(libIndex, 2)
'     'Transverse spacing between tires in a dual set
'    XLB = libTX(libIndex, 4) - libTX(libIndex, 3)
'     'Longitudinal spacing between tires in a dual set
'    XLC = libTY(libIndex, 5) - libTY(libIndex, 1)
'    XLD = 0#
'Case "N" 'Triple Twin Tandem (OK!)
'    XNA = 2#
'    XNB = 1#
'    XNC = 3#
'    XND = 1#
'    XLA = libTT(libIndex) 'Tranvser spacing between tires
'    XLB = 0#
'    XLC = libB(libIndex)  'Longitudinal spacing between tires
'    XLD = 0#
'Case "OTHERS" 'Others
''ACNComp does not calculate slab edge stress for "others" gear configurations
''Case Else
'
'End Select
'Izydor Kawa code End

'      READ (5,*) XLA, XLB, XLC, XLD, NOD, NOSG
'      XLA = 27  'Izydor Kawa COMMENTED
'      XLA = 24  'Izydor Kawa COMMENTED
'      XLB = 56  'Izydor Kawa COMMENTED
'      XLC = 58  'Izydor Kawa COMMENTED
'      XLD = 0   'Izydor Kawa COMMENTED
      
      NOD = 1
      NOSG = 0
      
'      WRITE (6,60)
'   60 FORMAT (1H0,3X,50HSMALL A(IN)  SMALL B(IN)  SMALL C(IN)  SMALL D(I
'     1N),22H NO. DELTA(I) NO.(S,G) )
     If PrintResults Then Debug.Print "SMALL A(IN)   SMALL B(IN)   SMALL C(IN)   SMALL D(IN)  NO. DELTA(I)  NO.(S,G)"
'      WRITE (6,65) XLA,XLB,XLC,XLD,NOD,NOSG
'   65 FORMAT (1H ,5X,F7.2,3(6X,F7.2),7X,I4,5X,I4)
   If PrintResults Then Debug.Print XLA; XLB; XLC; XLD; NOD; NOSG
'      READ(5,*)XNA,XNB,XNC,XND,PHIE
'      XNA = 2
'      XNB = 1
'      XNB = 2
'      XNC = 2
'      XNC = 2
'      XND = 1
      PHIE = 1.667
      
      XOP1 = 0#
      If (PHIE = 0#) Then PHIE = 5# / 3#
'      WRITE (6,70)       XNA,XNB,XNC,XND,PHIE
'   70 FORMAT (1H0,5X,3HXNA,9X,3HXNB,9X,3HXNC,9X,3HXND,9X,6HPHI(E)/
'     11H ,4X,F4.1,4(8X,F4.1))
     If PrintResults Then Debug.Print "XNA    XNB    XNC    XND    PHI(E)"
     If PrintResults Then Debug.Print XNA; XNB; XNC; XND; PHIE



'      READ (5,*) B, XOP3, BIGX, BIGY, XOP6
     B = 150
     XOP3 = 0
     BIGX = 0
     BIGY = 0
     XOP6 = 0

'      WRITE (6,75) B, XOP3, BIGX, BIGY, XOP6
'   75 FORMAT (1H0,8X,1HB,6X,9HPRINT OPT,3X,5HBIG X,7X,5HBIG Y,6X,
'     18HCOOR OPT /1H ,5X,F7.1,5X,F4.1,2(5X,F7.2),7X,F4.1 )
     If PrintResults Then Debug.Print "B    PRINT OPT    BIG X    BIG Y    COOR OPT"
     If PrintResults Then Debug.Print B; XOP3; BIGX; BIGY; XOP6
'      READ (5,*) (H(I),I=1,NOH)
' Izydor Kawa code Begin
'     H(1) = 10:  H(2) = 12:  H(3) = 14:  H(4) = 16:  H(5) = 18
'     H(6) = 20:  H(7) = 22:  H(8) = 25:  H(9) = 28:  H(10) = 30
     
'      WRITE (6,80) (H(I),I=1,NOH)
'   80 FORMAT (1H0,30X,9HH(I) (IN) /
'     11H ,2X,6(F7.2,4X) )
     
'     Debug.Print "H(I) = ";
'     For I = 1 To NOH:  Debug.Print H(I);:  Next I
'     Debug.Print

'      READ (5,*) (GAMMA(I), I=1,NOG)
'     GAMMA(1) = 22.5:  GAMMA(2) = 45:  GAMMA(3) = 67.5 'Izydor Kawa commented
'     Gamma(1) = 0:   Gamma(2) = 90:  'GAMMA(3) = 90
     
     
     
'      WRITE (6,85) (GAMMA(I), I=1,NOG)
'   85 FORMAT (1H0,27X,14HGAMMA(I) (DEG)/
'     11H ,2X,6(F7.2,4X) )

'     Debug.Print "GAMMA(I) = ";
'     For I = 1 To NOG:  Debug.Print Gamma(I);:  Next I
'     Debug.Print
     
      If (NOD = 0) Then GoTo 97
'      READ (5,*) (DELTA(I), I=1,NOD)

'      Delta(1) = 0 'commented by Izydor Kawa
      
'      WRITE (6,90) (DELTA(I), I=1,NOD)
'   90 FORMAT (1H0,30X,8HDELTA(I) /
'     11H ,2X,6(F7.2,4X) )
     If PrintResults Then Debug.Print "DELTA(I) = ";
     If PrintResults Then
       For I = 1 To NOD:  Debug.Print Delta(I);:  Next I
     End If
     If PrintResults Then Debug.Print
97    If (NOSG = 0) Then GoTo 99
'      READ (5,*) (ASIG(I), AG(I), I=1,NOSG)
     ASIG(1) = 0:  AG(1) = 0
     If PrintResults Then Debug.Print "ASIG(I)     AG(I)"
     If PrintResults Then
       For I = 1 To NOSG
         Debug.Print ASIG(I); AG(I)
       Next I
     End If
'      WRITE (6,95) ( ASIG(I),AG(I), I=1,NOSG)
'   95 FORMAT (1H0,6X,7HASIG(I),9X,5HAG(I) /    2(5X,F10.1)/)
'   99 DO 300 I = 1,NOG
99 Continue
     For I = 1 To NOG
       Gamma(I) = Gamma(I) * RPD
     Next I
300   Continue
      XNT = XNA * XNB * XNC * XND
'      IF (A) 490, 500, 490
      If A = 0 Then GoTo 500 Else GoTo 490
490   P = G / (A * XNT)
      GoTo 510
500   A = G / (P * XNT)
510   G = A * P * XNT
'      Return
      End Sub

    Sub CURVE()
'C
'C
    Dim PrintResults As Boolean
    PrintResults = False
      Gamma(INOG) = Gamma(INOG) * DPR
'      WRITE (6,10) E, XMU
'   10 FORMAT (1H1,4X, 3HE =,F10.1,5X, 5HXMU =,F6.3)
  If PrintResults Then Debug.Print "E = "; E; "XMU = "; XMU
'      WRITE (6,30) XLA,XLB,XLC,XLD
'   30 FORMAT(1H0,10X, 4HGEAR /
'     1       1H ,10X,3HA =,F7.2,8H(IN) B =,F7.2,8H(IN) C =,F7.2,
'     2       8H(IN) D =,F7.2 )
  If PrintResults Then Debug.Print "XLA, XLB, XLC, XLD = "; XLA; XLB; XLC; XLD
'      WRITE (6,40) XNA,XNB,XNC,XND
'   40 FORMAT(1H ,10X,4HNA =,F5.1,6X,4HNB =,F5.1,6X,4HNC =,F5.1,6X,4HND =
'     1 , F5.1 )
  If PrintResults Then Debug.Print "XNA, XNB, XNC, XND = "; XNA; XNB; XNC; XND
'      WRITE (6,50) A,PHIE
'   50 FORMAT(1H0,10X,26HCONTACT AREA OF ONE TIRE =,F9.2,8H(SQ.IN.),
'     1 10X, 6HPHIE =,F5.3)
  If PrintResults Then Debug.Print "Contact area of one tire = "; A; "PHIE = "; PHIE
'      WRITE (6,60) H(ILH), GAMMA(INOG), DELTA(ILD), PVMTST(INOG)
'   60 FORMAT (1H0,4X, 3HH =,F8.3,5X, 7HGAMMA =,F8.3,5X, 7HDELTA =,F8.3,
'     1  5X, 3HN= ,F11.3)
  If PrintResults Then Debug.Print "H, Gamma, Delta, PVMTST (N) = "; H(ILH); Gamma(INOG); Delta(ILD); PVMTST(INOG)
'      DO 100 ISG=1,NOSG
  If PrintResults Then Debug.Print "ASIG(ISG)      AG(ISG)     AP(ISG)     AH(ISG)     AK(ISG)"
  If PrintResults Then
    For ISG = 1 To NOSG
'      WRITE (6,70) ASIG(ISG), AG(ISG), AP(ISG), AH(ISG), AK(ISG)
'   70 FORMAT (1H0,2X, 7HSIGMA =,F 8.3,2X, 3HG =,F 8.1,2X, 3HP =F7.1,2X,
'     1  3HH =F8.3,2X,3HK =,F8.1)
      Debug.Print ASIG(ISG); AG(ISG); AP(ISG); AH(ISG); AK(ISG)
    Next ISG
  End If
100   Continue
      Gamma(INOG) = Gamma(INOG) * RPD
'      Return
      End Sub

Sub TABINT(X As Double, Y As Double, Z As Double, NX As Long, NZ As Long, CV() As Double, IND As Long)
' Izydor Kawa code begin
Dim I As Integer, J As Integer, IL As Integer, JL As Integer
Dim JS As Integer, IZ As Integer, IQ As Integer
Dim K1 As Integer, K2 As Integer, K3 As Integer, K4 As Integer
Dim Y1S As Double, Y1L As Double, Y1 As Double
Dim Y2S As Double, Y2L As Double, Y2 As Double
' Izydor Kawa code end

'      DIMENSION CV(700)
      Dim ISS As Long
      IND = 1
'      DO 100 I=26,50
      For I = 26 To 50
        If (Z < CV(26)) Then GoTo 200
        If (Z < CV(I)) Then GoTo 300
      Next I
100   Continue
      IND = 5
      ISS = 49
      IL = 50
      GoTo 250
200   IND = 4
      ISS = 26
      IL = 27
      GoTo 250
300   IL = I
      ISS = I - 1
250 ' DO 800 J = 1,25
      For J = 1 To 25
        If (X < CV(1)) Then GoTo 900
        If (X < CV(J)) Then GoTo 1000
      Next J
800   Continue
      IND = 3
      JS = 24
      JL = 25
      GoTo 950
900   JS = 1
      JL = 2
      IND = 2
      GoTo 950
1000  JL = J
      JS = J - 1
950   Continue
      IZ = ISS - 25
      IQ = IL - 25
      K1 = 50 + (IZ - 1) * 25 + JS
      Y1S = CV(K1)
      K2 = K1 + 1
      Y1L = CV(K2)
      K3 = 50 + (IQ - 1) * 25 + JS
      Y2S = CV(K3)
      K4 = K3 + 1
      Y2L = CV(K4)
      If (IND > 1) Then GoTo 1100
1010  Y1 = (((Y1L - Y1S) / (CV(JL) - CV(JS))) * (X - CV(JS))) + Y1S
      Y2 = (((Y2L - Y2S) / (CV(JL) - CV(JS))) * (X - CV(JS))) + Y2S
      If (IND > 1) Then GoTo 1050
1020  Y = (((Y2 - Y1) / (CV(IL) - CV(ISS))) * (Z - CV(ISS))) + Y1
      If (IND > 1) Then GoTo 1070
      GoTo 2000
1100  If (X < CV(1)) Then GoTo 1010
      If (X > CV(25)) Then GoTo 1040
      GoTo 1010
1040  Y1 = (((Y1L - Y1S) / (CV(JL) - CV(JS))) * (X - CV(JL))) + Y1L
      Y2 = (((Y2L - Y2S) / (CV(JL) - CV(JS))) * (X - CV(JL))) + Y2L
1050  If (Z < CV(26)) Then GoTo 1020
      If (Z > CV(50)) Then GoTo 1060
      GoTo 1020
1060  Y = (((Y2 - Y1) / (CV(IL) - CV(ISS))) * (Z - CV(IL))) + Y2
1070  Continue
2000  Continue
'      Return
      End Sub

Sub init_cv()
CV(1) = 0
CV(2) = 0.1
CV(3) = 0.2
CV(4) = 0.3
CV(5) = 0.4
CV(6) = 0.5
CV(7) = 0.6
CV(8) = 0.8
CV(9) = 1
CV(10) = 1.2
CV(11) = 1.4
CV(12) = 1.6
CV(13) = 1.8
CV(14) = 2
CV(15) = 2.2
CV(16) = 2.4
CV(17) = 2.6
CV(18) = 2.8
CV(19) = 3
CV(20) = 3.2
CV(21) = 3.4
CV(22) = 3.6
CV(23) = 3.8
CV(24) = 4
CV(25) = 8
CV(26) = 0
CV(27) = 0.1
CV(28) = 0.2
CV(29) = 0.3
CV(30) = 0.4
CV(31) = 0.5
CV(32) = 0.6
CV(33) = 0.8
CV(34) = 1
CV(35) = 1.2
CV(36) = 1.4
CV(37) = 1.6
CV(38) = 1.8
CV(39) = 2
CV(40) = 2.2
CV(41) = 2.4
CV(42) = 2.6
CV(43) = 2.8
CV(44) = 0
CV(45) = 3.2
CV(46) = 3.4
CV(47) = 3.6
CV(48) = 3.8
CV(49) = 4
CV(50) = 8
CV(51) = 0
CV(52) = 0
CV(53) = 0
CV(54) = 0
CV(55) = 0
CV(56) = 0
CV(57) = 0
CV(58) = 0
CV(59) = 0
CV(60) = 0
CV(61) = 0
CV(62) = 0
CV(63) = 0
CV(64) = 0
CV(65) = 0
CV(66) = 0
CV(67) = 0
CV(68) = 0
CV(69) = 0
CV(70) = 0
CV(71) = 0
CV(72) = 0
CV(73) = 0
CV(74) = 0
CV(75) = 0
CV(76) = 0
CV(77) = 59.61
CV(78) = 96.44
CV(79) = 121.67
CV(80) = 139.43
CV(81) = 151.81
CV(82) = 160.1
CV(83) = 167.67
CV(84) = 166.85
CV(85) = 160.54
CV(86) = 150.71
CV(87) = 138.77
CV(88) = 125.74
CV(89) = 112.35
CV(90) = 99.14
CV(91) = 86.47
CV(92) = 74.61
CV(93) = 63.7
CV(94) = 53.82
CV(95) = 45
CV(96) = 37.23
CV(97) = 30.47
CV(98) = 24.65
CV(99) = 19.7
CV(100) = 19.7
CV(101) = 0
CV(102) = 104.57
CV(103) = 175.97
CV(104) = 226.34
CV(105) = 262.29
CV(106) = 287.66
CV(107) = 304.92
CV(108) = 321.48
CV(109) = 321.23
CV(110) = 309.93
CV(111) = 291.52
CV(112) = 268.79
CV(113) = 243.78
CV(114) = 217.96
CV(115) = 192.4
CV(116) = 167.84
CV(117) = 144.8
CV(118) = 123.58
CV(119) = 104.35
CV(120) = 87.18
CV(121) = 72.05
CV(122) = 58.88
CV(123) = 47.55
CV(124) = 37.91
CV(125) = 37.91
CV(126) = 0
CV(127) = 140.04
CV(128) = 241.75
CV(129) = 315.9
CV(130) = 369.83
CV(131) = 408.44
CV(132) = 435.13
CV(133) = 461.85
CV(134) = 463.43
CV(135) = 448.39
CV(136) = 422.58
CV(137) = 390.18
CV(138) = 354.22
CV(139) = 316.9
CV(140) = 279.84
CV(141) = 244.15
CV(142) = 210.61
CV(143) = 179.69
CV(144) = 151.65
CV(145) = 126.6
CV(146) = 104.52
CV(147) = 85.29
CV(148) = 68.75
CV(149) = 54.68
CV(150) = 54.68
CV(151) = 0
CV(152) = 169.01
CV(153) = 296.76
CV(154) = 392.57
CV(155) = 463.64
CV(156) = 515.33
CV(157) = 551.63
CV(158) = 589.36
CV(159) = 593.86
CV(160) = 576.22
CV(161) = 544.14
CV(162) = 503.13
CV(163) = 457.21
CV(164) = 409.31
CV(165) = 361.58
CV(166) = 315.5
CV(167) = 272.13
CV(168) = 232.1
CV(169) = 195.77
CV(170) = 163.3
CV(171) = 134.67
CV(172) = 109.73
CV(173) = 88.28
CV(174) = 70.05
CV(175) = 70.05
CV(176) = 0
CV(177) = 193.18
CV(178) = 343.27
CV(179) = 458.41
CV(180) = 545.37
CV(181) = 609.6
CV(182) = 655.41
CV(183) = 704.64
CV(184) = 712.96
CV(185) = 693.75
CV(186) = 656.43
CV(187) = 607.82
CV(188) = 552.89
CV(189) = 495.29
CV(190) = 437.69
CV(191) = 381.96
CV(192) = 329.41
CV(193) = 280.86
CV(194) = 236.75
CV(195) = 197.31
CV(196) = 162.52
CV(197) = 132.22
CV(198) = 106.17
CV(199) = 84.03
CV(200) = 84.03
CV(201) = 0
CV(202) = 213.63
CV(203) = 382.94
CV(204) = 515.16
CV(205) = 616.59
CV(206) = 692.58
CV(207) = 747.58
CV(208) = 808.45
CV(209) = 821.26
CV(210) = 801.36
CV(211) = 759.75
CV(212) = 704.47
CV(213) = 641.42
CV(214) = 574.95
CV(215) = 508.25
CV(216) = 443.57
CV(217) = 382.47
CV(218) = 325.96
CV(219) = 274.58
CV(220) = 228.61
CV(221) = 188.05
CV(222) = 152.73
CV(223) = 122.37
CV(224) = 96.58
CV(225) = 96.58
CV(226) = 0
CV(227) = 246.13
CV(228) = 446.42
CV(229) = 606.88
CV(230) = 732.99
CV(231) = 829.74
CV(232) = 901.53
CV(233) = 984.96
CV(234) = 1007.91
CV(235) = 988.7
CV(236) = 940.95
CV(237) = 874.88
CV(238) = 798.08
CV(239) = 716.24
CV(240) = 633.53
CV(241) = 552.95
CV(242) = 476.58
CV(243) = 405.78
CV(244) = 341.31
CV(245) = 283.57
CV(246) = 232.61
CV(247) = 188.24
CV(248) = 150.11
CV(249) = 117.75
CV(250) = 117.75
CV(251) = 0
CV(252) = 270.36
CV(253) = 494.03
CV(254) = 676.25
CV(255) = 821.93
CV(256) = 935.68
CV(257) = 1021.74
CV(258) = 1125.54
CV(259) = 1159.02
CV(260) = 1142.32
CV(261) = 1090.98
CV(262) = 1016.97
CV(263) = 929.35
CV(264) = 834.99
CV(265) = 738.97
CV(266) = 644.97
CV(267) = 555.59
CV(268) = 472.54
CV(269) = 396.8
CV(270) = 328.91
CV(271) = 268.96
CV(272) = 216.78
CV(273) = 171.96
CV(274) = 133.97
CV(275) = 133.97
CV(276) = 0
CV(277) = 288.65
CV(278) = 530.07
CV(279) = 729.03
CV(280) = 890.03
CV(281) = 1017.39
CV(282) = 1115.16
CV(283) = 1236.45
CV(284) = 1279.87
CV(285) = 1266.56
CV(286) = 1213.4
CV(287) = 1133.68
CV(288) = 1037.67
CV(289) = 933.23
CV(290) = 826.27
CV(291) = 721.09
CV(292) = 620.76
CV(293) = 527.33
CV(294) = 442
CV(295) = 365.44
CV(296) = 297.82
CV(297) = 238.97
CV(298) = 188.45
CV(299) = 145.68
CV(300) = 145.68
CV(301) = 0
CV(302) = 302.51
CV(303) = 557.45
CV(304) = 769.25
CV(305) = 942.15
CV(306) = 1080.24
CV(307) = 1187.41
CV(308) = 1323.31
CV(309) = 1375.43
CV(310) = 1365.74
CV(311) = 1311.89
CV(312) = 1228.14
CV(313) = 1125.7
CV(314) = 1013.25
CV(315) = 897.39
CV(316) = 782.99
CV(317) = 673.53
CV(318) = 571.39
CV(319) = 477.98
CV(320) = 394.1
CV(321) = 319.99
CV(322) = 255.52
CV(323) = 200.22
CV(324) = 153.45
CV(325) = 153.45
CV(326) = 0
CV(327) = 313.02
CV(328) = 578.23
CV(329) = 799.85
CV(330) = 981.92
CV(331) = 1128.36
CV(332) = 1242.95
CV(333) = 1390.47
CV(334) = 1450.14
CV(335) = 1443.88
CV(336) = 1389.98
CV(337) = 1303.4
CV(338) = 1196.05
CV(339) = 1077.26
CV(340) = 954.22
CV(341) = 832.28
CV(342) = 715.29
CV(343) = 605.92
CV(344) = 505.78
CV(345) = 415.79
CV(346) = 336.27
CV(347) = 267.12
CV(348) = 207.84
CV(349) = 157.78
CV(350) = 157.78
CV(351) = 0
CV(352) = 320.96
CV(353) = 593.95
CV(354) = 823.03
CV(355) = 1012.11
CV(356) = 1164.98
CV(357) = 1285.34
CV(358) = 1442.14
CV(359) = 1507.91
CV(360) = 1504.67
CV(361) = 1451.04
CV(362) = 1362.45
CV(363) = 1251.33
CV(364) = 1127.56
CV(365) = 998.78
CV(366) = 870.73
CV(367) = 747.6
CV(368) = 632.29
CV(369) = 526.59
CV(370) = 431.55
CV(371) = 347.56
CV(372) = 274.56
CV(373) = 212.01
CV(374) = 159.27
CV(375) = 159.27
CV(376) = 0
CV(377) = 326.92
CV(378) = 605.76
CV(379) = 840.47
CV(380) = 1034.86
CV(381) = 1192.63
CV(382) = 1317.41
CV(383) = 1481.4
CV(384) = 1552.01
CV(385) = 1551.27
CV(386) = 1498
CV(387) = 1407.95
CV(388) = 1293.94
CV(389) = 1166.26
CV(390) = 1032.9
CV(391) = 899.94
CV(392) = 771.82
CV(393) = 651.67
CV(394) = 541.43
CV(395) = 442.28
CV(396) = 354.65
CV(397) = 278.52
CV(398) = 213.34
CV(399) = 158.47
CV(400) = 158.47
CV(401) = 0
CV(402) = 331.36
CV(403) = 614.56
CV(404) = 853.47
CV(405) = 1051.83
CV(406) = 1213.27
CV(407) = 1341.39
CV(408) = 1510.85
CV(409) = 1585.19
CV(410) = 1586.42
CV(411) = 1533.47
CV(412) = 1442.32
CV(413) = 1326.06
CV(414) = 1195.29
CV(415) = 1058.29
CV(416) = 921.39
CV(417) = 789.25
CV(418) = 665.2
CV(419) = 551.29
CV(420) = 448.81
CV(421) = 358.24
CV(422) = 279.59
CV(423) = 212.31
CV(424) = 155.76
CV(425) = 155.76
CV(426) = 0
CV(427) = 334.62
CV(428) = 621.03
CV(429) = 863.04
CV(430) = 1064.33
CV(431) = 1228.49
CV(432) = 1359.08
CV(433) = 1532.61
CV(434) = 1609.74
CV(435) = 1612.43
CV(436) = 1559.7
CV(437) = 1467.67
CV(438) = 1349.63
CV(439) = 1216.42
CV(440) = 1076.53
CV(441) = 936.49
CV(442) = 801.13
CV(443) = 673.94
CV(444) = 557.09
CV(445) = 451.95
CV(446) = 359.04
CV(447) = 278.4
CV(448) = 209.49
CV(449) = 151.65
CV(450) = 151.65
CV(451) = 0
CV(452) = 336.98
CV(453) = 625.71
CV(454) = 869.96
CV(455) = 1073.37
CV(456) = 1239.5
CV(457) = 1371.88
CV(458) = 1548.36
CV(459) = 1627.49
CV(460) = 1631.22
CV(461) = 1578.58
CV(462) = 1485.82
CV(463) = 1366.34
CV(464) = 1231.16
CV(465) = 1088.96
CV(466) = 946.42
CV(467) = 808.51
CV(468) = 678.83
CV(469) = 559.65
CV(470) = 452.41
CV(471) = 357.66
CV(472) = 275.48
CV(473) = 205.33
CV(474) = 146.53
CV(475) = 146.53
CV(476) = 0
CV(477) = 338.65
CV(478) = 629.02
CV(479) = 874.85
CV(480) = 1079.76
CV(481) = 1247.28
CV(482) = 1380.92
CV(483) = 1559.47
CV(484) = 1639.98
CV(485) = 1644.37
CV(486) = 1591.69
CV(487) = 1498.27
CV(488) = 1377.61
CV(489) = 1240.86
CV(490) = 1096.82
CV(491) = 952.3
CV(492) = 812.36
CV(493) = 680.71
CV(494) = 559.69
CV(495) = 450.81
CV(496) = 354.64
CV(497) = 271.28
CV(498) = 200.2
CV(499) = 140.72
CV(500) = 140.72
CV(501) = 0
CV(502) = 339.8
CV(503) = 631.3
CV(504) = 878.22
CV(505) = 1084.15
CV(506) = 1252.62
CV(507) = 1387.11
CV(508) = 1567.04
CV(509) = 1648.43
CV(510) = 1653.19
CV(511) = 1600.37
CV(512) = 1506.36
CV(513) = 1384.71
CV(514) = 1246.68
CV(515) = 1101.16
CV(516) = 955.06
CV(517) = 815.53
CV(518) = 680.34
CV(519) = 557.89
CV(520) = 447.43
CV(521) = 350.48
CV(522) = 266.24
CV(523) = 194.48
CV(524) = 134.53
CV(525) = 134.53
CV(526) = 0
CV(527) = 340.56
CV(528) = 632.8
CV(529) = 880.44
CV(530) = 1087.04
CV(531) = 1256.12
CV(532) = 1391.16
CV(533) = 1571.96
CV(534) = 1653.86
CV(535) = 1658.75
CV(536) = 1605.7
CV(537) = 1511.13
CV(538) = 1388.64
CV(539) = 1249.56
CV(540) = 1102.84
CV(541) = 955.49
CV(542) = 812.71
CV(543) = 678.32
CV(544) = 554.77
CV(545) = 443.64
CV(546) = 345.57
CV(547) = 260.69
CV(548) = 188.46
CV(549) = 128.21
CV(550) = 128.21
CV(551) = 0
CV(552) = 341.02
CV(553) = 633.72
CV(554) = 881.8
CV(555) = 1088.81
CV(556) = 1258.26
CV(557) = 1393.62
CV(558) = 1574.9
CV(559) = 1657.03
CV(560) = 1661.89
CV(561) = 1608.55
CV(562) = 1513.45
CV(563) = 1390.24
CV(564) = 1250.29
CV(565) = 1102.61
CV(566) = 954.27
CV(567) = 810.51
CV(568) = 675.2
CV(569) = 550.81
CV(570) = 438.95
CV(571) = 340.29
CV(572) = 254.97
CV(573) = 182.43
CV(574) = 122.01
CV(575) = 122.01
CV(576) = 0
CV(577) = 341.28
CV(578) = 634.23
CV(579) = 882.55
CV(580) = 1089.78
CV(581) = 1259.41
CV(582) = 1394.93
CV(583) = 1576.4
CV(584) = 1658.56
CV(585) = 1663.25
CV(586) = 1609.57
CV(587) = 1513.97
CV(588) = 1390.13
CV(589) = 1249.46
CV(590) = 1101
CV(591) = 951.86
CV(592) = 807.33
CV(593) = 671.3
CV(594) = 546.28
CV(595) = 433.88
CV(596) = 334.8
CV(597) = 249.18
CV(598) = 176.46
CV(599) = 115.98
CV(600) = 115.98
CV(601) = 0
CV(602) = 341.39
CV(603) = 634.45
CV(604) = 882.86
CV(605) = 1090.16
CV(606) = 1259.85
CV(607) = 1395.41
CV(608) = 1576.88
CV(609) = 1658.93
CV(610) = 1663.38
CV(611) = 1609.34
CV(612) = 1513.27
CV(613) = 1388.87
CV(614) = 1247.59
CV(615) = 1098.49
CV(616) = 948.71
CV(617) = 803.58
CV(618) = 667.01
CV(619) = 541.53
CV(620) = 428.75
CV(621) = 329.38
CV(622) = 243.57
CV(623) = 170.77
CV(624) = 110.28
CV(625) = 110.28
CV(626) = 0
CV(627) = 341.39
CV(628) = 634.45
CV(629) = 882.86
CV(630) = 1090.14
CV(631) = 1259.81
CV(632) = 1395.33
CV(633) = 1576.67
CV(634) = 1658.52
CV(635) = 1662.68
CV(636) = 1608.26
CV(637) = 1511.76
CV(638) = 1386.88
CV(639) = 1245.1
CV(640) = 1095.48
CV(641) = 945.2
CV(642) = 799.6
CV(643) = 662.62
CV(644) = 536.79
CV(645) = 423.73
CV(646) = 324.16
CV(647) = 238.24
CV(648) = 165.42
CV(649) = 104.93
CV(650) = 104.93
CV(651) = 0
CV(652) = 341.39
CV(653) = 634.45
CV(654) = 882.86
CV(655) = 1090.14
CV(656) = 1259.81
CV(657) = 1395.33
CV(658) = 1576.67
CV(659) = 1658.52
CV(660) = 1662.68
CV(661) = 1608.26
CV(662) = 1511.76
CV(663) = 1386.88
CV(664) = 1245.1
CV(665) = 1095.48
CV(666) = 945.2
CV(667) = 799.6
CV(668) = 662.62
CV(669) = 536.79
CV(670) = 423.73
CV(671) = 324.16
CV(672) = 238.24
CV(673) = 165.42
CV(674) = 104.93
CV(675) = 104.93
End Sub

