function list = CLISLAB_GetListFoldersInFolder(folderpath)

% This function receives a folder as input (foldername)
% and returns a string array (list) with all the folder names
% inside the folder

if exist(folderpath, 'dir')
    old_dir = pwd;
    d = dir(folderpath); 
    isub = [d(:).isdir]; %Starts at 3 to remove '.' and '..'
    nameFolds = string({d(isub).name});
    cd(old_dir);
    list = nameFolds(3:length(nameFolds));
else
  warningMessage = sprintf('Warning: Folder does not exist:\n%s', folderpath);
  uiwait(msgbox(warningMessage,'Error','error'));
  list = [];
end


end




