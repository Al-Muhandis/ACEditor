unit ACColorDlg;

interface

uses Forms, ExtCtrls, ComCtrls, Classes, Controls, StdCtrls, ACADTypes,
  LResources;

type
  TACColorDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel: TBevel;
    ComboBox: TComboBox;
    Edit: TEdit;
    UpDown: TUpDown;
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
  private
    function GetACADColor: TACColor;
    procedure SetACADColor(const Value: TACColor);
  public
    function Execute: Boolean;
    property ACADColor: TACColor read GetACADColor write SetACADColor;
  end;

implementation


const
  ACColorList: array [0..7] of String = ('По слою', 'Красный', 'Желтый', 'Зеленый',
    'Голубой', 'Синий', 'Пурпурный', 'Черный|белый');

procedure TACColorDialog.FormCreate(Sender: TObject);
var
  i: Byte;
begin
  for i := Low(ACColorList) to High(ACColorList) do
     ComboBox.Items.Append(ACColorList[i]);
  ACADColor := 7
end;

function TACColorDialog.GetACADColor: TACColor;
begin
  Result := TACColor(UpDown.Position)
end;

procedure TACColorDialog.SetACADColor(const Value: TACColor);
begin
  UpDown.Position := Value;
  if Value < 8 then
    ComboBox.ItemIndex := Value
  else
    ComboBox.ItemIndex := -1
end;

procedure TACColorDialog.ComboBoxChange(Sender: TObject);
begin
  if not (ComboBox.ItemIndex = -1) then
    ACADColor := ComboBox.ItemIndex
end;

procedure TACColorDialog.UpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  ACADColor := UpDown.Position
end;

function TACColorDialog.Execute: Boolean;
begin
  Result := (ShowModal = mrOk)
end;

initialization
  {$i ACColorDlg.lrs}

end.
