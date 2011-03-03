%miscellaneous default parameters

FRET_OPTIONS.bitdepth=14;
%xtalk fitting
FRET_OPTIONS.threshold_const=200;
FRET_OPTIONS.threshold_frac=0.1;

FRET_OPTIONS.bkgd_method='mode';
assignin('base','FRET_OPTIONS',FRET_OPTIONS);