%First shot at analyzing data
%Using PFC data for now since still unclear which is better
%...PFC seems to all be from unstimulated case which seem weird is
%unhelpful so probably going with AL data, but regardless can practice
%techniques on this data set for now just so have some numbers

%% Load in of control data for first pass

names = dir('C:\Users\ronwd\Desktop\MATLAB\Konrad_Kausality_Project\PFC_Pairs\Algn1');

names = {names.name};

names = names(3:end); %get rid of . and .. at beginning that is always there when you use dir

%HERE WOULD BE SOMETHING THAT CHECKS LEAD FILE NAME TO MAKE SURE GRABBING FROM SAME SESSION%

%for now just hard code

neurons_in_session = 4;
shift = 0;
Session_Data = cell(neurons_in_session,1);

for i = 1:neurons_in_session
    
    Data = load(['C:\Users\ronwd\Desktop\MATLAB\Konrad_Kausality_Project\PFC_Pairs\Algn1\' names{1+shift}]);
    Session_Data{i} = Data.Data;
    
end

%Microstim preprocessing/other preprocessing
%May need to pool accross sessions with similiar stimuli

%% Calculate neural trajectory

%for now using spike times and just doing Euclidian distance between each
%subsequent frame to get a total length of trajectories/distribution of
%distance length (between successive frames)

%Above naturally brings up a binning question, but let's just get this for
%now

%Try this with just all high and all low since these make up the majority
%of trials

All_high_ind = (Data.data(:,1)==100);

All_low_ind = (Data.data(:,1)==0);

%Honestly from this, this may just fail due to these PFC neurons having
%such low spiking rates


%% Invariance with respect to coherence

%% RDD around stimulus onset

%%  RDD around DDM decision completion

%% FDR on PFC null data