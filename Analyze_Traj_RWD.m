%% Adaptation of example code from Byron and Peeps
%2019-07-31
%Goal is to change this slightly to accomdate our data format and general
%goals.  Note: need to have NeuralTraj_v0300 on path for this code to work
%2019-08-02
%Update: can now feed in data and did get dat_AC analyzed
%Data from PFC tosses odd error, figure out work out later

%%
% ===========================================
% 1) Basic extraction of neural trajectories
% ===========================================


%% Get data files
% local = 'C:\Users\ronwd\Desktop\MATLAB\NeuralTraj_Lalitta\Code_from_Yu_website\NeuralTraj_v0300_RWD\Lalitta_Data';
% file_name = [local '']; %manually enter file name for now.
% 
% load(file_name);

load('C:\Users\ronwd\Desktop\MATLAB\NeuralTraj_Lalitta\NeuralTraj_v0300_RWD\Lalitta_Data\190719_MrM_AudiResp_24_24_PT2_Rwdedit.mat')

[dat_PFC, dat_AC]=preprocess_Ldata2(allAlign_spkDisp_RWD); 
%%
%little snippet of code to pull specific stimuli
%stim_ind = 4; dat = dat_AC(arrayfun(@(x) x.stimIndex==stim_ind, dat_AC));

%% Index run and select method

%Set brain region for saving

brainregion = 'AC'; %my have to change this so this fires in preprocess step instead...think on it
%for stimind = 1:30

%%%little snippet of code to pull specific stimuli
%%%stimind = 4;
%%%********************DOUBLE CHECK******************************************
%dat = dat_AC(arrayfun(@(x) x.stimIndex==stimind, dat_AC)); 
                       %%%not technically doesn't matter which dat goes second here as both are from same recording
                        %%%but for sake consistency just change it
dat = dat_AC; stimind = 999;  %If just want to throw all together

% datFormat is set to 'spikes' for 0/1 spiking activity (see neuralTraj.m)
datFormat = 'spikes';

