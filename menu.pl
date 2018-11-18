:- consult('logic.pl'), consult('bot.pl'), consult('display.pl'), use_module(library(system)).

%%%%%%%%
% MENU %
%%%%%%%%

% Starts menu and reads option
kl :-
	clear_console(60),
	display_gameStart,
	display_options, nl,nl,nl,nl,nl,
	write('Input: '),
	read(A), nl, 
	gameOptions(A).

% Welcomes player
display_gameStart :-
	write('Welcome to Knights Line !'), nl, nl.

% Displays possible game options
display_options :-
	write('+--------------------------------------+'), nl,
	write('| '),write('Choose the mode you want to play :   |'), nl,
	write('|--------------------------------------|'), nl,
	write('| '),write('1 - Player vs Player                 |'), nl, 
	write('|--------------------------------------|'), nl,
	write('| '),write('2 - Player vs Computer               |'), nl,
	write('|--------------------------------------|'), nl,
	write('| '),write('3 - Watch Computer vs Computer       |'), nl,
	write('|--------------------------------------|'), nl,
	write('| '),write('4 - Credits                          |'), nl,
	write('|--------------------------------------|'), nl,
	write('| '),write('5 - Exit                             |'), nl,
	write('+--------------------------------------+').
  
% Sets option
gameOptions(1):- clear_console(60),
				 write('You selected Player vs Player game !'),nl, nl,
				 write('Instructions: '), nl,nl,
				 write('- Enter the X and Y of the stack you want to move.'),nl,
				 write('- Enter the letter of the move you can make according to the possibilities.'), nl,
				 write('  Enter it in CAPS LOCK and between '' '' '), nl,nl,nl,nl,nl,nl,nl,nl,nl,
				 %sleep(3), 
				 %clear_console(60),
		   		 write('Have a nice game ! '), nl,nl,nl,nl,nl,nl,nl,nl,nl, 
		   		 %countdown, nl, nl, 
		   		 clear_console(60), gameLoop.
gameOptions(2):- gameLoopPlayerVsBot.
gameOptions(3):- gameLoopBotVsBot.
gameOptions(4):- write_credits.
gameOptions(5):- true.
gameOptions(_):- write('Wrong input, please input again !'), kl.

% Sets difficulty of Computer player
select_difficulty_pc :- write('You selected Player vs Computer game !'),
							nl, nl, write('Please enter PC difficulty (0 for medium, 1 for hard)'),
							nl, write('Input: '), read(Y),nl,
							pc_difficulty_read(Y).

pc_difficulty_read(0) :- write('Difficulty Medium setted !'),nl.
pc_difficulty_read(1) :- write('Difficulty Hard setted !').

% Displays credits of the game 
write_credits :- (write('Game developed by : '), nl,
				  write('- Joao Pedro Viveiros Franco'), nl,
				  write('- Tomas Nuno Fernandes Novo'), nl,nl).

gameOverMenu('w'):-
	write('Whites won!'),nl,
	write('Write 1 to go back to the Main Menu or 0 to exit.'),nl,
	read(Option),
	gameOverOption(Option).

gameOverMenu('b'):-
	write('Blacks won!'),nl,
	write('Write 1 to go back to the Main Menu or 0 to exit.'),nl,
	read(Option),
	gameOverOption(Option).


gameOverOption(0):-
	true.
gameOverOption(1):-
	kl.
gameOverOption(Option):-
	Option \= 0,
	Option \= 1,
	write('Invalid input'),nl,nl,
	read(Option2),
	gameOverOption(Option2).


% countdown fort game to start
countdown :-write('Game Starting in: 3'),nl,
	sleep(1),
	write('Game Starting in: 2'),nl,
	sleep(1),
	write('Game Starting in: 1'),nl,
	sleep(1). 




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%
%  Player functions  %
%%%%%%%%%%%%%%%%%%%%%%


%Moves piece
movePrompt(Board, I, NewBoard) :-
	P is mod(I, 2),
	movePrompt(Board, I, NewBoard, P).

