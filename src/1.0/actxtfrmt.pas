unit ACTxtFrmt;

{$mode objfpc}{$H+}

interface

uses ACADTypes;

function GetACADAlignment(AHandle: THandle; var AnAlignment: TACAlignment): Boolean;
function GetACADCharSpace(AHandle: THandle; var ACharSpace: Single): Boolean;
function GetACADColor(AHandle: THandle; var AnACADColor: TACColor): Boolean;
function GetACADFont(AHandle: THandle; var AFontName: TACFontName): Boolean;
function GetACADFontHeight(AHandle: THandle; var AnACHeight: TACHeight): Boolean;
function GetACADObliquing(AHandle: THandle; var AnObliquing: Single): Boolean;
function GetACADOverline(AHandle: THandle; var AOverline: Boolean): Boolean;
function GetACADStack(AHandle: THandle; const AHighText, ALowText: PChar;
  const TextBufSize: Integer; var AStackType: TStackType):
  Boolean;
function GetACADUnderline(AHandle: THandle; var AUnderline: Boolean): Boolean;
function GetACADUnicode(AHandle: THandle; var AnUnicode: Word;
  var AFontName: TACFontName): Boolean;
function GetACADWidthFactor(AHandle: THandle; var AFactor: Single): Boolean;
function GetOptionsFile(AHandle: THandle; var ATab: Integer): Boolean;
function GetPath(AHandle: THandle; var ATemplateDir: ShortString): Boolean;
function GetFileSaveName(AHandle: THandle; const AFileName, DlgTitle,
  InitialPath: PChar; BufSize: Cardinal): Boolean;
function GetFileOpenName(AHandle: THandle; const AFileName, DlgTitle,
  InitialPath: PChar; BufSize: Cardinal): Boolean;
procedure GetSample(AHandle: THandle);
  
implementation

uses
  Forms, Controls, Dialogs, ACAlignmentDlg, ACAngleDlg, OptionsFrm,
  ACCharSpaceDlg, ACColorDlg, ACFontDlg, ACHhtDlg, ACLineDlg,
  ACStackDlg, ACUnicodeDlg, ACWidthDlg, FileCtrl, Classes, ComCtrls;

function GetACADAlignment(AHandle: THandle; var AnAlignment: TACAlignment): Boolean;
begin
  Application.MainForm.Handle := AHandle;
  with TACAlignmentDialog.Create(Application) do
  begin
    ACADAlignment := AnAlignment;
    Result := Execute;
    if Result then
      AnAlignment := ACADAlignment;
    Free
  end
end;

function GetACADColor(AHandle: THandle; var AnACADColor: TACColor): Boolean;
var
  ACDialog: TACColorDialog;
begin
  Application.CreateForm(TACColorDialog, ACDialog);
  ACDialog.Parent.Handle := AHandle;
  with ACDialog do
  begin
    ACADColor := AnACADColor;
    Result := Execute;
    if Result then
      AnACADColor := ACADColor;
    Free
  end
end;

function GetACADFont(AHandle: THandle; var AFontName: TACFontName): Boolean;
begin
  Application.MainForm.Handle := AHandle;
  with TACFontDialog.Create(Application) do
  begin
    FontName := AFontName;
    Result := Execute;
    if Result then
      AFontName := FontName;
    Free
  end
end;

function GetACADFontHeight(AHandle: THandle; var AnACHeight: TACHeight): Boolean;
begin
  Application.MainForm.Handle := AHandle;
  with TACHeightDialog.Create(Application) do
  begin
    ACHeight := AnACHeight;
    Result := Execute;
    if Result then
      AnACHeight := ACHeight;
    Free
  end
end;

function GetACADObliquing(AHandle: THandle; var AnObliquing: Single): Boolean;
begin
  Application.MainForm.Handle := AHandle;
  with TACObliquingDialog.Create(Application) do
  begin
    Obliquing := AnObliquing;
    Result := Execute;
    if Result then
      AnObliquing := Obliquing;
    Free
  end
