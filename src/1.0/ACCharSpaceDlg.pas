unit ACCharSpaceDlg;

{$MODE Delphi}

interface

uses Classes, StdCtrls, Controls, Forms, LResources;

type
  TACCharSpaceDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Edit: TEdit;
    procedure FormCreate(Sender: TObject);
  private
    function GetCharSpace: Single;
    procedure SetCharSpace(const Value: Single);
  public
    function Execute: Boolean;
    property CharSpace: Single read GetCharSpace write SetCharSpace;
  end;

implementation


uses ACADTypes;

{ TACCharSpaceDialog }

function TACCharSpaceDialog.Execute: Boolean;
begin
  Result := (ShowModal = MrOk)
end;

procedure TACCharSpaceDialog.FormCreate(Sender: TObject);
begin
  CharSpace := 1
end;

function TACCharSpaceDialog.GetCharSpace: Single;
begin
  if not TryStringToFloat(Edit.Text, Result) then
    Result := 1
end;

procedure TACCharSpaceDialog.SetCharSpace(const Value: Single);
begin
  Edit.Text := FloatToString(Value)
end;

initialization
  {$i ACCharSpaceDlg.lrs}

end.
