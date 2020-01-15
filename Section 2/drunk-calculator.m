function drunk_calculator
% A funny calculator
%   NOTE: use this calculator for computations at your own risk! 
%         The purpose of this calculator is to teach MATLAB graphics programming.
% 
%%%
%     COURSE: Learn image processing by coding silly games in MATLAB
%    PROJECT: Do "math" with a drunk calcuator
% Instructor: sincxpress.com
%
%%%

%% create the body of the calculator

set(0,'DefaultFigureWindowStyle','normal')

monsize = get(0,'ScreenSize');

% set up the figure. Note that position corresponds to [left,bottom, width,height].
calcfig = figure('Position',[123 456 monsize(3)*.25 monsize(4)*.25],'menubar','none','name','Yes, officer, I''m a calculator','Numbertitle','off');

% fix the size of the calculator and change the background color
set(calcfig,'resize','off','color',[1 1 1]*.4)

figsize = get(calcfig,'Position');
figsize = figsize(3:4);

%% put some buttons on the body

% locations of the button positions
xfracs = linspace(.1,.5,3);
yfracs = linspace(.6,.1,4);


% create buttons for digits 1-10
for bnum=1:10
    
    h(bnum) = uicontrol('style','pushbutton',...
        'string',num2str(mod(bnum,10)),...
        'FontSize',15,...
        'Callback',@but,...
        'Position',[xfracs(mod(bnum-1,3)+1)*figsize(1) yfracs(ceil(4*bnum/12))*figsize(2) 80 40]);
end


% buttons +-/*
symbs = '+-/*';
for si=1:length(symbs)
    
    uicontrol('style','pushbutton',...
        'string',symbs(si),...
        'FontSize',15,...
        'Callback',@but,...
        'Position',[.8*figsize(1) yfracs(si)*figsize(2) 80 40]);
end

% equals sign
uicontrol('style','pushbutton',...
    'string','=',...
    'FontSize',15,...
    'Callback',@but,...
    'Position',[.3*figsize(1) .1*figsize(2) 176 40]);


% clear button
uicontrol('style','pushbutton',...
    'string','clear',...
    'FontSize',15,...
    'Callback',@but,...
    'Position',[.675*figsize(1) .1*figsize(2) 57 40]);

% display bar
txth = uicontrol('style','text',...
    'string','',...
    'FontSize',17,...
    'Callback',@but,...
    'backgroundcolor',[1 1 1]*.2,...
    'HorizontalAlignment','right',...
    'Position',[.1*figsize(1) .78*figsize(2) .87*figsize(1) 55]);



%% create a blank function

function but(source,eventdata)
    
    % flash the color of the calling button
    set(source,'BackgroundColor',[.3 .4 .8])
    pause(.1)
    set(source,'BackgroundColor',[1 1 1]*.94)
    
    % update the display so that the pressed button shows up
    whichbutton = get(source,'string');
    displaytext = get(txth,'String');
    
    % see if user pressed equals sign
    if isequal(whichbutton,'=')
        
        try
            result = num2str(eval( displaytext ));
            set(txth,'String',[ '= ' result ])
        catch me;
            set(txth,'string',[ '= ' getaphrase]);
        end
        
    % if the user clears the screen
    elseif isequal(whichbutton,'clear')
        set(txth,'string','')
        
    % not equals sign; update display    
    else
        
        % clean the display if '=' is the first character
        if isempty(displaytext) || isequal(displaytext(1),'=')
            set(txth,'string',whichbutton);
        else
            set(txth,'string',[displaytext whichbutton]);
        end
        
    end
    
    
    % randomly change a button label
    if rand>.9
        changebutton;
    end
    
    
end % end of the but function

function msg = getaphrase
    allmsg = {...
        'oh, I''ve had one too many.',...
        'no, you shut up!',...
        'I''m not drunk, you''re a... wait, what?',...
        'I love you, man.',...
        'Last call? But I just got here!',...
        'Calculator? But I hardly know her!',...
        'Don''t worry about me, I''ll get home.',...
        'Tequilla for me? Tequilla for everyone!'
        };
    msg = allmsg{randi(length(allmsg))};
end


function changebutton
    set(h(randi(10)),'string',num2str(randi(10)-1));
end

end % end of main function


%%


% Interested in more courses? See sincxpress.com 
% Use code MXC-DISC4ALL for the lowest price for all courses.
