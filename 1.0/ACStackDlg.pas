unit ACStackDlg;


interface

uses LCLIntf, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ACADTypes, LResources;

type
  TACStackDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel: TBevel;
    EditHigh: TEdit;
    EditLow: TEdit;
    ComboBox: TComboBox;
    procedure FormCreate(Sender: TObject);
  private
    function GetStackType: TStackType;
    procedure SetHighText(const Value: String);
    procedure SetLowText(const Value: String);
    procedure SetStackType(const Value: TStackType);
    function GetHighText: String;
    function GetLowText: String;
  public
    function Execute: Boolean;
    property HighText: String read GetHighText write SetHighText;
    property LowText: String read GetLowText write SetLowText;
    property StackType: TStackType read GetStackType write
      SetStackType;
  end;

implementation

{ TACStackDialog }

function TACStackDialog.GetHighText: String;
begin
  Result := EditHigh.Text
end;

function TACStackDialog.GetLowText: String;
begin
  Result := EditLow.Text 
end;

function TACStackDialog.GetStackType: TStackType;
begin
  Result := TStackType(ComboBox.ItemIndex)
end;

procedure TACStackDialog.SetHighText(const Value: String);
begin
  EditHigh.Text := Value
end;

procedure TACStackDialog.SetLowText(const Value: String);
begin
  EditLow.Text := Value
end;

procedure TACStackDialog.SetStackType(const Value: TStackType);
begin
  ComboBox.ItemIndex := Ord(Value)
end;

procedure TACStackDialog.FormCreate(Sender: TObject);
begin
  StackType := stHorFraction
end;

function TACStackDialog.Execute: Boolean;
begin
  Result := (ShowModal = MrOk)
end;

initialization
  {$i ACStackDlg.lrs}

end.
