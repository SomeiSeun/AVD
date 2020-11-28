Attribute VB_Name = "modACNMain"
Option Explicit

Public ACN_mode_true As Boolean 'ikawa 01/29/03
Public PCN_mode_true As Boolean 'GFH 06/12/08
Public Stress_mode As Boolean  'ikawa 11/25/08
Public Index3StressCalc As Boolean 'ikawa seattle
Public SamePcntAndPress As Boolean

Public MaxGrossWeightTrue As Boolean
Public mode_changed As Boolean   'ikawa 02/14/03
Public ResizingfrmGear As Boolean ' GFH 04/17/06.

Public rowsNumber As Integer 'ik02
Public ACNrowsNumber As Integer
Public ThickrowsNumber As Integer
Public frmGearStarted As Boolean
Public VGAMode As Boolean
Public ScaleModeConst As Double

Public frmGearStartHeight As Double
Public frmGearStartWidth As Double
Public lstLibFileStartHeight As Double
Public lblCriticalAircraftStartTop As Double
Public lblCriticalAircraftTextStartTop As Double
Public lblEvaluationThicknessStartTop As Double
Public txtEvaluationThicknessStartTop As Double
Public lblMessageStartTop As Double
Public grdParmsStartTop As Double
Public grdParmsStartLeft As Double
Public grdOutputStartTop As Double
Public grdOutputStartLeft As Double
Public cmdFlexibleComputeStartTop As Double
Public cmdFlexibleComputeStartLeft As Double
Public cmdRigidComputeStartTop As Double
Public cmdRigidComputeStartLeft As Double
Public fraEditWheelsStartLeft As Double
Public fraLibraryFunctionsStartLeft As Double
Public fraMiscellaneousFunctionsStartLeft As Double
Public fraOptionsStartLeft As Double
Public fraCompModeStartTop As Double
Public fraCompModeStartLeft As Double
Public picGearStartHeight As Double
Public picGearStartWidth As Double

Public frmACNtxtOutputHeight As Double
Public frmACNtxtOutputStartHeight As Double
Public frmACNgphAlphaHeight As Double
Public frmACNgphAlphaStartHeight As Double
Public frmACNHeight As Double
Public frmACNStartHeight As Double

Public frmACNtxtOutputWidth As Double
Public frmACNtxtOutputStartWidth As Double
Public frmACNgphAlphaWidth As Double
Public frmACNgphAlphaStartWidth As Double
Public frmACNWidth As Double
Public frmACNStartWidth As Double

Public Const SGCol As Integer = 0, SGText$ = "SG"
Public Const CBRCol As Integer = 1, CBRText$ = "CBR"
Public Const CBRtCol As Integer = 2, CBRtText = "Flex t, "
Public Const ACNFlexCol As Integer = 3, ACNFlexText = "ACN Flex"

Public Const kCol As Integer = 4, kText$ = "k, "
Public Const RigtCol As Integer = 5, RigtText$ = "Rig t, "
Public Const ACNRigCol As Integer = 6, ACNRigText$ = "ACN Rig"

Public Sub Main()

' Change ACNOnly = False to ACNOnly = True and then recompile to produce
' an executable for the ACN only version.

  Dim I As Integer
  Dim h1 As Integer, hButton As Integer, h2 As Integer
  
  ACN_mode_true = True 'ikawa 02/11/03
