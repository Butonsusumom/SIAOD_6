unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, math;

type
  TForm1 = class(TForm)
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    tv1: TTreeView;
    lbl1: TLabel;
    btn4: TButton;
    Button1: TButton;
    btn5: TButton;
    lbl2: TLabel;
    btn6: TButton;
    btn7: TButton;
    edt1: TEdit;
    btn8: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  N = 10;
  sl=300;


type
  TPNode = ^PNode;

  PNode = record
    Info, number: integer;
    Pleft, Pright,Parent: TPNode;
    Thread:TPNode;
    Flag:boolean;
  end;

  mnoj = set of 0..255;

var
  Form1: TForm1;
  num: Integer;
  tree,fpar: TPNode;
  kek: TTreeNode;
  buf: array[0..255] of string;
  buf1: array[0..255] of string;
  buf2: array[0..255] of string;
  array_coord: array[0..255, 0..2] of Integer;
  // |elem|   0,0 ...
  // ------
  // | x  |   0,1 ...
  // ------
  // | y  |   0,2 ...
  counter: integer;
  mnojestvo: mnoj;
  number:integer;

  j: byte;

implementation

{$R *.dfm}

            procedure PunktLineTo(x0,y0:Integer;x,y:Integer; Canvas:TCanvas);
var
  x1,y1,x2,y2,i:Integer;
begin
  //Идём от левого к правому
  if x>x0 then
  begin
    x1:=x0; y1:=y0;
    x2:=x;  y2:=y;
  end
  else
  begin
    x1:=x;  y1:=y;
    x2:=x0; y2:=y0;
  end;


  //Часть по оси 0x
  i:=x1;
  while i<=x2 do
  begin
   Canvas.MoveTo(i,y1);
    Canvas.LineTo(i+5,y1);
    i:=i+10;
  end;

  //Часть по оси 0y
  i:=y1;
  if y1 > y2 then
    while i>=y2 do
    begin
      Canvas.MoveTo(x2,i);
      Canvas.LineTo(x2,i-5);
      i:=i-10;
    end
  else
    while i<=y2 do
    begin
      Canvas.MoveTo(x2,i);
     Canvas.LineTo(x2,i+5);
      i:=i+10;
    end;
end;



 function Proshivka( El:TPNode):string;
var
  prev:TPNode;
  //Рекурсивны вызов. Сама прошивка  и обход
  function Sim( El:TPNode):string;
   begin
    if El = nil then
    begin
      Result:='0 ';
      Exit;
    end;

    Result:=IntToStr(El^.Info) + ' ';
    //Левое поддерево
    Result:=Result+Sim(El^.PLeft);
    Result:=Result + '('+IntToStr(El^.Info) + ')' + ' ';


       //Прошивка
    if (prev^.PRight = nil) or (prev^.Flag = true) then
    begin
      prev^.Flag:=True; //Нить
      new(prev^.Thread);
      prev^.Thread:=El;    //Указываем на текущий
      //PunktLineTo(array_coord[prev^.number][1]+20,array_coord[prev^.number][2],array_coord[prev^.number][1],array_coord[prev^.number][2]+20,Canvas);
    end
    else
      prev^.Flag:=False; //Занято - не нить
    prev:=El;

   

    //Правое поддерево
    if Not El^.Flag then
    begin
      Result:=Result+Sim(El^.PRight);
      Result:=Result+IntToStr(El^.Info)+ ' ';
    end
    else
      Result:=Result + '0 ' + IntToStr(El^.Info)+ ' ';


  end;
begin
      prev:=El^.PLeft; //начальное знаение предыдущёёго элемента
  Result:=Sim(El^.PLeft);  //Сама прошвка и обход    //Если надо - заводим линию на голову из последнего элемента
  if (prev^.PRight = nil) then
  begin
    prev^.Flag:=True; //Нить
    prev^.Thread:=El;    //Указываем на текущий
   // PunktLineTo(array_coord[prev^.number][1]+20,array_coord[prev^.number][2],10,array_coord[prev^.number][2],Canvas); //Линию в парвую часть экрана
    //PunktLineTo(10,array_coord[prev^.number][2],array_coord[prev^.number][1],array_coord[prev^.number][2]+20,Canvas);
  end;


  prev:=El^.PRight;
  Result:=Result+Sim(El^.PRight);
  if (prev^.PRight = nil) then
  begin
    prev^.Flag:=True; //Нить
    prev^.Thread:=El;    //Указываем на текущий
   // PunktLineTo(array_coord[prev^.number][1]+20,array_coord[prev^.number][2],10,array_coord[prev^.number][2],Canvas); //Линию в парвую часть экрана
    //PunktLineTo(10,array_coord[prev^.number][2],array_coord[prev^.number][1],array_coord[prev^.number][2]+20,Canvas);
  end;

  
