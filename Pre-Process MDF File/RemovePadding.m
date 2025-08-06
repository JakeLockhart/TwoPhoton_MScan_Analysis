function Stack = RemovePadding(Stack)
    RowMean = mean(Stack, [1,3]);
    RowActual = find(RowMean ~= -2048);
    FrameWidth_Actual = RowActual(1):RowActual(end);
    Stack = Stack(:, FrameWidth_Actual, :);
end