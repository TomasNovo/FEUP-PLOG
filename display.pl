:- consult('utilities.pl'), use_module(library(lists)).

%Clears console
clear_console :- 
	clear_console(40), !.

clear_console(0).

clear_console(N) :-
	nl, N1 is N - 1, clear_console(N1).

%Alphabet list
alphabet([' A ', ' B ', ' C ', ' D ', ' E ', ' F ', ' G ', ' H ']).

%Creates line
createLine([], 0).
createLine([H|T], I):-
	I > 0,
	append([], [], H),
	I1 is I-1,
	createLine(T, I1), !.

%Draws piece
draw_piece_aux([H|T]):-
	nth0(1, [H|T], Colour),
	printPieceColour(H, Colour).
draw_piece_aux([H|[]]): write(H).

draw_piece([]):- write(' _ ').
draw_piece([H|T]):-
	draw_piece_aux([H|T]).
		
%Prints piece and colour
%% printPieceColourAux(N):- write(N),
%% 			write(' '),
%% 			write(Colour),
%% 			N @> 10, printPieceColourAux2(N).

%% printPieceColourAux2(N):- 
%% 			write(N),
%% 			write(Colour).


%% printPieceColour(N, Colour):-
%% 		N @=< 10, printPieceColourAux(N).			

printPieceColour(N, Colour):-
		N @< 10 -> 
			write(N),
			write(' '),
			write(Colour);
		N @>= 10 -> 
			write(N),
			write(Colour).

%Prints line
print_line([]).
print_line([H|T]):-
	draw_piece(H),
	T \= [] -> write('|'), print_line(T);
	T = [] -> print_line(T).

%Prints board
printBoard([ ]).
printBoard([H|T]) :-
	print_line(H),
	nl,printBoard(T).

%Prints initial board
printInitial :-
	initialBoard(Tabuleiro),
	printBoard(Tabuleiro).


% Shows possible piece moves
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