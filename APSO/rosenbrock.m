

function z = rosenbrock(x)

z=0;
	for i=1:(columns(x)-1) 
		z = z+100*(x(i+1)-x(i)^2)^2+(1-x(i))^2;
	end
end
