function [R,d] = augument_R(R,d,state,control,robot_id, delta_time)
%Augument for the new line of R
%Return original R , augument_R, original d

global INFO;                            % experiment configuration, should not be updated
global PARAM;                           % global variables, should be updated

[s_r,s_c] = size(state);
last_state = state(:,s_c);
new_R =[];
robot_id = robot_id(1:length(robot_id) - 1); %exclude obsevcation
%overall_control = zeros(2,4);
overall_control = zeros(3,4);
overall_dt = zeros(1,4);
%combine control
for id = 1:4
    [ind] = find(robot_id == id);
    for i = 1 : length(ind)
        overall_control(:,id) = overall_control(:,id) + control(:,ind(i));
        overall_dt(id) = overall_dt(id) + delta_time(ind(i));
    end
end


M = diag([INFO.Sigma_v,INFO.Sigma_v,INFO.Sigma_omega].^2);

default_w = inv((M')^0.5);
new_R = zeros(12,12);

augument_I = zeros(12,12);
for i = 1:4
    augument_I(3*i-2:3*i,3*i-2:3*i)= -default_w*eye(3,3);
end


unique_id = unique(robot_id);
for i = 1:length(unique_id)
    id = unique_id(i);
    theta = last_state(3*id);
    v = overall_control(1,id);
    omega = overall_control(2,id);
    dt = overall_dt(id);
    
    Gt = eye(3);
    Vt = eye(3);
%     Gt = [ 1, 0, -dt*v*sin(theta + dt*omega);
%         0, 1,  dt*v*cos(theta + dt*omega);
%         0, 0,                        1];
%     Vt = [ dt*cos(theta + dt*omega), -dt^2*v*sin(theta + dt*omega);
%         dt*sin(theta + dt*omega),  dt^2*v*cos(theta + dt*omega);
%         0,                          dt];
    
    
    
    Q =  Vt*M*Vt';
    
    if Q(1,1) == 0
        Q(1,1) = INFO.Default_var;
    end
    
    if Q(2,2) == 0
        Q(2,2) = INFO.Default_var;
    end
    
    if Q(3,3) == 0
        Q(3,3) = INFO.Default_var;
    end
    
    w = inv((Q')^0.5);
    new_R(3*id-2:3*id,3*id-2:3*id) = w*Gt;
    augument_I(3*id-2:3*id,3*id-2:3*id) = -w*eye(3);
end

[R_r,R_c] = size(R);
new_R = [zeros(12,R_c-12),new_R,augument_I];
lamda = zeros(12,1);
R = sparse(R);
[R, d] = Givens_Rotation(R, d, new_R, lamda);
R = sparse(R);

end


