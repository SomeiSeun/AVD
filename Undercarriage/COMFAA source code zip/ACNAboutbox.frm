VERSION 5.00
Begin VB.Form frmAboutBox 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "About ACN Comp"
   ClientHeight    =   6900
   ClientLeft      =   810
   ClientTop       =   2085
   ClientWidth     =   9120
   ClipControls    =   0   'False
   BeginProperty Font 
      Name            =   "MS Sans Serif"
      Size            =   9.75
      Charset         =   0
      Weight          =   700
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   ForeColor       =   &H80000008&
   Icon            =   "ACNAboutbox.frx":0000
   LinkMode        =   1  'Source
   LinkTopic       =   "Form2"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   PaletteMode     =   1  'UseZOrder
   ScaleHeight     =   6900
   ScaleWidth      =   9120
   Begin VB.PictureBox Pic_ApplicationIcon 
      Appearance      =   0  'Flat
      AutoSize        =   -1  'True
      BackColor       =   &H80000005&
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H80000008&
      Height          =   480
      Left            =   120
      Picture         =   "ACNAboutbox.frx":030A
      ScaleHeight     =   480
      ScaleWidth      =   480
      TabIndex        =   6
      Top             =   120
      Width           =   480
   End
   Begin VB.CommandButton Cmd_OK 
      Appearance      =   0  'Flat
      BackColor       =   &H80000005&
      Cancel          =   -1  'True
      Caption         =   "&OK"
      Default         =   -1  'True
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   360
      Left            =   6120
      TabIndex        =   4
      Top             =   6000
      Width           =   1095
   End
   Begin VB.Label lblLEDFAA 
      Caption         =   "COMFAA 3.0 - August 26, 2011"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   18
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   570
      Left            =   840
      TabIndex        =   7
      Top             =   120
      Width           =   5715
   End
   Begin VB.Label lblComments 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   840
      TabIndex        =   5
      Top             =   4800
      Width           =   7575
   End
   Begin VB.Line lin_HorizontalLine1 
      BorderWidth     =   2
      X1              =   840
      X2              =   8280
      Y1              =   5760
      Y2              =   5760
   End
   Begin VB.Label lblVersion 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   4320
      TabIndex        =   1
      Top             =   120
      Width           =   900
   End
   Begin VB.Label lblCredits 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3975
      Left            =   840
      TabIndex        =   2
      Top             =   720
      Width           =   7575
   End
   Begin VB.Label lblSystem 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   1320
      TabIndex        =   3
      Top             =   6000
      Width           =   2055
   End
   Begin VB.Label lblSystemValues 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   615
      Left            =   3600
      TabIndex        =   0
      Top             =   6000
      Width           =   2055
   End
End
Attribute VB_Name = "frmAboutBox"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

  Const WF_STANDARD = &H10
  Const WF_ENHANCED = &H20
  Const WF_80x87 = &H400
  Const GFSR_SYSTEMRESOURCES = 0

  Dim SysInfo As SYSTEM_INFO, SysMem As TMemoryStatus
Private Sub Cmd_OK_Click()
    Unload Me
End Sub

