:- consult('logic.pl'), consult('utilities.pl').

%%%%%%%%%%%
% Console %
%%%%%%%%%%%



draw_piece([]):- write(' _').
draw_piece(H):- write(' '),write(H).



print_line_aux([]):-
	write(' |'),
	displayBar,
	write('|').
print_line_aux([_|_]):-
	write(' |').


print_line([], _).
print_line([H|T], I):-
	draw_piece(H),
	print_line_aux(T),
	print_line(T, I).



printBoard([], _).
printBoard([H|T], I) :-
	%% printColumnNumber(I),
	print_line(H, I),
	I1 is I+1,
	printBoard(T, I1).

printBoard(Board):-
	I is 0,
	nl,nl,nl,
	initialHints(Hints),
	displayHints(Hints),
	displayBar, write('|'),
	printBoard(Board, I), !.



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
	nl,write(' -----------------------------------'),nl.

displayHints(Hints):-
	fillHints(Hints, Hints2),
	displayHints(Hints2, 0).

displayHints(_, 3):-!.
displayHints(Hints, I):-
	write('  '),
	displayHints(Hints, I, 0),
	nl,

	I1 is I+1,
	displayHints(Hints, I1).

displayHints(_, _, 9):-!.
displayHints(Hints, I, I2):-
	nth0(I2, Hints, Hint),
	nth0(I, Hint, Element),

	write(Element), write('   '),

	I3 is I2+1,
	displayHints(Hints, I, I3).

fillHints([], []).
fillHints([H|T], [H2|T2]):-
	fillHints2(H, H2, 0),
	fillHints(T, T2).


fillHints2([], [], 3):-!.
fillHints2([], [' '|T2], I):-
	I1 is I+1,
	fillHints2([], T2, I1).

fillHints2([H|T], [H|T2], I):-
	I1 is I+1,
	fillHints2(T, T2, I1).