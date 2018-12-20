:- consult('logic.pl'), consult('utilities.pl').

%%%%%%%%%%%
% Console %
%%%%%%%%%%%



draw_piece([]):- write(' _').
draw_piece(H):- write(' '),write(H).



print_line_aux([], Hints, I):-
	write(' | '),
	I1 is I+9,
	nth0(I1, Hints, Hint),
	reverse(Hint, Hint2),
	displayRightHints(Hint2),
	displayBar.
print_line_aux([_|_], _, _):-
	write(' |').


print_line([], _, _).
print_line([H|T], Hints, I):-
	draw_piece(H),
	print_line_aux(T, Hints, I),
	print_line(T, Hints, I).



printBoard([], _, _).
printBoard([H|T], Hints, I) :-
	I2 is 35-I,
	nth0(I2, Hints, Hint3),
	fillHint(Hint3, Hint4),
	displayRightHints(Hint4),
	write('|'),
	print_line(H, Hints, I),
	I1 is I+1,
	printBoard(T, Hints, I1).

printBoard(Hints, Board):-
	I is 0,
	nl,nl,nl,
	displayTopHints(Hints),
	displayBar,
	printBoard(Board, Hints, I),
	displayBottomHints(Hints).



printColumnNumber(N):- 
	N < 10,
	write('| |').

 printColumnNumber(N):- 
	N >= 10,
	write(N),
	write('|').



% Helper to clear console 
clear_console :- 
	clear_console(40), !.

clear_console(0).

clear_console(N) :-
	nl, N1 is N - 1, clear_console(N1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


displayBar:-
	nl,write('       -----------------------------------'),nl.

displayTopHints(Hints):-
	fillHints(Hints, Hints2),
	displayTopHints(Hints2, 0),
	!.

displayTopHints(_, 3):-!.
displayTopHints(Hints, 2):-
	write('        '),
	displayTopHints(Hints, 2, 0).



displayTopHints(Hints, I):-
	write('        '),
	displayTopHints(Hints, I, 0),
	nl,

	I1 is I+1,
	displayTopHints(Hints, I1).

displayTopHints(_, _, 9):-!.
displayTopHints(Hints, I, I2):-
	nth0(I2, Hints, Hint),
	nth0(I, Hint, Element),

	write(Element), write('   '),

	I3 is I2+1,
	displayTopHints(Hints, I, I3).


displayBottomHints(Hints):-
	fillHints(Hints, Hints2),
	displayBottomHints(Hints2, 0),
	!.

displayBottomHints(_, 3):-!.
displayBottomHints(Hints, I):-
	write('        '),
	displayBottomHints(Hints, I, 0),
	nl,

	I1 is I+1,
	displayBottomHints(Hints, I1).

displayBottomHints(_, _, 9):-!.
displayBottomHints(Hints, I, I2):-
	I4 is 26-I2,
	nth0(I4, Hints, Hint),
	I5 is 2-I,
	nth0(I5, Hint, Element),

	write(Element), write('   '),

	I3 is I2+1,
	displayBottomHints(Hints, I, I3).

fillHints([], []):-!.
fillHints([H|T], [H2|T2]):-
	fillHint(H, H2),

	fillHints(T, T2).


fillHint([A,B,C], [A,B,C]):-!.
fillHint(List, Return):-
	append([' '], List, List2),
	fillHint(List2, Return).


displayleHints([]).
displayLeftHints([H|T]):-
	write(H),write(' '),
	displayRightHints(T).

displayRightHints([]).
displayRightHints([H|T]):-
	write(H),write(' '),
	displayRightHints(T).