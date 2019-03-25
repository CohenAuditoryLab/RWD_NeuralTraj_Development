%% 3/5/19 Making schematic figure to show invariance ideas
% %Stick with 3 neurons (i.e. 3D neural space) for sake of plotting
% 
% 

%19-3-11 It may not be best to do parametric variables on second thought,
%can probably get the same stuff with more ability to directly interact
%with them if we just use plot 3 with normally defined vectors

%Also will have to go over again to change sizes of things and color scheme
%to be best.


%% Invariance 0 A : Showing neural population trajectories aslines
% 
% %Group 1 ends up at .5,1,.4
% x1 = linspace(0,.5,20); y1 = linspace(0,1,20); z1 =linspace(.3,.4,20);
% x2 = linspace(1,.5,20); y2 =linspace(.3,1,20); z2 = linspace(0,.4,20);
% 
% %Group 2 ends up at .75,.5,1
% x3 = linspace(.5,.75,20); y3 = linspace(.4,.5,20); z3= linspace(.2,1,20);
% x4 = linspace(.25, .75, 20); y4 = linspace(0,.5,20); z4= linspace(.7,1,20);
% 
% figure(1)
% plot with change transparency based on teh end point
% f1 = plot3(x1,y1,z1,'b--')
% alpha(f1,'y')
% hold on
% f2 = plot3(x2,y2,z2,'b.')
% alpha(f2,'y')
% plot3(x1(end),y1(end),z1(end),'b*')
% f3 = plot3(x3,y3,z3,'k--')
% alpha(f3,'z')
% f4 = plot3(x4,y4,z4,'k.')
% plot3(x3(end),y3(end),z3(end),'k*')
% alpha(f1,'z')
% hold off
% xlabel('Neuron 1 normalized firing rate')
% ylabel('Neuron 2 normalized firing rate')
% zlabel('Neuron 3 normalized firing rate')
% legend('Trajectory1', 'Trajectory2', 'Endpoint1', 'Trajectory3', 'Trajectory4', 'Endpoint2')
% title('Schematic of neural trajectories')
%% Invariance 0 B: Showing neural trajectories as curves
% going with this figure
%also think about using quiver3 function (little to complex to do now but
%does arrows which would be nice)

%update 19-3-11:
%removing syms coding since I don't think it really helpful
%Looks a bit better, maybe think about doing opaque to solid as well
%Can't really do arrows, quiver3 more equipt for vectorfields than this

t = 1:.1:5; %back to other format (see above)

xt1 = .8*t; yt1 = 5*t; zt1 = t.^2;

xt3 = 3*t+.2; yt3 = (t.^2)+.3; zt3 = t+.5;

figure(1)

plot3(xt1(2:end),yt1(2:end),zt1(2:end),'b.','MarkerSize',10)
hold on
plot3(xt1(1),yt1(1),zt1(1),'c.','MarkerSize',10)
%fplot3(xt1,yt1,zt1,[1 5],'b^','LineWidth',2)
% plot3(.8,5,1, 'c.','MarkerSize',15)%eyeball start point
% plot3(3.2,1.3,1.5, 'c.','MarkerSize',15)%same as above
plot3(4,25,25,'m*','MarkerSize',10) %just eyeballed end point
%fplot3(xt3, yt3, zt3, [1 5],'k^','LineWidth',2)

plot3(xt3(2:end),yt3(2:end),zt3(2:end),'k.','MarkerSize',10)
plot3(xt3(1),yt3(1),zt3(1),'c.','MarkerSize',10)
plot3(15.2, 25.3, 5.5, 'm*','MarkerSize',10) %same as above

axis([0 16 0 30 0 30])


grid on
%title('Cartoon schematic of neural trajectories in 3 neuron "network"')

xlabel('Neuron #1 arb firing rate')
ylabel('Neuron #2 arb firing rate')
zlabel('Neuron #3 arb firing rate')
%legend('Trajectory 1', 'Start 1', 'End 1', 'Trajectory 2', 'Start 2' , 'End 2')

%% Invariance 1 All end up at same place

syms t %leaving this alone since this didn't really change this figure

xt1 = .8*t; yt1 = 5*t; zt1 = t.^2;
xt2 = 4 - 4*exp(-.05*t); yt2 = 25 - 25*exp(-.05*t); zt2 = 25 - 25*exp(-.1*t);
xt3 = 4 - exp(-.05*t); yt3 = 25 - 10*exp(-.05*t); zt3 = 25 - 25*exp(-.1*t);
xt4 = 4 - 3*exp(-.05*(t+2)); yt4 = 25 - 25*exp(-.05*(t)); zt4 = 25 - 20*exp(-.1*(t+10));

