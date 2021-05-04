


function z = rastrigin(x)

    z = 10*columns(x)+sum(x.^2 - 10*cos(2*pi*x));

end
