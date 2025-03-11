%% VLSM and MLSM analyses 
% (c/o https://aphasialab.org/vlsm/ and https://github.com/atdemarco/svrlsmgui, respectively)

% VLSM 
vlsm2('vlsm_design.txt','lesions','vlsm_ss','highscoresarebad',false,'nperms',1000,'maskthresh',5,'vars',{'alt_spont','overall','LesionSize','aos','qabEval','daysPost'}); % vlsmROI = vlsm_ss/t_0.001_thresh.nii
vlsm2('vlsm_design_tumorOnly.txt','lesions','vlsm_ss_tumorOnly','highscoresarebad',false,'nperms',1000,'maskthresh',5,'vars',{'alt_spont','overall','LesionSize','aos','qabEval','daysPost'}); 

% MLSM 
svrlsmgui; % File --> Open... --> mlsm_params.mat; mlsmROI = mlsm_ss/[date_run]/alt_spont, high scores are good/Voxwise p005 (1000 perms)/Clustwise p05 (1000 perms)/Signif clusts cluster pvals (inv).nii');

%% Risk and Odds Ratios

% load LSM-ROI (result of vlsmROI>0.5 & mlsmROI>0.5)
[~,lsmROI]=read_nifti('lsmROI.nii');
mask=lsmROI>0;

% load design file
design=readtable('vlsm_design.txt');

% find participants with LSM-ROI resections
les_thresh=mean(design.lsmROI_sim)+1.5*std(design.lsmROI_sim);
lsm_les=design.lsmROI_sim>=les_thresh;
rsxn_pts=design(lsm_les,:);

% find participants who meet behavioral criteria for spontaneous speech deficit
beh_thresh=mean(design.overall-design.alt_spont)+1.5*std(design.overall-design.alt_spont);
ss_def=(design.overall-design.alt_spont)>=beh_thresh & design.aos==false;

% create contingency table
cont_tbl=table([sum(lsm_les&ss_def);sum(lsm_les&~ss_def)],[sum(~lsm_les&ss_def);sum(~lsm_les&~ss_def)],'VariableNames',{'rsxn','noRsxn'},'RowNames',{'ssDef','noSSDef'});

% conduct risk and odds ratio analysis (c/o https://www.mathworks.com/matlabcentral/fileexchange/15347-odds)
odds(table2array(cont_tbl))

%% Chi-square and rank-sum tests

rsxn_pt_has_def=(rsxn_pts.overall-rsxn_pts.alt_spont)>=beh_thresh & rsxn_pts.aos==false;
rsxn_pts=addvars(rsxn_pts,rsxn_pt_has_def,'NewVariableNames','has_deficit');

[tbl_path,chi2stat_path,pval_path]=crosstab([rsxn_pts.pathology(rsxn_pts.has_deficit==true);rsxn_pts.pathology(~rsxn_pts.has_deficit)],[zeros(sum(rsxn_pts.has_deficit),1);ones(sum(~rsxn_pts.has_deficit),1)]);
[tbl_eval,chi2stat_eval,pval_eval]=crosstab([rsxn_pts.qabEval(rsxn_pts.has_deficit==true);rsxn_pts.qabEval(~rsxn_pts.has_deficit)],[zeros(sum(rsxn_pts.has_deficit),1);ones(sum(~rsxn_pts.has_deficit),1)]);

allPs=[];
varsToTest=[find(strcmp(rsxn_pts.Properties.VariableNames,'les_size')), find(strcmp(rsxn_pts.Properties.VariableNames,'age')),find(strcmp(rsxn_pts.Properties.VariableNames,'daysPost')), find(endsWith(rsxn_pts.Properties.VariableNames,'_L'))];
for i=varsToTest
    [p,h,stats]=ranksum(rsxn_pts{rsxn_pts.has_deficit==true,rsxn_pts.Properties.VariableNames{i}},rsxn_pts{rsxn_pts.has_deficit==false,rsxn_pts.Properties.VariableNames{i}});
    fprintf('%s - U %0.3f, p %0.4f\n',rsxn_pts.Properties.VariableNames{i},stats.ranksum,p)
    allPs=[allPs;p];
end