function index = danger_range(ranges, safe_range, current_i, direction)
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
        
    if((~isnan(mainRange) || mainRange < safe_range) &&  ...
            isDanger)
        fprintf("STOP!!!!!\n");
        index = current_i;
    else
        index = current_i + 1;
    end
%     fprintf("range1 = %f, range2 = %f, range3 = %f, "...
%                     +"range4 = %f, range5 = %f, range6 = %f, "...
%                     +"range7 = %f, range8 = %f, range9 = %f\n",...
%                     range1, range2, range3, range4, ...
%                     range5, range6, range7, range8, range9);
end

function isDanger = is_danger(range1, range2, range3, range4, range5, ...
    range6, range7, range8, range9, safe_range)
    isDanger = range1 < safe_range|| range2 < safe_range ||...
        range3 < safe_range || range4 < safe_range|| ...
        range5 < safe_range|| range6 < safe_range || ...
        range7 <safe_range || range8 <safe_range || range9 <safe_range;
end