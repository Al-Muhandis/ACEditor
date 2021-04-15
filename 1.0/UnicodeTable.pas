unit UnicodeTable;

{$MODE Delphi}

interface

uses
  LCLIntf, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Shapes, ACADTypes, ACUnicodeDlg, Grids,
  StdCtrls, LResources;

type
  TFrmUnicodeTable = class(TForm)
    StatusBar: TStatusBar;
    DrwGrd: TDrawGrid;
    PnlButtons: TPanel;
    BtnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DrwGrdDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrwGrdSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BtnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FACUnicodeDlg: TACUnicodeDialog;
    FDrawShape: TShapeProc;
    FShapeData: TShapeFontData;
    procedure ShapeOnSubShape(Sender: TObject;
      AnUnicode: Word);
    procedure SetACUnicodeDlg(const Value: TACUnicodeDialog);
    procedure SetShapeData(const Value: TShapeFontData);
  public
    property ACUnicodeDlg: TACUnicodeDialog read FACUnicodeDlg write SetACUnicodeDlg;
    property ShapeData: TShapeFontData read FShapeData write SetShapeData;
  end;

implementation


procedure TFrmUnicodeTable.FormCreate(Sender: TObject);
begin
  FDrawShape := TShapeProc.Create(DrwGrd.Canvas);
  FDrawShape.OnSubShape := ShapeOnSubShape
end;

procedure TFrmUnicodeTable.ShapeOnSubShape(Sender: TObject;
  AnUnicode: Word);
begin
  (Sender as TShapeProc).BeginDraw(Pointer(
    FACUnicodeDlg.ListBox.Items.Objects[FACUnicodeDlg.ListBoxItemByUnicode(AnUnicode)]))
end;

procedure TFrmUnicodeTable.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FDrawShape.Free;
  FACUnicodeDlg.BtnTable.Enabled := True
end;

procedure TFrmUnicodeTable.SetACUnicodeDlg(const Value: TACUnicodeDialog);
begin
  FACUnicodeDlg := Value;
  DrwGrd.RowCount := FACUnicodeDlg.ListBox.Count div DrwGrd.ColCount + 1
end;

procedure TFrmUnicodeTable.SetShapeData(const Value: TShapeFontData);
begin
  FShapeData := Value;
  FDrawShape.ScaleFactor := 0.4 * DrwGrd.DefaultColWidth / FShapeData.above
end;

procedure TFrmUnicodeTable.DrwGrdDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  i: Integer;
  ShiftPos:  Double;
begin
  DrwGrd.Canvas.Pen.Color := clBlack;
  DrwGrd.Canvas.FillRect(Rect);
  i := ACol + ARow * DrwGrd.ColCount;
  if i < FACUnicodeDlg.ListBox.Count then
  begin
    ShiftPos := 0.14 * DrwGrd.DefaultColWidth;
    FDrawShape.Position := RealPoint(Rect.Left + ShiftPos,
      Rect.Top + DrwGrd.DefaultRowHeight - ShiftPos);
    FDrawShape.BeginDraw(FACUnicodeDlg.ListBox.Items.Objects[i]);
    if gdSelected in State then
      DrwGrd.Canvas.DrawFocusRect(Rect)
  end
end;

procedure TFrmUnicodeTable.DrwGrdSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  i: Integer;  
begin
  i := ACol + ARow * DrwGrd.ColCount;
  CanSelect := i < FACUnicodeDlg.ListBox.Count;
  if CanSelect then
  begin
    StatusBar.Panels[0].Text := '$' +
      IntToHex(FACUnicodeDlg.UnicodeFromListItem(i), 2);
    StatusBar.Panels[1].Text :=
      IntToStr(FACUnicodeDlg.UnicodeFromListItem(i));
    StatusBar.Panels[2].Text := ' ' + FACUnicodeDlg.ListBox.Items[i];
    if Self.Active then
    begin
      ACUnicodeDlg.ListBox.ItemIndex := i;
      ACUnicodeDlg.ListBoxClick(ACUnicodeDlg.ListBox)
    end
  end
end;

procedure TFrmUnicodeTable.BtnCloseClick(Sender: TObject);
begin
  Self.Close
end;

procedure TFrmUnicodeTable.FormResize(Sender: TObject);
begin
  DrwGrd.ColCount := DrwGrd.Width div DrwGrd.DefaultColWidth - 1;
  DrwGrd.RowCount := FACUnicodeDlg.ListBox.Count div DrwGrd.ColCount + 1;
  DrwGrd.Repaint
end;

initialization
  {$i UnicodeTable.lrs}
  {$i UnicodeTable.lrs}

end.
