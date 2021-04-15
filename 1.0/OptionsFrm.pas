unit OptionsFrm;

interface

uses
  LCLIntf, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ACADTypes, AutoCADObjects, LResources;

type
  TFrmOptions = class(TForm)
    PnlBtns: TPanel;
    BtnYes: TButton;
    PgCntrl: TPageControl;
    TbShtACAD: TTabSheet;
    BvlHeight: TBevel;
    BvlAlign: TBevel;
    BtnAlignment: TButton;
    ChckBxAlignment: TCheckBox;
    BtnFontHeight: TButton;
    ChckBxFontHeight: TCheckBox;
    LblHeight: TLabel;
    LblAlign: TLabel;
    GrpBxStack: TGroupBox;
    GrpBxACADFont: TGroupBox;
    TbShtEditor: TTabSheet;
    BtnFont: TButton;
    BtnBackground: TButton;
    LblPreview: TLabel;
    ChckBxAlphaBlend: TCheckBox;
    ChckBxOnTop: TCheckBox;
    ChckBxOnCenter: TCheckBox;
    UpDownAlphaBlend: TUpDown;
    EditAlphaBlend: TEdit;
    GrpBxView: TGroupBox;
    ChckBxSelectAtRun: TCheckBox;
    GrpBxTemplate: TGroupBox;
    ComboBoxImport: TComboBox;
    EdtDir: TEdit;
    BtnBrowse: TButton;
    LblInsert: TLabel;
    LblDirTitle: TLabel;
    GrpBxWindow: TGroupBox;
    GrpBxKeyboard: TGroupBox;
    ClrDlg: TColorDialog;
    FntDlg: TFontDialog;
    BtnCancel: TButton;
    BtnDefault: TButton;
    TbShtAbout: TTabSheet;
    Bvl: TBevel;
    MmAbout: TMemo;
    ChckBxMainMenu: TCheckBox;
    CmbBxKBLayout: TComboBox;
    LblKBLayout: TLabel;
    TbShtTools: TTabSheet;
    GrpBxEnumeration: TGroupBox;
    EdtEnumFormat: TEdit;
    LblFormat: TLabel;
    RdGrpEnumaration: TRadioGroup;
    procedure BtnAlignmentClick(Sender: TObject);
    procedure BtnBackgroundClick(Sender: TObject);
    procedure BtnBrowseClick(Sender: TObject);
    procedure BtnFontHeightClick(Sender: TObject);
    procedure ChckBxAlphaBlendClick(Sender: TObject);
    procedure ChckBxClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnFontClick(Sender: TObject);
    procedure BtnACFontClick(Sender: TObject);
    procedure BtnDefaultClick(Sender: TObject);
    procedure ToolsChange(Sender: TObject);
  private
    FACAlignment: TACAlignment;
    FModified: Boolean;
    FOptionsTools: TMemTools;
    FTextHeight: TACHeight;
    function GetStackAlign: TACAlignment;
    function GetStackAlignChange: Boolean;
    function GetStackHeightChange: Boolean;
    function GetStackTextHeight: TACHeight;
    procedure SetStackAlign(const Value: TACAlignment);
    procedure SetStackAlignChange(const Value: Boolean);
    procedure SetStackHeightChange(const Value: Boolean);
    procedure SetModified(const Value: Boolean);
    procedure SetStackTextHeight(const Value: TACHeight);
    function GetTemplateDir: String;
    procedure SetTemplateDir(const Value: String);
    function GetImportType: TImportType;
    procedure SetImportType(const Value: TImportType);
    function GetFont: TFont;
    procedure SetFont(const Value: TFont);
    function GetBackground: TColor;
    procedure SetBackground(const Value: TColor);
    function GetBlend: Boolean;
    function GetBlendValue: Byte;
    procedure SetBlend(const Value: Boolean);
    procedure SetBlendValue(const Value: Byte);
    function GetStayOnTop: Boolean;
    procedure SetStayOnTop(const Value: Boolean);
    function GetStayOnCenter: Boolean;
    procedure SetStayOnCenter(const Value: Boolean);
    function GetSelectOnStart: Boolean;
    procedure SetSelectOnStart(const Value: Boolean);
    procedure SetACFont(const Value: TACFontName);
    function GetACFont: TACFontName;
    function GetMainMenu: Boolean;
    procedure SetMainMenu(const Value: Boolean);
    function GetKeyboradLayout: TKBLayout;
    procedure SetKeyboradLayout(const Value: TKBLayout);
    function GetEnumFormat: String;
    procedure SetEnumFormat(const Value: String);
    procedure SetEnumType(const Value: TEnumType);
    function GetEnumType: TEnumType;
  public
    EdtACFont: TACADFontComboBox;
    procedure Apply;
    function Execute: Boolean;
    procedure LoadOptions;
    property Blend: Boolean read GetBlend write SetBlend;
    property BlendValue: Byte read GetBlendValue
      write SetBlendValue;
    property ACFont: TACFontName read GetACFont write SetACFont;
    property EnumFormat: String read GetEnumFormat write SetEnumFormat;
    property EnumType: TEnumType read GetEnumType write SetEnumType;
    property ViewFont: TFont read GetFont write SetFont;
    property Background: TColor read GetBackground
      write SetBackground;
    property SelectOnStart: Boolean read GetSelectOnStart
      write SetSelectOnStart;
    property StackHeightChange: Boolean read GetStackHeightChange
      write SetStackHeightChange;
    property StackTextHeight: TACHeight read GetStackTextHeight
      write SetStackTextHeight;
    property StackAlignChange: Boolean
      read GetStackAlignChange write SetStackAlignChange;
    property StackAlign: TACAlignment read GetStackAlign
      write SetStackAlign;
    property TemplateDir: String read GetTemplateDir
      write SetTemplateDir;
    property TemplateImport: TImportType read GetImportType
      write SetImportType;
    property StayOnTop: Boolean read GetStayOnTop
      write SetStayOnTop;
    property StayOnCenter: Boolean read GetStayOnCenter
      write SetStayOnCenter;
    property Modified: Boolean read FModified
      write SetModified;
    property MainMenu: Boolean read GetMainMenu write SetMainMenu;
    property KeyboradLayout: TKBLayout read GetKeyboradLayout
      write SetKeyboradLayout;
  end;

