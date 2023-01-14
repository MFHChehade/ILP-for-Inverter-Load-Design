%% 
% User-assigned parameters:

DC_voltage = 900 ; 
Duty_cycle = 0.8 ; 
V = DC_voltage * sqrt(Duty_cycle) ;
Resistor_rating = 1500 ; 
I_lim = sqrt(Resistor_rating) ;
%% 
% Define optimization variables:

x1=optimvar('x1',1,'Type','integer','LowerBound',0,'UpperBound',Inf);
x2=optimvar('x2',1,'Type','integer','LowerBound',0,'UpperBound',Inf);
x3=optimvar('x3',1,'Type','integer','LowerBound',0,'UpperBound',Inf);
x4=optimvar('x4',1,'Type','integer','LowerBound',0,'UpperBound',Inf);
x5=optimvar('x5',1,'Type','integer','LowerBound',0,'UpperBound',Inf);
x6=optimvar('x6',1,'Type','integer','LowerBound',0,'UpperBound',Inf);
x7=optimvar('x7',1,'Type','integer','LowerBound',0,'UpperBound',Inf);
%DC_voltage=optimvar('DC_Voltage',1,'Type','integer','LowerBound',100,'UpperBound',900);
%Duty_cycle=optimvar('Duty_cycle',1,'Type','continuous','LowerBound',0.5,'UpperBound',0.85);
%% 
% Define slack variables:

z1=optimvar('z1',1,'Type','integer','LowerBound',0,'UpperBound',1);
z2=optimvar('z2',1,'Type','integer','LowerBound',0,'UpperBound',1);
z3=optimvar('z3',1,'Type','integer','LowerBound',0,'UpperBound',1);
z4=optimvar('z4',1,'Type','integer','LowerBound',0,'UpperBound',1);
z5=optimvar('z5',1,'Type','integer','LowerBound',0,'UpperBound',1);
z6=optimvar('z6',1,'Type','integer','LowerBound',0,'UpperBound',1);
z7=optimvar('z7',1,'Type','integer','LowerBound',0,'UpperBound',1);
%% 
% Assign R{eq} 

Req= x1 + 1/2*x2 + 1/3*x3 + 1/4*x4 + 1/5*x5 + 1/6*x6 + 1/7*x7 ;
%V=DC_voltage*sqrt(Duty_cycle);
%% 
% Define the objective function as a polynomial:

obj = x1 + 2*x2 + 3*x3 + 4*x4 + 5*x5 + 6*x6 + 7*x7 ;
%obj = Req ;
%% 
% Create an optimization problem:

prob = optimproblem('Objective',obj,'ObjectiveSense',"minimize");
%% 
% Assign slack constants:

M = 100000 ;
%M = 100 ;
epsilon = 1e-3 ;
%% 
% Assign special constants for current constrants:

K= V/I_lim ;
K1 = K ; 
K2 = K/2 ; 
K3 = K/3 ; 
K4 = K/4 ; 
K5 = K/5 ; 
K6 = K/6 ; 
K7 = K/7 ; 
%% 
% Define the technical constraint to have at least 1 resistor:

technical_constriant = obj>=1 ; 
%% 
% Add the technical constraint: 

prob.Constraints.technical = technical_constriant;
%% 
% Define the slack constraints:

slack_11 = 1 - x1 <= M*z1;
slack_12 = x1 - 1 <= M*(1-z1) - epsilon;
slack_21 = 1 - x2 <= M*z2;
slack_22 = x2 - 1 <= M*(1-z2) - epsilon;
slack_31 = 1 - x3 <= M*z3;
slack_32 = x3 - 1 <= M*(1-z3) - epsilon;
slack_41 = 1 - x4 <= M*z4;
slack_42 = x4 - 1 <= M*(1-z4) - epsilon;
slack_51 = 1 - x5 <= M*z5;
slack_52 = x5 - 1 <= M*(1-z5) - epsilon;
slack_61 = 1 - x6 <= M*z6;
slack_62 = x6 - 1 <= M*(1-z6) - epsilon;
slack_71 = 1 - x7 <= M*z7;
slack_72 = x7 - 1 <= M*(1-z7) - epsilon;
%% 
% Add the slack constraints:

prob.Constraints.slack11 = slack_11;
prob.Constraints.slack12 = slack_12;
prob.Constraints.slack21 = slack_21;
prob.Constraints.slack22 = slack_22;
prob.Constraints.slack31 = slack_31;
prob.Constraints.slack32 = slack_32;
prob.Constraints.slack41 = slack_41;
prob.Constraints.slack42 = slack_42;
prob.Constraints.slack51 = slack_51;
prob.Constraints.slack52 = slack_52;
prob.Constraints.slack61 = slack_61;
prob.Constraints.slack62 = slack_62;
prob.Constraints.slack71 = slack_71;
prob.Constraints.slack72 = slack_72;
%% 
% Define the current constraints: 

current_1= K1-Req <= M*z1 ;
current_2= K2-Req <= M*z2 + M*(1-z1) ;
current_3= K3-Req <= M*z3 + M*(1-z1) + M*(1-z2) ;
current_4= K4-Req <= M*z4 + M*(1-z1) + M*(1-z2) + M*(1-z3) ;
current_5= K5-Req <= M*z5 + M*(1-z1) + M*(1-z2) + M*(1-z3) + M*(1-z4) ;
current_6= K6-Req <= M*z6 + M*(1-z1) + M*(1-z2) + M*(1-z3) + M*(1-z4) + M*(1-z5) ;
current_7= K7-Req <= M*z7 + M*(1-z2) + M*(1-z3) + M*(1-z4) + M*(1-z5) + M*(1-z6) ;
%% 
% Add the current constraints:

prob.Constraints.current1 = current_1;
prob.Constraints.current2 = current_2;
prob.Constraints.current3 = current_3;
prob.Constraints.current4 = current_4;
prob.Constraints.current5 = current_5;
prob.Constraints.current6 = current_6;
prob.Constraints.current7 = current_7;
%% 
% Define overall current constraint:

%current_constraint=Req>=V/124.26 ; 
%% 
% Add overall current constraint: 

%prob.Constraints.current=current_constraint;
%% 
% Define the power constraint as a polynomial:

power_constraint = Req<=V^2/1e5 ;
%power_constraint = x1 + 2*x2 + 3*x3 + 4*x4 + 5*x5 + 6*x6 + 7*x7 <= 25 ;
%power_constraint2 = Req<=V^2/3e4 ;
%% 
% Add the power constraint:

prob.Constraints.power=power_constraint;
%prob.Constraints.power2=power_constraint2;
%% 
% Solve the problem:

[sol,fval,exitflag,output] = solve(prob)
%% 
%