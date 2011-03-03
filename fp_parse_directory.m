function [imnames, type] = fp_parse_directory (directory);

type='';
dir_struct=dir(fullfile(directory,'*.nd')); %look for Metamorph files
if ~isempty(dir_struct)                     %if there are Metamorph files, parse them.
    type='metamorph';
    imnames={};
    i=1;
    for n=1:size(dir_struct,1)
        [s,f,t]=regexp(dir_struct(n).name,'(.+?)_\d+\.nd');
        t=cell2mat(t);
        currname=dir_struct(n).name(t(1):t(2))
        if max(strcmp(imnames, currname));
            continue
        else
            imnames{i}=currname;
            i=i+1;
        end
    end
    return
end

dir_struct=dir(fullfile(directory,'*_*')); %look for Micromanager files
if ~isempty(dir_struct)
    imnames={};
    i=1;
    for n=1:size(dir_struct,1)
        if (dir_struct(n).isdir)                %make sure that it's a directory
            [s,f,t]=regexp(dir_struct(n).name,'(.+?)_\d+');
            if ~isempty(t)
                type='micromanager';
                t=cell2mat(t);
                currname=dir_struct(n).name(t(1):t(2));
                if max(strcmp(imnames, currname));
                    continue
                else
                    imnames{i}=currname;
                    i=i+1;
                end
            end
        end
    end
end
if max(strcmp(type, 'micromanager'));
    return
end
dir_struct=dir(fullfile(directory,'*xy*')); %look for NIS-Elements multiposition files
if ~isempty(dir_struct)
    imnames={};
    i=1;
    for n=1:size(dir_struct,1)
        [s,f,t]=regexp(dir_struct(n).name,'(.+?)xy\d+c\d+');
        if ~isempty(t)
            type='niselements';
            t=cell2mat(t);
            currname=dir_struct(n).name(t(1):t(2));
            if max(strcmp(imnames, currname));
                continue
            else
                imnames{i}=currname;
                i=i+1;
            end
        end
    end
end