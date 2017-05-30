function [] = getOkay()
% Construct a questdlg with three options
choice = questdlg('Click OK to confirm the registration', ...
	'Registration Confirmation', ...
	'OK','OK');
end

