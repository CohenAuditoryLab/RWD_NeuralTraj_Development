%% Intro and log

%This code is for trying to first simulate how neural trajectories may go
%and what our statistics look like when we have a priori knowledge this
%probably won't be used directly in CE but is good to know tools work
%before we try them out on the PFC data

%Also from that standpoint, going to write for PFC data first and then
%circle back to simulating what we think will happen in auditory regions

%Note: Will ultimately use PFC date but for now using info gleaned from
%Figure 4 of Tsunada et al. 2016 (microstim causal contribution paper)
%which as firing rates from AL and ML

%19-3-7: basics all work, will continue to adjust these to make them more
%realistic but for now has led to some insights already and may be useful
%in the future for statistical power analyses.

%Obvious next steps for basic sim work:
%- Chat with Yale
%- Make actual trajectories/have correlations between neurons
%- Think about how to do these as actual power analyses







%Also general note: will move this over to python as soon as that seems
%viable (most likely after candidacy exam).  Kept in Matlab for now jsut
%for ease of loading data


%*************just leaving to be lazy right now for PCA stuff
clear all
%**************
%% Notes on Simulating small population of cells

%trials run from .6 to .8 seconds based on reaction time

%First just doing some binning to say average firing rate in a time window,
%will pay with size of time window for actual data

%for now say window is 50 ms (go back to Flinker et al. 2019
%Spectrotemporal modulations...framework to see potential integration
%windows.  This is in human but may be a good place to start)

%From figure 4 B in above indicated paper: Using AL data since it was
%choice modulated
%average min firing rate through trial is ~10 Hz in  AL
%average peak firing rate is ~28 Hz
%range is large though, shows one ML neuron in a that gets to ~140 Hz

%Note: can use code from contam_st_gen to generate spike trains with these
%average firing rates if wanted (maybe just change average and
%concatenate...)

%ALSO VERY IMPORTANT: NOT ACTUALY TRYING TO SIMULATE ACTUAL RESULTS OF
%PAPER JUST USING THESE TO MAKE CONTRIVED NEURAL TRAJECTORIES WITH SEMI
%REAL NEURONAL PROPERTIES

%% 1 Test Euclidian distance between frames and ending point

