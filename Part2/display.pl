%%%%%%%%%%%
% Console %
%%%%%%%%%%%

initialBoard(	[
				 [ [[], [], []], [[], [], []], [[], [], []] ],
				 [ [[], [], []], [[], [], []], [[], [], []] ],
				 [ [[], [], []], [[], [], []], [[], [], []] ],
				 [ [[], [], []], [[], [], []], [[], [], []] ],
				 [ [[], [], []], [[], [], []], [[], [], []] ],
				 [ [[], [], []], [[], [], []], [[], [], []] ],
				 [ [[], [], []], [[], [], []], [[], [], []] ],
				 [ [[], [], []], [[], [], []], [[], [], []] ],
				 [ [[], [], []], [[], [], []], [[], [], []] ]
				]
			).

draw_piece_aux([H|[]]):- write(H).

draw_piece([]):- write(' _ ').
draw_piece([H|T]):-
	draw_piece_aux([H|T]).


print_trio([]).
print_trio([H|T]):-
	T \= [],
	draw_piece(H),
	print_trio_aux(T),
	print_trio(T).

print_trio([H|T]):-
	T = [],
	draw_piece(H),
	print_trio_aux(T),
	print_trio(T).


print_trio_aux([]):- write('| ').
print_trio_aux([_|_]):-write('|').

print_line_aux([]):-
	write('|'),nl,
	write(' ----------------------------------------------'),nl.
print_line_aux([_|_]):-
	write(' |').


print_line([], _).
print_line([H|T], I):-
	T \= [],
	Z is I mod 3,
	print_trio(H),
	print_line_aux(T),
	print_line(T, I).

print_line([H|T], I):-
	T = [],
	print_trio(H),
	print_line_aux(T),
	print_line(T, I).

printBoard([], _).
printBoard([H|T], I) :-
	printColumnNumber(I),
	print_line(H, I),
	I1 is I+1,
	printBoard(T, I1).

printBoard(Board):-
	I is 0,
	nl,nl,nl,
	printBoard(Board, I).



printColumnNumber(N):- 
	N < 10,
	write('| |').

 printColumnNumber(N):- 
	N >= 10,
	write(N),
	write('|').

% Returns the dimensions of the board
getBoardSize([H|T], X, Y):-
	length(H, X),
	length([H|T], Y).



% Helper to clear console 
clear_console :- 
	clear_console(40), !.

clear_console(0).

clear_console(N) :-
	nl, N1 is N - 1, clear_console(N1).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


displayBar(Board):-
	getBoardSize(Board, W, _),
	I is 1,
	write('   ___'),
	displayBar(Board, W, I).

displayBar(Board, Width, N) :-
	write('|___'),
	(N1 is N + 1,
	N1 @< Width,
	displayBar(Board, Width, N1);
	true).

getPiece([H|T], X, Y, Piece) :-
	nth0(Y, [H|T], Line),
	nth0(X, Line, Piece).


