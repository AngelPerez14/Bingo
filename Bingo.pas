PROGRAM BingoJuego;

USES
  Crt;

TYPE
  TableroBingo = ARRAY[1..5, 1..5] OF Integer;

VAR
  tablero: TableroBingo;
  numeroActual: Integer;
  numSacados: ARRAY[1..75] OF Boolean;
  seguirJugando: Boolean;

// Genera un tablero nuevo con números al azar
function GenerarTablero: TableroBingo;
var
  numeroAleatorio, columna, fila, min, max: Integer;
  numerosUsados: ARRAY[1..75] OF Boolean;
  tableroTemp: TableroBingo;
begin
  Randomize;  // Inicializa el generador de números aleatorios
  for numeroAleatorio := 1 to 75 do
    numerosUsados[numeroAleatorio] := False;  // Inicializa números usados

  for columna := 1 to 5 do begin
    // Establece los rangos de números permitidos para cada columna
    case columna of
      1: begin min := 1; max := 15 end;  // Rango para la columna B
      2: begin min := 16; max := 30 end;  // Rango para la columna I
      3: begin min := 31; max := 45 end;  // Rango para la columna N
      4: begin min := 46; max := 60 end;  // Rango para la columna G
      5: begin min := 61; max := 75 end;  // Rango para la columna O
    end;

    for fila := 1 to 5 do begin
      repeat
        numeroAleatorio := Random(max - min + 1) + min;  // Genera un número aleatorio dentro del rango
      until not numerosUsados[numeroAleatorio];  // Verifica si ya fue usado
      
      numerosUsados[numeroAleatorio] := True;  // Marca número como usado
      tableroTemp[columna, fila] := numeroAleatorio;  // Asigna número al tablero
    end;
  end;

  tableroTemp[3, 3] := 0;  // Marca el centro del tablero como espacio libre
  GenerarTablero := tableroTemp;  // Devuelve el tablero generado
end;

// Dibuja el tablero en pantalla
procedure DibujarTablero(tablero: TableroBingo);
var
  columna, fila: Integer;
begin
  TextColor(LightBlue);  // Cambia el color del texto a azul
  Writeln('-----------------------');  // Borde superior del tablero
  for fila := 1 to 5 do begin
    Write('¦ ');  // Lado izquierdo del tablero
    for columna := 1 to 5 do begin
      if tablero[fila, columna] = 0 then
        Write(' * ':3)  // Espacio libre marcado con asterisco
      else
        Write(tablero[fila, columna]:3);  // Imprime número
      Write(' ');
    end;
    Writeln('¦');  // Lado derecho del tablero
  end;
  Writeln('-----------------------');  // Borde inferior del tablero
  TextColor(White);  // Restablece el color del texto al blanco
end;

// Saca un número nuevo
function SacarNumero: Integer;
var
  intento: Integer;
begin
  repeat
    intento := Random(75) + 1;  // Genera un número aleatorio
  until not numSacados[intento];  // Verifica si ya fue sacado
  numSacados[intento] := True;  // Marca número como sacado
  SacarNumero := intento;  // Devuelve el número sacado
end;

// Marca un número en el tablero
procedure MarcarNumero(var tablero: TableroBingo; numero: Integer);
var
  columna, fila: Integer;
  encontrado: Boolean;
begin
  encontrado := False;  // Inicializa la variable de control
  for columna := 1 to 5 do begin
    for fila := 1 to 5 do begin
      if tablero[columna, fila] = numero then begin
        tablero[columna, fila] := 0;  // Marca el número como encontrado
        encontrado := True;  // Cambia el estado si el número es encontrado
        Break;
      end;
    end;
    if encontrado then Break;  // Detiene la búsqueda si el número fue encontrado
  end;
end;

// Revisa si hay bingo
function EsBingo(tablero: TableroBingo): Boolean;
var
  columna, fila: Integer;
  esLineaCompleta: Boolean;
begin
  // Revisar filas
  for fila := 1 to 5 do begin
    esLineaCompleta := True;  // Asume que la línea está completa
    for columna := 1 to 5 do
      if tablero[columna, fila] <> 0 then esLineaCompleta := False;  // Verifica cada columna
    if esLineaCompleta then begin
      EsBingo := True;  // Bingo en la fila
      Exit;
    end;
  end;

  // Revisar columnas
  for columna := 1 to 5 do begin
    esLineaCompleta := True;  // Asume que la columna está completa
    for fila := 1 to 5 do
      if tablero[columna, fila] <> 0 then esLineaCompleta := False;  // Verifica cada fila
    if esLineaCompleta then begin
      EsBingo := True;  // Bingo en la columna
      Exit;
    end;
  end;

  // Diagonal principal
  esLineaCompleta := True;  // Asume que la diagonal está completa
  for fila := 1 to 5 do
    if tablero[fila, fila] <> 0 then esLineaCompleta := False;  // Verifica cada posición
  if esLineaCompleta then begin
    EsBingo := True;  // Bingo en la diagonal principal
    Exit;
  end;

  // Diagonal inversa
  esLineaCompleta := True;  // Asume que la diagonal está completa
  for fila := 1 to 5 do
    if tablero[fila, 6 - fila] <> 0 then esLineaCompleta := False;  // Verifica cada posición
  if esLineaCompleta then begin
    EsBingo := True;  // Bingo en la diagonal inversa
    Exit;
  end;

  EsBingo := False;  // No hay bingo
end;

BEGIN
  ClrScr;  // Limpia la pantalla
  seguirJugando := True;  // Inicializa la variable de control
  
  // Inicializar el juego
  for numeroActual := 1 to 75 do
    numSacados[numeroActual] := False;  // Inicializa números sacados
    
  tablero := GenerarTablero;  // Genera un tablero nuevo

  // Mensaje inicial amigable
  TextColor(LightGreen); // Cambia el color del texto a verde
  Writeln('------------------------------');
  Writeln('¦          B I N G O         ¦');
  Writeln('------------------------------');
  TextColor(White); // Cambia el color del texto a blanco
  Writeln;
  TextColor(LightBlue); // Cambia el color del texto a azul
  Writeln('Tu carton: ');
  TextColor(White); // Cambia el color del texto a blanco
  DibujarTablero(tablero);  // Muestra el tablero inicial

  // Loop principal del juego
  while seguirJugando do begin
    Writeln;
    Write('Presiona ENTER para sacar numero... ');
    Readln;
    
    numeroActual := SacarNumero;  // Saca un número nuevo
    ClrScr;  // Limpia la pantalla
    
    TextColor(LightBlue);  // Cambia el color del texto a azul
    Writeln('--------------------');
    Writeln('Salio el numero: ', numeroActual:2);
    Writeln('--------------------');
    TextColor(LightGray);  // Restablece el color del tablero a gris
    
    MarcarNumero(tablero, numeroActual);  // Marca el número en el tablero
    DibujarTablero(tablero);  // Muestra el tablero actualizado

    if EsBingo(tablero) then begin
      TextColor(LightGreen);  // Cambia el color del texto a verde
      Writeln;
      Writeln('------------------------------');
      Writeln('  ¡¡¡ B I N G O !!!    ');
      Writeln('------------------------------');
      TextColor(White);  // Restablece el color del texto al blanco
      Break;
    end;
  end;
  
  Writeln;
  TextColor(LightRed);  // Cambia el color del texto a rojo
  Writeln('Presiona ENTER para salir...');
  TextColor(White);  // Restablece el color del texto al blanco
  Readln;
END.