figure(2)

 %just eyeballed end point

fplot3(xt1,yt1,zt1,[1 5],'b-')
hold on
fplot3(xt2,yt2,zt2,[0 1000],'k-')
fplot3(xt3,yt3,zt3,[0 1000],'m-')
fplot3(xt4,yt4,zt4,[0 1000],'y-')

plot3(4,25,25,'m*', 'MarkerSize', 10) %end point
%starting points for each (just read off of graph, but could also easily
%check)
plot3(.8,5,1,'c.','MarkerSize', 10)
plot3(0,0,0,'c.','MarkerSize', 10)
plot3(3,15,0,'c.','MarkerSize', 10)
plot3(1.285,0,17.64,'c.', 'MarkerSize', 10)



axis([0 6 0 27 0 27])

grid on

xlabel('Neuron #1 arb firing rate')
ylabel('Neuron #2 arb firing rate')
zlabel('Neuron #3 arb firing rate')
%legend('Trajectory 1', 'Trajectory 2', 'Trajectory 3', 'Trajectory 4', 'Shared End Point')
%title('Same stimulus leading to same end point')

%% Invariance 2 Average Euclidain distance between vectors clusters near zero

%going with histogram for invar 1 and 2 since I think that will be more
%clear/can add trajectory figure later

%19-3-11 Now adding trajectory figure

%Have one trajectory circle endpoint and other have greater distance sweep

figure(10) %just so it doesn't overlap with other figures

t = 1:.01:5; %just including so don't have to run earlier code blocks first

xt1 = .8*t; yt1 = 5*t; zt1 = t.^2; %first curve, just quick trajectory to spot

t_other=0:.01:6.25; %just going to do a normal equation rather than symbolic stuff for this one

xt2 = 0.25*cos(2*pi*t_other)+4; yt2 = 25 - 15*exp(-.75*t_other); zt2 = 25 + 0.25*sin(2*pi*t_other); %just trying to get something that sits by end point

%xt2 = 4 - 2*exp(-.05*t)+ normrnd(0,1,[1,1]); yt2 = 25 - 12*exp(-.05*t)+ normrnd(0,1,[1,1]); zt2 = 25 - 12*exp(-.1*t)+ normrnd(0,1,[1,1]); %second curve

%xt2 = yt2= zt2= 

plot3(xt1(2:end-1),yt1(2:end-1),zt1(2:end-1),'b-','LineWidth', 2)
hold on
plot3(xt1(1),yt1(1),zt1(1),'c.','MarkerSize', 10) %start of curve 1
plot3(xt1(end),yt1(end),zt1(end),'m*','MarkerSize', 10)%end of curve 1

plot3(xt2(2:end-1),yt2(2:end-1),zt2(2:end-1),'k-','LineWidth', 2)
plot3(xt2(1),yt2(1),zt2(1),'c.','MarkerSize', 10)%start of curve 2
plot3(xt2(end),yt2(end),zt2(end),'m*','MarkerSize', 10)%end of curve 2

grid on
xlabel('Neuron #1 arb firing rate')
ylabel('Neuron #2 arb firing rate')
zlabel('Neuron #3 arb firing rate')
axis([0 6 0 27 0 27])

%% Histogram (of actual trajectory above)

figure(3)

%realistically variances should be equalish (or that is a separate point) but this is just for illustration
%the idea that distances cluster more around zero

% pre_learn_data = normrnd(2.5,1,[100 , 1]);
% pre_learn_data = pre_learn_data.^2;
% 
% post_learn_data = normrnd(0,3,[100 , 1]);
% post_learn_data = post_learn_data.^2;

% 
% subplot(1,2,1)
% hist(pre_learn_data)
% axis([0 max(pre_learn_data) 0 100])
% title('Pre-learning Distance Between Adjacent Neural Trajectory States')
% xlabel('Euclidian Distance (a.u.)')
% 
% subplot(1,2,2)
% hist(post_learn_data)
% axis([0 max(post_learn_data) 0 100])
% title('Post-learning Distance Between Adjacent Neural Trajectory States')
% xlabel('Euclidian Distance (a.u.)')

Traj1 = [xt1; yt1; zt1];
Traj2 = [xt2; yt2; zt2];

Dis_Traj1 = sqrt(sum((Traj1(:,2:end)-Traj1(:,1:end-1)).^2,1));

