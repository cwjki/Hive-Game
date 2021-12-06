:- module(utils, [init_color/0, init_turn/0, get_color/1, get_turn/1,
                  update_color/1, update_turn/1]).

:- dynamic color/1.
:- dynamic turn/1.

init_color() :- assertz(color(0)).

get_color(Color) :- color(Color).

update_color(NewColor) :- color(OldColor), 
                  Aux is OldColor + 1,
                  NewColor is Aux mod 2,
                  assertz(color(NewColor)),
                  retract(color(OldColor)).


init_turn() :- assertz(turn(1)).

get_turn(Turn) :- turn(Turn).

update_turn(NewTurn) :- turn(Turn),
                        NewTurn is Turn + 1,
                        assertz(turn(NewTurn)),
                        retract(turn(Turn)).




