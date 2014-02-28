function [ V ] = get_vuln_mat( Q )
%GET_VULN_MAT Summary of this function goes here
%   Detailed explanation goes here
% @author David Grimsman

n = size(Q,1);
V = zeros(n);
%V = tf(V);
for i = 1:n
    for j = 1:n
        if i ~= j
            V(i,j) = norm(get_vuln_at(Q, i, j), 'inf');
        end
    end
end

end

