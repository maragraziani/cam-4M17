function stop = saplotbestf(~,optimvalues,flag)
%SAPLOTBESTF PlotFcn to plot best function value.
%   STOP = SAPLOTBESTF(OPTIONS,OPTIMVALUES,FLAG) where OPTIMVALUES is a
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
%
%   Example:
%    Create an options structure that will use SAPLOTBESTF
%    as the plot function
%     options = optimoptions('simulannealbnd','PlotFcn',@saplotbestf);

%   Copyright 2006-2015 The MathWorks, Inc.

persistent thisTitle
temperature=zeros(5000,1);
stop = false;
switch flag
    case 'init'
        plotBest = plot(optimvalues.iteration, 0.365+optimvalues.fval);
       
        set(plotBest,'Tag','saplotbestf');
        xlabel('Iteration','interp','none');
        ylabel('Function value','interp','none')
        thisTitle = title(sprintf('Best Function Value: %g', 0.365+optimvalues.fval),'interp','none');
    case 'iter'
        plotBest = findobj(get(gca,'Children'),'Tag','saplotbestf');
        newX = [get(plotBest,'Xdata') optimvalues.iteration];
        newY = [get(plotBest,'Ydata'), 0.365+optimvalues.fval];
        set(plotBest,'Xdata',newX, 'Ydata', newY);
        if isempty(thisTitle)
            set(get(gca,'Title'),'String',sprintf('Best Function Value: %g', 0.365+optimvalues.fval));
        else
            set(thisTitle,'String',sprintf('Best Function Value: %g', 0.365+optimvalues.fval));
        end

end
