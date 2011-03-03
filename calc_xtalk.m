function [xtalk_struct,raw_data]=calc_xtalk(setnames, method)
%[xtalk_struct, raw_data]=calc_xtalk(SETNAMES, METHOD): Calculates crosstalk
%for a FRET data set.  SETNAMES is a cell array of data set names (e.g.
%{'ykt157'; 'ykt158'})
%NOTE: This will update and overwrite parts of the SETNAME structures

for set_idx=1:size(setnames,1)
    set=evalin('base',setnames{set_idx,1});         %pass in structure from base workspace
    maxval=(2^set.bitdepth)-1;
    if ~exist('exp_type')
        exp_type=set.exp_type;
    elseif ~strcmpi(exp_type,set.exp_type)
        warning(['Set name ',setnames{set_idx,1}, 'does not match first experiment type.  Skipping'])
        continue
    end
    if strcmpi(set.sample_type,'B')
        warning(['Set name ',setnames{set_idx,1}, 'is not of type D or A.  Skipping.'])
        continue
    end
    
    %Are we masking off images?
    if (isfield(set.image(1),'Xmask') & strcmpi(input(['Use existing image masks for ',setnames{set_idx,1} ' [Y/N]'],'s'),'Y'))
        disp (['Using existing image masks for ', setnames{set_idx,1}])
    else
        if (~strcmpi(input(['Mask off ', setnames{set_idx,1}, ' images? [Y/N]'],'s'),'n'))
            for n=1:size(set.image,2)       %loop over all images
                F=double(set.image(n).fret);
                DIC=double(set.image(n).dic)/maxval;
                D=double(set.image(n).donor);
                A=double(set.image(n).acceptor);
                
                if (strcmpi(set.sample_type, 'D'))  %if donor only set
                    scale=max([F(:); D(:)]);
                elseif (strcmpi(set.sample_type, 'A'))  %acceptor only                                       
                    scale=max([F(:); A(:)]);
                end
                
                F=max(0,F);
                D=max(0,D);
                A=max(0,A);
                RGB(:,:,1)=min(1,( (F/scale) + DIC*0.5));
                RGB(:,:,2)=min(1,((A/scale) + DIC*0.5));
                RGB(:,:,3)=min(1,((D/scale) + DIC*0.5));
  
                subplot(1,1,1)
                set.image(n).Xmask=sparse(logical(roipoly(RGB)));
                clear RGB F D A
            end
        end
    end
    assignin('base',setnames{set_idx,1},set)        %update setname in base workspace
    
    %cumulate data
    cum_data=set_cum(set);
    raw_data(set_idx).name=setnames{set_idx,1};
    raw_data(set_idx).exp_type=set.exp_type;
    raw_data(set_idx).sample_type=set.sample_type;
    raw_data(set_idx).F=int16(cum_data.F);
    raw_data(set_idx).D=int16(cum_data.D);
    raw_data(set_idx).A=int16(cum_data.A);
    
    raw_data(set_idx).fit_type=method;
    sample_type=set.sample_type;
    disp (['fitting ', setnames{set_idx}])
    Y=raw_data(set_idx).F;
    X=raw_data(set_idx).(sample_type);
    switch sample_type
        case 'D'
            xaxis_title='Donor';
        case 'A'
            xaxis_title='Acceptor';
    end
    switch method
        case 'lsq'
            result=lsq_fit(double(X),double(Y),setnames{set_idx},xaxis_title);
            raw_data(set_idx).params=result;
        case 'mean'
            result=mean_fit(double(X),double(Y),setnames{set_idx},xaxis_title);
            raw_data(set_idx).params=result;
    end
end

%calculate joint fit of all data
xtalk_struct.method=method;
xtalk_struct.source=setnames;
clear F D A
[F, D, A]=raw_data_cum(raw_data,'D');
if ~isempty(F)
    disp ('Calculating joint donor fit')
    switch method
        case 'lsq'
            result=lsq_fit(double(D),double(F),'joint donor fit','Donor');
        case 'mean'
            result=mean_fit(double(D),double(F),'joint donor fit','Donor');
    end
end
xtalk_struct.D_fit=result; 
clear F D A
[F, D, A]=raw_data_cum(raw_data,'A');
if ~isempty(F)
    disp ('Calculating joint acceptor fit')
    switch method
        case 'lsq'
            result=lsq_fit(double(A),double(F),'joint acceptor fit','Acceptor');
        case 'mean'
            result=mean_fit(double(A),double(F),'joint acceptor fit','Acceptor');
    end
