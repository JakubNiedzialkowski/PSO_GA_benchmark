clc;
clear;
close all;

%% Zalozenia pierwotne dotyczace optymalizowanej funkcji

problem.CostFunction = @(x) rosenbrock(x);  % funkcja do optymalizacji(analizy) @() - funkcja anonimowa
problem.nVar = 5;       % ilosc wymiarow zadanieu(zmiennych decyzyjnych)
problem.VarMin =  -5;  % dolny przedzial zmiennych decyzyjnych
problem.VarMax =  5;   % gorny przedzial zmiennych decyzyjnych

%% Parametry przekazywane do glownego algorytmu

params.MaxIt = 300;        % ilosc iteracji
params.nPop = 50;           % ilosc czasteczek
params.w = 1;               % wspolczynnik bezwladnosci (1 dla standardowego pso)
params.wdamp = 0.99;        % wytlumienie wspolczynnika bezwladnosci (1%)
params.c1 = 2;              % wspolczynnik przyspieszenia lokalnego czasteczki(poznawczy) (2 dla standardowego pso)
params.c2 = 2;              % wspolczynnik przyspieszenia globalnego czasteczki(spoleczny) (2 dla standardowego pso)
params.precision = 5; % Precyzja wartosci
params.threshold = 5*10^(-params.precision); % zadowalajacy pulap wartosci rozwiazania
params.iterationsToBreak = 50; % ilosc iteracji pod rzad przed warunkowym zakonczeniem algorytmu


%% Parametry skryptu testowego
testSize = 100;
totalTime = 0;
isSuccess = 0;
resultsWithinThreshold = 0;

% Inicjalizacja wartosci pomocniczych
BestCosts = zeros(1,testSize);
theoreticalBestPositions = 1.*ones(1,problem.nVar);
theoreticalBestCost = problem.CostFunction(theoreticalBestPositions);
threshold = theoreticalBestCost + 5*10^(-params.precision);

%% Wywolanie glownego algorytmu
for i=1:testSize
    tic ();
    out = PSO(problem, params);
    elapsed_time = toc ();

    totalTime = totalTime + elapsed_time;

    minValue = min(out.BestCosts);
    BestCosts(i) = minValue;
    

    
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

% disp(sprintf('Sredni czas wykonania algorytmu: %f sekund\n', totalTime/testSize));
% disp(sprintf('Srednia ilosc iteracji: %f \n', mean(iterations)));

%% Wyswietlenie wynikow

%figure;
%plot(BestCosts, 'LineWidth', 2);
%%semilogy(NajlepszeWartosci, 'LineWidth', 2);
%xlabel('Iteracja');
%ylabel('Najlepsza wartosc');
%grid on;


