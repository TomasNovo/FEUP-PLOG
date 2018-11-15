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


draw_piece_aux([H|T]):-
	nth0(1, [H|T], Colour),
	printPieceColour(H, Colour).
draw_piece_aux([H|[]]):- write(H).

draw_piece([]):- write(' _ ').
draw_piece([H|T]):-
	draw_piece_aux([H|T]).


addLineLeft([], []).
addLineLeft([H|T], [H2|Tail]):-
	addHead(H, [], H2),
	addLineLeft(T, Tail).

addLineRight([], []).
addLineRight([H|T], [H2|Tail]):-
	addTail(H, [], H2),
	addLineRight(T, Tail).

addLineTop([H|T], Y) :-
	length(H, Hl),
	createLine(W, Hl),
	addHead([H|T], W, Y).

addLineBottom([H|T], Y) :-
	length(H, Hl),
	createLine(W, Hl),
	addTail([H|T], W, Y).


%Prints piece and colour
printPieceColourAux(N, Colour):- 
	N < 10,
	write(N),
	write(' '),
	write(Colour).

 printPieceColourAux(N, Colour):- 
	N >= 10,
	write(N),
	write(Colour).

 printPieceColour(N, Colour):-
 		 printPieceColourAux(N,Colour).

print_line_aux([]):-
	nl.
print_line_aux([H|T]):-
	write('|').

print_line([]).
print_line([H|T]):-
	draw_piece(H),
	print_line_aux(T),
	print_line(T).

printBoard([]).
printBoard([H|T]) :-
	print_line(H),
	printBoard(T).


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


increaseBoard(Board, X, Y, NewBoard):-
	X1 is X+1, Y1 is Y-2, %% Up-right
	increaseBoardAux(Board, X1, Y1, Foobar),
	X2 is X+2, Y2 is Y-1, %% Right-up
	checkPieceMove(Board, X2, Y2, Colour, Foobar2, Foobar3),
	X3 is X+2, Y3 is Y+1, %% Right-down
	checkPieceMove(Board, X3, Y3, Colour, Foobar3, Foobar4),
	X4 is X+1, Y4 is Y+2, %% Down-right
	checkPieceMove(Board, X4, Y4, Colour, Foobar4, Foobar5),
	X5 is X-1, Y5 is Y+2, %% Down-left
	checkPieceMove(Board, X5, Y5, Colour, Foobar5, Foobar6),
	X6 is X-2, Y6 is Y+1, %% Left-down
	checkPieceMove(Board, X6, Y6, Colour, Foobar6, Foobar7),
	X7 is X-2, Y7 is Y-1, %% Left-up
	checkPieceMove(Board, X7, Y7, Colour, Foobar7, Foobar8),
	X8 is X-1, Y8 is Y-2, %% Up-left
	checkPieceMove(Board, X8, Y8, Colour, Foobar8, Output).


increaseBoardAux(Board, X, Y, NewBoard):-
	getBoardSize(Board, Height, Width),

	X1 is 0-X, Y1 is 0-Y, X2 is Width-X, Y2 is Height-Y,

	

increaseBoardAux2(NewBoard, 0, NewBoard).
increaseBoardAux2(Board, X, NewBoard):-
	X1 > 0,
	addLineLeft(Board, Foobar).
