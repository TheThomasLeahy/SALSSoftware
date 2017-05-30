function [ checked ] = getInput()

% Construct a questdlg with three options
choice = questdlg('Would you like to load all files at once?', ...
	'Load All Files', ...
	'Yes','No', 'No');
% Handle response
switch choice
    case 'Yes'
        disp([choice ' coming right up.'])
        checked = 1;
    case 'No'
        disp([choice ' coming right up.'])
        checked = 0;
end

end


