function CLISLAB_AddToFile(filename,record)
% adds a new record (record) to a file (filename)

if exist(filename, 'file')
    fileID = fopen(filename,'a');
    fprintf(fileID,[newline '%s'],record);
    fclose(fileID);
else
  warningMessage = sprintf('Warning: File does not exist:\n%s', filename);
  uiwait(msgbox(warningMessage,'Error','error'));
end

end

