// Name:   KOL Addon - Visual XP Styles
// Rev.:   1.95
// Date:   9 aug 2007 /18:49/
// Author: MTsv DN
// Thanks: mdw

//***************************** Initializing themes **************************//
function InitThemes : boolean;
begin
 if ThemeLibrary <> 0 then begin
   Result:=True;
   exit;
 end;
 Result := false;
 ThemeLibrary := LoadLibrary(themelib);
 if ThemeLibrary > 0 then
  begin
   OpenThemeData := GetProcAddress(ThemeLibrary, 'OpenThemeData');
   DrawThemeBackground := GetProcAddress(ThemeLibrary, 'DrawThemeBackground');
   IsThemeBackgroundPartiallyTransparent := GetProcAddress(ThemeLibrary, 'IsThemeBackgroundPartiallyTransparent');
   DrawThemeParentBackground := GetProcAddress(ThemeLibrary, 'DrawThemeParentBackground');
   DrawThemeText := GetProcAddress(ThemeLibrary, 'DrawThemeText');
   CloseThemeData := GetProcAddress(ThemeLibrary, 'CloseThemeData');
   IsThemeActive := GetProcAddress(ThemeLibrary, 'IsThemeActive');
   IsAppThemed := GetProcAddress(ThemeLibrary, 'IsAppThemed');
   GetThemeColor := GetProcAddress(ThemeLibrary, 'GetThemeColor');
   Result := true;
  end;
end;
//***************************** Deinitializing themes ************************//
procedure DeinitThemes;
begin
 if ThemeLibrary > 0 then
  begin
   FreeLibrary(ThemeLibrary);
   ThemeLibrary := 0;
   OpenThemeData := nil;
   DrawThemeBackground := nil;
   IsThemeBackgroundPartiallyTransparent := nil;
   DrawThemeParentBackground := nil;
   CloseThemeData := nil;
   IsAppThemed := nil;
   IsThemeActive := nil;
   GetThemeColor := nil;
  end;
end;

function IsThemesAvailable: boolean;
begin
  Result:=ThemeLibrary > 0;
end;

function IsThemesEnabled: boolean;
begin
  Result:=IsThemesAvailable and IsThemeActive and IsAppThemed;
end;

function WndProc_ParentBackground( Self_: PControl; var Msg: TMsg; var Rslt: Integer ): Boolean;
var
  DC: HDC;
  f: HGDIOBJ;
begin
  with Self_^ do begin
    Result:=False;
    if not fParentBackground or not IsThemesEnabled then
      exit;
    case Msg.message of
      WM_ERASEBKGND:
        begin
          if fCommandActions.aChange = EN_CHANGE then begin
            DC := Msg.wParam;
            DrawThemeParentBackground(fHandle, DC, nil);
          end;
          Rslt := 1;
          Result:=True;
        end;
      CN_CTLCOLORMSGBOX..CN_CTLCOLORSTATIC:
        begin
          DC := Msg.wParam;
          f:=GetCurrentObject(DC, OBJ_FONT);
          DrawThemeParentBackground(fHandle, DC, nil);
          if f <> 0 then
            SelectObject(DC, f);
          SetTextColor(DC, Color2RGB(fTextColor));
          SetBkMode( DC, Windows.TRANSPARENT );
          Rslt := GetStockObject( NULL_BRUSH );
          Result := TRUE;
        end;
      WM_MOUSELEAVE:
        if fCommandActions.aChange = EN_CHANGE then
          Invalidate;
      WM_MOUSEFIRST..WM_MOUSELAST:
        if fCommandActions.aChange = EN_CHANGE then
          if not MouseInControl then
            Invalidate;
    end;
  end;  
end;

//********************************* End File *********************************//

