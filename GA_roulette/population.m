function Y = population(n, precision, lowerBound, upperBound, nVar)

    % n = wielkosc populacji
    
    % Ilosc bitow w reprezentacji zmiennych zalezna jest od wymaganej
    % dokladnosci

    % Przykladowo precyzja to 5 miejsc po przecinku
    % Zmienne losowe sa z przedzialu -5 do 5 wiec potrzeba 20 bitow na kazda
    % zmienna
    % Wzor ogolny 2^(m-1) < (gorna granica - dolna granica)*10^p < 2^m-1 
    % p=5, m=20

    % aproksymacja wartosci m
    m = ceil(log2((upperBound-lowerBound)*10^precision+1));

    % inicjalizacja populacji n osobnikow po m bitów na kazda zmienna decyzyjna
    Y=round(rand(n,m*nVar));