end;



 function TreeDepth(tree: TPNode): byte;
begin
  if (tree = nil) then
    TreeDepth := 0
  else
    TreeDepth := 1 + max(TreeDepth(tree^.Pleft), TreeDepth(tree^.pright));
end;

function find(const p: TPNode; x: integer;Rect:TRect;Canvas: TCanvas; mode: Integer):TPNode;
var M,H,D,Radius:integer;
R: TRect;
begin
  Radius:=20;
  if p <> nil then
  begin
    M := (Rect.Left + Rect.Right) div 2;
    H := Rect.Top;
    D := Abs(Rect.Bottom - Rect.Top) div TreeDepth(p);
    with Canvas do
    begin
      if p^.info=x then
      begin
      Pen.Color := $000000;
      Pen.Width := 2;

      Brush.Color := clGreen;
       // Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
       Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
       Sleep(sl);

      Brush.Color := clWhite;
      //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
      Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
      IntToStr(p^.info));
      Form1.Update;
      end;
    end;
   end;

  if ((p=nil) or (x=p^.Info)) then result:=p;

      R.Left := Rect.Left;
      R.Right := M;
      R.Top := H + D;
      R.Bottom := Rect.Bottom;
      if  p<>nil then
  if  x<p^.Info then result:=find(p^.Pleft,x,R,Canvas, 0);

      R.Left := M;
      R.Right := Rect.Right;
      R.Top := H + D;
      R.Bottom := Rect.Bottom;
      if  p<>nil then
  if  x>p^.Info then result:=find(p^.Pright,x,R,Canvas,0);

end;

procedure AddToTree(var phead,parent: TPNode; x, number: integer);
var
  flag: boolean;
begin
  flag := True;
  if phead = nil then
  begin
    new(phead);
    phead^.Info := x;
    phead^.number := number;
    phead^.Pleft := nil;
    phead^.Pright := nil;
    phead^.parent := parent;
    phead^.Thread := nil;
    phead^.Flag:=False;
    flag := False;
  end;
  if flag = True then
  begin
    if x < phead^.Info then
      AddToTree(phead^.Pleft,phead, x, number)
    else
      AddToTree(phead^.Pright,phead, x, number);
  end;
end;

procedure writeTree(phead: TPnode);
begin
  if phead <> nil then
  begin
    writetree(phead^.Pleft);
    write(phead^.Info: 4);
    writetree(phead^.Pright);
  end;
end;

function height12(phead: TPnode): integer;
var
  l, r: integer;
begin
  if (phead <> nil)  then
  begin
    l := height12(phead^.Pleft);
    r := height12(phead^.Pright);
    if l > r then
      height12 := l + 1
    else
      height12 := r + 1
  end
  else
    height12 := 0;
end;

function getpath(phead: TPNode): string;
begin
  if phead <> nil then
  begin
    if height12(phead^.Pleft) > height12(phead^.Pright) then
      getpath := IntToStr(phead^.info) + ' ' + getpath(phead^.Pleft)
    else
      getpath := IntToStr(phead^.info) + ' ' + getpath(phead^.Pright)
  end
  else
    getpath := '';
end;

procedure TreeFree(var aPNode: TPNode);
begin
  if aPNode = nil then
    Exit;
  TreeFree(aPNode^.PLeft);
  {Рекурсивный вызов для освобождения памяти в левой ветви.}
  TreeFree(aPNode^.PRight);
  {Рекурсивный вызов для освобождения памяти в правой ветви.}
  Dispose(aPNode); {Освобождение памяти, занятой для текущего узла.}
  aPNode := nil; {Обнуление указателя на текущий узел.}
end;

procedure PrintTree(treenode: TTreeNode; root: TPNode);
var
  newnode: TTreeNode;
begin
  if Assigned(root) then
    with Form1 do
    begin
      newnode := tv1.Items.AddChild(treenode, inttostr(root^.info));
      PrintTree(newnode, root^.PLeft);
      PrintTree(newnode, root^.PRight);
    end;