end;

function GetACADStack(AHandle: THandle; const AHighText, ALowText: PChar;
  const TextBufSize: Integer; var AStackType: TStackType):
  Boolean;
begin
  Application.MainForm.Handle := AHandle;
  with TACStackDialog.Create(Application) do
  begin
    HighText := AHighText;
    LowText := ALowText;
    StackType := AStackType;
    Result := Execute;
    if Result then
    begin
      AStackType := StackType;
      if not (Length(HighText) < TextBufSize - 1) then
        HighText := Copy(HighText, 1, TextBufSize - 1);
      if not (Length(LowText) < TextBufSize - 1) then
        LowText := Copy(LowText, 1, TextBufSize - 1);
      Move(PChar(HighText)^, AHighText^, Length(HighText) + 1);
      Move(PChar(LowText)^, ALowText^, Length(LowText) + 1)
    end;
    Free
  end
end;

function GetACADOverline(AHandle: THandle; var AOverline: Boolean): Boolean;
begin
  Application.MainForm.Handle := AHandle;
  with TACLineDialog.Create(Application) do
  begin
    Hint := '¬ключить/выключить надчеркивание';
    IsOverline := True;
    Result := Execute;
    if Result then
      AOverline := SetOn;
    Free
  end
end;

function GetACADUnderline(AHandle: THandle; var AUnderline: Boolean): Boolean;
begin
  Application.MainForm.Handle := AHandle;
  with TACLineDialog.Create(Application) do
  begin
    Hint := '¬ключить/выключить подчеркивание';
    IsUnderline := True;
    Result := Execute;
    if Result then
      AUnderline := SetOn;
    Free
  end
end;

function GetACADUnicode(AHandle: THandle; var AnUnicode: Word;
  var AFontName: TACFontName): Boolean;
begin
  Application.MainForm.Handle := AHandle;
  with TACUnicodeDialog.Create(Application) do
  begin
    ACFont := AFontName;
    Result := Execute;
    ACUnicode := AnUnicode;
    if Result then
    begin
      if AddFontName then
        AFontName := ACFont
      else
        AFontName := '';
      AnUnicode := ACUnicode
    end;
    Free
  end
end;

function GetACADWidthFactor(AHandle: THandle; var AFactor: Single): Boolean;
begin
  Application.MainForm.Handle := AHandle;
  with TACWidthDialog.Create(Application) do
  begin
    Width := AFactor;
    Result := Execute;
    if Result then
      AFactor :=  Width;
    Free
  end
end;


function GetOptionsFile(AHandle: THandle; var ATab: Integer): Boolean;
begin
  Application.MainForm.Handle := AHandle;
  with TFrmOptions.Create(Application) do
  begin
    PgCntrl.TabIndex := PgCntrl.PageCount - 1;
    Result := Execute;
    if Result then
      ATab := PgCntrl.TabIndex;
    Free
  end
end;

function GetPath(AHandle: THandle; var ATemplateDir: ShortString): Boolean;
begin

end;

function GetFileSaveName(AHandle: THandle; const AFileName, DlgTitle,
  InitialPath: PChar; BufSize: Cardinal): Boolean;
begin

end;

function GetFileOpenName(AHandle: THandle; const AFileName, DlgTitle,
  InitialPath: PChar; BufSize: Cardinal): Boolean;
begin

end;

procedure GetSample(AHandle: THandle);
var
  F: TextFile;
begin
  AssignFile(F, 'D:/sample.txt');
  Rewrite(F);
  Writeln(F, 'sample!');
  CloseFile(F)
end;

function GetACADCharSpace(AHandle: THandle; var ACharSpace: Single): Boolean;
begin
  Application.MainForm.Handle := AHandle;
  with TACCharSpaceDialog.Create(Application) do
  begin
    CharSpace := ACharSpace;
    Result := Execute;
    if Result then
      ACharSpace := CharSpace;
    Free
  end
end;

end.

