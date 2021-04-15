unit Shapes;

interface

uses Graphics, Types;

type

  TRealPoint = packed record
    AX: Real;
    AY: Real
  end;

  TRealRect = packed record
    LeftBottom: TRealPoint;
    RightTop: TRealPoint
  end;

  TOctant = 0..7;

  TShapeEvent = procedure (Sender: TObject;
    AnUnicode: Word) of object;

  THex = 0..$F;


  TDrawShape = class
  private
    FCanvas: TCanvas;
    FDrawMode: Boolean;
    FLocation: TRealPoint;
    FLocationMem: TRealPoint;
    FScaleFactor: Real;
    function GetDrawMode: Boolean;
    function GetLocationMem: TRealPoint;
    function GetScaleFactor: Real;
    procedure DrawArc(StartAngle, EndAngle, Radius: Real);
    procedure SetDrawMode(const Value: Boolean);
    procedure SetLocationMem(const Value: TRealPoint);
    procedure SetScaleFactor(const Value: Real);
  public
    constructor Create(ACanvas: TCanvas);
    procedure Displace(XOffset, YOffset: Shortint);
    procedure DrawOctantArc(radius: Byte; CCW: Boolean;
      S, N: TOctant);
    procedure DrawFractionalArc(start_offset, end_offset: Byte;
      radius: Word; CCW: Boolean; S, N: TOctant);
    procedure DrawBulgeArc(X, Y: Shortint; Bulge: Shortint);
    procedure DrawVector(Length, Direction: Byte);
    procedure PopLocation;
    procedure PushLocation;
    property DrawMode: Boolean read GetDrawMode
      write SetDrawMode;
    property LocationMem: TRealPoint read GetLocationMem
      write SetLocationMem;
    property ScaleFactor: Real read GetScaleFactor
      write SetScaleFactor;
  end;

  TShapeProc = class
  private
    FDrawShape: TDrawShape;
    FOnSubShape: TShapeEvent;
    FPointer: PAnsiChar;
    FVerticalFlag: Boolean;
    procedure Displacement;
    procedure DivideVectorLength;
    procedure Vector;
    procedure MDisplacement;
    procedure MultiplyVectorLength;
    procedure OctantArc;
    procedure FractionalArc;
    procedure BulgeSpecifiedArc;
    procedure MBulgeSpecifiedArcs;
    procedure Pop;
    procedure Push;
    procedure TurnOffDrawMode;
    procedure TurnOnDrawMode;
    procedure SubShape;
    procedure VerticalFlag;
    function GetScaleFactor: Real;
    procedure SetScaleFactor(const Value: Real);
    function GetPosition: TRealPoint;
    procedure SetPosition(const Value: TRealPoint);
    procedure SetOnSubShape(const Value: TShapeEvent);
  public
    constructor Create(ACanvas: TCanvas);
    destructor Destroy; override;
    procedure BeginDraw(APointer: Pointer);
    property OnSubShape: TShapeEvent read FOnSubShape
      write SetOnSubShape;
    property Position: TRealPoint read GetPosition write SetPosition;
    property ScaleFactor: Real read GetScaleFactor write
      SetScaleFactor;
  end;

function RealPoint(const AX, AY: Real): TRealPoint;

implementation

uses SysUtils, Classes, Math;

const
  cos1Oct = 0.7071067811;
  OctToFactor: array[TOctant] of Single = (1,  cos1Oct, 0,
    -cos1Oct, -1, -cos1Oct, 0, cos1Oct);
  VectorDeltaX: array[THex] of Shortint = (4, 4, 4, 2, 0, -2,
    -4, -4, -4, -4, -4, -2, 0, 2, 4, 4);

function RealPointToPoint(const ARealPoint:
  TRealPoint): TPoint;
begin
  Result.X := Round(ARealPoint.AX);
  Result.Y := Round(ARealPoint.AY)
end;

function PointToRealPoint(const APoint: TPoint): TRealPoint;
begin
  with Result do
  begin
    AX := APoint.X;
    AY := APoint.Y
  end
end;

function RealRectToRect(const ARealRect: TRealRect): TRect;
begin
  with Result do
  begin
    TopLeft := RealPointToPoint(ARealRect.LeftBottom);
    BottomRight := RealPointToPoint(ARealRect.RightTop)
  end;
end;

function RealPoint(const AX, AY: Real): TRealPoint;
begin
  Result.AX := AX;
  Result.AY := AY
end;

