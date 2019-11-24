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
% pode_andar(Estado, Proximo, ListaEscada, Caminho) :- % DIREITA/ESQUERDA
%     anda(Estado,Proximo),
%     not(pertence(Proximo, [Estado|Caminho])),
%     not(pertence(Estado, ListaEscada)).
% pode_andar(Estado, Proximo, ListaEscada, Caminho) :- % CIMA
%     anda(Estado,Proximo),
%     not(pertence(Proximo, [Estado|Caminho])),
%     pertence(Estado, ListaEscada).
% pode_andar(Estado, Proximo, ListaEscada, Caminho) :- % Baixo
%     anda(Estado,Proximo),
%     not(pertence(Proximo, [Estado|Caminho])),
%     pertence(Proximo, ListaEscada).
pode_andar(Estado, Proximo, ListaEscada, Caminho) :-
    anda(Estado,Proximo),
    not(pertence(Proximo, [Estado|Caminho])).

% BUSCA
estende([Estado|Caminho], ListaCaminhos, ListaEscada) :-
    bagof([Proximo,Estado|Caminho], (pode_andar(Estado, Proximo, ListaEscada, Caminho)), ListaCaminhos),!.
estende(_,[],_).


meta(X) :- X = [7,4].
    

solucao(Inicial, ListaEscada, S) :- busca_largura([[Inicial]], ListaEscada, S).
busca_largura([[Posicao|Caminho]|_], _, [Posicao|Caminho]) :- meta(Posicao).
busca_largura([Posicao|Calda], ListaEscada, Caminho) :- 
    estende(Posicao, ListaProximos, ListaEscada),
    concatena(Calda,ListaProximos, NovaListaProximos),
    busca_largura(NovaListaProximos, ListaEscada, Caminho).


% FUNCAO PRINCIPAL
jogo(Inicial, ListaEscada, C) :- 
    solucao(Inicial, ListaEscada, C).