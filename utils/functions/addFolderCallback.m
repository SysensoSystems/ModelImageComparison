function addFolderCallback(src,event,handles,choice)
% Add the required folders to the path

if isequal(choice,1)
    userData = get(handles.firstModelBrowseButton,'userData');
else
    userData = get(handles.secondModelBrowseButton,'userData');
end

folderTree = {};
if ~isempty(userData)
    folderTree = userData;
end
% GUI creation
addFolderHandles.addFolderfigureH = uifigure('Name','Model Image Comparison Tool - Path','menubar','none','Visible','off');
scrsz = get(0,'ScreenSize');
screensize_factor = 0.3;
figsize = [(scrsz(3)*(1-screensize_factor))/2 (scrsz(4)*(1-screensize_factor))/2 ...
            scrsz(3)*screensize_factor scrsz(4)*screensize_factor];
set(addFolderHandles.addFolderfigureH,'Position',figsize);
mainLayout = uigridlayout('Parent',addFolderHandles.addFolderfigureH);
mainLayout.ColumnWidth = {150,'1x'};
mainLayout.RowHeight = {'1x'};
addFolderLayout = uigridlayout('Parent',mainLayout);
addFolderLayout.ColumnWidth = {'1x'};
addFolderLayout.RowHeight = {25,25,25};
addFolderLayout.Layout.Row = 1;
addFolderLayout.Layout.Column = 1;
addFolderHandles.addFolderButton = uibutton(addFolderLayout, 'push');
addFolderHandles.addFolderButton.Layout.Row = 1;
addFolderHandles.addFolderButton.Layout.Column = 1;
addFolderHandles.addFolderButton.Text = 'Add Folder';
addFolderHandles.addSubFolderButton = uibutton(addFolderLayout, 'push');
addFolderHandles.addSubFolderButton.Layout.Row = 2;
addFolderHandles.addSubFolderButton.Layout.Column = 1;
addFolderHandles.addSubFolderButton.Text = 'Add with SubFolder';
addFolderHandles.removeFolderButton = uibutton(addFolderLayout, 'push');
addFolderHandles.removeFolderButton.Layout.Row = 3;
addFolderHandles.removeFolderButton.Layout.Column = 1;
addFolderHandles.removeFolderButton.Text = 'Remove';
addFolderHandles.folderTree = uitree('Parent',mainLayout,'Multiselect','on');
addFolderHandles.folderTree.Layout.Row = 1;
addFolderHandles.folderTree.Layout.Column = 2;

% Get Icon Path
filePath = fileparts(mfilename('fullpath'));
addFolderHandles.iconPath = [filePath filesep 'iconImages'];

if ~isempty(folderTree)
    for ii = 1:length(folderTree)
        folderName = folderTree{ii};
        if ~(isempty(folderName))
            addpath(folderName);
            uitreenode(addFolderHandles.folderTree,'Text',folderName,'Icon',[addFolderHandles.iconPath '\folderIcon.png']);
        end
    end
end
% Set Callback functions
set(addFolderHandles.addFolderButton,'ButtonPushedFcn',{@addFolderButtonCallback,addFolderHandles,handles,choice})
set(addFolderHandles.addSubFolderButton,'ButtonPushedFcn',{@addSubFolderButtonCallback,addFolderHandles,handles,choice})
set(addFolderHandles.removeFolderButton,'ButtonPushedFcn',{@removeFolderButtonCallback,addFolderHandles,handles,choice})
set(addFolderHandles.addFolderfigureH,'Visible','on');

end
%==========================================================================
function addFolderButtonCallback(src,event,addFolderHandles,handles,choice)
% To add the selected folder to path

folderName = uigetdir();
figure(addFolderHandles.addFolderfigureH);
bool = checkIfExists(folderName,handles,choice);
if ~(isequal(folderName,0))
    if bool
        uitreenode(addFolderHandles.folderTree,'Text',folderName,'Icon',[addFolderHandles.iconPath '\folderIcon.png']);
    end
end
% Get the folder path and store in user data
folderNames = getCurrentFolderNames(addFolderHandles);
addFolderToUserData(folderNames,handles,choice);

end
%==========================================================================
function addSubFolderButtonCallback(src,event,addFolderHandles,handles,choice)
% To add the selected folder and its sub folders to path

folderAndSubfolders = uigetdir();
figure(addFolderHandles.addFolderfigureH);
folderAndSubfolders = split(genpath(folderAndSubfolders),';');
for ii = 1:length(folderAndSubfolders)
    folderName = folderAndSubfolders{ii};
    bool = checkIfExists(folderName,handles,choice);
    if ~(isempty(folderName))
        if bool
            uitreenode(addFolderHandles.folderTree,'Text',folderName,'Icon',[addFolderHandles.iconPath '\folderIcon.png']);
        end
    end
end
% Get the folder path and store in user data
folderNames = getCurrentFolderNames(addFolderHandles);
addFolderToUserData(folderNames,handles,choice);

end
%==========================================================================
function removeFolderButtonCallback(src,event,addFolderHandles,handles,choice)
% To remove selected folders from path

selectedNodes = addFolderHandles.folderTree.SelectedNodes;
for index = 1:length(selectedNodes)
    selectedNodes(index).delete
end
% Get the folder path and store in user data
folderNames = getCurrentFolderNames(addFolderHandles);
addFolderToUserData(folderNames,handles,choice);

end
%==========================================================================
function folderNames = getCurrentFolderNames(addFolderHandles)
% Get the folder path
folderTreeChildrens = addFolderHandles.folderTree.Children;
folderNames = {};
for ii = 1:length(folderTreeChildrens)
    folderName = folderTreeChildrens(ii).Text;
    folderNames = [folderNames;folderName];
end

end
%==========================================================================
function bool = checkIfExists(folderName,handles,choice)
% Check if the folder path is already added

bool = false;
if isequal(choice,1)
    userData = get(handles.firstModelBrowseButton,'userData');
else
    userData = get(handles.secondModelBrowseButton,'userData');
end
idx = find(ismember(userData, folderName));
if isempty(idx)
    bool = true;
end

end
%==========================================================================
function addFolderToUserData(folderNames,handles,choice)
% Add the folder paths to user data

if isequal(choice,1)
    set(handles.firstModelBrowseButton,'userData',folderNames);
else
    set(handles.secondModelBrowseButton,'userData',folderNames);
end

end