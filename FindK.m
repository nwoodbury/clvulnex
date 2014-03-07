% A random script for finding a (clean) controller which stabilizes the
% plant in the ME575 example. This is used in formulating the problem.
%
% @author Nathan Woodbury

clear;
clc;

% G
At = [1 0 0 ; 0 -1 1 ; 0 0 -1];
Bt = [1 0 ; 2 1 ; 0 2];
Ct = [eye(2) [0 ; 0]];
sys = ss(At, Bt, Ct, []);
G = tf(sys);

% K 
found = 0;
rng = [-10,10];
C0 = [eye(2) [0 ; 0]];
while found < 3
    A0 = [randi(rng) randi(rng) randi(rng);
          randi(rng) randi(rng) randi(rng);
          randi(rng) randi(rng) randi(rng)];
    B0 = [randi(rng) randi(rng);
          randi(rng) randi(rng);
          randi(rng) randi(rng)];
    if rank(A0) ~= 3 && rank(B0) ~= 2
        continue
    end
    
    A = [At Bt*C0 ; B0*Ct A0];
    eigs = eig(A);
    if all(eigs < 0) && isreal(eig(A0))
        display('----------------------');
        display('working found');
        display(A0);
        display(B0);
        display(eigs);
        found = found + 1;
        display(eig(A0));
    end
end