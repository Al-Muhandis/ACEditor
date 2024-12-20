{$DEFINE KOL_MCK}
{$ifdef FPC} {$mode delphi} {$endif}
unit ACAttributes;

interface

uses Windows, KOL, KOLadd {place your units here->}, Cmn
{$IFDEF LAZIDE_MCK}, Forms, mirror, Classes, Controls, mckCtrls, mckObjs, Graphics;
{$ELSE} ; {$ENDIF}

{  Коды ошибок ErrorCode:
$000100  Неправильный код цвета текста
$000200  Неправильный код высоты текста
$000300  Неправильный код выравнивания строк текста
$000400  Неправильный код угла наклона шрифта
$000500  Неправильный межсимвольный интервал
$000600  Неправильный код ширины символов

$010000  Неудачная попытка распознования формата
$020000  Неудачная попытка распознования кода %%
$030000  Нераспознано целое число
$040000  Нераспознано вещественное число
}

type
  TACAttributes = class;

  TStrInd = packed record
    Start: Integer;
    Len: Integer;
    TextPos: Integer;
  end;

  TStackText = class
  private
    FACAttributes: TACAttributes;
    FACADMemo: PControl;
    FHighText: String;
    FLowText: String;
    FStackType: TStackType;
    function GetStackType: TStackType;
  public
    constructor Create(AOwner: TACAttributes);
    procedure Read;
    procedure Write;
    property HighText: String read FHighText write FHighText;
    property LowText: String read FLowText write FLowText;
    property StackType: TStackType read GetStackType
      write FStackType;
  end;

  TACAttributes = class
  private
    FACADMemo: PControl;
    FUnicodeFontName: TACFontName;
    FACFormat: TACFormat;
    FErrPos: Integer;
    FFormatCharsSet: TCharSetList;
    FOnError: TErrorEvent;
    FStackText: TStackText;
    FStackHeightChange: Boolean;
    FStackTextHeight: TACHeight;
    FStackAlignChange: Boolean;
    FStackAlign: TACAlignment;
    function CharFromIndex(const AIndex: Integer): Char;
    function CharToFormatCode(AChar: Char): TFormatCode;
    function DetectFormatStrLen(const APosition: Integer): Integer;
    procedure DoErrorProc(const ErrorCode: Integer);
    function FloatToStr(Value: Single): String;
    function FormatCodeToTextFormat(
      AFormatCode: TFormatCode): TACTextFormat;
    function FormatStrLen(AFormatCode: TFormatCode;
      const APosition: Integer): Integer;
    function GetACTextFormat: TACFormat;
    function GetAlignment: TACAlignment;
    function GetAlignedAtFirst: Boolean;
    function GetAngle: Single;
    function GetCharSpace: Single;
    function GetColor: TACColor;
    function GetConsistentFormat: TSetACTextFormat;
    function GetDefaultFormat: TSetACTextFormat;
    function GetFont: String;
    function GetHeight: TACHeight;
    function GetOverline: Boolean;
    function GetStack: TStack;
    procedure GetStackText(var UpText, DownText: String;
      var AStackType: TStackType);
    function GetUnderline: Boolean;
    function GetUnicodeFontName: String;
    function GetWidth: Single;
    procedure ScanForFormatText(const AText: PChar);
    procedure SetACTextFormat(const Value: TACFormat);
    procedure SetAlignment(const Value: TACAlignment);
    procedure SetAngle(const Value: Single);
    procedure SetCharSpace(const Value: Single);
    procedure SetColor(const Value: TACColor);
    procedure SetConsistentFormat(const Value: TSetACTextFormat);
    procedure SetDefaultFormat(const Value: TSetACTextFormat);
    procedure SetFont(const Value: String);
    procedure SetHeight(const Value: TACHeight);
    procedure SetOverline(const Value: Boolean);
    procedure SetSymbol(const Value: TFormatCode);
    procedure SetUnderline(const Value: Boolean);
    procedure SetWidth(const Value: Single);
    procedure SetUnicodeFontName(const Value: String);

    function TryStrToFloat(const S: string;
      out Value: Single): Boolean;

    function TxtChar(APos: Integer): Char;
    function TxtCodeDPProc(APos: Integer): TDPCharType;
    function TxtExtractFloat(AStart: Integer): Single;
    function TxtExtractInt(AStart: Integer): Integer;
    function TxtExtractStr(AStart: Integer;
      ALength: Integer): String; overload;
    function TxtExtractStr(AStart: Integer): String; overload;
    function TxtLength: Integer;
    function TxtPos(StartPos: Integer; AChar: Char): Integer;
    function TxtPosEx(StartPos: Integer;
      const AChars: array of Char; var AnIndex: Byte): Integer;
    function TxtPtr(APos: Integer): PChar;
  protected
    function DPCharStr(DPCharType: TDPCharType): String;
    function FCAlignmentStr(AnAlignment: TACAlignment): String;
    function FCCharPrefix(FormatCode: TFormatCode): String;
    function FCCharSpaceStr(ACharSpace: Single):  String;
    function FCColorStr(ACColor: TACColor): String;
    function FCFontCode(const FontStr: String): TACFontName;
    function FCFontStr(const FileName: TACFontName): String;
    function FCHeightStr(const AHeight: TACHeight): String;
    function FCObliquingStr(const AObliquing: Single): String;
    function FCOverlineStr(const AOverline: Boolean): String;
    function FCStackTextStr(const UpText,
      LowText: String; StackType: TStackType): String;
    function FCUnderlineStr(const AOverline: Boolean): String;
    function FCUnicodeStr(const AnUnicodeChar: Word): String;
    function FCWidthStr(const AWidth:  Single): String;
  public
    constructor Create(AOwner: PControl); virtual;
    procedure ClearAllFormatting;
    procedure InsertBSCharStr(BSCharStr: TFormatCode);
    procedure InsertDPCharStr(DPCharType: TDPCharType);
    procedure InsertStackText(const HighText, LowText: String;
      AStackType: TStackType);
    procedure InsertUnicode(const AnUnicodeChar: Word);
    property Angle: Single read GetAngle write SetAngle;
    property Alignment: TACAlignment read GetAlignment
      write SetAlignment;
    property AlignedAtFirst: Boolean read GetAlignedAtFirst;
    property ACTextFormat: TACFormat read GetACTextFormat
      write SetACTextFormat;
    property CharSpace: Single read GetCharSpace write SetCharSpace;
    property Color: TACColor read GetColor write SetColor;
    property ConsistentFormat: TSetACTextFormat
      read GetConsistentFormat write SetConsistentFormat;
    property DefaultFormat: TSetACTextFormat
      read GetDefaultFormat write SetDefaultFormat;
    property Font: String read GetFont write SetFont;
    property Height: TACHeight read GetHeight write SetHeight;
    property OnError: TErrorEvent read FOnError write FOnError;
    property Overline: Boolean read GetOverline write SetOverline;
    property Stack: TStack read GetStack;
    property StackHeightChange: Boolean read FStackHeightChange
      write FStackHeightChange;
    property StackText: TStackText read FStackText;
    property StackTextHeight: TACHeight read FStackTextHeight
      write FStackTextHeight;
    property StackAlignChange: Boolean read FStackAlignChange
      write FStackAlignChange;
    property StackAlign: TACAlignment read FStackAlign
      write FStackAlign;
    property Underline: Boolean read GetUnderline write SetUnderline;
    property UnicodeFontName: String read GetUnicodeFontName
      write SetUnicodeFontName;
    property Width: Single read GetWidth write SetWidth;
  end;

