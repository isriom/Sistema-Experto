%Hechos
pistas(p1,p2-1,p2-2,p3).
pista(p1,1,peque�as).

aviones(["Embraer Phenom","Beechcraft","Cessna","Boing717","Embraer 190","Air Bus A220","Boing 747","AirBus A340","AirBus A380"]).
%operaciones de lista
cabeza([X|_],X).

concatenar([],B,B).
concatenar([L1|RESTO1],L2,[L1|L3]):-concatenar(RESTO1,L2,L3).

miembro(X,[X|_]).
miembro(X,[_|L]):-miembro(X,L).


%BNF
%
%S0:
oracion(S0,S,[M|D]):- sintagma_nominal(P,S0,S1,M),sintagma_verbal(P,S1,S,D).
oracion(S0,S,Z):- sintagma_preposicional(P,S0,S1,M),sintagma_verbal(P,S1,S,D),concatenar(M,D,Z).
oracion(S0,S,Z):- sintagma_verbal(P,S0,S1,D),sintagma_preposicional(P,S1,S,M),concatenar(M,D,Z).


sintagma_nominal(P,S0,S,M):- determinante(P,S0,S1),nombre(P,S1,S),cabeza(S1,M).

sintagma_preposicional(P,S0,S,[F,M,D]):- enlace(P,S0,S1,D),sintagma_nominal(_,S1,S,M),cabeza(S0,F).
sintagma_preposicional(P,S0,S,D):- enlace(P,S0,S,D).

enlace(P,S0,S,M):- preposicion(P,S0,S1),infinitivo(P,S1,S),cabeza(S1,M).


sintagma_verbal(P,S0,S,S0):- verbo(P,S0,S).
sintagma_verbal(P,S0,S,[F,M]):- verbo(P,S0,S1),sintagma_nominal(_,S1,S,M),cabeza(S0,F).
sintagma_verbal(P,S0,S,[F,M]):- verbo(P,S0,S1),sintagma_preposicional(_,S1,S,M),cabeza(S0,F).



%Lenguaje natural

determinante([singular,masculino,_],[el|S],S).
determinante([singular,femenino,_],[la|S],S).
determinante([plural,femenino,_],[las|S],S).


preposicion([_,_,_],[para|S],S).

infinitivo([_,_,_],[despegar|S],S).
infinitivo([_,_,_],[aterrizar|S],S).

nombre([singular,masculino,_],[N|S],S):-aviones(X),miembro(N,X).
nombre([singular,masculino,_],["permiso"|S],S).


verbo([singular,_,_],[solicito|S],S).
verbo([singular,_,1],[quiero|S],S).
verbo([singular,_,1],[perd�|S],S).



