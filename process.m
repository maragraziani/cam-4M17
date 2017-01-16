%% Postprocessing the results
clear all
% Specify experiment
experiment='A';
%% SA results

if experiment ~'E'

    directory=['results/SA/SA_' experiment '/'];
    files = dir([directory '*.mat']);

    log = cell(length(files), 7);
    i=1;

    for file = files'
        csv = load([directory file.name]);
        params = split(file.name, '_');
        % params:
        % 1. algo
        % 2. to
        % 3. to_value
        % 4. ri
        % 5. ri_value
        % 6. temperature function
        % 7. annealing function
        PS_value = str2double(params(3));
        crossprobab = str2double(params(5));
        tempf = params(6);
        mutationf = params(7);
        mean_opt = -mean(csv.optim);
        std_opt = std(csv.optim);

        log{i,1} = PS_value;
        log{i,2} = crossprobab;
        log{i,3} = mean_opt;
        log{i,4} = std_opt;
        log{i,5} = tempf;
        log{i,6} = mutationf;
        log{i,7} = mean(csv.evaluations);
        i=i+1;
    end

    optimums=cell2mat(log(:,3));
    max_opt=find(optimums==max(optimums));

    stds=cell2mat(log(:,4));
    min_std=find(stds==min(stds));

    log(max_opt,:)
    log(min_std,:)
end
%% Process GA results

directory=['results/exp2/GA/GA_' experiment '/'];
files = dir([directory '*.mat']);

log = cell(length(files), 6);
i=1;

for file = files'
    csv = load([directory file.name]);
    params = split(file.name, '_');
    % params:
    % 1. algo
    % 2. PS
    % 3. PS_value
    % 4. crossover fraction
    % 5. cfraction value
    % 6. repetitions
    % Do some stuff,
    
    PS_value = str2double(params(3));
    crossprobab = csv.GA_param.opts.CrossoverFraction;
    crossf = csv.GA_param.opts.CrossoverFcn;
    selectionf = csv.GA_param.opts.SelectionFcn;
    mean_opt = -mean(csv.optim); 
    std_opt = std(csv.optim);

    log{i,1} = PS_value;
    log{i,2} = crossprobab;
    log{i,3} = mean_opt;
    log{i,4} = std_opt;
    log{i,5} = crossf;
    log{i,6} = selectionf;
    log{i,7} = mean(csv.evaluations);
    i=i+1;
end

optimums=cell2mat(log(:,3));
max_opt=find(optimums==max(optimums));

stds=cell2mat(log(:,4));
min_std=find(stds==min(stds));

log(max_opt,:)
log(min_std,:)

%% SA Overall analysis
clear all
experiments=['A', 'B', 'C', 'D'];

tot_length=0
for e=experiments
    directory=['results/SA/SA_' e '/'];
    disp(directory)
    files = dir([directory '*.mat']);
    tot_length=tot_length+length(files);
end
log = cell(tot_length, 7);
    i=1;
for e=experiments
    directory=['results/SA/SA_' e '/'];
    files = dir([directory '*.mat']);
    for file = files'
        csv = load([directory file.name]);
        params = split(file.name, '_');
        % params:
        % 1. algo
        % 2. to
        % 3. to_value
        % 4. ri
        % 5. ri_value
        % 6. temperature function
        % 7. annealing function
        % Do some stuff

        PS_value = str2double(params(3));
        rivalue = str2double(params(5));
        tempf = params(6);
        annealf = params(7);
        mean_opt = -mean(csv.optim);
        std_opt = std(csv.optim);
        log{i,1} = PS_value;
        log{i,2} = rivalue;
        log{i,3} = mean_opt;
        log{i,4} = std_opt;
        log{i,5} = tempf;
        log{i,6} = annealf;
        log{i,7} = mean(csv.evaluations);
        i=i+1;
    end
end
%% SA Temperature
PSs=unique(cell2mat(log(:,1)));

