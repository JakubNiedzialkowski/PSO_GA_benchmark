function Y=evaluation(P, lowerBound, upperBound, nVar, costFunction)
[x1 y1]=size(P);
values=zeros(1,x1);
positions = zeros(1,nVar);
interval = y1/nVar; %ilosc bitow reprezentujaca jedna zmienna
for i = 1:x1
    for n = 1:nVar
        %konwersja z wartosci binarnej na decymalna
        temp = bi2de(P(i, (interval*(n-1)+1):interval*n));
        %rzutowanie zapisanej wartosci binarnej z przedzialu <0;1> na docelowy przedzial zmiennych
        value = lowerBound + temp*(upperBound - lowerBound)/(2^interval-1);
        positions(n) = value;
    end
    %obliczanie wartosci funkcji dopasowania
    values(1,i)= costFunction(positions);
end
Y=-values; 