end
xtalk_struct.A_fit=result; 
clear F D A 

%CHECK IF BOTH DONOR AND ACCEPTOR SETS ARE PRESENT
samples=[raw_data.sample_type];
if (max(samples=='A') & max(samples=='D'))
    disp ('Calculating overall fit for all data')
    %calculate overall fit
    [Fd, Dd, Ad]=raw_data_cum(raw_data,'D');
    [Fa, Da, Aa]=raw_data_cum(raw_data,'A');
    switch method
        case 'lsq'
            result=lsq_fit_3d(Fd,Dd,Ad,Fa,Da,Aa)
            xtalk_struct.fit=result;        %joint fit result
        case 'mean'
            result=mean_fit_3d(Fd,Dd,Ad,Fa,Da,Aa)
            xtalk_struct.fit=result;        %joint fit result
    end
    subplot(4,1,1)
    Fd_calc=result(1)*Dd + result(2)*Ad + result(3);
    plot(Dd,Fd,'.b',Dd,Fd_calc,'.r')
    xlabel('Donor intensity')
    ylabel('FRET intensity')
    subplot(4,1,2)
    plot(Dd,Fd-Fd_calc,'.')
    title('residuals')
    subplot(4,1,3)
    Fa_calc=result(1)*Da + result(2)*Aa + result(3);
    plot(Aa,Fa,'.b',Aa,Fa_calc,'.r')
    xlabel('Acceptor intensity')
    ylabel('FRET intensity')
    subplot(4,1,4)
    plot(Aa,Fa-Fa_calc,'.')
    title('residuals')
    Aresid=double(Fa)-double(Da)*result(1)-double(Aa)*result(2) - result(3);
    Dresid=double(Fd)-double(Dd)*result(1)-double(Ad)*result(2) - result(3);
    meanD=mean(Dresid)
    meanA=mean(Aresid)
end

%do median fit to get look-up table, offset
%[Abin,AFbin,cutoff,Pa2]= medfit(Atot,Ftot);   
%A_high_cutoff=cutoff;
%Alow=[Abin(1:cutoff),AFbin(1:cutoff)];

%-------------------------------------------------------
function cum_data=set_cum(set)
threshold_frac=0.1;            %fraction of max intensity to keep for calculation
threshold_const=200;            %minimum intensity to keep for calculation
for n=1:size(set.image,2)       %loop over all images
    D=double(set.image(n).donor);
    A=double(set.image(n).acceptor);
    F=double(set.image(n).fret);
    if (isfield(set.image(n),'Amask'))
        mask=full(double(set.image(n).Amask));
    else
        mask = ones(size(F));
    end
    if strcmpi(set.sample_type,'D')         %donor only
        D=D.*mask;                  %mask off D
        [i]=find((D>0) & (F>0));
    elseif strcmpi(set.sample_type,'A')
        A=A.*mask;                  %mask off A
        [i]=find((A>0) & (F>0));
    end
    if ~exist('Fcum') | isempty(Fcum)
        Fcum=F(i);
        Acum=A(i);
        Dcum=D(i);
    else
        Fcum=cat(1,Fcum,F(i));
        Acum=cat(1,Acum,A(i));
        Dcum=cat(1,Dcum,D(i));
    end 
end
switch set.sample_type
    case 'A'
        thresh=max(threshold_const,threshold_frac*max(A(:)));
        i=find(Acum>thresh);
    case 'D'
        thresh = max(threshold_const,threshold_frac*max(D(:)));
        i=find(Dcum>thresh);
end
cum_data.F=Fcum(i);
cum_data.A=Acum(i);
cum_data.D=Dcum(i);
%-------------------------------------------------------
function [F, D, A] = raw_data_cum(raw_data,sample_type)
for n=1:size(raw_data,2)     
    if ~strcmpi(sample_type,raw_data(n).sample_type)     %check if we have right sample type
        continue
    end
    if ~exist('exp_type')
        exp_type=raw_data(n).exp_type;
    elseif ~strcmpi(exp_type,raw_data(n).exp_type)
        warning(['Mismatched experiments in raw_data_cum.  Skipping ', raw_data(n).name])
        continue
    end
    
    if ~exist('F') | isempty(F)
        F=raw_data(n).F;
        D=raw_data(n).D;
        A=raw_data(n).A;
    else
        F=cat(1,F,raw_data(n).F);
        D=cat(1,D,raw_data(n).D);
        A=cat(1,A,raw_data(n).A);
    end 
end

%make sure we return something
if ~exist('F')
    F=[];
    D=[];
    A=[];
