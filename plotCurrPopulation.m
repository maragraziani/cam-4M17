function state = plotCurrPopulation(~,state,flag)
global n lb ub
% disp(state)
if  size(state.Score,2) > 1
   title('Best Individual Plot: not available','interp','none');
   return;
end

switch flag
   
   case 'init'
       
 hold on
    plotobjective(@flippedkbf,[0 10; 0 10]);
    
    for i=1:length(state.Population(:,2))
        scatter3(state.Population(i,1),state.Population(i,2),flippedkbf(state.Population(i,:)),'filled','g')
    end
       
   case 'iter'
       
%         h = findobj(get(gca,'Children'),'Tag','plotCurrPopulation');
       lHandle = findobj(get(gca,'Children'),'Tag','plotBestX');
       
        
        c=rand(1,3);
       for i=1:size(state.Population,1)
           %scatter(state.Population(i,1),state.Population(i,2),20,'y');
           scatter3(state.Population(i,1),state.Population(i,2),flippedkbf(state.Population(i,:)),'MarkerEdgeColor',c);
       end
       
       [~,j] = min(state.Score);
           X = get(lHandle, 'XData');
           Y = get(lHandle, 'YData');
           X = [X state.Population(j,1)];
           Y = [Y state.Population(j,2)];
%             Z = [Z optimvalues.bestf];
%             set(lHandle, 'XData', X, 'YData', Y, 'ZData', Z);
           set(lHandle, 'XData', X, 'YData', Y,'LineWidth',2,'Color','r');
       scatter3(state.Population(j,1),state.Population(j,2),flippedkbf(state.Population(j,:)),30,'r','*');
       
%         set(h_temp,'Visible','off')
end
end