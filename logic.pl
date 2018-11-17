:- consult('utilities.pl'), use_module(library(lists)).

initialBoard(	[[[], [], [], []],
				[[], [20,'w'], [20,'b'], []],
				[[], [], [], []]]).

testBoard(	[[[1, 'w'], [], [], [5, 'w']],
			[[1, 'b'], [15,'w'], [20,'b'], [3, 'b']],
			[[3, 'b'], [3, 'w'], [3, 'w'], []],
			[[3, 'b'], [4, 'w'], [], [7, 'b']],
			[[8, 'w'], [7,  'b'], [], []]]).

testBoard2(	[[[], [], [], [], [], [], []],
			[[], [], [4, 'w'], [4, 'b'], [], [], []],
			[[], [], [], [1, 'w'], [2, 'b'], [], []],
			[[], [3, 'w'], [13, 'b'], [], [], [3, 'w'], []],
			[[], [], [], [6, 'w'], [1, 'b'], [], []],
			[[], [], [], [], [], [], []]]).

testingBoard(X):-
	initialBoard(Z),
	addVerticalLines(Z, Y),
	addHorizontalLines(Y, X).


isWithinBounds(Board, X, Y) :-
	getBoardSize(Board, Width, Height),
	X >= 0, X < Width, Y >= 0, Y < Height.

getBoardSize([H|T], X, Y):-
	length(H, X),
	length([H|T], Y).

makeMove(Board, Move, N, X):-

	nth0(0, Move, Piece1),
	nth0(0, Piece1, X1),
	nth0(1, Piece1, Y1),
	nth0(1, Move, Piece2),
	nth0(0, Piece2, X2),
	nth0(1, Piece2, Y2),

	makeMove(Board, X1, Y1, X2, Y2, N, X).

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
	replace(Foo, Y2, L2, Foo2),
	increaseBoard(Foo2, X).

getPiece([H|T], X, Y, Piece) :-
	nth0(Y, [H|T], Line),
	nth0(X, Line, Piece).


%Gets piece Height
getHeight(Piece, Height, 0) :- Height = 0.
getHeight(Piece, Height, 2) :- nth0(0, Piece, Height).
getHeight(Piece, Height):-
	length(Piece, L),
	getHeight(Piece, Height, L).

%Gets piece colour
getColour(Piece, Colour, 0):- Colour = ''.
getColour(Piece, Colour, 2):- nth0(1, Piece, Colour).
getColour(Piece, Colour):-
	length(Piece, L),
	getColour(Piece, Colour, L).


getMovingPlayer(Board, Player):-
	getPieces(Board, 'w', Wpieces),
	getPieces(Board, 'b', Bpieces),
	length(Wpieces, WL),
	length(Bpieces, BL),
	getMovingPlayer(Board, WL, BL, Player).

getMovingPlayer(_, WL, WL, 'w').

getMovingPlayer(_, WL, BL, 'b').


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
	valid_moves(Board, X, Y, Moves),
	getBotMoves2(X, Y, Moves, InList, Foobar),
	getBotMoves(Board, T, Foobar, OutList).

% Gets the list of moves in [[[X1,Y1],[X2,Y2]]] form
getBotMoves(Board, Colour, Moves):-
	append([], [], EmptyList),
	getPieces(Board, Colour, Pieces),
	getBotMoves(Board, Pieces, EmptyList, Moves).

getPiecesLine([H|T], Colour, PieceColour, X, Y, Pieces, NewPieces):-
	Colour = PieceColour,
	append(Pieces, [[X,Y]], NewPieces).

getPiecesLine([H|T], Colour, PieceColour, X, Y, Pieces, NewPieces):-
	Colour \= PieceColour,
	append([], Pieces, NewPieces). 
	

getPiecesLine([], _, _, _, Pieces, Pieces).
getPiecesLine([H|T], Colour, X, Y, Pieces, NewPieces):-
	getColour(H, PieceColour),
	getPiecesLine([H|T], Colour, PieceColour, X, Y, Pieces, Foobar),

	X1 is X+1,
	getPiecesLine(T, Colour, X1, Y, Foobar, NewPieces).

getPiecesBoard([], _, _, Pieces, Pieces).
getPiecesBoard([H|T], Colour, Y, EmptyPieces, Pieces):-
	getPiecesLine(H, Colour, 0, Y, EmptyPieces, NewPieces),
	Y1 is Y+1,
	getPiecesBoard(T, Colour, Y1, NewPieces, Pieces).

getPieces(Board, Colour, Pieces):-
	append([], [], EmptyPieces),
	getPiecesBoard(Board, Colour, 0, EmptyPieces, Pieces).


valid_moves(Board, X, Y, Output):-
	append([], [], Foobar),

	getPiece(Board, X, Y, Piece),
	getColour(Piece, Colour),
	getHeight(Piece, Height),

	valid_moves2(Board, X, Y, Height, Colour, Output).

