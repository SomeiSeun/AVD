Attribute VB_Name = "modAlpha"
Option Explicit

Public Function New06AlphaFactorFromCurve(NW As Integer, Coverages As Double) As Double

' NW = number of wheels.
  Dim I As Long
  Dim A As Double, B As Double, C As Double
  Dim A0 As Double, A1 As Double, A4 As Double
  Dim LogCovA0 As Double, LogCovA1 As Double, LogCovA4 As Double
  Dim A4define() As Double, NWA4define() As Long, NA4define As Long
  Dim Resid As Double, ResidM1 As Double, DelA As Double, Slope As Double
  
' Fixed points to define alpha versus log(coverages) curves.
' log(coverage) values.
  LogCovA0 = 0:  LogCovA1 = 1:  LogCovA4 = 4
' Alphas at log(coverages)
  A0 = 0.1:  A1 = 0.38:  ' A4 = derived from new set of alpha at 10,000 coverages.
  
' Incremental damage relative to six-wheels the same as old alphas for higher than 6-wheels.
  NA4define = 8 ' Number of defined values of alpha at 10,000 coverages.
' NWA4define() = number of wheels. A4define = alpha for NWA4define wheels.
  ReDim NWA4define(NA4define), A4define(NA4define)
  NWA4define(1) = 1:     NWA4define(2) = 2:     NWA4define(3) = 4
  NWA4define(4) = 6:     NWA4define(5) = 8:     NWA4define(6) = 12
  NWA4define(7) = 18:    NWA4define(8) = 24
  A4define(1) = 0.995:   A4define(2) = 0.9:     A4define(3) = 0.8
  A4define(4) = 0.72:    A4define(5) = 0.69:    A4define(6) = 0.66
  A4define(7) = 0.64:    A4define(8) = 0.63

' Boeing Proposals
  If False Then
    NA4define = 13
    ReDim A4define(NA4define), NWA4define(NA4define)
    NWA4define(1) = 1:   NWA4define(2) = 2:   NWA4define(3) = 4
    NWA4define(4) = 6:   NWA4define(5) = 8:   NWA4define(6) = 10
    NWA4define(7) = 12:  NWA4define(8) = 14:  NWA4define(9) = 16
    NWA4define(10) = 18: NWA4define(11) = 20: NWA4define(12) = 22: NWA4define(13) = 24
    A4define(1) = 0.995:  A4define(2) = 0.9:    A4define(3) = 0.8
    A4define(4) = 0.72:   A4define(5) = 0.679:  A4define(6) = 0.65
    A4define(7) = 0.627:  A4define(8) = 0.608:  A4define(9) = 0.591
    A4define(10) = 0.576: A4define(11) = 0.563: A4define(12) = 0.551: A4define(13) = 0.54
  End If

  If NW < NWA4define(1) Then ' Should never happen. Would be an error.
    New06AlphaFactorFromCurve = A4define(1)
    Exit Function
  End If
  
  If Coverages < 10 Then ' Lower end of curves is independent of number of wheels.
    If Coverages < 0# Then
      New06AlphaFactorFromCurve = 0.15 - 0.23 * Log10(-Coverages)
    Else
      New06AlphaFactorFromCurve = 0.15 + 0.23 * Log10(Coverages)
    End If
    Exit Function
  End If
  
' Linear interpolation for alpha factors at 10,000 coverages undefined.
  For I = 1 To NA4define - 1
    If NW < NWA4define(I + 1) Then
      Slope = (A4define(I + 1) - A4define(I)) / CDbl(NWA4define(I + 1) - NWA4define(I))
      A4 = A4define(I) + Slope * CDbl(NW - NWA4define(I))
      Exit For
    Else
      A4 = A4define(NA4define)
    End If
  Next I
  
' Find the coefficients of the defining exponential association curve (see CurveExpert program).
' Alpha = A * (B - e^(-C * log10(Coverages)))
' Solve for Resid function (below) by Newton's method.
  A = A4 - A0 + 0.1 ' The second log argument is -ve if A < A4 - A0.
  DelA = A / 1000
  
  ResidM1 = Log((A0 + A - A1) / A) / LogCovA1 - Log((A0 + A - A4) / A) / LogCovA4
  Do
    A = A + DelA
    Resid = Log((A0 + A - A1) / A) / LogCovA1 - Log((A0 + A - A4) / A) / LogCovA4
    A = A - Resid * DelA / (Resid - ResidM1)
    If A < A4 - A0 + 0.001 Then A = A4 - A0 + 0.001 ' Jumped too far because of nonlinearity.
    ResidM1 = Log((A0 + A - A1) / A) / LogCovA1 - Log((A0 + A - A4) / A) / LogCovA4
    DoEvents ' In case the iteration does not terminate. Allows interruption.
  Loop Until Abs(ResidM1) < 0.000001
  
  B = A0 / A + 1
  C = -Log((A0 + A - A4) / A) / LogCovA4

  New06AlphaFactorFromCurve = A * (B - Exp(-C * Log10(Coverages)))
