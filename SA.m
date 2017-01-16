%% Simulated Annealing Algorithm
% The main structure of the algorithm is the following:\\
%  1. Initialisation. Generation of an initial random solution\\ 
%  2. Estimation of the initial temperature\\
%  3. Repeat:\\
%  	\space \space a. Generate new solution\\
%     \space \space b. Test new solution\\
%     \space \space c. If the new solution is accepted, update the archive\\
%     \space \space d. Adjust temperature (annealing)\\
%   Until the search is completed\\

function  [x,fval,exitFlag,output]= SA()
 global SA_param  

 %% Init 
    rand('seed', SA_param.seed);
    numberOfVariables = SA_param.numberOfVariables;
    ObjectiveFunction = SA_param.ObjectiveFunction;
    
  % Initial state
    X0 = unifrnd(0,10,1,numberOfVariables); 

  % Lower and upper boundaries 
    LB = double(zeros(numberOfVariables,1));    
    UB = zeros(numberOfVariables,1)+10;  

  % Setting SA basic options
    saopts=SA_param.saopts;

  %% Optimisation

    [x,fval,exitFlag,output] = simulannealbnd(ObjectiveFunction,X0,LB,UB, saopts);

    fprintf('The number of iterations was : %d\n', output.iterations);
    fprintf('The number of function evaluations was : %d\n', output.funccount);
    fprintf('The best function value found was : %g\n', fval);

end

