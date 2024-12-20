{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
{$ifdef FPC} {$mode delphi} {$endif}
unit MainForm;

interface

uses Windows, Messages, KOL, KOLadd {place your units here->}, Cmn, ACAttributes
{$IFDEF LAZIDE_MCK}, Forms, mirror, Classes, Controls, mckCtrls, mckObjs, Graphics;
{$ELSE} ; {$ENDIF}

type

  { TFrm }

  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} TFrm = class; PFrm = TFrm; {$ELSE OBJECTS} PFrm = ^TFrm; {$ENDIF CLASSES/OBJECTS}
  TFrm = {$IFDEF KOLCLASSES}class{$ELSE}object{$ENDIF}({$IFDEF LAZIDE_MCK}TForm{$ELSE}TObj{$ENDIF})
    ActnSymbolsUnicode: TKOLAction;
    ActnSymbolsDiameter: TKOLAction;
    ActnSymbolsTolerance: TKOLAction;
    ActnSymbolsDegrees: TKOLAction;
    ActnSymbolsParEnd: TKOLAction;
    ActnSymbolsCloseBrace: TKOLAction;
    ActnSymbolsOpnBrace: TKOLAction;
    ActnSymbolsBackSlash: TKOLAction;
    ActnSymbolsNonBreakSpace: TKOLAction;
    ActnToolsOptions: TKOLAction;
    ActnEditSelectStrings: TKOLAction;
    ActnEditSelectAll: TKOLAction;
    ActnEditDelete: TKOLAction;
    ActnEditPaste: TKOLAction;
    ActnEditCopy: TKOLAction;
    ActnEditCut: TKOLAction;
    ActnEditUndo: TKOLAction;
    ActnFileCancel: TKOLAction;
    ActnFileSaveAs: TKOLAction;
    ActnFormatOverline: TKOLAction;
    ActnFormatUnderline: TKOLAction;
    ActnFormatHeight: TKOLAction;
    ActnFormatAlignment: TKOLAction;
    ActnFormatSpace: TKOLAction;
    ActnFormatOblique: TKOLAction;
    ActnFormatColor: TKOLAction;
    ActnFormatFree: TKOLAction;
    ActnFormatWidth: TKOLAction;
    ActnFormatStack: TKOLAction;
    ActnFormatFont: TKOLAction;
    ActnFileSave: TKOLAction;
    ActnFileOpen: TKOLAction;
    ActnLst: TKOLActionList;
    BtnOk: TKOLButton;
    BtnCancel: TKOLButton;
    Button1: TKOLButton;
    Form: PControl;
    KOLFrm: TKOLForm;
    KOLPrjct: TKOLProject;
    MnMn: TKOLMainMenu;
    Mm: TKOLMemo;
    OpnDlgText: TKOLOpenSaveDialog;
    SvDlgTextSaveAs: TKOLOpenSaveDialog;
    PnlBtns: TKOLPanel;
    PppMn: TKOLPopupMenu;
    procedure ActnEditUndoExecute(Sender: PObj);
    procedure ActnEditCopyExecute(Sender: PObj);
    procedure ActnEditCutExecute(Sender: PObj);
    procedure ActnEditDeleteExecute(Sender: PObj);
    procedure ActnEditPasteExecute(Sender: PObj);
    procedure ActnEditSelectAllExecute(Sender: PObj);
    procedure ActnFileCancelExecute(Sender: PObj);
    procedure ActnFileOpenExecute(Sender: PObj);
    procedure ActnFileSaveAsExecute(Sender: PObj);
    procedure ActnFileSaveExecute(Sender: PObj);
    procedure ActnFormatAlignmentExecute(Sender: PObj);
    procedure ActnFormatColorExecute(Sender: PObj);
    procedure ActnFormatFontExecute(Sender: PObj);
    procedure ActnFormatFreeExecute(Sender: PObj);
    procedure ActnFormatObliqueExecute(Sender: PObj);
    procedure ActnFormatOverlineExecute(Sender: PObj);
    procedure ActnFormatSpaceExecute(Sender: PObj);
    procedure ActnFormatStackExecute(Sender: PObj);
    procedure ActnFormatUnderlineExecute(Sender: PObj);
    procedure ActnFormatWidthExecute(Sender: PObj);
    procedure ActnSymbolsBackSlashExecute(Sender: PObj);
    procedure ActnSymbolsCloseBraceExecute(Sender: PObj);
    procedure ActnSymbolsDegreesExecute(Sender: PObj);
    procedure ActnSymbolsDiameterExecute(Sender: PObj);
    procedure ActnSymbolsNonBreakSpaceExecute(Sender: PObj);
    procedure ActnSymbolsOpnBraceExecute(Sender: PObj);
    procedure ActnSymbolsParEndExecute(Sender: PObj);
    procedure ActnSymbolsToleranceExecute(Sender: PObj);
    procedure ActnSymbolsUnicodeExecute(Sender: PObj);
    procedure ActnToolsOptionsExecute(Sender: PObj);
    procedure Button1Click(Sender: PObj);
    procedure KOLFrmClose(Sender: PObj; var Accept: Boolean);
    procedure KOLFrmFormCreate(Sender: PObj);
  private
    FAttr: TACAttributes;
    FCanUndo: Boolean;
    FDefaultACFont: String;
    FFileName: String;
    FOptionsTab: Integer;
    FSelectOnRun: Boolean;
    FStayOnCenter: Boolean;
    FTemplateDir: KOLString;
    FUndoBuffer, FUndoBuffer1: String;
    FUndoSelBuffer, FUndoSelBuffer1: TStringPos;
    procedure DoBufferring;
    procedure LoadOptions;
    procedure Profile(const AProfile: String; ToSave: Boolean);
    procedure LoadTextFromFile(const AFileName: String; out AText: String);
    procedure SaveOptions;
    procedure SaveTextToFile(const AFileName, AText: String);
    procedure SetDefaultACFont(const AValue: String);
    procedure SetOptionsTab(const AValue: Integer);
    procedure SetSelectOnRun(const AValue: Boolean);
    procedure SetStayOnCenter(const AValue: Boolean);
    procedure SetTemplateDir(const AValue: KOLString);
  public
    property DefaultACFont: String read FDefaultACFont write SetDefaultACFont;
    property OptionsTab: Integer read FOptionsTab write SetOptionsTab;
    property SelectOnRun: Boolean read FSelectOnRun write SetSelectOnRun;
    property StayOnCenter: Boolean read FStayOnCenter write SetStayOnCenter;
    property TemplateDir: KOLString read FTemplateDir write SetTemplateDir;
  end; 

