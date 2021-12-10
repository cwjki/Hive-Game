:- module(hexagon, [get_hex/2, new_hex/1,
                    remove_hex/1, get_all_hexs/1,
                    get_hex_row/2, get_hex_column/2,
                    get_hex_color/2, get_hex_level/2,
                    get_hexs_by_color/2, get_free_positions/2,
                    get_empty_neighbours/2, get_useless_hex/2,
                    only_one_hive/1,
                    reachable_path/2,
                    keep_all_together/3,
                    get_hive_empty_neighbours/2,
                    get_multiple_slidable_neighbours/2,
                    get_multiple_empty_neighbours/2,
                    get_multiple_neighbours/2,
                    get_slidable_neighbours/2,                 
                    its_slidable/2,
                    get_neighbours/2,
                    get_hex_bug/2,
                    check_queen/1,
                    dfs/2,
                    get_first_empty/5,
                    get_possible_hex_by_direction/2,
                    its_the_queen_on_the_table/1]).

:- dynamic hex/5.
:- dynamic uselessHex/5.

new_hex(hex(Row, Column, Bug, Color, Level)) :- 
    not(get_hex(hex(Row, Column, _, _, _), Hex)),
    assertz(hex(Row, Column, Bug, Color, 0)), !.

new_hex(hex(Row, Column, Bug, Color, Level)) :- 
    get_hex(hex(Row, Column, OldBug, OldColor, OldLevel), OldHex),
    new_useless_hex(uselessHex(Row, Column, OldBug, OldColor, OldLevel)),
    retract(OldHex),
    NewLevel is OldLevel + 1,
    assertz(hex(Row, Column, Bug, Color, NewLevel)).


remove_hex(hex(Row, Column, Bug, Color, Level)) :- 
    Level =:= 0, 
    retract(hex(Row, Column, Bug, Color, Level)), !.

remove_hex(hex(Row, Column, Bug, Color, Level)) :-
    retract(hex(Row, Column, Bug, Color, Level)),
    NewLevel is Level - 1,
    get_useless_hex(uselessHex(Row, Column, NewBug, NewColor, NewLevel), NewHex),
    remove_useless_hex(NewHex),
    assertz(hex(Row, Column, NewBug, NewColor, NewLevel)).


get_hex_row(hex(Row, _, _, _, _), Row).

get_hex_column(hex(_, Column, _, _, _), Column).

get_hex_bug(hex(_, _, Bug, _, _), Bug).

get_hex_color(hex(_, _, _, Color, _), Color).

get_hex_level(hex(_, _, _, _, Level), Level).

get_hex(hex(Row, Column, Bug, Color, Level), hex(Row, Column, Bug, Color, Level)) :- hex(Row, Column, Bug, Color, Level).

get_all_hexs(Hexs) :- findall(Hex, get_hex(_, Hex), Hexs).

get_hexs_by_color(Color, Hexs) :- findall(Hex, get_hex(hex(_, _, _, Color, _), Hex), Hexs).


%get_vecinos
get_neighbours(hex(Row, Column, Bug, Color, Level), Neighbours) :- 
    get_neighbours_aux(hex(Row, Column, Bug, Color, Level), [-1,1,2,1,-1,-2], [1,1,0,-1,-1,0], Neighbours).

%get_vecinos_aux
get_neighbours_aux(_,[],[],[]).
get_neighbours_aux(hex(Row, Column, Bug, Color, Level), [X|DirR], [Y|DirC], Neighbours) :- 
    NewRow is Row + X,
    NewColumn is Column + Y,
    ((get_hex(hex(NewRow, NewColumn, B, C, L), N), !, N_N = [N]);
    (N_N = [])),
    get_neighbours_aux(hex(Row, Column, Bug, Color, Level), DirR, DirC, Old_Neighbours),
    append(N_N,Old_Neighbours, Neighbours).

%get_vecinos_vacios
get_empty_neighbours(hex(Row, Column, _, _, _), EmptyNeighbours) :- 
    get_empty_neighbours_aux(hex(Row, Column, _, _, _), [-1,1,2,1,-1,-2],[1,1,0,-1,-1,0], EmptyNeighbours).

%get_vecinos_vacios_aux
get_empty_neighbours_aux(_, [], [], []).
get_empty_neighbours_aux(hex(Row, Column, _, _, _), [X|DirR], [Y|DirC], EmptyNeighbours) :- 
    NewRow is Row + X,
    NewColumn is Column + Y,
    ((not(get_hex(hex(NewRow, NewColumn, _, _, _),_)),
    Empty_N = [hex(NewRow, NewColumn, null, null, 0)], !);
    Empty_N = []),
    get_empty_neighbours_aux(hex(Row, Column, _, _, _), DirR, DirC, Empty_Neighbours),
    append(Empty_N, Empty_Neighbours, EmptyNeighbours).



