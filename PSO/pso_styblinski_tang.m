clc;
clear;
close all;

%% Zalozenia pierwotne dotyczace optymalizowanej funkcji

problem.CostFunction = @(x) styblinski_tang(x);  % funkcja do optymalizacji(analizy) @() - funkcja anonimowa
problem.nVar = 5;       % ilosc wymiarow zadanieu(zmiennych decyzyjnych)
problem.VarMin =  -10;  % dolny przedzial zmiennych decyzyjnych
problem.VarMax =  10;   % gorny przedzial zmiennych decyzyjnych

%% Parametry przekazywane do glownego algorytmu

params.MaxIt = 1000;        % ilosc iteracji
params.nPop = 50;           % ilosc czasteczek
params.w = 1;               % wspolczynnik bezwladnosci (1 dla standardowego pso)
params.wdamp = 0.90;        % wytlumienie wspolczynnika bezwladnosci (1%)
params.c1 = 2;              % wspolczynnik przyspieszenia lokalnego czasteczki(poznawczy) (2 dla standardowego pso)
params.c2 = 2;              % wspolczynnik przyspieszenia globalnego czasteczki(spoleczny) (2 dla standardowego pso)
params.ShowIterInfo = false; % warunek do wyswietlania informacji o iteracjach

%% Wywolanie glownego algorytmu

tic ();
out = PSO(problem, params);
elapsed_time = toc ();
disp(sprintf('Czas wykonania algorytmu: %f sekund\n', elapsed_time));

BestSolution = out.BestSolution; % najlepsze znalezione rozwiazanie
BestCosts = out.BestCosts; % najlepsze wartosci

%% Wyswietlenie wynikow

figure;
 plot(BestCosts, 'LineWidth', 2);
%semilogy(NajlepszeWartosci, 'LineWidth', 2);
xlabel('Iteracja');
ylabel('Najlepsza wartosc');
grid on;