end;



procedure drawdot(x, y, m: Integer; canvas: TCanvas);
begin
  if m = 0 then
    canvas.Pixels[x, y] := clRed
  else
    canvas.Pixels[x, y] := clGreen;

end;

//прямой

procedure TreeWritelnD(const aPNode: TPNode);
begin
  if aPNode = nil then
  begin
    buf[j] := '0';
    Inc(j);
    Exit;
  end;

  buf[j] := '(' + inttostr(aPNode^.info) + ')';
  Inc(j);
  Include(mnojestvo, aPnode^.Info);
  TreeWritelnD(aPNode^.PLeft);
 // if((aPNode^.PLeft<>nil)and(aPNode^.Pright<>nil))    then
  //begin
  buf[j] := IntToStr(aPnode^.info);
  Inc(j);
 // end;
  TreeWritelnD(aPNode^.PRight);
 // if((aPNode^.PLeft<>nil)and(aPNode^.Pright<>nil))  then
 // begin
  buf[j] := IntToStr(aPnode^.info);
  Inc(j);
 // end;
end;

//обратный

procedure TreeWritelnR(const aPNode: TPNode);
var
  lol: Byte;
begin
  if aPNode = nil then
  begin
    buf1[j] := '0';
    Inc(j);
    Exit;
  end;
 // if((aPNode^.PLeft<>nil)and(aPNode^.Pright<>nil))    then
//  begin
  buf1[j] := IntToStr(aPnode^.info);
  Inc(j);
 // end;
  TreeWritelnR(aPNode^.PLeft);

  buf1[j] := '(' + IntToStr(aPnode^.info) + ')';
  Inc(j);
  Include(mnojestvo, aPnode^.Info);

  TreeWritelnR(aPNode^.PRight);
  //if((aPNode^.PLeft<>nil)and(aPNode^.Pright<>nil))    then
 // begin
  buf1[j] := IntToStr(aPnode^.info);
  Inc(j);
 // end;

end;

//симметричный

procedure TreeWritelnS(const aPNode: TPNode);
begin
  if aPNode = nil then
  begin
    buf2[j] := '0';
    Inc(j);
    Exit;
  end;
 // if((aPNode^.PLeft<>nil)and(aPNode^.Pright<>nil))    then
 // begin
  buf2[j] := IntToStr(aPnode^.info);
  Inc(j);
 // end;
  TreeWritelnS(aPNode^.PLeft);
 // if((aPNode^.PLeft<>nil)and(aPNode^.Pright<>nil))    then
 // begin
  buf2[j] := IntToStr(aPnode^.info);
  Inc(j);
 // end;

  TreeWritelnS(aPNode^.PRight);

  buf2[j] := '(' + IntToStr(aPnode^.info) + ')';
  Inc(j);
  Include(mnojestvo, aPnode^.Info);

end;

procedure DrawTree(Tree: TPNOde; Rect: TRect; Canvas: TCanvas;x,y:integer);
const
  Radius = 20;
var
  M, H, D: Word;
var
  R: TRect;
begin



  if (Tree <> nil)and(TreeDepth(Tree)<>0) then
  begin
    M := (Rect.Left + Rect.Right) div 2;
    H := Rect.Top;
    D := Abs(Rect.Bottom - Rect.Top) div TreeDepth(Tree);
    with Canvas do
    begin
      Pen.Color := $000000;
      Pen.Width := 2;
      Brush.Color := clWhite;
       x:=M;
      y:=H;
      LineTo(M, H);
     if (Tree^.Flag) then
        begin
           Pen.Color := clRed;
           x:=M;
           y:=H;
           //LineTo(M, H);
           PunktLineTo(array_coord[Tree^.number][1],array_coord[Tree^.number][2],array_coord[Tree^.Thread^.number][1],array_coord[Tree^.Thread^.number][2]+20,Canvas);
           Pen.Color := $000000;

        end;

      
      array_coord[Tree^.number][0]:=Tree^.number;
      array_coord[Tree^.number][1]:=M;
      array_coord[Tree^.number][2]:=H;

      //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
      Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
        IntToStr(Tree.info));
    end;
    Canvas.MoveTo(M, H + radius);
    x:=M;
    y:=H + radius;
    if Tree^.Pleft <> nil then
    begin
      R.Left := Rect.Left;
      R.Right := M;
      R.Top := H + D;
      R.Bottom := Rect.Bottom;
      //Sleep(500);
      DrawTree(Tree^.Pleft, R, Canvas,x,y);
    end;
    Canvas.MoveTo(M, H + radius);
    x:=M;
    y:=H + radius;
    if Tree^.Pright <> nil then
    begin
      R.Left := M;
      R.Right := Rect.Right;
      R.Top := H + D;
      R.Bottom := Rect.Bottom;
      //Sleep(500);
      DrawTree(Tree^.Pright, R, Canvas,x,y);
    end;
  end;
