:- consult('logic.pl'), consult('display.pl'), use_module(library(system)), use_module(library(random)).

%%%%%%%%
% MENU %
%%%%%%%%

%Starts menu and reads option
kl :-
	clear_console(60),
	display_gameStart,
	display_options, nl,nl,nl,
	write('Pick your option by writing its number !'),
	nl,nl,
	read(A), nl, 
	gameOptions(A).

%Welcomes player
display_gameStart :-
	write('Welcome to Knights Line !'), nl, nl.

%Displays possible game options
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

%Sets option
gameOptions(1):- clear_console(60),
				 write('You selected Player vs Player game !'),nl, nl,
				 write('Instructions: '), nl,nl,
				 write('- Enter the X and Y of the stack you want to move.'),nl,
				 write('- Enter the letter of the move you can make according to the possibilities.'), nl,
				 write('  Enter it in CAPS LOCK and bewtween '' '' '), nl,
				 write('- On the first play, whites can only move one piece'),nl,nl,nl,nl,nl,nl,nl,nl,
				 %sleep(5), clear_console(60),
		   		 write('Have a nice game ! '), nl,nl,nl,nl,nl,nl,nl,nl,nl, 
		   		 %countdown, 
		   		 nl, nl, clear_console(60), gameLoop.
gameOptions(2):- select_difficulty_pc.
gameOptions(3):- write('Option 3').
gameOptions(4):- write_credits.
gameOptions(5):- true.
gameOptions(N):- kl.


%Sets difficulty of computer player
select_difficulty_pc :- write('You selected Player vs Computer game !'),
							nl, nl, write('Please enter PC difficulty (0 for medium, 1 for hard)'),
							nl, read(Y),nl, clear_console(60),
							pc_difficulty_read(Y).

pc_difficulty_read(0) :- write('Difficulty Medium setted !'), gameLoopPlayervsBot,nl.
pc_difficulty_read(1) :- write('Difficulty Hard setted !').

%Displays credits of the game 
write_credits :- (write('Game developed by : '), nl,
				  write('- Joao Pedro Viveiros Franco'), nl,
				  write('- Tomas Nuno Fernandes Novo'), nl,nl).

