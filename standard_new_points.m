function newx = standard_new_points(optimValues,problem)
%blabla
C=4;
nvar=length(optimValues.x);
u=unifrnd(-1,1,1,nvar);
newx=optimValues.x + C*u;
end