for i=1:length(PSs)
    mean_PSs(i)=mean(cell2mat(log(find(cell2mat(log(:,1))==PSs(i)),3)));
    std_PSs(i)=std(cell2mat(log(find(cell2mat(log(:,1))==PSs(i)),4)));
end
log_PSs=[PSs, mean_PSs', std_PSs']

bar(mean_PSs+std_PSs)
hold on
bar(mean_PSs)
bar(mean_PSs-std_PSs)

%% SA Number of trials before reanniling

re_values=unique(cell2mat(log(:,2)));

for i=1:length(re_values)
    mean_revalues(i)=mean(cell2mat(log(find(cell2mat(log(:,2))==re_values(i)),3)));
    std_revalues(i)=std(cell2mat(log(find(cell2mat(log(:,2))==re_values(i)),4)));
end
log_reannealing=[re_values, mean_revalues', std_revalues']


figure 
hold on
plot(re_values, mean_revalues-3*std_revalues)
plot(re_values, mean_revalues)
plot(re_values, mean_revalues+3*std_revalues)

%% SA Max value
max_index=max(cell2mat(log(:,3)))
log(max_index,:)
   

%% GA Overall analysis
clear all
experiments=['A', 'B', 'C', 'D', 'E'];

tot_length=0
for e=experiments
    directory=['results/GA/GA_' e '/'];
    disp(directory)
    files = dir([directory '*.mat']);
    tot_length=tot_length+length(files);
end
log = cell(tot_length, 7);
    i=1;
for e=experiments
    directory=['results/GA/GA_' e '/'];
    files = dir([directory '*.mat']);
    for file = files'
       csv = load([directory file.name]);
    params = split(file.name, '_');
    % params:
    % 1. algo
    % 2. PS
    % 3. PS_value
    % 4. crossover fraction
    % 5. cfraction value
    % 6. repetitions
    % Do some stuff
    
    PS_value = str2double(params(3));
    crossprobab = csv.GA_param.opts.CrossoverFraction;
    crossf = csv.GA_param.opts.CrossoverFcn;
    selectionf = csv.GA_param.opts.SelectionFcn;
    mean_opt = -mean(csv.optim); 
    std_opt = std(csv.optim);
    

    log{i,1} = PS_value;
    log{i,2} = crossprobab;
    log{i,3} = mean_opt;
    log{i,4} = std_opt;
    log{i,5} = crossf;
    log{i,6} = selectionf;
    log{i,7} = floor(mean(csv.evaluations));
    log{i,8} = floor(mean(csv.generations));;
    i=i+1;
    end
end
%%  GA Population Size
PSs=unique(cell2mat(log(:,1)));

for i=1:length(PSs)
    mean_PSs(i)=mean(cell2mat(log(find(cell2mat(log(:,1))==PSs(i)),3)));
    std_PSs(i)=std(cell2mat(log(find(cell2mat(log(:,1))==PSs(i)),4)));
end
log_PSs=[PSs, mean_PSs', std_PSs']

plot(PSs, mean_PSs+3*std_PSs)
hold on
plot(PSs, mean_PSs)
plot(PSs, mean_PSs-3*std_PSs)

hold on
plot(PSs, 15*std_PSs)

%% Max value

max=max(cell2mat(log(:,3)))

%% NUMBER OF GENERATIONS

PSs=unique(cell2mat(log(:,1)));


for i=1:length(PSs)
     no_gen(i)=floor(mean(cell2mat(log(find(cell2mat(log(:,1))==PSs(i)),8))));
end

plot(PSs, no_gen)
hold on
plot(PSs, 10*mean_PSs)


%% crossover pb

cv=unique(cell2mat(log(:,2)));
PSs=unique(cell2mat(log(:,1)));


for i=1:length(cv)
     mean_cvs(i)=mean(cell2mat(log(find(cell2mat(log(:,2))==cv(i)),3)));
    
end

plot(cv, mean_cvs)

