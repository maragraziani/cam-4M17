function flag = verifyConstraints(x)
  global GA_param
   flag = true;
   if any(x<GA_param.LB) || any(x>GA_param.UB) || prod(x)<=0.75 || sum(x)>=15*GA_param.numberOfVariables/2
       flag = false;
   end
   
end