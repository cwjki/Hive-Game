:- dynamic hex/4.

new_hex(Row, Column, Bug, Color) :- assertz(hex(Row, Column, Bug, Color)).

remove_hex(Row, Column, Bug, Color) :- retract(hex(Row, Column, Bug, Color)).

get_hex_row(hex(Row, _, _, _), Row).

get_hex_column(hex(_, Column, _, _), Column).

get_hex_bug(hex(_, _, Bug, _), Bug).

get_hex_color(hex(_, _, _, Color), Color).

get_hex(hex(Row, Column, Bug, Color), hex(Row, Column, Bug, Color)) :- hex(Row, Column, Bug, Color).

get_all_hexs(Hexs) :- findall(Hex, get_hex(_, Hex), Hexs).

get_hex_by_color(Color, Hexs) :- findall(Hex, get_hex(hex(_, _, _, Color), Hex), Hexs).

get_neighbour1(hex(Row, Column, _, _), Neighbour) :- NeighbourRow is Row - 1, NeighbourColumn is Column + 1, Neighbour = hex(NeighbourRow, NeighbourColumn, _, _).
get_neighbour2(hex(Row, Column, _, _), Neighbour) :- NeighbourRow is Row + 1, NeighbourColumn is Column + 1, Neighbour = hex(NeighbourRow, NeighbourColumn, _, _).
get_neighbour3(hex(Row, Column, _, _), Neighbour) :- NeighbourRow is Row + 2, Neighbour = hex(NeighbourRow, Column, _, _).
get_neighbour4(hex(Row, Column, _, _), Neighbour) :- NeighbourRow is Row + 1, NeighbourColumn is Column - 1, Neighbour = hex(NeighbourRow, NeighbourColumn, _, _).
get_neighbour5(hex(Row, Column, _, _), Neighbour) :- NeighbourRow is Row - 1, NeighbourColumn is Column - 1, Neighbour = hex(NeighbourRow, NeighbourColumn, _, _).
get_neighbour6(hex(Row, Column, _, _), Neighbour) :- NeighbourColumn is Column + 2, Neighbour = hex(Row, NeighbourColumn, _, _).

get_neighbour(Hex, Neighbour) :- get_neighbour1(Hex, Neighbour);                                                     
                                 get_neighbour2(Hex, Neighbour);
                                 get_neighbour3(Hex, Neighbour);
                                 get_neighbour4(Hex, Neighbour);
                                 get_neighbour5(Hex, Neighbour);
                                 get_neighbour6(Hex, Neighbour).

get_all_neighbours(Hex, Neighbours) :- findall(Neighbour, get_neighbour(Hex, Neighbour), Neighbours).


