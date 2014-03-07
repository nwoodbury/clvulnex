% A random script for finding an unstable plant which the controller in
% example 2 stabilizes. This is used in formulating the problem.

clear;
clc;

% K 
A0 = [-1 0 -1 ; 0 -2 -2 ; 0 0 -3];
B0 = [1 0 ; 0 1 ; 1 1];
C0 = [eye(2) zeros(2,1)];
sysk = ss(A0, B0, C0, []);
K = tf(sysk);

% G
found = 0;
rng = [-5,5];
Ct = C0;
while found < 3
    At = [randi(rng) randi(rng) randi(rng);
          randi(rng) randi(rng) randi(rng);
          randi(rng) randi(rng) randi(rng)];
    Bt = [randi(rng) randi(rng);
          randi(rng) randi(rng);
          randi(rng) randi(rng)]; 
    if rank(A0) ~= 3 && rank(B0) ~= 2
        continue
    end  
    
    A = [At Bt*C0 ; B0*Ct A0];
    eigs = eig(A);
    eigst = eig(At);
    if all(eigs < 0) && isreal(eigst) && ~all(eigst < 0)
        display('----------------------');
        display('working found');
        display(At);
        display(Bt);
        display(eigs);        
        display(eigst); 
        found = found + 1;
    end
end