implementation

uses ACAlignmentDlg, ACHhtDlg, SysUtils, FileCtrl, ACTxtFrmt, IniFiles;


function TFrmOptions.GetStackAlign: TACAlignment;
begin
  Result := FACAlignment
end;

function TFrmOptions.GetStackAlignChange: Boolean;
begin
  Result := ChckBxAlignment.Checked
end;

function TFrmOptions.GetStackHeightChange: Boolean;
begin
  Result := ChckBxFontHeight.Checked
end;

function TFrmOptions.GetStackTextHeight: TACHeight;
begin
  Result := FTextHeight
end;

procedure TFrmOptions.SetStackAlign(const Value: TACAlignment);
begin
  FACAlignment := Value;
  LblAlign.Caption := ACAlignmentToString(Value)
end;

procedure TFrmOptions.SetStackAlignChange(const Value: Boolean);
begin
  ChckBxAlignment.Checked := Value;
  ChckBxClick(ChckBxAlignment)
end;

procedure TFrmOptions.SetStackHeightChange(const Value: Boolean);
begin
  ChckBxFontHeight.Checked := Value;
  ChckBxClick(ChckBxFontHeight)
end;

procedure TFrmOptions.SetModified(const Value: Boolean);
begin
  FModified := Value
end;

procedure TFrmOptions.SetStackTextHeight(const Value: TACHeight);
begin
  FTextHeight := Value;
  if Value.DwgUnits then
    LblHeight.Caption := FloatToStr(Value.Height)
      + ' ед. чертежа'
  else
    LblHeight.Caption := FloatToStrF(Value.Height * 100,
      ffFixed, 6, 0) + '% от текущей высоты'
