:- module(board, 
    [   add_new_piece/1, get_possible_positions/2, get_board/1,
        get_possible_moves/2,
        move_piece/2,
        check_win_condition/2,
        get_possible_piece_to_move/2
    ]
).

:- use_module(hexagon).
:- use_module(player).
:- use_module(movements).

get_board(Board) :- get_all_hexs(Board).

add_new_piece(hex(Row, Column, Bug, Color, Level)) :- 
    get_player(player(_, Color, _, _, _, _, _, _, _, _), Player),
    update_player_hand(Bug, Player, NewPlayer),
    new_hex(hex(Row, Column, Bug, Color, Level)).

move_piece(OriginHex, DestinyHex) :- 
    get_hex_bug(OriginHex, Bug),
    get_hex_color(OriginHex, Color),
    get_hex_level(OriginHex, Level),
    get_hex_row(DestinyHex, DestinyRow), get_hex_column(DestinyHex, DestinyColumn),
    remove_hex(OriginHex),
    new_hex(hex(DestinyRow, DestinyColumn, Bug, Color, Level)).

get_possible_positions(Color, Positions) :- 
    get_hexs_by_color(Color, SameColorHexs),
    get_free_positions(SameColorHexs, Positions).

get_possible_moves(Hex, Moves) :- 
    get_moves(Hex, Moves).

get_possible_piece_to_move([],[]).
get_possible_piece_to_move([H|Hexs], Pieces) :-
    get_possible_moves(H, PossibleMoves),
    get_possible_piece_to_move(Hexs, OldResult),
    ((length(PossibleMoves, Length), Length =\= 0, Y = [H]); Y = []),
    append(Y, OldResult, Pieces).


check_win_condition(Turn, Condition) :-
    (Turn > 100, Condition = 2, writeln("LA PARTIDA HA TERMINADO EN EMPATE"));
    (check_queen(0), ((check_queen(1), Condition = 2, writeln("LA PARTIDA HA TERMINADO EN EMPATE"));
    Condition = 1, writeln("HA GANADO EL JUGADOR CON LAS FICHAS NEGRAS")));
    (check_queen(1), Condition = 0, writeln("HA GANADO EL JUGADOR CON LAS FICHAS BLANCAS"));
    Condition = 3.

    
