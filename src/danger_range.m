% Author: Aditya Prawira 

% the main helper function that will update robot's position in the
% simulation, and prevent position update if the direction that where the
% robot movign towards to, detected objects wihtin 0.5m from the robot body
function index = danger_range(ranges, safe_range, current_i, direction, detections)
    cellRanges = num2cell(ranges);
    
    % Destructuring 9-direction detection channels
    [range1, range2, range3, range4, range5, range6, range7, range8, range9] = ...
        cellRanges{:};
    
    isDanger = is_danger(range1, range2, range3, range4, range5, ...
        range6, range7,  range8, range9, safe_range);
    
    % If statement for the main chosen detection channels
    if(direction == "l")
        mainRange = range(9);
    elseif(direction == "r")
        mainRange = range(1);
    elseif(direction == "fr")
        mainRange = range(3);
    elseif(direction == "fl")
        mainRange = range(7);
    else
        mainRange = range(5);
    end
    
    % Destructuring objName, and its range from the main robot body
    [objName, objRange] = object_detection(detections);
    
    % the following if statement will prevent robot to move any further
    % if the object detected is either furniture or living object or wall
    % that is located less than 0.5m from the robot.
    if((~isnan(mainRange) || mainRange <= safe_range) &&  ...
            isDanger || (objName == "FURNITURE" || objName == "LIVING OBJECT")...
            && objRange <= safe_range)
        fprintf("STOP!!!!!\n");
        index = current_i;
    else
        index = current_i + 1;
    end
end

% subhelper function that will make sure that it triggers a boolen value that
% one of the sensor detecting object that located less than 0.5m from the
% robot
function isDanger = is_danger(range1, range2, range3, range4, range5, ...
    range6, range7, range8, range9, safe_range)
    isDanger = range1 <= safe_range|| range2 <= safe_range ||...
        range3 <= safe_range || range4 <= safe_range|| ...
        range5 <= safe_range|| range6 <= safe_range || ...
        range7 <=safe_range || range8 <=safe_range || range9 <=safe_range;
end

% subhelper function that will operate object detection as the robot is being
% operated
function [objectName, objectRange] = object_detection(detections)
    % if the detections object is not empty, parse the detected object,
    % otherwise, indicates no particular objects are detected.
    if ~isempty(detections)
        nearestLabel = detections(1,3);
        if(nearestLabel == 1)
            objectName = "MOLD";
            objectRange = detections(1);
        elseif(nearestLabel == 2)
            objectName = "FURNITURE";
            objectRange = detections(1);
        else
            objectName = "LIVING OBJECT";
            objectRange = detections(1);
        end
        fprintf("range = %fm, object type = %s\n", ...
            objectRange, objectName);
    else
        objectName = "No particular object detected";
        objectRange = 0;
        fprintf("range = %fm, object type = %s\n", ...
            objectRange, objectName);
    end
end
