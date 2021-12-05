:- consult(player).
:- consult(utils).



init() :- random(0, 2, R1), new_player("Jugador", R1, 1, 3, 3, 2, 2, 1, 1, 1), R2 is R1-1, new_player("PC", R2, 1, 3, 3, 2, 2, 1, 1, 1),
          init_color(),
          init_turn(),
          writeln("Comienza la partida, el color de las fichas fue asignado aleatoriamente."),
          writeln("").


printInfo(Name, Color).

choose_option(Option) :- writeln("Seleccione el tipo de jugada a realizar:"),
                         writeln("1 - Colocar pieza nueva en el tablero"),
                         writeln("2 - Mover pieza en el tablero"),
                         read(Option),
                         writeln("").




choose_hand_piece(Option) :- get_color(Color), get_player(_, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs),
                             writeln("Seleccione que bicho desea agregar al tablero"),
                             QueenBee > 0 -> writeln("1 - Abeja Reina");                           
                             Ants > 0 -> writeln("2 - Hormiga");
                             Grasshoppers > 0 -> writeln("3 - Saltamontes");
                             Scarabs > 0 -> writeln("4 - Escarabajo");
                             Spiders > 0 -> writeln("5 - Araña");
                             Mosquitos > 0 -> writeln("6 - Mosquito");
                             Ladybugs > 0 -> writeln("7 - Mariquita");
                             Pillbugs > 0 -> writeln("8 - Bicho Bola");
                             read(Option),
                             writeln("")


play_new_piece() :- choose_hand_piece(Option).

move_piece()

next_move_player() :- choose_option(Option),
                      Option =:= 1 -> play_new_piece();
                      Option =:= 2 -> move_piece()
                      

next_move_pc() :- writeln("Pc").

next_move(Name) :- Name =:= "Jugador" -> next_move_player();
                   next_move_pc().

play(Color, Turn) :- get_player(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), Current_Player),
                     printInfo(Name, Color),
                     next_move(Name),
                     update_turn(NewTurn),
                     update_color(NewColor),
                     play(NewColor, NewTurn).


playerVsPC() :- init(), play(0, 1),