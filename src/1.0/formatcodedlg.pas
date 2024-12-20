unit FormatCodeDlg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin;

type

  { TDlgFormatCode }

  TDlgFormatCode = class(TForm)
    ComboBox1: TComboBox;
    GroupBox1: TGroupBox;
    SpinEdit1: TSpinEdit;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  DlgFormatCode: TDlgFormatCode;

implementation

initialization
  {$I formatcodedlg.lrs}

end.

