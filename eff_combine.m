function new_eff=eff_combine(effstructs)

new_eff.Fc_mean=[];
%new_eff.Fc_mean_norm=[];
new_eff.D_mean=[];
new_eff.A_mean=[];
new_eff.E=[];
for set_idx=1:size(effstructs,1)
    new_eff.Fc_mean=cat(2,new_eff.Fc_mean,effstructs{set_idx}.Fc_mean);
    new_eff.D_mean=cat(2,new_eff.D_mean,effstructs{set_idx}.D_mean);
    new_eff.A_mean=cat(2,new_eff.A_mean,effstructs{set_idx}.A_mean);
%    new_eff.Fc_mean_norm=cat(2,new_eff.Fc_mean_norm,effstructs{set_idx}.Fc_mean_norm);
    new_eff.E=[cat(2,new_eff.E,effstructs{set_idx}.E)];
end