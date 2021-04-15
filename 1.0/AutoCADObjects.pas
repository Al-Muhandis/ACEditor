unit AutoCADObjects;

{$MODE Delphi}

interface

uses
  ACADTypes, Classes, StdCtrls;

type
  TACADFontComboBox = class(TCustomComboBox)
  private
    FOnlyShape: Boolean;
    procedure UpdateFonts;
    function GetFont: String;
    function GetOnlyShape: Boolean;
    procedure SetFont(const Value: String);    
    procedure SetOnlyShape(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    function ACFontPath: String;
    property FontName: String read GetFont write SetFont;
    property OnlyShape: Boolean read GetOnlyShape
      write SetOnlyShape;
  published
    property AutoComplete default True;
    property AutoDropDown default False;
    property Anchors;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ItemHeight;
    property ItemIndex default -1;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property Style;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses Registry, SysUtils, LCLIntf, Controls;

const
  WinFontsKey =
    'Software\Microsoft\Shared Tools\Panose';

{ TACADFontComboBox }

function TACADFontComboBox.ACFontPath: String;
begin
  Result := AutoCADFontPath + '*.shx'
end;

constructor TACADFontComboBox.Create(AOwner: TComponent);
begin
  inherited;
  Parent := TWinControl(AOwner);
  OnlyShape := True;
  FontName := 'txt'
end;

function TACADFontComboBox.GetFont: String;
begin
  Result := Text
end;

function TACADFontComboBox.GetOnlyShape: Boolean;
begin
  Result := FOnlyShape
end;

procedure TACADFontComboBox.SetFont(const Value: String);
begin
  if Style = csDropDown then
    Text := Value
  else
    ItemIndex := Items.IndexOf(Value)
end;

procedure TACADFontComboBox.SetOnlyShape(const Value: Boolean);
var
  BFont: TACFontName;
begin
  FOnlyShape := Value;
  BFont := FontName;
  UpdateFonts;
  FontName := BFont
end;

procedure TACADFontComboBox.UpdateFonts;
var
  Reg: TRegistry;
  SearchRec: TSearchRec;
  AStrings: TStringList;
begin
  Items.Clear;
  Reg := TRegistry.Create(KEY_READ);
  try
    if not FOnlyShape then
    begin
      Reg.RootKey := HKEY_CURRENT_USER;
      if Reg.OpenKey(WinFontsKey, False) then
      begin
        AStrings := TStringList.Create;
        Reg.GetValueNames(AStrings);
        Self.Items := AStrings
      end
    end;
    if FindFirst(ACFontPath, faAnyFile - faDirectory,
      SearchRec) = 0 then
      repeat
        Self.Items.Append(ChangeFileExt(SearchRec.Name, ''))
      until FindNext(SearchRec) <> 0;
    SysUtils.FindClose(SearchRec);
    Self.Sorted := True
  finally
    Reg.Free
  end;
end;

end.
