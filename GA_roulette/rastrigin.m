


function z = rastrigin(x)

    z = 10*size(x,2)+sum(x.^2 - 10*cos(2*pi*x));

end
