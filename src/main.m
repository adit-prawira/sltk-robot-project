%% STALKER ROBOT SIMULATIONS
clear
clc
set(0,'DefaultFigureWindowStyle','docked') % Docked simulation.

%% KEY BINDING ASCII CODE CONSTANTS
FORWARD = 82;
BACKWARD = 81; 
LEFT = 80;
RIGHT = 79;
ESC = 41;
ENTER = 13;
KEY_D = 7; % d key
KEY_A = 4; % a key
 
%% SIMULATION ENVIRONMENT SETUP INTERFACE
fprintf("\nDo you want to start the simulation?\nPress 'Enter' to "+...
    "process or any key to cancel\n") ;
val = getkey;
start = 0;


if(val == ENTER)
    start = 1;
    val = 0;
    
    % Options that allows user to choose map of the environment
    map = input("Enter a number to choose simulation's map:\n"+...
        "1 - Simple map\n2 - Complex map\n");
    
    % load simple map model if use pressed number 1, complex map otherwise.
    if(map == 1)
        load('simpleMap.mat');
        world = load('simpleMap.mat');
        molds = mold_generator(world);
        furnitures = [4.5, 2.5, 2;...
            5, 10.5, 2;...
            1, 7, 2;...
            8, 11, 2;...
            12.5, 5.5, 2];
        objects = [molds; ...
           furnitures; ...
           8, 4, 3];
    else
        load('complexMap.mat');
        world = load('complexMap.mat');
        molds = mold_generator(world);
        furnitures = [2.5, 7, 2;...
            7.5, 1, 2;...
            11, 1, 2;...
            13, 1, 2;...
            21, 1, 2;...
            22, 5, 2;...
            24, 6.5, 2;...
            19, 16.5, 2;...
            8, 11, 2;...
            8, 19.5, 2;...
            2.5, 19.5, 2];
        objects = [molds; ...
           furnitures; ...
           8, 4, 3];
    end
    fprintf("\nStatus: Simulation has started...\n");
else
    fprintf("\nStatus: Simulation cancelled\n");
end

%% Create lidar sensor
lidar = LidarSensor;
lidar.sensorOffset = [0,0];
lidar.scanAngles = linspace(-pi/2,pi/2,9);
lidar.maxRange = 5;

%% Create object detection
detector = ObjectDetector;
detector.fieldOfView = pi/4;

%% INITIALIZE ROBOT BODY (customisable)
R = 0.05;
Lx = 0.35393; % Wheel base = 353.93 mm
Ly = 0.3354; % Wheel track = 401.4 mm
robot = FourWheelMecanum(R, Lx, Ly); % Declare robot body motion mechanism.

%% Create 2D visualizer
viz = Visualizer2D;
viz.mapName = 'map';
viz.showTrajectory = false;

%% Attaching Lidar and Object Detectino Sensor.
attachLidarSensor(viz,lidar);
attachObjectDetector(viz, detector);

%% Generate 3 object with color of Red, Blue, and Green.
viz.objectColors = [1 0 0;0 1 0;0 0 1];
viz.objectMarkers = 'so^';

%% Simulation parameters
sampleTime = 0.1;              % Sample time [s]
MAX_TIME = 9999;

%% Set initial position of the robot.
x0 = 2;
y0 = 1;
angle_d = 90;
angle_r = angle_d * pi/180; % Setting the robot to initially faced forward 
initpost = [x0; y0; angle_r];% Initial post (x y theta) to column matrix.
%% Set speed of motor
motor_speed = 18.8496; % rad/s
SAFE_RANGE = 0.5; % threshold range between robot with wall or an object
tVec = 0:sampleTime:double(MAX_TIME);         % Time array/vector
%% Initilize Robot's reference movement
ref = move_forward(robot, tVec, motor_speed);       
post = zeros(3,numel(tVec));    % postion matrix
post(:,1) = initpost;

%% Simulation loop
r = rateControl(1/sampleTime);
iter = 2;
i = iter;

while start
    % Convert the reference speeds to world coordinates
    vel = bodyToWorld(ref(:,i-1),post(:,i-1));

    % Perform forward discrete integration step
    post(:,i) = post(:,i-1) + vel*sampleTime;
    
    % Perform object detection
    detections = detector(post(:,i),objects);
    
    % Update lidar and visualization
    ranges = lidar(post(:,i));

    viz(post(:,i),ranges,objects);

    waitfor(r);
    
    % Updating status of whether or not one or more keyard key are pressed.
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(-1);
    
    if(keyIsDown)
        val = find(keyCode==1);
        
        % One key command.
        if(length(val) == 1)
           
            if(val == ESC)
                % End simulation when user pressed ESC key.
                start = 0;
                fprintf("\nStatus: Simulation has ended\n");
            elseif(val == FORWARD)
                ref = move_forward(robot, tVec, motor_speed);
                i =danger_range(ranges, SAFE_RANGE, i, "f", detections);
            elseif(val == BACKWARD)
                ref = move_backward(robot, tVec, motor_speed);
                i = danger_range(ranges, SAFE_RANGE, i, "b", detections);
            elseif(val == RIGHT)
                ref = move_right(robot, tVec, motor_speed);
                i = danger_range(ranges, SAFE_RANGE, i, "r", detections);
            elseif(val == LEFT)
                ref = move_left(robot, tVec, motor_speed);
                i = danger_range(ranges, SAFE_RANGE, i, "l", detections);
            elseif(val == KEY_D)
                ref = rotate_clockwise(robot, tVec, motor_speed);
                i = i + 1;
                cellRanges = num2cell(ranges);
                [range1, ransge2, range3, range4, range5, range6, ...
                    range7, range8, range9] = cellRanges{:};
            elseif(val == KEY_A)
                ref = rotate_anticlockwise(robot, tVec, motor_speed);
                i = i + 1;
                cellRanges = num2cell(ranges);
                [range1, range2, range3, range4, range5, range6, ...
                    range7, range8, range9] = cellRanges{:};
            else
                sprintf("Command unused\n");
            end
        end
        
        % DIAGONAL MOVEMENTS, hence 2-key command.
        if(length(val) == 2)
            key1 = val(1);
            key2 = val(2);
            if(key1 < key2)
                if(key1 == LEFT && key2 == FORWARD)
                    ref = move_forward_left(robot, tVec, motor_speed);
                    i = danger_range(ranges, SAFE_RANGE, i, "fl", detections);
                elseif(key1 == RIGHT && key2 == FORWARD)
                    ref = move_forward_right(robot, tVec, motor_speed);
                    i = danger_range(ranges, SAFE_RANGE, i, "fr", detections);
                elseif(key1 == RIGHT && key2 == BACKWARD)
                    ref = move_backward_right(robot, tVec, motor_speed);
                    i = danger_range(ranges, SAFE_RANGE, i, "br", detections);
                elseif(key1 == LEFT && key2 == BACKWARD)
                    ref = move_backward_left(robot, tVec, motor_speed);
                    i = danger_range(ranges, SAFE_RANGE, i, "bl", detections);
                end 
            end
        end
    end
end