procedure CorrectPoint(var ARealPoint: TRealPoint);
begin
  with ARealPoint do AY := -AY
end;

procedure CorrectRect(var ARealRect: TRealRect);
begin
  with ARealRect do
  begin
    CorrectPoint(LeftBottom);
    CorrectPoint(RightTop)
  end
end;

function RealRect(const ALeftBottom, ARightTop: TRealPoint): TRealRect;
begin
  with Result do
  begin
    LeftBottom := ALeftBottom;
    RightTop := ARightTop
  end;
end;

procedure FactorRealPoint(var ARealPoint: TRealPoint;
  AFactor: Real);
begin
  with ARealPoint do
  begin
    AX := AX * AFactor;
    AY := AY * AFactor
  end
end;

procedure FactorRealRect(var ARealRect: TRealRect;
  AFactor: Real);
begin
  with ARealRect do
  begin
    FactorRealPoint(LeftBottom, AFactor);
    FactorRealPoint(RightTop, AFactor)
  end
end;

function SumRealPoint(const RealPoint1: TRealPoint;
  const RealPoint2: TRealPoint): TRealPoint;
begin
  with Result do
  begin
    AX := RealPoint1.AX + RealPoint2.AX;
    AY := RealPoint1.AY + RealPoint2.AY
  end
end;

procedure DisplaceRealRect(var ARealRect: TRealRect;
  const ADisplace: TRealPoint);
begin
  with ARealRect do
  begin
    LeftBottom := SumRealPoint(ARealRect.LeftBottom,
      ADisplace);
    RightTop := SumRealPoint(ARealRect.RightTop,
      ADisplace)
  end
end;

function SumRealRect(const RealRect1: TRealRect;
  const RealRect2: TRealRect): TRealRect;
begin
  with Result do
  begin
    LeftBottom := SumRealPoint(RealRect1.LeftBottom,
      RealRect2.LeftBottom);
    RightTop := SumRealPoint(RealRect1.RightTop,
      RealRect2.RightTop)
  end
end;

function OctantCos(AOctant: Shortint): Real;
begin
  AOctant := AOctant and $07;
  Result := OctToFactor[AOctant]
end;

function OctantSin(AOctant: Shortint): Real;
begin
  AOctant := AOctant and $07;
  Result := OctantCos(AOctant - $2)        
end;

function OctArcCenter(AOctant: Shortint): TRealPoint;
begin
  with Result do
  begin
    AX := OctantCos(AOctant + $4);
    AY := OctantSin(AOctant + $4)
  end
end;

function ArcCenter(AnAngle: Real): TRealPoint;
begin
  with Result do
  begin
    AX := Cos(AnAngle + Pi);
    AY := Sin(AnAngle + Pi)
  end
end;

function HexToVectDeltaX(AHex: Shortint): Single;
begin
  AHex := AHex and  $0F;
  Result := VectorDeltaX[AHex] / 4
end;

{ TDrawShape }

constructor TDrawShape.Create(ACanvas: TCanvas);
begin
  FCanvas := ACanvas;
  FCanvas.FillRect(FCanvas.ClipRect);
  FDrawMode := True;
  FLocation := RealPoint(0, 0);
  FLocationMem := RealPoint(0, 0);
  FScaleFactor := 1
end;

procedure TDrawShape.Displace(XOffset, YOffset: Shortint);
var
  APoint: TPoint;
begin
  FCanvas.PenPos := RealPointToPoint(FLocation);
  FLocation.AX := FLocation.AX + XOffset * FScaleFactor;
  FLocation.AY := FLocation.AY - YOffset * FScaleFactor;
  if FDrawMode then
  begin
    APoint := RealPointToPoint(FLocation);  
    FCanvas.LineTo(APoint.X, APoint.Y)
  end
end;

procedure TDrawShape.DrawArc(StartAngle, EndAngle, Radius: Real);
var
  RPArcCenter, EndPointR: TRealPoint;
  RRArc: TRealRect;
  RectArc: TRect;
  StartPoint, EndPoint: TPoint;
  Factor: Real;
