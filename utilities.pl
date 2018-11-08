replace([_|T], 0, New, [New|T]).
replace([H|T], Index, New, [H|R]) :-
	I1 is Index - 1,
	replace(T, I1, New, R), !.

replaceByCoords([H|T], X, Y, New, [H2|R]) :-
    nth0(Y, [H|T], Line),
    replace(Line, X, New, L),
    replace([H|T], Y, L, [H2|R]), !.

addHead([H|T],A,Zs) :-
	append([A],[H|T],Zs).
addTail([H|T],A,Zs) :-
	append([H|T],[A],Zs).