'  New06AlphaFactorFromCurve = A * (B - Exp(-C * Log10Coverages))

End Function

Public Sub Disclaimer07Alphas()

  Dim S$

  S$ = "In December 2006, ICAO accepted revisions to the ""alpha factor"" multiplier for" & vbCrLf
  S$ = S$ & "flexible pavement thickness design. The revised alpha factors affect the required" & vbCrLf
  S$ = S$ & "pavement thickness and the Aircraft Classification Number (ACN) as determined" & vbCrLf
  S$ = S$ & "by airplane manufacturers and the COMFAA computer program. Until official ICAO " & vbCrLf
  S$ = S$ & "documentation incorporates the revisions, users are advised to confirm use of" & vbCrLf
  S$ = S$ & "the revised '06 alpha factors." & vbCrLf & vbCrLf
  
  S$ = S$ & "The FAA will not modify Advisory Circular 150/5320-6D, Airport Pavement Design" & vbCrLf
  S$ = S$ & "and Evaluation, to incorporate the revised '06 alpha factors as the FAA intends to" & vbCrLf
  S$ = S$ & "fully adopt the layered elastic based design procedure provided in the FAArfield" & vbCrLf
  S$ = S$ & "computer program for flexible pavement design. However, the revised alpha" & vbCrLf
  S$ = S$ & "factors may be used for pavement evaluations and PCN determination conducted" & vbCrLf
  S$ = S$ & "in accordance with AC 150/5335-5A."

  MsgBox S$, 0, "Use of Revised '06 Alpha Factors"

End Sub

Public Sub AlphaCurves(Coverages As Double, Alpha() As Double, NWD() As Double, NCurves As Integer, NWMax As Integer)

  Dim LogCov As Double
    
  NCurves = 7
  NWMax = 24
  NWD(1) = 1:  NWD(2) = 2:  NWD(3) = 4:  NWD(4) = 6
  NWD(5) = 12:  NWD(6) = 16:  NWD(7) = NWMax
  
  If Coverages < 1 Then Coverages = 1
  LogCov = Log10(Coverages)
  
  If LogCov < 1 Then
    Alpha(1) = 0.405 + 0.2 * (LogCov - 1)  ' Single.
    Alpha(2) = 0.4 + 0.2 * (LogCov - 1)    ' Dual.
    Alpha(3) = 0.395 + 0.2 * (LogCov - 1)  ' Dual tandem.
    Alpha(4) = 0.39 + 0.2 * (LogCov - 1)   ' Six wheels.
'    Alpha(5) = 0.38 + 0.2 * (LogCov - 1)  ' Eight wheels, not smooth curve.
    Alpha(5) = 0.37 + 0.2 * (LogCov - 1)   ' Twelve wheels.
    Alpha(6) = 0.36 + 0.2 * (LogCov - 1)   ' Sixteen wheels.
    Alpha(7) = 0.359 + 0.2 * (LogCov - 1)  ' Twenty four wheels.
  ElseIf 1 <= LogCov And LogCov <= 4 Then
    Alpha(1) = 0.405 + (LogCov - 1) * _
                  (0.205 + (LogCov - 2) * (-0.0025 - 0.0025 * (LogCov - 3)))
    Alpha(2) = 0.4 + (LogCov - 1) * _
                  (0.19 + (LogCov - 2) * (-0.0125 - 0.000833 * (LogCov - 3)))
    Alpha(3) = 0.395 + (LogCov - 1) * _
                  (0.18 + (LogCov - 2) * (-0.0225 + 0.0041667 * (LogCov - 3)))
    Alpha(4) = 0.39 + (LogCov - 1) * _
                  (0.175 + (LogCov - 2) * (-0.026 + 0.004833 * (LogCov - 3)))
'    Alpha(5) = 0.38 + (LogCov - 1) * _
                  (0.175 + (LogCov - 2) * (-0.0375 + 0.0141667 * (LogCov - 3)))
    Alpha(5) = 0.37 + (LogCov - 1) * _
                  (0.175 + (LogCov - 2) * (-0.035 + 0.006667 * (LogCov - 3)))
    Alpha(6) = 0.36 + (LogCov - 1) * _
                  (0.175 + (LogCov - 2) * (-0.035 + 0.005 * (LogCov - 3)))
    Alpha(7) = 0.359 + (LogCov - 1) * _
                  (0.171 + (LogCov - 2) * (-0.0355 + 0.0035 * (LogCov - 3)))
  ElseIf LogCov > 4 Then
    Alpha(1) = 0.99 + 0.17 * (LogCov - 4)
    Alpha(2) = 0.89 + 0.125 * (LogCov - 4)
    Alpha(3) = 0.825 + 0.0875 * (LogCov - 4)
    Alpha(4) = 0.788 + 0.08 * (LogCov - 4)
