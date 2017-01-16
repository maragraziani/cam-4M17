%% Genetic Algorithms
%The fittest individuals of the population will be selected to reproduce 
%and pass their 'positive sides' to the next generation. 
%The main structure of the GA algorithm is the following:\\
% 1. Init. Initial population random generation\\ 
% 2. Assessment of the initial population fitness\\
% 3. Repeat:\\
% 	\space \space a. Parents selection\\
%    \space \space b. Breeding with crossover and mutation\\
%    \space \space c. New population assesment and archive updates\\
%  Until the search is completed\\

function [x,fval,exitFlag,output,population,scores]=GA()
  global GA_param;
  
 %% Init 
    rand('seed', GA_param.seed);
    numberOfVariables = GA_param.numberOfVariables;
    FitnessFunction = GA_param.FitnessFunction;
    PS=GA_param.opts.PopulationSize;
  
  % Lower and upper boundaries 
    LB = double(zeros(numberOfVariables,1));    
    UB = zeros(numberOfVariables,1)+10;  
    
    GA_param.LB=LB;
    GA_param.UB=UB;
  % Linear Constraints
    A = GA_param.A;
    b = GA_param.b;
  
  % Nonlinear Constraints
    nonlincon=GA_param.ConstraintFunction;
  
  % Initial population
    IPM=unifrnd(0,10,PS,numberOfVariables);
        for i=1:PS
        while ~verifyConstraints(IPM(i,:)')
            IPM(i,:)=unifrnd(0,10,1,numberOfVariables);
        end
        end
    GA_param.opts.InitialPopulationMatrix=IPM;
    
  
  % Setting GA basic options
  
    gaopts=GA_param.opts;

  %% Optimisation
  
    [x,fval,exitFlag,output,population,scores] = ga(FitnessFunction, numberOfVariables,A, b, ...
        [], [], LB, UB, nonlincon, gaopts);

    fprintf('The number of generations was : %d\n', output.generations);
    fprintf('The number of function evaluations was : %d\n', output.funccount);
    fprintf('The best function value found was : %g\n', fval);
end
