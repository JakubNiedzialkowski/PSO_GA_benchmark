function Y=mutation(P,n)
% P = populacja
% n = chromosomy do zmutowania
[x1 y1]=size(P);
Z=zeros(n,y1);
for i = 1:n
    r1=randi(x1);
    A1=P(r1,:); % wybranie losowego osobnika
    r2=randi(y1); % losowanie indeksu bitu do zmiany
    if A1(1,r2)== 1
        A1(1,r2) = 0; % zmiana stanu bitu
    else
        A1(1,r2) = 1;
    end
    Z(i,:)=A1;
end
Y=Z;