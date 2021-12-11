:- use_module(game).
:- use_module(hexagon).
    
beginning_message(Input) :- 
    writeln(""),
    writeln("Proyecto I Programacion Declarativa - Olivia Gonzalez Pena, Juan Carlos Casteleiro Wong - C411"),
    writeln("HIVE"),
    writeln("Opciones de Juego:"),
    writeln("1 - Jugador contra PC"),
    writeln("2 - Simulacion de dos jugadores"),
    read(Input),
    writeln("").

main() :- 
    beginning_message(Input), 
    (Input =:= 1 -> playerVsPC();
    (Input =:= 2 -> pcVsPC());
    (writeln("Debe seleccionar una de las opciones disponibles"), main())).
