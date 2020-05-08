function list = CLISLAB_GetListFilesFromFolder(foldername, extension, bool_ext)

% This function receives a folder (foldername), an extension 
% (without the '.')as input and a boolean (bool_ext) for returning or not 
% the extension in the string. 
% It returns a string array (list) with all the document names inside the 
% folder with the desired extension
files_list = "";

if exist(foldername, 'dir')
    old_dir = pwd;
    cd(foldername);
    ext_base = '*.';
    ext_desired = strcat(ext_base,extension);
    files = dir(ext_desired);
    
    for i = 1:length(files)
        
        new_str = string(files(i).name);
        
        if bool_ext == true
            files_list = [files_list  new_str];
        else
            files_list = [files_list  extractBefore(new_str,'.')];
        end

    end
    cd(old_dir);
else
  warningMessage = sprintf('Warning: Folder does not exist:\n%s', foldername);
  uiwait(msgbox(warningMessage,'Error','error'));
end
list = files_list;
% Remove empty files
list(list=="") = [];
end





