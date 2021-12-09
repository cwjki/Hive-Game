:- module(board, [add_new_piece/1, get_possible_positions/2, get_board/1,
                  its_the_queen_on_the_table/1, get_possible_moves/2,
                  move_piece/2]).

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

its_the_queen_on_the_table(Color) :- get_hex(hex(_, _, 1, Color, _), _).

get_possible_positions(Color, Positions) :- 
    get_hexs_by_color(Color, SameColorHexs),
    get_free_positions(SameColorHexs, Positions).

get_possible_moves(Hex, Moves) :- 
    get_moves(Hex, Moves).


