function [x1,y1,x2,y2,x3,y3,time] = compute3BodyPaths(M,P,Vo,dt)
% 3-Body Problem 2D simulation - Tolga Selcuk
%  [x1,y1,x2,y2,x3,y3] = compute3BodyPaths(M,P,Vo)
% INPUT ARGUMENTS
% M = Mass values for planets ( e.g. M = [5,5,9] )
% P = Positions of the planets ( e.g. P = [0 25 50; 0 0 0])
% Vo = Initial Velocities (e.g. Vo = [-1.47 -1.47 -2; 3.32 3.32 -10.64])
% dt = Time step for simulation (e.g. dt = 0.00005)

% Gravitational constant (normalized to 1 in this simulation)
G = 30;

time = 0:dt:100;

% Preallocate arrays for trajectory plotting
x1 = 0*time; y1 = x1;
x2 = x1;     y2 = x1;
x3 = x1;     y3 = x1;
fprintf("Computing\n");
tic
for i = 1:1:length(time)

    % Calculate forces on the bodies using pairwise distances
    % Force from body 2 on body 1
    r12 = P(:,2) - P(:,1); % Displacement vector from body 1 to body 2
    distance12 = norm(r12); % Euclidean distance between body 1 and body 2
    F12 = G * M(1) * M(2) * r12 / distance12^3; % Gravitational force from body 2 on body 1

    % Force from body 1 on body 2 (opposite direction)
    F21 = -F12;

    % Force from body 3 on body 1
    r13 = P(:,3) - P(:,1); % Displacement vector from body 1 to body 3
    distance13 = norm(r13); % Euclidean distance between body 1 and body 3
    F13 = G * M(1) * M(3) * r13 / distance13^3; % Gravitational force from body 3 on body 1

    % Force from body 1 on body 3 (opposite direction)
    F31 = -F13;

    % Force from body 3 on body 2
    r23 = P(:,3) - P(:,2); % Displacement vector from body 2 to body 3
    distance23 = norm(r23); % Euclidean distance between body 2 and body 3
    F23 = G * M(2) * M(3) * r23 / distance23^3; % Gravitational force from body 3 on body 2

    % Force from body 2 on body 3 (opposite direction)
    F32 = -F23;

    % Recalculate positions using the net forces
    % Recalculating Position for each body
    P(:,1) = P(:,1) + Vo(:,1)/2 * dt + (F12 + F13) * (dt^2); 
    P(:,2) = P(:,2) + Vo(:,2)/2 * dt + (F21 + F23) * (dt^2); 
    P(:,3) = P(:,3) + Vo(:,3)/2 * dt + (F32 + F31) * (dt^2);
    
    % Recalculating Velocity for each body
    Vo(:,1) = Vo(:,1) + (F12 + F13) * dt;
    Vo(:,2) = Vo(:,2) + (F21 + F23) * dt;
    Vo(:,3) = Vo(:,3) + (F32 + F31) * dt;

    % Store the current positions for trajectory plotting
    x1(i) = P(1,1);
    y1(i) = P(2,1);
    x2(i) = P(1,2);
    y2(i) = P(2,2);
    x3(i) = P(1,3);
    y3(i) = P(2,3);

end
toc
end