:- module(utils, [init_color/0, init_turn/0, get_color/1, get_turn/1,
                  update_color/1, update_turn/1, 
                  reverse/3]).

:- dynamic color/1.
:- dynamic turn/1.

% Color
init_color() :- assertz(color(0)).

get_color(Color) :- color(Color).

update_color(NewColor) :- color(OldColor), 
                  Aux is OldColor + 1,
                  NewColor is Aux mod 2,
                  retract(color(OldColor)),
                  assertz(color(NewColor)).

% Turn 
init_turn() :- assertz(turn(1)).

get_turn(Turn) :- turn(Turn).

update_turn(NewTurn) :- turn(Turn),
                        NewTurn is Turn + 1,
                        assertz(turn(NewTurn)),
                        retract(turn(Turn)).

% TOOLS
reverse([],Z,Z).
reverse([H|T],Z,Acc) :- reverse(T,Z,[H|Acc]).