movePrompt(Board, I, NewBoard, 0):- 
	write('Whites playing:'),nl,
	( playerMove(Board,'w', I, NewBoard) ; invalidInput2('Invalid input!', Board, I, NewBoard)).

movePrompt(Board, I, NewBoard, 1):- 
	write('Blacks playing:'),nl,
	( playerMove(Board,'b', I, NewBoard) ; invalidInput2('Invalid input!', Board, I, NewBoard)).


% Makes the move of movePrompt, making test to check colour, possible plays and error inputs
%  playerMove -> Chooses the stack to move by reading its (X,Y) coordinates
%  playerMoveAux -> Handles inputs, checking invalid coordinates, nonexistent or not owned pieces , wrong colours
%					and checks if the stack only has one piece , disallowing the move
%  playerMove2 -> Displays possible movement options and chooses it , handling incorrect letter input and allowing
%				  the user to return to the stack selector if he want to move another piece
%  playerMove3 -> Moves the number of pieces inputed by the user,  allowing the user to return 
%				  to the stack selector if he want to move another piece

playerMove(Board, Colour, _, NewBoard):-
	valid_moves(Board, Colour, Moves),
	Moves = [],
	write('No moves are possible, skipping this turn'),nl,nl,
	move([], Board, 0, NewBoard). %% Doesn't move

playerMove(Board, Colour, I, NewBoard):-
	nl,nl,write('Choose a stack to move (X,Y) : '),nl,
	read(X),nl,
	read(Y),nl,
	playerMove(Board, Colour, X, Y, I, NewBoard).


playerMove(Board, Colour, X, Y, I, NewBoard):-
	getPiece(Board, X, Y, Piece),
	playerMove(Board, X, Y, Piece, Colour, I, NewBoard).

playerMove(Board, Colour, _, _, I, NewBoard):-
	invalidInput('Invalid input', Board, Colour, I, NewBoard).

playerMove(Board, X, Y, Piece, Colour, I, NewBoard):- 
	getColour(Piece, PieceColour), 
	playerMoveAux(Board, X, Y, Colour, I, NewBoard, Piece, PieceColour).


playerMoveAux(Board, _, _, Colour, I, NewBoard, _, PieceColour):- 
	PieceColour \= '',
	PieceColour \= Colour,
	invalidInput('That piece belongs to the other player!', Board, Colour, I, NewBoard).

playerMoveAux(Board, _, _, Colour, I, NewBoard, _, PieceColour):- 
	PieceColour = '',
	invalidInput('There is no piece at those coordinates!', Board, Colour, I, NewBoard).

playerMoveAux(Board, _, _, Colour, I, NewBoard, Piece, _):- 
	getHeight(Piece, Height),
	Height = 1,
	invalidInput('The stack must have more than one piece!', Board, Colour, I, NewBoard).

playerMoveAux(Board, X, Y, Colour, I, NewBoard, _, _):- 
	getPieceMoves(Board, X, Y, Moves),
	Moves = [],
	invalidInput('That piece has no possible moves!', Board, Colour, I, NewBoard).


playerMoveAux(Board, X, Y, Colour, I, NewBoard, _, PieceColour):- 
	Colour = PieceColour,

	playerMove2(Board, Colour, X, Y, I, NewBoard).



playerMove2(Board, Colour, X1, Y1, I, NewBoard):-
	getPieceMoves(Board, X1, Y1, Moves),
	showMoves(Board, Moves, BoardWithLetters),
	printBoard(BoardWithLetters),nl,
	write('Choose a position letter (or write ''Z'' to return to stack selector):'),nl,
	read(P), 
	( (letter(P, Position), playerMove3(Board, Colour, X1, Y1, Position, Moves, I, NewBoard));
			(P = 'Z', movePrompt(Board, I, NewBoard));
			write('Incorrect input!'),nl,
			playerMove2(Board, Colour, X1, Y1, I, NewBoard)).
	

playerMove3(Board, _, X1, Y1, Position, Moves, I, NewBoard):-
	I \= 0,
	nth0(Position, Moves, Move),
	nth0(0, Move, X2),
	nth0(1, Move, Y2),
	write('Choose the number of pieces to move (or write ''Z'' to return to stack selector):'),nl,
	read(N),
	((N = 'Z', movePrompt(Board, I, NewBoard));
	move(Board, X1, Y1, X2, Y2, N, NewBoard)).
			
