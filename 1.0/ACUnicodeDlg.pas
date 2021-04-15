unit ACUnicodeDlg;

interface

uses Forms, StdCtrls, Controls, Classes, ExtCtrls, ACADTypes,
  Shapes, AutoCADObjects, LResources;

type
  TACUnicodeDialog = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    EdtCode10: TEdit;
    ListBox: TListBox;
    CmbBxBookmark: TComboBox;
    GroupBox: TGroupBox;
    BtnAdd: TButton;
    BtnDelete: TButton;
    GrpBxCode: TGroupBox;
    LblCode10: TLabel;
    EdtCode16: TEdit;
    LblCode16: TLabel;
    ChckBxFontInfo: TCheckBox;
    Image: TImage;
    LblFont: TLabel;
    BtnTable: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ListBoxClick(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
    procedure EdtCode10Change(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure CmbBxBookmarkSelect(Sender: TObject);
    procedure CmbBxBookmarkEnter(Sender: TObject);
    procedure CmbBxBookmarkChange(Sender: TObject);
    procedure EdtCode10KeyPress(Sender: TObject; var Key: Char);
    procedure CmbBxBookmarkKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EdtCode16KeyPress(Sender: TObject; var Key: Char);
    procedure BtnTableClick(Sender: TObject);
  private
    FBuf: Integer;
    FBookmarksModified: Boolean;
    FComboBox: TACADFontComboBox;
    FUnicodeArray: array of Word;
    FShapeData: TShapeFontData;
    FShapeSizes: array of Word;
    FSHXFile: file;
    FDefNamesFile: file;
    function DefNamesFileName: String;
    function GetACUnicode: Word;
    procedure SetACUnicode(const Value: Word);
    function GetACFont: TACFontName;
    procedure SetACFont(const Value: TACFontName);
    procedure UpdateACFontState;
    procedure UpdateListBox;
    procedure UpdateUnifont;
    procedure UpdateFont;
    function ExtractDefName(AnUnicode: Word): String;
    procedure FreeShapesData;
    procedure DrawCharacter(APointer: Pointer);
    procedure ComboBoxSelect(Sender: TObject);
    function GetbmFile: String;
    procedure SetBookmarksModified(const Value: Boolean);
    function GetCanModify: Boolean;
    procedure SetCanModify(const Value: Boolean);
    function GetBMCanDelete: Boolean;
    procedure SetBMCanDelete(const Value: Boolean);
    function GetAddFontName: Boolean;
    procedure SetAddFontName(const Value: Boolean);
    function GetCompleteBookmark: Boolean;
    procedure SetCompleteBookmark(const Value: Boolean);
    procedure ShapeOnSubShape(Sender: TObject;
      AnUnicode: Word);
    function UCodeListItem(AnACUnicode: Word): Integer;
  protected
    property BMCanChange: Boolean read GetCanModify
      write SetCanModify;
    property BMCanDelete: Boolean read GetBMCanDelete
      write SetBMCanDelete;
  public
    function FontPath: String;
    procedure BMAdd;
    procedure BMDelete;
    procedure BMLoad;
    procedure BMSave;
    function Execute: Boolean;
    function UnicodeFromListItem(ListItemIndex: Integer): Word;
    function ListBoxItemByUnicode(AnACUnicode: Word): Integer;
    property ACFont: TACFontName read GetACFont write
      SetACFont;
    property ACUnicode: Word read GetACUnicode
      write SetACUnicode;
    property AddFontName: Boolean read GetAddFontName
      write SetAddFontName;
    property CompleteBookmark: Boolean
      read GetCompleteBookmark write SetCompleteBookmark;
    property BMFile: String read GetbmFile;
    property BMModified: Boolean read FBookmarksModified
      write SetBookmarksModified;
  end;

implementation


uses
  SysUtils, ACFontDlg, StrUtils, LCLIntf, UnicodeTable, Grids;

const DefFont = 'txt';

var
  Table: TFrmUnicodeTable;

{ TACUnicodeDialog }

function TACUnicodeDialog.GetACUnicode: Word;
var
  AnInteger: Integer;
begin
  if not TryStrToInt(EdtCode10.Text, AnInteger) then
    Result := $0000
  else
    Result := AnInteger
end;

procedure TACUnicodeDialog.SetACUnicode(const Value: Word);
begin
  ListBox.ItemIndex := UCodeListItem(Value);
  ListBoxClick(ListBox)
end;

procedure TACUnicodeDialog.FormCreate(Sender: TObject);
begin
  FComboBox := TACADFontComboBox.Create(Self);
  with FComboBox do
  begin
    FComboBox.Parent := Self;
    Top := 135;
    Left := 210;
    Width := 100;
    OnlyShape := True;
    OnSelect := @ComboBoxSelect;
    Style := csDropDownList
  end;
  ACFont := DefFont;
  BMModified := False;
  BMCanChange := BMCanChange;
  BMCanDelete := BMCanDelete;
  CompleteBookmark := False
end;

procedure TACUnicodeDialog.ListBoxClick(Sender: TObject);
var
  AnItemIndex: Integer;
begin
  AnItemIndex := ListBox.ItemIndex;
  if (AnItemIndex > -1) and
    (AnItemIndex < ListBox.Items.Count) then
  begin
    CmbBxBookmark.Text :=
      ListBox.Items[AnItemIndex];
    EdtCode10.Text := IntToStr(FUnicodeArray[AnItemIndex]);
    BMCanChange := BMCanChange;
    BMCanDelete := BMCanDelete;
    DrawCharacter(
      Pointer(ListBox.Items.Objects[AnItemIndex]));
    if not BtnTable.Enabled and Self.Active then
      with Table.DrwGrd do
      begin
        Row := AnItemIndex div ColCount;
        Col := AnItemIndex - Row * ColCount
      end
  end
end;

procedure TACUnicodeDialog.ListBoxDblClick(Sender: TObject);
begin
  ListBoxClick(Sender);
  ModalResult := mrOk
end;

procedure TACUnicodeDialog.EdtCode10Change(Sender: TObject);
begin
  EdtCode16.Text := IntToHex(Ord(ACUnicode), 4)
end;

procedure TACUnicodeDialog.BMAdd;
var
  AnInteger: Integer;
begin
  with CmbBxBookmark do
    if ItemIndex = -1 then
    begin
      if ListBox.ItemIndex <> -1 then
      begin
        AnInteger := Items.IndexOf(CmbBxBookmark.Text);
        if AnInteger = -1 then
        begin
          AddItem(CmbBxBookmark.Text, TObject(Integer(ACUnicode)));
          BMModified := True
        end
        else
        begin  
          Items.Delete(AnInteger);
          AddItem(CmbBxBookmark.Text, TObject(Integer(ACUnicode)));
          BMModified := True
        end
      end
    end
end;

procedure TACUnicodeDialog.BMDelete;
begin
  with CmbBxBookmark do
    Items.Delete(ItemIndex);
  BMModified := True
end;

procedure TACUnicodeDialog.BtnDeleteClick(Sender: TObject);
begin
  BMDelete
end;

procedure TACUnicodeDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  BMSave;
  FreeShapesData
end;

function TACUnicodeDialog.GetACFont: TACFontName;
begin
  Result := FComboBox.FontName
end;

procedure TACUnicodeDialog.SetACFont(const Value: TACFontName);
begin
  if Value = '' then
    FComboBox.FontName := DefFont
  else
    FComboBox.FontName := Value;
  UpdateACFontState
end;

function TACUnicodeDialog.GetbmFile: String;
begin
  Result := ExtractFilePath(Application.ExeName) +
    'Bin\' + ChangeFileExt(ACFont, '.bkm')
end;

procedure TACUnicodeDialog.BMSave;
var
  i: Integer;
  AStrings: TStringList;
begin
  if FBookmarksModified then
  begin
    AStrings := TStringList.Create;
    for i := 0 to CmbBxBookmark.Items.Count - 1 do
    begin
      AStrings.Add(CmbBxBookmark.Items[i] + '=');
      AStrings.ValueFromIndex[i] := IntToStr(
        Integer(CmbBxBookmark.Items.Objects[i]))
    end;
    AStrings.SaveToFile(BMFile);
    AStrings.Free;
    BMModified := False
  end
end;

procedure TACUnicodeDialog.BMLoad;
var
  i, j: Integer;
  AStrings: TStringList;
begin
  if FileExists(BMFile) then
  begin
    AStrings := TStringList.Create;
    AStrings.LoadFromFile(BMFile);
    for i := 0 to AStrings.Count - 1 do
    begin
      j := StrToInt(AStrings.ValueFromIndex[i]);
      CmbBxBookmark.AddItem(AStrings.Names[i], TObject(j))
    end;
    AStrings.Free;
    BMModified := False
  end
end;

procedure TACUnicodeDialog.SetBookmarksModified(const Value: Boolean);
begin
  FBookmarksModified := Value
end;

procedure TACUnicodeDialog.BtnAddClick(Sender: TObject);
begin
  BMAdd;
  BMCanChange := BMCanChange;
  BMCanDelete := BMCanDelete
end;

function TACUnicodeDialog.GetCanModify: Boolean;
begin
  Result := not (CmbBxBookmark.Text = '')
end;

procedure TACUnicodeDialog.SetCanModify(const Value: Boolean);
begin
  BtnAdd.Enabled := Value
end;

function TACUnicodeDialog.GetBMCanDelete: Boolean;
begin
  Result := not (CmbBxBookmark.ItemIndex = -1)
    and not ListBox.Focused
end;

procedure TACUnicodeDialog.SetBMCanDelete(const Value: Boolean);
begin
  BtnDelete.Enabled :=  Value
end;

procedure TACUnicodeDialog.CmbBxBookmarkSelect(Sender: TObject);
begin
  BMCanChange := BMCanChange;
  BMCanDelete := BMCanDelete;
  ACUnicode := Integer(CmbBxBookmark.Items.Objects[
    CmbBxBookmark.ItemIndex])
end;

procedure TACUnicodeDialog.CmbBxBookmarkEnter(Sender: TObject);
begin
  BMCanChange := BMCanChange;
  BMCanDelete := BMCanDelete
end;

function TACUnicodeDialog.ListBoxItemByUnicode(
  AnACUnicode: Word): Integer;
var
  Flag: Boolean;
begin
  Result := 0;
  Flag := False;
  while not Flag do
  begin
    Flag := (Result = Length(FUnicodeArray));
    if not Flag then
    begin
      Flag := (FUnicodeArray[Result] = AnACUnicode);
      if not Flag then Inc(Result)
    end
  end;
  if not (Result < Length(FUnicodeArray)) then
    Result := -1
end;

procedure TACUnicodeDialog.CmbBxBookmarkChange(Sender: TObject);
begin
  BMCanChange := BMCanChange;
  BMCanDelete := BMCanDelete
end;

function TACUnicodeDialog.GetAddFontName: Boolean;
begin
  Result := ChckBxFontInfo.Checked
end;

procedure TACUnicodeDialog.SetAddFontName(const Value: Boolean);
begin
  ChckBxFontInfo.Checked := Value
end;

procedure TACUnicodeDialog.EdtCode10KeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    ACUnicode := ACUnicode
end;

procedure TACUnicodeDialog.CmbBxBookmarkKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
{  if Key = VK_F2 then
    CompleteBookmark := not CompleteBookmark}
    
end;
                   { TODO: Доработать
}


function TACUnicodeDialog.GetCompleteBookmark: Boolean;
begin
  Result := CmbBxBookmark.AutoComplete
end;

procedure TACUnicodeDialog.SetCompleteBookmark(const Value: Boolean);
begin
  with CmbBxBookmark do
  begin
    AutoComplete := Value;
    if Value then
      Hint := 'Режим автопоиск включен. ' +
        'Для смены режима нажмите F2'
    else
      Hint := 'Режим автопоиск выключен. ' +
        'Для смены режима нажмите F2'
  end
end;

procedure TACUnicodeDialog.EdtCode16KeyPress(Sender: TObject;
  var Key: Char);
var
  AWord: Word;
  S: String;
begin
  AWord := 0;
  if Key = #13 then
  begin
    S := EdtCode16.Text;
    while Length(S) < 4 do
      S := '0' + S;
    EdtCode16.Text := S;
    HexToBin(PChar(S), @AWord, 2);
    ACUnicode := Swap(AWord)
  end
end;

procedure TACUnicodeDialog.UpdateListBox;
var
  ShapeHeader: TShapeFontHeader;
  CharTitleData: TCharTitleData;
begin
  AssignFile(FDefNamesFile, DefNamesFileName);
  FileMode := fmOpenRead;
  Reset(FDefNamesFile, 1);
  BlockRead(FDefNamesFile, CharTitleData,
    SizeOf(TCharTitleData));
  FBuf := CharTitleData.Offset;

  FreeShapesData;
  BMModified := False;
  if FileExists(FontPath) then
  begin
    AssignFile(FSHXFile, FontPath);
    FileMode :=  fmOpenRead;
    Reset(FSHXFile, 1);
    try
      BlockRead(FSHXFile, ShapeHeader, SizeOf(TShapeFontHeader));
      if ShapeHeader.LineEnd[1] = 'u' then
        UpdateUnifont
      else
        if ShapeHeader.LineEnd[1] = 's' then
          UpdateFont
        else
          Exit
    finally
      CloseFile(FSHXFile)
    end
  end;
  CloseFile(FDefNamesFile)
end;

procedure TACUnicodeDialog.DrawCharacter(APointer: Pointer);
var
  DrawShape: TShapeProc;
begin
  DrawShape := TShapeProc.Create(Image.Canvas);
  DrawShape.OnSubShape := @ShapeOnSubShape;
  DrawShape.ScaleFactor := 30 / FShapeData.above;
  DrawShape.Position := RealPoint(15, 40);
  DrawShape.BeginDraw(APointer);
  DrawShape.Free
end;

procedure TACUnicodeDialog.FreeShapesData;
var
  i: Integer;
begin
  for i := 0 to Length(FShapeSizes) - 1 do
    FreeMem(Pointer(ListBox.Items.Objects[i]), FShapeSizes[i]);
  ListBox.Clear;
  BMSave;
  CmbBxBookmark.Clear;
  SetLength(FShapeSizes, 0);
  SetLength(FUnicodeArray, 0)
end;

function TACUnicodeDialog.FontPath: String;
begin
  Result := AutoCADFontPath + ChangeFileExt(ACFont, '.shx')
end;

procedure TACUnicodeDialog.ShapeOnSubShape(Sender: TObject;
  AnUnicode: Word);
begin
  (Sender as TShapeProc).BeginDraw(Pointer(
    ListBox.Items.Objects[ListBoxItemByUnicode(AnUnicode)]))
end;

procedure TACUnicodeDialog.UpdateUnifont;
var
  BufStr: String;
  ReadByte, i: Integer;
  ShapeHeader2: TShapeFontHeader2;
  ShapeDataHeader: TShapeDataHeader;
  PBufStr: PChar;
  PShapeData: Pointer;
begin
  BlockRead(FSHXFile, ShapeHeader2,
    SizeOf(TShapeFontHeader2));
  SetLength(BufStr, ShapeHeader2.TitleLength -
    SizeOf(TShapeFontHeader2));
  PBufStr := PChar(BufStr);
  BlockRead(FSHXFile, PBufStr^, ShapeHeader2.TitleLength -
    SizeOf(TShapeFontHeader2));
  BlockRead(FSHXFile, FShapeData, SizeOf(TShapeFontData));
  i := 1;
  repeat
    BlockRead(FSHXFile, ShapeDataHeader,
      SizeOf(TShapeDataHeader), ReadByte);
    if ReadByte = SizeOf(TShapeDataHeader) then
    begin
      SetLength(FUnicodeArray, i);
      SetLength(FShapeSizes, i);
      FUnicodeArray[i - 1] := ShapeDataHeader.shapenumber;
      GetMem(PShapeData, ShapeDataHeader.defbytes);
      FShapeSizes[i - 1] := ShapeDataHeader.defbytes;
      BlockRead(FSHXFile, PShapeData^,
        ShapeDataHeader.defbytes);
      if (PChar(PShapeData)[0] = #00) then
        BufStr := ExtractDefName(FUnicodeArray[i - 1])
      else
        BufStr := PChar(PShapeData);
      ListBox.Items.AddObject(BufStr,
        TObject(Pointer(PShapeData)));
      Inc(i)
    end
  until ReadByte < SizeOf(TShapeDataHeader)
end;

function TACUnicodeDialog.UCodeListItem(AnACUnicode: Word): Integer;
var
  Flag: Boolean;
begin
  Result := 0;
  Flag := False;
  while not Flag do
  begin
    Flag := (Result = Length(FUnicodeArray));
    if not Flag then
    begin
      Flag := (FUnicodeArray[Result] >= AnACUnicode);
      if not Flag then Inc(Result)
    end
  end;
  if not (Result < Length(FUnicodeArray)) then
    Result := -1
end;

procedure TACUnicodeDialog.UpdateFont;
var
  BufStr: String;
  PBufStr: PChar;
  i: Integer;
  ShapeHeader2: TShapeFontHeader2;  
  ShapeDataHeader: TShapeDataHeader;
  PShapeData: Pointer;
begin
  BlockRead(FSHXFile, ShapeHeader2,
    SizeOf(TShapeFontHeader2));
  Seek(FSHXFile, $22);
  for i := 0 to 100-1 do
  begin
    BlockRead(FSHXFile, ShapeDataHeader,
      SizeOf(ShapeDataHeader));
    SetLength(FUnicodeArray, i+1);
    SetLength(FShapeSizes, i+1);
    FUnicodeArray[i] := ShapeDataHeader.shapenumber;
    FShapeSizes[i] := ShapeDataHeader.defbytes
  end;
  Seek(FSHXFile, $1B2);
  SetLength(BufStr, 127);
  PBufStr := PChar(BufStr);
  BlockRead(FSHXFile, PBufStr^, 127);
  Seek(FSHXFile, $1B2 + StrLen(PBufStr) + 1);
  BlockRead(FSHXFile, FShapeData, 4);
  for i := 0 to 100-1 do
  begin
    GetMem(PShapeData, FShapeSizes[i]);
    BlockRead(FSHXFile, PShapeData^, FShapeSizes[i]);
    if (PChar(PShapeData)[0] = #00) then
      BufStr := ExtractDefName(FUnicodeArray[i])
    else
      BufStr := PChar(PShapeData);
    ListBox.Items.AddObject(BufStr,
      TObject(Pointer(PShapeData)))
  end
end;

function TACUnicodeDialog.ExtractDefName(AnUnicode: Word): String;
var
  CharTitleData: TCharTitleData;
  Flag: Boolean;
  ReadByte: Integer;
begin
  Flag := False;
  Seek(FDefNamesFile, 0);
  while not Flag do
    if FilePos(FDefNamesFile) < FBuf then
    begin
      BlockRead(FDefNamesFile, CharTitleData,
        SizeOf(CharTitleData));
      if CharTitleData.AnUnicode = AnUnicode then
      begin
        Flag := True;
        SetLength(Result, 63);
        Seek(FDefNamesFile, CharTitleData.Offset);
        BlockRead(FDefNamesFile, PChar(Result)^, 63,
          ReadByte);
        SetLength(Result, StrLen(PChar(Result)));
        Result := '[' + Result + ']'
      end
      else
        if CharTitleData.AnUnicode > AnUnicode then
        begin
          Flag := True;
          Result := 'Без названия'
        end
    end
    else begin
      Flag := True;
      Result := 'Без названия'
    end
end;

function TACUnicodeDialog.DefNamesFileName: String;
begin
  Result :=  ExtractFilePath(Application.ExeName) +
    'DefNames.dat'
end;

function TACUnicodeDialog.Execute: Boolean;
begin
  Result := ShowModal = mrOk
end;

procedure TACUnicodeDialog.UpdateACFontState;
var
  BUnicode: Word;
begin
  BUnicode := ACUnicode;
  GrpBxCode.Caption := 'Символы шрифта "' + ACFont + '"';
  UpdateListBox;
  BMLoad;
  ACUnicode := BUnicode;
  if not BtnTable.Enabled then
  begin
    Table.ACUnicodeDlg := Self;
    Table.ShapeData := FShapeData;
    Table.DrwGrd.Repaint
  end
end;

procedure TACUnicodeDialog.ComboBoxSelect(Sender: TObject);
begin
  UpdateACFontState
end;

function TACUnicodeDialog.UnicodeFromListItem(ListItemIndex: Integer): Word;
begin
  Result := FUnicodeArray[ListItemIndex]
end;

procedure TACUnicodeDialog.BtnTableClick(Sender: TObject);
begin
  Table := TFrmUnicodeTable.Create(Self);
  with Table do
  begin
    BtnTable.Enabled := False;
    ACUnicodeDlg := Self;
    ShapeData := FShapeData;
    Show
  end
end;

initialization
  {$i ACUnicodeDlg.lrs}

end.

