function out = PSO(problem, params)

     %% Założenia pierwotne dotyczące optymalizowanej funkcji

    CostFunction = problem.CostFunction;  % funkcja testowana(optymalizowana)

    nVar = problem.nVar;        % ilość wymiarów funkcji(zmiennych decyzyjnych)

    VarSize = [1 nVar];         % wektor zmiennych decyzyjnych

    VarMin = problem.VarMin;	% dolny przedział zmiennych decyzyjnych
    VarMax = problem.VarMax;    % górny przedział zmiennych decyzyjnych

    %% Parametry algorytmu

    MaxIt = params.MaxIt;   % ilość epok(iteracji)

    nPop = params.nPop;     % ilość cząsteczek

    w = params.w;           % współczynnik bezwładności
    wdamp = params.wdamp;   % współczynnik wytłumiania
    c1 = params.c1;         % współczynnik przyspieszenia cząsteczki(lokalny, poznawczy)
    c2 = params.c2;         % współczynnik przyspieszenia cząsteczki(globalny, społeczny)
	
	threshold = params.threshold; % zadowalajacy pulap wartosci rozwiazania
    iterationsToBreak = params.iterationsToBreak; % ilosc iteracji pod rzad przed warunkowym zakonczeniem algorytmu

    out.iterations = MaxIt;
    breakCounter = 0;
    savedValue = inf;

    % flaga odpowiadająca za wyświetlanie informacji o iteracjach
    ShowIterInfo = params.ShowIterInfo;    

	%dozwolone przedziały prędkości cząsteczki, nie mogą wykraczać poza przedział wartości decyzyjnych
    MaxVelocity = 0.2*(VarMax-VarMin);
    MinVelocity = -MaxVelocity;
    
    %% Inicjalizacja algorytmu

    % Szablon cząsteczki
    empty_particle.Position = [];
    empty_particle.Velocity = [];
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

        % Inicjalizacja prędkości cząsteczek
        particle(i).Velocity = zeros(VarSize);

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

            % obliczanie prędkości cząsteczek
            particle(i).Velocity = w*particle(i).Velocity ...
                + c1*rand(VarSize).*(particle(i).Best.Position - particle(i).Position) ...
                + c2*rand(VarSize).*(GlobalBest.Position - particle(i).Position);

            % w razie przekroczenia dozwolonych wartości obcięcie prędkości do wartości granicznej.
            particle(i).Velocity = max(particle(i).Velocity, MinVelocity);
            particle(i).Velocity = min(particle(i).Velocity, MaxVelocity);
            
            % aktualizacja pozycji
            particle(i).Position = particle(i).Position + particle(i).Velocity;
            
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

        % Wyświetlenie informacji o iteracji
        if ShowIterInfo
            disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
        end
		
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

        % Wytłumienie współczynnika bezwładności
        w = w * wdamp;

    end
    
    out.pop = particle;
    out.BestSolution = GlobalBest;
    out.BestCosts = BestCosts;
    
end