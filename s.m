clc
clear all
format short

% Define the problem
Noofvariables = 2;
C = [2 5];
a = [1 4; 3 1; 1 1];
b = [24; 21; 9];
s = eye(size(a, 1));
A = [a s b];

% Initialize the cost vector
cost = zeros(1, size(A, 2));
cost(1:Noofvariables) = C;

% Basic Variables
bv = Noofvariables+1:1:size(A, 2)-1;

% Calculate the initial tableau
zjcj = cost(bv)*A - cost;
zcj = [zjcj; A];
simptable = array2table(zcj);
simptable.Properties.VariableNames(1:size(zcj, 2)) = {'x_1', 'x_2', 's_1', 's_2', 's_3', 'sol'};

RUN = true;
while RUN
    if any(zjcj < 0)  % Check for (most) negative value
        fprintf('The current BFS is not optimal \n')
        zc = zjcj(1:end-1);
        [Enter_val, pvt_col] = min(zc);
        if all(A(:, pvt_col) <= 0)
            error('LPP is Unbounded all entries are <=0 in column %d', pvt_col);
        else
            sol = A(:, end);
            column = A(:, pvt_col);
            ratio = zeros(size(A, 1), 1);
            for i = 1:size(A, 1)
                if column(i) > 0
                    ratio(i) = sol(i) / column(i);
                else
                    ratio(i) = inf;
                end
            end
            [~, pvt_row] = min(ratio);
        end
        bv(pvt_row) = pvt_col;
        pvt_key = A(pvt_row, pvt_col);
        A(pvt_row, :) = A(pvt_row, :) ./ pvt_key;
        for i = 1:size(A, 1)
            if i ~= pvt_row
                A(i, :) = A(i, :) - A(i, pvt_col) .* A(pvt_row, :);
            end
        end
        zjcj = zjcj - zjcj(pvt_col) .* A(pvt_row, :);
        zcj = [zjcj; A];
        simptable = array2table(zcj);
        simptable.Properties.VariableNames(1:size(zcj, 2)) = {'x_1', 'x_2', 's_1', 's_2', 's_3', 'sol'};
        disp(simptable); % Display the updated table
    else
        RUN = false;
        fprintf('The current BFS is optimal \n')
    end
end
