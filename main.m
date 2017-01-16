v%% Evaluation of Siulated Annealing and Genetic Algorithms 
%   on Keane's Bump function

%% Initialisation global parameters:
% SA_param STRUCT: 
% SA_param.numberOfVariables = problem dimensionality (2, 10)
% SA_param.ObjectiveFunction = handle to KBF 
% SA_param.saopts = struct with the parametrisation for SA 
% SA_param.seed = seed for the initialisation of the solution
%
%
% GA_param STRUCT: 
%     GA_param.UB,
%     GA_param.opts,
%     GA_param.seed,
%     GA_param.numberOfVariables, 
%     GA_param.A, 
%     GA_param.b, 
%     GA_param.FitnessFunction,
%     GA_param.ConstraintFunction,
%     GA_param.LB
% %
%

global SA_param
global GA_param

%% Preferences
% Environmental setup for running the experiments

PLOT_BUMP=0; % Set PLOT_BUMP=1 to plot the Keane's Bump Function
MULTIPLE_RUNS=10; % set MULTIPLE_RUNS = N to repeat N times the experiments
MAX_EVALUATIONS=5000;
SOLVE_2D=0; % set SOLVE_2D=1 to tune the parameters on the 2D function 
SA_OFF=0; % SA_OFF=1 turns off the excution of SA
GA_OFF=0; % GA_OFF=1 turns off the excution of SA

%% Experiments
% Select the experiment to perform with EXPERIMENT='option'
% Options list:
% 
%     A = SA(fast temperature, fast annealing); 
%          GA(scattered crossover, roulette selection) ;
% 
%     B = SA(fast temperature, Boltz annealing);
%          GA(scattered crossover, tournament selection) ;
% 
%     C = SA(exponential temperature, fast annealing);
%          GA(intermediate crossover, roulette selection) ;
% 
%     D = SA(exponential temperature, Boltz annealing);
%          GA(intermediate crossover, tournament selection) ;
% 
% Extension of the experiments on GA: Experiment E
%     E = GA(intermediate crossover, tournament selection) ;
% 
% For example: EXPERIMENT='A'

EXPERIMENT = 'E';

%% SA general settings:
% Experimental ranges, saving folder ect.

% Directory where to save the experimental configuration and
% results
 saving_directory_SA=['results/exp2/SA/SA_' EXPERIMENT '/'];
 mkdir(saving_directory_SA); 
 
% Initial temperatures to evaluate
 interval_temperature=[30, 40, 50, 60, 100, 200, 500]; 
% Reannealing invervals to evaluate
 interval_reannealing=[5, 10, 30, 50, 100, 200, 500];
%% GA_settings:
% Experimental ranges, saving folder ect.

% Directory where to save the experimental configuration and
% results
  saving_directory_GA=['results/exp2/GA/GA_' EXPERIMENT '/'];
  mkdir(saving_directory_GA);
  
% Population sizes to evaluate 
  PSvec=[20, 40, 50, 100, 150, 200, 400];
  
% Crossover probabilities to evaluate 
  crossover_fraction = [0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95];
  
% set GA_MANUAL_CONSTRAINTS=0 to use the
% MATLAB constraints handling function
  GA_MANUAL_CONSTRAINTS = 1; 

% set PLOT_BEST_10D = 1 to plot the 0th, 1st, 10th and 30th generation
% solution over the 2D problem
  PLOT_BEST_10D = 0
  if PLOT_BEST_10D
      SOLVE_2D=1;
      PSvec=150;
      crossover_fraction=0.95     
  end

%% Keane's Bump
% to visualise the bump set the 'PLOT_BUMP' flag to 1.

if PLOT_BUMP
% 3D visualisation of the function
    plotobjective(@flippedkbf,[0 10; 0 10]);
% 2D contours visualisation    
    figure
    plotcontours
end
%% Evaluation Dataset Parameters

% Creation of the common set of seeds that will be shared
% by both GA and SA  
no_multiple_runs = MULTIPLE_RUNS;
seeds=[1:no_multiple_runs];

%% Saving Data Structure Initialisation

% number of algorithm iterations
iterations=zeros(no_multiple_runs,1);
% number of function evaluations
evaluations=zeros(no_multiple_runs,1);
% final temperature
temperature=zeros(no_multiple_runs, 10);
% CPU time 
time=zeros(no_multiple_runs,1);
% best x
solutions= zeros(no_multiple_runs, 10);
% best f(x)
optim= zeros(no_multiple_runs, 1); 

% best generation
generations=zeros(no_multiple_runs,1);
% population sizes
populationSize=zeros(no_multiple_runs,1);

%% Setting up the environment 