end;

procedure lightnigh1(Tree: TPNode; Rect: Trect; Canvas: TCanvas; mode: Integer);
const
  Radius = 20;
var
  M, H, D: Word;
var
  R: TRect;
begin

  if Tree <> nil then
  begin
    M := (Rect.Left + Rect.Right) div 2;
    H := Rect.Top;
    D := Abs(Rect.Bottom - Rect.Top) div TreeDepth(Tree);
    with Canvas do
    begin
      Pen.Color := $000000;
      Pen.Width := 2;

      Brush.Color := clGreen;
     // Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
     Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      Sleep(sl);

      Brush.Color := clWhite;
      //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
      Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
        IntToStr(Tree.info));
      Form1.Update;

    end;
    if tree.Pleft <> nil then
    begin
      R.Left := Rect.Left;
      R.Right := M;
      R.Top := H + D;
      R.Bottom := Rect.Bottom;
      Sleep(sl);
      lightnigh1(Tree^.Pleft, R, Canvas, mode);
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clRed;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
       // Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
       Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;
    end
    else
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clYellow;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
       // Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
       Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;

    if tree.Pright <> nil then
    begin
      R.Left := M;
      R.Right := Rect.Right;
      R.Top := H + D;
      R.Bottom := Rect.Bottom;
      Sleep(sl);
      lightnigh1(Tree^.Pright, R, Canvas, mode);
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clRed;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;
    end
    else
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clYellow;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;

  end;

end;

procedure lightnigh2(Tree: TPNode; Rect: Trect; Canvas: TCanvas; mode: Integer);
const
  Radius = 20;
var
  M, H, D: Word;
var
  R: TRect;
begin

  if Tree <> nil then
  begin
    M := (Rect.Left + Rect.Right) div 2;
    H := Rect.Top;
    D := Abs(Rect.Bottom - Rect.Top) div TreeDepth(Tree);
    with Canvas do
    begin
      Pen.Color := $000000;
      Pen.Width := 2;

      Brush.Color := clRed;
     // Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
     Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      Sleep(sl);

      Brush.Color := clWhite;
      //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
      Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
        IntToStr(Tree.info));
      Form1.Update;

    end;
    if tree.Pleft <> nil then
    begin
      R.Left := Rect.Left;
      R.Right := M;
      R.Top := H + D;
      R.Bottom := Rect.Bottom;
      Sleep(sl);
      lightnigh2(Tree^.Pleft, R, Canvas, mode);
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clGreen;
       // Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
       Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;
    end
    else
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clYellow;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;
    with Canvas do
    begin
      Pen.Color := $000000;
      Pen.Width := 2;
      Brush.Color := clGreen;
     // Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
     Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      Sleep(sl);

      Brush.Color := clWhite;
     // Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
     Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
        IntToStr(Tree.info));
      Form1.Update;

    end;
    if tree.Pright <> nil then
    begin
      R.Left := M;
      R.Right := Rect.Right;
      R.Top := H + D;
      R.Bottom := Rect.Bottom;
      Sleep(sl);
      lightnigh2(Tree^.Pright, R, Canvas, mode);
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clRed;
       // Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
       Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;
    end
    else
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clYellow;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;

  end;
end;

procedure lightnigh3(Tree: TPNode; Rect: Trect; Canvas: TCanvas; mode: Integer);
const
  Radius = 20;
var
  M, H, D: Word;
var
  R: TRect;
