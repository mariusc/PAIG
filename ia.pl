%starea finala, oricand agentul ia un obiect
finala(stare(_,_,_,1)).

%verific daca X,Y sunt pe harta si primesc in Tip ce am la celula respectiva
%onBoard(X,Y,Harta,Tip)
onBoard(_,_,[],_) :- fail.
onBoard(X,Y,[[X,Y,Tip|_]|_],Tip) :- !.
onBoard(X,Y,[_|L],Tip) :- onBoard(X,Y,L,Tip).

%imi intoarce in Obiect 1 daca sunt pe obiect, 0 altfel
found(X,Y,[[X,Y,1|_]|_],1) :- !.
found(X,Y,[_|L],Obiect) :- found(X,Y,L,Obiect),!.
found(_,_,_,0).

%incarca harta, deocamdata hardcodata: iaHarta(stfaraharta, stcuharta, harta)
iaHarta(stare(X,Y,_,_), stare(X,Y,Harta,0),Harta).

%starile ilegale: nu sunt pe harta sau vreau sa trec printr-un obstacol
ilegala(stare(X,Y,Harta,_)) :- not(onBoard(X,Y,Harta,_)).
ilegala(stare(X,Y,Harta,_)) :- onBoard(X,Y,Harta,Tip), Tip = -1.


% miscarile: misca(stare, stare, DirXi, DirYi, DirXf, DirYf, Gaurica,GauricaUrm).
%miscare pentru wormhole
misca(stare(X,Y,Harta,0), stare(X1,Y1,Harta,0),_,_,0,0,Gaurica,GauricaUrm) :- onBoard(X,Y,Harta,Tip),
	                                                                      Tip \= 2, Tip \= 1, Tip \= -1, Tip \=0,
									      google(X,Y,X1,Y1,Harta,Tip),
									      Gaurica=1, GauricaUrm is 0, !.
%miscarile pentru gheata
misca(stare(X,Y,Harta,0), stare(X1,Y1,Harta,Val),DirX,DirY,DirX,DirY,_,GauricaUrm) :- onBoard(X,Y,Harta,Tip),
	                                                                              Tip=2,
										      X1 is X+DirX, Y1 is Y+DirY,
										      found(X1,Y1,Harta,Val),
										      GauricaUrm is 1,
										      onBoard(X1,Y1,Harta,Tip1),
										      Tip1 \= -1,!.
%ma opresc pe gheata: am obstacol in fata
misca(stare(X,Y,Harta,0), stare(X1,Y1,Harta,Val),DirX,DirY,DirX,DirY,_,GauricaUrm) :- onBoard(X,Y,Harta,Tip),
	                                                                              Tip=2,
										      X1 is X, Y1 is Y,
										      found(X1,Y1,Harta,Val),
										      GauricaUrm is 1,
										      onBoard(X1,Y1,Harta,Tip1),
										      Tip1 = -1,!.
%miscari normale, fara cazuri speciale
misca(stare(X,Y,Harta,0), stare(X1,Y1,Harta,Val),_,_,1,0,_,GauricaUrm) :- X1 is X+1, Y1 is Y,
	                                                                  found(X1,Y1,Harta,Val),
									  GauricaUrm is 1.
misca(stare(X,Y,Harta,0), stare(X1,Y1,Harta,Val),_,_,0,1,_,GauricaUrm) :- X1 is X, Y1 is Y+1,
	                                                                  found(X1,Y1,Harta,Val),
									  GauricaUrm is 1.
misca(stare(X,Y,Harta,0), stare(X1,Y1,Harta,Val),_,_,-1,0,_,GauricaUrm) :- X1 is X-1, Y1 is Y,
	                                                                   found(X1,Y1,Harta,Val),
									   GauricaUrm is 1.
misca(stare(X,Y,Harta,0), stare(X1,Y1,Harta,Val),_,_,0,-1,_,GauricaUrm) :- X1 is X, Y1 is Y-1,
									   found(X1,Y1,Harta,Val),
									   GauricaUrm is 1.

%google: cauta capatul unui tunel;
%google(Xi,Yi,X,Y,Harta,Val) imi intoarce X si Y din Harta care au Val dat de mine
google(_,_,_,_,[],_) :- fail.
google(Xi,Yi,X,Y,[[X,Y,Val|_]|_],Val) :- Xi \= X; Yi \= Y,!.
google(Xi,Yi,X,Y,[_|L],Val) :- google(Xi,Yi,X,Y,L,Val).

