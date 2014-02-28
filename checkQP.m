function [Q,P] = checkQP(A,B,C)
% Given a state space system represented by (A, B, C), returns the 
% Dynamical Structure Function (DSF) representation of the system.
%
% @author Vasu Chetty
[p,~] = size(C);
[n,~] = size(A);
[h,m] = size(B);

A11 = A(1:p,1:p);
if p < n
    A12 = A(1:p,p+1:n);
    A21 = A(p+1:n,1:p);
    A22 = A(p+1:n,p+1:n);
else
    A12 = [];
    A21 = [];
    A22 = [];
end
    

B1 = B(1:p,1:m);
B2 = B(p+1:h,1:m);

s = tf('s');
I = eye(size(A22));

if p ~= n
    W = A11 + A12*inv(s*I - A22)*A21;
    V = A12*inv(s*I-A22)*B2 + B1;
else
    W = A11;
    V = B1;
end

D = tf(zeros(p));
for i = 1:size(W)
    D(i,i) = W(i,i);
end

I = eye(size(D));
Q = inv(s*I-D)*(W-D);
P = inv(s*I-D)*V;