%First pass: %Going to pull from normal (since pulling averages and just have a
%different number of pulls
%don't need to normalize yet since all neurons on the same scale

%Instead of binning may think of just doing a moving average for firing
%rate...unclear what is done in the paper to generate figure 4; need to ask
%Yale.  Without this may have to few bins to really assess anything

N_neurons = 75; %number of neurons

Trial_length = 1; %in seconds
Bin_size = .010; % in seconds (10 ms)

N_bins = floor(Trial_length / Bin_size); %number of bins in session

%Have it go low - high - medium stable as it does in paper.  Euclidian distance
%shortened by decreasing the variance of the normal from the draws

fraction_of_sesh = [0.2 .7]; %set up when to switch means

Mean_FRs = [15 27 20]; %all in Hz

Var_difference = .78; %percent of Traj1 var that is Traj2 var (i.e. .2 means it is 20% of the varaince of Traj1

Piece1 = 1:floor(N_bins.*fraction_of_sesh(1));

Piece2 = Piece1(end)+1:floor(N_bins.*fraction_of_sesh(2));

Piece3 = Piece2(end)+1:N_bins;

%Put loop here if want to do multiple trials

Traj1 = zeros(N_neurons, N_bins);

Traj1_var = [5 1];

Traj2 = zeros(N_neurons, N_bins);

%Pre-learning set is Traj1
%Post-learning set is Traj2

%Note: probably don't have to do for loop and can do in one line, but, eh, fine for
%now...
%...nevermind this bothers me making it into single lines now

    
    Traj1(:,Piece1) = normrnd(Mean_FRs(1),Traj1_var(1),[N_neurons, length(Piece1)]);
    
    Traj2(:,Piece1) = normrnd(Mean_FRs(1),Traj1_var(1)*Var_difference,[N_neurons, length(Piece1)]);
     
    Traj1(:,Piece2) = normrnd(Mean_FRs(2),Traj1_var(1),[N_neurons, length(Piece2)]);
    
    Traj2(:,Piece2) = normrnd(Mean_FRs(2),Traj1_var(1)*Var_difference,[N_neurons, length(Piece2)]);
    
    %Make last piece have very low variance to reflect attracting to end
    %point
    
    Traj1(:,Piece3) = normrnd(Mean_FRs(3),Traj1_var(2),[N_neurons, length(Piece3)]);
    
    Traj2(:,Piece3) = normrnd(Mean_FRs(3),Traj1_var(2),[N_neurons, length(Piece3)]);
    


%Get distances between frames
%potentially more efficient way with norms but this should at least work
%for now

Dis_Traj1 = sqrt(sum((Traj1(:,2:end)-Traj1(:,1:end-1)).^2,1));

Dis_Traj2 = sqrt(sum((Traj2(:,2:end)-Traj2(:,1:end-1)).^2,1));

% T1_med = median(Dis_Traj1);
% T1_mean = mean(Dis_Traj1);
% 
% T2_med = median(Dis_Traj2);
% T2_mean = mean(Dis_Traj2);

%Basic idea works 3/7/19 but should be definition work
%Now can play with magnitude of change based on changing var difference or
%other parameters

%Now adding basic stats test (welch t since we know the variances are not
%equal and right since we think that Dis_Traj1 is greater than Dis_Traj2

%Keep playing with this but this generally shows some okay results...this
%is not exactly what we are going to do (we are going to median distance
%between things...but for now this is okay.

%Main result is even if we let the session be equally invariant for the
%end point  we still can still detect a difference with a 25% change in
%variance between Traj1 and Traj2

[h,p]= ttest2(Dis_Traj1, Dis_Traj2, 'Tail', 'right', 'Vartype', 'unequal')

%Over weekend maybe code this up as a loop but for now this is
%okay/something I can work with

%% 2 Calculating Neural Traj Length

%Maybe put in slightly different simulation where things are more of a
%trajectory in time than this (i.e. use a parametric equation for change in
%firing rate

%For now can just use above and calculate.  Should still hold true even
%though not explicitly shortening Traj Length

%dividing by n neurons just to have some sence of scalling

total_length1_Nnorm = sum(Dis_Traj1)/N_neurons 

total_length2_Nnorm = sum(Dis_Traj2)/N_neurons

%If construct curves, also explore spline fitting.


%% 3 PCA and check dim reduction

%***************Note: need redo sim if rerunning this otherwise just keep
%stablizing more neurons*********************************************

%For dim reduction select number neurons to decrease firing rate to a
%stable value

%First pass, decrease them to zero

%For now also just going to use traj from above and reset some of the
%neurons to near constant + noise
stable_fraction = .15; %fraction of neurons to stablize (i.e. percent as decimal)

N_to_stable = floor(N_neurons *stable_fraction); %Stablize certain percent of all neurons

neuron_inds = randsample(N_neurons, N_to_stable);

stable_fr = 15; %in Hz, stable firing rate for neurons, just chose min for ease

%Leave Traj1 alone since Traj2 is our "post-learning" Trajectory
%Taking stable firing rate and adding gaussian noise (mean 0 Hz with var 1)

    
    Traj2(neuron_inds, :) = stable_fr + normrnd(0,1,[N_to_stable, N_bins]);
    


%Then run PCA
%Focus is on explained and how much variance is explained by each component
%should achieve more variance explained with less components in two than one
%Due to fact that some of the neurons are now stable

[coeff1,~,latent1,~,explained1] = pca(Traj1);

[coeff2,~,latent2,~,explained2] = pca(Traj2);

%% Plot PCA stuff
figure(3)
plot(explained1,'b.')
hold on
plot(explained2, 'r.')
title('Percent Var explained per PCA')
xlabel('PCA #')
ylabel('Percent Var Explained')
axis([0 N_neurons 0 max(explained2)+10])
legend('Non-learning Traj', 'Learning Traj')
hold off

figure(4)
plot(cumsum(explained1),'b.')
hold on
plot(cumsum(explained2), 'r.')
plot(1:N_neurons-1, ones(1,length(explained2))*80,'k--') %puts a dashed line at 80 percent
title('Cumulative Percent Var explained per PCA')
xlabel('PCA #')
ylabel('Cumulative Percent Var Explained')
axis([0 N_neurons 0 100])
legend('Non-learning Traj', 'Learning Traj')