implementation

{ TACAttributes }

function TACAttributes.DPCharStr(DPCharType: TDPCharType): String;
begin
  Result := DoublePercent + DPCharacters[DPCharType]
end;

function TACAttributes.FCCharPrefix(FormatCode: TFormatCode): String;
begin
  Result := BackSlash + FCCharacters[FormatCode]
end;

function TACAttributes.FCColorStr(ACColor: TACColor): String;
begin
  Result := FCCharPrefix(fcColor) + Int2Str(ACColor) + FCEnd
end;

function TACAttributes.FCFontStr(const FileName: TACFontName): String;
begin
  Result := FCCharPrefix(fcFontName) + ChangeFileExt(FileName, '')
    + FCEnd
end;

function TACAttributes.FCHeightStr(const AHeight: TACHeight): String;
var
  BStr: String[1];
begin
  if not AHeight.DwgUnits then
    BStr := MultipleSign
  else
    BStr := '';
  Result := FCCharPrefix(fcHeight) +
    FloatToStr(AHeight.Height) + BStr + FCEnd
end;

function TACAttributes.FCStackTextStr(const UpText, LowText: String;
  StackType: TStackType): String;
begin
  Result := FCCharPrefix(fcStack) +
    UpText + STCharacters[StackType] + LowText + FCEnd
