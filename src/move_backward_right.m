function ref = move_backward_right(robot, tVec, motor_speed)
    w1 = 0; % angular velocity of motor 1
    w2 = -motor_speed; % angular velocity of motor 2
    w3 = -motor_speed; % angular velocity of motor 3
    w4 = 0; % angular velocity of motor 4
    w_motor = [w1; w2; w3; w4];

    robot_velocities = num2cell(forwardKinematics(robot, w_motor));

    [vx, vy, w] = robot_velocities{:};
    vx = round(vx,2);
    vy = round(vy,2);
    w = round(w,2);
    
    vxRef = vx*ones(size(tVec));    % Reference Vx speed
    vyRef = vy*ones(size(tVec));    % Reference Vy speed

    % Reference y speed
    wRef = w*ones(size(tVec));      % Reference angular (w) speed

    ref = [vxRef;vyRef;wRef];       % combine references
end