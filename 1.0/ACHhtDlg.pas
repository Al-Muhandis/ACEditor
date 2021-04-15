unit ACHhtDlg;

interface

uses Forms, Controls, StdCtrls, ExtCtrls, Classes, ACADTypes, LResources;

type
  TACHeightDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel: TBevel;
    CheckBox: TCheckBox;
    ComboBox: TComboBox;
    procedure CheckBoxClick(Sender: TObject);
  private
    FAbsHeight: Single;
    FRelHeight: Single;
    FErrorCode: Integer;
    function GetACHeight: TACHeight;
    procedure SetACHeight(const Value: TACHeight);
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean;
    property ACHeight: TACHeight read GetACHeight write SetACHeight;
  end;

implementation


{ TACHeightDialog }

const
  ErrStr1 = 'Введите, пожалуйста, вещественное число';

constructor TACHeightDialog.Create(AOwner: TComponent);
var
  AnACHeight: TACHeight;
begin
  inherited Create(AOwner);
  FErrorCode := 0;
  FAbsHeight := 3.5;
  FRelHeight := 1;
  with AnACHeight do
  begin
    Height := FAbsHeight;
    DwgUnits := True
  end;
  ACHeight := AnACHeight
end;

function TACHeightDialog.GetACHeight: TACHeight;
begin
  if not TryStringToFloat(ComboBox.Text, Result.Height) then
    Result.Height := 0;
  Result.DwgUnits := not CheckBox.Checked
end;

procedure TACHeightDialog.SetACHeight(const Value: TACHeight);
begin
  ComboBox.Text := FloatToString(Value.Height);
  if Value.DwgUnits then
    FAbsHeight := Value.Height
  else
    FRelHeight := Value.Height;
  CheckBox.Checked := not Value.DwgUnits
end;

procedure TACHeightDialog.CheckBoxClick(Sender: TObject);
var
  AnACHeight: TACHeight;
begin
  with ComboBox do
    if TCheckBox(Sender).Checked then
    begin
      AutoComplete := False;
      Style := csSimple;
      TryStringToFloat(ComboBox.Text, FAbsHeight);
      AnACHeight.Height := FRelHeight;
      AnACHeight.DwgUnits := False;
      ACHeight := AnACHeight
    end
    else begin
      AutoComplete := True;
      Style := csDropDown;
      TryStringToFloat(ComboBox.Text, FRelHeight);
      AnACHeight.Height := FAbsHeight;
      AnACHeight.DwgUnits := True;
      ACHeight := AnACHeight
    end
end;

function TACHeightDialog.Execute: Boolean;
begin
  Result := (ShowModal = mrOk)
end;

initialization
  {$i ACHhtDlg.lrs}

end.
