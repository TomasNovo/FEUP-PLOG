:-consult('logic.pl'), use_module(library(random)).

%%%%%%%%%%%%%%%%%
% Bot functions %
%%%%%%%%%%%%%%%%%
% Makes a move for computer player
%  moveBot -> Makes a move for computer player according to colour and play number
%  botMove -> Executes the move

moveBot(Board, I, Difficulty, NewBoard) :-
	P is mod(I, 2),
	moveBot(Board, I, P, Difficulty, NewBoard).


moveBot(Board, I, 0, Difficulty, NewBoard):-
	Colour = 'w',
	valid_moves(Board, Colour, Moves),
	choose_move(Board, Colour, Difficulty, Moves, Move, Height),
	checkHeight(Height, I, NewHeight),
	move(Move, Board, NewHeight, NewBoard),
	value(NewBoard, Colour, Value),

	write('Whites playing !'),nl,
	write('Move : '), write(Move),nl,
	write('Height = '), write(Height),nl,
	write('Value = '), write(Value),nl,nl.

moveBot(Board, I, 1, Difficulty, NewBoard):-
	Colour = 'b',
	valid_moves(Board, Colour, Moves),
	choose_move(Board, Colour, Difficulty, Moves, Move, Height),
	checkHeight(Height, I, NewHeight),
	move(Move, Board, NewHeight, NewBoard),
	value(NewBoard, Colour, Value),

	write('Blacks playing !'),nl,
	write('Move : '), write(Move),nl,
	write('Height = '), write(Height),nl,
	write('Value = '), write(Value),nl,nl.

checkHeight(_, 0, 1).
checkHeight(H1, _, H1).

choose_move(_, _, _, [], [], 0).

choose_move(Board, _, 1, Moves, Move, Height):-

	length(Moves, MovesLength),
	random(0, MovesLength, RandomIndex),
	nth0(RandomIndex, Moves, Move),
	
	nth0(0, Move, Piece1),
	nth0(0, Piece1, X1),
	nth0(1, Piece1, Y1),
	getPiece(Board, X1, Y1, Piece),
	getHeight(Piece, H),
	
	random(1, H, Height).

choose_move(Board, Colour, 2, Moves, Move, Height):-
	getBiggestValueMove(Board, Moves, Colour, Move),
	
	nth0(0, Move, Piece1),
	nth0(0, Piece1, X1),
	nth0(1, Piece1, Y1),
	
	getPiece(Board, X1, Y1, P1),
	getHeight(P1, H),

	H2 is H/3,
	H3 is H2*2,
	H4 is round(H2),
	H5 is ceiling(H3),

	random(H4, H5, Height).

getBiggestValueMove(Board, Moves, Colour, Move):-
	getBiggestValueMove(Board, Moves, Colour, 0, [], Move).

getBiggestValueMove(_, [], _, _, Move, Move).
getBiggestValueMove(Board, [H|T], Colour, MaxValue, MaxMove, Move):-
	getBotMoveValue(Board, H, Colour, Value),

	getBiggestValueMoveAux(Board, [H|T], Colour, Value, MaxValue, MaxMove, Move).

getBiggestValueMoveAux(Board, [H|T], Colour, Value, MaxValue, _, Move):-
	Value > MaxValue,
	getBiggestValueMove(Board, T, Colour, Value, H, Move).

getBiggestValueMoveAux(Board, [_|T], Colour, Value, MaxValue, MaxMove, Move):-
	Value =< MaxValue,
	getBiggestValueMove(Board, T, Colour, MaxValue, MaxMove, Move).

getBotMoveValue(Board, Move, Colour, Value):-
	nth0(0, Move, Piece1),
	nth0(0, Piece1, X1),
	nth0(1, Piece1, Y1),
	nth0(1, Move, Piece2),
	nth0(0, Piece2, X2),
	nth0(1, Piece2, Y2),
	move(Board, X1, Y1, X2, Y2, 1, Board2),
	value(Board2, Colour, Value).