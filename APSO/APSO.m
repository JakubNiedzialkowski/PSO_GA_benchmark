function out = APSO(problem, params)

     %% Założenia pierwotne dotyczące optymalizowanej funkcji

    CostFunction = problem.CostFunction;  % funkcja testowana(optymalizowana)

    nVar = problem.nVar;        % ilość wymiarów funkcji(zmiennych decyzyjnych)

    VarSize = [1 nVar];         % wektor zmiennych decyzyjnych

    VarMin = problem.VarMin;	% dolny przedział zmiennych decyzyjnych
    VarMax = problem.VarMax;    % górny przedział zmiennych decyzyjnych

    %% Parametry algorytmu

    MaxIt = params.MaxIt;   % ilość epok(iteracji)

    nPop = params.nPop;     % ilość cząsteczek

    c1 = params.c1;         % współczynnik przyspieszenia cząsteczki(lokalny, poznawczy)
    c2 = params.c2;         % współczynnik przyspieszenia cząsteczki(globalny, społeczny)
    pGamma = params.pGamma;

    threshold = params.threshold; % zadowalajacy pulap wartosci rozwiazania
    iterationsToBreak = params.iterationsToBreak; % ilosc iteracji pod rzad przed warunkowym zakonczeniem algorytmu

    out.iterations = MaxIt;
    breakCounter = 0;
    savedValue = inf;

    % flaga odpowiadająca za wyświetlanie informacji o iteracjach
    ShowIterInfo = params.ShowIterInfo;    
    
    %% Inicjalizacja algorytmu

    % Szablon cząsteczki
    empty_particle.Position = [];
    empty_particle.Cost = [];
    empty_particle.Best.Position = [];
    empty_particle.Best.Cost = [];

	% Stworzenie tablicy z cząsteczkami
    particle = repmat(empty_particle, nPop, 1);

    % Inicjalizacja najlepszej wartości globalnej
    GlobalBest.Cost = inf;

    % Inicjalizacja cząsteczek
    for i=1:nPop

        % Przypisanie przypadkowych wartości
        particle(i).Position = unifrnd(VarMin, VarMax, VarSize);

        % Wyliczenie wartości optymalizowanej funkcji
        particle(i).Cost = CostFunction(particle(i).Position);

		% Inicjalizacja najlepszej wartości lokalnej
        particle(i).Best.Position = particle(i).Position;
        particle(i).Best.Cost = particle(i).Cost;

        % Aktualizacja najlepszej pozycji globalnej
        if particle(i).Best.Cost < GlobalBest.Cost
            GlobalBest = particle(i).Best;
        end

    end

    % inicjalizacja tablicy przechowującej najlepsze wartośći z poszczególnych iteracji
    BestCosts = zeros(MaxIt, 1);


    %% Główna pętla programu

    for it=1:MaxIt

        for i=1:nPop
            
            % aktualizacja pozycji
            particle(i).Position = (1-c2) * particle(i).Position + c2 * GlobalBest.Position + c1*pGamma^(it-1)*rand(VarSize);
            
            % w razie przekroczenia dozwolonych wartości obcięcie prędkości do wartości granicznej.
            particle(i).Position = max(particle(i).Position, VarMin);
            particle(i).Position = min(particle(i).Position, VarMax);

            % Wyliczenie wartości optymalizowanej funkcji
            particle(i).Cost = CostFunction(particle(i).Position);

            % aktualizacja najlepszej lokalnej wartości
            if particle(i).Cost < particle(i).Best.Cost

                particle(i).Best.Position = particle(i).Position;
                particle(i).Best.Cost = particle(i).Cost;

                % aktualizacja najlepszej globalnej wartości
                if particle(i).Best.Cost < GlobalBest.Cost
                    GlobalBest = particle(i).Best;
                end            

            end

        end

        % Zapisanie najlepszej globalnej wartości
        BestCosts(it) = GlobalBest.Cost;

        % warunkowe przerwanie algorytmu
        if (savedValue-threshold <= BestCosts(it)) && (BestCosts(it) <= savedValue+threshold) 
            breakCounter = breakCounter + 1;
            if breakCounter >= iterationsToBreak
                out.iterations = it;
                BestCosts(it+1:MaxIt) = [];
                break;
            end
        else
            breakCounter = 0;
            savedValue = BestCosts(it);
        end

        % Wyświetlenie informacji o iteracji
        if ShowIterInfo
            disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
        end

    end
    
    out.pop = particle;
    out.BestSolution = GlobalBest;
    out.BestCosts = BestCosts;
    
end