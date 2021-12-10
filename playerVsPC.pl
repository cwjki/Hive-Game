:- module(playerVsPC, [playerVsPC/0]).

:- use_module(player).
:- use_module(utils).
:- use_module(board).
:- use_module(hexagon).


init() :- 
    random(0, 2, R1), new_player(player(0, R1, 1, 3, 3, 2, 2, 1, 1, 1)), R2 is 1-R1, new_player(player(1, R2, 1, 3, 3, 2, 2, 1, 1, 1)),
    init_color(),
    init_turn(),
    writeln("Comienza la partida, el color de las fichas fue asignado aleatoriamente."),
    writeln("").


printInfo(Name, Color) :- 
    get_turn(Turn),
    write("Turno # "), write(Turn),
    write(" Le corresponde jugar a: "),
    (Name =:= 0 -> write("Jugador"); write("PC")),
    write(", fichas "),
    (Color =:= 0 -> write("Blancas"); write("Negras")),                                             
    writeln("").


choose_option(Option) :- 
    writeln("Seleccione el tipo de jugada a realizar:"),
    writeln("1 - Colocar pieza nueva en el tablero"),
    writeln("2 - Mover pieza en el tablero"),
    read(Option),
    writeln("").


player_choose_hand_piece(Piece) :- 
    get_color(Color), get_player(player(_, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), Current_Player),
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



print_positions([],Count) :- Count = 0.
print_positions([X|Positions], NewCount) :- 
    get_hex_row(X,Row),
    get_hex_column(X, Column),
    print_positions(Positions, Count),
    NewCount is Count + 1,
    write(NewCount), write("- "), write("["), write(Row), write(", "), write(Column), write("]"),
    writeln("").


player_choose_position(Color, ChoosenHex) :- 
    writeln("Seleccione en que coordenadas desea colocar la ficha."),
    get_possible_positions(Color, Positions),
    print_positions(Positions, TotalOptions),
    read(Option),
    reverse(Positions, X, []),
    nth1(Option, X, ChoosenHex),
    writeln("").

player_choose_board_piece(Color, ChoosenHex) :-
    writeln("Seleccione la ficha que desea mover:"),
    get_hexs_by_color(Color, Hexs),
    print_positions(Hexs, TotalOptions),
    read(Option),
    reverse(Hexs, X, []),
    nth1(Option, X, ChoosenHex),
    writeln("").

                                           
player_play_new_piece() :- 
    get_color(Color), player_choose_hand_piece(Piece), player_choose_position(Color, ChoosenHex),
    get_hex_row(ChoosenHex, Row), get_hex_column(ChoosenHex, Column),
    add_new_piece(hex(Row, Column, Piece, Color, 0)).
    

player_choose_piece_destiny(OriginHex, DestinyHex) :-
    writeln("Seleccione la casilla destino para su ficha:"),
    get_possible_moves(OriginHex, PossibleDestinies),
    print_positions(PossibleDestinies, TotalOptions),
    read(Option),
    reverse(PossibleDestinies, X, []),
    nth1(Option, X, DestinyHex),
    writeln("").


player_move_one_piece() :- 
    get_color(Color),
    player_choose_board_piece(Color, OriginHex),
    player_choose_piece_destiny(OriginHex, DestinyHex),
    move_piece(OriginHex, DestinyHex).


    



print_neighbours_options(Option) :- 
    writeln("Seleccione en que coordenadas desea colocar la ficha:"),
    writeln("1 - [-1, 1]"),
    writeln("2 - [1, 1]"),
    writeln("3 - [2, 0]"),
    writeln("4 - [1, -1]"),
    writeln("5 - [-1, -1]"),
    writeln("6 - [-2, 0]"),
    read(Option).

player_choose_position_second_play(Row, Column) :- 
    print_neighbours_options(Option),
    (Option =:= 1    -> (Row = -1, Column = 1);
     Option =:= 2    -> (Row = 1, Column = 1);
     Option =:= 3    -> (Row = 2, Column = 0);
     Option =:= 4    -> (Row = 1, Column = -1);
     Option =:= 5    -> (Row = -1, Column = -1);
     Option =:= 6    -> (Row = -2, Column = 0)
    ). 


player_first_play() :- 
    get_color(Color), player_choose_hand_piece(Piece),
    add_new_piece(hex(0, 0, Piece, Color, 0)).

player_second_play() :- 
    get_color(Color), player_choose_hand_piece(Piece), player_choose_position_second_play(Row, Column),
    add_new_piece(hex(Row, Column, Piece, Color, 0)).



pc_choose_hand_piece(Piece) :- 
    get_color(Color), get_player(player(_, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), Current_Player),
    HandPieces = [], 
    ((QueenBee > 0     -> append([1], [], Hand_pieces)); append([], [], Hand_pieces)),
    ((Ants > 0         -> append([2], Hand_pieces, Hand_pieces1)); append([], Hand_pieces, Hand_pieces1)),
    ((Grasshoppers > 0 -> append([3], Hand_pieces1, Hand_pieces2)); append([], Hand_pieces1, Hand_pieces2)),
    ((Scarabs > 0      -> append([4], Hand_pieces2, Hand_pieces3)); append([], Hand_pieces2, Hand_pieces3)),
    ((Spiders > 0      -> append([5], Hand_pieces3, Hand_pieces4)); append([], Hand_pieces3, Hand_pieces4)),
    ((Mosquitos > 0    -> append([6], Hand_pieces4, Hand_pieces5)); append([], Hand_pieces4, Hand_pieces5)),
    ((Ladybugs > 0     -> append([7], Hand_pieces5, Hand_pieces6)); append([], Hand_pieces5, Hand_pieces6)),
    ((Pillbugs > 0     -> append([8], Hand_pieces6, Hand_pieces7)); append([], Hand_pieces6, Hand_pieces7)),
    length(Hand_pieces7, Length), NewLength is Length +1,
    random(1, NewLength, RIndex), 
    nth1(RIndex, Hand_pieces7, Piece).

