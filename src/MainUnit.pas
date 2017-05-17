unit MainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms3D, FMX.Types3D, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, System.Math.Vectors, FMX.Objects3D, FMX.Controls3D, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layers3D, FMX.MaterialSources,
  FMX.Layouts, FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.Menus;

type
  TForm1 = class(TForm3D)
    Layer3D1: TLayer3D;
    DummyXY: TDummy;
    MainCamera: TCamera;
    Light1: TLight;
    WallSource: TLightMaterialSource;
    Button1: TButton;
    ListView1: TListView;
    RadioButton1: TRadioButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
    TextLayer3D1: TTextLayer3D;
    procedure Form3DMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Form3DMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure Button1Click(Sender: TObject);
    procedure Form3DMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure Button2Click(Sender: TObject);

  private
    { Private declarations }
    Procedure CubedblClick(Sender : TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  FDown : TPointF;
  popupXY : TPointF;
  isCameraMode : Boolean = True;
  CubeNum : integer = 0;

implementation

{$R *.fmx}
Procedure Zoom(Const camera : TCamera;Const checkwheel: Boolean);
begin
 if checkwheel = True then begin
   camera.Position.Z := camera.Position.Z + 1;
 end
 else begin
   camera.Position.Z := camera.Position.Z - 1;
 end;

end;

Procedure updateList(Listview:TListview);
var
 ListItemadd : TListViewItem;
 i : integer;
begin
 Listview.BeginUpdate;
 Listview.Items.Clear;
 try
    for i := 0 to Form1.ComponentCount - 1 do begin
      if (Form1.Components[i] is TCube) then begin
        ListItemadd := Listview.Items.Add;
        ListItemadd.Text := Form1.Components[i].Name;
      end;
    end;
 finally
   Listview.EndUpdate;
 end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 DummyXY.RotationAngle.X := 0;
 DummyXY.RotationAngle.Y := 0;
 MainCamera.Position.X := 0;
 MainCamera.Position.Y := 0;
 MainCamera.Position.Z := -10;
end;

Procedure Tform1.CubedblClick(Sender: TObject);
begin
 if sender <> nil then begin
  Form1.BeginUpdate;
  try
    (Sender as TCube).Free;
    updateList(Listview1);
  finally
    Form1.EndUpdate;;
  end;
 end;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 Try
     with TCube.Create(form1) do begin
       Visible := True;
       Parent := form1;
       Position.X := strtoint(Edit1.text);
       Position.Y := strtoint(Edit2.text);
       Position.Z := strtoint(Edit3.text);
       MaterialSource := WallSource;
       Name := 'Cube' + inttostr(CubeNum);
       OnDblClick := CubedblClick;
       inc(CubeNum);
     end;
 Finally
    UpdateList(ListView1);
 End;
end;

procedure TForm1.Form3DMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  FDown := PointF(X, Y);

  if button = TMouseButton.mbRight then
  begin
   isCameramode := not isCameraMode;

   if isCameraMode then
   begin
      TextLayer3D1.Text := 'Now mouse Event Type :  Dummy XY Type';
   end
   else if not isCameraMode then begin
      TextLayer3D1.Text := 'Now mouse Event Type :  Camera XY Type';
   end;

  end;

end;

procedure TForm1.Form3DMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
 if ssLeft in Shift then begin
   if isCameraMode = True then begin
      DummyXY.RotationAngle.X := DummyXY.RotationAngle.X - (Y - FDown.Y);
      DummyXY.RotationAngle.Y := DummyXY.RotationAngle.Y + (X - FDown.X);
      FDown := PointF(X, Y);
   end
   else if not isCameraMode then begin
      MainCamera.Position.X := MainCamera.Position.X + ((X - FDOWN.X) * 0.05);
      FDown := PointF(X,Y);
   end;
 end;
end;

procedure TForm1.Form3DMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
 Zoom(Maincamera,WheelDelta > 0);
end;

end.