end;

procedure TACAttributes.InsertDPCharStr(DPCharType: TDPCharType);
begin
  FACADMemo.Selection := DPCharStr(DPCharType)
end;

function TACAttributes.FCObliquingStr(const AObliquing: Single): String;
begin
  Result := FCCharPrefix(fcAngle) + FloatToStr(AObliquing)
    + FCEnd
end;

function TACAttributes.FCAlignmentStr(AnAlignment: TACAlignment): String;
begin
  Result := FCCharPrefix(fcAlignment) + Int2Str(Ord(AnAlignment)) + FCEnd
end;

procedure TACAttributes.InsertBSCharStr(BSCharStr: TFormatCode);
begin
  SetSymbol(BSCharStr)
end;

function TACAttributes.FCCharSpaceStr(ACharSpace: Single): String;
begin
  Result := FCCharPrefix(fcCharSpace) +
    FloatToStr(ACharSpace) + FCEnd
end;

function TACAttributes.FCOverlineStr(const AOverline: Boolean): String;
var
  AFormatCode: TFormatCode;
begin
  if AOverline then
    AFormatCode := fcOverlineOn
  else
    AFormatCode := fcOverlineOff;
  Result := FCCharPrefix(AFormatCode)
end;

function TACAttributes.FCUnderlineStr(
  const AOverline: Boolean): String;
var
  AFormatCode: TFormatCode;
begin
  if AOverline then
    AFormatCode := fcUnderlineOn
  else
    AFormatCode := fcUnderlineOff;
  Result := FCCharPrefix(AFormatCode)
end;

function TACAttributes.FCWidthStr(const AWidth: Single): String;
begin
  Result := FCCharPrefix(fcWidth) + FloatToStr(AWidth)
    + FCEnd
end;

function TACAttributes.FCUnicodeStr(
  const AnUnicodeChar: Word): String;
begin
  Result := FCCharPrefix(fcUnicodeSym) + '+' +
    Int2Hex(Word(AnUnicodeChar), 4)
end;

constructor TACAttributes.Create(AOwner: PControl);
begin
  inherited Create;
  FACADMemo := AOwner;
  FStackText := TStackText.Create(Self);
  with FStackTextHeight do
  begin
    Height := 0.75;
    DwgUnits := False
  end
end;

function TACAttributes.CharToFormatCode(AChar: Char): TFormatCode;
var AFormatCode: TFormatCode;
begin
  AFormatCode := Low(TFormatCode);
  while not ((FCCharacters[AFormatCode] = AChar) or
    (AFormatCode = High(TFormatCode))) do Inc(AFormatCode);
  Result := AFormatCode
end;

function TACAttributes.GetColor: TACColor;
begin
  Result := FACFormat.Color
end;