var
  Frm {$IFDEF KOL_MCK} : PFrm {$ELSE} : TFrm {$ENDIF} ;

{$IFDEF KOL_MCK}
procedure NewFrm( var Result: PFrm; AParent: PControl );
{$ENDIF}

implementation

{$IFDEF KOL_MCK}
{$I mainform_1.inc}
{$ENDIF}

const
  BufSize = 127;

{ TFrm }

procedure TFrm.KOLFrmFormCreate(Sender: PObj);
var
  AText: String;
begin
  StayOnCenter := True;
  SelectOnRun := True;
  TemplateDir := GetStartDir + 'Templates';

  if ParamCount > 0 then
  begin
    FFileName := ParamStr(1);
    if FileExists(FFileName) then
    begin
      LoadTextFromFile(FFileName, AText);
      Mm.Text := AText
    end
    else
      FFileName := ''
  end
  else
    Mm.Text := MsgMustOpenFromCAD;
  FAttr := TACAttributes.Create(TKOLMemo(Mm));
  LoadOptions;
  if SelectOnRun then
    Mm.SelectAll
end;

procedure TFrm.DoBufferring;
begin
  FUndoBuffer := Mm.Text;
  FUndoSelBuffer.Start := Mm.SelStart;
  FUndoSelBuffer.Length := Mm.SelLength;
  FCanUndo := True
end;

procedure TFrm.LoadOptions;
begin
  Profile('Options', False)
end;

procedure TFrm.Profile(const AProfile: String; ToSave: Boolean);
var
  Ini: PIniFile;