%golesteHarta(Harta1,HartaRev)
golesteHarta([],[]).
golesteHarta([[X,Y,1]|L1],[[X,Y,0]|L2]) :- golesteHarta(L1,L2).
golesteHarta([[X,Y,T]|L1],[[X,Y,T]|L2]) :- golesteHarta(L1,L2).

%pune1(X,Y,Harta,HartaNoua)
pune1(_,_,[],[]).
pune1(X,Y,[[X,Y,_]|L1],[[X,Y,1]|L2]) :- pune1(X,Y,L1,L2).
pune1(X,Y,[S|L],[S|H]) :- pune1(X,Y,L,H).



%ala care misca (bkt-ul) :p
lcv(Stare, [Stare|Vizitate], Vizitate,_,_,1) :- finala(Stare).
lcv(Stare, Solutie, Vizitate,DirX,DirY,Gaurica) :- misca(Stare, StareUrm, DirX,DirY,DirXUrm,DirYUrm,Gaurica,GauricaUrm),
	                                           not(ilegala(StareUrm)),
				                   not(member(StareUrm, [Stare|Vizitate])),
						   lcv(StareUrm, Solutie, [Stare|Vizitate],DirXUrm,DirYUrm,GauricaUrm).

rezolva(X,Y,Harta,Harta2,Solutie,Solutie2) :- lcv(stare(X,Y,Harta,0),Solutie, [],0,0,1),
	                                      prim(Solutie,SI),
					      golesteHarta(Harta,HartaGoala),
					      pune1(X,Y,HartaGoala,HartaNoua),
					      iaHarta(SI,StareInitiala,HartaNoua),
					      modificaHarta(Harta,SI,Harta2),
					      lcv(StareInitiala,Solutie2,[],0,0,1).

%sterge obiectul proaspat gasit de pe harta
modificaHarta([],_,[]).
modificaHarta([[X,Y,_]|R],stare(X,Y,_,_),[[X,Y,0]|R]) :- !.
modificaHarta([Q|R], S, [Q|L]) :- modificaHarta(R, S, L).

afis([]) :- nl. % newline
afis([X|R]) :- write(X), nl, afis(R).

%pune 1 in loc de 0 si invers la intoarcere
trim([],[]).
trim([stare(X,Y,H,0)|L],[stare(X,Y,H,1)|L2]) :- trim(L,L2).
trim([stare(X,Y,H,1)|L],[stare(X,Y,H,0)|L2]) :- trim(L,L2).


%construiesteRez(Rez,Rezultat)
construiesteRez([stare(X,Y,H,O)|L],[[X,Y,T,O]|L2]) :- onBoard(X,Y,H,T),construiesteRez(L,L2).
construiesteRez([],[]).


%aranjeaza(Rez1,RezBun)
aranjeaza([],[]).
aranjeaza([[X,Y,1,O]|L],[[X,Y,0,O]|L]).
go([X,Y],Harta,HartaRez,Rezultat) :- rezolva(X,Y,Harta,HartaRez,L1,L2),
	                             trim(L2,Lista),
				     reverse(Lista,[],[_|LI]),
				     reverse(LI,[],BLA),
				     append(BLA,L1,Rez),
				     construiesteRez(Rez,Rez2),
				     aranjeaza(Rez2,RezInv),
				     reverse(RezInv,[],Rezultat).
tema12(_,_,0,[],_).
tema12([X,Y],Harta,1,Rezultat,1) :- go([X,Y],Harta,_,Rezultat),
	                            afis(Rezultat).
tema12([X,Y],Harta,N,Rezultat,0) :- go([X,Y],Harta,HartaRez,Rezultat1),
                                    N1 is N-1,
	                            tema12([X,Y],HartaRez,N1,Rezultat2,0),
				    rest(Rezultat2,Rezultat21),
				    append(Rezultat1, Rezultat21, Rezultat).
tema12([X,Y],Harta,N,Rezultat,1) :- go([X,Y],Harta,HartaRez,Rezultat1),
                                    N1 is N-1,
	                            tema12([X,Y],HartaRez,N1,Rezultat2,1),
                                    afis(Rezultat1),
				    rest(Rezultat1,Rezultat11),
				    append(Rezultat2, Rezultat11, Rezultat).

tema1([X,Y],Harta,N,Rezultat,CL) :- tema12([X,Y],Harta,N,Rezultat,CL),
				    write('REZULTAT:'),
				    nl,
				    afis(Rezultat),!.
prim([E|_],E).
rest([],[]).
rest([_|BLA],BLA).
reverse([X|Y],Z,W) :- reverse(Y,[X|Z],W).
reverse([],X,X).



