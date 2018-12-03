File.open("input.txt", "r") do |f|
  blocks = {}
  blocks.default = 0
  f.each_line do |line|
    split1 = line.split("@")
    if split1.length > 1 then
      location = split1[1].split(":")[0]
      size = split1[1].split(":")[1]
      location.strip!
      size.strip!
      location = location.split(",").map { |s| s.to_i }
      size = size.split("x").map { |s| s.to_i }
      for x in location[0]..(location[0]+size[0]-1)
        for y in location[1]..(location[1]+size[1]-1)
          blocks[[x,y]] = blocks[[x,y]]+1
        end
      end
    end
  end

  res = 0
  blocks.each do |loc,count|
    if count > 1 then
      res += 1
    end
  end

  puts res
end