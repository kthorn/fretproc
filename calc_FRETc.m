function calc_FRETc(setnames, xtalk)
%Calculates FRETc plane for existing image set
for set_idx=1:max(size(setnames))
    set=evalin('base',setnames{set_idx});         %pass in structure from base workspace
    AF=set.autofluor;
    for n=1:size(set.image,2)       %loop over all images
        FRETc=zeros(size(set.image(n).fret));
        fitmap=zeros(size(set.image(n).fret));  
        FRETb=double(set.image(n).fret)-AF(3);
        CFPb=double(set.image(n).donor)-AF(1);
        YFPb=double(set.image(n).acceptor)-AF(2);
        if (isfield(xtalk,'low_cutoff'))       %if we have median fit results
            %if above YFP low cutoff but below CFP low cutoff, interpolate on YFP
            clear vals
            vals=find(CFPb<=xtalk.low_cutoff(1) & YFPb>xtalk.low_cutoff(2));
            FRETc(vals)=FRETb(vals) - interp1(xtalk.Ylow(:,1),xtalk.Ylow(:,2),(YFPb(vals)));
            fitmap(vals)=50
            %if above CFP low cutoff but below YFP low cutoff, interpolate on CFP
            clear vals
            vals=find(CFPb>xtalk.low_cutoff(1) & YFPb<=xtalk.low_cutoff(2));
            FRETc(vals)=FRETb(vals) - interp1(xtalk.Clow(:,1),xtalk.Clow(:,2),(CFPb(vals)));
            fitmap(vals)=30;
            %if both between low and high cutoffs,subtract off greater interpolated value
            clear vals
            vals=find(CFPb>xtalk.low_cutoff(1) & CFPb<xtalk.high_cutoff(1) & YFPb>xtalk.low_cutoff(2) &YFPb<xtalk.high_cutoff(2));
            FRETc(vals)=FRETb(vals) - max(interp1(xtalk.Ylow(:,1),xtalk.Ylow(:,2),(YFPb(vals))),interp1(xtalk.Clow(:,1),xtalk.Clow(:,2),(CFPb(vals))));
            fitmap(vals)=10;  
            %if either above high cutoff, use linear fit on both
            clear vals
            vals=find(CFPb>=xtalk.high_cutoff(1) | YFPb>=xtalk.high_cutoff(2));
            FRETc(vals)=FRETb(vals) - (xtalk.fit(1)*CFPb(vals)) - (xtalk.fit(2)*YFPb(vals)) - xtalk.fit(3);
            fitmap(vals)=100;
            %if both below low cutoff, just subtract offset
            clear vals
            vals=find(CFPb<=xtalk.low_cutoff(1) & YFPb<=xtalk.low_cutoff(2));
            FRETc(vals)=FRETb(vals) - xtalk.low_offset;
            fitmap(vals)=0;
            set.image(n).fitmap = int16(fitmap);
        else                %just do linear correction
            FRETc=FRETb - xtalk.fit(1)*CFPb - xtalk.fit(2)*YFPb - xtalk.fit(3);
        end
        set.image(n).FRETc = int16(FRETc);  
        
        %get exposure times
        donor_exp=set.exp_time.donor;
        acceptor_exp=set.exp_time.acceptor;
        fret_exp=set.exp_time.fret;
        
        %calculate an efficiency channel
        G=get_exp_type('G',set.exp_type);
        warning off MATLAB:divideByZero
        E=((FRETc/fret_exp)*G)./((CFPb/donor_exp)+(FRETc/fret_exp)*G);
        warning on MATLAB:divideByZero
        set.image(n).E=single(E);
        
        %calculate the error in efficiency
        %eliminate intensities <0 by setting a floor at 0
        CFP_err=sqrt(max(CFPb,0))+4;
        YFP_err=sqrt(max(YFPb,0))+4;
        FRETb_err=sqrt(max(FRETb,0))+4;
        %should also include errors in fitting
        FRETc_err=sqrt((xtalk.fit(1)*CFP_err).^2 + (xtalk.fit(2)*YFP_err).^2 + FRETb_err.^2);
        dEdC=-(FRETc*G).*(CFPb+FRETc*G).^-2;
        dEdF=G*((CFPb+FRETc*G).^-1 - (FRETc*G).*(CFPb+FRETc*G).^-2);
        E_err=sqrt((CFP_err.^2).*(dEdC.^2) + (FRETc_err.^2).*(dEdF.^2));
        set.image(n).E_err=single(E_err);
    end
    assignin('base',setnames{set_idx},set)        %update setname in base workspace
end
