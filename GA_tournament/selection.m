function [YY1 YY2] = selection(Population,fitnessValue,populationSize)
% Population - populacja, fitnessValue - wartosc funkcji dopasowania, populationSize - ilosc osobnikow
[x y]=size(Population);
Y1 = zeros(populationSize,y);
fitnessValue = fitnessValue + 1000; % dodanie wartosci zeby zaden chromosom nie mial ujemnej wartosci(fitness)

% wybieranie najlepszych osobnikow(elityzm)
e=3;
for i = 1:e
    [r1 c1]=find(fitnessValue==max(fitnessValue));
    Y1(i,:)=Population(max(c1),:);
    Population(max(c1),:)=[];
    Fn(i)=fitnessValue(max(c1));
    fitnessValue(:,max(c1))=[];
end

selectedIndex=e;

while selectedIndex <= populationSize-e
    selectedIndex = selectedIndex + 1;
    randPair = randperm(x-selectedIndex, 2); % wybór pary do turnieju
    if fitnessValue(:,randPair(1)) >= fitnessValue(:,randPair(2))
        Y1(selectedIndex+1,:)=Population(randPair(1),:);
        Fn(selectedIndex+1)=fitnessValue(:,randPair(1));
    else
        Y1(selectedIndex+1,:)=Population(randPair(2),:);
        Fn(selectedIndex+1)=fitnessValue(:,randPair(2));
    end

    Population(randPair(1),:) = [];
    fitnessValue(:,randPair(1)) = [];
    Population(randPair(2),:) = [];
    fitnessValue(:,randPair(2)) = [];
end

YY1 = Y1;
YY2 = Fn-1000; % odejmowanie zeby przywrocic poczatkowa wartosc(fitness)
end