end;

procedure TFrmOptions.BtnFontHeightClick(Sender: TObject);
begin
  with TACHeightDialog.Create(Application) do
  begin
    ACHeight := StackTextHeight;
    if ShowModal = mrOK then
      StackTextHeight := ACHeight;
    Free
  end
end;

procedure TFrmOptions.BtnAlignmentClick(Sender: TObject);
begin
  with TACAlignmentDialog.Create(Application) do
  begin
    ACADAlignment := StackAlign;
    if ShowModal = mrOK then
      StackAlign := ACADAlignment;
    Free
  end
end;

procedure TFrmOptions.FormCreate(Sender: TObject);
begin
  FOptionsTools := TMemTools.Create;
  EdtACFont := TACADFontComboBox.Create(GrpBxACADFont);
  with EdtACFont do
  begin
    Parent := GrpBxACADFont;
    Top := 20;
    Left := 20
  end;  
  LoadOptions;
  ChckBxAlphaBlendClick(ChckBxAlphaBlend);
  Modified := False
end;

procedure TFrmOptions.ChckBxClick(Sender: TObject);
var
  ABoolean: Boolean;
begin
  ABoolean := TCheckBox(Sender).Checked;
  if Sender = ChckBxFontHeight then
  begin
    BtnFontHeight.Enabled := ABoolean;
    LblHeight.Enabled := ABoolean
  end else
  begin
    BtnAlignment.Enabled := ABoolean;
    LblAlign.Enabled := ABoolean
  end
end;

procedure TFrmOptions.SetTemplateDir(const Value: String);
begin
  EdtDir.Text := Value
end;

procedure TFrmOptions.BtnBrowseClick(Sender: TObject);
var
  Directory: String;
begin
  Directory := TemplateDir;
  if SelectDirectory('Укажите папку с шаблонами', '', Directory) then
    TemplateDir := Directory
end;

function TFrmOptions.GetTemplateDir: String;
begin
  Result := EdtDir.Text
end;

function TFrmOptions.GetImportType: TImportType;
begin
  Result := TImportType(ComboBoxImport.ItemIndex)
end;

procedure TFrmOptions.SetImportType(const Value: TImportType);
begin
  ComboBoxImport.ItemIndex := Ord(Value)
end;

procedure TFrmOptions.BtnFontClick(Sender: TObject);
begin
  FntDlg.Font := ViewFont;
  if FntDlg.Execute then
    ViewFont := FntDlg.Font
end;

function TFrmOptions.GetFont: TFont;
begin
  Result := LblPreview.Font
end;

procedure TFrmOptions.SetFont(const Value: TFont);
begin
  LblPreview.Font := Value
end;

function TFrmOptions.GetBackground: TColor;
begin
  Result := LblPreview.Color
end;

procedure TFrmOptions.SetBackground(const Value: TColor);
begin
  LblPreview.Color := Value
end;

procedure TFrmOptions.BtnBackgroundClick(Sender: TObject);
begin
  ClrDlg.Color := Background;
  if ClrDlg.Execute then
    Background := ClrDlg.Color
end;

procedure TFrmOptions.ChckBxAlphaBlendClick(Sender: TObject);
var AChecked: Boolean;
begin
  AChecked := TCheckBox(Sender).Checked;
  EditAlphaBlend.Enabled := AChecked;
  UpDownAlphaBlend.Enabled := AChecked
end;

function TFrmOptions.GetBlend: Boolean;
begin
  Result := ChckBxAlphaBlend.Checked
end;

function TFrmOptions.GetBlendValue: Byte;
begin
  Result := UpDownAlphaBlend.Position
end;

procedure TFrmOptions.SetBlend(const Value: Boolean);
begin
  ChckBxAlphaBlend.Checked := Value
end;

procedure TFrmOptions.SetBlendValue(const Value: Byte);
begin
  UpDownAlphaBlend.Position := Value
