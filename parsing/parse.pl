
digit('0'). digit('1'). digit('2'). digit('3'). digit('4').
digit('5'). digit('6'). digit('7'). digit('8'). digit('9').


num([D]) :- digit(D).
num([D|T]) :- digit(D), num(T).


line(L) :- num(L).
line([H|T]) :- append(N, [','|RestLine], [H|T]), num(N), line(RestLine).


lines(L) :- line(L).
lines(L) :- append(Line, [';'|RestLines], L), line(Line), lines(RestLines).


parse(X) :- lines(X).
