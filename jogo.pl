:- dynamic pertence/2.
% LISTAS
pertence(E, [E|_]).
pertence(E, [_|C]) :- pertence(E,C).

concatena([],L,L).
concatena([Cb|Cd],L,[Cb|Cd2]) :- concatena(Cd,L,Cd2).

% MOVIMENTACAO
anda([X,Y],[Xnovo,Y]) :- X < 7, Xnovo is X + 1. % DIREITA
anda([X,Y],[Xnovo,Y]) :- X > 0, Xnovo is X - 1. % ESQUERDA
anda([X,Y],[X,Ynovo]) :- Y < 4, Ynovo is Y + 1. % CIMA 
anda([X,Y],[X,Ynovo]) :- Y > 0, Ynovo is Y - 1. % BAIXO

% CONDICOES DE MOVIMENTACAO
% pode_andar(Estado, Proximo, ListaEscadas, ListaParedes, ListaBarril, Caminho) :- % DIREITA/ESQUERDA
%     anda(Estado,Proximo),
%     not(pertence(Proximo, [Estado|Caminho])),
%     not(pertence(Estado, ListaEscadas, ListaParedes, ListaBarril)).
% pode_andar(Estado, Proximo, ListaEscadas, ListaParedes, ListaBarril, Caminho) :- % CIMA
%     anda(Estado,Proximo),
%     not(pertence(Proximo, [Estado|Caminho])),
%     pertence(Estado, ListaEscadas, ListaParedes, ListaBarril).
% pode_andar(Estado, Proximo, ListaEscadas, ListaParedes, ListaBarril, Caminho) :- % Baixo
%     anda(Estado,Proximo),
%     not(pertence(Proximo, [Estado|Caminho])),
%     pertence(Proximo, ListaEscadas, ListaParedes, ListaBarril).
pode_andar(Estado, Proximo, _, ListaParedes, _, Caminho) :-
    anda(Estado,Proximo),
    not(pertence(Proximo, ListaParedes)),
    not(pertence(Proximo, [Estado|Caminho])).

% pode_andar(Estado, Proximo, ListaEscadas, _, _, Caminho) :-
%     anda(Estado,Proximo),
%     pertence(Estado,ListaEscadas),
%     not(pertence(Proximo, [Estado|Caminho])).

% pode_andar(Estado, Proximo, _, _, ListaBarril, Caminho) :-
%     anda(Estado,Proximo),
%     not(pertence(Proximo, [Estado|Caminho])).


% BUSCA
estende([Estado|Caminho], ListaCaminhos, ListaEscadas, ListaParedes, ListaBarril) :-
    bagof([Proximo,Estado|Caminho], (pode_andar(Estado, Proximo, ListaEscadas, ListaParedes, ListaBarril, Caminho)), ListaCaminhos),!.
estende(_,[],_, _, _).


meta(X) :- X = [7,4].
    

solucao(Inicial, ListaEscadas, ListaParedes, ListaBarril, S) :- busca_largura([[Inicial]], ListaEscadas, ListaParedes, ListaBarril, S).
busca_largura([[Posicao|Caminho]|_], _, _, _, [Posicao|Caminho]) :- meta(Posicao).
busca_largura([Posicao|Calda], ListaEscadas, ListaParedes, ListaBarril, Caminho) :- 
    estende(Posicao, ListaProximos, ListaEscadas, ListaParedes, ListaBarril),
    concatena(Calda,ListaProximos, NovaListaProximos),
    busca_largura(NovaListaProximos, ListaEscadas, ListaParedes, ListaBarril, Caminho).


% FUNCAO PRINCIPAL
jogo(Inicial, ListaEscadas, ListaParedes, ListaBarril, C) :- 
    solucao(Inicial, ListaEscadas, ListaParedes, ListaBarril, C).