%countdown for game to start
countdown :-write('Game Starting in: 3'),nl,
	sleep(1),
	write('Game Starting in: 2'),nl,
	sleep(1),
	write('Game Starting in: 1'),nl,
	sleep(1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 

%%%%%%%%%%%%%%%%%
% Bot functions %
%%%%%%%%%%%%%%%%%

%Makes a move for computer player
% moveBot -> Makes a move for computer player according to colour and play number
% botMove -> Executes the move
moveBot(Board, I, NewBoard) :-
	printBoard(Board), nl,
	P is mod(I, 2),
	moveBot(Board, I, P, NewBoard).

moveBot(Board, I, 0, NewBoard):- 
	write('Whites playing !'),nl,
	botMove(Board, 'w' ,NewBoard).

moveBot(Board, I, 1, NewBoard):-  
	write('Blacks playing !'),nl,
	botMove(Board, 'b', NewBoard).

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%
%  Player functions  %
%%%%%%%%%%%%%%%%%%%%%%

%Moves piece according to play number and colour, handling eventual incorrect inputs
movePrompt(Board, I, NewBoard) :-
	printBoard(Board),nl,
	P is mod(I, 2),
	movePrompt(Board, I, NewBoard, P).

movePrompt(Board, I, NewBoard, 0):- 
	write('Whites playing:'),nl,
	( playerMove(Board,'w', I, NewBoard) ; invalidInput2('Invalid input!', Board, I, NewBoard)).

movePrompt(Board, I, NewBoard, 1):- 
	write('Blacks playing:'),nl,
	( playerMove(Board,'b', I, NewBoard) ; invalidInput2('Invalid input!', Board, I, NewBoard)).


%Makes the move of movePrompt, making test to check colour, possible plays and error inputs
% playerMove -> Chooses the stack to move by reading its (X,Y) coordinates
% playerMoveAux -> Handles inputs, checking invalid coordinates, nonexistent or not owned pieces , wrong colours
%					and checks if the stack only has one piece , disallowing the move
% playerMove2 -> Displays possible movement options and chooses it , handling incorrect letter input and allowing
%				 the user to return to the stack selector if he want to move another piece
% playerMove3 -> Moves the number of pieces inputed by the user,  allowing the user to return 
%				 to the stack selector if he want to move another piece
playerMove(Board, Colour, I, NewBoard):-
	nl,nl,write('Choose a stack to move (X,Y) : '),nl,
	read(X),nl,
	read(Y),nl,
	playerMove(Board, Colour, X, Y, I, NewBoard).

playerMove(Board, Colour, X, Y, I, NewBoard):-
	getPiece(Board, X, Y, Piece),
	playerMove(Board, X, Y, Piece, Colour, I, NewBoard).

playerMove(Board, Colour, X, Y, I, NewBoard):-
	invalidInput('Invalid input', Board, Colour, I, NewBoard).

playerMove(Board, X, Y, Piece, Colour, I, NewBoard):- 
	getColour(Piece, PieceColour), 
	playerMoveAux(Board, X, Y, Colour, I, NewBoard, Piece, PieceColour).


playerMoveAux(Board, X, Y, Colour, I, NewBoard, Piece, PieceColour):- 
	PieceColour = '',
	invalidInput('There is no piece at those coordinates!', Board, Colour, I, NewBoard).

playerMoveAux(Board, X, Y, Colour, I, NewBoard, Piece, PieceColour):- 
	getHeight(Piece, Height),
	Height = 1,
	invalidInput('The stack must have more than one piece!', Board, Colour, I, NewBoard).

playerMoveAux(Board, X, Y, Colour, I, NewBoard, Piece, PieceColour):- 
	Colour = PieceColour,
	playerMove2(Board, Colour, X, Y, I, NewBoard).

playerMoveAux(Board, X, Y, Colour, I, NewBoard, Piece, PieceColour):- 
	PieceColour \= '',
	invalidInput('That piece belongs to the other player!', Board, Colour, I, NewBoard).


playerMove2(Board, Colour, X1, Y1, I, NewBoard):-
	valid_moves(Board, X1, Y1, Moves),
	showMoves(Board, Moves, BoardWithLetters),
	printBoard(BoardWithLetters),nl,
	write('Choose a position letter (or write ''Z'' to cancel):'),nl,
	read(P),
	(P = 'Z', printBoard(Board), playerMove(Board, Colour, I, NewBoard) ;
		(letter(P, Position), 
			(playerMove3(Board, Colour, X1, Y1, Position, Moves, I, NewBoard);
			(write('Incorrect input!'),nl, playerMove2(Board, Colour, X1, Y1, I, NewBoard))))).

playerMove3(Board, Colour, X1, Y1, Position, Moves, I, NewBoard):-
	I \= 0,
	nth0(Position, Moves, Move),
	nth0(0, Move, X2),
	nth0(1, Move, Y2),
	write('Choose the number of pieces to move (or write ''Z'' to cancel):'),nl,
	read(N),
	(P = 'Z', printBoard(Board), playerMove(Board, Colour, I, NewBoard);
	(makeMove(Board, X1, Y1, X2, Y2, N, NewBoard))).

playerMove3(Board, Colour, X1, Y1, Position, Moves, I, NewBoard):-
	I = 0,
	nth0(Position, Moves, Move),
	nth0(0, Move, X2),
	nth0(1, Move, Y2),
	makeMove(Board, X1, Y1, X2, Y2, 1, NewBoard).


%Alphabet letters for playerMove2 
letter('A', 0).
letter('B', 1).
letter('C', 2).
letter('D', 3).
letter('E', 4).
letter('F', 5).
letter('G', 6).
letter('H', 7).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%
% GAME %
%%%%%%%%

%gameLoop - Loop of the Player vs Player game according to number of plays
%gameLoopPlayervsBot - Loop of the Player Vs Computer game according to number of plays
%gameLoopBotVsBot - Loop of the Computer Vs Computer game according to number of plays

gameLoop:-
	write('KNIGHT LINE '), nl,nl,nl,
	I is 0,
	initialBoard(Board),
	gameLoop(Board, I).

gameLoop(Board, I):-
	movePrompt(Board, I, NewBoard),
	I1 is I+1,
	gameLoop(NewBoard, I1).

gameLoopPlayervsBot:-
	I is 0,
	initialBoard(Board),
	gameLoopPlayervsBot(Board, I).

gameLoopPlayervsBot(Board, I):-
 	P is mod(I, 2),
 	gameLoopPlayervsBot(Board, I, P, NewBoard),

 	I1 is I+1,
	gameLoopPlayervsBot(NewBoard, I1).

gameLoopPlayervsBot(Board, I, 0, NewBoard):-
	movePrompt(Board, I, NewBoard).

gameLoopPlayervsBot(Board, I, 1, NewBoard):-
	moveBot(Board, I, NewBoard).	
	

gameBotVsBot:-
	countdown,
	I is 0,
	initialBoard(Board),
	gameLoopBotVsBot(Board,I).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%
% Input handling %
%%%%%%%%%%%%%%%%%%

%Handles incorrect inputs during game
invalidInput(Message, Board, Colour, I, NewBoard):-
	write(Message),nl, playerMove(Board, Colour, I, NewBoard).

invalidInput2(Message, Board, I, NewBoard):-
	write(Message),nl, movePrompt(Board, I, NewBoard).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
