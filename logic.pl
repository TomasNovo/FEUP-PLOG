:- consult('utilities.pl'), use_module(library(lists)).

initialBoard([[[], [], [], []],
			[[], [20,'w'], [20,'b'], []],
			[[], [], [], []]]).

testBoard([[[], [], [], [5, 'w']],
			[[], [15,'w'], [20,'b'], []],
			[[], [], [], []]]).

testingBoard(X):-
	initialBoard(Z),
	addVerticalLines(Z, Y),
	addHorizontalLines(Y, X).


isWithinBounds([H|T], X, Y) :-
	getBoardSize([H|T], Ll, Bl),
	X >= 0, X < Ll, Y >= 0, Y < Bl.

getBoardSize([H|T], X, Y):-
	length(H, X),
	length([H|T], Y).


makeMove([H|T], X1, Y1, X2, Y2, N2, X):-
	isWithinBounds([H|T], X1, Y1),
	isWithinBounds([H|T], X2, Y2),
	
	getPiece([H|T], X1, Y1, Piece),
	length(Piece, 2),
	getPiece([H|T], X2, Y2, Piece2),
	length(Piece2, 0),

	nth0(0, Piece, N1),
	nth0(1, Piece, Colour),
	nth0(Y1, [H|T], Line),
	N is N1-N2,

	N > 0, N2 > 0,

	replace(Line, X1, [N, Colour], L),
	replace([H|T], Y1, L, Foo),

	nth0(Y2, [H|T], Line2),
	replace(Line2, X2, [N2, Colour], L2),
	replace(Foo, Y2, L2, X), !.

getPiece([H|T], X, Y, Piece) :-
	nth0(Y, [H|T], Line),
	nth0(X, Line, Piece).


%Gets piece Height
getHeight(Piece, Height, 0) :- H = 0.
getHeight(Piece, Height,2) :- nth0(0, Piece).
getHeight(Piece, Height):-
	length(Piece, L),
	getHeight(Piece, Height, L).

%Gets piece colour
getColour(Piece, Colour, 0):- Colour = ''.
getColour(Piece, Colour, 2):- nth0(1, Piece, Colour).
getColour(Piece, Colour):-
	length(Piece, L),
	getColour(Piece, Colour, L).


% Iterates the moves list and makes the pairs
getBotMoves2(_, _, [], OutList, OutList).
getBotMoves2(X1, Y1, [H|T], InList, OutList):-
	nth0(0, H, X2),
	nth0(1, H, Y2),
	append(InList, [[[X1,Y1],[X2,Y2]]], Foobar),
	getBotMoves2(X1, Y1, T, Foobar, OutList).

getBotMoves(_, [], OutList, OutList).
getBotMoves(Board, [H|T], InList, OutList):-
	nth0(0, H, X),
	nth0(1, H, Y),	
	getPieceMoves(Board, X, Y, Moves),
	getBotMoves2(X, Y, Moves, Final, Foobar),
	getBotMoves(Board, T, Foobar, OutList).

% Gets the list of moves in [[[X1,Y1],[X2,Y2]]] form
getBotMoves(Board, Colour, Moves):-
	append([], [], EmptyList),
	getPieces(Board, Colour, Pieces),
	getBotMoves(Board, Pieces, EmptyList, Moves).

getPiecesLine([H|T], Colour, Colour, X, Y, Pieces, NewPieces):-
	append(Pieces, [[X,Y]], Foobar),
	X1 is X+1,
	getPiecesLine(T, Colour, X1, Y, Foobar, NewPieces).

getPiecesLine([H|T], Colour, PieceColour, X, Y, Pieces, NewPieces):-
	append([], Pieces, Foobar), 
	X1 is X+1,
	getPiecesLine(T, Colour, X1, Y, Foobar, NewPieces).

getPiecesLine([], _, _, _, Pieces, Pieces).
getPiecesLine([H|T], Colour, X, Y, Pieces, NewPieces):-
	getColour(H, PieceColour),
	getPiecesLine([H|T], Colour, PieceColour, Y, Pieces, NewPieces).

getPiecesBoard([], _, _, Pieces, Pieces).
getPiecesBoard([H|T], Colour, Y, EmptyPieces, Pieces):-
	getPiecesLine(H, Colour, 0, Y, EmptyPieces, NewPieces),
	Y1 is Y+1,
	getPiecesBoard(T, Colour, Y1, NewPieces, Pieces).

getPieces(Board, Colour, Pieces):-
	append([], [], EmptyPieces),
	getPiecesBoard(Board, Colour, 0, EmptyPieces, Pieces).


addVerticalLines([], []).
addVerticalLines([H|T], [H2|Tail]):-
	addHead(H, [], Z),
	addTail(Z, [], H2),
	addVerticalLines(T, Tail).


addHorizontalLines([H|T], Y) :-
	append([H|T], [], X),
	length(H, Hl),
	createLine(W, Hl),
	addHead(X, W, Z),
	addTail(Z, W, Y).


getPieceMoves(Board, X, Y, Output):-
	append([], [], Foobar),

	getPiece(Board, X, Y, Piece),
	nth0(1, Piece, Colour),

	X1 is X+1, Y1 is Y-2, %% Up-right
	checkPieceMove(Board, X1, Y1, Colour, Foobar, Foobar2),
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


checkPieceMove(Board, X, Y, Colour, InputList, OutputList):-
	checkAdjacent(Board, X, Y, Colour) ->
		append(InputList, [[X, Y]], OutputList);

		append(InputList, [], OutputList).

checkAdjacent(Board, X, Y, Colour):-
	
	getPiece(Board, X, Y, Piece),
	length(Piece, 0),

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
	checkPieceColour(Board, X8, Y8, Colour)).

checkPieceColour(Board, X, Y, Colour):-
	getPiece(Board, X, Y, Piece),
	nth0(1, Piece, Colour1),
	dif(Colour, Colour1).



checkWin([H|T], Winner):-
	length([H|T], BL),
	length(H, Ll),
	checkWinVertical(Board, 0, 0, Bl, Ll, Winner).





checkWinVertical(Board, X, Y, Bl, Ll, Winner):-
	Bl2 is Bl-3,
	X < Ll,
	Y < Bl2,
	checkWinVertical(Board, X, Y, Bl, Ll, 'w', Winner);
	checkWinVertical(Board, X, Y, Bl, Ll, 'b', Winner);
	checkWinVertical(Board, X, Y, Bl, Ll, Winner).


checkWinVertical(Board, X, Y, Bl, Ll, Colour, Winner):-
	Y2 is Y+1,
	Y3 is Y+2,
	Y4 is Y+3,

	getPiece(Board, X, Y, Piece1),
	getColour(Piece1, Colour1),
	Colour1 = Colour,

	getPiece(Board, X, Y2, Piece2),
	getColour(Piece2, Colour2),
	Colour2 = Colour,

	getPiece(Board, X, Y3, Piece3),
	getColour(Piece3, Colour3),
	Colour3 = Colour,

	getPiece(Board, X, Y4, Piece4),
	getColour(Piece4, Colour4),
	Colour4 = Colour,

	Winner is Colour.