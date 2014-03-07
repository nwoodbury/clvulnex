function ExploreStructure( toexplore, constant, bound, numsteps, showprogress )
% Iterates over all ts and generates a surface graph representation of the
% structure, with the following interpretations for each height for the
% structure of Q:
%   (-1) Q is infeasible (t3 = 0)
%   (0) Q is empty
%   (1) q_12 alone is non-zero
%   (2) q_21 alone is non-zero
%   (3) Q is full
% And the following interpretations for each height for the structure of P:
%   (-1) P is infeasible (t3 = 0)
%   (0) P is empty
%   (1) p_11 alone is non-zero
%   (2) p_12 alone is non-zero
%   (3) p_12 and p_11 alone are non-zero
%   (4) p_21 alone is non-zero
%   (5) p_21 and p_11 alone are non-zero
%   (6) p_21 and p_12 alone are non-zero
%   (7) p_21, p_12, and p_11 alone are non-zero
%   (8) p_22 alone is non-zero
%   (9) p_22 and p_11 alone are non-zero
%   (10) p_22 and p_12 alone are non-zero
%   (11) p_22, p_12, and p_11 alone are non-zero
%   (12) p_22 and p_21 alone are non-zero
%   (13) p_22, p_21, and p_11 alone are non-zero
%   (14) p_22, p_21, and p_12 alone are non-zero
%   (15) P is full
%
% @param toexplore {12, 13, 23} (default 12). Explores the following:
%   12: Holds t3 constant and explores t1 and t2
%   13: Holds t2 constant and explores t1 and t3
%   23: Holds t1 constant and explores t2 and t3
% @param constant {int} (default = 1 if toexplore is 12, 0 otherwise).
%   Sets the value of the ti that is held constant.
% @param bound {int} (default 50). The two ti's that are being explored
%   will be allowed to range between -bound and bound.
% @param numsteps {int} (default 10). Each ti being explored will evaluate
%   vulnerability at (numsteps+1) steps between -bound and bound, including
%   the points at -bound, bound, and 0. To have clean evaluation points,
%   (2*bound)/numsteps should be a rational number. The total number
%   of evaluations in the exploration will be (numsteps+1)^2.
% @param showprogress {boolean} (default true). If true, prints out 
%   progress reports as a percentage completed. Each incremental percentage
%   shown will be 100 / (numsteps + 1).

% Load controller
load('sysk.mat');

if nargin < 1
    toexplore = 12;
end
if nargin < 2
    if toexplore == 12
        constant = 1;
    else
        constant = 0;
    end
end
if nargin < 3
    bound = 50;
end
if nargin < 4
    numsteps = 10;
end
if nargin < 5
    showprogress = true;
end

% Build the ranges and the space being explored
rng = (0 : numsteps) * (2*bound)/numsteps - bound;
[X, Y] = meshgrid(rng);
dimeval = numsteps + 1;

% For storing the representation of the structures of Q and P
Zq = zeros(dimeval); 
Zp = zeros(dimeval);

if showprogress
    fprintf('Beginning Exploration\n');
end
for x = 1 : dimeval
    for y = 1 : dimeval
        % Determine which are decision and which are not
        if toexplore == 12
            t1 = X(x, y);
            t2 = Y(x, y);
            t3 = constant;
            xaxislabel = 't1';
            yaxislabel = 't2';
        elseif toexplore == 13
            t1 = X(x, y);
            t2 = constant;
            t3 = Y(x, y);
            xaxislabel = 't1';
            yaxislabel = 't3';
        else
            t1 = constant;
            t2 = X(x, y);
            t3 = Y(x, y);
            xaxislabel = 't2';
            yaxislabel = 't3';
        end  
        
        % Check infeasibility
        if t3 == 0
            Zq(x,y) = -1;
            continue;
        end
        
        % Get the DSF of the transformed system
        [A1, B1] = GetTransformedSystem(t1, t2, t3, sysk.A, sysk.B);
        [Q, P] = checkQP(A1, B1, sysk.C);
        
        % Represent and store the structure of Q
        zq = 0;
        if ~isequal(Q(1,2), tf(0)) 
            zq = zq + 1; 
        end
        if ~isequal(Q(2,1), tf(0))
            zq = zq + 2;
        end        
        Zq(x,y) = zq; 
        
        % Represent and store the structure of P
        zp = 0;
        if ~isequal(P(1,1), tf(0))
            zp = zp + 1;
        end
        if ~isequal(P(1,2), tf(0))
            zp = zp + 2;
        end
        if ~isequal(P(2,1), tf(0))
            zp = zp + 4;
        end
        if ~isequal(P(2,2), tf(0))
            zp = zp + 8;
        end
        Zp(x,y) = zp;
        
    end
    if showprogress
        fprintf('%.1f%% Complete\n', 100 * x / size(rng,2));
    end
end

subplot(2,2,1);
surf(X,Y,Zq);
xlabel(xaxislabel);
ylabel(yaxislabel);
zlabel('Structure');
title('Structure of Q');
zlim([-1,3]);
shading interp

subplot(2,2,2);
contour(X, Y, Zq);
title('Structure of Q (contour)');
xlabel(xaxislabel);
ylabel(yaxislabel);
shading interp

subplot(2,2,3);
surf(X,Y,Zp);
xlabel(xaxislabel);
ylabel(yaxislabel);
zlabel('Structure');
title('Structure of P');
zlim([-1,15]);
shading interp

subplot(2,2,4);
contour(X, Y, Zp);
title('Structure of P (contour)');
xlabel(xaxislabel);
ylabel(yaxislabel);
shading interp

end

