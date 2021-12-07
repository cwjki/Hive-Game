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


player_choose_hand_piece(Piece) :- get_color(Color), get_player(player(_, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), Current_Player),
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



print_neighbours_options(Option) :- writeln("Seleccione en que coordenadas desea colocar la ficha:"),
                                    writeln("1 - [-1, 1]"),
                                    writeln("2 - [1, 1]"),
                                    writeln("3 - [2, 0]"),
                                    writeln("4 - [1, -1]"),
                                    writeln("5 - [-1, -1]"),
                                    writeln("6 - [-2, 0]"),
                                    read(Option).

choose_position_second_play(Row, Column) :- print_neighbours_options(Option),
                                            (Option =:= 1    -> (Row = -1, Column = 1);
                                             Option =:= 2    -> (Row = 1, Column = 1);
                                             Option =:= 3    -> (Row = 2, Column = 0);
                                             Option =:= 4    -> (Row = 1, Column = -1);
                                             Option =:= 5    -> (Row = -1, Column = -1);
                                             Option =:= 6    -> (Row = -2, Column = 0)
                                            ). 


player_first_play() :- get_color(Color), player_choose_hand_piece(Piece),
                       add_new_piece(hex(0, 0, Piece, Color)).

player_second_play() :- get_color(Color), choose_hand_piece(Piece), choose_position_second_play(Row, Column),
                        add_new_piece(hex(Row, Column, Piece, Color)).



pc_choose_hand_piece(Piece) :- get_color(Color), get_player(player(_, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), Current_Player),
                          HandPieces = [], 
                          ((QueenBee > 0     -> append([1], [], Hand_pieces)); append([], [], Hand_pieces)),
                          ((Ants > 0         -> append([2], Hand_pieces, Hand_pieces1)); append([], Hand_pieces, Hand_pieces1)),
                          ((Grasshoppers > 0 -> append([3], Hand_pieces1, Hand_pieces2)); append([], Hand_pieces1, Hand_pieces2)),
                          ((Scarabs > 0      -> append([4], Hand_pieces2, Hand_pieces3)); append([], Hand_pieces2, Hand_pieces3)),
                          ((Spiders > 0      -> append([5], Hand_pieces3, Hand_pieces4)); append([], Hand_pieces3, Hand_pieces4)),
                          ((Mosquitos > 0    -> append([6], Hand_pieces4, Hand_pieces5)); append([], Hand_pieces4, Hand_pieces5)),
                          ((Ladybugs > 0     -> append([7], Hand_pieces5, Hand_pieces6)); append([], Hand_pieces5, Hand_pieces6)),
                          ((Pillbugs > 0     -> append([8], Hand_pieces6, Hand_pieces7)); append([], Hand_pieces6, Hand_pieces7)),
                          writeln("Despues del chorizo"),
                          length(Hand_pieces7, Length), NewLength is Length +1,
                          random(1, NewLength, RIndex), 
                          nth1(RIndex, Hand_pieces7, Piece).

pc_choose_position_second_play(Row, Column) :- random(1, 7, Option),
                                               (Option =:= 1    -> (Row = -1, Column = 1);
                                                Option =:= 2    -> (Row = 1, Column = 1);
                                                Option =:= 3    -> (Row = 2, Column = 0);
                                                Option =:= 4    -> (Row = 1, Column = -1);
                                                Option =:= 5    -> (Row = -1, Column = -1);
                                                Option =:= 6    -> (Row = -2, Column = 0)
                                               ).


pc_first_play() :- get_color(Color), pc_choose_hand_piece(Piece),
                   add_new_piece(hex(0, 0, Piece, Color)).

pc_second_play() :- get_color(Color), pc_choose_hand_piece(Piece), pc_choose_position_second_play(Row, Column),
                    add_new_piece(hex(Row, Column, Piece, Color)).


player_next_move() :- get_turn(Turn),
                      (Turn =:= 1 -> player_first_play();
                      Turn =:= 2 -> player_second_play();
                      Turn >=  2 -> (choose_option(Option),
                      (Option =:= 1 -> play_new_piece();
                      Option =:= 2 -> move_one_piece()))
                      ).
                       
                       
pc_next_move() :- get_turn(Turn), 
                 (Turn =:= 1 -> pc_first_play();
                  Turn =:= 2 -> pc_second_play();
                  Turn >=  2 -> (choose_option(Option),
                 (Option =:= 1 -> play_new_piece();
                  Option =:= 2 -> move_one_piece()))
                 ).

next_move(Name) :- (Name =:= 0 -> player_next_move();
                   pc_next_move()).

play(Color, Turn) :- get_player(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), Current_Player),
                     printInfo(Name, Color),
                     print_board(_), 
                     next_move(Name),
                     print_board(_),
                     update_turn(NewTurn),
                     update_color(NewColor),               
                     play(NewColor, NewTurn).

playerVsPC() :- init(), play(0, 1).

print_board(Board) :- get_board(Board), writeln(Board). 

