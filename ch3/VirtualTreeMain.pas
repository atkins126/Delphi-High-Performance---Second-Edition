unit VirtualTreeMain;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  VirtualTrees.Types, VirtualTrees;

type
  TfrmVTV = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    lblLog10k: TLabel;
    lblLogAdd100: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure Button2Click(Sender: TObject);
    procedure VirtualStringTree3InitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VirtualStringTree3GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure VirtualStringTree2GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
  private
    VirtualStringTree1: TVirtualStringTree;
    VirtualStringTree2: TVirtualStringTree;
    VirtualStringTree3: TVirtualStringTree;
    FModel1, FModel2, FModel3: TStringList;
    procedure CreateComponents;
  public
  end;

var
  frmVTV: TfrmVTV;

implementation

uses
  System.Diagnostics;

{$R *.dfm}

procedure TfrmVTV.Button1Click(Sender: TObject);
var
  swLB, swVTV1, swVTV2, swVTV3: TStopwatch;
  i, idx: Integer;
begin
  swLB := TStopwatch.StartNew;
  ListBox1.Items.BeginUpdate;
  for i := 1 to 10000 do
    ListBox1.Items.Add('Line ' + IntToStr(i));
  ListBox1.Items.EndUpdate;
  swLB.Stop;

  swVTV1 := TStopwatch.StartNew;
  VirtualStringTree1.BeginUpdate;
  for i := 1 to 10000 do begin
    idx := FModel1.Add('Line ' + IntToStr(i));
    VirtualStringTree1.AddChild(nil, pointer(idx));
  end;
  VirtualStringTree1.EndUpdate;
  swVTV1.Stop;

  swVTV2 := TStopwatch.StartNew;
  VirtualStringTree2.BeginUpdate;
  for i := 1 to 10000 do begin
    idx := FModel2.Add('Line ' + IntToStr(i));
    VirtualStringTree2.AddChild(nil, pointer(idx));
  end;
  VirtualStringTree2.EndUpdate;
  swVTV2.Stop;

  swVTV3 := TStopwatch.StartNew;
  for i := 1 to 10000 do
    FModel3.Add('Line ' + IntToStr(i));
  VirtualStringTree3.RootNodeCount :=
    VirtualStringTree3.RootNodeCount + 10000;
  VirtualStringTree3.EndUpdate;
  swVTV3.Stop;

  lblLog10k.Caption := Format(
    'Listbox: %d ms; Virtual TreeView: %d ms; VTV -autoSort: %d ms; VTV +OnInit: %d',
    [swLB.ElapsedMilliseconds, swVTV1.ElapsedMilliseconds,
     swVTV2.ElapsedMilliseconds, swVTV3.ElapsedMilliseconds]);
  lblLog10k.Visible := true;
end;

procedure TfrmVTV.Button2Click(Sender: TObject);
var
  swLB, swVTV1, swVTV2, swVTV3: TStopwatch;
  i, idx: Integer;
begin
  swLB := TStopwatch.StartNew;
  for i := 1 to 100 do
    ListBox1.Items.Add('Line ' + IntToStr(i));
  swLB.Stop;

  swVTV1 := TStopwatch.StartNew;
  for i := 1 to 100 do begin
    idx := FModel1.Add('Line ' + IntToStr(i));
    VirtualStringTree1.AddChild(nil, pointer(idx));
  end;
  swVTV1.Stop;

  swVTV2 := TStopwatch.StartNew;
  for i := 1 to 100 do begin
    idx := FModel2.Add('Line ' + IntToStr(i));
    VirtualStringTree2.AddChild(nil, pointer(idx));
  end;
  swVTV2.Stop;

  swVTV3 := TStopwatch.StartNew;
  for i := 1 to 100 do begin
    FModel3.Add('Line ' + IntToStr(i));
    VirtualStringTree3.RootNodeCount := VirtualStringTree3.RootNodeCount + 1;
  end;
  swVTV3.Stop;

  lblLogAdd100.Caption := Format(
    'Listbox: %d ms; Virtual TreeView: %d ms; VTV -autoSort: %d ms; VTV +OnInit: %d',
    [swLB.ElapsedMilliseconds, swVTV1.ElapsedMilliseconds,
     swVTV2.ElapsedMilliseconds, swVTV3.ElapsedMilliseconds]);
  lblLogAdd100.Visible := true;
end;

procedure TfrmVTV.CreateComponents;
var
  spacing: integer;
begin
  spacing := (ClientWidth - ListBox1.Left * 2 - ListBox1.Width * 4) div 3;

  VirtualStringTree1 := TVirtualStringTree.Create(Self);
  with VirtualStringTree1 do
  begin
    Name := 'VirtualStringTree1';
    Parent := Self;
    Left := ListBox1.Left + ListBox1.Width + spacing;
    Top := ListBox1.Top;
    Width := ListBox1.Width;
    Height := ListBox1.Height;
    NodeDataSize := 4;
    TabOrder := 0;
    OnGetText := VirtualStringTree1GetText;
  end;

  VirtualStringTree2 := TVirtualStringTree.Create(Self);
  with VirtualStringTree2 do
  begin
    Name := 'VirtualStringTree2';
    Parent := Self;
    Left := VirtualStringTree1.Left + VirtualStringTree1.Width + spacing;
    Top := ListBox1.Top;
    Width := ListBox1.Width;
    Height := ListBox1.Height;
    NodeDataSize := 4;
    TabOrder := 3;
    OnGetText := VirtualStringTree2GetText;
  end;

  VirtualStringTree3 := TVirtualStringTree.Create(Self);
  with VirtualStringTree3 do
  begin
    Name := 'VirtualStringTree3';
    Parent := Self;
    Left := VirtualStringTree2.Left + VirtualStringTree2.Width + spacing;
    Top := ListBox1.Top;
    Width := ListBox1.Width;
    Height := ListBox1.Height;
    NodeDataSize := 4;
    TabOrder := 3;
    OnGetText := VirtualStringTree3GetText;
    OnInitNode := VirtualStringTree3InitNode;
  end;
end;

procedure TfrmVTV.FormCreate(Sender: TObject);
begin
  CreateComponents;
  FModel1 := TStringList.Create;
  FModel2 := TStringList.Create;
  FModel3 := TStringList.Create;
end;

procedure TfrmVTV.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FModel1);
  FreeAndNil(FModel2);
  FreeAndNil(FModel3);
end;

procedure TfrmVTV.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  CellText := FModel1[PInteger(Node.GetData)^];
end;

procedure TfrmVTV.VirtualStringTree2GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  CellText := FModel2[PInteger(Node.GetData)^];
end;

procedure TfrmVTV.VirtualStringTree3GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  CellText := FModel3[PInteger(Node.GetData)^];
end;

procedure TfrmVTV.VirtualStringTree3InitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.SetData(pointer(Node.Index));
end;

end.
