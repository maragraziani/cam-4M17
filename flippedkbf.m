function f = flippedkbf(y)
%input is a long list of points
%returns a set of evaluations
for j = 1: size(y,1)
    x=y(j,:)';
    idxs = [1:size(y,2)];
    idxs = idxs';
    f(j) = ((sum(power(cos(x),4)) - 2*prod(power(cos(x),2))) / (sqrt(sum(idxs.*power(x,2)))));
    if ((prod(x)<0.75) || (sum(x)>15))
        f(j)=NaN;
end
end