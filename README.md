# FEUP PLOG 2018/19

Programming in Prolog with and without restrictions for PLOG 2018/2019 at FEUP.


## 1.	Knight's Line

The 1st project of PLOG was to implement a board game with Prolog language.
Knight's Line is a game that involves Chess and Four in a Row.
The game starts with two (black and white) stacks of 20 pieces. 
User can move the stacks but always has to leave 1 piece behind. 
The stack can only me moved in L and has to have another stack adjacent to it.
It will win the color that has 4 adjacent pieces in four adjacent tiles in any direction.


• Using the interface, the user can choose the type of game he wants to play.
![Menu](https://github.com/TomasNovo/FEUP-PLOG1819/blob/master/Part1/images%20md/menu.png)  
  
  
    
      
• User can play versus another player, versus a bot or watch two bots play.
Instructions to play: 
![Instructions](https://github.com/TomasNovo/FEUP-PLOG1819/blob/master/Part1/images%20md/instructions.png)   
  
    
      
        
• The game starts with the two adjacent stacks and user inputs the X and Y of 
the stack that he wants to move. But on the 1st move, **user can only move 1 piece**.

![PlayOne](https://github.com/TomasNovo/FEUP-PLOG1819/blob/master/Part1/images%20md/1st%20play.png)   
    
    
  


• After choosing the stack, letters that show possible moves will appear and user
has to input the move like for example: 'A'.

![PlayMove](https://github.com/TomasNovo/FEUP-PLOG1819/blob/master/Part1/images%20md/1st%20move.png)  
      
        
    
  


• After the input, the stack will move to the inputed tile.

![PlayDone](https://github.com/TomasNovo/FEUP-PLOG1819/blob/master/Part1/images%20md/1st%20done.png)  
  
    
    
  

• On following plays, users have to choose the number of pieces of the stack they want to move.  
![MoveMore](https://github.com/TomasNovo/FEUP-PLOG1819/blob/master/Part1/images%20md/MoveMore.png)  
  

• After the input, the pieces are moved to desired tile.  
![Donee](https://github.com/TomasNovo/FEUP-PLOG1819/blob/master/Part1/images%20md/Done.png)  
  
    
    
  

## 2.	Outside Sudoku

In the 2nd project of PLOG, we had to implement a game applying restrictions. We
choosed Outside Sudoku. 
This game is similar to the traditional Sudoku game but it has no hints on the inside. 
The hints are outside the board. They are numbers, and there can be one to three numbers per
row or column. These numbers adjacent to a column or row say that those numbers appear on the first three cells.  
For example: 

![Empty](https://github.com/TomasNovo/FEUP-PLOG1819/blob/master/Part2/imagens%20md/empty.png)

In the first column, we see "3 4 5" and that means that on that direction, the first three cells contain that numbers, he just dont know which one, and that is the purpose of this project: **to solve the game applying restrictions**.

![Filled](https://github.com/TomasNovo/FEUP-PLOG1819/blob/master/Part2/imagens%20md/filled.png)  

User can change the hints by creating new list of lists containing the hints.