' GFH 05/10/09. Needed to start with External library selected and to
' allow entry of thickness for the batch PCN button.
'  ACN_mode_true = False
  mode_changed = False 'ikawa 02/11/03
  SamePcntAndPress = True
  
  ChDir App.Path
  AppPath$ = App.Path & "\"
  If Right$(AppPath$, 1) <> "\" Then AppPath$ = AppPath$ & "\"
  ExtFilePath$ = AppPath$
  App.HelpFile = AppPath$ & "COMFAA.chm"
  
  ExternalAircraftFileName$ = "COMFAAaircraft"  ' GFH 01/21/03
  If Dir(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext") = "" Then
    Debug.Print "Not new name"
    If Dir(ExtFilePath$ & "AircraftLibrary" & ".Ext") <> "" Then
      ExternalAircraftFileName$ = "AircraftLibrary"
    End If
  End If
  
'  FlexibleACN = True
  Call StoreFlexCurveFits
  Call InitACLib
  
  With frmGear
  
    'ACNOnly = True
    If ACNOnly Then
      .lblCriticalAircraft.Visible = False
      .lblCriticalAircraftText.Visible = False
      .lblEvaluationThickness.Visible = False
      .txtEvaluationThickness.Visible = False
      .lblStress.Visible = False
      .txtStress.Visible = False
      .chkPCAThicknessDesign.Visible = False
      .chkPCAforGrossWeight.Visible = False
      .btnMORE.Visible = False
      .btnMORE.Visible = False
      .btnPCN_flexible.Caption = "ACN Flexible"
      .btnPCN_rigid.Caption = "ACN Rigid"
    End If
  
  Call frmGear.chkUnitsConversion_Click 'code added by Izydor Kawa
  
'  Load frmGear ' into memory, but do not display. Call frmGear.chkUnitsConversion_Click loads frmGear.
  Load frmACN

    I = frmGear.Width / 120 - Len(frmGearCaptionStart) - 5 ' 120 = twips / character.
    If I < Len(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext") Then S = "..." Else S = ""
    frmGear.Caption = frmGearCaptionStart & S & Right(ExtFilePath$ & ExternalAircraftFileName$ & ".Ext", I)
  
    ScaleModeConst = 1
'    Debug.Print .TextWidth("A")
'    Debug.Print .ScaleX(.ScaleWidth, .ScaleMode, vbPixels)
'    Check for large system fonts. .ScaleX is 792 for small fonts
'    880 for large fonts. If the start width is changed then change 800 as required.
    If .ScaleX(.ScaleWidth, .ScaleMode, vbPixels) > 800 Then
      ScaleModeConst = 1.25
    End If
    If ScaleModeConst = 1 Then
      If .ScaleX(Screen.Width, frmGear.ScaleMode, vbPixels) < 800 Then
        .Width = .ScaleX(640, vbPixels, .ScaleMode)
        .Height = .ScaleY(480, vbPixels, .ScaleMode)
        VGAMode = True
      Else
        .Width = .ScaleX(800, vbPixels, .ScaleMode) * 1.008
        .Height = .ScaleY(600, vbPixels, .ScaleMode) * 1.06
      End If
    Else
'      Debug.Print ScaleModeConst; .ScaleX(Screen.Width, frmGear.ScaleMode, vbPixels)
      If .ScaleX(Screen.Width, frmGear.ScaleMode, vbPixels) <= 800 Then
        .Width = .ScaleX(640 * ScaleModeConst, vbPixels, .ScaleMode)
        .Height = .ScaleY(480 * ScaleModeConst, vbPixels, .ScaleMode)
        VGAMode = True
      Else
        .Width = (frmGear.fraOptions.Left + frmGear.fraOptions.Width) * 1.02
        .Height = (frmGear.fraOptions.Top + frmGear.fraOptions.Height) * 1.33 + 1600
      End If
    End If
    
    If ACNOnly Then
      .Height = .Height - 200
      .lstLibFile.Height = .lstLibFile.Height + 500
      .chkBatch.Left = .chkBatch.Left + 800
      .chkUnitsConversion.Left = .chkUnitsConversion.Left + 800
      .btnPCN_flexible.Left = .btnPCN_flexible.Left + 400
      .btnPCN_rigid.Left = .btnPCN_rigid.Left + 760
    End If
    
    Call MainStartSize
    Call MainSetGrids
'    Call MainResize

    For I = 1 To NLibACGroups
      .lstACGroup.AddItem LibACGroupName$(I)
    Next I
    h1 = .lstACGroup.ListCount - 1
  
    .Left = (Screen.Width - .Width) / 2           ' Finally center.
    .Top = (Screen.Height - .Height) / 2
    
    hButton = 468
    .cmdAddWheel.Height = hButton
    .cmdRemoveWheel.Height = hButton
    .cmdMoveWheel.Height = hButton
    .cmdSelectWheel.Height = hButton
    .cmdOutputDetails.Height = hButton
    .cmdExit.Height = hButton
    .cmdHelp.Height = hButton
    .cmdAbout.Height = hButton
  
    .fraEditWheels.Top = 70
    .fraEditWheels.Height = 3 * hButton '+ 500
  
    .fraLibraryFunctions.Top = .fraEditWheels.Top + .fraEditWheels.Height + 80
    .fraLibraryFunctions.Height = 4 * hButton + 60
    
    .fraMiscellaneousFunctions.Top = .fraLibraryFunctions.Top + .fraLibraryFunctions.Height + 60
    .fraMiscellaneousFunctions.Height = 3 * hButton
    
    .fraOptions.Top = .fraMiscellaneousFunctions.Top + .fraMiscellaneousFunctions.Height + 60 '100
    .fraOptions.Height = 990
  
    .fraCompMode.Top = .fraOptions.Top + .fraOptions.Height + 600 ' These two statements have
    .fraCompMode.Left = .fraOptions.Left - 20 ' no effect. Reset in MainResize of start values.

  End With
  
  frmGearStarted = True   ' Allow calls to Form_Resize.
  
' Startup sequence is sensitive. Needs work.
  h1 = frmGear.lstACGroup.ListCount - 1
  frmGear.lstACGroup.Selected(h1) = True  ' Sets lstACGroup to external library.
  lstLibFileIndex = 0                                  ' Select last group.
  frmGear.lstLibFile.Selected(lstLibFileIndex) = True  ' Select aircraft and plot.
  frmGear.Show                      ' Display after all sizing is completed.
  If ACNOnly Then ' GFH 03/06/13. Fixed the ACNOnly parm grid extra blank cell startup problem
    Call frmGear.optCalcMode_Click(0) ' Start in ACN.
  Else
    Call frmGear.optCalcMode_Click(1) ' Start in thickness. "Also set in edit mode" is an old comment not checked.
  End If
  
End Sub

Public Sub MainResize()
  
  Dim DeltaHeight As Double, DeltaWidth As Double
  Dim TempDeltaWidth As Double
  
  With frmGear
  
    If .ScaleX(.Width, .ScaleMode, vbPixels) <= 629 Then
      .Width = .ScaleX(629, vbPixels, .ScaleMode)
    End If
    If .ScaleY(.Height, .ScaleMode, vbPixels) <= 500 Then
      .Height = .ScaleY(500, vbPixels, .ScaleMode)
    End If
  
    DeltaHeight = .Height - frmGearStartHeight
    
    .lblCriticalAircraft.Top = lblCriticalAircraftStartTop + DeltaHeight
    .lblCriticalAircraftText.Top = lblCriticalAircraftTextStartTop + DeltaHeight
    .lblMessage.Top = lblMessageStartTop + DeltaHeight
    .picGear.Height = picGearStartHeight + DeltaHeight
    
    DeltaWidth = .Width - frmGearStartWidth
    .fraEditWheels.Left = fraEditWheelsStartLeft + DeltaWidth
    .fraLibraryFunctions.Left = fraLibraryFunctionsStartLeft + DeltaWidth
    .fraMiscellaneousFunctions.Left = fraMiscellaneousFunctionsStartLeft + DeltaWidth
    .fraOptions.Left = fraOptionsStartLeft + DeltaWidth

    .picGear.Width = picGearStartWidth + DeltaWidth
    
    If .Width < frmGearStartWidth Then
      TempDeltaWidth = DeltaWidth
    Else
      TempDeltaWidth = DeltaWidth / 4
    End If
  
    .fraCompMode.Move fraCompModeStartLeft + TempDeltaWidth, _
                            fraCompModeStartTop + DeltaHeight

    .grdParms.Move grdParmsStartLeft + TempDeltaWidth, _
                   grdParmsStartTop + DeltaHeight
    .grdOutput.Move grdOutputStartLeft + TempDeltaWidth, _
                    grdOutputStartTop + DeltaHeight
                    
    .lblEvaluationThickness.Left = .grdOutput.Left + 280
    .lblEvaluationThickness.Top = .grdOutput.Top + .grdOutput.Height + 40
    .txtEvaluationThickness.Left = .lblEvaluationThickness.Left + .lblEvaluationThickness.Width + 40
    .txtEvaluationThickness.Top = .lblEvaluationThickness.Top
    
    .lblStress.Left = .txtEvaluationThickness.Left + .txtEvaluationThickness.Width + 500
    .txtStress.Left = .lblStress.Left + .lblStress.Width + 40
    .lblStress.Top = .lblEvaluationThickness.Top
    .txtStress.Top = .lblEvaluationThickness.Top
                   
    If .lstLibFile.Left + .lstLibFile.Width > .grdParms.Left Then
      .lstLibFile.Height = .grdParms.Top - .lstLibFile.Top - .lblMessage.Height
    Else
      .lstLibFile.Height = lstLibFileStartHeight + DeltaHeight
    End If
    
    .lblXcoord.Top = 20
    .lblYcoord.Top = 20
    .lblXSelected.Top = 20
    .lblYSelected.Top = 20
    
  End With
  
  frmACNHeight = frmACNStartHeight + DeltaHeight
  frmACNtxtOutputHeight = frmACNtxtOutputStartHeight + DeltaHeight
  frmACNgphAlphaHeight = frmACNgphAlphaStartHeight + DeltaHeight
  If DeltaWidth > 0 Then
    frmACNWidth = frmACNStartWidth + DeltaWidth
    frmACNtxtOutputWidth = frmACNtxtOutputStartWidth + DeltaWidth
    frmACNgphAlphaWidth = frmACNgphAlphaStartWidth + DeltaWidth
  Else
    frmACNWidth = frmACNStartWidth
    frmACNtxtOutputWidth = frmACNtxtOutputStartWidth
    frmACNgphAlphaWidth = frmACNgphAlphaStartWidth
  End If

End Sub

Public Sub MainStartSize()

  With frmGear

    If VGAMode Then
      frmGearStartHeight = frmGear.ScaleY(600 * ScaleModeConst, vbPixels, .ScaleMode)
      frmGearStartWidth = frmGear.ScaleX(800 * ScaleModeConst, vbPixels, .ScaleMode)
    Else
      frmGearStartHeight = .Height
      frmGearStartWidth = .Width
    End If
    lstLibFileStartHeight = .lstLibFile.Height
    lblCriticalAircraftStartTop = .lblCriticalAircraft.Top
    lblCriticalAircraftTextStartTop = .lblCriticalAircraftText.Top
    lblMessageStartTop = .lblMessage.Top
    grdParmsStartTop = .grdParms.Top
    grdParmsStartLeft = .grdParms.Left
    grdOutputStartTop = .grdOutput.Top
    grdOutputStartLeft = .grdOutput.Left
    fraEditWheelsStartLeft = .fraEditWheels.Left
    fraLibraryFunctionsStartLeft = .fraLibraryFunctions.Left
    fraMiscellaneousFunctionsStartLeft = .fraMiscellaneousFunctions.Left
    fraOptionsStartLeft = .fraOptions.Left
    
    fraCompModeStartTop = .fraCompMode.Top
    fraCompModeStartLeft = .fraCompMode.Left
    picGearStartHeight = .picGear.Height
    picGearStartWidth = .picGear.Width
  
  End With

  frmACNHeight = frmACN.Height
  frmACNStartHeight = frmACNHeight
  frmACNtxtOutputHeight = frmACN.txtOutput.Height
  frmACNtxtOutputStartHeight = frmACNtxtOutputHeight
  frmACNgphAlphaHeight = frmACN.picAlphaCurves.Height
  frmACNgphAlphaStartHeight = frmACNgphAlphaHeight

  frmACNWidth = frmACN.Width
  frmACNStartWidth = frmACNWidth
  frmACNtxtOutputWidth = frmACN.txtOutput.Width
  frmACNtxtOutputStartWidth = frmACNtxtOutputWidth
  frmACNgphAlphaWidth = frmACN.picAlphaCurves.Width
  frmACNgphAlphaStartWidth = frmACNgphAlphaWidth

End Sub

Public Sub MainSetGrids()

  Dim I As Integer
' All plot variables in English units.
  
' Aircraft parameter grid.
  With frmGear.grdParms
  
    If ACNOnly Then ACNrowsNumber = 10 Else ACNrowsNumber = 11
    ThickrowsNumber = ACNrowsNumber + 1
  
    If ACN_mode_true Then
      rowsNumber = ACNrowsNumber
    Else
      rowsNumber = ThickrowsNumber
    End If
  
    .Rows = rowsNumber
    .Cols = 2
    .ColWidth(0) = frmGear.TextWidth(" % GW on Main Gears") * 1.31 '1.25 '1600
    .ColWidth(1) = frmGear.TextWidth("0,000,000") * 1.2
    I = .Rows - 1
    .Height = (.RowPos(I) + .RowHeight(I)) + 6 * Screen.TwipsPerPixelY
    I = .Cols - 1
    .Width = (.ColPos(I) + .ColWidth(I)) + 6 * Screen.TwipsPerPixelX
  
    .ColAlignment(0) = 0 'grdAlignLeft
    .ColAlignment(1) = 2 'grdAlignCenter

    I = 0
    .Col = 0
    GrossWeightRow = I: I = I + 1
      .Row = GrossWeightRow:       .Text = " Gross Weight (" _
      & UnitsOut.poundsName & ")" 'modified by Izydor Kawa
    PcntOnMainGearsRow = I: I = I + 1
      .Row = PcntOnMainGearsRow:   .Text = " % GW on Main Gears"
    NMainGearsRow = I: I = I + 1
      .Row = NMainGearsRow:        .Text = " No. Main Gears"
    NWheelsRow = I: I = I + 1
      .Row = NWheelsRow:           .Text = " Wheels on Main Gear"
    
    TirePressureRow = I: I = I + 1

      If ACN_mode_true Or SamePcntAndPress Then
        .Row = TirePressureRow:      .Text = " Tire Pressure (" _
               & UnitsOut.psiName & ")" 'modified by Izydor Kawa
      Else
        .Row = TirePressureRow:      .Text = " Tire Contact Area (" _
               & UnitsOut.squareInchName & ")" 'modified by Izydor Kawa
      End If
      
    AlphaFactorRow = I: I = I + 1
      .Row = AlphaFactorRow:              .Text = " Alpha Used"
    PtoTCRow = I: I = I + 1
    If ACNOnly Then I = I - 1
      .Row = PtoTCRow:                    .Text = " Pass/Traffic Cycle (P/TC)"
    AnnualDeparturesRow = I: I = I + 1
      .Row = AnnualDeparturesRow:         .Text = " Annual Departures"
    FlexibleCoveragesRow = I: I = I + 1
      .Row = FlexibleCoveragesRow ': .Text = " Flex Coverages" ' Now set in Sub WriteParmGrid.
    RigidCoveragesRow = I: I = I + 1
      .Row = RigidCoveragesRow ':    .Text = " Rigid Coverages" ' Now set in Sub WriteParmGrid.
    RigidCutoffRow = I
      .Row = RigidCutoffRow:              .Text = " Rigid Cutoff (times rrs)"

    If ACNOnly Then
    rowsNumber = rowsNumber - 1
    '.Rows = rowsNumber
    Else
    If Not ACN_mode_true Then ' GFH 11/27/06.
      FlexStrengthOfConcRow = RigidCutoffRow + 1
      .Row = FlexStrengthOfConcRow: .Text = " Concrete Flex. Str. (" & UnitsOut.psiName & ")"
    End If
    End If

  End With
  
' Output grid.
  With frmGear.grdOutput
  
    .Rows = 5
    .Cols = 7
    For I = 0 To .Cols - 1
      .ColAlignment(I) = flexAlignCenterBottom
    Next I
    .Row = 0
    .ColWidth(SGCol) = frmGear.TextWidth(SGText) * 1.5
    .Col = SGCol:    .Text = SGText
    
    .ColWidth(CBRCol) = frmGear.TextWidth(CBRText) * 1.6
    .Col = CBRCol:    .Text = CBRText
    
    .ColWidth(CBRtCol) = frmGear.TextWidth(CBRtText & "mm") * 1.15
    .Col = CBRtCol:    .Text = CBRtText & UnitsOut.inchName
    
    .ColWidth(ACNFlexCol) = frmGear.TextWidth(ACNFlexText) * 1.15
    .Col = ACNFlexCol:    .Text = ACNFlexText
    
    .ColWidth(kCol) = frmGear.TextWidth(kText & "MN/m^3") * 1.11
    .Col = kCol:    .Text = kText & UnitsOut.pciName
    
    .ColWidth(RigtCol) = frmGear.TextWidth(CBRtText & "mm") * 1.15
    .Col = RigtCol:    .Text = RigtText & UnitsOut.inchName
    
    .ColWidth(ACNRigCol) = frmGear.TextWidth(ACNFlexText) * 1.15
    .Col = ACNRigCol:    .Text = ACNRigText
    
'   Moved to Sub WriteOutputGrid() so that the column can be blanked when not in ACN mode.
'    .Col = SGCol
'    .Row = 1:    .Text = " D"
'    .Row = 2:    .Text = " C"
'    .Row = 3:    .Text = " B"
'    .Row = 4:    .Text = " A"

    I = .Rows - 1
    .Height = (.RowPos(I) + .RowHeight(I)) + 6 * Screen.TwipsPerPixelY
    I = .Cols - 1
    .Width = (.ColPos(I) + .ColWidth(I)) + 6 * Screen.TwipsPerPixelX
  
  End With

End Sub
