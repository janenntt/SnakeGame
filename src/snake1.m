
function mySnakeGame(command)
% initialise the game

% declare variables as global 
global snake 
global playingField 


% Check if the function was called without arguments
if ~nargin % return the number of input arguments of function
    command = 'setup';
end
% Check if the input command is valid
if ~(ischar(command) || isscalar(command))
    return; % Exit the function if the command is not valid
end


% Handle commands using switch statements
switch command
    case 'setup' 
        % Initialize the game
        % Ask for player's name and display a welcome message
        welcomeMessage();
        
         % Create a figure for the game using figure
        snakeFigure = figure('Name','Snake Game',... 
            'DoubleBuffer','on',... 
            'Menubar','none',... 
            'Numbertitle','off',...
            'KeyPressFcn',sprintf('%s(double(get(gcbf,''Currentcharacter'')))',mfilename)); % specify a callback function to be executed when a key is pressed

        % Create a menubar using uimenu
        % File Menu - play new game, show score and play sound
        fileMenu = uimenu(snakeFigure,'Label','&File');
        uimenu(fileMenu,'Label','New Game','Accelerator','N','Callback',sprintf('%s(''New Game'')',mfilename))
        uimenu(fileMenu,'Label','Score','Callback',sprintf('%s(''Show Score'')',mfilename),'Checked','on')
        uimenu(fileMenu,'Label','Sound','Callback',sprintf('%s(''Play Sound'')',mfilename),'Checked','on');

        % Mode Menu - choose game modes 
        modeMenu = uimenu(snakeFigure,'Label','&Mode');
        uimenu(modeMenu,'Label','Original','Callback',sprintf('%s(''Mode'')',mfilename))
        uimenu(modeMenu,'Label','Box','Callback',sprintf('%s(''Mode'')',mfilename))
        uimenu(modeMenu,'Label','Maze','Callback',sprintf('%s(''Mode'')',mfilename))

        % Level Menu - choose difficulty levels
        levelMenu = uimenu(snakeFigure,'Label','&Level');
        uimenu(levelMenu,'Label','1','Callback',sprintf('%s(''Level'')',mfilename)) % Easy 
        uimenu(levelMenu,'Label','2','Callback',sprintf('%s(''Level'')',mfilename)) % Medium
        uimenu(levelMenu,'Label','3','Callback',sprintf('%s(''Level'')',mfilename)) % Hard
        uimenu(levelMenu,'Label','4','Callback',sprintf('%s(''Level'')',mfilename)) % Super Hard
        
        % Help Menu - tutorial to play the game 
        helpMenu = uimenu(snakeFigure,'Label','&Help');
        uimenu(helpMenu,'Label','Tutorial','Callback',sprintf('%s(''Tutorial'')',mfilename))

        % Make the axes invisible
        axes('Visible','off');
        
        % Create an initial snake
        snake = [10,15;10,14;10,13;10,12;10,11];

        % Add the playing field
        playingField = image(getBackground,'CDataMapping','scaled'); 
        
        % Adjust the playing field's appearance
        set(gca,...
            'XTick',NaN,... 
            'YTick',NaN) % remove the axis tick marks 
        text(40,40,'0',... % create the text element and its position
            'Tag','Score', ... % assign the tag "Score" to the text element
            'FontUnits','normalized', ... % set the font units of the text element to be relative to the size of axes
            'FontSize',0.05, ... % set font size to 5% the size of the axes
            'Color',[1 1 1],... % set text color to white 
            'VerticalAlignment','baseline', ... % align the text vertically to the baseline
            'HorizontalAlignment','Right'); % align the text horizontally to the right

    
end 
end



