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


createLine([], 0).
createLine([H|T], I):-
	I > 0,
	append([], [], H),
	I1 is I-1,
	createLine(T, I1), !.

fillList(I, Row, Y):-
	fillList([], I, Row, Y).

fillList(X, 0, _, X):-!.
fillList(X, I, Row, Y):-
	append(X, [Row], NewX),
	I1 is I-1,
	fillList(NewX, I1, Row, Y).



cutLeftSide(List, X, List2):-
	length(List, L),
	L2 is L-X,
	length(List2, L2),
	length(List3, X),

	append(List3, List2, List).