playerMove3(Board, _, X1, Y1, Position, Moves, I, NewBoard):-
	I = 0,
	nth0(Position, Moves, Move),
	nth0(0, Move, X2),
	nth0(1, Move, Y2),
	move(Board, X1, Y1, X2, Y2, 1, NewBoard).

%Alphabet letters
letter('A', 0).
letter('B', 1).
letter('C', 2).
letter('D', 3).
letter('E', 4).
letter('F', 5).
letter('G', 6).
letter('H', 7).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%
% GAME %
%%%%%%%%

%gameLoop - Loop of the Player vs Player game according to number of plays
%gameLoopPlayervsBot - Loop of the Player Vs Computer game according to number of plays
%gameLoopBotVsBot - Loop of the Computer Vs Computer game according to number of plays

gameLoop:-
	I is 0,
	initialBoard(Board),
	gameLoop(Board, I).

gameLoop(Board, I):-
	printBoard(Board),nl,

 	gameLoop2(Board, I).

gameLoop2(Board, _):-
	checkGameOver(Board).

gameLoop2(Board, I):-
	movePrompt(Board, I, NewBoard),
	I1 is I+1,
	gameLoop(NewBoard, I1).

gameLoopPlayerVsBot:-
	I is 0,
	initialBoard(Board),
	setDifficulty(Difficulty),
	gameLoopPlayerVsBot(Board, Difficulty, I).

gameLoopPlayerVsBot(Board, Difficulty, I):-
	printBoard(Board),nl,

 	gameLoopPlayerVsBot2(Board, Difficulty, I).

gameLoopPlayerVsBot2(Board, _, _):-
	checkGameOver(Board).

gameLoopPlayerVsBot2(Board, Difficulty, I):-
	P is mod(I, 2),
 	gameLoopPlayerVsBot(Board, I, P, Difficulty, NewBoard),

 	I1 is I+1,
	gameLoopPlayerVsBot(NewBoard, Difficulty, I1).	

gameLoopPlayerVsBot(Board, I, 0, _, NewBoard):-
	movePrompt(Board, I, NewBoard).

gameLoopPlayerVsBot(Board, I, 1, _, NewBoard):-
	sleep(2),
	moveBot(Board, I, 2, NewBoard).	
	
gameLoopBotVsBot:-
	I is 0,
	initialBoard(Board),
	setDifficulty(Difficulty),
	gameLoopBotVsBot(Board, Difficulty, I).

gameLoopBotVsBot(Board, Difficulty, I):-
	printBoard(Board),nl,
 	
 	gameLoopBotVsBot2(Board, Difficulty, I).
 	

gameLoopBotVsBot2(Board, _, _):-
	checkGameOver(Board).

gameLoopBotVsBot2(Board, Difficulty, I):-	
	sleep(2),
 	moveBot(Board, I, Difficulty, NewBoard),

	I1 is I+1,
	gameLoopBotVsBot(NewBoard, Difficulty, I1).	

checkGameOver(Board):-
	game_over(Board, Winner),
	gameOverMenu(Winner).

setDifficulty(Difficulty):-
	write('Choose a difficulty:'),nl,
	write('1 - Medium'),nl,
	write('2 - Hard'),nl,nl,
	read(Option),
	setDifficulty2(Option),
	Difficulty = Option.


setDifficulty2(1):-
	true.
setDifficulty2(2):-
	true.
setDifficulty2(Option):-
	Option \= 1,
	Option \= 2,
	write('Invalid input'),nl,nl,
	read(Option2),
	setDifficulty2(Option2).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%
% Input handling %
%%%%%%%%%%%%%%%%%%

% Handles incorrect inputs during game
invalidInput(Message, Board, Colour, I, NewBoard):-
	write(Message),nl, playerMove(Board, Colour, I, NewBoard).
 invalidInput2(Message, Board, I, NewBoard):-
	write(Message),nl, movePrompt(Board, I, NewBoard).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%