%find_vecinos_by_edad
find_neighbours_by_color([],_,[]).
find_neighbours_by_color([X|Neighbours], Color, DistinctNeighbours) :- 
    ((get_hex(X,_), get_hex_color(X,Color1), Color1 =\= Color, Y = [X]) ; (Y = [])),
    find_neighbours_by_color(Neighbours, Color, OldDistinctNeighbours),
    append(Y, OldDistinctNeighbours, DistinctNeighbours).


%get_vecinos_posibles 
get_possible_neighbours([], _, []).
get_possible_neighbours([X|EmptyNeighbours], Color, PossibleNeighbours) :- 
    get_neighbours(X, Neighbours),
    find_neighbours_by_color(Neighbours, Color, DistinctNeighbours),
    get_possible_neighbours(EmptyNeighbours, Color, OldPossibleNeighbours),
    ((DistinctNeighbours = [], !, Y = [X]) ; (Y = [])),
    append(Y, OldPossibleNeighbours, PossibleNeighbours).


%get_vecinos_finales
get_free_positions([], []).
get_free_positions([X|SameColorHexs], PossibleMoves) :- 
    get_empty_neighbours(X, EmptyNeighbours),
    get_hex_color(X, Color),
    get_possible_neighbours(EmptyNeighbours, Color, PossibleNeighbours),
    get_free_positions(SameColorHexs, OldPossibleMoves),
    append(PossibleNeighbours, OldPossibleMoves, UnsortedPossibleMoves),
    sort(UnsortedPossibleMoves, PossibleMoves).

% buscar el primero vacio en una direccion en linea recta (Grasshopper)
get_first_empty(OriginHex, X,Y, Accumulated, Hex) :-
    get_hex(OriginHex, hex(Row, Column, _, _, _)),
    NewRow is Row + X,
    NewColumn is Column + Y,
    ((get_hex(hex(NewRow, NewColumn, _, _, _), NewOrigin), get_first_empty(NewOrigin, X,Y, Accumulated, Hex));
    (H = [hex(NewRow, NewColumn, null, null, 0)], append(H, Accumulated, Hex))).
    
% devuelve todas las casillas donde el Grasshopper puede aterrizar.
get_possible_hex_by_direction(OriginHex, PossibleHD) :- 
    get_hex_row(OriginHex, Row), get_hex_column(OriginHex, Column),
    Hex0 = [],
    Row1 is Row - 1, Column1 is Column + 1,
    ((get_hex(hex(Row1, Column1, _, _, _), _), 
    get_first_empty(OriginHex, -1,1, Hex0, Hex1));  Hex1 = Hex0),
    Row2 is Row + 1, Column2 is Column + 1,
    ((get_hex(hex(Row2, Column2, _, _, _), _), 
    get_first_empty(OriginHex, 1,1, Hex1, Hex2));  Hex2 = Hex1),
    Row3 is Row + 2,
    ((get_hex(hex(Row3, Column, _, _, _), _), 
    get_first_empty(OriginHex, 2,0, Hex2, Hex3));  Hex3 = Hex2),
    Row4 is Row + 1, Column4 is Column - 1,
    ((get_hex(hex(Row4, Column4, _, _, _), _), 
    get_first_empty(OriginHex, 1, -1, Hex3, Hex4));  Hex4 = Hex3),
    Row5 is Row - 1, Column5 is Column - 1,
    ((get_hex(hex(Row5, Column5, _, _, _), _), 
    get_first_empty(OriginHex, -1, -1, Hex4, Hex5));  Hex5 = Hex4),
    Row6 is Row - 2,
    ((get_hex(hex(Row6, Column, _, _, _), _), 
    get_first_empty(OriginHex, -2, 0, Hex5, PossibleHD));  PossibleHD = Hex5).


%% Dfs starting from a root
dfs(Hex, Result) :-
    dfs_aux([Hex], [], Result).
%% dfs(ToVisit, Visited)
%% Done, all visited
dfs_aux([], Visited, Visited) :- !.
%% Skip elements that are already visited
dfs_aux([H|T],Visited, Result) :-
    member(H,Visited),
    dfs_aux(T,Visited, Result).
%% Add all neigbors of the head to the toVisit
dfs_aux([H|T],Visited, Result) :-
    not(member(H,Visited)),
    get_neighbours(H, Neighbours),
    append(Neighbours,T, ToVisit),
    dfs_aux(ToVisit,[H|Visited], Result).


only_one_hive([H|Hexs]) :- 
    dfs(H, Reachable),
    length(Reachable, RLength),
    length(Hexs, Length), HLength is Length + 1,
    RLength =:= HLength.


