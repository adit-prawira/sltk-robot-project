function index = danger_range(ranges, safe_range, current_i, direction, detections)
    cellRanges = num2cell(ranges);
    [range1, range2, range3, range4, range5, range6, range7, range8, range9] = ...
        cellRanges{:};
    isDanger = is_danger(range1, range2, range3, range4, range5, ...
        range6, range7,  range8, range9, safe_range);
    
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
    [objName, objRange] = object_detection(detections);
    if((~isnan(mainRange) || mainRange < safe_range) &&  ...
            isDanger || (objName == "FURNITURE" || objName == "LIVING OBJECT")...
            && objRange < safe_range)
        fprintf("STOP!!!!!\n");
        index = current_i;
    else
        index = current_i + 1;
    end
end

function isDanger = is_danger(range1, range2, range3, range4, range5, ...
    range6, range7, range8, range9, safe_range)
    isDanger = range1 < safe_range|| range2 < safe_range ||...
        range3 < safe_range || range4 < safe_range|| ...
        range5 < safe_range|| range6 < safe_range || ...
        range7 <safe_range || range8 <safe_range || range9 <safe_range;
end

function [objectName, objectRange] = object_detection(detections)
    if ~isempty(detections)
        nearestLabel = detections(1,3);
        fprintf("range = %f, angle = %f, type = %f\n", ...
            detections(1),detections(2), detections(3));
        if(nearestLabel == 1)
            objectName = "MOLD";
            objectRange = 0;
        elseif(nearestLabel == 2)
            objectName = "FURNITURE";
            objectRange = detections(1);
        else
            objectName = "LIVING OBJECT";
            objectRange = detections(1);
        end
    else
        objectName = "";
        objectRange = 0;
    end
end
