:- use_module(playerVsPC).


beginning_message(Input) :- writeln("Proyecto I Programación Declarativa - Olivia González Peña, Juan Carlos Casteleiro Wong - C411"),
                            writeln("HIVE"),
                            writeln("Opciones de Juego:"),
                            writeln("1 - Jugador contra PC"),
                            writeln("2 - Simulación de dos jugadores"),
                            read(Input),
                            writeln("").

        

main() :- beginning_message(Input), (Input =:= 1 -> playerVsPC(), main();
                                    (Input =:= 2 -> playerVsPlayer(), main());
                                    (writeln("Debe seleccionar una de las opciones disponibles"), main())).


playerVsPlayer() :- writeln("PVP").