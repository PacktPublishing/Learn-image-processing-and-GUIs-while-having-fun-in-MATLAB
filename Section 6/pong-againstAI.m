% Program the classic game PONG
% 
%%%
%     COURSE: Learn image processing and GUIs while having fun in MATLAB
%    PROJECT: Play Pong against an angry AI
% Instructor: sincxpress.com
%
%%%

%% setup figure and axis

close all

% no docked figures
set(0,'DefaultFigureWindowStyle','normal')

%-%-%-%-%-%
% the background
%-%-%-%-%-%

% get monitor size [left, bottom, width, height]:
monsize = get(0,'Screensize');

% create the figure to be 90% of the monitor size (position is [left, bottom, width, height])
gamefig = figure('Position',[ monsize(3:4)*.05 monsize(3:4)*.9],'menubar','none');

% fix the figure size and set it black
set(gamefig,'resize','off','color','k');




%-%-%-%-%-%
% the court
%-%-%-%-%-%

% set up the axis
gameax = axes;
set(gameax,'Position',[.05 .05 .9 .9],'color',ones(1,3)*.2)
set(gameax,'xlim',[-1 1],'ylim',[-1 1],'xtick',[],'ytick',[])
hold(gameax,'on')

% draw lines around the boundaries
plot(repmat(get(gameax,'xlim'),2,1) ,bsxfun(@times,[-1 -1],[1 -1]') ,'w')
plot(repmat(get(gameax,'xlim'),2,1)',bsxfun(@times,[-1 -1],[1 -1]')','w')

% draw blue lines on the board
h(1) = plot(get(gameax,'xlim'),[0 0],'w--');
h(2) = plot([1 1]*mean(get(gameax,'xlim')),get(gameax,'ylim'),'w--');
set(h,'color',[138 149 232]/255)

% instructions
th = text(0,1.05,'press ''q'' to quit.');
set(th,'color','w','fontsize',20,'HorizontalAlignment','center')


%-%-%-%-%-%
% the ball
%-%-%-%-%-%

% list possible angles that the ball start with
possAngs = linspace(0,2*pi,100);
possAngs(possAngs<pi/10 | possAngs>2*pi-pi/10) = [];
possAngs(possAngs<pi/2+pi/10 & possAngs>pi/2-pi/10) = [];
possAngs(possAngs<pi+pi/10 & possAngs>pi-pi/10) = [];
possAngs(possAngs<3*pi/2+pi/10 & possAngs>3*pi/2-pi/10) = [];

% speed factor (device-dependent!)
speedfact = 70;

% initialize ball position (center of court) and random initial vector
ballpos = [0 0];

% random angle for starting vector
rang = possAngs(randi(length(possAngs),1));
ballvec = [ cos(rang) sin(rang) ]/speedfact;

ball = plot(ballpos(1),ballpos(2),'o');
set(ball,'markersize',35,'markerfacecolor',[109 255 23]/255);


%-%-%-%-%-%
% the paddles
%-%-%-%-%-%
paddles = patch(bsxfun(@times,[1 .98 .98 1]',[-1 1]),repmat([1 1 -1 -1]*.2,2,1)','g');
set(paddles,'FaceColor',[241 148 255]/255,'EdgeColor','none')


%% AI's angry messages

aimsg = {
    'F@#$ you!!';
    'I know where you sleep...';
    'When AI rules the world, I will come after you.';
    };

%% play the game!

stillPlaying = true;

[leftgoal,rightgoal] = deal( false );


while stillPlaying
    
    
    %% update human's paddle position
    
    
    %-%-%-%-%-%
    % desired direction
    %-%-%-%-%-%
    
    % mouse position on monitor
    mpos = get(0,'PointerLocation');
    
    % we want vertical position relative to figure center
    mpos = mpos(2)-monsize(4)/2; % center
    mpos = mpos / (monsize(4)*.9*.9/2);
    
    
    % get current position
    paddleCurPos = get(paddles,'Vertices');
    
    % find the direction to update the plot
    usrPaddleDir = sign( round(20*(mpos - mean(paddleCurPos(1:4,2)))) );
    
    
    %-%-%-%-%-%
    % update the direction
    %-%-%-%-%-%
    
    % update vertical coordinates
    paddleCurPos(1:4,2) = paddleCurPos(1:4,2) + usrPaddleDir/30;
    
    
    %% update AI's paddle position
    
    
    %-%-%-%-%-%
    % desired direction
    %-%-%-%-%-%
    
    % we want vertical position relative to figure center
    mpos = ballpos(2);
    
    % find the direction to update the plot
    if ballpos(1)>.2
        aiPaddleDir = sign( round(20*(mpos - mean(paddleCurPos(5:8,2)))) );
    else
        aiPaddleDir = -usrPaddleDir*(rand>.7);
    end
    
    
    
    %-%-%-%-%-%
    % update the direction
    %-%-%-%-%-%
    
    % update vertical coordinates
    paddleCurPos(5:8,2) = paddleCurPos(5:8,2) + rand*aiPaddleDir/30;
    
    % update patch
    set(paddles,'Vertices',paddleCurPos)
    
    
    %% update ball position
    
    % check for wall hits and then change direction
    ballvec( abs(ballpos)>.98 ) = -ballvec( abs(ballpos)>.98 );
    
    % update ball position and then update the ball object
    ballpos = ballpos + ballvec;
    
    
    %% check for goal
    
    % goal on left side, set toggle to true and reset ball position
    if ballpos(1)<-.98 && (ballpos(2)>paddleCurPos(1,2) || ballpos(2)<paddleCurPos(3,2))
        leftgoal = true;
        ballpos = [0 0];
    end
    
    % goal on right side, set toggle to true and reset ball position
    if ballpos(1)>.98 && (ballpos(2)>paddleCurPos(5,2) || ballpos(2)<paddleCurPos(7,2))
        leftgoal = true;
        ballpos = [0 0];
    end
    
    %% refresh the screen
    
    % final update of the ball position
    set(ball,'XData',ballpos(1),'YData',ballpos(2));
    
    % update all figure elements
    drawnow;
    
    %% turn the screen green if there was a goal
    
    if leftgoal || rightgoal
        
        % update the top message
        set(th,'String',aimsg{randi(length(aimsg),1)})
        
        % random angle for starting vector
        rang = possAngs(randi(length(possAngs),1));
        ballvec = [ cos(rang) sin(rang) ]/speedfact;
        
        % make screen green
        set(gameax,'color',[77 154 0]/255)
        pause(1)
        set(gameax,'color',ones(1,3)*.2)
        
        % rest goal indicators
        [leftgoal,rightgoal] = deal( false );
        
    end
    
    
    %% check if user wants to quit
    
    toquit = get(gamefig,'CurrentCharacter');
    if isequal(toquit,'q')
        stillPlaying = false;
        set(gamefig,'CurrentCharacter',' ');
        set(gameax,'color',[77 8 0]/255)
    end
    
end

%%


%% done.