function TACAttributes.GetFont: String;
begin
  Result := FACFormat.Font
end;

function TACAttributes.GetHeight: TACHeight;
begin
  Result := FACFormat.Height
end;

function TACAttributes.GetOverline: Boolean;
begin
  Result := FACFormat.Overline
end;

function TACAttributes.GetStack: TStack;
begin
  Result := FACFormat.Stack
end;

function TACAttributes.GetUnderline: Boolean;
begin
  Result := FACFormat.Underline
end;

procedure TACAttributes.SetColor(const Value: TACColor);
begin
  if FACADMemo.SelLength <> 0 then
    FACADMemo.Selection := BraceOpen + FCColorStr(Value) + FACADMemo.Selection
      + BraceClose
  else
    FACADMemo.Selection := FCColorStr(Value)
end;

procedure TACAttributes.SetFont(const Value: String);
begin
  if FACADMemo.SelLength <> 0 then
    FACADMemo.Selection := BraceOpen + FCFontStr(Value) + FACADMemo.Selection
      + BraceClose  
  else  
    FACADMemo.Selection := FCFontStr(Value)
end;

procedure TACAttributes.SetHeight(const Value: TACHeight);
begin
  if FACADMemo.SelLength <> 0 then
    FACADMemo.Selection := BraceOpen + FCHeightStr(Value) + FACADMemo.Selection
        + BraceClose  
  else
    FACADMemo.Selection := FCHeightStr(Value)
end;

procedure TACAttributes.SetOverline(const Value: Boolean);
begin
  if FACADMemo.SelLength <> 0 then
    FACADMemo.Selection := BraceOpen + FCOverlineStr(Value) + FACADMemo.Selection
      + BraceClose
  else
    FACADMemo.Selection := FCOverlineStr(Value)
end;

procedure TACAttributes.SetUnderline(const Value: Boolean);
begin
  if FACADMemo.SelLength <> 0 then
    FACADMemo.Selection := BraceOpen + FCUnderlineStr(Value) + FACADMemo.Selection
        + BraceClose  
    else  
      FACADMemo.Selection := FCUnderlineStr(Value)
end;

function TACAttributes.FormatCodeToTextFormat(
  AFormatCode: TFormatCode): TACTextFormat;
begin
  case AFormatCode of
    fcAlignment: Result := tfAlignment;
    fcAngle: Result := tfAngle;
    fcCharSpace: Result := tfCharSpace;
    fcColor: Result := tfColor;
    fcExtraColor: Result := tfColor;
    fcFontName: Result := tfFontName;
    fcExtraFontName: Result := tfFontName;
    fcHeight: Result := tfHeight;
    fcOverlineOn: Result := tfOverline;
    fcOverlineOff: Result := tfOverline;
    fcUnderlineOn: Result := tfUnderline;
    fcUnderlineOff: Result := tfUnderline;
    fcWidth: Result := tfWidth
  else
    Result := tfUnknown
  end;
end;

function TACAttributes.GetACTextFormat: TACFormat;
begin
  Result := FACFormat
end;

procedure TACAttributes.SetACTextFormat(const Value: TACFormat);
begin

end;

function TACAttributes.GetDefaultFormat: TSetACTextFormat;
begin
  Result := FACFormat.DefaultFormat
end;

procedure TACAttributes.SetDefaultFormat(const Value: TSetACTextFormat);
begin

end;

function TACAttributes.GetConsistentFormat: TSetACTextFormat;
begin
  Result := FACFormat.ConsistentFormat
end;

procedure TACAttributes.SetConsistentFormat(const Value: TSetACTextFormat);
begin

end;

procedure TACAttributes.DoErrorProc(const ErrorCode: Integer);
begin
  if Assigned(FOnError) then
    FOnError(ErrorCode)
end;

function TACAttributes.FCFontCode(const FontStr: String): TACFontName;
begin
  Result := FontStr
end;

