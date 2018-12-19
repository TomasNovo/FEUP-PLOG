:- consult('utilities.pl'), use_module(library(lists)).

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
	nth0(Y, Board, Line),
	nth0(X, Line, Piece).

check_valid_sudoku(Board):-
	check_valid_sudoku_vertical(Board),
	check_valid_sudoku_horizontal(Board).
	%% check_valid_sudoku_box(Board).

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