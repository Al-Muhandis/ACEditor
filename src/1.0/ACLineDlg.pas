unit ACLineDlg;

interface

uses Classes, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, LResources;

type
  TACLineDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    RadioGroup: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    FIsOverline: Boolean;
    function GetIsOverline: Boolean;
    function GetIsUnderline: Boolean;
    function GetSetOn: Boolean;
    procedure InitLineDlg;
    procedure SetIsOverline(const Value: Boolean);
    procedure SetIsUnderline(const Value: Boolean);
    procedure SetSetOn(const Value: Boolean);
  public
    function Execute: Boolean;
    property IsOverline: Boolean read GetIsOverline
      write SetIsOverline;
    property IsUnderline: Boolean read GetIsUnderline
      write SetIsUnderline;
    property SetOn: Boolean read GetSetOn write SetSetOn;
  end;

implementation


{ TACLineDialog }

const
  LineCaption: array[Boolean] of string[20] = ('Подчеркивание',
    'Надчеркивание');

function TACLineDialog.GetIsOverline: Boolean;
begin
  Result := FIsOverline
end;

function TACLineDialog.GetIsUnderline: Boolean;
begin
  Result := not FIsOverline
end;

function TACLineDialog.GetSetOn: Boolean;
begin
  Result := not Boolean(RadioGroup.ItemIndex)
end;

procedure TACLineDialog.SetIsOverline(const Value: Boolean);
begin
  FIsOverline := Value;
  InitLineDlg
end;

procedure TACLineDialog.SetIsUnderline(const Value: Boolean);
begin
  IsOverline := not Value 
end;

procedure TACLineDialog.SetSetOn(const Value: Boolean);
begin
  RadioGroup.ItemIndex := Ord(not Value)
end;

procedure TACLineDialog.FormCreate(Sender: TObject);
begin
  IsOverline := False;
  SetOn := True
end;

procedure TACLineDialog.InitLineDlg;
begin
  Caption := LineCaption[IsOverline]
end;

function TACLineDialog.Execute: Boolean;
begin
  Result := (ShowModal = mrOK)
end;

initialization
  {$i ACLineDlg.lrs}

end.
