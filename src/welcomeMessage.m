function welcomeMessage()
    % Declare variable and initialise it with an empty string
    playerName = '';

    % Keep prompting the user until a valid name is provided
    while isempty(playerName) || any(~isletter(playerName)) %checks if playerName is still an empty string
        % Input the player's name
        playerName = input('Please enter your name: ', 's');

        % Check if the input is empty or contains non-letter characters
        if isempty(strtrim(playerName))
            warning('Invalid input. Please enter a non-empty name.');
        elseif any(~isletter(playerName))
            warning('Invalid input. Name can only contain letters.');
        end
    end

    % Show a welcome message using uiconfirm
    welcomeFig = uifigure;
    welcomeMessage = sprintf('Welcome to Snake Game, %s!\n', playerName);
    welcomeTitle = sprintf('Welcome');

    uiconfirm(welcomeFig, welcomeMessage, welcomeTitle);

    uiwait(welcomeFig); % Wait for the user to close the message box

    delete(welcomeFig); % Delete the figure
end