begin
  Ini := OpenIniFile(GetStartDir + AProfile + '.ini');
  try
  begin
    if ToSave then
      Ini.Mode := ifmWrite;
    Ini.Section := IniSctView;
    Form.Top := Ini.ValueInteger('Top', Form.Top);
    Form.Left := Ini.ValueInteger('Left', Form.Left);
    Form.Height := Ini.ValueInteger('Height', Form.Height);
    Form.Width := Ini.ValueInteger('Width', Form.Width);
    Form.StayOnTop := Ini.ValueBoolean(IniStayOnTop, Form.StayOnTop);
    if Ini.ValueBoolean(IniStayOnCenter, StayOnCenter) then
      Form.CenterOnParent;
    Form.Transparent := Ini.ValueBoolean(IniBlend, Form.Transparent);
    Form.AlphaBlend := Ini.ValueInteger(IniBlendValue, Form.AlphaBlend);
    MnMn.Visible := Ini.ValueBoolean(IniMainMenu,  MnMn.Visible);
    Mm.Color := Ini.ValueInteger(IniBackground, Mm.Color);
    
    Ini.Section := IniSctComfort;
{    KBLayout := TKBLayout(ReadInteger(IniSctComfort, IniKB, Ord(kblRu)));}
    SelectOnRun := Ini.ValueBoolean(IniSelectOnStart, SelectOnRun);
    
    Ini.Section := IniSctFont;
    Mm.Font.FontCharset := Ini.ValueInteger(IniCharset, Mm.Font.FontCharset);
    Mm.Font.Color := Ini.ValueInteger(IniColor, Mm.Font.Color);
    Mm.Font.FontName := Ini.ValueString(IniName, Mm.Font.FontName);
    Mm.Font.FontHeight := Ini.ValueInteger(IniSize, Mm.Font.FontHeight);
    Mm.Font.FontStyle := TFontStyle(Integer(Ini.ValueInteger(
      IniStyle, Integer(Mm.Font.FontStyle))));

    Ini.Section := IniSctTemplate;
    TemplateDir := Ini.ValueString(IniPath, TemplateDir);
    
    Ini.Section := IniSctStack;
    with FAttr do
    begin
      StackHeightChange := Ini.ValueBoolean(IniChangeHeight,
        StackHeightChange);
      with StackTextHeight do
      begin
        DwgUnits := not Ini.ValueBoolean(IniRelativeHeight, not DwgUnits);
        Height := Str2Double(Ini.ValueString(IniHeight, '0,7'))
      end;
      StackAlignChange := Ini.ValueBoolean(IniChangeAlign,
        StackAlignChange);
      StackAlign := TACAlignment(Ini.ValueInteger(IniAlign,
        Ord(StackAlign)))
    end;
    
    Ini.Section := IniSctAutoCAD;
    DefaultFont := Ini.ValueString(IniFont, DefaultFont)
  end
  finally
    Ini.Free
  end
end;

procedure TFrm.ActnFileSaveExecute(Sender: PObj);
begin
  if FFileName <> '' then
    if FileExists(FFileName) then
      SaveTextToFile(FFileName, Mm.Text);
  Form.Close
end;

procedure TFrm.ActnFormatAlignmentExecute(Sender: PObj);
var
  AnAlignment: TACAlignment;
begin
  LoadLib;
  if TGetACAlignment(GetACADAlignment)(Form.Handle, AnAlignment) then
  begin
    DoBufferring;
    FAttr.Alignment := AnAlignment
  end
end;

procedure TFrm.ActnFormatColorExecute(Sender: PObj);
var
  AColor: Integer;
begin
  LoadLib;
  if TGetInteger(GetACADColor)(Form.Handle, AColor) then
  begin
    DoBufferring;
    FAttr.Color := AColor
  end
end;

procedure TFrm.ActnFormatFontExecute(Sender: PObj);
var
  AFont: TACFontName;
begin
  LoadLib;
  if TGetFontName(GetACADFont)(Form.Handle, AFont) then
  begin
    DoBufferring;
    FAttr.Font := AFont
  end
end;

procedure TFrm.ActnFormatFreeExecute(Sender: PObj);
begin
  DoBufferring;
  FAttr.ClearAllFormatting
end;

procedure TFrm.ActnFormatObliqueExecute(Sender: PObj);
var
  AObliquing: Single;
