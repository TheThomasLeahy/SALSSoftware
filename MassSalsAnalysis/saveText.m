function [choice] = saveText()
% Construct a questdlg with three options
choice = questdlg('Save Text Files?', ...
	'Text Files', ...
	'Yes','No','No');
end

