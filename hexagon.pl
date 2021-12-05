:- dynamic hex/4.

new_hex(Row, Column, Bug, Color) :- assertz(hex(Row, Column, Bug, Color)).

remove_hex(Row, Column, Bug, Color) :- retract(hex(Row, Column, Bug, Color)).

get_hex_row(hex(Row, _, _, _), Row).

get_hex_column(hex(_, Column, _, _), Column).

get_hex_bug(hex(_, _, Bug, _), Bug).

get_hex_color(hex(_, _, _, Color), Color).

get_hex(hex(Row, Column, Bug, Color), hex(Row, Column, Bug, Color)) :- hex(Row, Column, Bug, Color).

get_all_hexs(Hexs) :- findall(Hex, get_hex(Hex, _), Hexs).


:- module(hexagon, [new_hex/4, remove_hex/4, get_hex_row/2, get_hex_column/2, get_hex_bug/2, get_hex_color/2, get_hex/2, get_all_hexs/1]).

