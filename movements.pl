:- module(movements, [get_moves/2]).

:- use_module(hexagon).
:- use_module(game).


move_a_queen(OriginHex, PossibleHexs) :- 
    get_slidable_neighbours(OriginHex, Neighbours),
    remove_hex(OriginHex),
    get_all_hexs(Hexs),
    keep_all_together(Hexs, Neighbours, PossibleHexs),
    new_hex(OriginHex).
    

move_a_scarab(OriginHex, PossibleHexs) :-
    get_hex_level(OriginHex, Level),
    ((Level =:= 0, get_slidable_neighbours(OriginHex, EmptyNeighbours));
    (Level > 0, get_empty_neighbours(OriginHex, EmptyNeighbours))),
    get_neighbours(OriginHex, Neighbours),
    append(EmptyNeighbours, Neighbours, AllNeighbours),
    remove_hex(OriginHex),
    get_all_hexs(Hexs),
    keep_all_together(Hexs, AllNeighbours, PossibleHexs),
    new_hex(OriginHex).


move_a_grasshopper(OriginHex, PossibleHexs) :- 
    get_possible_hex_by_direction(OriginHex, PossibleHD),
    remove_hex(OriginHex),
    get_all_hexs(Hexs),
    keep_all_together(Hexs, PossibleHD, PossibleHexs),
    new_hex(OriginHex).


move_a_spider(OriginHex, PossibleHexs) :- 
    get_slidable_neighbours(OriginHex, EmptyNeighbours),
    remove_hex(OriginHex),
    get_hive_empty_neighbours(EmptyNeighbours, PossibleFirstStep),
    new_hex(OriginHex),
    get_multiple_slidable_neighbours(PossibleFirstStep, PossibleEmptyFirstNeighbours),
    remove_hex(OriginHex),
    get_hive_empty_neighbours(PossibleEmptyFirstNeighbours, PossibleSecondStep),
    new_hex(OriginHex),
    get_multiple_slidable_neighbours(PossibleSecondStep, PossibleEmptySecondNeighbours),
    remove_hex(OriginHex),
    get_hive_empty_neighbours(PossibleEmptySecondNeighbours, PossibleThirdStep),
    findall(H, (member(H, PossibleThirdStep), not(member(H, PossibleFirstStep))), ThirdStep),
    get_all_hexs(Hexs),
    keep_all_together(Hexs, ThirdStep, OldPossibleHexs),
    sort(OldPossibleHexs, PossibleHexs),
    new_hex(OriginHex).

move_a_ladybug(OriginHex, PossibleHexs) :- 
    get_neighbours(OriginHex, PossibleFirstStep),
    remove_hex(OriginHex),
    get_multiple_neighbours(PossibleFirstStep, OldPossibleSecondStep),
    sort(OldPossibleSecondStep, PossibleSecondStep),
    new_hex(OriginHex),
    get_multiple_empty_neighbours(PossibleSecondStep, PossibleThirdStep),
    remove_hex(OriginHex),
    get_all_hexs(Hexs),
    keep_all_together(Hexs, PossibleThirdStep, OldPossibleHexs),
    sort(OldPossibleHexs, PossibleHexs),
    new_hex(OriginHex).

move_an_ant(OriginHex, PossibleHexs) :-
    remove_hex(OriginHex),
    reachable_path(OriginHex, AntPath),
    get_hex_row(OriginHex, Row), get_hex_column(OriginHex, Column),
    findall(H, (member(H, AntPath), get_hex_row(H, HRow), get_hex_column(H, HColumn), not((HRow =:= Row, HColumn =:= Column))), Path),
    get_all_hexs(Hexs),
    keep_all_together(Hexs, Path, OldPossibleHexs),
    sort(OldPossibleHexs, PossibleHexs),
    new_hex(OriginHex).


get_possible_mosquito_move(_, [], []) :- !.
get_possible_mosquito_move(OriginHex, [B|Bugs], TotalMoves) :-
    get_hex_row(OriginHex, Row), get_hex_column(OriginHex, Column),
    get_hex_color(OriginHex, Color), get_hex_level(OriginHex, Level),
    new_hex(hex(Row, Column, B, Color, Level)),
    get_moves(hex(Row, Column, B, Color, Level), PossibleMoves),
    remove_hex(hex(Row, Column, B, Color, Level)),
    get_possible_mosquito_move(OriginHex, Bugs, OldTotalMoves),
    append(PossibleMoves, OldTotalMoves, TotalMoves).


move_a_mosquito(OriginHex, PossibleHexs) :-
    remove_hex(OriginHex),
    move_a_mosquito_aux(OriginHex, PossibleHexs),
    new_hex(OriginHex).

move_a_mosquito_aux(OriginHex, PossibleHexs) :- 
    get_hex_level(OriginHex, Level),
    Level =:= 0,
    get_neighbours(OriginHex, Neighbours),
    length(Neighbours, Length),
    Length =:= 1,
    nth1(1, Neighbours, N), 
    get_hex_bug(N, 6), !,
    PossibleHexs = []. 

move_a_mosquito_aux(OriginHex, PossibleHexs) :-
    get_hex_level(OriginHex, Level),
    Level =:= 0, !,
    get_neighbours(OriginHex, Neighbours),
    get_neighbours_bugs(Neighbours, OldBugs),
    sort(OldBugs, Bugs),
    get_possible_mosquito_move(OriginHex, Bugs, PossibleHexs).

move_a_mosquito_aux(OriginHex, PossibleHexs) :-
    get_hex_level(OriginHex, Level),
    Level > 0,
    get_hex_row(OriginHex, Row), get_hex_column(OriginHex, Column),
    get_hex_color(OriginHex, Color),
    new_hex(hex(Row, Column, 4, Color, Level)),
    move_a_scarab(hex(Row, Column, 4, Color, Level), PossibleHexs),
    remove_hex(hex(Row, Column, 4, Color, Level)).


get_neighbours_bugs([], []).
get_neighbours_bugs([N|Neighbours], Bugs) :-
    get_hex_bug(N, Bug),
    get_neighbours_bugs(Neighbours, OldBugs),
    ((Bug =\= 6, Y = [Bug]); Y = []),
    append(Y, OldBugs, Bugs).


get_moves(OriginHex, PossibleDestinies) :- 
    get_hex_bug(OriginHex, Bug),
    (Bug =:= 1 -> move_a_queen(OriginHex, PossibleDestinies);
    Bug =:= 2 -> move_an_ant(OriginHex, PossibleDestinies);
    Bug =:= 3 -> move_a_grasshopper(OriginHex, PossibleDestinies);
    Bug =:= 4 -> move_a_scarab(OriginHex, PossibleDestinies);   
    Bug =:= 5 -> move_a_spider(OriginHex, PossibleDestinies);
    Bug =:= 6 -> move_a_mosquito(OriginHex, PossibleDestinies);
    Bug =:= 7 -> move_a_ladybug(OriginHex, PossibleDestinies);
    %  Bug =:= 8 -> move_a_pillbug(OriginHex, PossibleDestinies)
    PossibleDestinies = []
    ).
