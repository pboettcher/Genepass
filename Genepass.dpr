program GenePass;

uses Messages,Windows;

{$R *.RES}

var Form:TWndClass;
    HWn,Handle,Button1,Memo1:HWnd;
    Msg:TMsg;

procedure Work;
const AllowedChars='!$%&+-.0123456789@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz';
var i,l,lac:integer;
    s:array[0..16]of char;
begin
  Randomize;
  l:=Random(10)+6; //В пароле минимум 6 символов, максимум 16
  s:='';
  lac:=Length(AllowedChars);
  for i:=0 to l-1 do begin
    s[i]:=AllowedChars[Random(lac-1)+1];
    s[i+1]:=chr(0);
  end;
  SetWindowText(Memo1,s);
end;

function WindowProc(hWnd,Msg,wParam,lParam:Longint):Longint; stdcall;
begin
  Result:=DefWindowProc(hWnd,Msg,wParam,lParam);
  case Msg of
    WM_COMMAND: if Lparam=Button1 then work;
    WM_DESTROY: begin
                  UnRegisterClass('Window',HWn);
                  ExitProcess(HWn);
                end;
  end;
end;

const ZFace:array[0..20] of char='MS Sans Serif';
      Size=10;

var Font1:integer;

begin
  HWn:=GetModuleHandle(NIL);
  with Form do begin
    Style:=CS_PARENTDC;
    hIcon:=LoadIcon(hwn,'MAINICON');
    lpfnWndProc:=@WindowProc;
    hInstance:=HWn;
    hbrBackground:=COLOR_BTNFACE+1;
    lpszClassName:='Window';
    hCursor:=LoadCursor(0,IDC_ARROW);
  end;
  RegisterClass(Form);
  Font1:=CreateFont(Size,0,0,0,fw_DontCare,0,0,0,1,
    OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,PROOF_QUALITY,
    VARIABLE_PITCH,ZFace);
  Handle:=CreateWindow('Window','Генератор паролей',
    281673728,10,10,330,60,0,0,hwn,NIL);
  SendMessage(Handle,wm_SetFont,Font1,0);
  Memo1:=CreateWindowEx(WS_EX_CLIENTEDGE,'Edit','',
    WS_VISIBLE or WS_CHILD or ES_LEFT or ES_WANTRETURN,
    5,5,200,23,Handle,0,HWn,NIL);
  SendMessage(Memo1,wm_SetFont,Font1,0);
  Button1:=CreateWindow('Button','Новый пароль',
    WS_VISIBLE or WS_CHILD or BS_PUSHLIKE or BS_TEXT,
    210,5,100,25,Handle,0,HWn,NIL);
  SendMessage(Button1,wm_SetFont,Font1,0);
  while(GetMessage(Msg,Handle,0,0))do begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end.