end
F=double(F);
D=double(D);
A=double(A);
%-------------------------------------------------------  
function result = lsq_fit(X,Y,plot_title,xaxis_title)

Yerr=sqrt(abs(Y))+4;
Xerr=sqrt(abs(X))+4;

d=([X,Y,Xerr,Yerr]);
param0=[0.2 50];
fresult= fminsearch(@lsq2d,param0,[],d)

%see how our fit looks
figure(1)
clf
resid=Y-X*fresult(1) - fresult(2);
linex=(0:10)*max(X)/10;
liney=fresult(1)*linex+fresult(2);
subplot(2,1,1)
plot(X,Y,'.b',linex,liney,'-r')
title(plot_title)
ylabel('FRET')
xlabel(xaxis_title)
subplot(2,1,2)
plot(X,resid,'.')
title('residuals')
drawnow
result=fresult;

%-------------------------------------------------------  
function result = mean_fit(X,Y,plot_title,xaxis_title)
a=1;
for n=min(X):max(X)
    pix=find(X==n);
    if isempty(pix)
        continue
    end
    Xbin(a)=n;
    Ybin(a)=mean(Y(pix));
    Yerr(a)=std(Y(pix));
    a=a+1;
end
badpix=(find(Yerr==0));
Yerr(badpix)=4*sqrt(Ybin(badpix));                  %factor of 4 scales errors closer to stddev of binned pixels

d=([Xbin',Ybin',zeros(size(Xbin')),Yerr']);
param0=[0.2 50];
fresult= fminsearch(@lsq2d,param0,[],d)

%see how our fit looks
figure(1)
clf
resid=Y-X*fresult(1) - fresult(2);
linex=(0:10)*max(Xbin)/10;
liney=fresult(1)*linex+fresult(2);
subplot(2,1,1)
hold on
plot(X,Y,'.b',linex,liney,'-r')
errorbar(Xbin,Ybin,Yerr,'-g')
title(plot_title)
ylabel('FRET')
xlabel(xaxis_title)
subplot(2,1,2)
plot(X,resid,'.')
title('residuals')
drawnow
result=fresult;

%----------------------------------------------------------
function  result=mean_fit_3d(Fd,Dd,Ad,Fa,Da,Aa)
a=1;
%calculate mean for donor channel
for n=min(Dd):max(Dd)
    pix=find(Dd==n);
    if isempty(pix)
        continue
    end
    Ddbin(a)=n;
    Fdbin(a)=mean(Fd(pix));
    Fderr(a)=std(Fd(pix));
    Adbin(a)=mean(Ad(pix));
    Aderr(a)=std(Ad(pix));
    a=a+1;
end
badpix=(find(Fderr==0));
Fderr(badpix)=4*sqrt(Fdbin(badpix));
badpix=(find(Aderr==0));
Aderr(badpix)=4*sqrt(Adbin(badpix));
%set Dderr to all ones
Dderr=ones(size(Ddbin));

a=1;
%calculate mean for acceptor channel
for n=min(Aa):max(Aa)
    pix=find(Aa==n);
    if isempty(pix)
        continue
    end
    Aabin(a)=n;
    Fabin(a)=mean(Fa(pix));
    Faerr(a)=std(Fa(pix));
    Dabin(a)=mean(Da(pix));
    Daerr(a)=std(Da(pix));
    a=a+1;
end
badpix=(find(Faerr==0));
Faerr(badpix)=sqrt(Fabin(badpix));
badpix=(find(Dderr==0));
Dderr(badpix)=sqrt(Ddbin(badpix));
Aaerr=ones(size(Aabin));
D=[Ddbin,Dabin]';
A=[Adbin,Aabin]';
F=[Fdbin,Fabin]';
Derr=[Dderr,Daerr]';
Aerr=[Aderr,Aaerr]';
Ferr=[Fderr,Faerr]';
d=([D,A,F,Derr,Aerr,Ferr]);
param0=[0.2 0.2 50];
result= fminsearch(@lsq3d,param0,[],d);

%-----------------------------------------------------------------
function  result=lsq_fit_3d(Fd,Dd,Ad,Fa,Da,Aa)
D=[Dd;Da];
A=[Ad;Aa];
F=[Fd;Fa];
Derr=sqrt(D);
Aerr=sqrt(A);
Ferr=sqrt(F);
d=([D,A,F,Derr,Aerr,Ferr]);
param0=[0.2 0.2 50];
result= fminsearch(@lsq3d,param0,[],d);