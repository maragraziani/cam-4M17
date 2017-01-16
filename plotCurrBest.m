function stop = plotCurrBest(~,optimvalues,flag)

%   STOP = SAPLOTX(OPTIONS,OPTIMVALUES,FLAG) where OPTIMVALUES is a
%   structure with the following fields:
%              x: current point 
%           fval: function value at x
%          bestx: best point found so far
%       bestfval: function value at bestx
%    temperature: current temperature
%      iteration: current iteration
%      funccount: number of function evaluations
%             t0: start time
%              k: annealing parameter
%
%   OPTIONS: The options object created by using OPTIMOPTIONS
%
%   FLAG: Current state in which PlotFcn is called. Possible values are:
%           init: initialization state
%           iter: iteration state
%           done: final state
%
%   STOP: A boolean to stop the algorithm.

    stop = false;
    
%     disp(optimvalues.bestx)
    
    switch flag
        
        case 'init'
            
            %%%
            x1=linspace(0,10,100);
            x2=linspace(0,10,100);
            funz=nan;
%             funz=zeros(length(x1));
            for i=1:length(x1)
                for j=1:length(x1)
                    xp = [x1(j); x2(i)];
                        funz(i,j) = constrained_kbf(xp');
                end
            end
            contour(x1,x2,funz);
%             mesh(x1,x2,funz);

            hold on

%             scatterplot(optimvalues.bestx)
%             hold on
            
            lHandle = line(nan, nan);
            X = get(lHandle, 'XData');
            Y = get(lHandle, 'YData');
%             Z = get(lHandle, 'ZData');
            X = [X optimvalues.bestx(1)];
            Y = [Y optimvalues.bestx(2)];
%             Z = [Z optimvalues.bestf];
%             set(lHandle, 'XData', X, 'YData', Y, 'ZData', Z);
            scatter(optimvalues.bestx(1),optimvalues.bestx(2),20,'filled','r');
            set(lHandle, 'XData', X, 'YData', Y,'LineWidth',1.5,'Color','r');
            %%%
            
            set(gca,'xlimmode','manual','zlimmode','manual', ...
                'alimmode','manual')
            title('Current Best x','interp','none')
            Xlength = numel(optimvalues.x);
            Ylength = numel(optimvalues.x);
            xlabel(sprintf('x1',Xlength),'interp','none');
            ylabel('x2','interp','none');
%             zlabel('f','interp','none');
            
%             plotX = plot3(optimvalues.bestx(1),optimvalues.bestx(2),funz);
            plotX = plot(optimvalues.bestx(1),optimvalues.bestx(2));
            
            %%%
            set(lHandle,'Tag','plotCurrBestX');
%             set(plotX,'Tag','plotCurrBestX');
%             set(plotX,'edgecolor','none')
            set(gca,'xlim',[0 10])
            set(gca,'ylim',[0 10])
%             set(gca,'xlim',[0,1 + Xlength])
            %%%
            

        case 'iter'
                     
            
            %%% 
            lHandle = findobj(get(gca,'Children'),'Tag','plotCurrBestX');
%             plotX = findobj(get(gca,'Children'),'Tag','plotCurrBestX');
            X = get(lHandle, 'XData');
            Y = get(lHandle, 'YData');
            X = [X optimvalues.bestx(1)];
            Y = [Y optimvalues.bestx(2)];
%             Z = [Z optimvalues.bestf];
%             set(lHandle, 'XData', X, 'YData', Y, 'ZData', Z);
            scatter(optimvalues.bestx(1),optimvalues.bestx(2),20,'filled','r');
            set(lHandle, 'XData', X, 'YData', Y,'LineWidth',1.5,'Color','r');
            %%%
%             set(plotX,'Ydata',optimvalues.x(:))
%             set(plotX, 'XData', optimvalues.bestx(1), 'YData', optimvalues.bestx(1));
            
            %%%
        case 'done'
            scatter(optimvalues.bestx(1),optimvalues.bestx(2),35,'filled','k');
            hold off
            %%%
            
    end
    
end
