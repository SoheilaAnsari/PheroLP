function Index = FindRow(S, s)
% S: Main matrice
% s: search element

nCol  = size(S, 2);
match = S(:, 1) == s(1);
for col = 2:nCol
   match(match) = S(match, col) == s(col);
end
Index = find(match);