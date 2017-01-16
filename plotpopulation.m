function plotpopulation(pop)
global gen0 gen1 gen10 gen30
if pop==0
    pop=gen0;
end
if pop==1
    pop=gen1;
end
if pop==10
    pop=gen10;
end
if pop==30
    pop=gen30;
end


        scatter3(pop(:,1),pop(:,2),flippedkbf(pop),'filled','b')

end