function TACAttributes.GetAlignment: TACAlignment;
begin
  Result := FACFormat.Alignment
end;

procedure TACAttributes.SetAlignment(const Value: TACAlignment);
begin
  if FACADMemo.SelLength <> 0 then
    FACADMemo.Selection := BraceOpen + FCAlignmentStr(Value) +
      FACADMemo.Selection + BraceClose
  else
    FACADMemo.Selection := FCAlignmentStr(Value)
end;

function TACAttributes.GetAngle: Single;
begin
  Result := FACFormat.Angle
end;

procedure TACAttributes.SetAngle(const Value: Single);
begin
  if FACADMemo.SelLength <> 0 then
    FACADMemo.Selection := BraceOpen + FCObliquingStr(Value) +
      FACADMemo.Selection + BraceClose
  else
    FACADMemo.Selection := FCObliquingStr(Value)
end;

function TACAttributes.GetCharSpace: Single;
begin
  Result := FACFormat.CharSpace
end;

procedure TACAttributes.SetCharSpace(const Value: Single);
begin
  if FACADMemo.SelLength <> 0 then
    FACADMemo.Selection := BraceOpen + FCCharSpaceStr(Value) +
      FACADMemo.Selection + BraceClose
  else
    FACADMemo.Selection := FCCharSpaceStr(Value)
end;

function TACAttributes.GetWidth: Single;
begin
  Result := FACFormat.Width
end;

procedure TACAttributes.SetWidth(const Value: Single);
begin
  if FACADMemo.SelLength <> 0 then
    FACADMemo.Selection := BraceOpen + FCObliquingStr(Value) +
      FACADMemo.Selection + BraceClose
  else
    FACADMemo.Selection := FCWidthStr(Value)
end;

procedure TACAttributes.SetSymbol(const Value: TFormatCode);
begin
  if FormatCodeToTextFormat(Value) = tfUnknown then
    FACADMemo.Selection := FCCharPrefix(Value)
end;

procedure TACAttributes.InsertStackText(const HighText, LowText: String;
  AStackType: TStackType);
var
  BufPos: Integer;
  BufStr: String;
begin
  if StackHeightChange then
    FACADMemo.Selection := BraceOpen + FCHeightStr(StackTextHeight) +
      FCStackTextStr(HighText, LowText, AStackType) + BraceClose
  else
    FACADMemo.Selection := FCStackTextStr(HighText, LowText, AStackType);
  if StackAlignChange then
    if not AlignedAtFirst then
    begin
      BufStr := FCAlignmentStr(StackAlign);
      BufPos := FACADMemo.SelStart + Length(BufStr);
      FACADMemo.Text := BufStr + FACADMemo.Text;
      FACADMemo.SelStart := BufPos
    end
    else
      FACADMemo.Text := PChar(FCAlignmentStr(StackAlign))[0]
        + CopyEnd(FACADMemo.Text, Length(FACADMemo.Text) - 1)
        
end;

procedure TACAttributes.GetStackText(var UpText, DownText: String;
  var AStackType: TSTackType);
var
  AStack: TStack;
  APChar: PChar;
begin
  AStack := GetStack;
  APChar := PChar(FACADMemo.Text);
  Inc(APChar, AStack.TextPos);
  if AStack.UpLen > 0 then
  begin
    SetLength(UpText, AStack.UpLen);
    StrLCopy(PChar(UpText), APChar, AStack.UpLen)    
  end
  else
    UpText := '';
  if AStack.LowLen > 0 then
  begin
    SetLength(DownText, AStack.LowLen);
    Inc(APChar, AStack.UpLen + 1);
    StrLCopy(PChar(DownText), APChar, AStack.LowLen)    
  end
  else
    DownText := '';
  AStackType := AStack.StackType
end;

procedure TACAttributes.ClearAllFormatting;
var
  StrBuf: String;
  FormatStr: TFormatStr;
  i: Integer;
  ASelected: Boolean;
