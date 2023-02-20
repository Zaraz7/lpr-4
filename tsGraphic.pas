program tsGraphic;

{
// 
- [x] Добавить параметры
- [x] Добавить окно с клавишами
- [x] Внедрить буферизацию изображения
}

uses
  ptcGraph, ptcCrt, tsCalc;

var
  scaleX, scaleY, errorCount: byte;
  xn, yn, x0, y0: word;
  Driver, Mode: smallint;
  i: integer;
  x, y, fSize: longint;
  xReal, Si: currency;
  userKey: char;
  userValue: string;
  pFrame: Pointer;

function border(x, br: integer): integer;
  begin
    if x < br then
      border := x
    else
      border := br;
  end;

procedure drawArea;
begin
  x := x0 + trunc(scaleX * a);
  if x <= xn then
  begin
	if x < 21 then
	  x := 21;
	moveTo(x, 21);
	lineTo(x, y0 - 1);
	y := border(x0 + trunc(scaleX * b), xn-1);
	if x + 1 < y then
	begin
	  lineTo(y, y0 - 1);
	  lineTo(y, 21);
	  setFillStyle(3, Blue);
	  floodFill(y - 1, y0 - 2, Cyan);
	end;
  end;
end;

procedure drawAbout;
begin
  setFillStyle(1, White);
  setColor(Black);
  bar(25, 25, xn-5, 110);
  outTextXY(30, 30, 'TrapsArea is a programm for calculation of an area of figure');
  outTextXY(30, 45, 'limited by the Ox axis and curve');
  outTextXY(30, 60, Description);
  outTextXY(30, 75, 'using the Trapezoid method.');
  outTextXY(30, 90, 'Made by Terlyck Maxim');
  ptcCrt.readKey;
end;

procedure drawIntegral;
  begin
	setFillStyle(1, White);
	setColor(Black);
	outTextXY(30, 60, '[Enter] to continue');
	xReal := a;
	area := 0;
	for i := 1 to n do
	begin
	  setColor(Magenta);
	  moveTo(x0 + trunc(xReal * scaleX), y0);
	  y := y0 - trunc(f(xReal) * scaleY);
	  x := border(x0 + trunc(xReal * scaleX), xn);
	  if y > yn then
		moveTo(x, yn - 1)
	  else if 20 > y then
		moveTo(x, 21)
	  else
		lineTo(x, y);


	  xReal := xReal + h;
	  y := y0 - trunc(f(xReal) * scaleY);
	  x := border(x0 + trunc(xReal * scaleX), xn);
	  if y > yn then
		moveTo(x, yn - 1)
	  else if 20 > y then
		moveTo(x, 21)
	  else
		lineTo(x, y);
	  lineTo(x, y0);
	  bar(30, 40, 200, 55);
	  Si := (f(xReal) + f(xReal - h)) / 2 * h;
	  setColor(Black);
	  outTextXY(30, 40, 'S' + strFi(i) + ' = ' + strF(Si));
	  userKey := ptcCrt.readkey;
	  if userKey = #27 then
		break;
	end;
	bar(30, 60, 200, 80);
	trapArea;
	outTextXY(30, 60, 'S = ' + strF(area));

	ptcCrt.readKey;
  end;

