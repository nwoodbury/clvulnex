function [ v_ij ] = get_vuln_at( Q, i, j )
%GET_VULN_AT Calculates the vulnerability of the DSF given a Q matrix
%   Detailed explanation goes here
% @author David Grimsman

%first, permute Q so Q(i,j) and Q(j,i) are in the upper left
n = size(Q, 1);
Perm = get_permutation_mat(n, 1, i);
Q = Perm * Q * Perm';
Perm = get_permutation_mat(n, 2, j);
Q = Perm * Q * Perm';

%get the partitions from Q
M1 = Q(1, 3:n);
M2 = Q(2, 3:n);
N1 = Q(3:n, 1);
N2 = Q(3:n, 2);
X = Q(3:n, 3:n);
Q_ij = Q(1,2);
Q_ji = Q(2,1);
F = inv(eye(n - 2) - X);

%calculate vulnerability
vuln = (Q_ji + M2*F*N1) / ((1 - M2*F*N2) - (Q_ji + M2*F*N1)*Q_ij);

%make it look like a rational function
%[num den] = numden(vuln);
%den = expand(den);
%num = expand(num);
%v_ij = num./den;
v_ij = vuln;

end

