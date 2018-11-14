:- consult('logic.pl'), consult('display.pl'), use_module(library(system)).
 
%Start menu
kl :-
	display_gameStart,
	display_options, nl,
	write('Input: '),
	read(A), nl,
	A >= 1, A < 5, 
	gameOptions(A).

%Welcome player
display_gameStart :-
	write('Welcome to Knights Line !'), nl, nl.

%Possible game options
display_options :-
	write('Choose the mode you want to play :'), nl,
	write('1 - Player vs Player '), nl,
	write('2 - Player vs Computer '), nl,
	write('3 - Watch Computer vs Computer '), nl,
	write('4 - Credits '), nl,
	write('5 - Exit'),nl.

gameOptions(1):- write('You selected Player vs Player game !'),nl, nl,
		   		 write('Have a nice game ! '), nl, nl, gameLoop.
gameOptions(2):- select_difficulty_pc.
gameOptions(3):- write('Option 3').
gameOptions(4):- write_credits.
gameOptions(5):- wrong_input, kl.

%Option2 
select_difficulty_pc :- write('You selected Player vs Computer game !'),
							nl, nl, write('Please enter PC difficulty (0 for medium, 1 for hard)'),
							nl, write('Input: '), read(Y),nl,
							pc_difficulty_read(Y).

%Option3
pc_difficulty_read(0) :- write('Difficulty Medium setted !'),nl.
pc_difficulty_read(1) :- write('Difficulty Hard setted !').

%Option4 
write_credits :- (write('Game developed by : '), nl,
				  write('- Joao Pedro Viveiros Franco'), nl,
				  write('- Tomas Nuno Fernandes Novo'), nl,nl).
 
%Option5
wrong_input :- write('You have picked an invalid option !'),
				nl, nl,  write('Please, input again !'),nl,nl.



moveBot(Board,I,NewBoard) :-
	printBoard(Board,nl),
	P is mod(I,2),
	P = 0 -> 
		write('Whites playing !'),nl,
		botMove(Board,'w',NewBoard);
	P = 1 -> write('Blacks playing !'),nl, botMove(Board,'b',NewBoard).

botMove(Board, Colour, NewBoard):-
	getBotMoves(Board, Colour, Moves),
	length(Moves, MovesLength),
	random(0, MovesLength, RandomIndex),
	nth0(RandomIndex, Moves, Move),
	nth0(0, Move, Piece1),
	nth0(0, Piece1, X1),
	nth0(1, Piece1, Y1),
	nth0(1, Move, Piece2),
	nth0(0, Piece2, X2),
	nth0(1, Piece2, Y2),
	getPiece(Board, X1, Y1, Piece),
	getHeight(Piece, Height),
	random(0, Height, RandomHeight),
	makeMove(Board, X1, Y1, X2, Y2, RandomHeight, NewBoard).

botMove2(Board, X1, Y1, Position, Moves, Height, NewBoard):-
	nth0(Position, Moves, Move),
	nth0(0, Move, X2),
	nth0(1, Move, Y2),
	random(0, Height, RandomHeight),
	makeMove(Board, X1, Y1, X2, Y2, N, NewBoard).




invalidInput(Message, Board, I, Colour, NewBoard):-
	write(Message),nl, playerMove(Board, Colour, NewBoard).

invalidInput2(Message, Board, I, NewBoard):-
	write(Message),nl, movePrompt(Board, I, NewBoard).


%Moves piece
movePrompt(Board, I, NewBoard, 0):- 
	write('Whites playing:'),nl,
	( playerMove(Board,'w', NewBoard) ; invalidInput2('Invalid input!', Board, I, NewBoard)).

movePrompt(Board, I, NewBoard, 1):- 
	write('Blacks playing:'),nl,
	( playerMove(Board,'b', NewBoard) ; invalidInput2('Invalid input!', Board, I, NewBoard)).

movePrompt(Board, I, NewBoard) :-
	printBoard(Board),nl,
	P is mod(I, 2),
	movePrompt(Board, I, NewBoard, P).


playerMove(Board, Colour, NewBoard):-
	nl,nl,write('Choose a stack to move (X,Y) : '),nl,
	read(X),nl,
	read(Y),nl,
	getPiece(Board, X, Y, Piece) ->(
		getColour(Piece, PieceColour),
		(Colour = PieceColour  -> 
			playerMove2(Board, X, Y, NewBoard);
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

%Alphabet letters
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

gameBotVsBot:-
	write('Game Starting in: 3'),nl,
	sleep(1),
	write('Game Starting in: 2'),nl,
	sleep(1),
	write('Game Starting in: 1'),nl,
	sleep(1),
	I is 0,
	initialBoard(Board),
	gameLoopBotVsBot(Board,I).

gameLoopBotVsBot(Board,I):-
	P is mod(I,2),
	(P = 0 -> write('Whites playing '), I1 is I+1,gameLoopBotVsBot(Board,I1);
	(P \= 0-> write('Blacks playing '), I1 is I+1,gameLoopBotVsBot(Board,I1))).