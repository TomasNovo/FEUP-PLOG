:- consult('utilities.pl'), use_module(library(lists)).

clear_console :- 
	clear_console(40), !.

clear_console(0).

clear_console(N) :-
	nl, N1 is N - 1, clear_console(N1).


alphabet([' A ', ' B ', ' C ', ' D ', ' E ', ' F ', ' G ', ' H ']).


createLine([], 0).
createLine([H|T], I):-
	I > 0,
	append([], [], H),
	I1 is I-1,
	createLine(T, I1), !.


draw_piece([]):-
	write(' _ ').

draw_piece([H|T]):-
	T = [] ->
		write(H);
	T \= [] ->
		nth0(1, [H|T], Colour),
		printPieceColour(H, Colour).


printPieceColour(N, Colour):-
		N @< 10 -> 
			write(N),
			write(' '),
			write(Colour);
		N @>= 10 -> 
			write(N),
			write(Colour).

print_line([]).
print_line([H|T]):-
	draw_piece(H),
	T \= [] -> write('|'), print_line(T);
	T = [] -> print_line(T).

printBoard([ ]).
printBoard([H|T]) :-
	print_line(H),
	nl,printBoard(T).


printInitial :-
	initialBoard(Tabuleiro),
	printBoard(Tabuleiro).


showMoves(Board, Moves, Output):-
	alphabet(Alphabet),
	showMoves(Board, Moves, Alphabet, Output).

showMoves(Board, [], _, Output):-
	append(Board, [], Output), !.

showMoves(Board, [H|T], [H2|T2], Output):-
	nth0(0, H, X),
	nth0(1, H, Y),
	replaceByCoords(Board, X, Y, [H2], Foobar),
	showMoves(Foobar, T, T2, Output).