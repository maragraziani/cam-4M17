function [c, ceq] = gaconstraints(x)
  c=[-prod(x)+0.75];
  ceq=[];
end