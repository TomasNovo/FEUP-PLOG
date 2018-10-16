display_gameStart :- write('Welcome to Knights Line !'), nl, nl.

display_menu :- write('Choose the mode you want to play :'), nl,
                write('1 - Player vs Player '), nl,
                write('2 - Player vs Computer '), nl,
                write('3 - Watch Computer vs Computer '), nl,
                write('4 - Credits '), nl.


gameChoose(X) :- A = 4 -> write('Game developed by : '), nl,
                          write('- Joao Pedro Viveiros Franco'), nl,
                          write('- Tomas Nuno Fernandes Novo'), nl.
                 A = 3 -> write('z').
                 A = 2 -> write('a').

kl :- display_gameStart,
      display_menu, nl,
      write('Input: '),
      read(A),
      gameChoose(A).

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
          nl,
          display_board(W,H1).

draw_line(_, Max, Max).
draw_line(String, Position, Max) :-
        write(String),
        Position1 is Position+1,
        not(not(draw_line(String, Position1, Max))).

draw_board(_, Y, Y).
draw_board(X, Y, Position) :-
	Position1 is Position+1,
	draw_line("_", 0, X),
	nl,
	not(not(draw_board(X, Y, Position1))).



draw_board(X, Y) :-
	draw_board(X, Y, 0).

nesimo(I, L, X):-
    Al is I-1,
    length(A, Al),
    append(A, [X|_], L).

 % +---+---+---+---+---+---+---+---+
 % | r | n | b | q | k | b | n | r |
 % +---+---+---+---+---+---+---+---+
 % | p | p | p | p | p | p | p | p |
 % +---+---+---+---+---+---+---+---+
 % |   |   |   |   |   |   |   |   |
 % +---+---+---+---+---+---+---+---+
 % |   |   |   |   |   |   |   |   |
 % +---+---+---+---+---+---+---+---+
 % |   |   |   |   |   |   |   |   |
 % +---+---+---+---+---+---+---+---+
 % |   |   |   |   |   |   |   |   |
 % +---+---+---+---+---+---+---+---+
 % | P | P | P | P | P | P | P | P |
 % +---+---+---+---+---+---+---+---+
 % | R | N | B | Q | K | B | N | R |
 % +---+---+---+---+---+---+---+---+


% draw_board(X, Y) :-