pc_choose_position_second_play(Row, Column) :- 
    random(1, 7, Option),
    (Option =:= 1    -> (Row = -1, Column = 1);
     Option =:= 2    -> (Row = 1, Column = 1);
     Option =:= 3    -> (Row = 2, Column = 0);
     Option =:= 4    -> (Row = 1, Column = -1);
     Option =:= 5    -> (Row = -1, Column = -1);
     Option =:= 6    -> (Row = -2, Column = 0)
    ).


pc_first_play() :- 
    get_color(Color), pc_choose_hand_piece(Piece),
    add_new_piece(hex(0, 0, Piece, Color, 0)).

pc_second_play() :- 
    get_color(Color), pc_choose_hand_piece(Piece), pc_choose_position_second_play(Row, Column),
    add_new_piece(hex(Row, Column, Piece, Color, 0)).


player_next_move() :- 
    get_turn(Turn), get_color(Color),
    % primera jugada del jugador, en el turno 1 o en el turno 2, depende de si es blancas o negras.
    (Turn =:= 1 -> player_first_play();
    Turn =:= 2 -> player_second_play();
    % forzar a poner la reina abeja si no ha sido colocada antes del turno 4.
    (Color =:= 0, Turn =:= 7, not(its_the_queen_on_the_table(0)) -> force_queenBee(Color));
    (Color =:= 1, Turn =:= 8, not(its_the_queen_on_the_table(1)) -> force_queenBee(Color));
    % si esta puesta la reina mostras las opciones de juego.
    (Turn >=  2, its_the_queen_on_the_table(Color)) -> (choose_option(Option),
    (Option =:= 1 -> player_play_new_piece();
    Option =:= 2 -> player_move_one_piece()));
    % solo poner nuevas fichas si no se ha puesto la reina.
    player_play_new_piece()
    ).


force_queenBee(Color) :- 
    get_player(player(Name, Color, _, _, _, _, _, _, _, _), Current_Player),
    (Name =:= 0 -> player_force_queenBee(Color);
    pc_force_queenBee(Color)).

pc_force_queenBee(Color) :- 
    pc_choose_position(Color, ChoosenHex),
    get_hex_row(ChoosenHex, Row), get_hex_column(ChoosenHex, Column),
    add_new_piece(hex(Row, Column, 1, Color, 0)).


player_force_queenBee(Color) :- 
    writeln("Debe colocar la reina abeja en este turno obligatoriamente."),
    player_choose_position(Color, ChoosenHex),
    get_hex_row(ChoosenHex, Row), get_hex_column(ChoosenHex, Column),
    add_new_piece(hex(Row, Column, 1, Color, 0)).


pc_choose_position(Color, ChoosenHex) :- 
    get_possible_positions(Color, Positions),
    length(Positions, Length), NewLength is Length + 1,
    random(1, NewLength, RIndex),
    nth1(RIndex, Positions, ChoosenHex).

                                          

pc_play_new_piece():- 
    get_color(Color), pc_choose_hand_piece(Piece), pc_choose_position(Color, ChoosenHex),
    get_hex_row(ChoosenHex, Row), get_hex_column(ChoosenHex, Column),
    add_new_piece(hex(Row, Column, Piece, Color, 0)).


pc_move_one_piece() :- writeln("Simular PC movio ficha").             
                       
pc_next_move() :- 
    get_turn(Turn), get_color(Color),
    (Turn =:= 1 -> pc_first_play();
    Turn =:= 2 -> pc_second_play();
    % forzar a poner la reina abeja si no ha sido colocada antes del turno 4.
    (Color =:= 0, Turn =:= 7, not(its_the_queen_on_the_table(0)) -> force_queenBee(Color));
    (Color =:= 1, Turn =:= 8, not(its_the_queen_on_the_table(1)) -> force_queenBee(Color));
    % si esta puesta la reina generar una de las jugadas aleatorias.
    (Turn >=  2, its_the_queen_on_the_table(Color)) -> (random(1,2, R),
    (R =:= 1 -> pc_play_new_piece();
    R =:= 2 -> pc_move_one_piece()));
    % solo poner nuevas fichas si no se ha puesto la reina.
    pc_play_new_piece()
    ).
               


next_move(Name) :- 
    (Name =:= 0 -> player_next_move();
    pc_next_move()).

play(Color, Turn) :- 
    get_player(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), Current_Player),
    printInfo(Name, Color),
    write("Tablero antes de jugar"),
    print_board(_), 
    next_move(Name),
    write("Tablero despues de jugar"),
    print_board(_),         
    update_turn(NewTurn),
    update_color(NewColor),
    check_win_condition(NewTurn, Condition),
    (Condition =:= 3, play(NewColor, NewTurn)),
    writeln("GRACIAS POR JUGAR").

playerVsPC() :- init(), play(0, 1).

print_board(Board) :- 
    get_board(Board),
    writeln(""), 
    writeln(Board),
    writeln(""). 