Dis_Traj2 = sqrt(sum((Traj2(:,2:end)-Traj2(:,1:end-1)).^2,1));

 subplot(1,2,1)
 histogram(Dis_Traj1,'FaceColor','b')
 axis([0 max(Dis_Traj1) 0 length(xt1)*.55])
 title('Blue Trajectory') %('Pre-learning Distance Between Adjacent Neural Trajectory States')
 xlabel('Euclidian Distance (a.u.)')
 
 subplot(1,2,2)
 histogram(Dis_Traj2(1,randsample(length(Dis_Traj2),length(Dis_Traj1))),'FaceColor','k') %subsample since Dis_Traj2 has more frames than one
 axis([0 max(Dis_Traj2) 0 length(xt2)*.55])
 title('Black Trajectory')
 xlabel('Euclidian Distance (a.u.)')


%% Invariance 3 Neural Trajectories are shorter

%not using for now / may want to make more like spiral or something to show
%attractor like nature
syms t %initalize the parameteric variable

xt1 = .8*t; yt1 = 5*t; zt1 = t^2;
xt2 = 4 - 2*exp(-.05*t); yt2 = 25 - 12*exp(-.05*t); zt2 = 25 - 12*exp(-.1*t);
xt3 = 4 - exp(-.25*t); yt3 = 25 - 10*exp(-.25*t); zt3 = 25 - 10*exp(-.5*t);

figure(3)

plot3(4,25,25,'m*', 'MarkerSize', 15) %just eyeballed end point
hold on
fplot3(xt1,yt1,zt1,[1 5],'b')
fplot3(xt2,yt2,zt2,[0 1000],'k.-')
fplot3(xt3,yt3,zt3,[0 1000],'k--')

%starting points with cyan dot
plot3(.8,5,1,'c.','MarkerSize', 10) %start of curve 1 %xt1
plot3(2,13,13,'c.','MarkerSize', 10) %start of curve 1%xt2
plot3(3,15,15,'c.','MarkerSize', 10) %start of curve 1%xt3

grid on
axis([0 6 0 27 0 27])
xlabel('Neuron #1 arb firing rate')
ylabel('Neuron #2 arb firing rate')
zlabel('Neuron #3 arb firing rate')

%title('Invariance 3: Trajectories are Shorter')

%legend('Endpoint' , 'Pre-learn trajectory', 'Post-learn trajectory 1', 'Post-learn trajectory 2')

%% Option 2 just do histogram  

%really should do this on same figure since it is a center shift
figure(4)

%realistically variances should be equalish (or that is a separate point) but this is just for illustration
%the idea that distances cluster more around zero

pre_learn_data = normrnd(20,1,[100 , 1]);
pre_learn_data = pre_learn_data.^2;

post_learn_data = normrnd(15,1,[100 , 1]);
post_learn_data = post_learn_data.^2;

histogram(pre_learn_data,'FaceColor','b')
hold on
histogram(post_learn_data, 'FaceColor', 'k')

title('Distribution of Trajectory Length for Each Trial')
xlabel('Trajectory Length (a.u.)')
%legend('Pre-learning', 'Post-learning')

% subplot(1,2,1)
% hist(pre_learn_data)
% axis([0 max(pre_learn_data) 0 100])
% title('Pre-learning Length of Trajectory for Trial')
% xlabel('Trajectory Length (a.u.)')
% 
% subplot(1,2,2)
% hist(post_learn_data)
% axis([0 max(post_learn_data) 0 100])
% title('Post-learning Length of Trajectory for Trial')
% xlabel('Trajectory Length (a.u.)')


%% Invariance 4 Response dimensionality Reduction

syms t4

xt1 = .8*t4; yt1 = t4^2; zt1 = t4^2+5;

xt2 = .8*t4; yt2 = t4^2; zt2 = (t4-t4)+6; %want to be closer to 6

figure(5)

fplot3(xt1,yt1,zt1,[1 5],'b')

hold on

fplot3(xt2,yt2,zt2,[1 5],'k--')
plot3([4,4],[25,25],[6,30],'b--')

plot3(4,25,30,'m*' , 'MarkerSize', 15)
plot3(.8,1,6, 'c.','MarkerSize', 15)

axis([0 6 0 32 0 32])

xlabel('Neuron #1 arb firing rate')
ylabel('Neuron #2 arb firing rate')
zlabel('Neuron #3 arb firing rate')
%title('Example of Dimensionality Reduction')
%legend('Higher Dimensional Trajectory', 'Lower Dimensional Trajectory')

hold off

figure(6)
fplot3(xt2,yt2,zt2,[1 5],'k--')
hold on
plot3(4,25,6,'m*' , 'MarkerSize', 15)
axis([0 6 0 32 0 32])

xlabel('Neuron #1 arb firing rate')
ylabel('Neuron #2 arb firing rate')
%title('Lower Dimensional Trajectory in 2D')
