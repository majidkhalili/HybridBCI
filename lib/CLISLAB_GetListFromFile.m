function list = CLISLAB_GetListFromFile(filename)

% the input is the filename and function reads the .txt file 
% and returns each line as one record. the return value is  
% 1 * number of lines in the text file

if isfile(filename)
    fileID = fopen(filename);
    read = textscan(fileID, '%s', 'Delimiter', newline);

    fclose(fileID);
else
  warningMessage = sprintf('Warning: File does not exist:\n%s', filename);
  uiwait(msgbox(warningMessage,'Error','error'));
  
end

list = string(read{1,1});

end
