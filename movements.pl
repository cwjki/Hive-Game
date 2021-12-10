:- module(movements, [get_moves/2]).

:- use_module(hexagon).


move_a_queen(OriginHex, PossibleHexs) :- 
    get_slidable_neighbours(OriginHex, Neighbours),
    remove_hex(OriginHex),
    get_all_hexs(Hexs),
    keep_all_together(Hexs, Neighbours, PossibleHexs),
    new_hex(OriginHex).
    

move_a_scarab(OriginHex, PossibleHexs) :- 
    get_slidable_neighbours(OriginHex, EmptyNeighbours),
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
    get_multiple_empty_neighbours(PossibleFirstStep, PossibleEmptyFirstNeighbours),
    remove_hex(OriginHex),
    get_hive_empty_neighbours(PossibleEmptyFirstNeighbours, PossibleSecondStep),
    new_hex(OriginHex),
    get_multiple_empty_neighbours(PossibleSecondStep, PossibleEmptySecondNeighbours),
    remove_hex(OriginHex),
    get_hive_empty_neighbours(PossibleEmptySecondNeighbours, PossibleThirdStep),
    findall(H, (member(H, PossibleThirdStep), not(member(H, PossibleFirstStep))), ThirdStep),
    get_all_hexs(Hexs),
    keep_all_together(Hexs, ThirdStep, OldPossibleHexs),
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


get_moves(OriginHex, PossibleDestinies) :- 
    get_hex_bug(OriginHex, Bug),
    (Bug =:= 1 -> move_a_queen(OriginHex, PossibleDestinies);
    Bug =:= 2 -> move_an_ant(OriginHex, PossibleDestinies);
    Bug =:= 3 -> move_a_grasshopper(OriginHex, PossibleDestinies);
    Bug =:= 4 -> move_a_scarab(OriginHex, PossibleDestinies);   
    Bug =:= 5 -> move_a_spider(OriginHex, PossibleDestinies)
    %  Bug =:= 6 -> move_a_mosquito(OriginHex, PossibleDestinies);
    %  Bug =:= 7 -> move_a_ladybug(OriginHex, PossibleDestinies);
    %  Bug =:= 8 -> move_a_pillbug(OriginHex, PossibleDestinies)
    ).