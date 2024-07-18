    function showScore()
        % Toggle the checked state of the score menu item
        switch get(gcbo,'checked')
            case 'on'
                set(gcbo,'checked','off')
                set(findobj(gcbf,'Tag','Score'),'Visible','off')
            case 'off'
                set(gcbo,'checked','on')
                set(findobj(gcbf,'Tag','Score'),'Visible','on')
        end
    end