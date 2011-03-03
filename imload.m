function Istruct = imload (filename, bkgd_method, fileformat)
%IMLOAD(FILENAME, METHOD): Loads an image, converts to double,
%background subtracts.
%bkgd_method is one of 'none', 'median', 'min', or 'regional'
%fileformat is one of 'metamorph', 'niselements', or 'micromanager'
switch fileformat
    case 'metamorph'
        [S,n]=mmread(filename);
        get exposure time from mmread output
        [s,f,t]=regexp(S.info,'Exposure:\s+(\d+)\s+(\w+)');
        pos=t{1};
        Istruct.exp_time=strread(S.info(pos(1,1):pos(1,2)));
        exp_units=S.info(pos(2,1):pos(2,2));
        switch lower(exp_units)
            case 'ms'
            case 's'
                Istruct.exp_time=Istruct.exp_time*1000;
            otherwise
                error('Unknown( exposure time units')
        end

        Get bitdepth from mmread output
        This only works for Orca-II-ER
        [s,f,t]=regexp(S.info,'Bit Depth:\s+(\d+)\s+(\w+)');
        if (max(size(t))>0)
            pos=t{1};
            Istruct.bitdepth=strread(S.info(pos(1,1):pos(1,2)));
        end
        Istruct.Iraw=double(S.data);
        %timestamp
        Istruct.datetime=S.datetime;

    case 'micromanager'
        [S,n]=mmread(filename);
        time = inputdlg ('Please enter exposure time in msec: ')
        Istruct.exp_time = str2double(time);
        %Get bitdepth from FRET_OPTIONS ... eventually
        %for now use a kludge
        Istruct.bitdepth = 16;
        maxval=(2^Istruct.bitdepth)-1;
        %actual image
        Istruct.Iraw=double(S.data);

    case 'niselements'
        Istruct.Iraw=double(imread(filename));
        time = inputdlg ('Please enter exposure time in msec: ')
        Istruct.exp_time = str2double(time);
        %Get bitdepth from FRET_OPTIONS ... eventually
        %for now use a kludge
        Istruct.bitdepth = 14;
        maxval=(2^Istruct.bitdepth)-1;
end

%do background subtraction
bkgd_method=lower(bkgd_method);
switch bkgd_method
    case 'none'
        Istruct.Ibkgd=0;
    case 'min'
        Istruct.Ibkgd=min(Istruct.Iraw(:));
    case 'median'
        Istruct.Ibkgd=median(Istruct.Iraw(find(Istruct.Iraw<maxval)));
    case 'mode'
        a=tabulate(Istruct.Iraw(find(Istruct.Iraw<maxval)));
        Istruct.Ibkgd=mean(a(find(a(:,2)==(max(a(:,2)))),1));
    case 'regional'
        Istruct.Ibkgd=imopen(Istruct.Iraw,strel('disk',40));
end
Istruct.I=Istruct.Iraw-Istruct.Ibkgd;