begin

  if Tree <> nil then
  begin
    M := (Rect.Left + Rect.Right) div 2;
    H := Rect.Top;
    D := Abs(Rect.Bottom - Rect.Top) div TreeDepth(Tree);
    with Canvas do
    begin
      Pen.Color := $000000;
      Pen.Width := 2;
      Brush.Color := clRed;
     // Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
     Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      Sleep(sl);

      Brush.Color := clWhite;
      //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
      Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
        IntToStr(Tree.info));
      Form1.Update;

    end;
    if tree.Pleft <> nil then
    begin
      R.Left := Rect.Left;
      R.Right := M;
      R.Top := H + D;
      R.Bottom := Rect.Bottom;
      Sleep(sl);
      lightnigh3(Tree^.Pleft, R, Canvas, mode);
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clRed;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;
    end
    else
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clYellow;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;

    if tree.Pright <> nil then
    begin
      R.Left := M;
      R.Right := Rect.Right;
      R.Top := H + D;
      R.Bottom := Rect.Bottom;
      Sleep(sl);
      lightnigh3(Tree^.Pright, R, Canvas, mode);
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clRed;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;
    end
    else
      with Canvas do
      begin
        Pen.Color := $000000;
        Pen.Width := 2;

        Brush.Color := clYellow;
       // Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
       Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        Sleep(sl);

        Brush.Color := clWhite;
        //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
        Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
        TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
          IntToStr(Tree.info));
        Form1.Update;

      end;

    with Canvas do
    begin
      Pen.Color := $000000;
      Pen.Width := 2;

      Brush.Color := clGreen;
      //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
      Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      Sleep(sl);

      Brush.Color := clWhite;
      //Ellipse(M - Radius, H - Radius, M + Radius, H + Radius);
      Rectangle(M - Radius,H - Radius,M +Radius,H + Radius);
      TextOut(M - (Radius div 2) + 2, H - (Radius div 2) + 2,
        IntToStr(Tree.info));
      Form1.Update;

    end;
  end;
end;






procedure TForm1.btn1Click(Sender: TObject);
var
  k: Integer;
  lel: TComponent;
  rectangle: TRect;
  rectangl: TRect;
begin
  Form1.Repaint;
  k := height12(tree);


  rectangle := Rect(10, 30, 657, 529);
  Form1.Canvas.MoveTo(((rectangle.Left + rectangle.Right) div 2),
    rectangle.Top);
  DrawTree(tree, rectangle, Canvas,(rectangle.Left + rectangle.Right) div 2,rectangle.Top);


  
  Form1.Repaint;
  k := height12(tree);
  rectangle := Rect(10, 30, 657, 529);
  Form1.Canvas.MoveTo(((rectangle.Left + rectangle.Right) div 2),
    rectangle.Top);
  DrawTree(tree, rectangle, Canvas,(rectangle.Left + rectangle.Right) div 2,rectangle.Top);
 //  rectangl := Rect(0, 0, 657, 529);
 // Canvas.fillrect(rectangl);
 // DrawTree(tree, rectangle, Canvas,(rectangle.Left + rectangle.Right) div 2,rectangle.Top);
  //mnojestvo := mnojestvo - mnojestvo;
  //TreeWritelnD(tree);
  //lightnigh1(tree, rectangle, Canvas, 0);
  //Sleep(1000);
 //mnojestvo := mnojestvo - mnojestvo;
  //TreeWritelnS(tree);
  //lightnigh2(tree, rectangle, Canvas, 0);
  //mnojestvo := mnojestvo - mnojestvo;
  //TreeWritelnR(tree);
  //lightnigh3(tree, rectangle, Canvas, 0);
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  fileofnode: Textfile;
  x: Integer;
  i: byte;
  text:integer;
  flag:boolean;
begin
  text:=0;
  flag:=true;
    for i:= 1 to Length(edt1.text) do
     begin
       if flag then
       begin
          if ((edt1.text[i]='0')or(edt1.text[i]='1')or(edt1.text[i]='2')or(edt1.text[i]='3')or(edt1.text[i]='4')or(edt1.text[i]='5') or(edt1.text[i]='6') or(edt1.text[i]='7') or(edt1.text[i]='8')or(edt1.text[i]='9'))
          then  text:=10*text+StrToInt(edt1.text[i])
          else
           begin
            ShowMessage('Uncorrect input');
            flag:=false;
            end;
       end;

     end;
 if flag then
 fpar:=nil;
    AddToTree(tree,fpar,text, number);
    Inc(number);

end;

procedure TForm1.btn3Click(Sender: TObject);
var
  aowner: TComponent;
  rectangl: TRect;
begin
  treefree(tree);
  rectangl := Rect(0, 0, 657, 529);
  Canvas.fillrect(rectangl);
  lbl2.Caption := '';
end;

procedure TForm1.btn4Click(Sender: TObject);
var
  i: Byte;
  kek: string;
  rectangle: TRect;
