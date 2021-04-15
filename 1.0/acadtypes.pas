unit ACADTypes;

interface

uses
  Graphics, IniFiles;
  
const
  LenFontName = 31;

type
  TStringPos = packed record
    Start: Integer;
    Length: Integer
  end;
  
  TACFontName = String[LenFontName];
  TACColor = Integer;
  TErrorEvent = procedure(const ErrorCode: Integer) of object;
  TACAlignment = (alBottom, alCenter, alTop);
  TACTextFormat = (tfAlignment, tfAngle, tfCharSpace,
    tfColor, tfFontName, tfHeight, tfOverline, tfUnderline,
    tfWidth, tfUnknown);
  TACHeight = packed record
    Height: Single;
    DwgUnits: Boolean
  end;
  TBlockBrace = (bbOther, bbOpen, bbClose);
  TDPCharType =
    (dpDegrees, dpTolerance, dpDiameter, dpUnknown);
  TFormatCode = (fcOverlineOn, fcOverlineOff, fcUnderlineOn,
    fcUnderlineOff, fcNBSpace, fcBackSlash, fcOpBrace,
    fcClBrace, fcEOParagraph, fcColor, fcExtraColor,
    fcFontName, fcExtraFontName, fcHeight, fcStack,
    fcCharSpace, fcAngle, fcWidth, fcAlignment,
    fcUnicodeSym, fcUnknown);
  TStackType = (stHorFraction, stVerFraction, stTolerance, stNone);
  TStackText = (stUp, stLow, stBoth);
  TStack = record
    TextPos: Integer;
    UpLen: Integer;
    LowLen: Integer;
    StackType: TStackType
  end;
  TSetACTextFormat = set of TACTextFormat;
  TACFormat = record
    Angle: Single;
    Alignment: TACAlignment;
    CharSpace: Single;
    Color: TACColor;
    Font: TFontName;
    Height: TACHeight;
    Overline: Boolean;
    Underline: Boolean;
    Stack: TStack;
    Width: Single;
    ConsistentFormat: TSetACTextFormat;
    DefaultFormat: TSetACTextFormat
  end;

  TFormatStr = record
    BlockMark: TBlockBrace;
    FormatCode: TFormatCode;
    case Boolean of
      False: (StrPos: Integer;
        StrLen: Integer);
      True: (Stack: TStack)
  end;

  TCharSetList = array of TFormatStr;

  TImportType = (imInsertAtCur, imReplaceAll);

  TFontParameters = packed record
    Name: TACFontName;
    Size: Byte;
    CharSet: Byte;
    Style: TFontStyles;
    Color: TColor;
  end;

  TShapeFontHeader = packed record
    AutoCAD_Ver: array[0..Length('AutoCAD-8') - 1] of AnsiChar;
    VerChar: AnsiChar;     
    LineEnd: array[0..Length(' unifont 1.0') - 1] of AnsiChar;
    Chars: array[0..2] of AnsiChar;
  end;
  TShapeFontHeader2 = packed record
    Word1: Word;
    Word2: Word;
    TitleLength: Word;
  end;

  TShapeFontData = packed record
    above: Byte;
    below: Byte;
    modes: Byte;
    encoding: Byte;
    Licence: Byte;
    Byte0: Byte;
  end;

  TShapeDataHeader = packed record
    shapenumber: Word;
    defbytes: Word;
  end;

  TFontType = (ftShape, ftUnifont, ftBigFont);

  TCharTitleData = packed record
    AnUnicode: Word;
    Length: Word;
    Offset: Cardinal
  end;

  TKBLayout = (kblDontChange, kblEn, kblRu);
  TEnumType = (etNumber, etCyrillic, etLatin);

  TFileFunc = function(AFileName: PChar): Boolean;
  TGetACAlignment =     function(Handle: THandle; var Value: TACAlignment): Boolean;
  TGetReal =            function(Handle: THandle; var Value: Single): Boolean;
  TGetInteger =         function(Handle: THandle; var Value: Integer): Boolean;
  TGetFontName =        function(Handle: THandle; var Value: TACFontName): Boolean;
  TGetFontHeight =      function(Handle: THandle; var Value: TACHeight): Boolean;
  TGetBoolean =         function(Handle: THandle; var Value: Boolean): Boolean;
  TGetUnicode = function(Handle: THandle; var AnUnicode: Word;
    var AFontName: TACFontName): Boolean;
  TGetStack =   function(Handle: THandle; const AHighText, ALowText: PChar;
    const TextBufSize: Integer; var AStackType: TStackType): Boolean;
  TGetOptionsFile = function(Handle: THandle; var ATab: Integer): Boolean;
  TGetFileName = function(Handle: THandle; const AFileName, DlgTitle,
    InitialPath: PChar; BufSize: Cardinal): Boolean;

  TOptions = class
  private
    FIniFile: TMemIniFile;
    FModified: Boolean;
    FFileName: String;
    function OptionsFilePath: String;    
    procedure SetFileName(const Value: String);
    procedure SetModified(const Value: Boolean);
  public
    constructor Create; virtual; abstract;
    destructor Destroy; override;
    procedure Reset; virtual; abstract;
    procedure Load; virtual;
    procedure Save; virtual;
    property FileName: String read FFileName write SetFileName;
    property Modified: Boolean read FModified write SetModified;
  end;


  TOptionsTools = record
    otEnumFormat: string;
    otEnumType: TEnumType;
  end;

  TMemTools = class(TOptions)
  private
    FToolsOptions: TOptionsTools;
    procedure SetToolsOptions(const Value: TOptionsTools);
  public
    constructor Create; override;  
    procedure Load; override;
    procedure Reset; override;
    procedure Save; override;
    property ToolsOptions: TOptionsTools read FToolsOptions
      write SetToolsOptions;
  end;