begin
  Factor := radius * FScaleFactor;

  RPArcCenter := ArcCenter(StartAngle);
  FactorRealPoint(RPArcCenter, Factor);
  CorrectPoint(RPArcCenter);
  RPArcCenter := SumRealPoint(RPArcCenter, FLocation);
  RRArc := RealRect(
    SumRealPoint(RPArcCenter, RealPoint(-Factor, -Factor)),
    SumRealPoint(RPArcCenter, RealPoint(Factor, Factor)));
  RectArc := RealRectToRect(RRArc);

  EndPointR := RealPoint(Cos(EndAngle), Sin(EndAngle));
  FactorRealPoint(EndPointR, radius * FScaleFactor);
  CorrectPoint(EndPointR);
  EndPointR := SumRealPoint(EndPointR, RPArcCenter);
  StartPoint := RealPointToPoint(FLocation);
  EndPoint := RealPointToPoint(EndPointR);

  FCanvas.Arc(RectArc.Left, RectArc.Top,
    RectArc.Right, RectArc.Bottom,
    StartPoint.X, StartPoint.Y,
    EndPoint.X, EndPoint.Y)
end;

procedure TDrawShape.DrawBulgeArc(X, Y: Shortint;
  Bulge: Shortint);
var
  AnAngle, AngleOffset, radius: Real;
  CCW: Boolean;
begin
  CCW := not (Bulge < 0);
  AnAngle := ArcTan2(Y, X) + Pi/2;
  if 2*(1/arctan(Bulge/127)) > pi/2 then
    AngleOffset := 2*(1/arctan(Bulge/127)) - pi
  else
    AngleOffset := Pi - 2*(1/arctan(Bulge/127));
  radius := Sqrt(sqr(x)+sqr(y))*sqrt(sqr(Bulge/127)+1)/2/2
    /cos(pi/2-AngleOffset/2);

  if not CCW then
  begin
    FLocation.AX := FLocation.AX + X * FScaleFactor;
    FLocation.AY := FLocation.AY - Y * FScaleFactor
  end;

  DrawArc(AnAngle + AngleOffset, AnAngle - AngleOffset,
      radius);

  if CCW then
  begin
    FLocation.AX := FLocation.AX + X * FScaleFactor;
    FLocation.AY := FLocation.AY - Y * FScaleFactor
  end
end;

procedure TDrawShape.DrawFractionalArc(
  start_offset, end_offset: Byte; radius: Word; CCW: Boolean;
  S, N: TOctant);
var
  N1: Shortint;
  RPArcCenter, EndPointR: TRealPoint;
  RRArc: TRealRect;
  RectArc: TRect;
  StartPoint, EndPoint: TPoint;
  Factor: Real;
begin
  if CCW then N1 := N else N1 := -N;

  Factor := radius * FScaleFactor;

  RPArcCenter := ArcCenter(S * pi/4 +
    start_offset / 256 * pi/4);
  FactorRealPoint(RPArcCenter, Factor);
  CorrectPoint(RPArcCenter);
  RPArcCenter := SumRealPoint(RPArcCenter, FLocation);
  RRArc := RealRect(
    SumRealPoint(RPArcCenter, RealPoint(-Factor, -Factor)),
    SumRealPoint(RPArcCenter, RealPoint(Factor, Factor)));
  RectArc := RealRectToRect(RRArc);

  EndPointR := RealPoint(Cos((S + N1) * pi/4 +
    end_offset / 256 * pi/4), Sin((S + N1) * pi/4 +
    end_offset / 256 * pi/4));
  FactorRealPoint(EndPointR, radius * FScaleFactor);
  CorrectPoint(EndPointR);
  EndPointR := SumRealPoint(EndPointR, RPArcCenter);
  if CCW then
  begin
    StartPoint := RealPointToPoint(FLocation);
    EndPoint := RealPointToPoint(EndPointR)
  end
  else begin
    StartPoint := RealPointToPoint(EndPointR);
    EndPoint := RealPointToPoint(FLocation)
  end;

  FCanvas.Arc(RectArc.Left, RectArc.Top,
    RectArc.Right, RectArc.Bottom,
    StartPoint.X, StartPoint.Y,
    EndPoint.X, EndPoint.Y);

  FLocation := EndPointR
end;

procedure TDrawShape.DrawOctantArc(radius: Byte; CCW: Boolean;
  S, N: TOctant);
var
  S1, N1: Shortint;
  RPArcCenter, EndPointR: TRealPoint;
  RRArc: TRealRect;
  RectArc: TRect;
  StartPoint, EndPoint: TPoint;
  Factor: Real;