begin

  if paramCount > 0 then
    case paramStr(1) of
    '-li', '-lic': 
	  begin
		errorCount := 0;
		val(paramStr(2), a, i);
		if i <> 0 then begin
		  writeLn('Error in the "a" parameter: ', paramStr(2));
		  inc(errorCount);
		end;
		val(paramStr(3), b, i);
		if i <> 0 then begin
		  writeLn('Error in the "b" parameter: ', paramStr(3));
		  inc(errorCount);
		end;
		val(paramStr(4), n, i);
		if (i <> 0) or (n = 0) then begin
		  writeLn('Error in the "n" parameter: ', paramStr(4));
		  inc(errorCount);
		end;

		if errorCount = 0 then begin
		  if paramStr(1) = '-li' then begin
			if a < xRoot then
			  a := xRoot;
			if b < xRoot then
			  b := xRoot;
			if a > b then begin
			  a := a + b;
			  b := a - b;
			  a := a - b;
			end;
		  end;
		  h := (b - a) / n;
		  status := True;
		end
		else
		  writeLn('Error of child parameters');
      end;
    end;

  scaleX := 15;
  scaleY := 10;

  Driver:=9;
  Mode:=2;
  initGraph(Driver, Mode, '');

  i := GraphResult;
  if i <> grOk then 
  begin
    writeln(GraphErrorMsg(i));
    readKey;
    exit;
  end;

  xn := GetMaxX - 20;
  yn := GetMaxY - 20;
  x0 := xn div 2;
  y0 := yn div 5 * 4;

  rectangle(20, 20, xn, yn);
  outTextXY(x0 - 2, 4, 'Y');
  outTextXY(xn + 4, y0 - 2, 'X');

  line(20, y0, xn, y0);

  Bar(25, 25, 200, 80);
  setColor(LightGray);
  Bar(xn-300, yn-70, xn-5, yn-5);
  setColor(Black);
  if status then
    outTextXY(30, 30, 'Limits: ' + strF(a) + ', ' + strF(b))
  else
    outTextXY(30, 30, 'Limits are empty');
  outTextXY(xn-295, yn-65, '[' + #24 + '] or [' + #25 + ']: resize Oy up or down');
  outTextXY(xn-295, yn-50, '[' + #26 + '] or [' + #27 + ']: resize Ox up or down');
  outTextXY(xn-295, yn-35, '[i]: visualize integration process');
  outTextXY(xn-295, yn-15, '[Esc]: escape [a]: about');

  fSize := ImageSize(20, 1, xn + 19, yn);
  GetMem(pFrame, fSize);
  GetImage(20, 1, xn + 19, yn, pFrame^);
  repeat
    PutImage(20,1,pFrame^,NormalPut);
    setColor(White);

    outTextXY(30, yn-20, 'scale: '+strFi(scaleX)+' '+strFi(scaleY));

    setColor(Cyan);
    y := yn - 1;
    moveTo(21, y);
    for x := x0 - xn + 22 to xn - x0 do
    begin
      y :=  - trunc(f(x / scaleX) * scaleY) + y0;
      if 21 > y then
        y := 21;
      if y > yn then
        y := yn - 1;
      lineTo(x0 + x, y);
    end;

    if status then
      drawArea;

    setColor(White);
    line(x0, 20, x0, yn);

    xReal := (xn - 20) / 10;
    for i := -3 to 3 do
    begin
      x := trunc(i * xReal);
      line(x0 + x, y0, x0 + x, y0 + 5);
      str(x / scaleX: 1: 1, userValue);
      outTextXY(x0 + x, y0 + 6, userValue);
    end;
    xReal := (yn - 20) / 8;
    for i := 1 to 6 do
    begin
      y := trunc(i * xReal);
      line(x0, y0 - y, x0 + 5, y0 - y);
      str(y / scaleY: 1: 1, userValue);
      outTextXY(x0 + 6, y0 - y, userValue);
    end;

    //writeln;
    userKey := ptcCrt.readkey;
    case userKey of
      #0: 
      begin
        userKey := ptcCrt.readKey;
        case userKey of
          #80:
          begin
            if scaleY > 1 then
			  Dec(scaleY);
          end;
          #72: 
          if scaleY div scaleX < 16 then
            Inc(scaleY);
          #75:
          if (scaleY div scaleX < 16) and (scaleX > 1) then
            Dec(scaleX);
          #77: Inc(scaleX);
        end;
      end;
	  #97, #228: drawAbout;
      'i', #248: if status then drawIntegral;
      #27:
      begin
        restoreCrtMode;
        break;
      end;
    end;
  until False;
  freeMem(pFrame, fSize);
  closeGraph;
end.
