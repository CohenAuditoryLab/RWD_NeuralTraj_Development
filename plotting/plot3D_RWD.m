function plot3D_RWD(seq, xspec, varargin)
%
% plot3D(seq, xspec, ...)
%
% Plot neural trajectories in a three-dimensional space.
%
% INPUTS:
%
% seq        - data structure containing extracted trajectories
% xspec      - field name of trajectories in 'seq' to be plotted 
%              (e.g., 'xorth' or 'xsm')
%
% OPTIONAL ARGUMENTS:
%
% dimsToPlot - selects three dimensions in seq.(xspec) to plot 
%              (default: 1:3)
% nPlotMax   - maximum number of trials to plot (default: 20)
% redTrials  - vector of trialIds whose trajectories are plotted in red
%              (default: [])
%
% stim_relevant_times - times to put markers for stimulus values, currently
% only accepts arguements of three (start, end, and one time)
%
% stim_points_only - toggle to generate a separate plot with stim relevant
% points only (0,1: default 0)
%
% trajtostart - set trajectory in data to start on (useful for plotting
% subsets during exploratory phases)
% 
% trial_diff_colors - toggle to plot trials in different colors (0,1:
%                      default 1,)
% @ 2009 Byron Yu -- byronyu@stanford.edu
% 2019 Ron DiTullio -- ron.w.ditullio@gmail.com
%slight modification of og code to allow for plotting options we need, such
%as seeing each trial in a different color and being able to reference
%specific times for the stimuli

%Note really should re-write this as a case switch or something but tons of
%if loops will have to do it for now

  dimsToPlot = 1:3;
  nPlotMax   = 5; %max number to plot
  trajtostart = 1; %trajectory to start on (useful if ploting subsets of trajectories)
  redTrials  = [];
  trials_diff_colors = 1;
  binwidth = 20; %send this through from main code
  stim_relevant_times = [1 floor(seq(1).T/2) seq(1).T]; %based on known alignment
  stim_points_only = 1;
  assignopts(who, varargin); %note this is a cool way to not have to use an input parser directly

  if size(seq(1).(xspec), 1) < 3
    fprintf('ERROR: Trajectories have less than 3 dimensions.\n');
    return
  end

  f = figure(1);%consider just setting col as an array for use in other plotting steps
  pos = get(gcf, 'position');
  set(f, 'position', [pos(1) pos(2) 1.3*pos(3) 1.3*pos(4)]);
  
  for n = 0:min(length(seq), nPlotMax)-1
    dat = seq(n+trajtostart).(xspec)(dimsToPlot,:);
    T   = seq(n+trajtostart).T;
    
    figure(1);
    if trials_diff_colors %have each trial be a different color
        lw = 0.5;
        col =  rand(1,3); %pull color randomly
        
        plot3(dat(1,:), dat(2,:), dat(3,:), '.-', 'linewidth', lw, 'color', col);
        hold on;
        
            if ~isempty(stim_relevant_times)
              ms = 10; %set marker size
              plot3(dat(1,stim_relevant_times(1,stim_relevant_times(1))),dat(2,stim_relevant_times(1)),dat(3,stim_relevant_times(1)),...
                'x', 'MarkerSize', ms,'color',col) %Trial Start

              plot3(dat(1,stim_relevant_times(2)),dat(2,stim_relevant_times(2)),dat(3,stim_relevant_times(2)),...
                    '*', 'MarkerSize', ms, 'color',col) %Stim on
              plot3(dat(1,stim_relevant_times(3)),dat(2,stim_relevant_times(3)),dat(3,stim_relevant_times(3)),...
                    '+', 'MarkerSize', ms,'color',col) %Trial End

               if stim_points_only %triggered only if you want a second graph of just the stimulus related points
                  figure(2);

                  %  plot3(dat(1,stim_relevant_times(1,stim_relevant_times(1))),...
                    %     dat(2,stim_relevant_times(1)),dat(3,stim_relevant_times(1)),...
                     %   'x', 'MarkerSize', ms, 'color',col ) %Trial Start
                   % hold on
                   % plot3(dat(1,stim_relevant_times(2)),...
                      %  dat(2,stim_relevant_times(2)),dat(3,stim_relevant_times(2)),...
                       % '*', 'MarkerSize', ms, 'color', col) %Stim on
                    plot3(dat(1,stim_relevant_times(3)),...
                        dat(2,stim_relevant_times(3)),dat(3,stim_relevant_times(3)),...
                    '+', 'MarkerSize', ms, 'color', col) %Trial End
                    hold on

