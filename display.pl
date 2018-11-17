:- consult('utilities.pl'), use_module(library(lists)).

clear_console :- 
	clear_console(40), !.

clear_console(0).

clear_console(N) :-
	nl, N1 is N - 1, clear_console(N1).

displayBar(Board):-
	getBoardSize(Board, W, H),
	I is 1,
	write('   ___'),
	displayBar(Board, W, I).

displayBar([H|T], Width, N) :-
	write('|___'),
	(N1 is N + 1,
	N1 @< Width,
	displayBar([H|T], Width, N1);
	true).

displayX(Board):-
	getBoardSize(Board, W, H),
	I is 1,
	write('    0 '),
	displayX(Board, W, I).

displayX([H|T], Width, N) :-
	write('| '), write(N), write(' '),
	(N1 is N + 1, 
	N1 @< Width,
	displayX([H|T], Width, N1);
	true).

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


printColumnNumber(N):- 
	N < 10,
	write(N),
	write(' |').

 printColumnNumber(N):- 
	N >= 10,
	write(N),
	write('|').

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
	write('|'),nl.
print_line_aux([H|T]):-
	write('|').

print_line([]).
print_line([H|T]):-
	T \= [],
	draw_piece(H),
	print_line_aux(T),
	print_line(T).

print_line([H|T]):-
	T = [],
	draw_piece(H),
	print_line_aux(T),
	print_line(T).

printBoard([], _).
printBoard([H|T], I) :-
	printColumnNumber(I),
	print_line(H),

	I1 is I+1,
	printBoard(T, I1).

printBoard(Board):-
	I is 0,
	nl,displayX(Board),nl,
	displayBar(Board),nl,
	printBoard(Board, I).


printInitial :-
	initialBoard(Tabuleiro),
	printBoard(Tabuleiro).


showMoves(Board, Moves, Output):-
	alphabet(Alphabet),
	showMoves(Board, Moves, Alphabet, Output).

showMoves(Board, [], _, Board).
showMoves(Board, [H|T], [H2|T2], Output):-
	nth0(0, H, X),
	nth0(1, H, Y),
	replaceByCoords(Board, X, Y, [H2], Foobar),
	showMoves(Foobar, T, T2, Output).

increaseBoard(Board, NewBoard):-
	getBoardSize(Board, W, H),
	increaseBoardY(Board, 0, W, H, NewBoard).

increaseBoardY(Board, H, _, H, Board).
increaseBoardY(Board, Y, W, H, NewBoard):-
	increaseBoardX(Board, 0, Y, W, H, Board2),

	Y1 is Y+1,
	increaseBoardY(Board2, Y1, W, H, NewBoard).

increaseBoardX(Board, W, _, W, _, Board).
increaseBoardX(Board, X, Y, W, H, NewBoard):-
	increaseBoard2(Board, X, Y, Board2),

	X1 is X+1,
	increaseBoardX(Board2, X1, Y, W, H, NewBoard).

increaseBoard2(Board, X, Y, NewBoard):-
	
	getPiece(Board, X, Y, Piece),
	getColour(Piece, Colour),

	X1 is X+1, Y1 is Y-2, %% Up-right
	X2 is X+2, Y2 is Y-1, %% Right-up
	X3 is X+2, Y3 is Y+1, %% Right-down
	X4 is X+1, Y4 is Y+2, %% Down-right
	X5 is X-1, Y5 is Y+2, %% Down-left
	X6 is X-2, Y6 is Y+1, %% Left-down
	X7 is X-2, Y7 is Y-1, %% Left-up
	X8 is X-1, Y8 is Y-2, %% Up-left
	
	increaseBoardAux(Board, X1, Y1, Colour, List1),
	increaseBoardAux(List1, X2, Y2, Colour, List2),
	increaseBoardAux(List2, X3, Y3, Colour, List3),
	increaseBoardAux(List3, X4, Y4, Colour, List4),
	increaseBoardAux(List4, X5, Y5, Colour, List5),
	increaseBoardAux(List5, X6, Y6, Colour, List6),
	increaseBoardAux(List6, X7, Y7, Colour, List7),
	increaseBoardAux(List7, X8, Y8, Colour, NewBoard).


increaseBoardAux(Board, X, Y, Colour, NewBoard):-
	checkAdjacent2(Board, X, Y, Colour),

	getBoardSize(Board, Width, Height),

	X1 is 0-X, X2 is X-Width+1, Y1 is 0-Y, Y2 is Y-Height+1,

	increaseBoardAux2(Board, X1, 0, List1),
	increaseBoardAux2(List1, X2, 1, List2),
	increaseBoardAux2(List2, Y1, 2, List3),
	increaseBoardAux2(List3, Y2, 3, NewBoard).

increaseBoardAux(Board, X, Y, Colour, NewBoard):-
	NewBoard = Board.


checkAdjacent2(Board, X, Y, Colour):-
	
	(getPiece(Board, X, Y, Piece),
	length(Piece, 0));
	(

	X1 is X, Y1 is Y-1, %% Up
	X2 is X+1, Y2 is Y-1, %% Up-right
	X3 is X+1, Y3 is Y, %% Right
	X4 is X+1, Y4 is Y+1, %% Down-right
	X5 is X, Y5 is Y+1, %% Down
	X6 is X-1, Y6 is Y+1, %% Down-left
	X7 is X-1, Y7 is Y, %% Left
	X8 is X-1, Y8 is Y-1, %% Up-left

	(checkPieceColour(Board, X1, Y1, Colour);
	checkPieceColour(Board, X2, Y2, Colour);
	checkPieceColour(Board, X3, Y3, Colour);
	checkPieceColour(Board, X4, Y4, Colour);
	checkPieceColour(Board, X5, Y5, Colour);
	checkPieceColour(Board, X6, Y6, Colour);
	checkPieceColour(Board, X7, Y7, Colour);
	checkPieceColour(Board, X8, Y8, Colour))).	


increaseBoardAux2(Board, X, _, NewBoard):-
	X =< 0,
	NewBoard = Board.

increaseBoardAux2(Board, X, 0, NewBoard):-
	X > 0,
	addLineLeft(Board, Foobar),

	X1 is X-1,
	increaseBoardAux2(Foobar, X1, 0, NewBoard).


increaseBoardAux2(Board, X, 1, NewBoard):-
	X > 0,
	addLineRight(Board, Foobar),

	X1 is X-1,
	increaseBoardAux2(Foobar, X1, 1, NewBoard).

increaseBoardAux2(Board, X, 2, NewBoard):-
	X > 0,
	addLineTop(Board, Foobar),

	X1 is X-1,
	increaseBoardAux2(Foobar, X1, 2, NewBoard).

increaseBoardAux2(Board, X, 3, NewBoard):-
	X > 0,
	addLineBottom(Board, Foobar),

	X1 is X-1,
	increaseBoardAux2(Foobar, X1, 3, NewBoard).	