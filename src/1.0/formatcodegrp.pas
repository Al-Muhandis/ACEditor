unit FormatCodeGrp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls;

type

  { TGrpFormatCode }

  TGrpFormatCode = class(TCustomGroupBox)
  private
  public
    constructor Create(AOwner: TComponent; ALeft, ATop: Integer); virtual;
  end;
  
  { TGrpFCColor }

  TGrpFCColor = class(TGrpFormatCode)
  private
  public
    constructor Create(AOwner: TComponent; ALeft, ATop: Integer); override;
  end;

implementation

{ TGrpFormatCode }

constructor TGrpFormatCode.Create(AOwner: TComponent; ALeft, ATop: Integer);
begin
  inherited Create(AOwner);
  Left := ALeft + 5;
  Top :=  ATop + 5
end;

{ TGrpFCColor }

constructor TGrpFCColor.Create(AOwner: TComponent; ALeft, ATop: Integer);
begin
  inherited Create(AOwner, ALeft, ATop);
  
end;

end.

