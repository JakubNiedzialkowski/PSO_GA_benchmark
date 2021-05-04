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
D=fitnessValue/sum(fitnessValue); %Okreslanie prawdopodobienstwa selekcji
E=cumsum(D); %Okreslenie lacznego prawdopodobienstwa
N=rand(1); % generacja wektora ograniczajacego znormalizowane liczby losowe
d1=1;
d2=e;
while d2 <= populationSize-e
    if N <= E(d1)
        Y1(d2+1,:)=Population(d1,:);
        Fn(d2+1)=fitnessValue(d1);
        N=rand(1);
        d2 = d2 + 1;
        d1=1;
    else
        d1 = d1+1;
    end
end
YY1 = Y1;
YY2 = Fn-1000; % odejmowanie zeby przywrocic poczatkowa wartosc(fitness)
end