end;

function TFrmOptions.GetStayOnTop: Boolean;
begin
  Result := ChckBxOnTop.Checked
end;

procedure TFrmOptions.SetStayOnTop(const Value: Boolean);
begin
  ChckBxOnTop.Checked := Value
end;

function TFrmOptions.GetStayOnCenter: Boolean;
begin
  Result := ChckBxOnCenter.Checked
end;

procedure TFrmOptions.SetStayOnCenter(const Value: Boolean);
begin
  ChckBxOnCenter.Checked := Value
end;

function TFrmOptions.Execute: Boolean;
begin
  Result := (ShowModal = mrYes);
  if Result then
    Apply
end;

function TFrmOptions.GetSelectOnStart: Boolean;
begin
  Result := ChckBxSelectAtRun.Checked
end;

procedure TFrmOptions.SetSelectOnStart(const Value: Boolean);
begin
  ChckBxSelectAtRun.Checked := Value
end;

procedure TFrmOptions.SetACFont(const Value: TACFontName);
begin
  if Value <> '' then
    EdtACFont.Text := Value
  else
    EdtACFont.Text := 'txt'
end;

function TFrmOptions.GetACFont: TACFontName;
begin
  Result := EdtACFont.Text
end;

procedure TFrmOptions.BtnACFontClick(Sender: TObject);
var
  AnACFont: TACFontName;
begin
  AnACFont := ACFont;
  if GetACADFont(Application.MainForm.Handle, AnACFont) then
    ACFont := AnACFont
end;

procedure TFrmOptions.Apply;
begin
  with TMemIniFile.Create(IniFileName) do
  begin
    WriteString(IniSctTemplate, IniPath, TemplateDir);
    WriteInteger(IniSctTemplate, IniImport, Ord(TemplateImport));
    WriteBool(IniSctStack, IniChangeHeight, StackHeightChange);
    WriteFloat(IniSctStack, IniHeight, StackTextHeight.Height);
    WriteBool(IniSctStack, IniRelativeHeight, not StackTextHeight.DwgUnits);
    WriteBool(IniSctStack, IniChangeAlign, StackAlignChange);
    WriteInteger(IniSctStack, IniAlign, Ord(StackAlign));
    with ViewFont do
    begin
      WriteInteger(IniSctFont, IniCharset, Charset);
      WriteInteger(IniSctFont, IniColor, Color);
      WriteString(IniSctFont, IniName, Name);
      WriteInteger(IniSctFont, IniSize, Size);
      WriteInteger(IniSctFont, IniStyle, Integer(Style))
    end;
    WriteInteger(IniSctView, IniBackground, Background);
    WriteBool(IniSctView, IniBlend, Blend);
    WriteInteger(IniSctView, IniBlendValue, BlendValue);
    WriteBool(IniSctView, IniStayOnTop, StayOnTop);
    WriteBool(IniSctView, IniStayOnCenter, StayOnCenter);
    WriteBool(IniSctComfort, IniSelectOnStart, SelectOnStart);
    WriteBool(IniSctView, IniMainMenu, MainMenu);
    WriteInteger(IniSctComfort, IniKB, Ord(KeyboradLayout));
    WriteString(IniSctAutoCAD, IniFont, ACFont);

    WriteString(IniSctNumeration, IniText, EnumFormat);
    WriteInteger(IniSctNumeration, IniType, Ord(EnumType));

    UpdateFile;
    Free
  end;
  with FOptionsTools.ToolsOptions do
  begin
    otEnumFormat := EnumFormat;
    otEnumType := EnumType
  end;
  FOptionsTools.Save;
  Modified := False
end;

procedure TFrmOptions.BtnDefaultClick(Sender: TObject);
begin
  if Application.MessageBox(
    PChar('Вы хотите сбросить настройки?'),
    PChar(Application.Title), 4) = 6 then
  begin
    if FileExists(IniFileName) then
      DeleteFile(IniFileName);
    LoadOptions
  end
end;

