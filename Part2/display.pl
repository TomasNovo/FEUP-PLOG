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


getPiece([H|T], X, Y, Piece) :-
	nth0(Y, [H|T], Line),
	nth0(X, Line, Piece).