const
  BraceOpen = '{';
  BraceClose = '}';
  FCEnd = ';';
  BackSlash = '\';
  Solidus = '/';
  NumberSign = '#';
  Accent = '^';
  DoublePercent = '%%';
  DPCharacters: array[TDPCharType] of Char =
    ('d', 'p', 'c', #00);
  FCCharacters: array[TFormatCode] of Char =
    ('O', 'o', 'L', 'l', '~', BackSlash, BraceOpen,
    BraceClose, 'P', 'C', 'c', 'F', 'f', 'H', 'S', 'T', 'Q',
    'W', 'A', 'U', #00);
  STCharacters: array[TStackType] of Char =
    (Solidus, NumberSign, Accent, #00);
  MultipleSign = 'x';
  ShapeTitle = 'shapes 1.1'#$0D#$0A#$1A;

  FunGetAl =          'GetACADAlignment';
  FunGetSpc =         'GetACADCharSpace';
  FunGetColor =       'GetACADColor';
  FunGetFontName =    'GetACADFont';
  FunGetFontHeight =  'GetACADFontHeight';
  FunGetObliquing =   'GetACADObliquing';
  FunGetOverline =    'GetACADOverline';
  FunGetUnderline =   'GetACADUnderline';  
  FunGetUnicode =     'GetACADUnicode';
  FunGetStack =       'GetACADStack';
  FunGetWidth =       'GetACADWidthFactor';
  FunGetOptions =     'GetOptions';
  FunGetOptionsFile = 'GetOptionsFile';  
  FunGetFileSave =    'GetFileSaveName';
  FunGetFileOpen =    'GetFileOpenName';

  IniSctTemplate = 'Template';
    IniPath = 'Path';
    IniImport = 'ImportType';
  IniSctStack = 'Stack';
    IniChangeHeight = 'ChangeHeight';
    IniChangeAlign = 'ChangeAlign';
    IniHeight = 'Height';
    IniAlign = 'Align';
    IniRelativeHeight = 'RelativeHeight';
  IniSctFont = 'Font';
    IniCharset = 'Charset';
    IniColor = 'Color';
    IniName = 'Name';
    IniSize = 'Size';
    IniStyle = 'Style';
  IniSctView = 'View';
    IniBackground = 'Background';
    IniBlend = 'Translucent';
    IniBlendValue = 'TranslucentValue';
    IniStayOnTop = 'StayOnTop';
    IniStayOnCenter = 'StayOnCenter';
    IniMainMenu = 'Menu';
  IniSctComfort = 'Comfort';
    IniKB = 'Keyboard';
    IniSelectOnStart = 'SelectOnStart';    
  IniSctAutoCAD = 'AutoCAD';
    IniFont = 'ACFont';
  IniSctNumeration = 'Emumeration';
    IniText = 'Text';
    IniType = 'Type';

  IniFileName = 'ACEditor.ini';



function ACAlignmentToString(const ACAlignment: TACAlignment): String;
function AutoCADFontPath: String;
function EnumCyrillic(Index: Integer): String;
function EnumLatin(Index: Integer): String;
function TryStringToFloat(const S: string; out Value: Single): Boolean;
function DetectStack(Text: PChar; Start: Integer;
  var err: Integer): TStack;
function DetectStackType(AStackChar: Char): TStackType;
function DPCharToDPType(ADPChar: Char): TDPCharType;
function FCharToCode(AFormatChar: Char): TFormatCode;
function FindStringLength(Text: PChar; Start: Integer;
  var err: Integer): Integer;
function FloatToString(Value: Single): string;
procedure ScanForFCode(AText: PChar; Start: Integer;
  var AFormates: TCharSetList; err: Integer);
function TxtPos(Text: PChar; Start: Integer; AChar: Char): Integer;

implementation

uses Registry, LCLIntf, Classes, SysUtils, Math;

const ACADKey = 'Software\Autodesk\AutoCAD';

function ACAlignmentToString(const ACAlignment: TACAlignment): String;
begin
  case ACAlignment of
    alBottom: Result := 'По низу';
    alCenter: Result := 'По центру';
    alTop: Result := 'По верху'
  end
end;

function AutoCADFontPath: String;
var
  Reg: TRegistry;
  AStrings: TStringList;
begin
    Reg := TRegistry.Create(KEY_READ);
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKey(ACADKey, False) then
      begin
        AStrings := TStringList.Create;
        Reg.GetKeyNames(AStrings);
        if AStrings.Count > 0 then
        begin
          if Reg.OpenKey(AStrings[0], False) then
          begin
            Reg.GetKeyNames(AStrings);
            if AStrings.Count > 0 then
              if Reg.OpenKey(AStrings[0], False) then
                Result := Reg.ReadString('AcadLocation')
                  + '\Fonts\'
          end
        end;
        AStrings.Free
      end
    finally
      Reg.Free
    end
end;

function TryStringToFloat(const S: string; out Value: Single): Boolean;
var
  AnExtended: Extended;
begin
  Result := TextToFloat(PChar(S), AnExtended, fvExtended);
  if not Result then
  begin
    StrScan(PChar(S), '.')[0] := ',';
    Result := TextToFloat(PChar(S), AnExtended, fvExtended)
  end;
  Value := AnExtended
end;

function FCharToCode(AFormatChar: Char): TFormatCode;
var
  Found: Boolean;
begin
  Result := Low(Result);
  repeat
    Found := AFormatChar = FCCharacters[Result];
    Inc(Result)
  until Found or (Result = High(Result))
end;

function DetectStack(Text: PChar; Start: Integer;
  var err: Integer): TStack;
var
  Flag: Boolean;
  BChar: Char;
  Add1: Byte;
begin
  Result.TextPos := Start;
  Result.UpLen := 0;
  Result.LowLen := 0;
  Flag := False;
  BChar := #0;
  Add1 := 0;
  while not Flag do
  begin
    BChar := Text[Result.UpLen + Result.LowLen + Start + Add1];
    Result.StackType := DetectStackType(BChar);
    Flag := (BChar = #0) or (BChar = FCEnd);
    if Result.StackType <> stNone then
      Inc(Result.UpLen)
    else begin
      Inc(Result.LowLen);
      Add1 := 1
    end
  end;
  if BChar = #0 then
    err := -1
end;

function DetectStackType(AStackChar: Char): TStackType;
var
  Found: Boolean;
begin
  Result := Low(Result);
  repeat
    Found := AStackChar = STCharacters[Result];
    if not Found then
      Inc(Result)
  until Found or (Result = High(Result))
end;

function DPCharToDPType(ADPChar: Char): TDPCharType;
var
  Found: Boolean;
begin
  Result := Low(Result);
  repeat
    Found := ADPChar = DPCharacters[Result];
    if not Found then
      Inc(Result)
  until Found or (Result = High(Result))
end;

procedure ScanForFCode(AText: PChar; Start: Integer;
  var AFormates: TCharSetList; err: Integer);
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
      SetLength(AFormates, i);
      with AFormates[i - 1] do
      begin
        BlockMark := bbOther;
        FormatCode := FCharToCode(AText[APos]);
        StrPos := APos;
        if FormatCode <> fcStack then
          StrLen := FindStringLength(AText, Start, err)
        else
          Stack := DetectStack(AText, Start, err);
        Inc(APos, StrLen - 1)
      end
    end else
      if (AText[APos - 1] = BraceOpen) or
        (AText[APos - 1] = BraceClose) then
      begin
        Inc(i);
        SetLength(AFormates, i);
        with AFormates[i - 1] do
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

function TxtPos(Text: PChar; Start: Integer; AChar: Char): Integer;
var
  Flag: Boolean;
  BChar: Char;
begin
  Result := Start;
  Flag := False;
  BChar := #0;
  while not Flag do
  begin
    BChar := Text[Result];
    Flag := (BChar = #0) or (BChar = AChar);
    Inc(Result)
  end;
  if BChar = #0 then
    Result := -1
end;

function FindStringLength(Text: PChar; Start: Integer;
  var err: Integer): Integer;
var
  Flag: Boolean;
  BChar: Char;
begin
  Result := 0;
  Flag := False;
  BChar := #0;
  while not Flag do
  begin
    BChar := Text[Result + Start];
    Flag := (BChar = #0) or (BChar = FCEnd);
    Inc(Result)
  end;
  if BChar = #0 then
    err := -1
end;

function FloatToString(Value: Single): string;
var
  Buffer: array[0..63] of Char;
  AnExtended: Extended;
begin
  AnExtended := Value;
  SetString(Result, Buffer, FloatToText(Buffer, AnExtended,
    ffGeneral, 5, 0))
end;

function EnumCyrillic(Index: Integer): String;
begin
  Dec(Index);
  Index := Index mod 32;
  if Index < 9 then
    Result:= Char(Ord('а') + Index)
  else
    Result := Char(Ord('а') + Index + 1)
end;

function EnumLatin(Index: Integer): String;
begin
  Dec(Index);
  Index := Index mod 26;
  Result:= Char(Ord('a') + Index)
end;

{ TOptions }

destructor TOptions.Destroy;
begin
  if Assigned(FIniFile) then
    FIniFile.Free;
  inherited
end;

procedure TOptions.Load;
begin
  if Assigned(FIniFile) then
    FIniFile.Free;
  FIniFile := TMemIniFile.Create(OptionsFilePath);
  Modified := False
end;

function TOptions.OptionsFilePath: String;
begin
  Result := ExtractFilePath(ParamStr(0)) + '\' + FileName
end;

procedure TOptions.Save;
begin
  if Assigned(FIniFile) and Modified then
  begin
    FIniFile.UpdateFile;
    Modified := False
  end
end;

procedure TOptions.SetFileName(const Value: String);
begin
  FFileName := Value;
end;

procedure TOptions.SetModified(const Value: Boolean);
begin
  FModified := Value;
end;

{ TMemTools }

constructor TMemTools.Create;
begin
  FileName := 'Tools.ini'
end;

procedure TMemTools.Load;
begin
  inherited;
  with FIniFile, ToolsOptions do
  begin
    otEnumFormat := ReadString(IniSctNumeration, IniText, '  # ');
    otEnumType := TEnumType(ReadInteger(
      IniSctNumeration, IniType, Ord(etNumber)))
  end
end;

procedure TMemTools.Reset;
begin
  if FileExists(OptionsFilePath) then
  begin
    DeleteFile(OptionsFilePath);
    Load
  end
end;

procedure TMemTools.Save;
begin
  with FIniFile, ToolsOptions do
  begin
    WriteString(IniSctNumeration, IniText, otEnumFormat);
    WriteInteger(IniSctNumeration, IniType, Ord(otEnumType))
  end;
  inherited
end;

procedure TMemTools.SetToolsOptions(const Value: TOptionsTools);
begin
  FToolsOptions := Value
end;

end.
