% Initialise variables
M = [5,5,9]; % Mass values for planets
P = [0 25 50; 0 0 0]; %  P = Positions of the planets
Vo = [-1.47 -1.47 -2; 3.32 3.32 -10.64]; % Vo = Initial Velocities
dt = 0.00005;

% Compute paths
[x1,y1,x2,y2,x3,y3,time] = compute3BodyPaths(M,P,Vo,dt);

% Produce Plot
plotPaths(x1,y1,x2,y2,x3,y3,time,dt);