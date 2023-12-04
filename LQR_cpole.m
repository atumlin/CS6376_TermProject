% Anne Tumlin
% Code for LQR Based CPole
% Code based on tutorial here: https://ctms.engin.umich.edu/CTMS/index.php?example=InvertedPendulum&section=ControlStateSpace
% Matrix values provided by T. Johnson and will be demonstrated in paper.

A = [0         0    1.0000         0; 
     0         0         0    1.0000; 
     0   -2.7500  -10.9500    0.0043; 
     0   28.5800   24.9200   -0.0440];
B = [0;0;1.9400;-4.4400];
C = [1 0 0 0;
     0 0 1 0];
D = [0;
     0];

% Calculate controllability
co = ctrb(A, B);
controllability = rank(co);

% Define Q and R matrices
Q = C' * C;
Q(1, 1) = 5000;
Q(3, 3) = 100;
R = 1;

% Calculate the LQR gain matrix K
K = lqr(A, B, Q, R);

% Closed-loop system dynamics
Ac = A - B * K;
Bc = B;
Cc = C;
Dc = D;

states = {'x', 'x_dot', 'phi', 'phi_dot'};
inputs = {'r'};

% Create two systems for different outputs
outputs1 = {'x', 'phi'};
sys1_cl = ss(Ac, Bc, Cc, Dc, 'statename', states, 'inputname', inputs, 'outputname', outputs1);

outputs2 = {'x_dot', 'phi_dot'};
sys2_cl = ss(Ac, Bc, Cc, Dc, 'statename', states, 'inputname', inputs, 'outputname', outputs2);

t = 0:0.01:5;
r = 0.2 * ones(size(t));

% Simulate and plot cart position and pendulum angle
[y1, t1, ~] = lsim(sys1_cl, r, t);

figure;
subplot(2, 1, 1);
plot(t1, y1(:, 1));
ylabel('Cart Position (m)');
title('Step Response with LQR Control (Cart Position and Pendulum Angle)');

subplot(2, 1, 2);
plot(t1, y1(:, 2));
ylabel('Pendulum Angle (radians)');
xlabel('Time (s)');

% Simulate and plot cart velocity and pendulum velocity
[y2, t2, ~] = lsim(sys2_cl, r, t);

figure;
subplot(2, 1, 1);
plot(t2, y2(:, 1));
ylabel('Cart Velocity (m/s)');
title('Step Response with LQR Control (Cart Velocity and Pendulum Velocity)');

subplot(2, 1, 2);
plot(t2, y2(:, 2));
ylabel('Pendulum Velocity (rad/s)');
xlabel('Time (s)');

% Call animateCartPole to visualize the cart-pole animation
% animateCartPole([y1(:, 1), y1(:, 2)], 0.3); % Use the pendulum length L from your system
% 
% Define function for cart-pole animation
% function animateCartPole(states, L)
%     Extract states
%     x = states(:, 1);     % Cart position
%     theta = states(:, 2); % Pendulum angle
% 
%     Define the dimensions of the cart and pendulum
%     cartWidth = 0.4;       % Adjust as needed
%     cartHeight = 0.2;      % Adjust as needed
% 
%     Create a figure for animation
%     figure;
% 
%     Iterate through time steps for animation
%     for i = 1:length(x)
%         Cart position
%         cartX = x(i) - cartWidth/2;
%         cartY = 0;
% 
%         Pendulum position
%         pendulumX = x(i);
%         pendulumY = 0;
% 
%         Draw the cart
%         rectangle('Position', [cartX, cartY, cartWidth, cartHeight], 'FaceColor', [0.2, 0.2, 0.8]);
%         hold on;
% 
%         Draw the pendulum
%         pendulumXEnd = pendulumX + L * sin(theta(i));
%         pendulumYEnd = pendulumY - L * cos(theta(i));
%         line([pendulumX, pendulumXEnd], [pendulumY, pendulumYEnd], 'LineWidth', 3, 'Color', [0.8, 0.2, 0.2]);
% 
%         Set axis limits
%         axis([x(i) - 2, x(i) + 2, -L - 1, L + 1]);
% 
%         Add labels and title
%         xlabel('Cart Position');
%         ylabel('Pendulum Height');
%         title('Cart-Pole Animation');
% 
%         Pause for animation
%         pause(0.01);
% 
%         Clear the figure for the next frame
%         clf;
%     end
% end

