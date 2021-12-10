:- module(movements, [get_moves/2]).

:- use_module(hexagon).


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
    findall(H, (member(H, AntPath), get_hex_row(H, HRow), get_hex_column(H, HColumn),(HRow \== Row; HColumn \== Column)), Path),
    get_all_hexs(Hexs),
    keep_all_together(Hexs, Path, OldPossibleHexs),
    sort(OldPossibleHexs, PossibleHexs),
    new_hex(OriginHex).

% move_a_mosquito(OriginHex, PossibleHexs) :- 
%     get_hex(OriginHex, hex(Row, Column, _, Color, Level)),
%     remove_hex(OriginHex),
%     ((Level =:= 0,
%     (get_neighbours(OriginHex, Neighbours), 
%     ((lenght(Neighbours, 1), nth1(1,Neighbours,H), get_hex_bug(H, 6), PossibleHexs = []);
%     get_multiple_bug(Neighbours, Bugs),
%     choose_bug(Bugs, ChoosenBug),
%     new_hex(hex(Row, Column, ChoosenBug, Color, Level))),
%     possible_to_move(hex(Row, Column, ChoosenBug, Color, Level), PossibleHexs),
%     remove_hex(hex(Row, Column, ChoosenBug, Color, Level))));
%     (Level > 0, (
%     new_hex(hex(Row, Column, 4, Color, Level)),
%     move_a_scarab(hex(Row, Column, 4, Color, Level), PossibleHexs),
%     remove_hex(hex(Row, Column, 4, Color, Level))))),
%     new_hex(OriginHex).

% get_multiple_bug([], []) :- !.
% get_multiple_bug([H|Hexs], Bugs) :-
%     get_hex_bug(H, Bug),
%     ((member(H, Bugs), Y = []);
%     (not(member(H, Bugs)), Y = [Bug])),
%     get_multiple_bug(Hexs, OldBugs),
%     append(Y, OldBugs, Bugs).

get_moves(OriginHex, PossibleDestinies) :- 
    get_hex_bug(OriginHex, Bug),
    (Bug =:= 1 -> move_a_queen(OriginHex, PossibleDestinies);
    Bug =:= 2 -> move_an_ant(OriginHex, PossibleDestinies);
    Bug =:= 3 -> move_a_grasshopper(OriginHex, PossibleDestinies);
    Bug =:= 4 -> move_a_scarab(OriginHex, PossibleDestinies);   
    Bug =:= 5 -> move_a_spider(OriginHex, PossibleDestinies);
    
    %  Bug =:= 6 -> move_a_mosquito(OriginHex, PossibleDestinies);
    Bug =:= 7 -> move_a_ladybug(OriginHex, PossibleDestinies);
    %  Bug =:= 8 -> move_a_pillbug(OriginHex, PossibleDestinies)
    PossibleDestinies = []
    ).