begin
  ASelected := FACADMemo.SelLength > 0;
  if ASelected then
    StrBuf := FACADMemo.Selection
  else
    StrBuf := FACADMemo.Text;
  ScanForFormatText(PChar(StrBuf));
  for i := Length(FFormatCharsSet) - 1 downto 0 do
  begin
    FormatStr := FFormatCharsSet[i];
    if FormatCodeToTextFormat(FormatStr.FormatCode)
      <> tfUnknown then
      Delete(StrBuf, FormatStr.StrPos, FormatStr.StrLen)
    else
      if FormatStr.BlockMark <> bbOther then
        Delete(StrBuf, FormatStr.StrPos, FormatStr.StrLen);
  end;
  if ASelected then
    FACADMemo.Selection := StrBuf
  else
    FACADMemo.Text := StrBuf;
  SetLength(FFormatCharsSet, 0)
end;

function TACAttributes.FormatStrLen(AFormatCode: TFormatCode;
  const APosition: Integer): Integer;
begin
  case AFormatCode of
    fcColor..fcAlignment: Result :=
      DetectFormatStrLen(APosition);
    fcUnicodeSym: Result := 6;
    fcUnknown: Result := 1;
  else
    Result := 2
  end
end;

function TACAttributes.DetectFormatStrLen(
  const APosition: Integer): Integer;
