:- module(player, [new_player/1, get_player/2, update_player_hand/3]).

:- dynamic player/10.

new_player(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)) :- 
    assertz(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).

remove_player(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)) :- 
    retract(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).

get_player(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)) :-
           player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs).

get_current_queenBee(player(_, _, QueenBee, _, _, _, _, _, _, _), QueenBee).
get_current_ants(player(_, _, _, Ants, _, _, _, _, _, _), Ants).
get_current_grasshoppers(player(_, _, _, _, Grasshoppers, _, _, _, _, _), Grasshoppers).
get_current_scarabs(player(_, _, _, _, _, Scarabs, _, _, _, _), Scarabs).
get_current_spiders(player(_, _, _, _, _, _, Spiders, _, _, _), Spiders).
get_current_mosquitos(player(_, _, _, _, _, _, _, Mosquitos, _, _), Mosquitos).
get_current_ladybugs(player(_, _, _, _, _, _, _, _, Ladybugs, _), Ladybugs).
get_current_pillbugs(player(_, _, _, _, _, _, _, _, _, Pillbugs), Pillbugs).

update_player_queenBee(player(Name, Color, _, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), ActualQueenBee,
                        player(Name, Color, ActualQueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).

update_player_ants(player(Name, Color, QueenBee, _, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), ActualAnts,
                        player(Name, Color, QueenBee, ActualAnts, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).

update_player_grasshoppers(player(Name, Color, QueenBee, Ants, _, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), ActualGrasshoppers,
                        player(Name, Color, QueenBee, Ants, ActualGrasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).
                
update_player_scarabs(player(Name, Color, QueenBee, Ants, Grasshoppers, _, Spiders, Mosquitos, Ladybugs, Pillbugs), ActualScarabs,
                        player(Name, Color, QueenBee, Ants, Grasshoppers, ActualScarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).

update_player_spiders(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, _, Mosquitos, Ladybugs, Pillbugs), ActualSpiders,
                        player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, ActualSpiders, Mosquitos, Ladybugs, Pillbugs)).

update_player_mosquitos(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, _, Ladybugs, Pillbugs), ActualMosquitos,
                    player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, ActualMosquitos, Ladybugs, Pillbugs)).

update_player_ladybugs(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, _, Pillbugs), ActualLadybugs,
                    player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, ActualLadybugs, Pillbugs)).

update_player_pillbugs(player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, _), ActualPillbugs,
                    player(Name, Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, ActualPillbugs)).


update_player_hand(Bug, Player, NewPlayer) :- 
    (Bug =:= 1 -> (get_current_queenBee(Player, QueenBee), 
        ActualQueenBee is QueenBee - 1,
        update_player_queenBee(Player, ActualQueenBee, NewPlayer),
        remove_player(Player),
        new_player(NewPlayer));
    Bug =:= 2 -> (get_current_ants(Player, Ants), 
        ActualAnts is Ants - 1,
        update_player_ants(Player, ActualAnts, NewPlayer),
        remove_player(Player),
        new_player(NewPlayer));
    Bug =:= 3 -> (get_current_grasshoppers(Player, Grasshoppers), 
        ActualGrasshoppers is Grasshoppers - 1,
        update_player_grasshoppers(Player, ActualGrasshoppers, NewPlayer),
        remove_player(Player),
        new_player(NewPlayer));
    Bug =:= 4 -> (get_current_scarabs(Player, Scarabs), 
        ActualScarabs is Scarabs - 1,
        update_player_scarabs(Player, ActualScarabs, NewPlayer),
        remove_player(Player),
        new_player(NewPlayer));
    Bug =:= 5 -> (get_current_spiders(Player, Spiders), 
        ActualSpiders is Spiders - 1,
        update_player_spiders(Player, ActualSpiders, NewPlayer),
        remove_player(Player),
        new_player(NewPlayer));
    Bug =:= 6 -> (get_current_mosquitos(Player, Mosquitos), 
        ActualMosquitos is Mosquitos - 1,
        update_player_mosquitos(Player, ActualMosquitos, NewPlayer),
        remove_player(Player),
        new_player(NewPlayer));
    Bug =:= 7 -> (get_current_ladybugs(Player, Ladybugs), 
        ActualLadybugs is Ladybugs - 1,
        update_player_ladybugs(Player, ActualLadybugs, NewPlayer),
        remove_player(Player),
        new_player(NewPlayer));
    Bug =:= 8 -> (get_current_pillbugs(Player, Pillbugs), 
        ActualPillbugs is Pillbugs - 1,
        update_player_pillbugs(Player, ActualPillbugs, NewPlayer),
        remove_player(Player),
        new_player(NewPlayer))
    ).


