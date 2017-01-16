function f = constrained_kbf(y)
%input is a long list of points
%returns a set of evaluations
%CONSTRAINED. No need of putting constraints


numberOfVariables=length(y);

for j = 1: size(y,1)
    x=y(j,:)';
    idxs = [1:size(y,2)];
    idxs = idxs';
    f(j) = -((sum(power(cos(x),4)) - 2*prod(power(cos(x),2))) / (sqrt(sum(idxs.*power(x,2)))));
    if ((prod(x)<0.75) || (sum(x)>15*numberOfVariables/2))
       f(j)=0;
end
end