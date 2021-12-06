consult(hexagon).
consult(player).


get_board(Board) :- get_all_hexs(Board).

add_new_piece(hex(Row, Column, Bug, Color)) :- get_player(player(_, Color, _, _, _, _, _, _, _, _), Player),
                                               update_player_hand(Bug, Player, NewPlayer),
                                               new_hex(Row, Column, Bug, Color).

move_piece(OriginRow, OriginColumn, DestinyRow, DestinyColumn) :- get_hex(OriginRow, OriginColumn, Bug, Color),
                                                                  remove_hex(OriginRow, OriginColumn, Bug, Color),
                                                                  new_hex(DestinyRow, DestinyColumn, Bug, Color).


