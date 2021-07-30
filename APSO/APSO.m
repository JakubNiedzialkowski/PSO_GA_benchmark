% Copyright (c) 2016, Yarpiz (www.yarpiz.com)
% All rights reserved.

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:

%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
	  
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution

% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

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
    out.hasReachedThreshold = false;
    breakCounter = 0;
    savedValue = inf;

    
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
                out.hasReachedThreshold = true;
                BestCosts(it+1:MaxIt) = [];
                break;
            end
        else
            breakCounter = 0;
            savedValue = BestCosts(it);
        end

    end
    
    out.pop = particle;
    out.BestSolution = GlobalBest;
    out.BestCosts = BestCosts;
    
end