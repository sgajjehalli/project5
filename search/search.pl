% Helper predicates

% Check if a door is passable
passable(CurrentRoom, NextRoom, _) :-
    door(CurrentRoom, NextRoom);
    door(NextRoom, CurrentRoom).

passable(CurrentRoom, NextRoom, Keys) :-
    (locked_door(CurrentRoom, NextRoom, LockColor);
     locked_door(NextRoom, CurrentRoom, LockColor)),
    member(LockColor, Keys). % Check if the key for the lock is available.

% Add key to the key list if present in the room
pickup_keys(CurrentRoom, Keys, UpdatedKeys) :-
    (key(CurrentRoom, KeyColor), \+ member(KeyColor, Keys) ->
        UpdatedKeys = [KeyColor | Keys]; % Add the key if not already picked.
        UpdatedKeys = Keys).

bfs([[Path, CurrentRoom, _] | _], Path) :-
    treasure(CurrentRoom). % Found the treasure.

bfs([[Path, CurrentRoom, Keys] | RestQueue], Solution) :-
    findall(
        [NewPath, NextRoom, UpdatedKeys],
        (
            passable(CurrentRoom, NextRoom, Keys),       % Check if the door is passable.
            \+ member(move(CurrentRoom, NextRoom), Path), % Avoid revisiting the same move.
            pickup_keys(NextRoom, Keys, UpdatedKeys),     % Pick up keys in the next room if available.
            append(Path, [move(CurrentRoom, NextRoom)], NewPath) % Add the move to the path.
        ),
        NewPaths
    ),
    append(RestQueue, NewPaths, NewQueue), % Add new paths to the queue for exploration.
    bfs(NewQueue, Solution). % Continue searching.

% Entry point for the search
search(Actions) :-
    initial(StartRoom), % Start from the initial room.
    bfs([[[ ], StartRoom, []]], Actions). % Initialize BFS with an empty path and no keys.