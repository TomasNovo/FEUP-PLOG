%Replace element in list
replace([_|T], 0, New, [New|T]).
replace([H|T], Index, New, [H|R]) :-
	I1 is Index - 1,
	replace(T, I1, New, R), !.

%Replace element in list by its coords
replaceByCoords(List1, X, Y, New, List2) :-
    nth0(Y, List1, Line),
    replace(Line, X, New, L),
    replace(List1, Y, L, List2), !.

%Appends on head of list
addHead([H|T],A,Zs) :-
	append([A],[H|T],Zs).

%Appends on tail of list
addTail([H|T],A,Zs) :-
	append([H|T],[A],Zs).

% Sets C to the max of [A,B]
maximum(A, B, C):-
	A > B,
	C = A.

maximum(A, B, C):-
	A =< B,
	C = B.

printList([]).
printList([H|T]):-
	write(H),nl,
	printList(T).