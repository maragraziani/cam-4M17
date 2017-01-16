function state = plotGenerations(~,state,flag)
global gen0 gen1 gen10 gen30

    if state.Generation==0
        disp in
        gen0=state.Population;
    end 
    if state.Generation==1
        gen1=state.Population;
    end 
    if state.Generation==10
        gen10=state.Population;
    end 
    if state.Generation==30
        gen30=state.Population;
    end 
    
    