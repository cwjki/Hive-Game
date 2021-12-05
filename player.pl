
:- dynamic player/9

new_player(player(Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)) :- 
    assertz(player(Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).

remove_player(player(Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)) :- 
    retract(player(Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).


get_current_queenBee(player(_, QueenBee, _, _, _, _, _, _, _), QueenBee).
get_current_ants(player(_, _, Ants, _, _, _, _, _, _), Ants).
get_current_grasshoppers(player(_, _, _, Grasshoppers, _, _, _, _, _), Grasshoppers).
get_current_scarabs(player(_, _, _, _, Scarabs, _, _, _, _), Scarabs).
get_current_spiders(player(_, _, _, _, _, Spiders, _, _, _), Spiders).
get_current_mosquitos(player(_, _, _, _, _, _, Mosquitos, _, _), Mosquitos).
get_current_ladybugs(player(_, _, _, _, _, _, _, Ladybugs, _), Ladybugs).
get_current_pillbugs(player(_, _, _, _, _, _, _, _, Pillbugs), Pillbugs).

update_player_queenBee(player(Color, _, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), ActualQueenBee,
                        player(Color, ActualQueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).

update_player_ants(player(Color, QueenBee, _, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), ActualAnts,
                        player(Color, QueenBee, ActualAnts, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).

update_player_grasshoppers(player(Color, QueenBee, Ants, _, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs), ActualGrasshoppers,
                        player(Color, QueenBee, Ants, ActualGrasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).
                
update_player_scarabs(player(Color, QueenBee, Ants, Grasshoppers, _, Spiders, Mosquitos, Ladybugs, Pillbugs), ActualScarabs,
                        player(Color, QueenBee, Ants, Grasshoppers, ActualScarabs, Spiders, Mosquitos, Ladybugs, Pillbugs)).

update_player_spiders(player(Color, QueenBee, Ants, Grasshoppers, Scarabs, _, Mosquitos, Ladybugs, Pillbugs), ActualSpiders,
                        player(Color, QueenBee, Ants, Grasshoppers, Scarabs, ActualSpiders, Mosquitos, Ladybugs, Pillbugs)).

update_player_mosquitos(player(Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, _, Ladybugs, Pillbugs), ActualMosquitos,
                    player(Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, ActualMosquitos, Ladybugs, Pillbugs)).

update_player_ladybugs(player(Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, _, Pillbugs), ActualLadybugs,
                    player(Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, ActualLadybugs, Pillbugs)).

update_player_pillbugs(player(Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, _), ActualPillbugs,
                    player(Color, QueenBee, Ants, Grasshoppers, Scarabs, Spiders, Mosquitos, Ladybugs, ActualPillbugs)).


update_player_hand(Bug, Player, NewPlayer) :- ( Bug =:= 0 -> (get_current_queenBee(Player, QueenBee), 
                                                            ActualQueenBee is QueenBee - 1,
                                                            update_player_queenBee(Player, ActualQueenBee, NewPlayer),
                                                            remove_player(Player),
                                                            assertz(NewPlayer));
                                                Bug =:= 1 -> (get_current_ants(Player, Ants), 
                                                            ActualAnts is Ants - 1,
                                                            update_player_ants(Player, ActualAnts, NewPlayer),
                                                            remove_player(Player),
                                                            assertz(NewPlayer));
                                                Bug =:= 2 -> (get_current_grasshoppers(Player, Grasshoppers), 
                                                            ActualGrasshoppers is Grasshoppers - 1,
                                                            update_player_grasshoppers(Player, ActualGrasshoppers, NewPlayer),
                                                            remove_player(Player),
                                                            assertz(NewPlayer));
                                                Bug =:= 3 -> (get_current_scarabs(Player, Scarabs), 
                                                            ActualScarabs is Scarabs - 1,
                                                            update_player_scarabs(Player, ActualScarabs, NewPlayer),
                                                            remove_player(Player),
                                                            assertz(NewPlayer));
                                                Bug =:= 4 -> (get_current_spiders(Player, Spiders), 
                                                            ActualSpiders is Spiders - 1,
                                                            update_player_spiders(Player, ActualSpiders, NewPlayer),
                                                            remove_player(Player),
                                                            assertz(NewPlayer));
                                                Bug =:= 5 -> (get_current_mosquitos(Player, Mosquitos), 
                                                            ActualMosquitos is Mosquitos - 1,
                                                            update_player_mosquitos(Player, ActualMosquitos, NewPlayer),
                                                            remove_player(Player),
                                                            assertz(NewPlayer));
                                                Bug =:= 6 -> (get_current_ladybugs(Player, Ladybugs), 
                                                            ActualLadybugs is Ladybugs - 1,
                                                            update_player_ladybugs(Player, ActualLadybugs, NewPlayer),
                                                            remove_player(Player),
                                                            assertz(NewPlayer));
                                                Bug =:= 7 -> (get_current_pillbugs(Player, Pillbugs), 
                                                            ActualPillbugs is Pillbugs - 1,
                                                            update_player_pillbugs(Player, ActualPillbugs, NewPlayer),
                                                            remove_player(Player),
                                                            assertz(NewPlayer));
                                                ).