begin
  LoadLib;
  if TGetReal(GetACADObliquing)(Form.Handle, AObliquing) then
  begin
    DoBufferring;
    FAttr.Angle := AObliquing
  end
end;

procedure TFrm.ActnFormatOverlineExecute(Sender: PObj);
var
  AnOverline: Boolean;
begin
  LoadLib;
  if TGetBoolean(GetACADOverline)(Form.Handle, AnOverline) then
  begin
    DoBufferring;
    FAttr.Overline := AnOverline
  end
end;

procedure TFrm.ActnFormatSpaceExecute(Sender: PObj);
var
  ASpace: Single;
begin
  LoadLib;
  if TGetReal(GetACADCharSpace)(Form.Handle, ASpace) then
  begin
    DoBufferring;
    FAttr.CharSpace := ASpace
  end
end;

procedure TFrm.ActnFormatStackExecute(Sender: PObj);
var
  AHighText, ALowText: String;
  AStackType: TStackType;
begin
  LoadLib;
  with FAttr.StackText do
  begin
    Read;
    AStackType := StackType;
    SetString(AHighText, PChar(HighText), BufSize);
    SetString(ALowText, PChar(LowText), BufSize)
  end;
  if TGetStack(GetACADStack)(Form.Handle, PChar(AHighText), PChar(ALowText),
    BufSize-1, AStackType) then
    with FAttr, StackText do
    begin
      DoBufferring;
      HighText := PChar(AHighText);
      LowText := PChar(ALowText);
      StackType := AStackType;
      Write
    end
end;

procedure TFrm.ActnFormatUnderlineExecute(Sender: PObj);
var
  AnUnderline: Boolean;
begin
  LoadLib;
  if TGetBoolean(GetACADUnderline)(Form.Handle, AnUnderline) then
  begin
    DoBufferring;
    FAttr.Underline := AnUnderline
  end
end;

procedure TFrm.ActnFormatWidthExecute(Sender: PObj);
var
  ASymWidth: Single;
begin
  LoadLib;
  if TGetReal(GetACADWidthFactor)(Form.Handle, ASymWidth) then
  begin
    DoBufferring;
    FAttr.Width := ASymWidth
  end
end;

procedure TFrm.ActnSymbolsBackSlashExecute(Sender: PObj);
begin
  DoBufferring;
  FAttr.InsertBSCharStr(fcBackSlash)
end;

procedure TFrm.ActnSymbolsCloseBraceExecute(Sender: PObj);
begin
  DoBufferring;
  FAttr.InsertBSCharStr(fcClBrace)
end;

procedure TFrm.ActnSymbolsDegreesExecute(Sender: PObj);
begin
  DoBufferring;
  FAttr.InsertDPCharStr(dpDegrees)
end;

procedure TFrm.ActnSymbolsDiameterExecute(Sender: PObj);
begin
  DoBufferring;
  FAttr.InsertDPCharStr(dpDiameter)
end;

procedure TFrm.ActnSymbolsNonBreakSpaceExecute(Sender: PObj);
begin
  DoBufferring;
  FAttr.InsertBSCharStr(fcNBSpace)
end;

procedure TFrm.ActnSymbolsOpnBraceExecute(Sender: PObj);
begin
  DoBufferring;
  FAttr.InsertBSCharStr(fcOpBrace)
end;

procedure TFrm.ActnSymbolsParEndExecute(Sender: PObj);
begin
  DoBufferring;
  FAttr.InsertBSCharStr(fcEOParagraph)
end;

procedure TFrm.ActnSymbolsToleranceExecute(Sender: PObj);
begin
  DoBufferring;
  FAttr.InsertDPCharStr(dpTolerance)
end;

procedure TFrm.ActnSymbolsUnicodeExecute(Sender: PObj);
var
  ACUnicode: Word;
  AFontName: TACFontName;
begin
  LoadLib;
  AFontName := DefaultACFont;
  if TGetUnicode(GetACADUnicode)(Form.Handle, ACUnicode, AFontName) then
  with FAttr do
  begin
    UnicodeFontName := AFontName;
    InsertUnicode(ACUnicode)
  end
end;

procedure TFrm.ActnToolsOptionsExecute(Sender: PObj);
var
  ATab: Integer;
