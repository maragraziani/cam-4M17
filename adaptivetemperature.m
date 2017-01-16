function temperature = temperatureexp(optimValues,options)
%ADAPTIVETEMPERATURE Updates the temperature vector for annealing process 
%blablbals
alpha=max(0.5, exp(-0.7.*options.InitialTemperature./std(optimValues.k)))
temperature = options.InitialTemperature.*alpha.^optimValues.k;

