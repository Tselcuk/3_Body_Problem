%% 3-Body Problem 2D simulation - Tolga Selcuk
clear all % start with a clean workspace
close all
%% Simulation pars:
tic
% Delta times
dt_max = 1/2*10.^-5;  % Min Delta t for the simulation
% Maximum Plottime
t_max = 200;
% Plottime for plotting/saving data
dtplot = .1;  


%simulation time
t_now = 0;
dt_now = dt_max;  % Plottime for simulation

% Mass values for Planets
m1 = 5; m2 = 5; m3 = 9;
M = [m1, m2, m3];

% Initial velocity and relative position conditions
P  = [0 25 50; 0 0 0];  % Positions of the bodies
Vo = [-1.47 -1.47 -2; 3.32 3.32 -10.64];     % Initial velocities


% Gravitational constant (normalized to 1 in this simulation)
G = 30;

Plottime = 0: dtplot : t_max;

% Preallocate arrays for trajectory plotting
xPositions = zeros(3,length(Plottime));  % data stored as [index, time]
yPositions = xPositions;
vals = Plottime;
PlotConunter = 1;


% computational things
Rs = zeros(2,3);
ForceTerms  = zeros(2,3);
% Split P data as indexing is slow!
P1=P(:,1);
P2=P(:,2);
P3=P(:,3);

Vo1=Vo(:,1);
Vo2=Vo(:,2);
Vo3=Vo(:,3);


while t_now < t_max
    
    % Calculate forces on the bodies using pairwise distances
    % Matrix of all radius data
    % Force from body 2 on body 1
    
    r12 = P2-P1; % Displacement vector from body 1 to body 2
    F12 = G * M(1) * M(2) * r12 / norm(r12)^(3); % Gravitational force from body 2 on body 1
    
    % Force from body 3 on body 1
    r13 = P3-P1; % Displacement vector from body 1 to body 3
    F13 = G * M(1) * M(3)* r13 / norm(r13)^(3); % Gravitational force from body 3 on body 1
    
    % Force from body 3 on body 2
    r23 = P3-P2; % Displacement vector from body 2 to body 3
    F23 = G * M(2) * M(3) * r23 / norm(r23)^(3) ; % Gravitational force from body 3 on body 2
    
    
    % Recalculating Position for each body (vectorized)
    %P = P + Vo/2 * dt + ForceTerms * (dt^2); One option. Is faster
    %for this comp but slower later when computing r.
    
    
    P1 = P1 + Vo1/2 * dt_now + (F12   + F13) * (dt_now^2);
    P2 = P2 + Vo2/2 * dt_now + (-F12  + F23) * (dt_now^2);
    P3 = P3 + Vo3/2 * dt_now + (-F23  - F13) * (dt_now^2);
    % Recalculating Velocity for each body (vectorized)
    
    % Vo = Vo + ForceTerms * dt;
    
    Vo1 = Vo1 + (F12  + F13) * dt_now;
    Vo2 = Vo2 + (-F12 + F23) * dt_now;
    Vo3 = Vo3 + (-F23 - F13) * dt_now;
    
    
    t_now = t_now +  dt_now;
     
    dt_now= max(min(dt_max, (10^-2)*min(abs([r12./(abs(Vo1)+abs(Vo2));...
      r13./(abs(Vo1)+abs(Vo3));...
      r23./(abs(Vo2)+abs(Vo3))]))), 10^-7);
    
     
    
    
    % Store the current positions for trajectory plotting
    if t_now >= dtplot*PlotConunter  % force plot when sim time passes plot time
        xPositions (:,PlotConunter) = [P1(1);P2(1);P3(1)];
        yPositions (:,PlotConunter) = [P1(2);P2(2);P3(2)];
        PlotConunter = PlotConunter+1;
    end
    
end


toc


%% Plot the Solution

% Set up figure for plotting
figure(1);
axis([-200 60 -200 60]); % Adjust axis limits as needed
hold on;
grid on; % Add a grid for better visualization
xlabel('x');
ylabel('y');


% Initialize plot handles for bodies - Use struct to index then
plotHandle{1} = plot(P(1,1), P(2,1), 'ro', 'MarkerFaceColor', 'r'); % Body 1
plotHandle{2} = plot(P(1,2), P(2,2), 'go', 'MarkerFaceColor', 'g'); % Body 2
plotHandle{3} = plot(P(1,3), P(2,3), 'bo', 'MarkerFaceColor', 'b'); % Body 3



Cols = ['r';'g';'b']; % vector of colors
for i=1: 1 :length(Plottime)
    
    
    if max(abs(xPositions(:,i)))==0 % in case we did not exactly reach the end times
        break
    end
    % Plot the new positions of the bodies and their trajectories
    % for each mass
    for mass = 1 : 3
        plot(xPositions(mass,1:i), yPositions(mass,1:i), Cols(mass));
        set(plotHandle{mass}, 'XData', xPositions(mass,i), 'YData', yPositions(mass,i));
    end
    title(['Simulation Graphic at t =',num2str(Plottime(i)) ]);
    set(gca,'FontSize',20)
    drawnow
    
    % break if they fly off
    if (max(abs([xPositions(:,i);yPositions(:,i)]))>10^3)
        break
    end
     
end
