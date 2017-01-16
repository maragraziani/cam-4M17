function acceptpoint = saconstraints(optimValues,newx,newfval)

%   OPTIMVALUES is a structure containing the following information:
%              x: current point 
%           fval: function value at x
%          bestx: best point found so far
%       bestfval: function value at bestx
%    temperature: current temperature
%      iteration: current iteration 
%             t0: start time
%              k: annealing parameter
%
%   NEWX: new point 
%
%   NEWFVAL: function value at NEWX

   
   %% standard

   delE = newfval - optimValues.fval;

   % If the new point is better accept it
   if delE < 0
       acceptpoint = true;
   % Otherwise, accept it randomly based on a Boltzmann probability density
   else
       h = 1/(1+exp(delE/max(optimValues.temperature)));
       if h > rand
           acceptpoint = true;
       else
           acceptpoint = false;
       end
   end

   
   %% specfic
   
	n=size(optimValues.x,2);
   
   if acceptpoint==true && prod(newx)>0.75 && sum(newx)<15*n/2
       acceptpoint = true;
   else
       acceptpoint = false;
   end
   
%     if acceptpoint==true && length(find(newx<0))==0 && length(find(newx>10))==0
%         acceptpoint = true;
%     else
%         acceptpoint = false;
%     end
   
end

