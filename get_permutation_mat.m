function [ P ] = get_permutation_mat(n, i, j)
%Returns a permutation matrix of size n to swap row/col i and j
%
% @author David Grimsman
    P = eye(n);
    P(i,j) = 1;
    P(j,i) = 1;
    if i ~= j
        P(i,i) = 0;
        P(j,j) = 0;
    end
end