begin
  LoadLib;
  SaveOptions;
  ATab := OptionsTab;
  if TGetOptionsFile(GetOptionsFile)(Form.Handle, ATab) then
    LoadOptions;
  OptionsTab := ATab
end;

procedure TFrm.Button1Click(Sender: PObj);
begin
  LoadLib;
  TGetSample(GetSample)(Form.Handle);
end;

procedure TFrm.KOLFrmClose(Sender: PObj; var Accept: Boolean);
begin
  SaveOptions;
  FAttr.Free;
  CloseLib
end;

procedure TFrm.ActnFileCancelExecute(Sender: PObj);
begin
  Form.Close
end;

procedure TFrm.ActnEditUndoExecute(Sender: PObj);
begin
  if not Mm.CanUndo then
    if FCanUndo then
    begin
      FUndoBuffer1 := Mm.Text;
      FUndoSelBuffer1.Start := Mm.SelStart;
      FUndoSelBuffer1.Length := Mm.SelLength;
      Mm.Text := FUndoBuffer;
      Mm.SelStart := FUndoSelBuffer.Start;
      Mm.SelLength := FUndoSelBuffer.Length;
      FUndoBuffer := FUndoBuffer1;
      FUndoSelBuffer := FUndoSelBuffer1
    end
end;

procedure TFrm.ActnEditCopyExecute(Sender: PObj);
begin
  Text2Clipboard(Mm.Selection)
end;

procedure TFrm.ActnEditCutExecute(Sender: PObj);
begin
  Text2Clipboard(Mm.Selection);
  Mm.SelLength := 0
end;

procedure TFrm.ActnEditDeleteExecute(Sender: PObj);
begin
  Mm.Selection := ''
end;

procedure TFrm.ActnEditPasteExecute(Sender: PObj);
begin
  Mm.Selection := Clipboard2Text
end;

procedure TFrm.ActnEditSelectAllExecute(Sender: PObj);
begin
  Mm.SelectAll
end;

procedure TFrm.ActnFileOpenExecute(Sender: PObj);
var
  AText: String;
begin
  if OpnDlgText.Execute then
  begin
    LoadTextFromFile(OpnDlgText.Filename, AText);
    Mm.Text := AText
  end
end;

procedure TFrm.ActnFileSaveAsExecute(Sender: PObj);
begin
  if SvDlgTextSaveAs.Execute then
    SaveTextToFile(SvDlgTextSaveAs.Filename, Mm.Text)
end;

procedure TFrm.LoadTextFromFile(const AFileName: String; out AText: String);
var
  ATextFile: TextFile;
  S: String;
begin
  AText := '';
  AssignFile(ATextFile, AFileName);
  Reset(ATextFile);
  try
    Readln(ATextFile, S);
    AText := AText + S + #$0D#$0A
  finally
    CloseFile(ATextFile)
  end
end;

procedure TFrm.SaveOptions;
begin
  Profile('Options', True)
end;

procedure TFrm.SaveTextToFile(const AFileName, AText: String);
var
  ATextFile: TextFile;
begin
  AssignFile(ATextFile, AFileName);
  Rewrite(ATextFile);
  try
    Write(ATextFile, AText)
  finally
    CloseFile(ATextFile)
  end
end;

procedure TFrm.SetDefaultACFont(const AValue: String);
begin
  FDefaultACFont := AValue
end;

procedure TFrm.SetOptionsTab(const AValue: Integer);
begin
  if FOptionsTab=AValue then exit;
  FOptionsTab:=AValue;
end;

procedure TFrm.SetSelectOnRun(const AValue: Boolean);
begin
  if FSelectOnRun=AValue then exit;
  FSelectOnRun:=AValue;
end;

procedure TFrm.SetStayOnCenter(const AValue: Boolean);
begin
  if FStayOnCenter=AValue then exit;
  FStayOnCenter:=AValue;
end;

procedure TFrm.SetTemplateDir(const AValue: KOLString);
begin
  if FTemplateDir=AValue then exit;
  FTemplateDir:=AValue;
end;

initialization
{$IFNDEF KOL_MCK} {$I mainform.lrs} {$ENDIF}

end.

