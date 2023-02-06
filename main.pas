program TrapsArea;

{ 1*x^3 + 1*x^2 + (-4)*x + 13 }

uses
  Crt, SysUtils, tsCalc;

const
  menu: array[1..6] of string = (
    'Limits and intervals',
    'Graph',
    'Area',
    'Bias',
    'About',
    'Quit');
var
  i: integer;
  selectedItem: byte;
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
    textColor(LightMagenta);
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

  procedure graphWindow; {Графика}
  begin
    newPage(menu[selectedItem]);
    if status then
      ExecuteProcess('./tsGraphic', ['-lic', strF(a), strF(b), strFi(n)])
    else
      ExecuteProcess('./tsGraphic', ['-d']);
  end;

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
            if selectedItem < 6 then
              Inc(selectedItem)
			else
			  selectedItem := 1;
          end;
          #72:
          begin {вверх}
            if selectedItem > 1 then
			  Dec(selectedItem)
			else
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
        //Write(ord(userKey));
      until userKey = #13;
      clrScr;
    until False;
  end;

begin
  TUImenu;
end.
