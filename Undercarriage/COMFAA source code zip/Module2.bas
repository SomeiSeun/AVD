Attribute VB_Name = "Module2"


Sub WriteExternalFile3()
   
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