begin
  S1 := S;
  if CCW then N1 := N else N1 := -N;

  Factor := radius * FScaleFactor;
  RPArcCenter := OctArcCenter(S1);
  FactorRealPoint(RPArcCenter, Factor);
  CorrectPoint(RPArcCenter);
  RPArcCenter := SumRealPoint(RPArcCenter, FLocation);
  RRArc := RealRect(
    SumRealPoint(RPArcCenter, RealPoint(-Factor, -Factor)),
    SumRealPoint(RPArcCenter, RealPoint(Factor, Factor)));
  RectArc := RealRectToRect(RRArc);

  EndPointR := RealPoint(OctantCos(S1 + N1), OctantSin(S1 + N1));
  FactorRealPoint(EndPointR, radius * FScaleFactor);
  CorrectPoint(EndPointR);
  EndPointR := SumRealPoint(EndPointR, RPArcCenter);
  if CCW then
  begin
    StartPoint := RealPointToPoint(FLocation);
    EndPoint := RealPointToPoint(EndPointR)
  end
  else begin
    StartPoint := RealPointToPoint(EndPointR);
    EndPoint := RealPointToPoint(FLocation)
  end;

  FCanvas.Arc(RectArc.Left, RectArc.Top,
    RectArc.Right, RectArc.Bottom,
    StartPoint.X, StartPoint.Y,
    EndPoint.X, EndPoint.Y);

  FLocation := EndPointR
end;

procedure TDrawShape.DrawVector(Length, Direction: Byte);
var
  APoint: TPoint;
begin
  FCanvas.PenPos := RealPointToPoint(FLocation);
  FLocation.AX := FLocation.AX + Length * FScaleFactor
    * HexToVectDeltaX(Direction);
  FLocation.AY := FLocation.AY - Length * FScaleFactor
    * HexToVectDeltaX(Direction - $4);
  if FDrawMode then
  begin
    APoint := RealPointToPoint(FLocation);  
    FCanvas.LineTo(APoint.X, APoint.Y)
  end
end;

function TDrawShape.GetDrawMode: Boolean;
begin
  Result := FDrawMode
end;

function TDrawShape.GetLocationMem: TRealPoint;
begin
  FLocation := FLocationMem
end;

function TDrawShape.GetScaleFactor: Real;
begin
  Result := FScaleFactor
end;

procedure TDrawShape.PopLocation;
begin
  FLocation := FLocationMem
end;

procedure TDrawShape.PushLocation;
begin
  FLocationMem := FLocation
end;

procedure TDrawShape.SetDrawMode(const Value: Boolean);
begin
  FDrawMode := Value
end;

procedure TDrawShape.SetLocationMem(const Value: TRealPoint);
begin
  FLocationMem := Value
end;

procedure TDrawShape.SetScaleFactor(const Value: Real);
begin
  FScaleFactor := Value
end;

{ TShapeProc }

procedure TShapeProc.BeginDraw(APointer: Pointer);
var
  BufChar: AnsiChar;
begin
  Inc(PChar(APointer), StrLen(PChar(APointer)) + 1);
  FPointer := APointer;
  while FPointer[0] <> #00 do
  begin
    BufChar := FPointer[0];
    case BufChar of
      #$01: TurnOnDrawMode;
      #$02: TurnOffDrawMode;
      #$03: DivideVectorLength;
      #$04: MultiplyVectorLength;
      #$05: Push;
      #$06: Pop;
      #$07: SubShape;
      #$08: Displacement;
      #$09: MDisplacement;
      #$0A: OctantArc;
      #$0B: FractionalArc;
      #$0C: BulgeSpecifiedArc;
      #$0D: MBulgeSpecifiedArcs;
      #$0E: VerticalFlag;
    else
      Vector
    end;
    Inc(FPointer)
  end
end;

procedure TShapeProc.BulgeSpecifiedArc;
begin
  if not FVerticalFlag then
    FDrawShape.DrawBulgeArc(Shortint(FPointer[1]),
      Shortint(FPointer[2]), Shortint(FPointer[3]));
  Inc(FPointer, 3);
  FVerticalFlag := False
end;

constructor TShapeProc.Create(ACanvas: TCanvas);
begin
  FDrawShape := TDrawShape.Create(ACanvas);
  FDrawShape.FDrawMode := True;
  FVerticalFlag := False
end;

destructor TShapeProc.Destroy;
begin
  FDrawShape.Free;
  FDrawShape := nil;
  inherited
end;

procedure TShapeProc.Displacement;
begin
  if not FVerticalFlag then
    FDrawShape.Displace(Shortint(FPointer[1]),
      Shortint(FPointer[2]));
  Inc(FPointer, 2);
  FVerticalFlag := False  
end;