'    Alpha(5) = 0.765 + 0.07 * (LogCov - 4)
    Alpha(5) = 0.725 + 0.05 * (LogCov - 4)
    Alpha(6) = 0.705 + 0.0375 * (LogCov - 4)
    Alpha(7) = 0.68 + 0.02 * (LogCov - 4)
  End If

End Sub

Public Function AlphaFactorFromCurve(NW As Integer, Coverages As Double, NWMax As Integer) As Double
      
  Dim NWInterp As Double
  Dim Alpha(10) As Double, NWD(10) As Double, NCurves As Integer
  Dim AlphaNW As Double
  Dim DAlphaDNW1 As Double, DAlphaDNWN As Double
  
  NWInterp = NW
  Call AlphaCurves(Coverages, Alpha(), NWD(), NCurves, NWMax)
  DAlphaDNW1 = (Alpha(2) - Alpha(1)) / (NWD(2) - NWD(1))
  DAlphaDNWN = (Alpha(NCurves) - Alpha(NCurves - 1)) / (NWD(NCurves) - NWD(NCurves - 1))
  Call SPLINE(NWD(), Alpha(), NCurves, DAlphaDNW1, DAlphaDNWN, NWInterp, AlphaNW)
  AlphaFactorFromCurve = AlphaNW
'  AlphaFactorFromCurve = 0.23 * Log(Coverages) / Log(10#) + 0.15

End Function

Public Sub SPLINE(X() As Double, Y() As Double, N As Integer, YP1 As Double, YPN As Double, XIN As Double, YOUT As Double)
  
  Const NMAX As Integer = 100
'  DIMENSION X(N), Y(N), Y2(N)
  Dim U(NMAX) As Double, Y2(NMAX) As Double
  Dim I As Integer, K As Double
  Dim SIG As Double
  Dim P As Double, QN As Double, UN As Double
  
  If (YP1 > 9.9E+29) Then
    Y2(1) = 0#
    U(1) = 0#
  Else
    Y2(1) = -0.5
    U(1) = (3# / (X(2) - X(1))) * ((Y(2) - Y(1)) / (X(2) - X(1)) - YP1)
  End If
'      DO 11 I=2,N-1
  For I = 2 To N - 1
    SIG = (X(I) - X(I - 1)) / (X(I + 1) - X(I - 1))
    P = SIG * Y2(I - 1) + 2#
    Y2(I) = (SIG - 1#) / P
    U(I) = (6# * ((Y(I + 1) - Y(I)) / (X(I + 1) - X(I)) - (Y(I) - Y(I - 1)) _
           / (X(I) - X(I - 1))) / (X(I + 1) - X(I - 1)) - SIG * U(I - 1)) / P
  Next I
'11    CONTINUE
  If (YPN > 9.9E+29) Then
    QN = 0#
    UN = 0#
  Else
    QN = 0.5
    UN = (3# / (X(N) - X(N - 1))) * (YPN - (Y(N) - Y(N - 1)) / (X(N) - X(N - 1)))
  End If
  Y2(N) = (UN - QN * U(N - 1)) / (QN * Y2(N - 1) + 1#)
'      DO 12 K=N-1,1,-1
  For K = N - 1 To 1 Step -1
        Y2(K) = Y2(K) * Y2(K + 1) + U(K)
  Next K
'12    CONTINUE
'      Return
'      End

'      Sub SPLINT(XA, YA, Y2A, N, X, Y)
  Dim KLO As Integer, KHI As Integer
'  Dim XIN As Double, YOUT As Double
  Dim A As Double, B As Double, H As Double
  Dim XA() As Double, YA() As Double, Y2A() As Double
  ReDim XA(N), YA(N), Y2A(N)
        
  For I = 1 To N
    XA(I) = X(I):  YA(I) = Y(I):  Y2A(I) = Y2(I)
  Next I
  KLO = 1
  KHI = N
1 If (KHI - KLO > 1) Then
    K = (KHI + KLO) / 2
    If (XA(K) > XIN) Then
      KHI = K
    Else
      KLO = K
    End If
    GoTo 1
  End If
  H = XA(KHI) - XA(KLO)
'  If (H = 0#) Then PAUSE 'Bad XA input.'
  A = (XA(KHI) - XIN) / H
  B = (XIN - XA(KLO)) / H
  YOUT = A * YA(KLO) + B * YA(KHI) + _
         ((A ^ 3 - A) * Y2A(KLO) + (B ^ 3 - B) * Y2A(KHI)) * (H * H) / 6#

End Sub

Public Function Log10(X As Double) As Double

  Const Log10BaseE As Double = 2.30258509299405
  
  Log10 = Log(X) / Log10BaseE

End Function


