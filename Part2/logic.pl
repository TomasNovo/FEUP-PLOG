:- consult('utilities.pl'), use_module(library(lists)), use_module(library(clpfd)).

initialBoard(	[
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ]
				]
			).


initialHints([ 
	[3,4,5],[8,9],[1,2],[1,3],[6,7],[5,6],[],[8,9],
	[3,1],[],[5,4],[4,3],[7,5][9,8],[],[6,5,4],[2,1],
	[3,2],[9,1],[8,7],[5,4,3],[9,8],[7,6],[9,8],[3,2],[7,6],
	[3,4],[],[1],[2,3,4],[6,8],[],[6,7],[5,8],[]
	] ).


testingBoard(	[
				 [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
				 [ 4, 5, 6, 7, 8, 9, 1, 2, 3 ],
				 [ 7, 8, 9, 1, 2, 3, 4, 5, 6 ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ],
				 [ [], [], [], [], [], [], [], [], [] ]
				]
			).


winningBoard(	[
				 [ 5, 3, 4, 6, 7, 8, 9, 1, 2 ],
				 [ 6, 7, 2, 1, 9, 5, 3, 4, 8 ],
				 [ 1, 9, 8, 3, 4, 2, 5, 6, 7 ],
				 [ 8, 5, 9, 7, 6, 1, 4, 2, 3 ],
				 [ 4, 2, 6, 8, 5, 3, 7, 9, 1 ],
				 [ 7, 1, 3, 9, 2, 4, 8, 5, 6 ],
				 [ 9, 6, 1, 5, 3, 7, 2, 8, 4 ],
				 [ 2, 8, 7, 4, 1, 9, 6, 3, 5 ],
				 [ 3, 4, 5, 2, 8, 6, 1, 7, 9 ]
				]
			).

initialSelection(X):-
	fillList(3, [], Y),
	fillList(3, Y, X).

getElement(Board, X, Y, Piece) :-
	element(Y, Board, Line),
	element(X, Line, Piece).


getBoardSize([H|T], Width, Height):-
	length([H|T], Height),
	length(H, Width).


fillBoard(Board):-
	length(Board, 9),
	fillBoardHorizontal(Board),
	fillBoardVertical(Board),
	fillBoardBox(Board),

	initialHints(Hints),
	fillHints(Board, Hints, 36),

	recursiveLabeling(Board).


fillBoardHorizontal([]).
fillBoardHorizontal([H|T]):-
	length(H, 9),
	domain(H, 1, 9),
	all_different(H),
	fillBoardHorizontal(T).

fillBoardVertical(Board):-
	fillBoardVertical(Board, 9).


fillBoardVertical(_, 0).
fillBoardVertical(Board, I):-

	fillBoardVertical(Board, I, [], List),
	domain(List, 1, 9),
	all_different(List),

	I1 is I-1,
	fillBoardVertical(Board, I1).

fillBoardVertical([], _, List, List).
fillBoardVertical([H|T], I, List, List2):-
	element(I,H,A),
	fillBoardVertical(T, I, [A|List], List2).

fillBoardBox(Board):-
	fillBoardBox(Board, 9).


fillBoardBox(_, 0).
fillBoardBox(Board, I):-
	I1 is I-1,
	X is mod(I1,3)*3,
	Y is div(I1,3)*3,

	fillBoardBox(Board, X, Y, 9, [], List),
	domain(List, 1, 9),
	all_different(List),

	fillBoardBox(Board, I1).

fillBoardBox(_, _, _, 0, List, List).
fillBoardBox(Board, X, Y, I, List, List2):-
	I1 is I-1,
	X1 is X+mod(I1,3)+1,
	Y1 is Y+div(I1,3),

	write(X1),nl,write(Y1),nl,nl,

	nth0(Y1, Board, Row),
	element(X1, Row, A),
	fillBoardBox(Board, X, Y, I1, [A|List], List2).


fillHints(Board, [], 0).
fillHints(Board, [H|T], I):-
	fillHint(Board, H, I),

	I1 is I-1,
	fillHints(Board, T, I1).

fillHint(Board, [], _).
fillHint(Board, [H|T], I):-
	



recursiveLabeling([]).
recursiveLabeling([H|T]):-
	labeling([], H),
	recursiveLabeling(T).


getTriplet(Board, I):-
	A is mod(I,9),
	B is div(I,9),

	X is A,
	Y is B,

getTriplet2(Board, I, A, B, List):-
	B = 0,
	Y = 1,
	getElement(Board, A, B)

getTriplet2(Board, I, A, B, List):-
	B = 1,
	X = 9,
	getElement(Board, A, B)

getTriplet2(Board, I, A, B, List):-
	B = 2,
	Y = 9,
	getElement(Board, A, B)

getTriplet2(Board, I, A, B, List):-
	B = 3,
	X = 0,
	getElement(Board, A, B)


check_valid_sudoku(Board):-
	check_valid_sudoku_vertical(Board),
	check_valid_sudoku_horizontal(Board),
	check_valid_sudoku_box(Board).

check_valid_sudoku_horizontal([]).
check_valid_sudoku_horizontal([H|T]):-
	fillList(9, 0, Work),
	check_valid_sudoku_horizontal2(H, Work),
	check_valid_sudoku_horizontal(T).

check_valid_sudoku_horizontal2([], _).
check_valid_sudoku_horizontal2([H|T], Work):-
	H \= [],
	H1 is H-1,
	nth0(H1, Work, 0),
	replace(Work, H1, 1, NewWork),
	check_valid_sudoku_horizontal2(T, NewWork).

check_valid_sudoku_horizontal2([H|T], Work):-
	H = [],
	check_valid_sudoku_horizontal2(T, Work).

check_valid_sudoku_vertical(Board):-
	check_valid_sudoku_vertical(Board, 9).

check_valid_sudoku_vertical(_, 0).
check_valid_sudoku_vertical(Board, I):-
	fillList(9, 0, Work),
	check_valid_sudoku_vertical2(Board, I, Work),
	I1 is I-1,
	check_valid_sudoku_vertical(Board, I1).

check_valid_sudoku_vertical2([], _, _).
check_valid_sudoku_vertical2([H|T], Index, Work):-
	Index1 is Index-1,
	nth0(Index1, H, Element),
	Element \= [],
	Element1 is Element-1,
	nth0(Element1, Work, 0),
	replace(Work, Element1, 1, NewWork),
	check_valid_sudoku_vertical2(T, Index, NewWork).

check_valid_sudoku_vertical2([H|T], Index, Work):-
	Index1 is Index-1,
	nth0(Index1, H, Element),
	Element = [],
	check_valid_sudoku_vertical2(T, Index, Work).

check_valid_sudoku_box(Board):-
	fillList(9, 0, Work),
	check_valid_sudoku_box(Board, 9, Work).

check_valid_sudoku_box(_, 0, _).
check_valid_sudoku_box(Board, I, Work):-
	I1 is I-1,
	X1 is mod(I1,3),
	Y1 is div(I1,3),
	X is X1*3,
	Y is Y1*3,

	check_valid_sudoku_box2(Board, X, Y, 9, Work),
	check_valid_sudoku_box(Board, I1, Work).

check_valid_sudoku_box2(_, _, _, 0, _).
check_valid_sudoku_box2(Board, X, Y, I, Work):-
	I1 is I-1,
	X1 is X+mod(I1,3),
	Y1 is Y+div(I1,3),

	getElement(Board, X1, Y1, Element),
	Element \= [],
	Element1 is Element-1,
	nth0(Element1, Work, 0),
	replace(Work, Element1, 1, NewWork),
	check_valid_sudoku_box2(Board, X, Y, I1, NewWork).

check_valid_sudoku_box2(Board, X, Y, I, Work):-
	I1 is I-1,
	X1 is X+mod(I1,3),
	Y1 is Y+div(I1,3),

	getElement(Board, X1, Y1, Element),
	Element = [],
	check_valid_sudoku_box2(Board, X, Y, I1, Work).