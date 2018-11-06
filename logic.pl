display_gameStart :-
	write('Welcome to Knights Line !'), nl, nl.

display_menu :- 
	write('Choose the mode you want to play :'), nl,
	write('1 - Player vs Player '), nl,
	write('2 - Player vs Computer '), nl,
	write('3 - Watch Computer vs Computer '), nl,
	write('4 - Credits '), nl, nl.

pc_difficulty_read(Y) :-
	Y = 0 ->
		write('Difficulty Medium setted !'),nl;
	Y \= 0 ->
		write('Difficulty Hard setted !').

gameOption1(X) :- 
	X = 1 ->
		write('You selected Player vs Player game !'),nl, nl,
		write('Have a nice game ! '), nl, nl,
		make_game(_);
	X \= 1 ->
		gameOption2(X).

gameOption2(X) :- 
	X = 2 ->
		write('You selected Player vs Computer game !'),
		nl, nl, write('Please enter PC difficulty (0 for medium, 1 for hard)'),
		nl, write('Input: '), read(Y),
		pc_difficulty_read(Y);
	X \= 2 ->
		gameOption3(X).

gameOption3(X) :-
	X = 3 ->
		write('Option 3');
	X \= 3 ->
		gameOption4(X).

gameOption4(X) :-
	X = 4 ->
		write('Game developed by : '), nl, 
		write('- Joao Pedro Viveiros Franco'), nl, 
		write('- Tomas Nuno Fernandes Novo'), nl,nl;
	X \= 4 ->
		write('You have picked an invalid option !'), nl, nl, write('Please, input again !'), nl,nl,
		kl.

kl :-
	display_gameStart,
	display_menu, nl,
	write('Input: '),
	read(A),
	gameOption1(A).


make_game(C) :-
	printInitial,nl,nl,
	write('Where do you wanna go ? A or B ?'),
	read(C).