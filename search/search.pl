
:- dynamic visited/2.


clear_visited :- retractall(visited(_, _)).


search(Actions) :-
    clear_visited,
    initial(Start),
    bfs([(Start, [], [])], [], Actions).


bfs([(Position, Keys, Path)|_], _, Actions) :-
    treasure(Position), !, % Found the treasure
    reverse(Path, Actions).
bfs([State|Queue], _, Actions) :-
    State = (Position, Keys, Path),
    findall(
        NextState,
        (   next_position(Position, Next, Keys, NewKeys),
            valid_state(Next, NewKeys),
            NextState = (Next, NewKeys, [move(Position, Next)|Path])
        ),
        NewStates
    ),
    append(Queue, NewStates, UpdatedQueue),
    bfs(UpdatedQueue, _, Actions).


valid_state(Position, Keys) :-
    \+ visited(Position, Keys), % Not visited with the same set of keys
    assertz(visited(Position, Keys)).


next_position(Pos, Next, Keys, NewKeys) :-
    (door(Pos, Next); door(Next, Pos)), % Unlocked door
    NewKeys = Keys.
next_position(Pos, Next, Keys, Keys) :- % Door locked, but we have the key
    (locked_door(Pos, Next, Color); locked_door(Next, Pos, Color)),
    member(Color, Keys).
next_position(Pos, Next, Keys, [Color|Keys]) :- % Picking up a new key
    door(Pos, Next),
    key(Next, Color),
    \+ member(Color, Keys).




