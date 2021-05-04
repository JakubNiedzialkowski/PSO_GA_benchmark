clc;
clear;
close all;

%% Założenia pierwotne dotyczące optymalizowanej funkcji

problem.CostFunction = @(x) Sphere(x);  % funkcja do optymalizacji(analizy) @() - funkcja anonimowa
problem.nVar = 5;       % ilość wymiarów zadanieu(zmiennych decyzyjnych)
problem.VarMin =  -10;  % dolny przedział zmiennych decyzyjnych
problem.VarMax =  10;   % górny przedział zmiennych decyzyjnych

% Współczynniki zawężające
kappa = 1;
phi1 = 2.05;
phi2 = 2.05;
phi = phi1 + phi2;
chi = 2*kappa/abs(2-phi-sqrt(phi^2-4*phi));

%% Parametry przekazywane do głównego algorytmu

params.MaxIt = 1000;        % ilość iteracji
params.nPop = 50;           % ilość cząsteczek
params.w = chi;               % współczynnik bezwładności 
params.wdamp = 1;        % wytłumienie współczynnika bezwładności 
params.c1 = chi*phi1;              % współczynnik przyspieszenia lokalnego cząsteczki(poznawczy) 
params.c2 = chi*phi2;              % współczynnik przyspieszenia globalnego cząsteczki(społeczny) 
params.ShowIterInfo = false; % warunek do wyświetlania informacji o iteracjach

%% Wywołanie głównego algorytmu

tic ();
out = PSO(problem, params);
elapsed_time = toc ();
printf('Czas wykonania algorytmu: %f sekund\n', elapsed_time);

BestSolution = out.BestSolution; % najlepsze znalezione rozwiązanie
BestCosts = out.BestCosts; % najlepsze wartości

%% Wyświetlenie wyników

figure;
 plot(BestCosts, 'LineWidth', 2);
%semilogy(NajlepszeWartosci, 'LineWidth', 2);
xlabel('Iteracja');
ylabel('Najlepsza wartosc');
grid on;