Private Sub Form_Load()
  
  Dim WinFlags As Long, wFlags As Integer
  Dim Mode As String, Processor As String, PCResources As Long
  Dim FreePhysMem As Long
     
  Left = frmGear.Left + (frmGear.Width - Width) \ 2
  Top = frmGear.Top + (frmGear.Height - Height) \ 2
  
  lblVersion.Caption = ""

  S$ = "Computer program COMFAA operates in three computational modes: ACN mode, thickness mode, "
  S$ = S$ & "and PCN Mode. In ACN mode, COMFAA calculates Aircraft Classification Numbers "
  S$ = S$ & "(ACNs) for flexible and rigid airport pavements. The flexible "
  S$ = S$ & "pavement ACNs are calculated using the CBR method for thickness design "
  S$ = S$ & "at CBR values of 15, 10, 6, and 3. The rigid pavement ACNs are calculated using "
  S$ = S$ & "the PCA method for thickness design at k values of 552.6, 294.7, 147.4, and 73.7 lb/in3. "
  S$ = S$ & "Computation of ACNs is by direct implementation of the computer programs "
  S$ = S$ & "in the ICAO Aerodrome Design Manual, Part 3 - Pavements, Appendix 2, except that the "
  S$ = S$ & "flexible thickness design Alpha Factors are those approved by ICAO in 2007. "
  S$ = S$ & "In thickness mode, COMFAA calculates flexible pavement thickness "
  S$ = S$ & "using the FAA CBR method with the 2007 Alpha Factors at a CBR value specified by "
  S$ = S$ & "the user, and calculates rigid pavement slab thickness using the FAA Westergaard "
  S$ = S$ & "edge-load method or by the PCA method at a k value specified by the user. "
  S$ = S$ & "The ACN and thickness modes are combined in the PCN mode to automatically "
  S$ = S$ & "compute PCN according to the procedure in AC 150/5335-5B. "
  S$ = S$ & "COMFAA was prepared "
  S$ = S$ & "by the FAA for R&&D use and for use in association with AC 150/5335-5B. "
  S$ = S$ & "It is not an ICAO standard."
     
  lblCredits.Caption = S$
  S$ = "Questions and comments regarding the program should be directed to "
  S$ = S$ & "Satish K. Agrawal, Airport Technology R&&D Team, AJP-6310, "
  S$ = S$ & "Federal Aviation Administration William J. Hughes Technical "
  S$ = S$ & "Center, Atlantic City International Airport, NJ 08405."
  lblComments.Caption = S$
  
  ' Get current Windows configuration
  
'  WinFlags = GetWinFlags()
'  If WinFlags And WF_ENHANCED Then Mode = "386 Enhanced" Else Mode = "Standard"
'  lblSystem.Caption = "Mode:" & NL & "Math Co-processor:" & NL & "Free Memory:" & NL & "System Resources:"
'  lblSystem.Caption = "Mode:" & NL & "Processor:" & NL & "Free Memory:" & NL & "System Resources:"
  S$ = "Processor:" & vbCrLf & "Total Physical Memory:" & vbCrLf
  S$ = S$ & "Free Physical Memory:" '& NL & "System Resources:"
  lblSystem.Caption = S$
  
'  If WinFlags And WF_80x87 Then Processor = "Present" Else Processor = "None"
'  wFlags = 0
'  PCResources = GetFreeSystemResources(GFSR_SYSTEMRESOURCES)
'  lblSystemValues.Caption = Mode & NL & Processor & NL & Format$(GetFreeSpace(0) \ 1024, "#,###,000") & " kbytes" & NL & Format$(PCResources, "0") & "% Free"

  Call GetSystemInfo(SysInfo)
'  Debug.Print SysInfo.dwProcessorType
  Processor = Format(SysInfo.dwProcessorType, "0")
  If Processor = "586" Then Processor = "Pentium"
  S$ = Processor & vbCrLf
  SysMem.iLength = Len(SysMem)
  Call GlobalMemoryStatus(SysMem)
'  FreePhysMem = SysMem.iTotalPhys \ 1024
'  FreePhysMem = SysMem.iAvailPhys \ 1024
  S$ = S$ & Format$(SysMem.iTotalPhys \ 1024, "#,###,000") & " kbytes" & vbCrLf
  S$ = S$ & Format$(SysMem.iAvailPhys \ 1024, "#,###,000") & " kbytes" & vbCrLf
'  PCResources = 100 - SysMem.iMemoryLoad
'  S$ = S$ & Format$(100 - SysMem.iMemoryLoad, "0") & "% Free"
  lblSystemValues.Caption = S$
  
End Sub

Private Sub Form_Unload(Cancel As Integer)
  Caption = ""
  lblLEDFAA = ""
  lblVersion.Caption = ""
  lblCredits.Caption = ""
  lblSystem.Caption = ""
  lblSystemValues.Caption = ""
  Refresh
End Sub

