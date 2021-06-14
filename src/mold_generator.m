function molds = mold_generator(world)
    molds = [];
    type = ["x" "y"];
    map = world.map;
    
    for i = 1: 10
        indexType = randperm(2, 1);
        if(type(indexType) == "x")
            index = randperm(length(map.XWorldLimits),1);
            x = map.XWorldLimits(index);
            if(x > 0)
                x = x - 0.6;
            else
                x = x + 0.6;
            end
            a = map.YWorldLimits(1);
            b = ceil(map.YWorldLimits(2));
            r = (b-a).*rand(b,1) + a;
            y = r(randperm(length(r), 1));
            if(y > 0.6)
                y = y - 0.6;
            else
                y = y + 0.6;
            end
            molds(i,:) = [x y 1];
        else
            index = randperm(length(map.YWorldLimits),1);
            y = map.YWorldLimits(index);
            if(y > 0)
                y = y - 0.6;
            else
                y = y + 0.6;
            end
            a = map.XWorldLimits(1);
            b = ceil(map.XWorldLimits(2));
            r = (b-a).*rand(b,1) + a;
            x = r(randperm(length(r), 1));
            if(x > 0.6)
                x = x - 0.6;
            else
                x = x + 0.6;
            end
            molds(i,:) = [x y 1];
        end
    end 
end
