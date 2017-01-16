function plotcontours()

x1=linspace(0,10);
    x2=linspace(0,10);
    for i=1:length(x1)
        for j=1:length(x2)
            z(i,j)=flippedkbf([x1(i) x2(j)]);
        end
    end
    contour(x1,x2,z);
    hold on
end