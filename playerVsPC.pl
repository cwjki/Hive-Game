:- module(playerVsPC, [playerVsPC/0]).

:- use_module(player).
:- use_module(utils).



init() :- random(0, 2, R1), new_player(player(0, R1, 1, 3, 3, 2, 2, 1, 1, 1)), R2 is 1-R1, new_player(player(1, R2, 1, 3, 3, 2, 2, 1, 1, 1)),
          init_color(),
          init_turn(),
          writeln("Comienza la partida, el color de las fichas fue asignado aleatoriamente."),
          writeln("").


printInfo(Name, Color) :- writeln(""),
                          get_turn(Turn),
                          write("Turno # "), write(Turn),
                          write(" Le corresponde jugar a: "),
                          (Name =:= 0 -> write("Jugador"); write("PC")),
                          write(", fichas "),
                          (Color =:= 0 -> write("Blancas"); write("Negras")),                                             
                          writeln("").




choose_option(Option) :- writeln("Seleccione el tipo de jugada a realizar:"),
                         writeln("1 - Colocar pieza nueva en el tablero"),
                         writeln("2 - Mover pieza en el tablero"),
                         read(Option),
                         writeln("").




choose_hand_piece(Piece) :- get_color(Color), get_player(_, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs),
                             writeln("Seleccione que bicho desea agregar al tablero"),
                             (QueenBee > 0     -> writeln("1 - Abeja Reina"); true),                         
                             (Ants > 0         -> writeln("2 - Hormiga"); true),
                             (Grasshoppers > 0 -> writeln("3 - Saltamontes"); true),
                             (Scarabs > 0      -> writeln("4 - Escarabajo"); true),
                             (Spiders > 0      -> writeln("5 - Araña"); true),
                             (Mosquitos > 0    -> writeln("6 - Mosquito"); true),
                             (Ladybugs > 0     -> writeln("7 - Mariquita"); true),
                             (Pillbugs > 0     -> writeln("8 - Bicho Bola"); true),
                             read(Piece),
                             writeln("").


play_new_piece() :- choose_hand_piece(Piece). 

move_one_piece() :- writeln("Simular mover una ficha").

next_move_player() :- choose_option(Option),
                      (Option =:= 1 -> play_new_piece();
                       Option =:= 2 -> move_one_piece()).
                      

next_move_pc() :- writeln("Simular Partida de la PC.").

next_move(Name) :- (Name =:= 0 -> next_move_player();
                   next_move_pc()).

play(Color, Turn) :- get_player(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), Current_Player),
                     printInfo(Name, Color), 
                     next_move(Name),
                     update_turn(NewTurn),
                     update_color(NewColor),               
                     play(NewColor, NewTurn).

playerVsPC() :- init(), play(0, 1).



