%Replace element in list
replace([_|T], 0, New, [New|T]).
replace([H|T], Index, New, [H|R]) :-
	I1 is Index - 1,
	replace(T, I1, New, R), !.

%Replace element in list by its coords
replaceByCoords([H|T], X, Y, New, [H2|R]) :-
    nth0(Y, [H|T], Line),
    replace(Line, X, New, L),
    replace([H|T], Y, L, [H2|R]), !.

%Appends on head of list
addHead([H|T],A,Zs) :-
	append([A],[H|T],Zs).

%Appends on tail of list
addTail([H|T],A,Zs) :-
	append([H|T],[A],Zs).