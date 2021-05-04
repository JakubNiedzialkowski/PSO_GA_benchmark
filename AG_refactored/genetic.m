function out = genetic(problem, params)
        
    CostFunction = problem.CostFunction;  % funkcja testowana(optymalizowana)
    nVar = problem.nVar;        % ilość wymiarów funkcji(zmiennych decyzyjnych)
    VarMin = problem.VarMin;	% dolny przedział zmiennych decyzyjnych
    VarMax = problem.VarMax;    % górny przedział zmiennych decyzyjnych
    

    %--------------------------------------------------------------------------
    populationSize=params.populationSize; % Ilosc osobnikow
    c=params.c; % Ilosc par chromosomow ktore beda krzyzowane
    m=params.m; % Ilosc chromosomow poddawanych mutacji
    totalGenerations=params.totalGenerations; % Ilosc generacji(iteracji petli glownej)
    precision = params.precision; % Precyzja wartosci
    threshold = params.threshold; % zadowalajacy pulap wartosci rozwiazania
    iterationsToBreak = params.iterationsToBreak; % ilosc iteracji pod rzad przed warunkowym zakonczeniem algorytmu
    %--------------------------------------------------------------------------

    out.hasReachedThreshold = false;
    out.iterations = totalGenerations;
    breakCounter = 0;

    % inicjalizacja tablicy przechowującej najlepsze wartośći z poszczególnych iteracji
    BestCosts = zeros(totalGenerations, 1);

    Pop=population(populationSize, precision, VarMin, VarMax, nVar);

    for i=1:totalGenerations   
        Cr=crossover(Pop,c);
        Mu=mutation(Pop,m);
        Pop(populationSize+1:populationSize+2*c,:)=Cr;
        Pop(populationSize+2*c+1:populationSize+2*c+m,:)=Mu;
        Eva=evaluation(Pop, VarMin, VarMax, nVar, CostFunction);
        [Pop Sel]=selection(Pop, Eva, populationSize);
        BestCosts(i)=-Sel(1); % Zapisanie najlepszej globalnej wartości

        if BestCosts(i) <= threshold
            breakCounter = breakCounter + 1;
            if breakCounter >= iterationsToBreak
                out.hasReachedThreshold = true;
                out.iterations = i;
                break;
            end
        else
            breakCounter=0;
        end

    end    

    % out.pop = Pop;
    % out.BestSolution = Pop(1,:); %najlepszy chromosom
    out.BestCosts = BestCosts;
    
end
    