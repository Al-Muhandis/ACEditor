unit ACFontDlg;

interface

uses Forms, Controls, StdCtrls, ExtCtrls, Classes, ACADTypes, AutoCADObjects,
  LResources;

type
  TACFontDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel: TBevel;
    CheckBox: TCheckBox;
    procedure CheckBoxClick(Sender: TObject);
  private
    FComboBox: TACADFontComboBox;
    function GetFont: String;
    procedure SetFont(const Value: String);
    function GetOnlyShape: Boolean;
    procedure SetOnlyShape(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    function ACFontPath: String;
    function Execute: Boolean;    
    property FontName: String read GetFont write SetFont;
    property OnlyShape: Boolean read GetOnlyShape
      write SetOnlyShape;
  end;

implementation                         

uses SysUtils, LCLIntf, Registry;


{ TACFontDialog }

const
  WinFontsKey =
    'Software\Microsoft\Shared Tools\Panose';

constructor TACFontDialog.Create(AOwner: TComponent);
begin
  inherited;
  FComboBox := TACADFontComboBox.Create(Self);
  with FComboBox do
  begin
    Parent := Self;
    Top := 20;
    Left := 20
  end;
  OnlyShape := True;
  FontName := 'txt'
end;

function TACFontDialog.GetFont: String;
begin
  Result := FComboBox.FontName
end;

procedure TACFontDialog.SetFont(const Value: String);
begin
  if Value = '' then
    FComboBox.FontName := 'txt'
  else
    FComboBox.FontName := Value
end;

function TACFontDialog.GetOnlyShape: Boolean;
begin
  Result := not CheckBox.Enabled
end;

procedure TACFontDialog.SetOnlyShape(const Value: Boolean);
begin
  CheckBox.Checked := True;
  FComboBox.OnlyShape := Value
end;

function TACFontDialog.ACFontPath: String;
begin
  Result := FComboBox.ACFontPath
end;

function TACFontDialog.Execute: Boolean;
begin
  Result := (ShowModal = mrOk)
end;

procedure TACFontDialog.CheckBoxClick(Sender: TObject);
begin
  FComboBox.OnlyShape := CheckBox.Checked
end;

initialization
  {$i ACFontDlg.lrs}

end.
