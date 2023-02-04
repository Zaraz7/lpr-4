Unit tsCalc;
Interface
  const
    Description = 'y = 1*x^3 + 1*x^2 + (-4)*x + 13';
    t = 0.001;
    xRoot = -3.35;
  var
    status, complite: boolean;
    n: word;
    a, b, h: real;
    area: currency;

  function f(x: real): real;
  procedure trapArea;

Implementation
  var 
    x: real;

  function f(x: real): real;
  begin
    f := 1 * x * x * x + 1 * x * x + (-4) * x + 13;
  end;

  procedure trapArea;
  begin
    x := a + h;
    area := (f(a) + f(b)) / 2;
    while (b - x) > t do
    begin
      area := area + f(x);
      x := x + h;
    end;
    area := area * h;
    writeln('Area = ', area: 2: 2);
    complite := True;
  end;
Begin
  area := 0;
  complite := False;
  status := False;
End.