begin
  Result := 0;
  while not ((CharFromIndex(APosition + Result) = #00) or
    (CharFromIndex(APosition + Result) = FCEnd)) do
    Inc(Result);
  if CharFromIndex(APosition + Result) = FCEnd then
    Inc(Result)
  else Result := 0
end;

function TACAttributes.CharFromIndex(const AIndex: Integer): Char;
begin
  Result := PChar(FACADMemo.Text)[AIndex - 1]
end;

procedure TACAttributes.InsertUnicode(
  const AnUnicodeChar: Word);
begin
  if UnicodeFontName = '' then
    FACADMemo.Selection :=
      FCUnicodeStr(AnUnicodeChar)
  else
    FACADMemo.Selection := BraceOpen + FCFontStr(UnicodeFontName) +
      FCUnicodeStr(AnUnicodeChar) + BraceClose
end;

function TACAttributes.GetUnicodeFontName: String;
begin
  Result := FUnicodeFontName
end;

procedure TACAttributes.SetUnicodeFontName(const Value: String);
begin
  FUnicodeFontName := Value
end;

function TACAttributes.GetAlignedAtFirst: Boolean;
begin
  Result := False;
  if CharFromIndex(1) = BackSlash then
    if CharToFormatCode(CharFromIndex(2)) = fcAlignment then
      Result := True
end;

function TACAttributes.TxtChar(APos: Integer): Char;
begin
  Result := PChar(FACADMemo.Text)[APos]
end;

function TACAttributes.TxtPos(StartPos: Integer;
  AChar: Char): Integer;
var
  Flag: Boolean;
  BChar: Char;
begin
  Result := StartPos;
  Flag := False;
  BChar := #0;
  while not Flag do
  begin
    BChar := TxtChar(Result);
    Flag := (BChar = #0) or (BChar = AChar);
    Inc(Result)
  end;
  if BChar = #0 then
    Result := -1
end;

function TACAttributes.TxtPosEx(StartPos: Integer;
  const AChars: array of Char; var AnIndex: Byte): Integer;
var
  Flag: Boolean;
  BChar: Char;
begin
  Result := StartPos;
  Flag := False;
  BChar := #0;
  while not Flag do
  begin
    BChar := TxtChar(Result);
    AnIndex := 0;
    while (AChars[AnIndex] < BChar) and
      (AnIndex < Length(AChars)) do
      Inc(AnIndex);
    if AChars[AnIndex] = BChar then Flag := True;
    Inc(Result)
  end;
  if BChar = #0 then
    Result := -1
end;

function TACAttributes.TxtExtractStr(AStart, ALength: Integer): String;
var
  DestS, SrcS: PChar;
begin
  SetLength(Result, ALength);
  DestS := PChar(Result);
  SrcS := TxtPtr(AStart);

  if (AStart + ALength - 1) < TxtLength then
    Move(SrcS, DestS, ALength)
  else
  begin
    FErrPos := AStart;
    DoErrorProc($010000)
  end
end;

function TACAttributes.TxtLength: Integer;
begin
  Result := Length(FACADMemo.Text)
end;

function TACAttributes.TxtPtr(APos: Integer): PChar;
begin
  Result := PChar(FACADMemo);
  Inc(Result, APos)
end;

function TACAttributes.TxtExtractStr(AStart: Integer): String;
var
  i: Integer;
begin
  i := TxtPos(AStart, FCEnd);
  Result := TxtExtractStr(AStart, i - AStart)
end;

function TACAttributes.TxtCodeDPProc(APos: Integer): TDPCharType;
begin
  case TxtChar(APos + 2) of
    'd': Result := dpDegrees;
    'p': Result := dpTolerance;
    'c': Result := dpDiameter
  else
    Result := dpUnknown;
    FErrPos := APos;
    DoErrorProc($020000)
  end
end;

function TACAttributes.TxtExtractInt(AStart: Integer): Integer;
var
  S: String;
begin
  S := TxtExtractStr(AStart);
  Result := Str2Int(S)
end;

function TACAttributes.TxtExtractFloat(AStart: Integer): Single;
begin
  if not TryStrToFloat(TxtExtractStr(AStart), Result) then
  begin
    Result := 0;
    FErrPos := AStart;
    DoErrorProc($040000)
  end;
end;

function TACAttributes.TryStrToFloat(const S: string;
  out Value: Single): Boolean;
begin
  StrScan(PChar(S), '.')[0] := ',';
  Value := Str2Extended(PChar(S))
end;

function TACAttributes.FloatToStr(Value: Single): String;
var
  AnExtended: Extended;
  Buffer: array[0..63] of Char;
  P: PChar;
begin
  AnExtended := Value;
  Result := Extended2Str(AnExtended)
end;

procedure TACAttributes.ScanForFormatText(const AText: PChar);
var
  i, APos: Integer;
begin
  i := 0;
  APos := 1;
  while AText[APos - 1] <> #00 do
  begin
    if AText[APos - 1] = BackSlash then
    begin
      Inc(i);
      SetLength(FFormatCharsSet, i);
      with FFormatCharsSet[i - 1] do
      begin
        BlockMark := bbOther;
        FormatCode := CharToFormatCode(AText[APos]);
        StrPos := APos;
        StrLen := FormatStrLen(FormatCode, APos);
        Inc(APos, StrLen - 1)
      end
    end else
      if (AText[APos - 1] = BraceOpen) or
        (AText[APos - 1] = BraceClose) then
      begin
        Inc(i);
        SetLength(FFormatCharsSet, i);
        with FFormatCharsSet[i - 1] do
        begin
          FormatCode := fcUnknown;
          if AText[APos - 1] = BraceOpen then
            BlockMark := bbOpen
          else
            BlockMark := bbClose;
          StrPos := APos;
          StrLen := 1
        end
      end;
    Inc(APos)
  end
end;

{ TStackText }

constructor TStackText.Create(AOwner: TACAttributes);
begin
  FACAttributes := AOwner;
  FACADMemo := FACAttributes.FACADMemo
end;

function TStackText.GetStackType: TStackType;
begin
  Result := FACAttributes.Stack.StackType
end;

procedure TStackText.Read;
begin
  FACAttributes.GetStackText(FHighText, FLowText, FStackType)
end;

procedure TStackText.Write;
begin
  FACAttributes.InsertStackText(FHighText, FLowText, FStackType)
end;

end.
