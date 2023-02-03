program TrapsArea;

{ 1*x^3 + 1*x^2 + (-4)*x + 13 }

{
// График
- [ ] Создать буферизацию графиков
- [ ] Добавить окошко клавиш
}

uses
  Crt, ptcGraph, ptcCrt, tsCalc;

const
  menu: array[1..6] of string = (
    'Limits and intervals',
    'Graph',
    'Area',
    'Bias',
    'About',
    'Quit');
  xRoot = -3.35;
var
  i: integer;
  selectedItem, scaleX, scaleY: byte;
  n: word;
  userKey: char;


  { Это процедура для более красивого и страшного вывода ошибок}
  procedure errorMessage(message: string);
  begin
    textColor(Red);
    Write('Error. ');
    writeln(message);
    normVideo;
    userKey := readKey;
    if userKey in ['e'] then
      exit;
  end;

  procedure newPage(lbl: string);  {Тоже для себя сделал}
  var
    i: integer;
  begin
    clrScr;
    textColor(Magenta);
    writeln('| ', lbl, ' |');
    Write('|');
    for i := 1 to length(lbl) + 2 do
      Write('_');
    writeln('|');
    normVideo;
  end;


  procedure inputLimits;  { Ввод ограничений}
  var
    userValue: string;
  begin
    newPage(menu[selectedItem]);
    status := False;
    repeat
      i := 1;
      repeat
        Write('Limit a: ');
        readln(userValue);
        if length(userValue) > 5 then
        begin
          errorMessage('Too long value');
          continue;
        end;
        val(userValue, a, i);
        if i <> 0 then
          errorMessage(
            'Check if there are any extraneous characters in the input');
      until i = 0;
      repeat
        Write('Limit b: ');
        readln(userValue);
        if length(userValue) > 5 then
        begin
          errorMessage('Too long value');
          continue;
        end;

        val(userValue, b, i);
        if i <> 0 then
          errorMessage(
            'Check if there are any extraneous characters in the input or replace "," to "."');
      until i = 0;
      if a > b then
      begin
        a := a + b;
        b := a - b;
        a := a - b;
      end;
    until i = 0;
    repeat
      Read;
      Write('Number of intervals: ');
      readln(userValue);
      val(userValue, n, i);
      if i <> 0 then
        errorMessage('Check if there are any extraneous characters in the input')
      else
      if n = 0 then
      begin
        errorMessage('"n" must be > 0');
        i := 1;
      end;
    until i = 0;
    if a < xRoot then
      a := xRoot;
    if b < xRoot then
      b := xRoot;
    textColor(Green);
    writeln('[a, b] = [', a: 2: 2, ', ', b: 2: 2, ']; n = ', n);
    h := (b - a) / n;
    status := True;
    complite := False;
    readln;
    normVideo;
  end;

  function f(xr: real): real;
  begin
    f := 1 * xr * xr * xr + 1 * xr * xr + (-4) * xr + 13;
  end;

  function primitivef(xr: currency): currency;
    { первообразная функции}
  begin
    primitivef := xr * xr * xr * xr / 4 + xr * xr * xr / 3 - xr * xr * 2 + 13 * xr;
  end;

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

  //procedure trapArea; forward;

  //procedure graphX(scale);

  procedure graphWindow; {Графика}
  var
    x, y: longint;
    xn, yn, x0, y0: word;
    Driver, Mode: smallint;
    xReal, Si: currency;
    userValue, lblText: string;
    pFrame: Pointer;
    size: integer;
  begin
    newPage(menu[selectedItem]);

    scaleX := 15;
    scaleY := 10;

    Driver:=10;
    Mode:=260;
    initGraph(Driver, Mode, '');

    i := GraphResult; {Запоминаем результат}
    if i <> grOk then {Проверяем ошибку}
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
  end;

  // procedure trapArea;
  // { Непосредственно вычисление самого алгоитма и вывод}
  // var
  //   x: real;
  // begin
  //   newPage(menu[selectedItem]);
  //   x := a + h;
  //   area := (f(a) + f(b)) / 2;
  //   while (b - x) > t do
  //   begin
  //     area := area + f(x);
  //     x := x + h;
  //   end;
  //   area := area * h;
  //   writeln('Area = ', area: 2: 2);
  //   complite := True;
  // end;

  procedure errorCalculate;
  var
    NL, R: real;
  begin
    newPage(menu[selectedItem]);

    NL := primitivef(b) - primitivef(a);
    writeln('Newton-Leibniz theorem result: ', NL: 2: 2);
    R := abs(area - NL);
    writeln('Absolute: ', R: 2: 2);
    if area < t then
      errorMessage('It is impossible to calculate the relative bias when area = 0')
    else
    begin
      writeln('Relative: ', R / area * 100: 2: 2, '%');
      readKey;
    end;
  end;

  procedure about;    { Объяснение. что делает программа}
  begin
    newPage(menu[selectedItem]);
    writeln('TrapsArea is a programm for calculation of an area of figure limited by the Ox axis and curve');
    writeln(Description);
    writeln('using the Trapezoid method.');
    writeln('Made by Terlyck Maxim');
    readln;
  end;

  procedure quit;
  begin
    clrScr;
    closeGraph;
    halt(0);
  end;

  procedure TUImenu; { В общем это и есть меню}
  begin
    selectedItem := 1;
    repeat
      newPage('Menu');
      for i := 1 to length(menu) do
        writeln(' ', menu[i]);
      repeat
        gotoXY(1, selectedItem + 2);
        userKey := readKey();
        case userKey of
          #80:
          begin {вниз}
            Inc(selectedItem);
            if selectedItem > 6 then
              selectedItem := 1;
          end;
          #72:
          begin {вверх}
            Dec(selectedItem);
            if selectedItem < 1 then
              selectedItem := 6;
          end;
          #13:
          begin
            case selectedItem of
              1: inputLimits;
              2: graphWindow;
              3:
              begin
                if status then
                begin
                  newPage(menu[selectedItem]);
                  trapArea;
                  readln;
                end
                else
                  errorMessage('You must input limits and number of intervals');
              end;
              4:
              begin
                if complite then
                  errorCalculate
                else
                if status then
                  errorMessage('Before that You need to select "Area"')
                else
                  errorMessage(
                    'You must input limits, number of intervals and then exec "Area"');
              end;
              5: about;
              6: quit;
            end;
            userKey := #13;
          end;
          #1, #27: quit;
        end;
        gotoXY(1, 10);
        Write(ord(userKey));
      until userKey = #13;
      clrScr;
    until False;
  end;

begin
  status := False;
  TUImenu;
end.
