function objective = Objective( t )
% Used to encode the objective for optimization.

[Vk, Vc, Vp] = VulnerabilityOfT(t);
objective = Vc;

end

