
function ref = rotate_anticlockwise(robot, tVec, motor_speed)
    w1 = -motor_speed; % angular velocity of motor 1
    w2 = motor_speed; % angular velocity of motor 2
    w3 = -motor_speed; % angular velocity of motor 3
    w4 = motor_speed; % angular velocity of motor 4
    w_motor = [w1; w2; w3; w4];

    robot_velocities = num2cell(forwardKinematics(robot, w_motor));

    [vx, vy, w] = robot_velocities{:};
    vx = round(vx,2);
    vy = round(vy,2);
    w = round(w,2);
    fprintf("omega = %d\n", w);

    % Initialize time, input, and pose arrays
    vxRef = vx*ones(size(tVec));   % Reference x speed
    vyRef = vy*ones(size(tVec));

    % Reference y speed
    wRef = w*ones(size(tVec));       % Reference angular speed

    ref = [vxRef;vyRef;wRef];
end

