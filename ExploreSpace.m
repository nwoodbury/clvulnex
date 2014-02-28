function ExploreSpace(toexplore, constant, bound, numsteps, clip, ...
                      showprogress)
% Explores the space of vulnerabilities, producing contour and mesh
% graphs of the result.
%
% @param toexplore {12, 13, 23} (default 12). Explores the following:
%   12: Holds t3 constant and explores t1 and t2
%   13: Holds t2 constant and explores t1 and t3
%   23: Holds t1 constant and explores t2 and t3
% @param constant {int} (default = 1 if toexplore is 12, 0 otherwise).
%   Sets the value of the ti that is held constant.
% @param minrange {int} (default 50). The two ti's that are being explored
%   will be allowed to range between -bound and bound.
% @param numstaps {int} (default 10). Each ti being explored will evaluate
%   vulnerability at (numsteps+1) steps between -bound and bound, including
%   the points at -bound, bound, and 0. To have clean evaluation points,
%   (2*bound)/numsteps should be a rational number. The total number
%   of evaluations in the exploration will be (numsteps+1)^2.
% @param clip {number} (default 50). The maximum vulnerability to be shown.
%   All vulnerabilities > clip will be clipped to clip.
% @param showprogress {boolean} (default true). If true, prints out 
%   progress reports as a percentage completed. Each incremental percentage
%   shown will be 100 / (numsteps + 1).
%
% @author Nathan Woodbury

% Set Defaults
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
    clip = 50;
end
if nargin < 6
    showprogress = true;
end

% Build the ranges and the space being explored
rng = (0 : numsteps) * (2*bound)/numsteps - bound;
[X, Y] = meshgrid(rng);
dimeval = numsteps + 1;

% For storing max vulnerability seen in the combined system
Zc = zeros(dimeval); 
% For storing max vulnerability seen in the controller
Zk = zeros(dimeval);

% Create placeholders to track the value and location of the minimum
% vulnerability
minvc = Inf;                % Combined System
minvcloc = [-Inf, -Inf];    % Combined System
minvk = Inf;                % Controller
minvkloc = [-Inf, -Inf];     % Controller

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
        
        % Compute and store the minimum vulnerability found
        [Vc, Vk] = VulnerabilityOfT(t1, t2, t3);
        Zc(x, y) = Vc;
        Zk(x, y) = Vk;
        
        % Update the traked location where the minum was found
        if Vc < minvc
            minvc = Vc;
            minvcloc = [t1, t2, t3];
        end
        if Vk < minvk
            minvk = Vk;
            minvkloc = [t1, t2, t3];
        end
            
    end
    if showprogress
        fprintf('%.1f%% Complete\n', 100 * x / size(rng,2));
    end
end

% Clip the vulnerabilities
Zc(Zc > clip) = clip;
Zk(Zk > clip) = clip;

% Plot the results
figure();
subplot(2,2,1);
surf(X,Y,Zc);
xlabel(xaxislabel);
ylabel(yaxislabel);
zlabel('Vulnerability');
title('Vulnerability of Combined System');
zlim([0 clip]);
shading interp

subplot(2,2,2);
contour(X, Y, Zc);
xlabel(xaxislabel);
ylabel(yaxislabel);
title('Vulnerability of Combined System (contour)');
shading interp

subplot(2,2,3);
surf(X,Y,Zk);
xlabel(xaxislabel);
ylabel(yaxislabel);
zlabel('Vulnerability');
title('Vulnerability of the Controller');
zlim([0 clip]);
shading interp

subplot(2,2,4);
contour(X, Y, Zk);
title('Vulnerability of the Controller (contour)');
xlabel(xaxislabel);
ylabel(yaxislabel);
shading interp

% Print the minimums found
fprintf('Min Vulnerability of the Combined System: %.3f @ (%i, %i, %i)\n', ...
    minvc, minvcloc(1), minvcloc(2), minvcloc(3));
fprintf('Min Vulnerability of the Controller: %.3f @ (%i, %i, %i)\n', ...
    minvk, minvkloc(1), minvkloc(2), minvkloc(3));

% Save the results
dir = sprintf('ex_e%i_c%i_b%i_s%i', toexplore, constant, bound, numsteps);
if exist(dir, 'dir')
    % Remove the old experiment run on the same parameters
    rmdir(dir, 's');
end
mkdir(dir);

figname = sprintf('%s/space.fig', dir);
resultsname = sprintf('%s/results.mat', dir);
saveas(gcf, figname);
save(resultsname, 'Zc', 'Zk', 'minvc', 'minvk', 'minvcloc', 'minvkloc');
fprintf('Figure saved to %s; results saved to %s\n', figname, resultsname);

end

