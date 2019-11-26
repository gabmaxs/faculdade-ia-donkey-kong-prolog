:- dynamic pertence/2.
% LISTAS
pertence(E, [E|_]).
pertence(E, [_|C]) :- pertence(E,C).

concatena([],L,L).
concatena([Cb|Cd],L,[Cb|Cd2]) :- concatena(Cd,L,Cd2).

retirar_elemento(E,[E|C],C).
retirar_elemento(E,[E1|C],[E1|C1]) :- retirar_elemento(E,C,C1).

inverter([],[]).
inverter([E|C],Ln) :- inverter(C,Cn),concatena(Cn,[E],Ln).


% MOVIMENTACAO
sobe([X,Y],[Xnovo,Y]) :- X < 4, Xnovo is X + 1. % SOBE
desce([X,Y],[Xnovo,Y]) :- X > 0, Xnovo is X - 1. % BAIXO
anda([X,Y],[X,Ynovo]) :- Y > 0, Ynovo is Y - 1. % ESQUERDA
anda([X,Y],[X,Ynovo]) :- Y < 9, Ynovo is Y + 1. % DIREITA 

% CONDICOES DE MOVIMENTACAO

pode_andar(Estado, Proximo, _, ListaParedes, ListaBarril, Caminho) :- % ANDAR PARA O LADO / PAREDES
    anda(Estado,Proximo),
    not(pertence(Proximo, ListaParedes)),
    not(pertence(Proximo, ListaBarril)),
    not(pertence(Proximo, [Estado|Caminho])).


% pode_andar(Estado, Proximo, _, _, ListaBarril, Caminho) :-
%     not(pertence(Proximo, [Estado|Caminho])),
%     pertence(Proximo, ListaBarril),
%     anda(Estado, Proximo),
%     pode_andar(Proximo, _, _, _, ListaBarril, Caminho).

pode_andar(Estado, Proximo, ListaEscadas, _, _, Caminho) :- % SUBIR / ESCADA
    sobe(Estado,Proximo),
    pertence(Estado, ListaEscadas),
    not(pertence(Proximo, [Estado|Caminho])).

pode_andar(Estado, Proximo, ListaEscadas, _, _, Caminho) :- % DESCER / ESCADA
    desce(Estado,Proximo),
    pertence(Proximo, ListaEscadas),
    not(pertence(Proximo, [Estado|Caminho])).

pode_andar(Estado, Proximo2, _, ListaParedes, ListaBarril, Caminho) :-
    anda(Estado,Proximo),
    anda(Proximo,Proximo2),
    pertence(Proximo, ListaBarril),
    (not(pertence(Proximo2, ListaBarril)) , not(pertence(Proximo2, ListaParedes))),
    not(pertence(Proximo, [Estado|Caminho])).

% BUSCA
estende([Estado|Caminho], ListaCaminhos, ListaEscadas, ListaParedes, ListaBarril) :-
    bagof([Proximo,Estado|Caminho], (pode_andar(Estado, Proximo, ListaEscadas, ListaParedes, ListaBarril, Caminho)), ListaCaminhos),!.
estende(_,[],_, _, _).

solucao(Inicial, ListaEscadas, ListaParedes, ListaBarril, Martelo, Peach, SolucaoFinal) :-
    busca_largura([[Inicial]], ListaEscadas, ListaParedes, ListaBarril, Martelo, BuscaMaterlo),
    busca_largura([[Martelo]], ListaEscadas, ListaParedes, ListaBarril, Peach, BuscaPeach),
    inverter(BuscaMaterlo,NM),
    inverter(BuscaPeach,NP),
    concatena(NM,NP, Solucao),
    retirar_elemento(Martelo,Solucao,SolucaoFinal).

busca_largura([[Posicao|Caminho]|_], _, _, _, Destino, [Posicao|Caminho]) :- Posicao = Destino.
busca_largura([Posicao|Calda], ListaEscadas, ListaParedes, ListaBarril, Destino, Caminho) :- 
    estende(Posicao, ListaProximos, ListaEscadas, ListaParedes, ListaBarril),
    concatena(Calda,ListaProximos, NovaListaProximos),
    busca_largura(NovaListaProximos, ListaEscadas, ListaParedes, ListaBarril, Destino, Caminho).


% FUNCAO PRINCIPAL
jogo(Inicial, ListaEscadas, ListaParedes, ListaBarril, Martelo, Peach, C) :- 
    solucao(Inicial, ListaEscadas, ListaParedes, ListaBarril, Martelo, Peach, C).