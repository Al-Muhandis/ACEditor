unit ACWidthDlg;

interface

uses Classes, StdCtrls, Controls, Forms, LResources;

type
  TACWidthDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Edit: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    function GetWidth: Single;
    procedure SetWidth(const Value: Single);
  public
    function Execute: Boolean;
    property Width: Single read GetWidth write SetWidth;
  end;

implementation


uses ACADTypes;

{ TACWidthDialog }

function TACWidthDialog.Execute: Boolean;
begin
  Result := (ShowModal = mrOk)
end;

procedure TACWidthDialog.FormCreate(Sender: TObject);
begin
  Width := 1
end;

function TACWidthDialog.GetWidth: Single;
begin
  if not TryStringToFloat(Edit.Text, Result) then
    Result := 1
end;

procedure TACWidthDialog.SetWidth(const Value: Single);
begin
  Edit.Text := FloatToString(Value)
end;

initialization
  {$i ACWidthDlg.lrs}

end.
