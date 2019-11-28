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
anda([X,Y],[X,Ynovo], _, ListaParedes, ListaBarril) :- % ESQUERDA
    Y > 0, Ynovo is Y - 1 , 
    not(pertence([X,Ynovo], ListaParedes)), 
    not(pertence([X,Ynovo], ListaBarril)). 
anda([X,Y],[X,Ynovo], _, ListaParedes, ListaBarril) :- % DIREITA 
    Y < 9, Ynovo is Y + 1, 
    not(pertence([X,Ynovo], ListaParedes)),
    not(pertence([X,Ynovo], ListaBarril)).
anda([X,Y],[X,Ynovo], ListaEscadas, ListaParedes, ListaBarril) :- % PULA ESQUERDA
    Y > 1, Ynovo is Y - 2, Ytemp is Y - 1, 
    pertence([X,Ytemp],ListaBarril), 
    not(pertence([X,Ynovo], ListaEscadas)),
    not(pertence([X,Ynovo], ListaParedes)),
    not(pertence([X,Ynovo], ListaBarril)).
anda([X,Y],[X,Ynovo], ListaEscadas, ListaParedes, ListaBarril) :- % PULA DIREITA
    Y < 8, Ynovo is Y + 2, Ytemp is Y + 1, 
    pertence([X,Ytemp],ListaBarril), 
    not(pertence([X,Ynovo], ListaEscadas)), 
    not(pertence([X,Ynovo], ListaParedes)), 
    not(pertence([X,Ynovo], ListaBarril)).

% CONDICOES DE MOVIMENTACAO
pode_andar(Estado, Proximo, ListaEscadas, _, _, Caminho) :- % SUBIR / ESCADA
    sobe(Estado,Proximo),
    pertence(Estado, ListaEscadas),
    not(pertence(Proximo, [Estado|Caminho])).

pode_andar(Estado, Proximo, ListaEscadas, _, _, Caminho) :- % DESCER / ESCADA
    desce(Estado,Proximo),
    pertence(Proximo, ListaEscadas),
    not(pertence(Proximo, [Estado|Caminho])).

pode_andar(Estado, Proximo, ListaEscadas, ListaParedes, ListaBarril, Caminho) :- % ANDAR PARA O LADO
    anda(Estado,Proximo, ListaEscadas, ListaParedes, ListaBarril),
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

% CASOS TESTE
% CENARIO 1
% jogo([0,0],[[0,3],[3,3],[1,9],[2,6]],[],[[0,4],[0,5],[2,1],[4,1],[4,5],[3,7]],[2,7],[4,9], C).

% CENARIO 2
% jogo([0,0],[[0,3],[0,8],[1,9],[1,0],[2,6],[3,3]],[[0,6],[2,4]],[[2,2],[2,4],[4,5],[1,6],[3,7]],[0,9],[4,9], C).

% CENARIO 3
% jogo([0,0],[[0,8],[1,2],[2,0],[3,2],[2,9],[3,7]],[[3,3],[4,6]],[[1,6],[2,5],[2,7],[3,6],[4,5]],[4,0],[4,9], C).

% CENARIO 4
% jogo([0,0],[[0,4],[1,8],[2,0],[3,2],[3,4],[2,9],[3,7]],[[2,2],[4,6]],[[1,3],[1,6],[3,3],[4,5]],[2,1],[4,9], C).

% CENARIO 5 
% jogo([0,0],[[0,4],[1,8],[2,0],[3,2],[3,4],[2,9],[3,7]],[[2,2],[4,6]],[[1,3],[1,6],[3,3],[4,5]],[2,1],[4,9], C).