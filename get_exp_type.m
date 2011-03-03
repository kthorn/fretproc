function exp_data=get_exp_type(param,exp_type)
%Returns data about different experiment types.  Param is 'list' or 'G'.
%list returns a list of defined experiment types, G returns the G factor
%for the specified experiment type.

%G = Q(d)Phi(d)/Q(a)Phi(a) or the inverse of G as defined by Gordon et al. (1998) 

experiments={'CFP/Citrine','GFP/tdimer2','CFP/phiYellow','GFP/mCherry','GFP/tHcRed','GFP/MkOrange','MkOrange/tHcRed','MkOrange/mCherry','Cit/mCherry','Cit/tHcRed'};
G=[0.327,1.307,0.715,2.71,9.93,0.792,11.76,3.02,3.70,15.4]; %order is same as above
%G for CFP/Cit determined by experiment is 0.088; theoretical value is 0.327
%G for GFP/mCherry is an estimate pending obtaining actual filter spectra

switch param
    case 'list'
        exp_data=experiments;
    case 'G'
        index=find(strcmp(experiments,exp_type));
        exp_data=G(index);
end