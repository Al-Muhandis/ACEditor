unit ACAngleDlg;

{$MODE Delphi}

interface

uses StdCtrls, Controls, Forms, Classes, LResources;

type
  TACObliquingDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Edit: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    function GetObliquing: Single;
    procedure SetObliquing(const Value: Single);
  public
    function Execute: Boolean;
    property Obliquing: Single read GetObliquing write SetObliquing;
  end;

implementation


uses ACADTypes;

{ TACObliquingDialog }

function TACObliquingDialog.Execute: Boolean;
begin
  Result := (ShowModal = mrOk)
end;

procedure TACObliquingDialog.FormCreate(Sender: TObject);
begin
  Obliquing := 15
end;

function TACObliquingDialog.GetObliquing: Single;
begin
  if not TryStringToFloat(Edit.Text, Result) then
    Result := 0
end;

procedure TACObliquingDialog.SetObliquing(const Value: Single);
begin
  Edit.Text := FloatToString(Value)
end;

initialization
  {$i ACAngleDlg.lrs}

end.
