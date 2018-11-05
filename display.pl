replace([_|T], 0, New, [New|T]).
replace([H|T], Index, New, [H|R]) :-
	I1 is Index - 1,
	replace(T, I1, New, R).

clear_console :-
	clear_console(40), !.

clear_console(0).

clear_console(N) :-
	nl, N1 is N - 1, clear_console(N1).


display_gameStart :- write('Welcome to Knights Line !'), nl, nl.

display_menu :- write('Choose the mode you want to play :'), nl,
				write('1 - Player vs Player '), nl,
				write('2 - Player vs Computer '), nl,
				write('3 - Watch Computer vs Computer '), nl,
				write('4 - Credits '), nl, nl.

pc_difficulty_read(Y) :- Y = 0 -> write('Difficulty Medium setted !'),nl;
						 Y \= 0 -> write('Difficulty Hard setted !').

gameOption1(X) :- X = 1 -> write('You selected Player vs Player game !'),
							nl, nl, write('Have a nice game ! '), nl, nl, make_game(_);
				  X \= 1 -> gameOption2(X).

gameOption2(X) :- X = 2 -> write('You selected Player vs Computer game !'),
							nl, nl, write('Please enter PC difficulty (0 for medium, 1 for hard)'),
							nl, write('Input: '), read(Y),
							pc_difficulty_read(Y);
				  X \= 2 -> gameOption3(X).

gameOption3(X) :- X = 3 -> write('Option 3');
				  X \= 3 -> gameOption4(X).

gameOption4(X) :- X = 4 -> write('Game developed by : '), nl,
						   write('- Joao Pedro Viveiros Franco'), nl,
						   write('- Tomas Nuno Fernandes Novo'), nl,nl;
				  X \= 4 -> write('You have picked an invalid option !'), nl, nl,
							write('Please, input again !'), nl,nl,
							kl.

kl :- display_gameStart,
	  display_menu, nl,
	  write('Input: '),
	  read(A),
	  gameOption1(A).


initialBoard([[[], [], [], [' A ']],
		[[], [20,'b'], [20,'p'], []],
		[[], [], [], [' B ']]]).


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
	write(H),
	T \= [] -> draw_piece(T);
	0 = 0.



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

make_game(C) :-
	printInitial,nl,nl,
	write('Where do you wanna go ? A or B ?'),
	read(C).