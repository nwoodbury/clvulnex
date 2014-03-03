function t = RandT0( tq, lim )
% Computes a random t = [t1, t2, t3] to use as an initial condition.
%
% @param tq = [t1q, t2q, t3q] {each in {-1, 1}}. Determines the quadrant 
%   from which the respective t will be drawn, 1 will create a random t 
%   from 0 to lim, -1 will create a random t from -lim to 0
% @param lim {number}. The upper (or lower depending on tq(i)) limit from
%   which the random number will be drawn.
%
% @returns t = [t1, t2, t3]. A random initial condition.
%
% @author Nathan Woodbury

t = zeros(1,3);
for i = 1 : 3
    t(i) = rand(1) * tq(i) * lim;
end

end

