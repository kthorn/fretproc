function suffix=get_suffix(exp_type)
%get_suffix.m: function to encapsulate file suffixes from metamorph
%exp_type can be one of 'CY' - CFP/YFP fret; 'CT' - CFP/tdimer2 FRET; or 
%'GT' - GFP/tdimer2 FRET; 

exp_list={'CY';'CY2';'CY3';'CY4';'CT';'GT';'CY_Xe';'CphiY'};

if (nargin==0)
    suffix=exp_list;
    return; 
end
if (strcmpi(exp_type,'CY'))
    suffix.fret='_w1cfp-yfp fret.tif';
    suffix.acceptor='_w2yfp.tif';
    suffix.donor='_w3cfp -w-yfp-.tif';
    suffix.dic='_w4dic-camera.tif';
elseif (strcmpi(exp_type,'CY2'))
    suffix.fret='_w2cfp-yfp fret.tif';
    suffix.acceptor='_w3yfp.tif';
    suffix.donor='_w4cfp -w-yfp-.tif';
    suffix.dic='_w5dic-camera.tif';
elseif (strcmpi(exp_type,'CY3'))
    suffix.fret='_w1cfp-yfp fret.tif';
    suffix.acceptor='_w2yfp.tif';
    suffix.donor='_w3cfp.tif';
    suffix.dic='_w4dic-camera.tif';
elseif (strcmpi(exp_type,'CY4'))
    suffix.fret='_w2cfp-yfp fret.tif';
    suffix.acceptor='_w3yfp.tif';
    suffix.donor='_w4cfp.tif';
    suffix.dic='_w5dic-camera.tif';
elseif (strcmpi(exp_type,'CT'))
    suffix.fret='_w1cfp-dsred fret.tif';
    suffix.acceptor='_w2dsred -w-cfp-.tif';
    suffix.donor='_w3cfp -w-dsred-.tif';
    suffix.dic='_w4dic-camera.tif';
elseif (strcmpi(exp_type,'GT'))
    suffix.fret='_w1gfp-dsred fret.tif';
    suffix.acceptor='_w2dsred -w-gfp-.tif';
    suffix.donor='_w3gfp.tif';
    suffix.dic='_w4dic-camera.tif';
elseif (strcmpi(exp_type,'CY_Xe'))
    suffix.fret='_w1cy fret xe.tif';
    suffix.acceptor='_w2yfp xe.tif';
    suffix.donor='_w3cfp xe.tif';
    suffix.dic='_w4dic-camera.tif';
elseif (strcmpi(exp_type,'CphiY'))
    suffix.fret='_w1cfp-yfp fret.tif';
    suffix.acceptor='_w2yfp.tif';
    suffix.donor='_w3cfp -w-yfp-.tif';
    suffix.dic='_w4dic-camera.tif';
else
    error('Unknown experiment type')
end
