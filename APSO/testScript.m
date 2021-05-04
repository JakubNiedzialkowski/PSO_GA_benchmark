clc;
clear;
close all;

%% Zalozenia pierwotne dotyczace optymalizowanej funkcji

problem.CostFunction = @(x) Sphere(x);  % funkcja do optymalizacji(analizy) @() - funkcja anonimowa
problem.nVar = 3;       % ilosc wymiarow zadanieu(zmiennych decyzyjnych)
problem.VarMin =  -10;  % dolny przedzial zmiennych decyzyjnych
problem.VarMax =  10;   % gorny przedzial zmiennych decyzyjnych

%% Parametry przekazywane do glownego algorytmu

params.MaxIt = 500;        % ilosc iteracji
params.nPop = 50;           % ilosc czasteczek
params.pGamma = 0.3;         % parametr kontrolny redukcji przyspieszenia (wartosc powinna sie miescic w przedziale 0 < pGamma < 1)
params.c1 = 1;              % wspolczynnik losowosci (domyslna wartosc z zakresu 0.5-1 dla standardowego APSO)
params.c2 = 0.1;            % wspolczynnik przyspieszenia globalnego czasteczki(spoleczny) (okolo 0.1 do 0.7 dla standardowego APSO)
params.precision = 5; % Precyzja wartosci
params.threshold = 5*10^(-params.precision); % zadowalajacy pulap wartosci rozwiazania
params.iterationsToBreak = 10; % ilosc iteracji pod rzad przed warunkowym zakonczeniem algorytmu
params.ShowIterInfo = false; % warunek do wyswietlania informacji o iteracjach


%% Parametry skryptu testowego
testSize = 100;
totalTime = 0;
resultsWithinThreshold = 0;

% Inicjalizacja wartosci pomocniczych
BestCosts = zeros(1,testSize);
discrepencies = zeros(1,testSize);
theoreticalBestPositions = 0.*ones(1,problem.nVar);
theoreticalBestCost = problem.CostFunction(theoreticalBestPositions);
params.threshold = theoreticalBestCost + 5*10^(-params.precision);

%% Wywolanie glownego algorytmu
for i=1:testSize
    tic ();
    out = APSO(problem, params);
    elapsed_time = toc ();

    totalTime = totalTime + elapsed_time;

    minValue = min(out.BestCosts);
    BestCosts(i) = minValue;
    discrepencies(i) = minValue - theoreticalBestCost;
    iterations(i) = out.iterations;

    if out.hasReachedThreshold
        resultsWithinThreshold = resultsWithinThreshold + 1;
    end     

end
disp(sprintf('Sredni czas wykonania algorytmu: %f sekund\n', totalTime/testSize));
disp(sprintf('Srednia ilosc iteracji: %f \n', mean(iterations)));

% BestSolution = out.BestSolution; % najlepsze znalezione rozwiazanie
% BestCosts = out.BestCosts; % najlepsze wartosci

%% Wyswietlenie wynikow

% figure;
%  plot(BestCosts, 'LineWidth', 2);
% %semilogy(NajlepszeWartosci, 'LineWidth', 2);
% xlabel('Iteracja');
% ylabel('Najlepsza wartosc');
% grid on;