valid_moves2(Board, X, Y, Height, Colour, Output):-

	Height = 1,
	append([], [], Output).

valid_moves2(Board, X, Y, Height, Colour, Output):-

	Height > 1,
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

colourToNumber('', 0).
colourToNumber('w', 1).
colourToNumber('b', 2).

value(Board, Player, Value):-
	getBoardSize(Board, Ll, Bl),

	Max = 0,

	valueVertical(Board, 0, Bl, Ll, Player, Max, Max2),
	valueHorizontal(Board, 0, Bl, Ll, Player, Max2, Max3),
	valueDownRight(Board, 0, Bl, Ll, Player, Max3, Max4),
	valueDownLeft(Board, 0, Bl, Ll, Player, Max4, Value).

valueVertical(_, Bl, Bl, _, _, Max, Max).
valueVertical(Board, Y, Bl, Ll, Player, Max, NewMax):-

	Y1 is Y+1,
	valueVertical(Board, 0, Y, Bl, Ll, Player, Max, Max2),
	valueVertical(Board, Y1, Bl, Ll, Player, Max2, NewMax).

valueVertical(_, Ll, _, _, Ll, _, Max, Max).
valueVertical(Board, X, Y, Bl, Ll, Player, Max, NewMax):-

	Y1 is Y+1,
	Y2 is Y+2,
	Y3 is Y+3,

	NewX is X+1,
	valueCheckFour(Board, X, Y, X, Y1, X, Y2, X, Y3, Player, Max, Max2),
	valueVertical(Board, NewX, Y, Bl, Ll, Player, Max2, NewMax).

valueHorizontal(_, Bl, Bl, _, _, Max, Max).
valueHorizontal(Board, Y, Bl, Ll, Player, Max, NewMax):-

	Y1 is Y+1,
	valueHorizontal(Board, 0, Y, Bl, Ll, Player, Max, Max2),
	valueHorizontal(Board, Y1, Bl, Ll, Player, Max2, NewMax).

valueHorizontal(_, Ll, _, _, Ll, _, Max, Max).
valueHorizontal(Board, X, Y, Bl, Ll, Player, Max, NewMax):-

	X1 is X+1,
	X2 is X+2,
	X3 is X+3,

	NewX is X+1,
	valueCheckFour(Board, X, Y, X1, Y, X2, Y, X3, Y, Player, Max, Max2),
	valueHorizontal(Board, NewX, Y, Bl, Ll, Player, Max2, NewMax).

valueDownRight(_, Bl, Bl, _, _, Max, Max).
valueDownRight(Board, Y, Bl, Ll, Player, Max, NewMax):-

	Y1 is Y+1,
	valueDownRight(Board, 0, Y, Bl, Ll, Player, Max, Max2),
	valueDownRight(Board, Y1, Bl, Ll, Player, Max2, NewMax).

valueDownRight(_, Ll, _, _, Ll, _, Max, Max).
valueDownRight(Board, X, Y, Bl, Ll, Player, Max, NewMax):-

	X1 is X+1,
	X2 is X+2,
	X3 is X+3,
	Y1 is Y+1,
	Y2 is Y+2,
	Y3 is Y+3,

	NewX is X+1,
	valueCheckFour(Board, X, Y, X1, Y1, X2, Y2, X3, Y3, Player, Max, Max2),
	valueDownRight(Board, NewX, Y, Bl, Ll, Player, Max2, NewMax).

valueDownLeft(_, Bl, Bl, _, _, Max, Max).
valueDownLeft(Board, Y, Bl, Ll, Player, Max, NewMax):-

	Y1 is Y+1,
	valueDownLeft(Board, 0, Y, Bl, Ll, Player, Max, Max2),
	valueDownLeft(Board, Y1, Bl, Ll, Player, Max2, NewMax).

valueDownLeft(_, Ll, _, _, Ll, _, Max, Max).
valueDownLeft(Board, X, Y, Bl, Ll, Player, Max, NewMax):-

	X1 is X-1,
	X2 is X-2,
	X3 is X-3,
	Y1 is Y+1,
	Y2 is Y+2,
	Y3 is Y+3,

	NewX is X+1,
	valueCheckFour(Board, X, Y, X1, Y1, X2, Y2, X3, Y3, Player, Max, Max2),
	valueDownLeft(Board, NewX, Y, Bl, Ll, Player, Max2, NewMax).
	

valueCheckOne(Board, X, Y, Player, N, Max, NewMax):-
	(\+((colourToNumber(Player, C),
	getPiece(Board, X, Y, Piece),
	getColour(Piece, Colour),
	colourToNumber(Colour, C2),
	C2 = C))), maximum(Max, N, NewMax).


