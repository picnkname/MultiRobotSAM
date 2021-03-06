function state = velocity_transition( x_i,u,dt)
%velocity_TRANSITION propagates the given state x_i according to the controls
% u = (vel_y; vel_x; vel_theta)
% x = (x;y;theta)


% assert(length(x_i)==3);
% assert(length(u)==3);
% v = u(1); vel_theta = u(2);
% x = x_i(1); y = x_i(2); theta = minimizedAngle(x_i(3));
% 
% 
% x = x + v*dt*cos(theta + vel_theta*dt);
% y = y + v*dt*sin(theta + vel_theta*dt);
% theta = minimizedAngle(theta + vel_theta*dt);
% state=[x;y;theta];



dx = u(1);
dy = u(2);
dtheta = u(3);

global INFO;  

x = x_i(1) + dx;
y = x_i(2) + dy;
theta = minimizedAngle(x_i(3) + dtheta);
state = [x;y;theta];
end

