function  plotPaths(x1,y1,x2,y2,x3,y3,time,dt)
%PLOTPATHS Plots the paths computed by compute3BodyPaths
fprintf("Making Animation\n");
tic

% Plot the objects
h1 = plot(x1(1), y1(1), 'ro', 'MarkerFaceColor', 'r'); 
axis([-100 60 -100 60]); % Adjust axis limits as needed
grid on; % Add a grid for better visualization;
xlabel('x');
ylabel('y');

hold on
h2 = plot(x2(1), y2(1), 'go', 'MarkerFaceColor', 'g');
h3 = plot(x3(1), y3(1), 'bo', 'MarkerFaceColor', 'b');
% Plot the trails
t1 = plot(NaN, NaN, 'r-'); % plot the trail
t2 = plot(NaN, NaN, 'g-'); % plot the trail
t3 = plot(NaN, NaN, 'b-'); % plot the trail


%% Plot the trails

dtplot = 0.1;
for i=1:floor(dtplot/dt):length(x1)
    % Update the positions of the bodies in the plot
    set(h1, 'XData', x1(i), 'YData', y1(i))
    set(h2, 'XData', x2(i), 'YData', y2(i))
    set(h3, 'XData', x3(i), 'YData', y3(i))
    % Update the trails
    set(t1, 'XData', x1(1:i), 'YData', y1(1:i))
    set(t2, 'XData', x2(1:i), 'YData', y2(1:i))
    set(t3, 'XData', x3(1:i), 'YData', y3(1:i))
    title(['Simulation Graphic at t =',num2str(time(i)) ]);
    drawnow
    if (max([abs(x1(i)),abs(x2(i)),abs(x1(i))])>10^5)
        break
    end
end
hold off
toc
end