switch EXPERIMENT
    case 'A' 
        disp 'Experiment A'
        % SA options
        temperature_function = @temperaturefast;
        annealing_function = @annealingfast;
        % GA options
        crossover_function = @crossoverscattered; 
        selection_function = @selectionroulette;
        
    case 'B'
        disp 'Experiment B'
        % SA options
        temperature_function = @temperaturefast;
        annealing_function =  @annealingboltz;
        % GA options
        crossover_function = @crossoverscattered; 
        selection_function = @selectiontournament;
         
    case 'C' 
        disp 'Experiment C'
        % SA options
        temperature_function =  @temperatureexp;
        annealing_function =  @annealingfast;
        % GA options
        crossover_function = @crossoverintermediate;
        selection_function = @selectionroulette;
       
    case 'D'
        disp 'Experiment D'
        % SA options
        temperature_function =  @temperatureexp;
        annealing_function =  @annealingboltz;
        % GA options
        crossover_function = @crossoverintermediate;
        selection_function = @selectiontournament;
      
    case 'E'
        disp 'Experiment E'
        % no SA options
        SA_OFF=1;
        % GA options
        crossover_function = @crossoverscattered; 
        selection_function = @selectionremainder;
         
end
%% Simulated Annealing

if SOLVE_2D && ~SA_OFF
    %Tuning in 2D
    SA_param.numberOfVariables=2;
    
    SA_param.seed=seeds(1);  % no multiple runs for the 2D case
    
    SA_param.ObjectiveFunction=@kbf;
    saopts=saoptimset();
    saopts.MaxFunEvals = MAX_EVALUATIONS;
    
    %saopts.PlotFcns=@plotCurrBest;
    %saopts.PlotFcns=@plot_objectivereduction;
   
    saopts.AcceptanceFcn= @saconstraints;

    saopts.TemperatureFcn = temperature_function;
    saopts.AnnealingFcn = annealing_function;
    
    saopts.InitialTemperature=100;
    saopts.ReannealInterval=100;
    
    SA_param.saopts=saopts;
    [x,fval,exitFlag,output]= SA;
end

if ~SOLVE_2D && ~SA_OFF
    %10D problem
    SA_param.numberOfVariables=10;
    % Creating a set of parameters for SA
    saopts=saoptimset();
    % Maximum number of function evaluations
    saopts.MaxFunEvals = MAX_EVALUATIONS;
    % Specification of the objective function
    SA_param.ObjectiveFunction=@kbf;
    % Handling constraints
    saopts.AcceptanceFcn= @saconstraints;
    
    % Setting Temperature decrease function
    saopts.TemperatureFcn = temperature_function;
    % Setting annealing funciton (generation of new solutions)
    saopts.AnnealingFcn = annealing_function;
   
    % Iterating over the initial temperatures to evaluate
    for temp=interval_temperature
        % Setting initial temperature
        saopts.InitialTemperature=temp;
        % Iterating over the initial reannealing interavs to evaluate
        for rean_int=interval_reannealing
            % Setting the reannealing interval
            saopts.ReannealInterval=rean_int;
            % Passing all the configurations to the global variable
            % SA_param
            SA_param.saopts=saopts;
            % Saving name of the experiment generation
            % pattern:
            % T0_InitialTemperature_
            % RI_ReannealingInterval_
            % repetitions_numberOfRepeatedExperiments
            name=['T0_' num2str(saopts.InitialTemperature) '_RI_' num2str(saopts.ReannealInterval) '_repetitions' num2str(length(seeds))]
            % Repeating the experiment to achieve statistical significance
            for s=1:length(seeds)
                % Setting the seed
                SA_param.seed=seeds(s);
                SA_param.saopts=saopts;
                disp(['Currently running evaluation n. ' num2str(s)])
                
                % Running SA
                [x,fval,exitFlag,output]= SA;
                
              % Storing results
                iterations(s,:)=output.iterations;
                evaluations(s,:)=output.funccount;
                temperature(s,:)=output.temperature;
                time(s,:)=output.totaltime;
                solutions(s,:)= x; 
                optim(s,:)= fval; 
            end
            
          % Saving
            save([saving_directory_SA 'SA_' name '.mat'], 'iterations', ...
                    'evaluations', 'temperature', ...
                    'time', 'solutions', ...
                    'optim', 'SA_param');
        end
    end
end

