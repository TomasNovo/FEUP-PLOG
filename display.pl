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
                            nl, nl, write('Have a nice game ! '), nl, hardcoded_board_init;
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
printBoard([H|T]) :-     print_line(H),
                         nl,printBoard(T).



printInitial :-
        initialBoard(Tabuleiro),
        printBoard(Tabuleiro).

/*printHand([], _).
printHand([H|T], N):- write(N), write('. '),
                      convertValue(H), nl,
                      N1 is N+1,
                      printHand(T, N1).



display_line(S) :-
        S1 is S-1,
        S > 0,
        write('_ , _ , _ , _ , _ , _ , _ , _ , _ , _ , _'),nl,
        display_line(S1).

display_board(W,H) :-
        W1 is W-1,
        W > 0,
        write('_ , '),
        display_board(W1,H),
        H1 is H-1,
        H > 0,
          W2 is W-1,
          nl,
          display_board(W2,H1).

draw_line(_, Max, Max).
draw_line(String, Position, Max) :-
        write(String),
        Position1 is Position+1,
        draw_line(String, Position1, Max).

draw_board(_, Y, Y).
draw_board(X, Y, Position) :-
	Position1 is Position+1,
	draw_line('_ ', 0, X),
	nl,
	draw_board(X, Y, Position1).


draw_piece([Number|Colour]):-
	append([Number|Colour], [A|B], [A|B]) -> write('   ');
	write(Number),
	write(Colour).

draw_line_even([]).
draw_line_even([Head|Tail]):-
	write('|'),
	draw_piece(Head),
	draw_line2([Tail|X], Position1, Max).

initialBoard([
	[[], [], [], []],
	[[], [20,'b'], [20,'a'], []],
	[[], [], [], []]]).

intermediateBoard([
  	[[], [], [], [] ,[], [], []],
    [[], [], [],[], [1,'b'], [2,'p'], []],
    [[], [], [16,'p'], [13,'p'] ,[], [], []],
  	[[], [5,'p'], [], [] ,[3,'b'], [], []],
    [[], [], [], [] ,[], [], []]]).

finalBoard([
      [[], [], [], [] ,[], [], [],[], []],
      [[], [2,'P'], [], [1,'b'] ,[3,'p'], [], [],[], []],
      [[], [], [4,'P'], [2,'p'] ,[1,'b'], [3,'p'], [1,'b'],[], []],
      [[], [], [], [3,'P'] ,[2,'b'], [2,'b'], [],[3,'b'], []],
      [[], [], [], [] ,[1,'P'], [6,'b'], [3,'b'],[], []],
      [[], [], [], [] ,[], [], [3,'b'],[], []],
      [[], [], [], [] ,[], [], [],[], []]]).



draw_line_odd([Head|Tail]):-
	append([Number|Colour], [A|B], [A|B]) -> write('+');
	write('+---'),
	append([Head|[]], [A|B], [Head, Tail]),
	draw_line_odd([A|B]).

draw_board(X, Y) :-
	draw_board(X, Y, 0).

draw_board2([Head,Tail]) :-
	draw_line_odd(Head).


nesimo(I, L, X):-
    Al is I-1,
    length(A, Al),
    append(A, [X|_], L).

init :- write('_   _   _  _ '),nl,
        write('_  20b 20p _ '),nl,
        write('_   _   _  _ '),nl.

  hardcoded_board_init :-
					 write('+---+---+---+---+'),nl,
                     write('|   |   |   |   |'),nl,
                     write('+---+---+---+---+'),nl,
                     write('|   |20b|20p|   |'),nl,
                     write('+---+---+---+---+'),nl,
                     write('|   |   |   |   |'),nl,
                     write('+---+---+---+---+'),nl.

hardcoded_board_intermediate:- write('+---+---+---+---+---+---+---+'),nl,
                               write('|   |   |   |   |   |   |   |'),nl,
                               write('+---+---+---+---+---+---+---+'),nl,
                               write('|   |   |   |   | 1b| 2p|   |'),nl,
                               write('+---+---+---+---+---+---+---+'),nl,
                               write('|   |   |16b|13p|   |   |   |'),nl,
                               write('+---+---+---+---+---+---+---+'),nl,
                               write('|   | 5p|   |   | 3b|   |   |'),nl,
                               write('+---+---+---+---+---+---+---+'),nl,
                               write('|   |   |   |   |   |   |   |'),nl,
                               write('+---+---+---+---+---+---+---+'),nl.



hardcoded_board_final :-  write('+---+---+---+---+---+---+---+---+---+'),nl,
                          write('|   | _ |   |   |   |   |   |   |   |'),nl,
                          write('+---+---+---+---+---+---+---+---+---+'),nl,
                          write('|   | 2P|   | 1b| 3p|   |   |   |   |'),nl,
                          write('+---+---+---+---+---+---+---+---+---+'),nl,
                          write('|   |   | 4P| 2p| 1b| 3p| 1b|   |   |'),nl,
                          write('+---+---+---+---+---+---+---+---+---+'),nl,
                          write('|   |   |   | 3P| 2b| 2p|   | 3b|   |'),nl,
                          write('+---+---+---+---+---+---+---+---+---+'),nl,
                          write('|   |   |   |   | 1P| 6b| 3b|   |   |'),nl,
                          write('+---+---+---+---+---+---+---+---+---+'),nl,
                          write('|   |   |   |   |   |   | 3b|   |   |'),nl,
                          write('+---+---+---+---+---+---+---+---+---+'),nl,
                          write('|   |   |   |   |   |   |   |   |   |'),nl,
                          write('+---+---+---+---+---+---+---+---+---+'),nl.
*/
