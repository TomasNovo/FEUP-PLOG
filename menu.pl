:- consult('logic.pl'), consult('display.pl').

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
			gameLoop );
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

movePrompt(Board, I, NewBoard) :-
	printBoard(Board),nl,
	P is mod(I, 2),
	P = 0 -> 
		write('Whites playing:'),nl,
		(playerMove(Board, I, 'w', NewBoard) -> 
			true;

			invalidInput2('Invalid input!', Board, I, NewBoard));
	(P = 1 ->
		write('Blacks playing:'),nl,
		(playerMove(Board, I, 'b', NewBoard) -> 
			true;

			invalidInput2('Invalid input!', Board, I, NewBoard))).


invalidInput(Message, Board, I, Colour, NewBoard):-
	write(Message),nl, playerMove(Board, I, Colour, NewBoard).

invalidInput2(Message, Board, I, NewBoard):-
	write(Message),nl, movePrompt(Board, I, NewBoard).


playerMove(Board, Colour, NewBoard):-
	nl,nl,write('Choose a stack to move (X,Y) : '),nl,
	read(X),nl,
	read(Y),nl,
	getPiece(Board, X, Y, Piece) ->(
		getColour(Piece, PieceColour),
		(Colour = PieceColour  -> 
			playerMove2(Board, I, X, Y, NewBoard);
		(PieceColour = '' ->
				invalidInput('There is no piece at those coordinates!', Board, I, Colour, NewBoard);

				invalidInput('That piece belongs to the other player!', Board, I, Colour, NewBoard))));

	invalidInput('Invalid input', Board, I, Colour, NewBoard).

playerMove2(Board, X1, Y1, NewBoard):-
	getPieceMoves(Board, X1, Y1, Moves),
	showMoves(Board, Moves, BoardWithLetters),
	printBoard(BoardWithLetters),nl,
	write('Choose a position letter (or write 0 to cancel):'),nl,
	read(P),
	letter(P, Position),
	playerMove3(Board, X1, Y1, Position, Moves, NewBoard) -> 
		true;
%% else	
		write('Incorrect input!'),nl,
		playerMove2(Board, X1, Y1, NewBoard).

playerMove3(Board, X1, Y1, Position, Moves, NewBoard):-
	nth0(Position, Moves, Move),
	nth0(0, Move, X2),
	nth0(1, Move, Y2),
	write('Choose the number of pieces to move:'),nl,
	read(N),
	makeMove(Board, X1, Y1, X2, Y2, N, NewBoard).

letter('A', 0).
letter('B', 1).
letter('C', 2).
letter('D', 3).
letter('E', 4).
letter('F', 5).
letter('G', 6).
letter('H', 7).

getLetter(I):-
	I is Position.

gameLoop:-
	I is 0,
	initialBoard(Board),
	gameLoop(Board, I).

gameLoop(Board, I):-
	movePrompt(Board, I, NewBoard),
	I1 is I+1,
	gameLoop(NewBoard, I1).

gameLoopBot:-
	I is 0,
	initialBoard(Board),
	gameLoopBot(Board, I).

gameLoopPlayerVsBot(Board, I):-
	P is mod(I, 2),
	(P = 0 ->
		movePrompt(Board, I, NewBoard),
		I1 is I+1,
		gameLoopPlayerVsBot(NewBoard, I1);
	(P = 1 ->
		movePrompt(Board, I, NewBoard),
		I1 is I+1,
		gameLoopPlayerVsBot(NewBoard, I1))).
	


moveBot(Board, P, NewBoard):-
	getPieces(Board, Player, Pieces).