%                 plot3([dat(1,stim_relevant_times(2)), dat(1,stim_relevant_times(3))],...
%                         [dat(2,stim_relevant_times(2)), dat(2,stim_relevant_times(3))],...
%                         [dat(3,stim_relevant_times(2)), dat(3,stim_relevant_times(3))],...
%                     '-', 'color', col) %Trial End%line connecting Stim on to trial end
                end
            end
        
    else
        if ismember(seq(n+trajtostart).trialId, redTrials)
        col = [1 0 0]; % red
        lw  = 3;
        else
        col = 0.2 * [1 1 1]; % gray
        lw = 0.5;
        end
        plot3(dat(1,:), dat(2,:), dat(3,:), '.-', 'linewidth', lw, 'color', col); 
        hold on;
        
    end
    
  
    
    
  end
  figure(1)
    axis equal;
  if isequal(xspec, 'xorth')
    str1 = sprintf('$$\\tilde{\\mathbf x}_{%d,:}$$', dimsToPlot(1));
    str2 = sprintf('$$\\tilde{\\mathbf x}_{%d,:}$$', dimsToPlot(2));
    str3 = sprintf('$$\\tilde{\\mathbf x}_{%d,:}$$', dimsToPlot(3));
  else
    str1 = sprintf('$${\\mathbf x}_{%d,:}$$', dimsToPlot(1));
    str2 = sprintf('$${\\mathbf x}_{%d,:}$$', dimsToPlot(2));
    str3 = sprintf('$${\\mathbf x}_{%d,:}$$', dimsToPlot(3));
  end
  xlabel(str1, 'interpreter', 'latex', 'fontsize', 24);
  ylabel(str2, 'interpreter', 'latex', 'fontsize', 24);
  zlabel(str3, 'interpreter', 'latex', 'fontsize', 24);
  grid on
  
  figure(2)
     axis equal;
  if isequal(xspec, 'xorth')
    str1 = sprintf('$$\\tilde{\\mathbf x}_{%d,:}$$', dimsToPlot(1));
    str2 = sprintf('$$\\tilde{\\mathbf x}_{%d,:}$$', dimsToPlot(2));
    str3 = sprintf('$$\\tilde{\\mathbf x}_{%d,:}$$', dimsToPlot(3));
  else
    str1 = sprintf('$${\\mathbf x}_{%d,:}$$', dimsToPlot(1));
    str2 = sprintf('$${\\mathbf x}_{%d,:}$$', dimsToPlot(2));
    str3 = sprintf('$${\\mathbf x}_{%d,:}$$', dimsToPlot(3));
  end
  xlabel(str1, 'interpreter', 'latex', 'fontsize', 24);
  ylabel(str2, 'interpreter', 'latex', 'fontsize', 24);
  zlabel(str3, 'interpreter', 'latex', 'fontsize', 24);
  grid on
  
%   if stim_points_only
%       
%   figure()
%   
%      if ~isempty(stim_relevant_times)
%       ms = 10; %set marker size
%       
%         for n = 0:min(length(seq), nPlotMax)-1
%             dat = seq(n+trajtostart).(xspec)(dimsToPlot,:);
%             T   = seq(n+trajtostart).T;
%             col =  rand(1,3); %pull color randomly
%       
%              plot3(dat(1,stim_relevant_times(1,stim_relevant_times(1))),...
%                  dat(2,stim_relevant_times(1)),dat(3,stim_relevant_times(1)),...
%                 'x', 'MarkerSize', ms, 'color',col ) %Trial Start
%             hold on
%             plot3(dat(1,stim_relevant_times(2)),...
%                 dat(2,stim_relevant_times(2)),dat(3,stim_relevant_times(2)),...
%                 '*', 'MarkerSize', ms, 'color', col) %Stim on
%             plot3(dat(1,stim_relevant_times(3)),...
%                 dat(2,stim_relevant_times(3)),dat(3,stim_relevant_times(3)),...
%             '+', 'MarkerSize', ms, 'color', col) %Trial End
%         
%         plot3([dat(1,stim_relevant_times(2)), dat(1,stim_relevant_times(3))],...
%                 [dat(2,stim_relevant_times(2)), dat(2,stim_relevant_times(3))],...
%                 [dat(3,stim_relevant_times(2)), dat(3,stim_relevant_times(3))],...
%             '-', 'color', col) %Trial End%line connecting Stim on to trial end
%         end
%      else
%          
%          fprintf('No stimulus specific times entered')
%     end
%   
%       
%   end
%   
%   axis equal;
%   if isequal(xspec, 'xorth')
%     str1 = sprintf('$$\\tilde{\\mathbf x}_{%d,:}$$', dimsToPlot(1));
%     str2 = sprintf('$$\\tilde{\\mathbf x}_{%d,:}$$', dimsToPlot(2));
%     str3 = sprintf('$$\\tilde{\\mathbf x}_{%d,:}$$', dimsToPlot(3));
%   else
%     str1 = sprintf('$${\\mathbf x}_{%d,:}$$', dimsToPlot(1));
%     str2 = sprintf('$${\\mathbf x}_{%d,:}$$', dimsToPlot(2));
%     str3 = sprintf('$${\\mathbf x}_{%d,:}$$', dimsToPlot(3));
%   end
%   xlabel(str1, 'interpreter', 'latex', 'fontsize', 24);
%   ylabel(str2, 'interpreter', 'latex', 'fontsize', 24);
%   zlabel(str3, 'interpreter', 'latex', 'fontsize', 24);
%   grid on