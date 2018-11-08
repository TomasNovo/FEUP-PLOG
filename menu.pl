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
    X = 1 ->(write('You selected Player vs Player game !'),nl, nl,
            write('Have a nice game ! '), nl, nl,
            make_game() );
    X \= 1 -> (X = 2 ->(select_difficulty_pc);           
               X \= 2 ->(X = 3 -> (write('Option 3'));                       
                         X \= 3 -> (X = 4 -> (write_credits);
                                    X \= 4 -> (X = 5 -> (write('Thank you, bye !'),nl,true);
                                               X \= 5 -> (wrong_input,kl))))).
 
wrong_input :- write('You have picked an invalid option !'),
               nl, nl,  write('Please, input again !'),nl,nl.
 
select_difficulty_pc :- write('You selected Player vs Computer game !'),
                     nl, nl, write('Please enter PC difficulty (0 for medium, 1 for hard)'),
                     nl, write('Input: '), read(Y),
                     pc_difficulty_read(Y).
 
write_credits :- (write('Game developed by : '), nl,
                  write('- Joao Pedro Viveiros Franco'), nl,
                  write('- Tomas Nuno Fernandes Novo'), nl,nl).
 
kl :-
    display_gameStart,
    display_menu, nl,
    write('Input: '),
    read(A), nl,
    gameOptions(A).

make_game() :-
  printInitial,nl,
  write('Choose a stack to move (X, Y) : '),nl,
  read(X),
  read(Y),
  initialBoard(Board),
  getPieceMoves(Board, X, Y, Board2),
  showMoves(Board, Board2, Board3),
  nl,printBoard(Board3),nl.