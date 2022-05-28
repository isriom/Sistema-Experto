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

direcciones(["norte","sur","este","oeste"]).

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
oracion->despedida
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
oracion(S0,S,Z):-
    despedida(_,S0,S1),
    oracion(S1,S,Z).


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
despedidas(["cambio","fuera"]).


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
despedida([singular,_,_],[N|S],S):-
    despedidas(X),
    miembro(N,X).




/*
interactuar
*/
%Procesa el texto y obtiene las palabras claves
analizartexto(TEXTO,SALIDA):-
    split_string(TEXTO," ","",INTERMEDIO),
    oracion(INTERMEDIO,[],SALIDA),
    print(INTERMEDIO),
    print(SALIDA),
    not(var(SALIDA)).

% prepara la obtencion de parametros extras, y trabaja sobre las claves
% obtenidas para resolver el caso.
analizar(TEXTO):- analizartexto(TEXTO, CLAVES),
    identificartipo(CLAVES,Tipo),
    verificardatos(Tipo,CLAVES,DATOS),
    resolver(Tipo,DATOS).

% Busca en las palabras claves palabras que le permitan identificar el
% caso
identificartipo(CLAVES,emergencia):-
    miembro(X,CLAVES),
    emergencias(X),
    !.
identificartipo(CLAVES,saludo):-
    miembro(saludo,CLAVES),
    handle_saludo_respuesta,
    repeat().
identificartipo(CLAVES,aterrizaje):-
    miembro(["aterrizar"],CLAVES),
    !.
identificartipo(CLAVES,despegue):-
    miembro(["despegar"],CLAVES),
    !.
identificartipo(CLAVES,despedida):-
    miembro(X,CLAVES),despedidas(X),
    !.
identificartipo(CLAVES,empty):-
    miembro(empty,CLAVES),
    !.

%respuestas pre-decididas segun el caso
handle_saludo:- write("Hola, �En que te puedo ayudar?").
handle_saludo_respuesta:- write("Hola").

handle_despedida:-write("Hasta luego").

handle_emergencia:- write("Entiendo, porfavor aterrize en la pista 3, ya los vehiculos de emergencia estan de camino").

%verifica que se tengan todos los datos para continuar con el caso.
verificardatos(emergencia,CLAVES,[AVION|EMERGENCIA]):-
    verificaremergencia(CLAVES,EMERGENCIA),
    verificaravion(CLAVES,AVION).

verificardatos(aterrizaje,CLAVES,[AVION|DIRECCION]):-
    verificaravion(CLAVES,AVION),
    verificardireccion(CLAVES,DIRECCION).

verificardatos(despegue,CLAVES,[AVION|DIRECCION]):-
    verificaravion(CLAVES,AVION),
    verificardireccion(CLAVES,DIRECCION).

verificardatos(empty,Claves,Claves).



%verifica datos especificos
verificaremergencia(CLAVES,EMERGENCIA):-
    miembro(EMERGENCIA,CLAVES),
    miembro(EMERGENCIA,EMERGENCIAS),
    emergencias(EMERGENCIAS).
verificaremergencia(_,EMERGENCIA):-
    write("Por favor indiquenos su emergencia"),
    read(EMERGENCIA).

verificaravion(CLAVES,AVION):-
    miembro(AVION,CLAVES),
    miembro(AVION,AVIONES),
    aviones(AVIONES).
verificaravion(_,AVION):-
    write("Por favor indiquenos su modelo"),
    read(AVION).

verificardireccion(CLAVES,DIRECCION):-
    miembro(DIRECCION,CLAVES),
    miembro(DIRECCION,DIRECCIONES),
    direcciones(DIRECCIONES).
verificardireccion(_,DIRECCION):-
    write("Por favor indiquenos su direccion"),
    read(DIRECCION).


%Resolver caso
%Asigna la pista o repite el proceso segun el caso
% vienen primero las funciones que hacen uso del asserta, ya que no
% sabemos si se debia usar y ya es un poco tarde para preguntar.
/*
resolver(emergencia,[AVION,EMERGENCIA]):-
    handle_emergencia
   ,asserta(emergencia(AVION,EMERGENCIA,p3))
   .
*/
resolver(emergencia,_):-
    handle_emergencia .

resolver(aterrizaje,[AVION,DIRECCION]):-
    asignar_pista(AVION,DIRECCION).

resolver(despegue,[AVION,DIRECCION]):-
    asignar_pista(AVION,DIRECCION).

resolver(empty,Claves1):-
    write("Disculpa no entendi, podrias repetir"),
    read(X),
    string_lower(X,TEXTO),
    analizartexto(TEXTO, CLAVES2),
    concatenar(Claves1,CLAVES2,CLAVES),
    identificartipo(CLAVES,Tipo),
    verificardatos(Tipo,CLAVES,DATOS),
    resolver(Tipo,DATOS).

/*
asignar_pista(AVION,DIRECCION):-
    asignarpista(PISTA),puede_aterrizar(PISTA,AVION,DIRECCION),not(ocupado(PISTA,_,_)),asserta(ocupado(PISTA,AVION,DIRECCION)).
*/
asignar_pista(AVION,DIRECCION):-
    asignarpista(PISTA),puede_aterrizar(PISTA,AVION,DIRECCION).

asignarpista(p1):- write("Se le reserva la pista P1 por cinco minutos. \n").
asignarpista(p21):- write("Se le reserva la pista P2-1, sentido este a oeste, por cinco minutos. \n").
asignarpista(p22):- write("Se le reserva la pista P2-2, sentido oeste a este, por cinco minutos. \n").
asignarpista(p3):- write("Se le reserva la pista P3 por cinco minutos. \n").



/*
Llamar a MayCEy
*/
iniciar(X):-
    write("Ya puede digitar"),
    nl,
    read_line_to_string(user_input,X),
    string_lower(X,X2),
    write("danos un momento"),
    analizar(X2).
