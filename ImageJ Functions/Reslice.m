function ReslicedStack = Reslice(Stack, Orientation)
    arguments
        Stack
        Orientation (1,:) char {mustBeMember(Orientation, {'XY', 'XZ', 'YZ'})} = 'XZ'
    end

    switch Orientation
        case "XY"
            ReslicedStack = permute(Stack, [1,2,3]);
        case "XZ"
            ReslicedStack = permute(Stack, [2,1,3]);
        case "YZ"
            ReslicedStack = permute(Stack, [3,2,1]);
    end
end