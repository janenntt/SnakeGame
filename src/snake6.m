
function mySnakeGame(command)
%add new game 

% declare variables as global-make them accessible from any part of the code
global snake 
global playingField 
global direction
global sound 
global mode
global level
global moving
global food
global PAUSE


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
        
        % Set initial game variables
        snake = [10,15;10,14;10,13;10,12;10,11];
        sound = true;

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

    
    % directions 
    case 28 % left arrow
        if snake(2,2)~=mod(snake(1,2)-2,40)+1 % check if the snake is not moving to the right
            direction = command;
        end
    case 29 % right arrow
        if snake(2,2)~=mod(snake(1,2),40)+1 % check if the snake is not moving to the left
            direction = command;
        end
    case 30 % up arrow
        if snake(2,1)~=mod(snake(1,1)-2,40)+1 % check if the snake is not moving down
            direction = command;
        end
    case 31 % down arrow
        if snake(2,1)~=mod(snake(1,1),40)+1 % check if the snake is not moving up
            direction = command;
        end

    % Generate food and place it on the playing field
    case 'Food' 
         x = mode; % represent the state of the playing field,
        % A for loop iterating through each segment of the snake's body
        for i=1:size(snake,1)
            x(snake(i,1),snake(i,2)) = 1; % mark the positions occupied 
        end

        unoccupied = find(x'==0); % find all the positions that are unoccupied (value = 0)
        unoccupied = unoccupied(ceil(rand*length(unoccupied))); % randomly select one of the unoccupied positions
        food = [ceil(unoccupied/40) mod(unoccupied-1,40)+1]; % calculate the row and column for the food position
    
    % Draw the playing field
    case 'Draw playing field'
        x = mode;
        for i=1:size(snake,1) % loop over each segment of the snake's body
            x(snake(i,1),snake(i,2)) = 7; % visually represent the snake
        end
        
        x(food(1),food(2)) = 4; % visually represent the food
        set(playingField,'CData',x) % Update the playing field display
    

    % Show/hide score
    case 'Show Score' 
        showScore();

    % Turn on/off sound
    case 'Play Sound' 
        playSound();
    
    
    % Start the game
    case 'Start' 
        moving = true;

        while(moving)
            if ~PAUSE
                % Stimulate the forward movement of the snake
                snake = circshift(snake,1); % shift the snake matrix by one position
                snake(1,:) = snake(2,:); % update the position
                
                % Update the snake's position based on the selected direction
                switch direction
                    case 28 % left arrow
                        snake(1,2) = mod(snake(1,2)-2,40)+1;
                    case 29 % right arrow
                        snake(1,2) = mod(snake(1,2),40)+1;
                    case 30 % up arrow
                        snake(1,1) = mod(snake(1,1)-2,40)+1;
                    case 31 % down arrow
                        snake(1,1) = mod(snake(1,1),40)+1;
                end

                % Check if the snake hits the wall or bites itself
                if mode(snake(1,1),snake(1,2)) || ... % check if the snake hits the wall
                        sum(ismember(snake(2:end,1),snake(1,1))+ismember(snake(2:end,2),snake(1,2))==2) % check if the snake bites itself
                    
                    % If sound is checked, play a collision sound
                    if sound
                        % Upload sound effect
                        collisionSound = audioread('collisionSound.wav');
    
                        % Play the custom sound effect
                        soundsc(collisionSound);
                    end

                   
                    feval(mfilename,'Stop') % stop the game

                    % Set the game over screen
                    set(playingField,'CData',getGameOver)

                else
                    % Check if snake eats food
                    if isequal(snake(1,:),food)

                        % Increase snake's length
                        snake(end+1,:) = snake(end,:); % add a new segment

                        % Update score
                        updateScore = findobj(gcbf,'Tag','Score');
                        set(updateScore,'String',num2str(level+str2double(get(updateScore,'String'))))

                        % If sound is enabled, play eating sound
                        if sound
                            % Load sound effect
                            eatingSound = audioread('eatingSound.wav');
    
                            % Play the custom sound effect
                            soundsc(eatingSound);
                        end


                        % Generate new food
                        feval(mfilename,'Food')
                    end
                    
                    % Update the playing field display
                    feval(mfilename,'Draw playing field')

                end
            end

            % Pause duration based on the selected game level
            pause_duration = 5/(level*30);
            pause(pause_duration);
            
        end
        
    % Pause Game
    case {32} % spacebar (ASCII code 32)
        PAUSE=~PAUSE;
        if PAUSE && moving
            set(playingField,'CData',getBackground) % Set the playing field display to a paused state
        end
        

    % Stop Game
    case 'Stop' 
        moving = false;
        set(playingField,'CData',getBackground) % Set the playing field display to the background state

    % Play new game
    case 'New Game' 
        % Reset the score
        set(findobj(gcbf,'Tag','Score'),'String','0')

        % Initialize the snake position, direction, and game state
        snake = [10,15;10,14;10,13;10,12;10,11];
        direction = 29; % rightarrow
        PAUSE = false;

        % Generate initial food
        feval(mfilename,'Food')

        % Start the game loop
        feval(mfilename,'Start')

    
end 
end % terminate function mySnakeGame()