% Results will be saved in mat_results/runXXX/, where XXX is runIdx.
% Use a new runIdx for each dataset.
%setup new run id based on how many are already in mat_results
temp_names = dir('mat_results');
%runIdx  = (length(temp_names)-3 +1); %need -2 since dir always has . and .. as first elements and mat_results alwayhs has .DS_store
runIdx = stimind; %(probably want to just save using the stim ind or
%otherwise set up a system to have results clearly tie back to their og
%data.  Ultimately may end up having to go into neuraltraj.m and figure out
%how the saving code works

% Select method to extract neural trajectories:
% 'gpfa'   -- Gaussian-process factor analysis
% 'fa'     -- Smooth and factor analysis
% 'ppca'   -- Smooth and probabilistic principal components analysis
% 'pca'    -- Smooth and principal components analysis
method = 'fa';

% Select number of latent dimensions

xDim = 8;
% NOTE: The optimal dimensionality should be found using 
%       cross-validation (Section 2) below.
%Note: we still have to do this, start with 8 for now just for shits and
%gigs

% If using a two-stage method ('fa', 'ppca', or 'pca'), select
% standard deviation (in msec) of Gaussian smoothing kernel.
kernSD = 20; %default 30 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: The optimal kernel width should be found using 
%       cross-validation (Section 2) below.
%Again have to run this as well.

% Extract neural trajectories
%adding try catch block to deal with times when too few spikes or otherwise
%issues with data.  Allows for a for loop to be used.
try
    
result = neuralTraj(runIdx, dat,'datFormat', datFormat, ...
    'method', method, 'xDims', xDim, 'kernSDList', kernSD, 'brainregion', brainregion );
% NOTE: This function does most of the heavy lifting.
catch
    result =[]; %set result to empty if this fails
    
end
%note in estParams gamma is actually tau from the paper, unless gamma
%is 2*tau^2 ... correction gamma is (binwidth/tau)^2.  So tau is
%bindwidth/sqrt(gamma) miliseconds (binwidth and tau are both entered in
%ms)


%added line to actually save results in a format that can actually be
%reanlyzed by postprocess when you load it in (i.e. as is the saved filed
%essentially is a fully unpacked results with each of the fields being a
%separate variable
if ~isempty(result)
save([sprintf(['mat_results/' brainregion 'run%03d'], runIdx) '/result_'  brainregion '_' method '_xDim' num2str(xDim)],'result') %ALWAYS DOUBLE CHECK PATHHHHH
else
   fprintf('Iteration Failed') 
end

%end
%for loop ends here*****************************************************
%% Do postprocess and plot
if ~exist('kernSD','var')
    
    kernSD = 20; %check matches above!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end
% Orthonormalize neural trajectories
[estParams, seqTrain] = postprocess(result, 'kernSD', kernSD);
% NOTE: The importance of orthnormalization is described on 
%       pp.621-622 of Yu et al., J Neurophysiol, 2009.

% Plot neural trajectories in 3D space
close all %just leaving for convenience
maxtrajtoplot = 20; %max number of trajs to plot
%check trajtostart in plot3D_RWD
plot3D_RWD(seqTrain, 'xorth', 'dimsToPlot', 1:3, 'nPlotMax', maxtrajtoplot);
% NOTES:
% - This figure shows the time-evolution of neural population
%   activity on a single-trial basis.  Each trajectory is extracted from
%   the activity of all units on a single trial.
% - This particular example is based on multi-electrode recordings
%   in premotor and motor cortices within a 400 ms period starting 300 ms 
%   before movement onset.  The extracted trajectories appear to
%   follow the same general path, but there are clear trial-to-trial
%   differences that can be related to the physical arm movement. 
% - Analogous to Figure 8 in Yu et al., J Neurophysiol, 2009.
% WARNING:
% - If the optimal dimensionality (as assessed by cross-validation in 
%   Section 2) is greater than 3, then this plot may mask important 
%   features of the neural trajectories in the dimensions not plotted.  
%   This motivates looking at the next plot, which shows all latent 
%   dimensions.

%% TEMPORARY CELL FOR CONVENIENCE
% Plot each dimension of neural trajectories versus time
plotEachDimVsTime(seqTrain, 'xorth', result.binWidth);
% NOTES:
% - These are the same neural trajectories as in the previous figure.
%   The advantage of this figure is that we can see all latent
%   dimensions (one per panel), not just three selected dimensions.  
%   As with the previous figure, each trajectory is extracted from the 
%   population activity on a single trial.  The activity of each unit 
%   is some linear combination of each of the panels.  The panels are
%   ordered, starting with the dimension of greatest covariance
%   (in the case of 'gpfa' and 'fa') or variance (in the case of
%   'ppca' and 'pca').
% - From this figure, we can roughly estimate the optimal
%   dimensionality by counting the number of top dimensions that have
%   'meaningful' temporal structure.   In this example, the optimal 
%   dimensionality appears to be about 5.  This can be assessed
%   quantitatively using cross-validation in Section 2.
% - Analogous to Figure 7 in Yu et al., J Neurophysiol, 2009.

%% cross validation steps
%Note: Ran these on all of AC data: seems like 20ms Kernal SD and Xdim of 8
%work best
%means should re-run FA for all stimuli
%Update 2019-08-08 rerun the cross validation with low firing neurons
%removed

fprintf('\n');
fprintf('Basic extraction and plotting of neural trajectories is complete.\n');
fprintf('Press any key to start cross-validation...\n');
fprintf('[Depending on the dataset, this can take many minutes to hours.]\n');
pause;

% ========================================================
% 2) Full cross-validation to find:
%  - optimal state dimensionality for all methods
%  - optimal smoothing kernel width for two-stage methods
% ========================================================

% Select number of cross-validation folds
numFolds = 4;

% Perform cross-validation for different state dimensionalities.
% Results are saved in mat_results/runXXX/, where XXX is runIdx.
xDims = [2 5 8];

% If 'parallelize' is true, all folds will be run in parallel using 
% Matlab's parfor construct. If you have access to multiple cores, this 
% provides significant speedup. 

parallelize = true;
neuralTraj(runIdx, dat, 'datFormat', datFormat, 'method',  'pca', ...
    'xDims', xDims, 'numFolds', numFolds, 'parallelize', parallelize);
neuralTraj(runIdx, dat, 'datFormat', datFormat, 'method', 'ppca', ...
    'xDims', xDims, 'numFolds', numFolds, 'parallelize', parallelize);
neuralTraj(runIdx, dat, 'datFormat', datFormat, 'method',   'fa', ...
    'xDims', xDims, 'numFolds', numFolds, 'parallelize', parallelize);
neuralTraj(runIdx, dat, 'datFormat', datFormat, 'method', 'gpfa', ...
    'xDims', xDims, 'numFolds', numFolds, 'parallelize', parallelize);

fprintf('\n');
% NOTES:
% - These function calls are computationally demanding.  Cross-validation 
%   takes a long time because a separate model has to be fit for each 
%   state dimensionality and each cross-validation fold.

% Plot prediction error versus state dimensionality.
% Results files are loaded from mat_results/runXXX/, where XXX is runIdx.
kernSD = 20; % select kernSD for two-stage methods
plotPredErrorVsDim(runIdx, kernSD);
% NOTES:
% - Using this figure, we i) compare the performance (i.e,,
%   predictive ability) of different methods for extracting neural
%   trajectories, and ii) find the optimal latent dimensionality for
%   each method.  The optimal dimensionality is that which gives the
%   lowest prediction error.  For the two-stage methods, the latent
%   dimensionality and smoothing kernel width must be jointly
%   optimized, which requires looking at the next figure.
% - In this particular example, the optimal dimensionality is 5. This
%   implies that, even though the raw data are evolving in a
%   53-dimensional space (i.e., there are 53 units), the system
%   appears to be using only 5 degrees of freedom due to firing rate
%   correlations across the neural population.
% - Analogous to Figure 5A in Yu et al., J Neurophysiol, 2009.

% Plot prediction error versus kernelSD.
% Results files are loaded from mat_results/runXXX/, where XXX is runIdx.
xDim = 8; % select state dimensionality
plotPredErrorVsKernSD(runIdx, xDim);
% NOTES:
% - This figure is used to find the optimal smoothing kernel for the
%   two-stage methods.  The same smoothing kernel is used for all units.
% - In this particular example, the optimal standard deviation of a
%   Gaussian smoothing kernel with FA is 30 ms.
% - Analogous to Figures 5B and 5C in Yu et al., J Neurophysiol, 2009.
