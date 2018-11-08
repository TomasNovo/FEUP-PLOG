:- consult('utilities.pl'), use_module(library(lists)).

initialBoard([[[], [], [], [' A ']],
			[[], [20,'b'], [20,'p'], []],
			[[], [], [], [' B ']]]).

testingBoard(X):-
	initialBoard(Z),
	addVerticalLines(Z, Y),
	addHorizontalLines(Y, X).

display_gameStart :-
	write('Welcome to Knights Line !'), nl, nl.

display_menu :-
	write('Choose the mode you want to play :'), nl,
	write('1 - Player vs Player '), nl,
	write('2 - Player vs Computer '), nl,
	write('3 - Watch Computer vs Computer '), nl,
	write('4 - Credits '), nl,
	write('5 - Exit'),nl.

pc_difficulty_read(Y) :-
	Y = 0 ->
		write('Difficulty Medium setted !'),nl;
	Y \= 0 ->
		write('Difficulty Hard setted !').

gameOptions(X) :-
	X = 1 -> (
							write('You selected Player vs Player game !'),nl, nl,
							write('Have a nice game ! '), nl, nl,
							make_game(_) );
	X \= 1 -> (X = 2 -> (write('You selected Player vs Computer game !'),
										 nl, nl, write('Please enter PC difficulty (0 for medium, 1 for hard)'),
										 nl, write('Input: '), read(Y),
										 pc_difficulty_read(Y));
						X \= 2 -> (X = 3 -> (write('Option 3'));
											 X \= 3 -> (X = 4 -> (write('Game developed by : '), nl,
																					write('- Joao Pedro Viveiros Franco'), nl,
																					write('- Tomas Nuno Fernandes Novo'), nl,nl);
																X \= 4 -> (X = 5 -> (write('Thank you, bye !'),nl,true);
																					 X \= 5	-> (write('You have picked an invalid option !'),
																					 						nl, nl,
																											write('Please, input again !'),
																											nl,nl,
																											kl))))).

kl :-
	display_gameStart,
	display_menu, nl,
	write('Input: '),
	read(A),
	gameOptions(A).

isWithinBounds([H|T], X, Y) :-
	getBoardSize([H|T], Ll, Bl),
	X >= 0, X < Ll, Y >= 0, Y < Bl.

getBoardSize([H|T], X, Y):-
	length(H, X),
	length([H|T], Y).
	

make_game(C) :-
	printInitial,nl,nl,
	write('Where do you wanna go ? A or B ?'),
	read(C).

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
	X1 is X+1, Y1 is Y-2, %% Up-right
	checkPieceMove(Board, X1, Y1, Foobar, Foobar2),
	X2 is X+2, Y2 is Y-1, %% Right-up
	checkPieceMove(Board, X2, Y2, Foobar2, Foobar3),
	X3 is X+2, Y3 is Y+1, %% Right-down
	checkPieceMove(Board, X3, Y3, Foobar3, Foobar4),
	X4 is X+1, Y4 is Y+2, %% Down-right
	checkPieceMove(Board, X4, Y4, Foobar4, Foobar5),
	X5 is X-1, Y5 is Y+2, %% Down-left
	checkPieceMove(Board, X5, Y5, Foobar5, Foobar6),
	X6 is X-2, Y6 is Y+1, %% Left-down
	checkPieceMove(Board, X6, Y6, Foobar6, Foobar7),
	X7 is X-2, Y7 is Y-1, %% Left-up
	checkPieceMove(Board, X7, Y7, Foobar7, Foobar8),
	X8 is X-1, Y8 is Y-2, %% Up-left
	checkPieceMove(Board, X8, Y8, Foobar8, Output).


checkPieceMove(Board, X, Y, InputList, OutputList):-
	checkAdjacent(Board, X, Y) ->
		append(InputList, [[X, Y]], OutputList);

		append(InputList, [], OutputList).

checkAdjacent(Board, X, Y):-
	getPiece(Board, X, Y, Piece),
	nth0(1, Piece, Colour),
	
	X1 is X, Y1 is Y-1, %% Up
	getPiece(Board, X1, Y1, Piece1),
	nth0(1, Piece1, Colour1),

	X2 is X+1, Y2 is Y-1, %% Up-right
	getPiece(Board, X2, Y2, Piece2),
	nth0(1, Piece2, Colour2),

	X3 is X+1, Y3 is Y, %% Right
	getPiece(Board, X3, Y3, Piece3),
	nth0(1, Piece3, Colour3),

	X4 is X+1, Y4 is Y+1, %% Down-right
	getPiece(Board, X4, Y4, Piece4),
	nth0(1, Piece4, Colour4),

	X5 is X, Y5 is Y+1, %% Down
	getPiece(Board, X5, Y5, Piece5),
	nth0(1, Piece5, Colour5),

	X6 is X-1, Y6 is Y+1, %% Down-left
	getPiece(Board, X6, Y6, Piece6),
	nth0(1, Piece6, Colour6),

	X7 is X-1, Y7 is Y, %% Left
	getPiece(Board, X7, Y7, Piece7),
	nth0(1, Piece7, Colour7),

	X8 is X-1, Y8 is Y-1, %% Up-left
	getPiece(Board, X8, Y8, Piece8),
	nth0(1, Piece8, Colour8).