:dynamic color/1.
:dynamic turn/1.

init_color() :- assertz(color(0)).

get_color(Color) :- color(Color).

update_color(NewColor) :- color(OldColor), 
                  Aux is OldColor + 1,
                  NewColor is Aux mod 2,
                  retract(color(OldColor)),
                  assertz(color(NewColor)).


init_turn() :- assertz(turn(0)).

get_turn(Turn) :- turn(Turn).

update_turn(NewTurn) :- turn(Turn),
                        NewTurn is Turn + 1,
                        retract(turn(Turn)),
                        assertz(turn(NewTurn)).