%% Genetic Algorithms
   
 if SOLVE_2D && ~GA_OFF
    % Solving in 2D
    GA_param.numberOfVariables= 2;
    
    GA_param.seed=seeds(1);%only one seed - one run for 2d probs
   
    
    if ~GA_MANUAL_CONSTRAINTS
        % Handling Constraints: way 1
        GA_param.FitnessFunction = @kbf;
        GA_param.ConstraintFunction = @gaconstraints;
        % Linear Constraints
        GA_param.A=ones(GA_param.numberOfVariables,1)';
        GA_param.b=15/2*GA_param.numberOfVariables;
    else
        % Handling Constraints: way 2
         GA_param.ConstraintFunction = []; 
         % assigning 0 fitness to unacceptable solutions
         GA_param.FitnessFunction = @constrained_kbf; 
         GA_param.A=[];
         GA_param.b=[];
    end
 
    GA_param.opts=optimoptions('ga');

    GA_param.opts.CrossoverFcn= crossover_function;
    GA_param.opts.CrossoverFraction= 0.95;
    
    GA_param.opts.FitnessScalingFcn=@fitscalingprop;
    
    GA_param.opts.MutationFcn ={@mutationadaptfeasible};
   
    GA_param.opts.SelectionFcn=selection_function;
    % Setting a fixed population size for the 2D problem
    PS=PSvec(3);
    MSG=10;
    % Computing the Maximum Generations as shown in the report
    MG=floor((5000-MSG*PS)/PS);
        
    GA_param.opts.PopulationSize = PS;
    GA_param.opts.Display='final';
    
    if PLOT_BEST_10D
        GA_param.opts.PlotFcn=@plotCurrPopulation;
        global gen0 gen1 gen10 gen30
        GA_param.opts.PlotFcn=@plotGenerations;
    else
        GA_param.opts.PlotFcn=@gaplotbestf;
    end
    
    GA_param.opts.MaxGenerations=MG;
    GA_param.opts.MaxStallGenerations=MSG;
    GA_param.opts.InitialPopulationRange = [0 0; 10 10];        

    [x,Fval,exitFlag,Output,population,scores]=GA;
    
    if PLOT_BEST_10D
        figure
        subplot(2,2,1)
        plotcontours
        plotpopulation(0)
        subplot(2,2,2)
        plotcontours
        plotpopulation(1)
        subplot(2,2,3)
        plotcontours
        plotpopulation(10)
        subplot(2,2,4)
        plotcontours
        plotpopulation(30)
    end
 end
 
 if ~SOLVE_2D && ~GA_OFF
    % 10D problem
    % Creating a set of options for GA
    GA_param.opts=optimoptions('ga');
    % Removing plot functions
    GA_param.opts.PlotFcn=[];
    
    % Setting crossover function
    GA_param.opts.CrossoverFcn = crossover_function;
    % Setting parents selection function
    GA_param.opts.SelectionFcn = selection_function;
    % Setting mutation function
    GA_param.opts.MutationFcn= {@mutationadaptfeasible};
    % Setting fitness scaling function
    GA_param.opts.FitnessScalingFcn=@fitscalingprop;
    % Iterating over the crossover probabilities to evaluate
    for c_fraction=crossover_fraction
        % Setting the crossover probability
        GA_param.opts.CrossoverFraction= c_fraction;
        % Iterating over the Population Sizes to evaluate
        for p=1:length(PSvec)
            % Setting the Population size
            PS=PSvec(p); 
            % Computing the Maximum No of Generations as shown in the
            % Report
            MSG=10;
            MG=floor((5000-MSG*PS)/PS);
            % Setting the Population Size
            GA_param.opts.PopulationSize = PS;
            GA_param.opts.Display='final';
            % Setting the number of generations
            GA_param.opts.MaxGenerations=MG;
            GA_param.opts.MaxStallGenerations=MSG;
            % Setting the boundaries for the initial population generation
            GA_param.opts.InitialPopulationRange = [0 0; 10 10];  
            % Setting the file name with the following pattern
            % PS_PopulationSize
            % crossFrac_crossoverProbability
            % repetitions_numberOfExperimentRepetitions
            name=['PS_' num2str(PS) '_crossFrac_' num2str(c_fraction) '_repetitions_' num2str(length(seeds))]
            % Repeating the experiment to achieve statistical significance
            for s=1:length(seeds)
                disp(['Currently running evaluation n. ' num2str(s)])
                % Setting the seed
                GA_param.seed=seeds(s);
                % Setting the number of Variables to 10
                GA_param.numberOfVariables= 10;
                % Handling Linear Constraints
                GA_param.A=ones(GA_param.numberOfVariables,1)';
                GA_param.b=15/2*GA_param.numberOfVariables;
                if ~GA_MANUAL_CONSTRAINTS
                % Handling Nonlinear Constraints: preimplemented version
                    GA_param.FitnessFunction = @kbf;
                    GA_param.ConstraintFunction = @gaconstraints;
                else
                % Handling Nonlinear Constraints: manual version
                % NOTE: this method needs constrained_kbf as
                % FitnessFunction
                    GA_param.FitnessFunction = @constrained_kbf;
                    GA_param.ConstraintFunction = []; 
                end
                tic
                % Running GA
                [x,fval,exitFlag,output,population,scores]=GA();
                % Saving the CPU time
                time=toc;

              % Storing results
                generations(s,:)=output.generations;
                evaluations(s,:)=output.funccount;
                populationSize(s,:)=PS;
                time(s,:)=time;
                solutions(s,:)= x; 
                optim(s,:)= fval;

            end  
               % Saving
                save([saving_directory_GA 'GA_' name '.mat'], 'generations', ...
                        'evaluations', 'populationSize', ...
                        'time', 'solutions', ...
                        'optim', 'GA_param');
        end
     end
end
 
