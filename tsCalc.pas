Unit tsCalc;
Interface
//интерфейсная часть>
  const
   Description = 'y = 1*x^3 + 1*x^2 + (-4)*x + 13';
  var
    complite: boolean;
    area: currency;

  function f(x: real): real;
  procedure trapArea(a, b, h: real);

Implementation
//исполняемая часть>
  var 
    x: real;

  function f(x: real): real;
  begin
    f := 1 * x * x * x + 1 * x * r + (-4) * x + 13;
  end;

  procedure trapArea(a, b, h: real);
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
  currency := 0;
  complite := True;
//инициализация
End.
  