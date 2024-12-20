unit ACAlignmentDlg;

interface

uses Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  ACADTypes, StdCtrls, ExtCtrls;

type

  { TACAlignmentDialog }

  TACAlignmentDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    RadioGroup: TRadioGroup;
    procedure FormCreate(Sender: TObject);    
  private
    function GetACADAlignment: TACAlignment;
    procedure SetACADAlignment(const Value: TACAlignment);
  public
    function Execute: Boolean;
    property ACADAlignment: TACAlignment read GetACADAlignment
      write SetACADAlignment;
  end;

implementation


{ TACAlignmentDialog }

function TACAlignmentDialog.GetACADAlignment: TACAlignment;
begin
  Result := TACAlignment(RadioGroup.ItemIndex)
end;

procedure TACAlignmentDialog.SetACADAlignment(const Value: TACAlignment);
begin
  RadioGroup.ItemIndex := Ord(Value)
end;

procedure TACAlignmentDialog.FormCreate(Sender: TObject);
begin
  ACADAlignment := alCenter
end;

function TACAlignmentDialog.Execute: Boolean;
begin
  Result := (ShowModal = mrOk)
end;

initialization
  {$i ACAlignmentDlg.lrs}

end.