procedure TFrmOptions.LoadOptions;
var
  AACHeight: TACHeight;
begin
  with TMemIniFile.Create(IniFileName) do
  begin
    TemplateDir :=       ReadString(IniSctTemplate, IniPath, '.');
    TemplateImport :=    TImportType(ReadInteger(
      IniSctTemplate, IniImport, Ord(imInsertAtCur)));
    StackHeightChange := ReadBool(IniSctStack, IniChangeHeight, True);
    with AACHeight do
    begin
      Height :=   ReadFloat(IniSctStack, IniHeight, 0.75);
      DwgUnits := not ReadBool(IniSctStack, IniRelativeHeight, True)
    end;
    StackTextHeight := AACHeight;
    StackAlignChange :=  ReadBool(IniSctStack, IniChangeAlign, True);
    StackAlign :=        TACAlignment(ReadInteger(
      IniSctStack, IniAlign, Ord(alCenter)));
    with ViewFont do
    begin
      Charset := ReadInteger(IniSctFont, IniCharset, 1);
      Color :=   ReadInteger(IniSctFont, IniColor, clWindowText);
      Name :=    ReadString(IniSctFont, IniName, 'MS Sans Serif');
      Size :=    ReadInteger(IniSctFont, IniSize, 8);
      Style :=   TFontStyles(Integer(ReadInteger(IniSctFont, IniStyle, 0)))
    end;
    Background :=     ReadInteger(IniSctView, IniBackground, clWindow);
    Blend :=          ReadBool(IniSctView, IniBlend, False);
    BlendValue :=     ReadInteger(IniSctView, IniBlendValue, 220);
    StayOnTop :=      ReadBool(IniSctView, IniStayOnTop, True);
    StayOnCenter :=   ReadBool(IniSctView, IniStayOnCenter, False);
    SelectOnStart :=  ReadBool(IniSctComfort, IniSelectOnStart, True);
    MainMenu :=       ReadBool(IniSctView, IniMainMenu, True);
    KeyboradLayout := TKBLayout(ReadInteger(IniSctComfort, IniKB, Ord(kblRu)));
    ACFont :=         ReadString(IniSctAutoCAD, IniFont, 'txt');

    EnumFormat :=     ReadString(IniSctNumeration, IniText, EnumFormat);
    EnumType :=       TEnumType(ReadInteger(
      IniSctNumeration, IniType, Ord(EnumType)));

    Free
  end;
  FOptionsTools.Load;
  with FOptionsTools.ToolsOptions do
  begin
    EnumFormat := otEnumFormat;
    EnumType := otEnumType
  end
end;

function TFrmOptions.GetMainMenu: Boolean;
begin
  Result := ChckBxMainMenu.Checked
end;

procedure TFrmOptions.SetMainMenu(const Value: Boolean);
begin
  ChckBxMainMenu.Checked := Value
end;

function TFrmOptions.GetKeyboradLayout: TKBLayout;
begin
  Result := TKBLayout(CmbBxKBLayout.ItemIndex)
end;

procedure TFrmOptions.SetKeyboradLayout(const Value: TKBLayout);
begin
  CmbBxKBLayout.ItemIndex := Ord(Value)
end;

function TFrmOptions.GetEnumFormat: String;
begin
  Result := '"' + EdtEnumFormat.Text + '"'
end;

procedure TFrmOptions.SetEnumFormat(const Value: String);
begin
  EdtEnumFormat.Text := AnsiDequotedStr(Value, '"')
end;

procedure TFrmOptions.SetEnumType(const Value: TEnumType);
begin
  RdGrpEnumaration.ItemIndex := Ord(Value)
end;

function TFrmOptions.GetEnumType: TEnumType;
begin
  Result := TEnumType(RdGrpEnumaration.ItemIndex)
end;

procedure TFrmOptions.ToolsChange(Sender: TObject);
begin
  FOptionsTools.Modified := True
end;

initialization
  {$i OptionsFrm.lrs}

end.