procedure TShapeProc.DivideVectorLength;
begin
  if not FVerticalFlag then
    FDrawShape.ScaleFactor := FDrawShape.ScaleFactor
      / Byte(FPointer[1]);
  Inc(FPointer);
  FVerticalFlag := False
end;

procedure TShapeProc.FractionalArc;
begin
  if not FVerticalFlag then
    FDrawShape.DrawFractionalArc(Byte(FPointer[1]),
      Byte(FPointer[2]), Word(FPointer[4]),
      not ((Byte(FPointer[5]) and $80) = $80),
      ((Byte(FPointer[5]) and $70) shr 4),
      (Byte(FPointer[5]) and $07));
  Inc(FPointer, 5);
  FVerticalFlag := False
end;

function TShapeProc.GetPosition: TRealPoint;
begin
  Result := FDrawShape.FLocation
end;

function TShapeProc.GetScaleFactor: Real;
begin
  Result := FDrawShape.ScaleFactor
end;

procedure TShapeProc.MBulgeSpecifiedArcs;
begin
  while not ((FPointer[1] = #00) and (FPointer[2] = #00)) do
  begin
    if not FVerticalFlag then
      FDrawShape.DrawBulgeArc(Shortint(FPointer[1]),
        Shortint(FPointer[2]), Shortint(FPointer[3]));
    Inc(FPointer, 3)
  end;
  Inc(FPointer, 2);
  FVerticalFlag := False
end;

procedure TShapeProc.MDisplacement;
begin
  while not ((FPointer[1] = #00) and (FPointer[2] = #00)) do
  begin
    if not FVerticalFlag then
      FDrawShape.Displace(Shortint(FPointer[1]),
        Shortint(FPointer[2]));
    Inc(FPointer, 2)
  end;
  Inc(FPointer, 2);
  FVerticalFlag := False  
end;

procedure TShapeProc.MultiplyVectorLength;
begin
  if not FVerticalFlag then
    FDrawShape.ScaleFactor := FDrawShape.ScaleFactor
      * Byte(FPointer[1]);
  Inc(FPointer);
  FVerticalFlag := False
end;

procedure TShapeProc.OctantArc;
begin
  if not FVerticalFlag then
    FDrawShape.DrawOctantArc(Byte(FPointer[1]),
      not ((Byte(FPointer[2]) and $80) = $80),
      ((Byte(FPointer[2]) and $70) shr 4),
      (Byte(FPointer[2]) and $07));
  Inc(FPointer, 2);
  FVerticalFlag := False
end;

procedure TShapeProc.Pop;
begin
  if not FVerticalFlag then
    FDrawShape.PopLocation;
  FVerticalFlag := False
end;

procedure TShapeProc.Push;
begin
  if not FVerticalFlag then
    FDrawShape.PushLocation;
  FVerticalFlag := False
end;

procedure TShapeProc.SetOnSubShape(const Value: TShapeEvent);
begin
  FOnSubShape := Value
end;

procedure TShapeProc.SetPosition(const Value: TRealPoint);
begin
  FDrawShape.FLocation := Value
end;

procedure TShapeProc.SetScaleFactor(const Value: Real);
begin
  FDrawShape.ScaleFactor := Value
end;

procedure TShapeProc.SubShape;
var
  BufPointer: PAnsiChar;
  PUnicode: ^Word;
  AnUnicode: Word;
begin
  if not FVerticalFlag then
  begin
    BufPointer := FPointer;
    Inc(FPointer);
    Pointer(PUnicode) := Pointer(FPointer);
    AnUnicode := Swap(PUnicode^);
    if Assigned(FOnSubShape) then
      FOnSubShape(Self, AnUnicode);
    FPointer := BufPointer;
  end;
  Inc(FPointer, 2);
  FVerticalFlag := False
end;

procedure TShapeProc.TurnOffDrawMode;
begin
  if not FVerticalFlag then
    FDrawShape.DrawMode := False;
  FVerticalFlag := False
end;

procedure TShapeProc.TurnOnDrawMode;
begin
  if not FVerticalFlag then
    FDrawShape.DrawMode := True;
  FVerticalFlag := False
end;

procedure TShapeProc.Vector;
begin
  if not FVerticalFlag then
    FDrawShape.DrawVector(((Byte(FPointer[0]) and $F0) shr 4),
      (Byte(FPointer[0]) and $0F));
  FVerticalFlag := False
end;

procedure TShapeProc.VerticalFlag;
begin
  FVerticalFlag := True
end;

end.
