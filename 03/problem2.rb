def included(location,range)
    return location[0] >= range[0][0] && location[0] < range[0][0]+range[1][0] && location[1] >= range[0][1] && location[1] < range[0][1]+range[1][1]
end

File.open("input.txt", "r") do |f|
    blocks = {}
    blocks.default = 0
    
    claims = []

    f.each_line do |line|
        split1 = line.split("@")
        if split1.length > 1 then
            location = split1[1].split(":")[0]
            size = split1[1].split(":")[1]
            location.strip!
            size.strip!
            location = location.split(",").map { |s| s.to_i }
            size = size.split("x").map { |s| s.to_i }

            claims.push([location,size])

            for x in location[0]..(location[0]+size[0]-1)
                for y in location[1]..(location[1]+size[1]-1)
                    blocks[[x,y]] = blocks[[x,y]]+1
                end
            end
        end
    end
  
    claims.each_with_index do |claim, index|
        single = true
        blocks.each do |loc,count|
            if count > 1 && included(loc,claim) then
                single = false
                break
            end
        end

        if single then
            puts (index+1)
        end
    end
end