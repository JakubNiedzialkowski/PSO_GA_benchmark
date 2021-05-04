clear all
close all
clc

%% Zalozenia pierwotne dotyczace optymalizowanej funkcji

problem.CostFunction = @(x) Sphere(x);  % funkcja do optymalizacji(analizy) @() - funkcja anonimowa
problem.nVar = 5;       % ilosc wymiarow zadanieu(zmiennych decyzyjnych)
problem.VarMin =  -10;  % dolny przedzial zmiennych decyzyjnych
problem.VarMax =  10;   % gorny przedzial zmiennych decyzyjnych


%--------------------------------------------------------------------------
params.populationSize=50; % Ilosc osobnikow
params.c=40; % Ilosc par chromosomow ktore beda krzyzowane
params.m=40; % Ilosc chromosomow poddawanych mutacji
params.totalGenerations=500; % Ilosc generacji(iteracji petli glownej)
params.precision=5; % Precyzja wartosci
params.threshold = 5*10^(-params.precision); % zadowalajacy pulap wartosci rozwiazania
params.iterationsToBreak = 10; % ilosc iteracji pod rzad przed warunkowym zakonczeniem algorytmu
params.ShowIterInfo = false; % warunek do wyswietlania informacji o iteracjach
%--------------------------------------------------------------------------

% Parametry skryptu testowego
testSize = 10;
totalTime = 0;
resultsWithinThreshold = 0;

% Inicjalizacja wartosci pomocniczych
BestCosts = zeros(1,testSize);
discrepencies = zeros(1,testSize);
iterations = zeros(1,testSize);
theoreticalBestPositions = 0.*ones(1,problem.nVar);
theoreticalBestCost = problem.CostFunction(theoreticalBestPositions);
params.threshold = theoreticalBestCost + 5*10^(-params.precision);

for i=1:testSize
    tic ();
    out = genetic(problem, params);
    elapsed_time = toc ();

    totalTime = totalTime + elapsed_time;

    % BestSolution = out.BestSolution; % najlepsze znalezione rozwiazanie
    

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


% figure;
% %title('Niebieski - Srednia         Czerwony - Minimum');
% xlabel('Generacja(Iteracja)')
% ylabel('Najlepsza wartosc funkcji dopasowania')
% grid on;
% plot(BestCosts,'LineWidth', 2); % wykres najlepszych wartosci

disp(['Najlepsza wartosc ze wszystkich przebiegow to ', num2str(min(BestCosts))]);