:- use_module(library(clpfd)).


cars(Colours):-
	length(Sizes, 4),
	domain(Sizes, 1, 4),
	all_different(Sizes),

	length(Colours, 4),
	domain(Colours, 1, 4),
	Yellow=1, Green=2, Blue=3, Black=4,
	all_different(Colours),

	element(BluePos, Colours, Blue),
	BeforeBluePos #= BluePos-1,
	AfterBluePos #= BluePos+1,
	element(BeforeBluePos, Sizes, BeforeBlueSize),
	element(AfterBluePos, Sizes, AfterBlueSize),
	BeforeBlueSize #< AfterBlueSize,

	element(GreenPos, Colours, Green),
	element(GreenPos, Sizes, 1),
	GreenPos #> BluePos,

	element(BlackPos, Colours, Black),
	element(YellowPos, Colours, Yellow),
	YellowPos #> BlackPos,


	labeling([], Colours).


triplets([A,B,C|T]):-
	all_different([A,B,C]),
	triplets([B,C|T]).
triplets([_,_]).

quadruplets(List, Count):-
	quadruplets(List, 0, Count), !.

quadruplets([_, _, _], Count, Count).
quadruplets([A,B,C,D|T], Count, Count2):-
	(A #= 1 #/\ B #= 2 #/\ C #= 3 #/\ D #= 4) #<=> X,
	NewCount #= Count+X,
	quadruplets([B,C,D|T], NewCount, Count2).



cars2(L):-
	length(L, 12),
	domain(L, 1, 4),
	global_cardinality(L, [1-4, 2-2, 3-3, 4-3]),
	
	element(1, L, X),
	element(12, L, X),
	element(2, L, Y),
	element(11, L, Y),

	element(5, L, 4),

	triplets(L),

	quadruplets(L, 1),

	%% Count #= 1,

	labeling([], L).