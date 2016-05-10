EnableExplicit
Structure CharVoice
  intro.l
  lose.l
  name.l
  opscore.l[10]
  score.l[10]
  win.l  
EndStructure
Structure Ball
  Disappeared.l
  x.f
  y.f
  speed.f
  speed2.f
  direction.l
  going.l
EndStructure
Structure player
  x.f
  score.l
  speedups.l
  turnarounds.l
  HasShield.l
  ShieldTimer.l
EndStructure

InitNetwork()
InitSound()
InitKeyboard()
InitSprite()
InitMouse()
InitJoystick()

;;;ttsInit(0,0,0)
ExamineDesktops()
Global width = DesktopWidth(0)
Global height = DesktopHeight(0)
Global GameWindow = OpenWindow(0, 0, 0, Width, height, "DragonPong", #PB_Window_ScreenCentered)
SetWindowColor(0, 000000) 
OpenWindowedScreen(WindowID(0), 0, 0, width, height, #True, 0, 0)

Global Me.player
Global Oponent.player
Global ball.ball
Global paused = 0
Global ip$ = "127.0.0.1"
Global port = 3214
Global NewMap KeysPressed()
Global NewMap MouseButtonsPressed()
Global NewMap JoystickButtonsPressed()
Global AmServer = 0
Global MusicHND = 0
Global I = 0
Global OPID1 = 0
Global OPID = 0
Global SEvent = 0
Global NTW_String.s = ""
Global *Buffer = AllocateMemory(2048)
Global TMPInput.s = ""
Global MyChar = 1
Global OPChar = 1
Global MusicFilePlaying.s = ""
Global ServeActive = 0
Global ConnectionHND = 0
Global Dim Args(20)
Global Dim S_Args.s(20)
Global GameActive = 0
Global GameStartTimer = 0
Global TempString.s = ""
Global Delta_X.f=0
Global Delta_Y.f = 0
Global Final_Pan.f = 0
Global Final_Volume.f = 0
Global Config_PanStep = 5
Global Config_Volumestep = 4
Global Config_MusicVolume.f = 5
Global Config_BoardDepth = 20
Global Config_GoalSounds = 8
Global config_Language.s = "EN"
Global Config_PointsToWin = 9
Global Dim L_Text.s(100)
Global LangFile = 0
Global ReadyToStart = 0
Global Version$ = "AFUYWGBDCMNZIUTWRUJY"
Global Determine = 0
Global Crowd_ChantVol = 10
Global crowd_going = 0
Global MouseDelta = 0
Global MouseTick = 0
Global VoiceHNDL = 0
Global GameMode = 0
Global SRMode = 1
Declare LoadSounds()
Declare ShowMenu(file.s, Music2Play.s)
Declare ShowText(text.s, music2Play.s)
Declare HandleMenus()
Declare ReadMenu()
Declare CreateServer()
Declare ConnectToServer()
Declare SendString(String.s)
Declare HandleReceived()
Declare HandleStrings()
Declare MoveLeft()
Declare moveRight()
Declare ShootBall()
Declare HandleBall()
Declare ShowLogos()
Declare Speak(Text.s)
Declare Keyboardpressed(x)
Declare MousePressed(x)
Declare JoystickPressed(x)
Declare ChangeMusicTrack(file.s, RespectVolume)
Declare.s GetInput(title.s, text.s, DefaultText.s)
Declare HandleServer()
Declare GameLoop()
Declare HandleInput()
Declare.s RemovePart(o_String.s, s_Remove.s)
Declare generate_pan(Listener_X.f, Listener_Y.f, source_X.f, source_Y.f, PanStep.f, VolumeStep.f, SoundHandle.l)
Declare Distance(X1.f, X2.f)
Declare UpdateSounds()
Declare ChangeMusicVolume(Action.s)
Declare ClearGame(StillGoing)
Declare ShowScores()
Declare ReadLang(LangCode.s)
Declare ShowTitleScreen()
Declare ChooseCharacter()
Declare HandleSpecials()
Declare CustomSleep(time)
Declare CrowdControl(action.s)
Declare VoiceControl(action.s, time)
Declare HandleMouse()
Declare HandleJoystick()

If CountProgramParameters() > 0
  config_Language = ProgramParameter()
  EndIf
ReadLang(config_Language)
LoadSounds()
ShowTitleScreen()
HandleMenus()
Procedure LoadSounds()
  speak(L_Text(1))
  Global Dim CharVoices.charvoice(5)
  For i = 1 To 5
    Charvoices(i)\intro = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/intro.wav")
    Charvoices(i)\lose = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/lose.wav")
    Charvoices(i)\name = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/name.wav")
    Charvoices(i)\opscore[1] = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/opscore1.wav")
    Charvoices(i)\opscore[2] = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/opscore2.wav")
    Charvoices(i)\opscore[3] = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/opscore3.wav")
    Charvoices(i)\opscore[4] = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/opscore4.wav")
    Charvoices(i)\opscore[5] = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/opscore5.wav")
    Charvoices(i)\score[1] = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/score1.wav")
    Charvoices(i)\score[2] = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/score2.wav")
    Charvoices(i)\score[3] = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/score3.wav")
    Charvoices(i)\score[4] = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/score4.wav")
    Charvoices(i)\score[5] = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/score5.wav")
    Charvoices(i)\win = LoadSound(#PB_Any, "Sounds/chars/"+Str(i)+"/win.wav")
  Next
  Global SFX_Ballsound = LoadSound(#PB_Any, "Sounds/pong/rolling.wav")
  Global SFX_BallBorder = LoadSound(#PB_Any, "Sounds/Pong/Ballborder.wav")
  Global SFX_Ball_Disappear = LoadSound(#PB_Any, "sounds/misc/disappear.wav")
  Global SFX_Ball_Appear = LoadSound(#PB_Any, "sounds/misc/appear.wav")
  Global SFX_MeBorder = LoadSound(#PB_Any, "sounds/pong/border.wav")
  Global SFX_OpBorder = LoadSound(#PB_Any, "sounds/pong/border.wav")
  
  Global SFX_MeMove = LoadSound(#PB_Any, "sounds/pong/move.wav")
  Global SFX_OpMove = LoadSound(#PB_Any, "sounds/pong/move.wav")
  Global SFX_Hit = LoadSound(#PB_Any, "Sounds/Pong/Hit.wav")
  Global SFX_Won = LoadSound(#PB_Any, "Sounds/Music/GAME_WON.wav")
  Global SFX_Lost = LoadSound(#PB_Any, "Sounds/Music/GAME_LOST.wav")
  Global Dim SFX_Goal(10)
  For I = 1 To Config_GoalSounds
    SFX_Goal(i) = LoadSound(#PB_Any, "sounds/pong/goal"+Str(I)+".wav")
  Next
  Global SFX_ME_ShieldOn = LoadSound(#PB_Any, "sounds/misc/shieldon.wav")
  Global SFX_ME_ShieldLoop = LoadSound(#PB_Any, "sounds/misc/shieldloop.wav")
  Global SFX_ME_ShieldHit = LoadSound(#PB_Any, "sounds/misc/shieldhit.wav")
  Global SFX_Me_ShieldOff = LoadSound(#PB_Any, "sounds/misc/shieldoff.wav")
  Global SFX_OP_ShieldOn = LoadSound(#PB_Any, "sounds/misc/shieldon.wav")
  Global SFX_OP_ShieldLoop = LoadSound(#PB_Any, "sounds/misc/shieldloop.wav")
  Global SFX_OP_ShieldHit = LoadSound(#PB_Any, "sounds/misc/shieldhit.wav")
  Global SFX_OP_ShieldOff = LoadSound(#PB_Any, "sounds/misc/shieldoff.wav")
  Global SFX_Crowd_Chant = LoadSound(#PB_Any, "sounds/crowd/chant.wav")
  Global Dim SFX_Crowd_cheer(5)
  SFX_Crowd_cheer(1) = LoadSound(#PB_Any, "sounds/crowd/cheer1.wav")
  SFX_Crowd_cheer(2) = LoadSound(#PB_Any, "sounds/crowd/cheer2.wav")
  SFX_Crowd_cheer(3) = LoadSound(#PB_Any, "sounds/crowd/cheer3.wav")
  SFX_Crowd_cheer(4) = LoadSound(#PB_Any, "sounds/crowd/cheer4.wav")
  SFX_Crowd_cheer(5) = LoadSound(#PB_Any, "sounds/crowd/cheer5.wav")
  Global Dim SFX_Crowd_Clap(2)
  SFX_Crowd_Clap(1) = LoadSound(#PB_Any, "sounds/crowd/clap1.wav")
  SFX_Crowd_Clap(2) = LoadSound(#PB_Any, "sounds/crowd/clap2.wav")
  Global Dim SFX_Crowd_EpicFail(2)
  SFX_Crowd_EpicFail(1) = LoadSound(#PB_Any, "sounds/crowd/EpicFail1.wav")
  SFX_Crowd_EpicFail(2) = LoadSound(#PB_Any, "sounds/crowd/EpicFail2.wav")
  Global SFX_Crowd_Lost = LoadSound(#PB_Any, "sounds/crowd/lost.wav")
  Global SFX_Crowd_Won = LoadSound(#PB_Any, "sounds/crowd/won.wav")
  Global SFX_Crowd_Loop = LoadSound(#PB_Any, "sounds/crowd/loop.wav")
  Global Dim SFX_Crowd_OK(2)
  SFX_Crowd_OK(1) = LoadSound(#PB_Any, "sounds/crowd/ok1.wav")
  SFX_Crowd_OK(2) = LoadSound(#PB_Any, "sounds/crowd/ok2.wav")
  Global Dim SFX_Crowd_Oh(3)
  SFX_Crowd_Oh(1) = LoadSound(#PB_Any, "sounds/crowd/oh1.wav")
  SFX_Crowd_Oh(2) = LoadSound(#PB_Any, "sounds/crowd/oh2.wav")
  SFX_Crowd_Oh(3) = LoadSound(#PB_Any, "sounds/crowd/oh3.wav")
EndProcedure
Procedure HandleMenus()
  
  ChangeMusicTrack("Menu", 1)
  Global result = Showmenu("main", "")
  If result = 1 : createServer() : EndIf
  If Result = 2
    ConnectMenu:
    Result = ShowMenu("connect", "")
    If Result = 1
      IP$ = GetInput("Host", "Enter host address to connect to", IP$)
    Goto ConnectMenu  
    EndIf
    If Result = 2
      Port = Val(GetInput("Port", "Enter port to connect on", Str(Port)))
    Goto ConnectMenu  
    EndIf
    If Result = 3 : ConnectToServer() : ProcedureReturn : EndIf
    If Result = 4 : HandleMenus() : EndIf
  EndIf
  
  If Result = 3 : End : EndIf
EndProcedure
Procedure ShowMenu(file.s, Music2Play.s)
  Global MOpen = LoadSound(#PB_Any, "Sounds/menu/Open.wav")
  PlaySound(MOpen)
  Global MClick = LoadSound(#PB_Any, "Sounds/Menu/Click.wav")
  Global MSelect = LoadSound(#PB_Any, "Sounds/Menu/Select.wav")
                                                                                                                                                                        
  
  
                                                                                    
                                                                                    
  Global TempFile = ReadFile(#PB_Any, "Menu\" + config_Language + "\" + file + ".mnu")
  Global MenuName$ = ReadString(tempFile)
  Global Dim Items.s(1000)
  
  Global Menupos = 0
  Global FoundItems = 0
  Repeat
    Menupos + 1
    FoundItems + 1
    Items(menupos) = ReadString(TempFile)
  Until Eof(TempFile)
                                                                                    
  speak (MenuName$)
  Menupos = 1
  Repeat
    ExamineKeyboard()
                                                                                      
            
    If keyboardpressed(#PB_Key_Down)
      If Menupos < FoundItems : Menupos + 1 : Else : Menupos = 1 : EndIf
      PlaySound(MClick)
      readMenu()
  EndIf
    If keyboardpressed(#PB_Key_Up)
      If Menupos > 1 : Menupos - 1 : Else : Menupos = FoundItems : EndIf
      ReadMenu()
      PlaySound(MClick)  
    EndIf
    If KeyboardReleased(#PB_Key_Return): 
      PlaySound(MSelect) 
      
                                                                                      
      customsleep(1000)
      FreeSound(MOpen)
      FreeSound(MClick)
      FreeSound(MSelect)
      

      ProcedureReturn Menupos : EndIf
    WaitWindowEvent(1)
  ForEver
EndProcedure
Procedure ShowText(text.s, music2Play.s)
  Global TextOn = LoadSound(#PB_Any, "sounds/misc/S_Open.wav")
  PlaySound(TextON)
  Global textCont = LoadSound(#PB_Any, "sounds/misc/s_continue.wav")
  Global textEnd = LoadSound(#PB_Any, "sounds/misc/s_close.wav")
                                                                                    
  Global TempMusic = LoadSound(#PB_Any, "sounds/music/" + Music2Play + ".wav")
  PlaySound(tempMusic, #PB_Sound_Loop)
                                                                                    
  Global Dim tempArray.s(1000)
  Global ToRead = 1
  Global ArrPos = 1
  Global ArrayPos = 1
  
  Global Found = 0
  Repeat
    ToRead = FindString(text, ".", ArrPos)
    If Toread <> 0
      Found + 1
                                                                                       
      Temparray(Arraypos) = Left(text, ToRead)
      Arraypos+1
      Text = Mid(text, Toread+1, Len(text))
                                                                                      
                                                                                        
    EndIf  
                                                                                      
  Until Toread = 0
  speak(TempArray(1))
  Global Postoread = 1
  Repeat
      ExamineKeyboard()
                                                                                      
            
      If keyboardpressed(#PB_Key_Return)
        postoread + 1
        If Postoread =< found : 
          PlaySound(TextCont)
          speak(TempArray(Postoread))
        EndIf
      EndIf
      If KeyboardPushed(#PB_Key_Escape) :  Postoread = Found+1  : EndIf
                                                                                      
      customsleep(16)
      WaitWindowEvent(1)
                                                                                    
  Until Postoread = Found+1
  PlaySound(TextEnd)
  customsleep(500)
                                                                                    
  FreeSound(TextOn)
  FreeSound(TextCont)
  FreeSound(TextEnd)
  StopSound(TempMusic)
                                                                                    
                                                                                    
EndProcedure
Procedure ReadMenu()

  speak(Items(Menupos))
EndProcedure
Procedure Speak(text.s)
  If SrMode = 1
    
    SetWindowTitle(0, text)
  Else
    ;ttsStop()
    ;ttsSpeak(Text)
    EndIf
EndProcedure
Procedure KeyboardPressed(x)
  If KeyboardReleased(X)
    KeysPressed(Str(x)) = 0
    ProcedureReturn 0
  EndIf
  If KeysPressed(Str(x))
    ProcedureReturn 0
  EndIf
  If KeyboardPushed(x)
    KeysPressed(Str(x)) = 1
    ProcedureReturn 1
  EndIf
  

EndProcedure

Procedure SendString(String.s)
  If AmServer = 0 : OPID = ConnectionHND : EndIf
  SendNetworkString(OPID, string + "$")
EndProcedure
Procedure CreateServer()
  AmServer = 1
  ChangeMusicTrack("connection", 1)
  Speak(L_Text(2))
  port = Val(GetInput("Port", "Enter port number to host the game on", Str(Port)))
  GameMode = ShowMenu("gamemode", "")
  Speak(L_Text(3))
  CreateNetworkServer(0, port, #PB_Network_TCP)
  Speak(L_Text(4))
  Repeat
    WaitWindowEvent(1)
    ExamineKeyboard()
    If KeyboardPressed(#PB_Key_Escape)
      ChangeMusicTrack("", 1)
      CloseNetworkServer(0)
      HandleMenus()
      ProcedureReturn
    EndIf
  SEvent = NetworkServerEvent()
  If SEvent
    
    FreeMemory(*Buffer)
    Global *Buffer = AllocateMemory(2048)
    OPID = EventClient()
    Select SEvent  
      Case #PB_NetworkEvent_Connect
        Speak(IPString(GetClientIP(OPID)) + " " + L_Text(5))
      Case #PB_NetworkEvent_Data
        ReceiveNetworkData(OPID, *Buffer, 4096)
        NTW_String = PeekS(*Buffer)
        
        If FindString(NTW_String, "_P_HI") > 0
          If FindString(NTW_String, Version$) > 0
          Speak(L_Text(6))
          SendString("_P_VARIFIED"+Str(GameMode))
          Break
        Else
          HandleMenus()
          ProcedureReturn
        EndIf
        
        EndIf
        
    EndSelect
  EndIf
  
  ForEver
  customsleep(2000)
  
  
  
  MyChar = ChooseCharacter()
  SendString("_P_V"+Str(MyChar))
    PlaySound(CharVoices(myChar)\name)
    ChangeMusicTrack("InGame", 1)
    CrowdControl("start")
  NTW_String = ""
  Speak(L_Text(7))
  
  me\X = 1
  Me\score = 0
  Oponent\X = 1
  Oponent\Score = 0
  Ball\X = 1
  Ball\Y = 1
  Ball\Speed = 0.1
  Ball\direction = 1
  Ball\going = 0
  ReadyToStart = 0
  GameLoop()
EndProcedure
Procedure ConnectToServer()
  AMServer = 0
  ChangeMusicTrack("connection", 1)
  Speak(L_Text(8) + " " + IP$ + " " + L_Text(9) + " " + Str(Port))
  ConnectionHND = OpenNetworkConnection(IP$, port, #PB_Network_TCP)
  If ConnectionHND = 0 : Speak(L_Text(10)) : customsleep(1000) : HandleMenus() : EndIf
  SendString("_P_HI"+Version$)
  Speak(L_Text(11))
  Repeat
    WaitWindowEvent(1)
    ExamineKeyboard()
    If KeyboardPressed(#PB_Key_Escape)
      ChangeMusicTrack("", 1)
      CloseNetworkConnection(ConnectionHND)
      HandleMenus()
      ProcedureReturn
    EndIf
    SEvent = NetworkClientEvent(ConnectionHND)
    If SEvent
    
      FreeMemory(*Buffer)
      Global *Buffer = AllocateMemory(2048)
      
      Select SEvent  
      
        Case #PB_NetworkEvent_Data
          ReceiveNetworkData(ConnectionHND, *Buffer, 4096)
          NTW_String = PeekS(*Buffer)
          
          If FindString(NTW_String, "_P_VARIFIED") > 0  
            GameMode = Val(Mid(NTW_String, FindString(NTW_String, "_P_VARIFIED")+11, FindString(NTW_String, "_P_VARIFIED")+12))
            Break
          EndIf
      EndSelect
    EndIf
  
  ForEver
  
  customsleep(2000)
  
  me\X = 1
  Me\score = 0
  Oponent\X = 1
  Oponent\Score = 0
  ChangeMusicTrack("charselect", 0)
  MyChar = ChooseCharacter()
  SendString("_P_V"+Str(MyChar))
    PlaySound(CharVoices(myChar)\name)
    SendString("_P_R")
    ChangeMusicTrack("InGame", 1)
    CrowdControl("start")
  NTW_String = ""
  Speak(L_Text(12))
  GameLoop()
EndProcedure
Procedure ChangeMusicTrack(file.s, RespectVolume)
  If File <> MusicFilePlaying
    If IsSound(MusicHnd)
      StopSound(MusicHND)
      FreeSound(MusicHND)  
    EndIf
    MusicHND = LoadSound(#PB_Any, "Sounds/Music/"+File+".wav")
    PlaySound(MusicHND, #PB_Sound_Loop)
    MusicFilePlaying = File
    If RespectVolume = 1 : SoundVolume(MusicHND, Config_MusicVolume) : EndIf
  EndIf  
EndProcedure

Procedure.s GetInput(title.s, text.s, DefaultText.s)
  
  ProcedureReturn InputRequester(title, text, DefaultText)
EndProcedure

Procedure HandleReceived()
  If AmServer = 1
    SEvent = NetworkServerEvent()
    If SEvent
    
      FreeMemory(*Buffer)
      Global *Buffer = AllocateMemory(2048)
      OPID1 = EventClient()
      If OPID1 <> OPID
        Speak(L_Text(13))
        Opid1 = Opid
      EndIf
      
      Select SEvent  
        
      Case #PB_NetworkEvent_Data
          ReceiveNetworkData(OPID, *Buffer, 4096)
          NTW_String = PeekS(*Buffer)
      EndSelect
      
    EndIf
  EndIf
  If AmServer = 0
    SEvent = NetworkClientEvent(ConnectionHND)
    If SEvent
    
      FreeMemory(*Buffer)
      Global *Buffer = AllocateMemory(2048)
      
      Select SEvent  
      
        Case #PB_NetworkEvent_Data
          ReceiveNetworkData(ConnectionHND, *Buffer, 4096)
          NTW_String = PeekS(*Buffer)
      EndSelect
    EndIf
  EndIf
  
EndProcedure
Procedure HandleStrings()
  If NTW_String <> ""
    While Len(NTW_String) > 0

      If Left(NTW_String, 3) = "_P_"
        NTW_String = Right(NTW_String, Len(NTW_String)-3)
      Else
        NTW_String = ""
      EndIf
      If Not Right(NTW_String, 1) = "$"
        Break
      EndIf
      
      TempString = Left(NTW_String, FindString(NTW_String, "$")-1)
      NTW_String = RemoveString(NTW_String, Left(NTW_String, FindString(NTW_String, "$")), 0, 1, 1)
      If Left(TempString,1) = "R"
        TempString = RemoveString(TempString, Left(TempString, 1), 0, 1, 1)
        ReadyToStart = 1
        GameStartTimer = ElapsedMilliseconds()
        CrowdControl("clap")
      EndIf
      
      If Left(TempString,1) = "V"
        TempString = RemoveString(TempString, Left(TempString, 1), 0, 1, 1)
        OPChar = Val(TempString)
        PlaySound(CharVoices(OpChar)\intro)
        
        CrowdControl("clap")
      EndIf
      If Left(TempString, 1) = "S"
        GameActive = 1
        
        TempString = RemoveString(TempString, Left(TempString, 1), 0, 1, 1)
        ServeActive = Val(TempString)
        If ServeActive = 1
          ServeActive = 0
          Speak(L_Text(14))
        Else
          ServeActive = 1
          Speak(L_Text(15))
        EndIf
        VoiceControl("gamestart", 0)
      EndIf
      
      If Left(TempString, 1) = "P"
        
        TempString = RemoveString(TempString, Left(TempString, 1), 0, 1, 1)
        Oponent\x = Val(TempString)
        If Oponent\X > 1 And Oponent\X < 19
          PlaySound(SFX_OpMove)
        Else
          PlaySound(SFX_OpBorder)
        EndIf
      EndIf
      If Left(TempString,2) = "BD"
        TempString = RemoveString(TempString, Left(TempString, 2), 0, 1, 1)
        
        Ball\direction = Val(TempString)
        If Val(TempString) = 1 : ball\Direction = 1 : EndIf
      EndIf
      If Left(TempString,2) = "BS"
        TempString = RemoveString(TempString, Left(TempString, 2), 0, 1, 1)
        Ball\Speed = Val(TempString)/1000
      EndIf
      If Left(TempString,2) = "BQ"
        TempString = RemoveString(TempString, Left(TempString, 2), 0, 1, 1)
        Ball\Speed2 = Val(TempString)/1000
      EndIf
      If Left(TempString,2) = "XD"
        TempString = RemoveString(TempString, Left(TempString, 2), 0, 1, 1)
        StopSound(SFX_Ballsound)
        PlaySound(SFX_Ball_Disappear)
        Ball\Disappeared = 1
        CrowdControl("oh")
      EndIf
      
      If Left(TempString,2) = "XS"
        TempString = RemoveString(TempString, Left(TempString, 2), 0, 1, 1)
        Oponent\HasShield = 1
        Oponent\ShieldTimer = ElapsedMilliseconds()
        PlaySound(SFX_OP_ShieldON)
        PlaySound(SFX_OP_ShieldLoop, #PB_Sound_Loop)
        CrowdControl("oh")
      EndIf
      If Left(TempString,4) = "XASR"
        TempString = RemoveString(TempString, Left(TempString, 4), 0, 1, 1)
        PlaySound(SFX_OP_ShieldHit)
        Ball\Going = 1
        
      EndIf
      
      
      
      If Left(TempString, 1) = "G"
        TempString = RemoveString(TempString, Left(TempString, 1), 0, 1, 1)
        me\score + 1
        Ball\Going = 0
        StopSound(SFX_Ballsound)
        PlaySound(SFX_Goal(Random(Config_GoalSounds-1)+1))
        If Ball\Disappeared = 1 : ball\Disappeared = 0 : PlaySound(SFX_Ball_Appear) : EndIf
        Speak(L_Text(18) + ": " +  Str(me\Score) + " " + L_Text(19) + " " + Str(Oponent\Score))
        CrowdControl("reset")
        CrowdControl("cheer")
        VoiceControl("score"+Str(Random(4)+1), 0)
        PlaySound(CharVoices(OPChar)\opscore[Random(4)+1])
        customsleep(3000)
        PlaySound(CharVoices(MyChar)\Score[Random(4)+1])
CustomSleep(3000)
VoiceControl("scores", 500) : VoiceControl(Str(me\score), 500) : VoiceControl(Str(Oponent\Score), 500)

          
      EndIf
      If Left(TempString, 2) = "BE"
        TempString = RemoveString(TempString, Left(TempString, 2), 0, 1, 1)
        generate_pan(me\x, 0, Oponent\x, Config_BoardDepth, Config_PanStep, Config_Volumestep, SFX_Hit)
        PlaySound(SFX_Hit)
        PlaySound(SFX_Ballsound, 1, 0)
        
        Ball\Going = 1
        Ball\X = Oponent\X
        If Ball\Disappeared = 1 : ball\Disappeared = 0 : PlaySound(SFX_Ball_Appear) : EndIf
        Ball\Y = Config_BoardDepth
        CrowdControl("chant")
        CrowdControl("increase")
        
      EndIf
      If Left(TempString, 3) = "BYE"
        TempString = RemoveString(TempString, Left(TempString, 3), 0, 1, 1)
        ClearGame(0)
      EndIf
      If Left(TempString, 1) = "D"
        TempString = RemoveString(TempString, Left(TempString, 3), 0, 1, 1)
        ShowScores()
      EndIf
      
    Wend
    NTW_String = ""
      
  EndIf
  
EndProcedure
Procedure HandleServer()
  If AmServer = 1
    
    If GameActive = 0
      If ReadyToStart = 1
        If ElapsedMilliseconds()-GameStartTimer > 10000
          ServeActive = Random(1)
          If ServeActive = 0 : speak(L_Text(14)) : EndIf
          If ServeActive = 1 : Speak(L_Text(15)) : EndIf
        
          SendString("_P_S"+Str(ServeActive))
          GameActive = 1
          If GameMode = 1 : Config_PointsToWin = 10 : Else : Config_PointsToWin = 20 : EndIf
          VoiceControl("gamestart", 0)
        EndIf
        EndIf
    EndIf
    If GameActive = 1
      If me\Score > Config_PointsToWin Or Oponent\Score > Config_PointsToWin
        SendString("_P_D")
        ShowScores()
      EndIf
    EndIf
  EndIf
  
EndProcedure
Procedure GameLoop()
  
  Repeat
    
    HandleReceived()
    HandleStrings()
    HandleBall()
    HandleServer()
    HandleInput()
    HandleSpecials()
    UpdateSounds()
    WaitWindowEvent(1)
    customsleep(16)
  ForEver
EndProcedure
Procedure HandleInput()
  ExamineKeyboard()
  ExamineMouse()
  ExamineJoystick(0)
  If KeyboardPushed(#PB_Key_PageDown) : ChangeMusicVolume("Down") : EndIf
  If KeyboardPushed(#PB_Key_PageUp) : ChangeMusicVolume("Up") : EndIf
  If KeyboardPressed(#PB_Key_Escape)
    
    ClearGame(1)
    ProcedureReturn
  EndIf
  If gameActive = 1
    If KeyboardPressed(#PB_Key_Left) : MoveLeft() : EndIf
    If KeyboardPressed(#PB_Key_Right) : MoveRight() : EndIf
    If KeyboardPressed(#PB_Key_Up) : ShootBall() : EndIf
    MouseDelta = MouseDeltaX()
    
    If MouseButton(#PB_MouseButton_Left) And MouseButtonsPressed("left") = 0
      MouseButtonsPressed("left") = 1
      ShootBall()
    EndIf
    If Not MouseButton(#PB_MouseButton_Left) And MouseButtonsPressed("left") = 1 : MouseButtonsPressed("left") = 0 : EndIf
    
    If MouseDelta > 0
      MouseTick + 1
      If MouseTick > 2
        MoveRight() 
        MouseTick = 0
      EndIf
      
    EndIf
    If MouseDelta < 0
      MouseTick + 1
      If MouseTick > 2
        MoveLeft() 
        MouseTick = 0
      EndIf
      
    EndIf
    MouseDelta = 0
    If JoystickButton(0, 1) And JoystickButtonsPressed("1") = 0
      JoystickButtonsPressed("1") = 1
      ShootBall()
    EndIf
    If Not JoystickButton(0, 1) And JoystickButtonsPressed("1") = 1 : JoystickButtonsPressed("1") = 0 : EndIf
    If JoystickAxisX(0) = -1 : MoveLeft() : EndIf
    If JoystickAxisX(0) = 1 : MoveRight() : EndIf
    
    
  EndIf
EndProcedure
Procedure HandleBall()
  If Ball\Going > 0
    If Ball\Going = 1
      If Ball\Y < 1
        If Me\HasShield = 1
          Ball\Going = 2
          PlaySound(SFX_ME_ShieldHit)
          SendString("_P_XASR")
          ProcedureReturn
        EndIf
        If Ball\Disappeared = 1 : ball\Disappeared = 0 : PlaySound(SFX_Ball_Appear) : PlaySound(SFX_Ballsound, 1) : EndIf
        Ball\Going = 0
        StopSound(SFX_Ballsound)
        PlaySound(SFX_Goal(Random(Config_GoalSounds-1)+1))
        CrowdControl("reset")
        CrowdControl("epicfail")
        VoiceControl("score"+Str(Random(4)+1), 0)
        Oponent\Score + 1
        Speak(L_Text(18) + ": " +  Str(me\Score) + " " + L_Text(19) + " " + Str(Oponent\Score))
        SendString("_P_G")
        PlaySound(CharVoices(OpChar)\Score[Random(4)+1])
        customsleep(3000)
        PlaySound(CharVoices(MyChar)\opscore[Random(4)+1])
        CustomSleep(3000)
        VoiceControl("scores", 500) : VoiceControl(Str(me\score), 500) : VoiceControl(Str(Oponent\Score), 300)
      EndIf
    EndIf
    If Ball\Going = 1
      Ball\Y - ball\Speed
    Else
      If ball\Y < Config_BoardDepth : Ball\Y + Ball\Speed : EndIf
    EndIf
    
    If Ball\Direction = 1 : Ball\X - Ball\Speed2 : EndIf
    If Ball\Direction = 2 : Ball\X + Ball\Speed2 : EndIf
    If Ball\X < 1 And Ball\Direction = 1
      Ball\Direction = 2
      PlaySound(SFX_BallBorder)
    EndIf
    If Ball\X > 19 And Ball\direction = 2
      Ball\Direction = 1
      PlaySound(SFX_BallBorder)
    EndIf
    
  EndIf
EndProcedure
Procedure.s RemovePart(o_String.s, s_Remove.s)
  ProcedureReturn RemoveString(o_String, Left(o_String, FindString(o_String, s_Remove)), 0, 1, 1)
EndProcedure
Procedure MoveLeft()
  If Me\x > 1
    Me\X - 1
    PlaySound(SFX_MeMove)
    
  Else
    PlaySound(SFX_Meborder)
  EndIf
  SendString("_P_P"+Str(Me\X))
EndProcedure
Procedure MoveRight()
  If Me\x < 19
    Me\X + 1
    PlaySound(SFX_MeMove)
    
  Else
    PlaySound(SFX_Meborder)
  EndIf
  SendString("_P_P"+Str(Me\X))
EndProcedure
Procedure ShootBall()
  If Ball\Going = 0
    If ServeActive = 1
      PlaySound(SFX_Hit)
      PlaySound(SFX_Ballsound, 1, 0)
      Ball\direction = Random(1)+1
      Ball\Speed = 0.05
      ball\Speed2 = 0.01
      Ball\y = 0
      Ball\X = me\X
      Ball\Going = 2
      SendString("_P_BD"+Str(Ball\Direction))
      SendString("_P_BQ"+Str(ball\Speed2*1000))
      SendString("_P_BS"+Str(ball\Speed*1000))
      SendString("_P_BE")
      CrowdControl("chant")
    EndIf
  EndIf
  If Ball\Going = 1
    If Ball\Y < 6
      If Distance(me\X, Ball\X)
        If Me\X < Ball\x : ball\Direction = 2 : EndIf
        If Me\X > Ball\X : Ball\Direction = 1 : EndIf
        If Me\X = Ball\X : Ball\Direction = 3 : EndIf
        SoundPan(SFX_Hit, 0)
        PlaySound(SFX_Hit, 0, 100)
        Ball\Going = 2
        Ball\Speed + Random(5)/100
        Ball\Speed2 + Random(5)/100
        SendString("_P_BD"+Str(Ball\Direction))
        SendString("_P_BS"+Str(ball\Speed*1000))
        SendString("_P_BQ"+Str(ball\Speed2*1000))
        SendString("_P_BE")
        If Ball\Disappeared = 1 : ball\Disappeared = 0 : PlaySound(SFX_Ball_Appear) : PlaySound(SFX_Ballsound, 1) : EndIf
        CrowdControl("increase")
                Determine = Random(10)
        If Determine = 7
          me\HasShield = 1
          me\ShieldTimer = ElapsedMilliseconds()
          PlaySound(SFX_Me_ShieldON)
          PlaySound(SFX_ME_ShieldLoop, #PB_Sound_Loop)
          SendString("_P_XS")
          CrowdControl("oh")
        EndIf
        
        Determine = Random(20)
        If Determine = 13
          PlaySound(SFX_Ball_Disappear)
          StopSound(SFX_Ballsound)
          Ball\Disappeared = 1
          SendString("_P_XD")
          CrowdControl("oh")
          EndIf
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure generate_pan(Listener_X.f, Listener_Y.f, source_X.f, source_Y.f, PanStep.f, VolumeStep.f, SoundHandle.l)
  delta_x.f=0;
  delta_y.f=0;
  final_pan.f=0;
  final_volume.f=100
  If source_x<listener_x

    delta_x=listener_x-source_x;
    final_pan=Final_Pan-(delta_x*panstep);
    ;final_volume=final_volume-(delta_x*volumestep);
  EndIf
  If source_x>listener_x

    delta_x=source_x-listener_x;
    final_pan=Final_Pan+(delta_x*panstep);
    ;final_volume=final_volume-(delta_x*volumestep);

  EndIf
  If source_y<listener_y


    delta_y=listener_y-source_y;
    final_volume=final_volume-(delta_y*volumestep);
  EndIf
  If source_y>listener_y

    delta_y=source_y-listener_y;
    final_volume=final_volume-(delta_y*volumestep);
  EndIf
  If final_volume < 0 : final_volume = 0 : EndIf
  If final_pan < -100 : final_pan = -100 : EndIf
  If final_pan > 100 : final_pan = 100 : EndIf

  SoundVolume(SoundHandle, Final_Volume)
  SoundPan(SoundHandle, Final_Pan)
EndProcedure
Procedure Distance(X1.f, X2.f)
  If X1.f < x2.f+3 And X1.f > X2.f-3 : ProcedureReturn 1 : EndIf
EndProcedure
Procedure UpdateSounds()
  generate_pan(me\x, 0, ball\x, ball\y, Config_PanStep, Config_Volumestep, SFX_Ballsound)
  generate_pan(me\x, 0, ball\x, ball\y, Config_PanStep, Config_Volumestep, SFX_BallBorder)
  generate_pan(me\x, 0, Oponent\x, Config_BoardDepth, Config_PanStep, Config_Volumestep, SFX_OpBorder)
  generate_pan(me\x, 0, Oponent\x, Config_BoardDepth, Config_PanStep, Config_Volumestep, SFX_OpMove)
  SoundVolume(SFX_OP_ShieldHit, 30)
  SoundVolume(SFX_OP_ShieldLoop, 30)
  SoundVolume(SFX_OP_ShieldOff, 30)
  SoundVolume(SFX_OP_ShieldOn, 30)
  
EndProcedure
Procedure ChangeMusicVolume(Action.s)
  If Action = "Down" : Config_MusicVolume - 0.25 : EndIf
  If Action = "Up" : Config_MusicVolume + 0.25 : EndIf
  SoundVolume(MusicHND, Config_MusicVolume)
EndProcedure
Procedure ClearGame(StillGoing)
  If StillGoing = 1
    If AmServer = 0 : SendString("_P_BYE") : CloseNetworkConnection(ConnectionHND) : EndIf
    If AMServer = 1 : SENDSTRING("_P_BYE") : CloseNetworkServer(0) : EndIf
  EndIf
  Ball\direction = 0
  Ball\going = 0
  Ball\speed = 0
  Ball\Speed2 = 0
  Ball\x = 0
  Ball\Y = 0
  me\score = 0
  Me\speedups = 0
  Me\turnarounds = 0
  Me\x = 0
  Oponent\X = 0
  Oponent\speedups = 0
  Oponent\turnarounds = 0
  Oponent\score = 0
  GameActive = 0
  StopSound(-1)
  HandleMenus()

EndProcedure
Procedure ShowScores()
  If me\Score < oponent\Score : PlaySound(CharVoices(OPChar)\Win) : Speak(L_Text(16)) : CrowdControl("lost") : VoiceControl("theywin", 0) : EndIf
  If Me\Score > Oponent\Score : PlaySound(SFX_WON) : PlaySound(CharVoices(OPChar)\lose) : Speak(L_Text(17)) : CrowdControl("won") : VoiceControl("youwin", 0) : EndIf
  customsleep(1000)
  Speak(L_Text(18) + ": " +  Str(me\Score) + " " + L_Text(19) + " " + Str(Oponent\Score))
  Repeat
    ExamineKeyboard()
    WaitWindowEvent(1)
  Until KeyboardReleased(#PB_Key_Return)
  If me\Score < oponent\Score : PlaySound(SFX_Lost) : CustomSleep(7000) : Else : PlaySound(SFX_Won) : CustomSleep(7000) : EndIf
  ClearGame(1)
EndProcedure
Procedure ReadLang(LangCode.s)
  If OpenFile(0, "lang/"+LangCode+".lng") = 0
    Speak("Language file not found!")
    End
  EndIf
  I = 0
  Repeat
    I + 1
    L_Text(i) = ReadString(0)
  Until Eof(0)
  CloseFile(0)
EndProcedure
Procedure ShowTitleScreen()
  
  ChangeMusicTrack("title", 0)
  Speak(L_Text(20))
  Repeat
    ExamineKeyboard()
    WaitWindowEvent(1)
    customsleep(16)
  Until KeyboardReleased(#PB_Key_Return)
  
EndProcedure
Procedure ChooseCharacter()
  ChangeMusicTrack("Charselect", 0)
  Global TMPSFX = 0
  Global TMPMSFX = LoadSound(#PB_Any, "sounds/charselect/csenter.wav")
  PlaySound(TMPMSFX)
  TMPSFX = LoadSound(#PB_Any, "sounds/charselect/0.wav")
  PlaySound(TMPSFX)
  Global CharSelected = 0
  Repeat
    ExamineKeyboard()
    If KeyboardPressed(#PB_Key_Left)
      CharSelected - 1
      If CharSelected < 1 : CharSelected = 5 : EndIf
      StopSound(TMPMSFX) : FreeSound(TMPMSFX) : TMPMSFX = LoadSound(#PB_Any, "sounds/CharSelect/CSMove.wav") : PlaySound(TMPMSFX)
      StopSound(TMPSFX) : FreeSound(TMPSFX) : TMPSFX = LoadSound(#PB_Any, "sounds/charselect/"+Str(CharSelected)+".wav") : PlaySound(TMPSFX)
    EndIf
    If KeyboardPressed(#PB_Key_Right)
      CharSelected + 1
      If CharSelected > 5 : CharSelected = 1 : EndIf
      StopSound(TMPMSFX) : FreeSound(TMPMSFX) : TMPMSFX = LoadSound(#PB_Any, "sounds/CharSelect/CSMove.wav") : PlaySound(TMPMSFX)
      StopSound(TMPSFX) : FreeSound(TMPSFX) : TMPSFX = LoadSound(#PB_Any, "sounds/charselect/"+Str(CharSelected)+".wav") : PlaySound(TMPSFX)
    EndIf
    If KeyboardReleased(#PB_Key_Return)
      FreeSound(TMPSFX)
      StopSound(TMPMSFX) : FreeSound(TMPMSFX) : TMPMSFX = LoadSound(#PB_Any, "sounds/CharSelect/CSExit.wav") : PlaySound(TMPMSFX) : customsleep(1000) : FreeSound(TMPMSFX)
      ProcedureReturn CharSelected
    EndIf

    customsleep(16)
  ForEver
EndProcedure
Procedure HandleSpecials()
  If me\HasShield = 1
    If ElapsedMilliseconds()-me\ShieldTimer > 30000
      me\HasShield = 0
      StopSound(SFX_ME_ShieldLoop)
      PlaySound(SFX_Me_ShieldOff)
    EndIf
  EndIf
  If Oponent\HasShield = 1
    If ElapsedMilliseconds()-Oponent\ShieldTimer > 30000
      oponent\HasShield = 0
      StopSound(SFX_OP_ShieldLoop)
      PlaySound(SFX_OP_ShieldOff)
    EndIf
  EndIf
EndProcedure
Procedure CustomSleep(time)
  Global CurrentTime = ElapsedMilliseconds()
  Repeat
    WaitWindowEvent(1)
    Until ElapsedMilliseconds()-CurrentTime > Time
EndProcedure
Procedure CrowdControl(action.s)
  If Action = "start"
    PlaySound(SFX_Crowd_Loop, #PB_Sound_Loop)
  EndIf
  If Action = "chant"
    If crowd_going = 0
    Crowd_ChantVol = 10
    PlaySound(SFX_Crowd_Chant, #PB_Sound_Loop, Crowd_ChantVol)
    crowd_going = 1
    EndIf
  EndIf
  If action = "increase"
    
    Crowd_ChantVol + 5
    SoundVolume(SFX_Crowd_Chant, Crowd_ChantVol)
    If Crowd_ChantVol > 40 : PlaySound(SFX_Crowd_OK(Random(1)+1)) : EndIf
  EndIf
  If action = "cheer"
    PlaySound(SFX_Crowd_cheer(Random(4)+1))
  EndIf
  If action = "clap"
    PlaySound(SFX_Crowd_Clap(Random(1)+1))
  EndIf
  If action = "epicfail"
    PlaySound(SFX_Crowd_EpicFail(Random(1)+1))
  EndIf
  If Action = "ok"
    PlaySound(SFX_Crowd_OK(Random(1)+1))
  EndIf
  If action = "oh"
    PlaySound(SFX_Crowd_Oh(Random(2)+1))
  EndIf
  If action = "won"
    PlaySound(SFX_Crowd_Won)
  EndIf
  If action = "lost"
    PlaySound(SFX_Crowd_Lost)
    EndIf
  If action = "reset"
    StopSound(SFX_Crowd_Chant)
    Crowd_ChantVol = 10
    crowd_going = 0
    
  EndIf
  If action = "stop"
    StopSound(SFX_Crowd_Loop)
    EndIf
EndProcedure
Procedure VoiceControl(action.s, time)
  If IsSound(VoiceHNDL) : FreeSound(VoiceHNDL) : EndIf
  VoiceHNDL = LoadSound(#PB_Any, "sounds/announcer/"+action+".wav")
  PlaySound(VoiceHNDL)
  Global CurrentTime = ElapsedMilliseconds()
  Repeat
    WaitWindowEvent(1)
    Until ElapsedMilliseconds()-CurrentTime > Time

EndProcedure

; IDE Options = PureBasic 5.31 (Windows - x86)
; CursorPosition = 349
; FirstLine = 320
; Folding = ------
; EnableXP
; Executable = DragonPong.exe
; DisableDebugger
; Debugger = Console
; IncludeVersionInfo
; VersionField0 = 1.0.0.0
; VersionField1 = 1.0.0.0
; VersionField2 = DragonApps.org
; VersionField3 = DragonPong
; VersionField4 = 1.0.0.0
; VersionField5 = 1.0.0.0
; VersionField6 = DragonPong
; VersionField7 = DP2013
; VersionField8 = dragonpong.exe
; VersionField9 = Copyright 2013 DragonApps.ORG
; VersionField14 = http://dragonapps.org