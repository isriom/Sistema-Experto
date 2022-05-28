/*SE Tarea 2 modulo lenguajes
contenido:
  -hechos
    .pistas
      []lista pistas
      ()definiciones
    .aviones
      []lista aviones
      ()definiciones
  -funciones de operacion en listas
    ()cabeza
    ()concatenar
    ()miembro
  -BNF
    .gramatica libre de contexto
      ()Oracion
      ()Sintagma nominal
      ()Sintagma preposicional
      ()Enlace preposicional
      ()Sintagma verbal
    .Lenguaje
      ()determinante
      ()preposicion
      ()infinitivo
      ()sustantivo
      ()verbo
*/

/*Hechos/
*/
pistas(p1,p2_1,p2_2,p3).
pista(p1,_,pequena).
pista(p21,"este",mediana).
pista(p22,"oeste",mediana).
pista(p3,_,grande).

%(tamaño de avion)(tamaño de pista donde puede aterrizar).
proporcion(pequeno,[pequena,mediana,grande]).
proporcion(mediano,[mediana,grande]).
proporcion(grande,[grande]).

puede_aterrizar(PISTA,AVION,DIRECCION):-
	pista(PISTA,DIRECCION,X),
	tamano(AVIONES,Y),
	miembro(AVION, AVIONES),
	proporcion(Y,Z),
	miembro(X,Z).

aviones(["EmbraerPhenom","Beechcraft","Cessna","Boeing717","Embraer190","AirBusA220","Boeing747","AirBusA340","AirBusA380"]).
tamano(["Cessna","Beechcraft","EmbraerPhenom"],pequeno).
tamano(["Boeing717","Embraer190","AirBusA220"],mediano).
tamano(["Boeing747","AirBusA340","AirBusA380"],grande).

emergencias(["Perdida de motor", "Parto en Medio Vuelo", "Paro Cardiaco de Pasajero", "Secuestro","Mayday","MaydayMayday"]).

respuestaemergencias(["Llamar a Bomberos", "Llamar a medico", "Llamar medico", "Llamar a seguridad"]).

condicionesaterrizaje([velocidad_viento,dir_viento,peso_aeronave,velocidad_avion]).

/*operaciones de lista
*/
cabeza([X|_],X).

concatenar([],B,B).
concatenar([L1|RESTO1],L2,[L1|L3]):-concatenar(RESTO1,L2,L3).

miembro(X,[X|_]).
miembro(X,[_|L]):-miembro(X,L).


/*BNF
No Terminales
raiz->oracion

oracion->sintagma_nominal, sintagma_verbal
oracion->sintagma_verbal, sintagma_preposicional
oracion->saludo, oracion
oracion->emergencia
oracion->sintagma_nominal
oracion->sintagma_verbal
oracion->

sintagma_nominal-> determinante, sustantivo
sintagma_nominal-> sustantivo
sintagma_verbal-> verbo, sintagma_nominal
sintagma_verbal-> verbo
sintagma_preposicional-> enlace, sintagma_nominal
sintagma_preposicional-> enlace

enlace-> preposicion, infinitivo

Terminales
determinante,sustantivo,verbo,preposicion,infinitivo,saludo
*/
oracion(S0,S,[M|D]):-
    sintagma_nominal(P,S0,S1,M),
    sintagma_verbal(P,S1,S,D).
oracion(S0,S,[M,F|D]):-
    sintagma_nominal(P,S0,S1,M),
    sintagma_verbal(P,S1,S2,D),
    sintagma_preposicional(P,S2,S,F).
oracion(S0,S,Z):-
    sintagma_verbal(P,S0,S1,D),
    sintagma_preposicional(P,S1,S,M),
    concatenar([M],D,Z).
oracion(S0,S,Y):-
    saludo(_,S0,S1),
    oracion(S1,S,M),concatenar([saludo],M,Y).
oracion(S0,S,Z):-
    sintagma_nominal(_,S0,S,Z).
oracion(S0,S,Z):-
    sintagma_verbal(_,S0,S,Z).

oracion(_,_,[empty]).


sintagma_nominal(P,S0,S,M):-
    determinante(P,S0,S1),
    sustantivo(P,S1,S),
    cabeza(S1,M).
sintagma_nominal(P,S0,S,M):-
    sustantivo(P,S0,S),
    cabeza(S0,M).



sintagma_preposicional(P,S0,S,[F,M,D]):-
    enlace(P,S0,S1,D),
    sintagma_nominal(_,S1,S,M),
    cabeza(S0,F).
sintagma_preposicional(P,S0,S,D):-
    enlace(P,S0,S,D).


enlace(P,S0,S,M):-
    preposicion(P,S0,S1),
    infinitivo(P,S1,S),
    cabeza(S1,M).


sintagma_verbal(P,S0,S,S0):-
    verbo(P,S0,S).
sintagma_verbal(P,S0,S,Z):-
    verbo(P,S0,S1),
    sintagma_nominal(_,S1,S,M),
    cabeza(S0,F),
    concatenar(M,F,Z).
sintagma_verbal(P,S0,S,[M,F]):-
    verbo(P,S0,S1),
    sintagma_nominal(_,S1,S,M),
    cabeza(S0,F).

%Lenguaje natural

infinitivos(["despegar","aterrizar"]).
saludos(["hola","saludos","buenas"]).
verbos(["solicita","solicito","quiero","Perdi"]).


determinante([singular,masculino,_],["el"|S],S).
determinante([singular,femenino,_],["la"|S],S).
determinante([plural,femenino,_],["las"|S],S).


preposicion([_,_,_],["para"|S],S).


infinitivo([_,_,_],[N|S],S):-
	infinitivos(X),
	miembro(N,X).


sustantivo([singular,masculino,_],[N|S],S):-
    aviones(X),miembro(N,X).
sustantivo([singular,masculino,_],[N|S],S):-
    emergencias(X),miembro(N,X).
sustantivo([singular,masculino,_],["permiso"|S],S).
sustantivo([singular,masculino,_],["MayCEy"|S],S).


verbo([singular,_,1],[N|S],S):-
	verbos(X),
	miembro(N,X).


saludo([singular,_,_],[N|S],S):-
    saludos(X),
    miembro(N,X).




/*
test interactuar
*/
analizartexto(TEXTO,SALIDA):-split_string(TEXTO," ","",INTERMEDIO),oracion(INTERMEDIO,[],SALIDA),print(INTERMEDIO),print(SALIDA),not(var(SALIDA)).


/*
Llamar a MayCEy

iniciar:- write("Sistema en linea.\n"),
    read(X),
    string_lower(X,X2),
    split_string(X2," ",X3),
    analizartexto2(X3).

analizartexto2(TEXTO):- analizartexto(TEXTO, CLAVES), identificartipo(CLAVES,Tipo).
identificartipo(CLAVES,Tipo):- miembro(CLAVES,X),saludos(X),!, Tipo is saludo.
identificartipo(CLAVES,Tipo):- miembro(CLAVES,X),peticion(X),!, Tipo is peticion.
identificartipo(CLAVES,Tipo):- miembro(CLAVES,X),pregunta(X),!, Tipo is pregunta.
identificartipo(CLAVES,Tipo):- miembro(CLAVES,X),despedida(X),!, Tipo is despedida.

handle_saludo:-

handle_solicitud:-

handle_pregunta:-

handle_despedida:-

asignar_pista(Avion,Direccion):-*/
