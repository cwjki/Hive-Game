:- module(movements, [get_moves/2]).

:- use_module(hexagon).



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


move_a_queen(OriginHex, PossibleHexs) :- 
    get_empty_neighbours(OriginHex, Neighbours),
    remove_hex(OriginHex),
    get_all_hexs(Hexs),
    keep_all_together(Hexs, Neighbours, PossibleHexs),
    new_hex(OriginHex).
    

move_a_scarab(OriginHex, PossibleHexs) :- 
    get_empty_neighbours(OriginHex, EmptyNeighbours),
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


                                        
% %devuelve de la entrada, los que tienen vecinos ocupados (NO DEVUELVE LOS VECINOS OCUPADOS)
% multiple_get_neighbours([], []).
% multiple_get_neighbours([X|EmptyNeighbours], Neighbours) :-
%     get_neighbours(X, SingleNeighbours),
%     multiple_get_neighbours(EmptyNeighbours, OldNeighbours),
%     ((SingleNeighbours =\= [], Y = [X]); Y = []),
%     append(Y, OldNeighbours, Neighbours).
    
% %devuelve los vecinos vacios de la entrada
% multiple_get_empty_neighbours([], []).
% multiple_get_empty_neighbours([X|PossibleStep], EmptyNeighbours) :-
%     get_empty_neighbours(X, SingleEmptyNeighbours),
%     multiple_get_empty_neighbours(PossibleStep, OldEmptyNeighbours),
%     append(SingleEmptyNeighbours, OldEmptyNeighbours, EmptyNeighbours).
    


% %de los vecinos vacios, solo podre tomar como posibles los que tengan algun vecino ocupado
% %repetir 3 veces
% %revisar si quitar la arana desconecta la colmena, si es asi solo seran validos los destinos
% %que la vuelvan a conectar
% %sino, todos los vecinos obtenidos
% move_a_spider(OriginHex, PossibleHexs) :- 
%     get_empty_neighbours(OriginHex, EmptyNeighbours),
%     multiple_get_neighbours(EmptyNeighbours, PossibleFirstStep),
%     multiple_get_empty_neighbours(PossibleFirstStep, PossibleEmptyFirstNeighbours),
%     multiple_get_neighbours(PossibleEmptyFirstNeighbours, PossibleSecondStep),
%     multiple_get_empty_neighbours(PossibleSecondStep, PossibleEmptySecondNeighbours),
%     multiple_get_neighbours(PossibleEmptySecondNeighbours, PossibleThirdStep),
%     remove_hex(OriginHex),
%     get_all_hexs(Hexs),
%     ((dfs(Hexs), PossibleHexs = PossibleThirdStep);
%     keep_all_together(Hexs, PossibleThirdStep, PossibleHexs)),
%     new_hex(OriginHex).


% move_an_ant(OriginHex, PossibleHexs) :-

%     remove_hex(OriginHex),
%     get_all_hexs(Hexs),
%     ((dfs(Hexs), PossibleHexs = PossibleThirdStep);
%     keep_all_together(Hexs, PossibleThirdStep, PossibleHexs)),
%     new_hex(OriginHex).


get_moves(OriginHex, PossibleDestinies) :- 
    get_hex_bug(OriginHex, Bug),
    (Bug =:= 1 -> move_a_queen(OriginHex, PossibleDestinies);
    %  Bug =:= 2 -> move_an_ant(OriginHex, PossibleDestinies);
    Bug =:= 3 -> move_a_grasshopper(OriginHex, PossibleDestinies);
    Bug =:= 4 -> move_a_scarab(OriginHex, PossibleDestinies)   
    %  Bug =:= 5 -> move_a_spider(OriginHex, PossibleDestinies);
    %  Bug =:= 6 -> move_a_mosquito(OriginHex, PossibleDestinies);
    %  Bug =:= 7 -> move_a_ladybug(OriginHex, PossibleDestinies);
    %  Bug =:= 8 -> move_a_pillbug(OriginHex, PossibleDestinies)
    ).