valueCheckFour(Board, X1, Y1, X2, Y2, X3, Y3, X4, Y4, Player, Max, NewMax):-

	valueCheckOne(Board, X1, Y1, Player, 0, Max, NewMax);
	valueCheckOne(Board, X2, Y2, Player, 1, Max, NewMax);
	valueCheckOne(Board, X3, Y3, Player, 2, Max, NewMax);
	valueCheckOne(Board, X4, Y4, Player, 3, Max, NewMax);
	maximum(Max, 4, NewMax).


game_over(Board, Winner):-
	getBoardSize(Board, Ll, Bl),

	(checkWinVertical(Board, 0, Bl, Ll, Winner);
	checkWinHorizontal(Board, 0, Bl, Ll, Winner);
	checkWinDownRight(Board, 0, Bl, Ll, Winner);
	checkWinDownLeft(Board, 0, Bl, Ll, Winner)).

checkWinVertical(Board, Y, Bl, Ll, Winner):-
	Bl2 is Bl-3,
	Y @< Bl2,

	Y1 is Y+1,
	(checkWinVertical(Board, 0, Y, Bl, Ll, Winner);
	checkWinVertical(Board, Y1, Bl, Ll, Winner)).

checkWinVertical(Board, X, Y, Bl, Ll, Winner):-
	X @< Ll,

	Y1 is Y+1,
	Y2 is Y+2,
	Y3 is Y+3,

	NewX is X+1,
	(checkFour(Board, X, Y, X, Y1, X, Y2, X, Y3, Winner);
	checkWinVertical(Board, NewX, Y, Bl, Ll, Winner)).

checkWinHorizontal(Board, Y, Bl, Ll, Winner):-
	Y @< Bl,

	Y1 is Y+1,
	(checkWinHorizontal(Board, 0, Y, Bl, Ll, Winner);
	checkWinHorizontal(Board, Y1, Bl, Ll, Winner)).

checkWinHorizontal(Board, X, Y, Bl, Ll, Winner):-
	Ll2 is Ll-3,
	X @< Ll2,

	X1 is X+1,
	X2 is X+2,
	X3 is X+3,

	NewX is X+1,
	(checkFour(Board, X, Y, X1, Y, X2, Y, X3, Y, Winner);
	checkWinHorizontal(Board, NewX, Y, Bl, Ll, Winner)).

checkWinDownRight(Board, Y, Bl, Ll, Winner):-
	Bl2 is Bl-3,
	Y @< Bl2,

	Y1 is Y+1,
	(checkWinDownRight(Board, 0, Y, Bl, Ll, Winner);
	checkWinDownRight(Board, Y1, Bl, Ll, Winner)).

checkWinDownRight(Board, X, Y, Bl, Ll, Winner):-
	Ll2 is Ll-3,
	X @< Ll2,

	X1 is X+1,
	X2 is X+2,
	X3 is X+3,
	Y1 is Y+1,
	Y2 is Y+2,
	Y3 is Y+3,

	NewX is X+1,
	(checkFour(Board, X, Y, X1, Y1, X2, Y2, X3, Y3, Winner);
	checkWinDownRight(Board, NewX, Y, Bl, Ll, Winner)).

checkWinDownLeft(Board, Y, Bl, Ll, Winner):-
	Bl2 is Bl-3,
	Y @< Bl2,

	Y1 is Y+1,
	(checkWinDownLeft(Board, 3, Y, Bl, Ll, Winner);
	checkWinDownLeft(Board, Y1, Bl, Ll, Winner)).

checkWinDownLeft(Board, X, Y, Bl, Ll, Winner):-
	X @< Ll,

	X1 is X-1,
	X2 is X-2,
	X3 is X-3,
	Y1 is Y+1,
	Y2 is Y+2,
	Y3 is Y+3,

	NewX is X+1,
	(checkFour(Board, X, Y, X1, Y1, X2, Y2, X3, Y3, Winner);
	checkWinDownLeft(Board, NewX, Y, Bl, Ll, Winner)).

checkFour(Board, X1, Y1, X2, Y2, X3, Y3, X4, Y4, Winner):-
	checkFour(Board, X1, Y1, X2, Y2, X3, Y3, X4, Y4, 'w', Winner);
	checkFour(Board, X1, Y1, X2, Y2, X3, Y3, X4, Y4, 'b', Winner).

checkFour(Board, X1, Y1, X2, Y2, X3, Y3, X4, Y4, Colour, Winner):-

	colourToNumber(Colour, C),

	getPiece(Board, X1, Y1, Piece1),
	getColour(Piece1, Colour1),
	colourToNumber(Colour1, C1),
	C1 = C,

	getPiece(Board, X2, Y2, Piece2),
	getColour(Piece2, Colour2),
	colourToNumber(Colour2, C2),
	C2 = C,
	
	getPiece(Board, X3, Y3, Piece3),
	getColour(Piece3, Colour3),
	colourToNumber(Colour3, C3),
	C3 = C,

	getPiece(Board, X4, Y4, Piece4),
	getColour(Piece4, Colour4),
	colourToNumber(Colour4, C4),
	C4 = C,

	Winner = Colour.