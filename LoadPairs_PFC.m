%%  Notes

%19-03-08******************************************************************

%Need to write function to sort through all of the data Joji gave me to find
%useful trials where the neurons actually fire

%Also need to think about averaging across trials and whether that is
%kosher...otherwise need to only use recordings that are
%simultaneous...UPDATE: just going to go for it since not enough
%simultaneous recordings

%For first pass just going to roll through data by hand, either later today
%or probably this weekend will do a heavy sesh on getting what we need out

%Also going to use stimulus onset for now since that should give full
%trajectory until decision made.  Maybe change later

%Have very different average firing rates so will definitely normalize in
%some fashion (want on 0 to 1 scale so probably won't do typical subtract
%mean and divide by std and instead will just divide by peak firing rate)



%First sorting will probably have to be by coherence (% high or low tone).
%Going to start with only using trials that are fully high or low tones.
%Note each neuron has multiple trials for the day so have to sort by all
%trials experienced that day at the coherence level

%Also need to sort by times the monkey makes the correct decsions
%**************
%Note: low frequency is shifting stick to the RIGHT and 1 indicates joystick
%was moved to the RIGHT while 2 indicates joystick was moved to the LEFT.
%Thus want 100% high coherence to have all 2's for responses and 0% high
%coherence (i.e. 100% low tones)  should have all 1's for responses
%*****************






