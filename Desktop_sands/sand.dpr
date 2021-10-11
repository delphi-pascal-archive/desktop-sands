program sand;

uses
  Forms,
  windows,
  SysUtils,   graphics,
  UMain in 'UMain.pas' {Form1},
  UConfig in 'UConfig.pas' {Form2};

{$R *.res}
{$E scr}

function Screenshot(var bmp: TBitmap; MonitorNumber: Integer): Boolean;
const
  CAPTUREBLT = $40000000;
var
  DC: HDC;
  Left, Top: Integer;
begin
  Result := False;
  if (MonitorNumber >= Screen.MonitorCount) then  Exit;
  DC:= GetDC(0);
  try
    if (DC = 0) then  Exit;
    Bmp.Width := Screen.Monitors[MonitorNumber].Width;
    Bmp.Height := Screen.Monitors[MonitorNumber].Height;
    Left := Screen.Monitors[MonitorNumber].Left;
    Top := Screen.Monitors[MonitorNumber].Top;
    try
      Result := BitBlt(
        Bmp.Canvas.Handle,
        0, 0, Bmp.Width, Bmp.Height,
        DC, Left,Top,
        SRCCOPY or CAPTUREBLT);
      Result:= True;
    finally
    end;
  finally
    if (DC <> 0) then  ReleaseDC(0, DC);
  end;
end;


var
 i:integer;
 bmp:tbitmap;
 
begin
  Param1 := Copy(UpperCase(ParamStr(1)),1,2);
  Param2 := UpperCase(ParamStr(2));
  If (Length(Param1)>0)And Not (Param1[1] In ['A'..'Z']) Then
    Param1 := Copy(Param1,2,1);

  ssMode := ssAffiche;
  If Param1='P' Then ssMode := ssPrevisu;
  If Param1='C' Then ssMode := ssConfig;
  If Param1='S' Then ssMode := ssAffiche;
  If Param1='A' Then ssMode := ssMotDePasse;

  // vérifie si le programme est déjà lancé
  SetLastError(NO_ERROR);
  CreateMutex (nil, False, 'MONSCREENSAVER');
  if GetLastError = ERROR_ALREADY_EXISTS Then Exit;

  case ssMode of
  ssAffiche:
   begin
    SystemParametersInfo(SPI_SCREENSAVERRUNNING,1,@i,0);
    Application.Initialize;
    bmp:=tbitmap.Create;
    for i:=0 to screen.MonitorCount-1 do
     begin
      Application.CreateForm(TForm1, Form1);
      Form1.Cursor:=-1;
      Screenshot(Form1.bitmap,i);
      if not form1.Visible then Form1.Show;
      Form1.BoundsRect:=screen.Monitors[i].BoundsRect;
      Form1.iniPicture;
     end;
    bmp.Free;
    Application.Run;
    SystemParametersInfo(SPI_SCREENSAVERRUNNING,0,@i,0);
   end;
  ssPrevisu:
   begin
    Application.Initialize;
    Application.CreateForm(TForm1, Form1);
    Form1.bitmap.assign(Form1.image1.picture.bitmap);
    Form1.iniPicture;
    Form1.ParentWindow := StrToInt(paramstr(2));
    Form1.WindowState:=wsMaximized;
    Application.Run;
   end;
  ssConfig:
   begin
    Application.Initialize;
    Application.CreateForm(TForm2, Form2);
    Application.CreateForm(TForm1, Form1);
    Form1.bitmap.assign(Form1.image1.picture.bitmap);
    Form1.iniPicture;
    ssmode:=ssPrevisu;
    Form1.ParentWindow := Form2.panel1.Handle;
    Form1.WindowState:=wsMaximized;
    Form1.Show;
    Application.Run;
   end;
  ssMotDePasse:
   begin
   end;
  end;
end.