keep_all_together(_, [], []).
keep_all_together(Hexs, [X|Neighbours], NewPossibleHexs) :- 
    new_hex(X),
    get_all_hexs(NewHexs),
    ((only_one_hive(NewHexs), Y = [X]);
    Y = []),
    get_hex_row(X, Row), get_hex_column(X, Column),
    get_hex(hex(Row, Column, _, _, _), NewX),
    remove_hex(NewX),
    keep_all_together(Hexs, Neighbours, PossibleHexs),
    append(Y,PossibleHexs,NewPossibleHexs). 


%devuelve los vecinos de la entrada
get_multiple_neighbours([], []).
get_multiple_neighbours([X|PossibleStep], Neighbours) :-
    get_neighbours(X, SingleNeighbours),
    get_multiple_neighbours(PossibleStep, OldNeighbours),
    % findall(M, (member(M, SingleNeighbours), not(member(M, PossibleStep)), M \== X), Result),
    append(SingleNeighbours, OldNeighbours, Neighbours).

%devuelve los vecinos vacios
get_multiple_empty_neighbours([], []).
get_multiple_empty_neighbours([X|PossibleStep], EmptyNeighbours) :-
    get_empty_neighbours(X, SingleEmptyNeighbours),
    get_multiple_empty_neighbours(PossibleStep, OldEmptyNeighbours),
    findall(M, (member(M, SingleEmptyNeighbours), not(member(M, PossibleStep)), M \== X), Result),
    append(Result, OldEmptyNeighbours, EmptyNeighbours).

%devuelve los vecinos vacios deslizables de la entrada
get_multiple_slidable_neighbours([], []).
get_multiple_slidable_neighbours([X|PossibleStep], EmptyNeighbours) :-
    get_slidable_neighbours(X, SingleEmptyNeighbours),
    get_multiple_slidable_neighbours(PossibleStep, OldEmptyNeighbours),
    findall(M, (member(M, SingleEmptyNeighbours), not(member(M, PossibleStep)), M \== X), Result),
    append(Result, OldEmptyNeighbours, EmptyNeighbours).

%devuelve de la entrada, los que tienen vecinos ocupados (NO DEVUELVE LOS VECINOS OCUPADOS)
get_hive_empty_neighbours([], []).
get_hive_empty_neighbours([X|EmptyNeighbours], Neighbours) :-
    get_neighbours(X, SingleNeighbours),
    get_hive_empty_neighbours(EmptyNeighbours, OldNeighbours),
    ((length(SingleNeighbours, Length), Length =\= 0, Y = [X]); Y = []),
    append(Y, OldNeighbours, Neighbours).


reachable_path(Hex, Result) :-
    reachable_path_aux([Hex], [], Result).

reachable_path_aux([], Visited, Visited) :- !.
reachable_path_aux([H|T], Visited, Result) :-
    member(H, Visited),
    reachable_path_aux(T, Visited, Result).
reachable_path_aux([H|T], Visited, Result) :-
    not(member(H, Visited)),
    get_slidable_neighbours(H, EmptyNeighbours),
    get_hive_empty_neighbours(EmptyNeighbours, ValidHexs),
    append(ValidHexs, T, ToVisit),
    reachable_path_aux(ToVisit, [H|Visited], Result).


% USELESS BUGS 

new_useless_hex(uselessHex(Row, Column, Bug, Color, Level)) :- assertz(uselessHex(Row, Column, Bug, Color, Level)).

remove_useless_hex(uselessHex(Row, Column, Bug, Color, Level)) :- retract(uselessHex(Row, Column, Bug, Color, Level)).

get_useless_hex_row(uselessHex(Row, _, _, _, _), Row).

get_useless_hex_column(uselessHex(_, Column, _, _, _), Column).

get_useless_hex_level(uselessHex(_, _, _, _, Level), Level).

get_useless_hex(uselessHex(Row, Column, Bug, Color, Level), uselessHex(Row, Column, Bug, Color, Level)) :- uselessHex(Row, Column, Bug, Color, Level).

get_all_useless_hexs(UselessHexs) :- findall(Hex, get_useless_hex(_, Hex), UselessHexs).


its_the_queen_on_the_table(Color) :- 
    get_hex(hex(_, _, 1, Color, _), _);
    get_useless_hex(uselessHex(_, _, 1, Color, _), _).


check_queen(Color) :-
    its_the_queen_on_the_table(Color),
    get_hex(hex(_, _, 1, Color, _), Queen),
    get_empty_neighbours(Queen, Neighbours),
    length(Neighbours, 0).


its_slidable(OriginHex, DestinyHex) :- 
    get_neighbours(OriginHex, ONeighbours),
    get_neighbours(DestinyHex, DNeighbours),
    findall(H, (member(H, ONeighbours), member(H, DNeighbours)), Result),
    length(Result, Length),
    Length < 2.

get_slidable_neighbours(OriginHex, SlidableNeighbours) :-
    get_empty_neighbours(OriginHex, EmptyNeighbours),
    findall(H, (member(H, EmptyNeighbours), its_slidable(OriginHex, H)), SlidableNeighbours).
