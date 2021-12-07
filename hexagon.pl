:- module(hexagon, [get_hex/2, new_hex/4, remove_hex/4, get_all_hexs/1,
                    get_hex_row/2, get_hex_column/2,
                    get_hexs_by_color/2, get_possible_moves/2]).

:- dynamic hex/4.

new_hex(Row, Column, Bug, Color) :- assertz(hex(Row, Column, Bug, Color)).

remove_hex(Row, Column, Bug, Color) :- retract(hex(Row, Column, Bug, Color)).

get_hex_row(hex(Row, _, _, _), Row).

get_hex_column(hex(_, Column, _, _), Column).

get_hex_bug(hex(_, _, Bug, _), Bug).

get_hex_color(hex(_, _, _, Color), Color).

get_hex(hex(Row, Column, Bug, Color), hex(Row, Column, Bug, Color)) :- hex(Row, Column, Bug, Color).

get_all_hexs(Hexs) :- findall(Hex, get_hex(_, Hex), Hexs).

get_hexs_by_color(Color, Hexs) :- findall(Hex, get_hex(hex(_, _, _, Color), Hex), Hexs).

% get_neighbour1(hex(Row, Column, _, _), Neighbour) :- NeighbourRow is Row - 1, NeighbourColumn is Column + 1, Neighbour = hex(NeighbourRow, NeighbourColumn, _, _).
% get_neighbour2(hex(Row, Column, _, _), Neighbour) :- NeighbourRow is Row + 1, NeighbourColumn is Column + 1, Neighbour = hex(NeighbourRow, NeighbourColumn, _, _).
% get_neighbour3(hex(Row, Column, _, _), Neighbour) :- NeighbourRow is Row + 2, Neighbour = hex(NeighbourRow, Column, _, _).
% get_neighbour4(hex(Row, Column, _, _), Neighbour) :- NeighbourRow is Row + 1, NeighbourColumn is Column - 1, Neighbour = hex(NeighbourRow, NeighbourColumn, _, _).
% get_neighbour5(hex(Row, Column, _, _), Neighbour) :- NeighbourRow is Row - 1, NeighbourColumn is Column - 1, Neighbour = hex(NeighbourRow, NeighbourColumn, _, _).
% get_neighbour6(hex(Row, Column, _, _), Neighbour) :- NeighbourColumn is Column + 2, Neighbour = hex(Row, NeighbourColumn, _, _).

% get_neighbour(Hex, Neighbour) :- get_neighbour1(Hex, Neighbour);                                                     
%                                  get_neighbour2(Hex, Neighbour);
%                                  get_neighbour3(Hex, Neighbour);
%                                  get_neighbour4(Hex, Neighbour);
%                                  get_neighbour5(Hex, Neighbour);
%                                  get_neighbour6(Hex, Neighbour).

% get_all_neighbours(Hex, Neighbours) :- findall(Neighbour, get_neighbour(Hex, Neighbour), Neighbours).


%get_vecinos
get_neighbours(hex(Row,Column, _,_), Neighbours) :- get_neighbours_aux(hex(Row,Column, _, _), [-1,1,2,1,-1,-2], [1,1,0,-1,-1,0], Neighbours).

%get_vecinos_aux
get_neighbours_aux(_,[],[],[]).
get_neighbours_aux(hex(Row, Column, _, _), [X|DirR], [Y|DirC], Neighbours) :- NewRow is Row + X,
                                                                              NewColumn is Column + Y,
                                                                              ((get_hex(hex(NewRow, NewColumn, _, _), N), !, N_N = [N]);
                                                                              (N_N = [])),
                                                                              get_neighbours_aux(hex(Row, Column, _, _), DirR, DirC, Old_Neighbours),
                                                                              append(N_N,Old_Neighbours, Neighbours).

%get_vecinos_vacios
get_empty_neighbours(hex(Row,Column,_,_), EmptyNeighbours) :- get_empty_neighbours_aux(hex(Row,Column,_,_), [-1,1,2,1,-1,-2],[1,1,0,-1,-1,0], EmptyNeighbours).

%get_vecinos_vacios_aux
get_empty_neighbours_aux(_, [], [], []).
get_empty_neighbours_aux(hex(Row,Column,_,_), [X|DirR], [Y|DirC], EmptyNeighbours) :- NewRow is Row + X,
                                                                              NewColumn is Column + Y,
                                                                              ((not(get_hex(hex(NewRow, NewColumn, _, _),_)),
                                                                              Empty_N = [hex(NewRow, NewColumn, _, _)], !);
                                                                              Empty_N = []),
                                                                              get_empty_neighbours_aux(hex(Row, Column, _, _), DirR, DirC, Empty_Neighbours),
                                                                              append(Empty_N, Empty_Neighbours, EmptyNeighbours).



%find_vecinos_by_edad
find_neighbours_by_color([],_,[]).
find_neighbours_by_color([X|Neighbours], Color, DistinctNeighbours) :- ((get_hex(X,_), get_hex_color(X,Color1), Color1 =\= Color, Y = [X]) ; (Y = [])),
                                                                        find_neighbours_by_color(Neighbours, Color, OldDistinctNeighbours),
                                                                        append(Y, OldDistinctNeighbours, DistinctNeighbours).


%get_vecinos_posibles 
get_possible_neighbours([], _, []).
get_possible_neighbours([X|EmptyNeighbours], Color, PossibleNeighbours) :- get_neighbours(X, Neighbours),
                                                                               find_neighbours_by_color(Neighbours, Color, DistinctNeighbours),
                                                                               get_possible_neighbours(EmptyNeighbours, Color, OldPossibleNeighbours),
                                                                               ((DistinctNeighbours = [], !, Y = [X]) ; (Y = [])),
                                                                               append(Y, OldPossibleNeighbours, PossibleNeighbours).


%get_vecinos_finales
get_possible_moves([], []).
get_possible_moves([X|SameColorHexs], PossibleMoves) :- get_empty_neighbours(X, EmptyNeighbours),
                                                              get_hex_color(X, Color),
                                                              get_possible_neighbours(EmptyNeighbours, Color, PossibleNeighbours),
                                                              get_possible_moves(SameColorHexs, OldPossibleMoves),
                                                              append(PossibleNeighbours, OldPossibleMoves, PossibleMoves).