begin
  j := 0;
  kek := '';
  rectangle := Rect(10, 30, 657, 529);
  Form1.Canvas.MoveTo(((rectangle.Left + rectangle.Right) div 2),
    rectangle.Top);
  mnojestvo := mnojestvo - mnojestvo;
  fpar:=nil;
  TreeWritelnD(tree);
  for i := 0 to 255 do
  begin
    kek := kek + buf[i] + ' ';
  end;
  lbl2.Caption := kek;
  lbl2.Update;
  lightnigh1(tree, rectangle, Canvas, 0);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Byte;
  kek: string;
  rectangle: TRect;
begin
  j := 0;
  kek := '';
  rectangle := Rect(10, 30, 657, 529);
  Form1.Canvas.MoveTo(((rectangle.Left + rectangle.Right) div 2),
    rectangle.Top);
  mnojestvo := mnojestvo - mnojestvo;
  TreeWritelnR(tree);
  for i := 0 to 255 do
  begin
    kek := kek + buf1[i] + ' ';
  end;
  lbl2.Caption := kek;
  lbl2.Update;
  lightnigh2(tree, rectangle, Canvas, 0);
end;

procedure TForm1.btn5Click(Sender: TObject);
var
  i: Byte;
  kek: string;
  rectangle: TRect;
begin
  j := 0;
  kek := '';
  rectangle := Rect(10, 30, 657, 529);
  Form1.Canvas.MoveTo(((rectangle.Left + rectangle.Right) div 2),
    rectangle.Top);
  mnojestvo := mnojestvo - mnojestvo;
  TreeWritelnS(tree);
  for i := 0 to 255 do
  begin
    kek := kek + buf2[i] + ' ';
  end;
  lbl2.Caption := kek;
  lbl2.Update;
  lightnigh3(tree, rectangle, Canvas, 0);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  lbl2.Caption := '';
  edt1.text := '';
  number:=0;
end;


procedure TForm1.btn8Click(Sender: TObject);
var
text,i:Integer;
flag:Boolean;
rectangle:TRect;
begin
  rectangle := Rect(10, 30, 657, 529);
   text:=0;
  flag:=true;
    for i:= 1 to Length(edt1.text) do
     begin
       if flag then
       begin
          if ((edt1.text[i]='0')or(edt1.text[i]='1')or(edt1.text[i]='2')or(edt1.text[i]='3')or(edt1.text[i]='4')or(edt1.text[i]='5') or(edt1.text[i]='6') or(edt1.text[i]='7') or(edt1.text[i]='8')or(edt1.text[i]='9'))
          then  text:=10*text+StrToInt(edt1.text[i])
          else
           begin
            ShowMessage('Uncorrect input');
            flag:=false;
            end;
       end;

     end;
  if find(tree,text,rectangle,Canvas,0)=nil then ShowMessage('Uncorrect input');
end;

procedure TForm1.btn6Click(Sender: TObject);
var
text,i:Integer;
flag:Boolean;
rectangle:TRect;
a:TPNode;
begin
   rectangle := Rect(10, 30, 657, 529);
   text:=0;
  flag:=true;
    for i:= 1 to Length(edt1.text) do
     begin
       if flag then
       begin
          if ((edt1.text[i]='0')or(edt1.text[i]='1')or(edt1.text[i]='2')or(edt1.text[i]='3')or(edt1.text[i]='4')or(edt1.text[i]='5') or(edt1.text[i]='6') or(edt1.text[i]='7') or(edt1.text[i]='8')or(edt1.text[i]='9'))
          then  text:=10*text+StrToInt(edt1.text[i])
          else
           begin
            ShowMessage('Uncorrect input');
            flag:=false;
            end;
       end;

     end;
     a:=find(tree,text,rectangle,Canvas,0);
  if a=nil then ShowMessage('Uncorrect input')
  else
  begin
    if a^.parent^.Pleft<>nil then
    if a^.parent^.Pleft=a then begin
   TreeFree(a^.parent^.Pleft);
   //a^.parent^.Pleft:=nil;
   end
   else begin
     if a^.parent^.Pright<>nil then 
   if a^.parent^.Pright=a then
   begin
   TreeFree(a^.parent^.PRight);
   //a^.parent^.PRight:=nil;
   end;
   end;
   end;

end;

procedure TForm1.btn7Click(Sender: TObject);
var s:string;
begin
  s:=Proshivka(tree)
end;

end.

