function [An, Bn] = GetTransformedSystem( t1, t2, t3, A, B )
% Given a transformation T represented by t1, t2, t3, and an old system
% represented by A and B (the transformation is designed so that C is
% invariate), returns the transformed system represented by An, Bn
%
% Note, this function is only designed to work with a system with 2 
% observed states and one hidden state where C = [I 0].
%
% @param t1, t2, t3 {float} The parameters representing T
% @param A {matrix, 3x2} The A matrix of the original system
% @param B {matrix, 3x2} The B matrix of the original system
%
% @returns An {matrix, 3x3} TAT^-1
% @returns Bn {matrix, 3x2} TB

T = [1 0 0 ; 0 1 0 ; t1 t2 t3];
An = T * A * T^-1;
Bn = T * B;
end

