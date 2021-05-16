clear all
close all
clc

%% Zalozenia pierwotne dotyczace optymalizowanej funkcji

problem.CostFunction = @(x) rosenbrock(x);  % funkcja do optymalizacji(analizy) @() - funkcja anonimowa
problem.nVar = 5;       % ilosc wymiarow zadanieu(zmiennych decyzyjnych)
problem.VarMin =  -5;  % dolny przedzial zmiennych decyzyjnych
problem.VarMax =  5;   % gorny przedzial zmiennych decyzyjnych


%--------------------------------------------------------------------------
params.populationSize=50; % Ilosc osobnikow
params.c=40; % Ilosc par chromosomow ktore beda krzyzowane
params.m=40; % Ilosc chromosomow poddawanych mutacji
params.totalGenerations=300; % Ilosc generacji(iteracji petli glownej)
params.precision=5; % Precyzja wartosci
params.threshold = 5*10^(-params.precision); % zadowalajacy pulap wartosci rozwiazania
params.iterationsToBreak = 50; % ilosc iteracji pod rzad przed warunkowym zakonczeniem algorytmu
%--------------------------------------------------------------------------

% Parametry skryptu testowego
testSize = 100;
totalTime = 0;
isSuccess = 0;
resultsWithinThreshold = 0;

% Inicjalizacja wartosci pomocniczych
BestCosts = zeros(1,testSize);
discrepencies = zeros(1,testSize);
iterations = zeros(1,testSize);
theoreticalBestPositions = 1.*ones(1,problem.nVar);
theoreticalBestCost = problem.CostFunction(theoreticalBestPositions);
threshold = theoreticalBestCost + 5*10^(-params.precision);

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
        isSuccess = isSuccess + 1;
        iterations(i) = out.iterations;
        discrepencies(i) = minValue - theoreticalBestCost;
        if minValue <= threshold
            resultsWithinThreshold = resultsWithinThreshold + 1;
        end
    end       

end

csvwrite('testOutput.csv', {isSuccess/testSize*100, resultsWithinThreshold/testSize*100, mean(iterations), mean(discrepencies), sum((discrepencies-mean(discrepencies)).^2)/testSize, totalTime/isSuccess, totalTime/sum(iterations)})


% figure;
% %title('Niebieski - Srednia         Czerwony - Minimum');
% xlabel('Generacja(Iteracja)')
% ylabel('Najlepsza wartosc funkcji dopasowania')
% grid on;
% plot(out.BestCosts,'LineWidth', 2); % wykres najlepszych wartosci