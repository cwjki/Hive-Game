:- module(playerVsPC, [playerVsPC/0]).

:- use_module(player).
:- use_module(utils).
:- use_module(board).
:- use_module(hexagon).


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


choose_hand_piece(Piece) :- get_color(Color), get_player(player(_, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), Current_Player),
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



choose_positions_aux([],Count) :- Count = 0.
choose_positions_aux([X|Positions], NewCount) :- get_hex_row(X,Row),
                                                 get_hex_column(X, Column),
                                                 choose_positions_aux(Positions, Count),
                                                 NewCount is Count + 1,
                                                 write(NewCount), write("- "), write("["), write(Row), write(", "), write(Column), write("]"),
                                                 writeln("").


choose_position(Color, ChoosenHex) :- writeln("Seleccione en que coordenadas desea colocar la ficha."),
                                       get_possible_positions(Color, Positions),
                                       choose_positions_aux(Positions, TotalOptions),
                                       read(Option),
                                       reverse(Positions, X, []),
                                       nth1(Option, X, ChoosenHex),
                                       writeln(ChoosenHex).
                                       

                

play_new_piece() :- get_color(Color), choose_hand_piece(Piece), choose_position(Color, ChoosenHex),
                    get_hex_row(ChoosenHex, Row), get_hex_column(ChoosenHex, Column),
                    add_new_piece(hex(Row, Column, Piece, Color)),
                    writeln("Simular que se puso uno ficha.").

move_one_piece() :- writeln("Simular mover una ficha").

first_play() :- writeln("Primera jugada").
second_play() :- writeln("Segunda jugada").

next_move_player() :-  get_turn(Turn),
                       (Turn =:= 1 -> first_play();
                        Turn =:= 2 -> second_play();
                        Turn >=  2 -> (choose_option(Option),
                        (Option =:= 1 -> play_new_piece();
                        Option =:= 2 -> move_one_piece()))
                        ).
                       
                       
                      

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



