function [dat_PFC, dat_AC] = preprocess_Ldata(Table1)
%PREPROCESS_LDATA Function to preprocess Lalitta data into a format the
%Byron et al. can use.  Specifically changing it into spiking format (i.e.
%spike trains)

%   Does some basic preprocessing to get Lalitta data from Table form to
%   spike train form so that it fits with Byron et al. code.  If feeling
%   fancy can add extra stuff later.
%
% INPUT:

% Table1 - table of data from Lalitta as input

% OUTPUT

%dat - struct array (1 x number of trials) containing fields trialId and
%spikes.  This is format for using Byron et al code with spiking as data
%format

%% Running notes from 2019-07-31

%thinking through how to do grouping...think can rely on the fact that
%neurons are in order and do some combo between the name and the trial
%number

%DON'T FORGET TO SEPARATE BY BRAIN REGION*********************************

%% Check number of fields/format of file 
%Note this will probably become a case-switch type thing later on when
%there are more forms of the data and more stuff to work with.

%For now getting the number of columns (i.e. number of variable names)
%seems to be primary way of distinguishing between files.

colnum = length(Table1.Properties.VariableNames);% don't fully need this
%functionality yet but in future can use this hard coded to see difference
%between files (i.e. if colnum = 5 do this because it is this type of
%folder

%Test for which file format it is firing or spkDisp
test1 = strcmp('spikes', Table1.Properties.VariableNames);
test2 = strcmp('spikes_disp', Table1.Properties.VariableNames);

structure = [num2str(any(test1)) ' ' num2str(any(test2))];
%switch-case structure only works with scalars or character vector so here we are
%% Preprocess data accordingly
%2019-07-31 for this to work have to group together all neurons across all
%trials and give each trial a unique id. 

%Format is a struct ARRAY which we will call dat keeping in line with the sample.
%- Struct has two fields, trialId and spikes.
%----trialId is a UNIQUE NUMERICAL trial id for each trial
%----spikes is a matrix of binned spikes (1ms bins) for all neurons for that trial 
%due to format will have to do some kind of loop for each trial to setup
%struct this way, silly but don't know a workaround yet

%Remove units with almost no spikes accross their trials
%Right now just relying on hard coded fact that their are 300 rows for each
%unit



switch structure %if feeling fancy or feel it is necessary for clarity later can have this function
                 %call other functions that do the preprocessing for each
                 %data type or set something up like that.
    case '1 0'
        disp('Have spikes from stimulus onset only, i.e. xxx_firing')
    case '0 1' %2019-07-31 going to start with this case
        fprintf('Have spikes_disp (spike dispersion) +-400ms  from stim onset , \n i.e. xxx_spkDisp\n')
        %Things of note so far:
        % - there was not a trial index field in these files, so added that
        % to the end, hence why colnum now equals 8 and renamed file
        % accordingly. NOTE have not done this for stimsearch yet, only for
        % pure tone
        
        %dumb basic thing for flipping between two "task" conditions we have
        %so far
        
        if colnum == 8 %Have pure tone data
            %NOTE also need to set up way to recover or save stimulus frequencey for that trial
            %Update on note: trial index can recover stimulus frequency for
            %that trial due to table structure.
            
            %Grab all the unique trial indecies
            trialId = unique(Table1.trial_index); 
            
            %Now group together by trial
            
            %just did some manual calc to find 16200 is when switch from D1
            %(PFC) to D2 (AC) i.e. 16200 is the last PFC ind
            %Going to need to redo this after data cleaning
            
            Table1_PFC = Table1(1:16200,:);
            
            Table1_AC = Table1(16201:end,:);
            %Terrible code below  but will have to due for now
                for i=1:length(Table1_PFC.spikes_disp)/300 %remove low firing units after split just to make life easier

                     if sum(cellfun(@isempty, Table1_PFC{1+300*(i-1):300*i,{'spikes_disp'}})) > 150
                         %if no spikes in over half of trials for this unit
                         %delete it from the table
                         
                         Table1_PFC(1+300*(i-1):300*i,:) =[];
                         
                     end

                end
                %Do separately since there are different amounts of units
                %per brain region
                for i=1: %remove low firing units after split just to make life easier

                    Table1_AC;
                    

                end
            
            spike_times = cell(length(trialId),2); %initialize spike times and spikes
            %spikes = cell(length(trialId),1);      % as cell array for each trial
            
            %would love to have something more elegant, but stuck with dumb
            %for loop I think just due to it being cell and struct arrays.
            
            dat_PFC = struct('trialId',[],'spikes',[],'stimIndex', []);
            dat_AC = struct('trialId',[],'spikes',[],'stimIndex', []);
            
            for i = 1:length(trialId)
                
                
                
                %load in trialID
                dat_PFC(i).trialId = trialId(i); 
                dat_AC(i).trialId = trialId(i); 
                
                %save stimulus index to recover stimulus value from table
                dat_PFC(i).stimIndex = Table1.stmFreqIndx(i);
                dat_AC(i).stimIndex = Table1.stmFreqIndx(i);
                
                %Grab all of the spike times of neurons recorded on the same trial
                %note: spike_times is a cell containing cells
                
                spike_times{i,1} = Table1_PFC.spikes_disp(Table1_PFC.trial_index == i);
                spike_times{i,2} = Table1_AC.spikes_disp(Table1_AC.trial_index == i);
                
                %hard coded since know that have +- 200ms from stim
                %therefore 401 bins, update: not true some of the bins have
                %spikes from after +200ms, increase window size maybe to
                %+-400ms?
                
                bin_edges = -400:1:400; %using 1ms bin size
                
                %use anonymous function call to apply hist counts to each
                %cell in spike times (i.e. bin the spikes of each neuron)
                %then use cell2mat to push all these spike trains into 1
                %matrix that is (number of neurons) x (number of bins)
                
                %load into temp and clean data (i.e. get rid of neurons
                %that don't fire) Update: this causes an issue in inputs
                %so no longer getting rid of neurons that don't fire on a
                %given session
               % temp = cell2mat(cellfun(@(x) histcounts(x,bin_edges), spike_times{i}, 'UniformOutput', false));
                
               % temp(sum(temp,2)<1,:)=[];
                
                %spikes{i} = temp;
                
                dat_PFC(i).spikes =  cell2mat(cellfun(@(x) histcounts(x,bin_edges), spike_times{i,1}, 'UniformOutput', false));
                dat_AC(i).spikes =  cell2mat(cellfun(@(x) histcounts(x,bin_edges), spike_times{i,2}, 'UniformOutput', false));
            end
            
            
            
        else %Have noise data colnum = 5;
            
        end
        
    case '0 0'
        disp('Have unknown format')
end

end

