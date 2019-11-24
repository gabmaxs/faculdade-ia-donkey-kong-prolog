:- dynamic pertence/2.
% LISTAS
pertence(E, [E|_]).
pertence(E, [_|C]) :- pertence(E,C).

concatena([],L,L).
concatena([Cb|Cd],L,[Cb|Cd2]) :- concatena(Cd,L,Cd2).

% MOVIMENTACAO
sobe([X,Y],[Xnovo,Y]) :- X < 4, Xnovo is X + 1. % SOBE
desce([X,Y],[Xnovo,Y]) :- X > 0, Xnovo is X - 1. % BAIXO
anda([X,Y],[X,Ynovo]) :- Y > 0, Ynovo is Y - 1. % ESQUERDA
anda([X,Y],[X,Ynovo]) :- Y < 9, Ynovo is Y + 1. % DIREITA 

% CONDICOES DE MOVIMENTACAO
pode_andar(Estado, Proximo, _, ListaParedes, _, Caminho) :- % ANDAR PARA O LADO / PAREDES
    anda(Estado,Proximo),
    not(pertence(Proximo, ListaParedes)),
    not(pertence(Proximo, [Estado|Caminho])).


pode_andar(Estado, Proximo, ListaEscadas, _, _, Caminho) :- % SUBIR / ESCADA
    sobe(Estado,Proximo),
    pertence(Estado, ListaEscadas),
    not(pertence(Proximo, [Estado|Caminho])).

pode_andar(Estado, Proximo, ListaEscadas, _, _, Caminho) :- % DESCER / ESCADA
    desce(Estado,Proximo),
    pertence(Proximo, ListaEscadas),
    not(pertence(Proximo, [Estado|Caminho])).

% pode_andar(Estado, Proximo, _, _, ListaBarril, Caminho) :-
%     anda(Estado,Proximo),
%     not(pertence(Proximo, [Estado|Caminho])).


% BUSCA
estende([Estado|Caminho], ListaCaminhos, ListaEscadas, ListaParedes, ListaBarril) :-
    bagof([Proximo,Estado|Caminho], (pode_andar(Estado, Proximo, ListaEscadas, ListaParedes, ListaBarril, Caminho)), ListaCaminhos),!.
estende(_,[],_, _, _).


meta(X) :- X = [4,9].
    

solucao(Inicial, ListaEscadas, ListaParedes, ListaBarril, S) :- busca_largura([[Inicial]], ListaEscadas, ListaParedes, ListaBarril, S).
busca_largura([[Posicao|Caminho]|_], _, _, _, [Posicao|Caminho]) :- meta(Posicao).
busca_largura([Posicao|Calda], ListaEscadas, ListaParedes, ListaBarril, Caminho) :- 
    estende(Posicao, ListaProximos, ListaEscadas, ListaParedes, ListaBarril),
    concatena(Calda,ListaProximos, NovaListaProximos),
    busca_largura(NovaListaProximos, ListaEscadas, ListaParedes, ListaBarril, Caminho).


% FUNCAO PRINCIPAL
jogo(Inicial, ListaEscadas, ListaParedes, ListaBarril, C) :- 
    solucao(Inicial, ListaEscadas, ListaParedes, ListaBarril, C).