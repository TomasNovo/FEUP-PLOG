clear_console :- 
	clear_console(40), !.

clear_console(0).

clear_console(N) :-
	nl, N1 is N - 1, clear_console(N1).


createLine([], 0).
createLine([H|T], I):-
	I > 0,
	append([], [], H),
	I1 is I-1,
	createLine(T, I1), !.


/*Adicionar elementos na lista*/
addHead([H|T],A,Zs) :-
	append([A],[H|T],Zs).
addTail([H|T],A,Zs) :-
	append([H|T],[A],Zs).


draw_piece([]):-
	write(' _ ').

draw_piece([H|T]):-
	T = [] ->
		write(H);
	T \= [] ->
		nth0(1, [H|T], Colour),
		printPieceColour(H, Colour).


printPieceColour(N, Colour):-
		N @< 10 -> 
			write(N),
			write(' '),
			write(Colour);
		N @>= 10 -> 
			write(N),
			write(Colour).

print_line([]).
print_line([H|T]):-
	draw_piece(H),
	T \= [] -> write('|'), print_line(T);
	T = [] -> print_line(T).

printBoard([ ]).
printBoard([H|T]) :-
	print_line(H),
	nl,printBoard(T).


printInitial :-
	initialBoard(Tabuleiro),
	printBoard(Tabuleiro).