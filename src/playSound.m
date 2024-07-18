function playSound()
global sound
        % Checked state of the sound menu item
        switch get(gcbo,'checked')
            case 'on'
                set(gcbo,'checked','off')
                sound = false;
            case 'off'
                set(gcbo,'checked','on')
                sound = true;
        end
    end