program tsGraphic;

{
// ??????
- [ ] ???????? ?????????? ?????????
- [ ] ???????? ?????? ???????? ???????????
- [ ] ???????? ??????? ????????? ???????????
- [ ] ???????? ?????? ??????
- [ ] ??????? ??????????? ????????
}

uses
  ptcGraph, ptcCrt, tsCalc;

var
  scaleX, scaleY: byte;
  xn, yn, x0, y0: word;
  Driver, Mode: smallint;
  i, size: integer;
  x, y: longint;
  xReal, Si: currency;
  userKey: char;
  lblText, userValue: string;
  pFrame: Pointer;

  function strF(s: real): string;
  begin
    str(s: 2: 2, strF);
  end;

  function border(x, br: integer): integer;
  begin
    if x < br then
      border := x
    else
      border := br;
  end;

begin
    scaleX := 15;
    scaleY := 10;

    Driver:=10;
    Mode:=260;
    initGraph(Driver, Mode, '');

    i := GraphResult; {?????????? ?????????}
    if i <> grOk then {????????? ??????}
    begin
      writeln(GraphErrorMsg(i));
      readKey;
    end;

    xn := GetMaxX - 20;
    yn := GetMaxY - 20;
    x0 := xn div 2;
    y0 := yn div 5 * 4;

    repeat
      ClearDevice;
      setColor(White);
      rectangle(20, 20, xn, yn);
      outTextXY(x0 - 2, 4, 'Y');
      outTextXY(xn + 4, y0 - 2, 'X');

      line(20, y0, xn, y0);
      line(x0, 20, x0, yn);

{       Size := ImageSize(20, 20, xn, yn);
      GetMem(pFrame, Size);
      GetImage(20, 20, xn, yn, pFrame^); }

      xReal := (xn - 20) / 10;
      for i := -4 to 4 do
      begin
        x := trunc(i * xReal);
        line(x0 + x, y0, x0 + x, y0 + 5);
        str(x / scaleX: 1: 1, userValue);
        outTextXY(x0 + x, y0 + 6, userValue);
      end;
      xReal := (yn - 20) / 12;
      for i := 1 to 10 do
      begin
        y := trunc(i * xReal);
        line(x0, y0 - y, x0 + 5, y0 - y);
        str(y / scaleY: 1: 1, userValue);
        outTextXY(x0 + 6, y0 - y, userValue);
      end;

      setColor(Cyan);
      y := yn - 1;
      moveTo(20, y);
      for x := x0 - xn + 22 to xn - x0 do
      begin
        y := y0 - trunc(f(x / scaleX) * scaleY);
        if 20 > y then
          y := 21;
        if y > yn then
          y := yn - 1;
        lineTo(x0 + x, y);
      end;

      if status then
      begin
        x := x0 + trunc(scaleX * a);
        if x <= xn then
        begin
          moveTo(x, 21);
          lineTo(x, y0 - 1);
          y := border(x0 + trunc(scaleX * b), xn);
          if x + 1 < y then
          begin
            lineTo(y, y0 - 1);
            lineTo(y, 21);
            setFillStyle(3, Blue);
            floodFill(y - 1, y0 - 2, Cyan);
            outTextXY(30, 30, 'Limits: ' + strF(a) + ', ' + strF(b));
          end;
        end;
      end
      else
        outTextXY(30, 30, 'Limits are empty');

      if status then
      begin
        setColor(Red);
        xReal := a;
        area := 0;
        setFillStyle(1, Black);
        for i := 1 to n do
        begin
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
          bar(30, 40, 220, 60);
          Si := (f(xReal) + f(xReal - h)) / 2 * h;
          str(i, lblText);
          outTextXY(30, 40, 'S' + lblText + ' = ' + strF(Si));
          delay(1000);
        end;

        delay(2000);
        if not complite then
          trapArea;
        outTextXY(30, 60, 'S = ' + strF(area));
        complite := True;
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
              Dec(scaleY);
              if scaleY = 0 then
                scaleY := 1;
            end;
            #72: Inc(scaleY);
            #75:
            begin
              Dec(scaleX);
              if scaleX = 0 then
                scaleX := 1;
            end;
            #77: Inc(scaleX);
          end;
        end;
        #116: PutImage(100, 100, pFrame^, NormalPut);
        #27:
        begin
          closeGraph;
          restoreCrtMode;
          break;
        end;
      end;
      // freeMem(pFrame, size);
    until False;
    closeGraph;
end.