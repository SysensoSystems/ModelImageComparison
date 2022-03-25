function varargout = micTool(varargin)
% Helps to compare two Simulink models and finds the difference
% between the models using image comparison approach.
%
% Syntax:
% * >> micTool
% * >> micTool('<ModelName or SystemPath>')
% * >> micTool('<ModelName or SystemPath>','<ModelName or SystemPath>')
%
% Developed by: Sysenso Systems, https://sysenso.com/
% Contact: contactus@sysenso.com
%
% Version:
% 1.0 - Initial Version.
%

%--------------------------------------------------------------------------
% Input validation
if isempty(varargin)
    firstModel = '';
    secondModel = '';
    choice = 1;
elseif length(varargin) == 1
    firstModel = varargin{1};
    preferredChoice = 0;
    [firstModel,choice] = inputValidation(firstModel,preferredChoice);
    secondModel = '';
elseif length(varargin) == 2
    firstModel = varargin{1};
    preferredChoice = 0;
    [firstModel,choice] = inputValidation(firstModel,preferredChoice);
    secondModel = varargin{2};
    preferredChoice = 0;
    if isequal(choice,1)
        preferredChoice = 1;
    elseif isequal(choice,2)
        preferredChoice = 2;
    end
    [secondModel,choice] = inputValidation(secondModel,preferredChoice);
else
    error('Too many input arguments.');
end
if isequal(choice,1)
    labelA = 'First Model';
    labelB = 'Second Model';
    buttonTextA = 'Browse';
    buttonTextB = 'Browse';
else
    labelA = 'First System Path';
    labelB = 'Second System Path';
    buttonTextA = 'GCS';
    buttonTextB = 'GCS';
end
%--------------------------------------------------------------------------
% Icons for Tool
filePath = fileparts(mfilename('fullpath'));
handles.iconPath = [filePath filesep 'icons'];
handles.imagesPath = [filePath filesep 'images'];
warning('off','MATLAB:MKDIR:DirectoryExists');
mkdir(handles.imagesPath);

%--------------------------------------------------------------------------
% GUI Creation
handles.figureH = uifigure('Name','Model Image Comparison Tool','menubar','none','Visible','off');
scrsz = get(0,'ScreenSize');
screensize_factor = 0.8;
figsize = [(scrsz(3)*(1-screensize_factor))/2 (scrsz(4)*(1-screensize_factor))/2 ...
    scrsz(3)*screensize_factor scrsz(4)*screensize_factor];
set(handles.figureH,'Position',figsize);
mainLayout = uigridlayout('Parent',handles.figureH);
mainLayout.ColumnWidth = {'1x'};
mainLayout.RowHeight = {130,'1x'};
mainLayout.Padding = [5 5 5 5];
browseLayout = uigridlayout('Parent',mainLayout);
browseLayout.ColumnWidth = {150, '1x', 100,50};
browseLayout.RowHeight = {'1x','1x', '1x', '1x'};
browseLayout.Layout.Row = 1;
browseLayout.Layout.Column = 1;
browseLayout.Padding = [1 1 1 1];
typeLabel = uilabel(browseLayout,'HorizontalAlignment','Center');
typeLabel.Layout.Row = 1;
typeLabel.Layout.Column = 1;
typeLabel.Text = 'Type';
ButtonGroupA = uibuttongroup(browseLayout);
ButtonGroupA.Layout.Row = 1;
ButtonGroupA.Layout.Column = 2;
handles.modelButton = uiradiobutton(ButtonGroupA);
handles.modelButton.Text = 'Simulink Model';
handles.modelButton.Position = [13 1 179 22];
handles.modelButton.Value = true;
handles.subsystemButton = uiradiobutton(ButtonGroupA);
handles.subsystemButton.Text = 'Simulink Subsystem';
handles.subsystemButton.Position = [213 1 199 22];
handles.firstModelLabel = uilabel(browseLayout,'HorizontalAlignment','Center');
handles.firstModelLabel.Layout.Row = 2;
handles.firstModelLabel.Layout.Column = 1;
handles.firstModelLabel.Text = labelA;
handles.firstModelEditField = uieditfield(browseLayout, 'text');
handles.firstModelEditField.Layout.Row = 2;
handles.firstModelEditField.Layout.Column = 2;
handles.firstModelEditField.Value = firstModel;
handles.firstModelBrowseButton = uibutton(browseLayout, 'push');
handles.firstModelBrowseButton.Layout.Row = 2;
handles.firstModelBrowseButton.Layout.Column = 3;
handles.firstModelBrowseButton.Text = buttonTextA;
handles.addToPathButtonA = uibutton(browseLayout, 'push','Text','');
handles.addToPathButtonA.Layout.Row = 2;
handles.addToPathButtonA.Layout.Column = 4;
handles.addToPathButtonA.Icon = [handles.iconPath '\folderIcon.png'];
handles.secondModelLabel = uilabel(browseLayout,'HorizontalAlignment','Center');
handles.secondModelLabel.Layout.Row = 3;
handles.secondModelLabel.Layout.Column = 1;
handles.secondModelLabel.Text = labelB;
handles.secondModelEditField = uieditfield(browseLayout, 'text');
handles.secondModelEditField.Layout.Row = 3;
handles.secondModelEditField.Layout.Column = 2;
handles.secondModelEditField.Value = secondModel;
handles.secondModelBrowseButton = uibutton(browseLayout, 'push');
handles.secondModelBrowseButton.Layout.Row = 3;
handles.secondModelBrowseButton.Layout.Column = 3;
handles.secondModelBrowseButton.Text = buttonTextB;
handles.addToPathButtonB = uibutton(browseLayout, 'push','Text','');
handles.addToPathButtonB.Layout.Row = 3;
handles.addToPathButtonB.Layout.Column = 4;
handles.addToPathButtonB.Icon = [handles.iconPath '\folderIcon.png'];
imageDiffLabel = uilabel(browseLayout,'HorizontalAlignment','Center');
imageDiffLabel.Layout.Row = 4;
imageDiffLabel.Layout.Column = 1;
imageDiffLabel.Text = 'Show Difference Using';
ButtonGroupB = uibuttongroup(browseLayout);
ButtonGroupB.Layout.Row = 4;
ButtonGroupB.Layout.Column = 2;
handles.pythonButton = uiradiobutton(ButtonGroupB);
handles.pythonButton.Text = 'Python - scikit-image Processing';
handles.pythonButton.Position = [213 1 199 22];
handles.matlabButton = uiradiobutton(ButtonGroupB);
handles.matlabButton.Text = 'MATLAB - Pixel Differences';
handles.matlabButton.Position = [13 1 179 22];
handles.matlabButton.Value = true;
handles.compareButton = uibutton(browseLayout, 'push');
handles.compareButton.Layout.Row = 4;
handles.compareButton.Layout.Column = 3;
handles.compareButton.Text = 'Compare';
secondaryLayout = uigridlayout(mainLayout);
secondaryLayout.ColumnWidth = {'1.3x', '2x'};
secondaryLayout.RowHeight = {'1x'};
secondaryLayout.Padding = [1 1 1 1];
secondaryLayout.Layout.Row = 2;
secondaryLayout.Layout.Column = 1;
handles.basicTreeLayout = uigridlayout(secondaryLayout);
handles.basicTreeLayout.ColumnWidth = {'1x'};
handles.basicTreeLayout.RowHeight = {'1x',0};
handles.basicTreeLayout.Padding = [1 1 1 1];
handles.basicTreeLayout.Layout.Row = 1;
handles.basicTreeLayout.Layout.Column = 1;
treeLayout = uigridlayout(handles.basicTreeLayout);
treeLayout.ColumnWidth = {'1x','1x'};
treeLayout.RowHeight = {'1x'};
treeLayout.Padding = [1 1 1 1];
treeLayout.Layout.Row = 1;
treeLayout.Layout.Column = 1;
handles.firstModelTree = uitree('Parent',treeLayout);
handles.secondModelTree = uitree('Parent',treeLayout);
handles.firstModelTree.Layout.Row = 1;
handles.firstModelTree.Layout.Column = 1;
handles.secondModelTree.Layout.Row = 1;
handles.secondModelTree.Layout.Column = 2;
handles.laodingDisplay = uibutton(handles.basicTreeLayout,'state','Text','');
handles.laodingDisplay.Icon = [handles.iconPath '\loading.png'];
handles.laodingDisplay.BackgroundColor = [1 1 1];
handles.laodingDisplay.Layout.Row = 2;
handles.laodingDisplay.Layout.Column = 1;
imageLayout = uigridlayout('Parent',secondaryLayout);
imageLayout.Layout.Row = 1;
imageLayout.Layout.Column = 2;
imageLayout.ColumnWidth = {'1x'};
imageLayout.RowHeight = {'1x',25,'1x',25};
handles.firstModelAxes = uiaxes('parent',imageLayout,'XTick',[],'YTick',[],'Box','on');
handles.firstModelAxes.Layout.Row = 1;
handles.firstModelAxes.Layout.Column = 1;
lookInsideButtonLayout = uigridlayout(imageLayout);
lookInsideButtonLayout.ColumnWidth = {'1x',25};
lookInsideButtonLayout.RowHeight = {'1x'};
lookInsideButtonLayout.Padding = [1 1 1 1];
lookInsideButtonLayout.Layout.Row = 2;
lookInsideButtonLayout.Layout.Column = 1;
handles.lookInsdieButtonA = uibutton(lookInsideButtonLayout, 'push','Text','');
handles.lookInsdieButtonA.Layout.Row = 1;
handles.lookInsdieButtonA.Layout.Column = 2;
handles.lookInsdieButtonA.Icon = [handles.iconPath '\lookInside.png'];
handles.lookInsdieButtonA.Tooltip = 'Look Inside';
handles.secondModelAxes = uiaxes('parent',imageLayout,'XTick',[],'YTick',[],'Box','on');
handles.secondModelAxes.Layout.Row = 3;
handles.secondModelAxes.Layout.Column = 1;
viewOutsideButtonLayout = uigridlayout(imageLayout);
viewOutsideButtonLayout.ColumnWidth = {'1.3x', 100,100, '1x',25};
viewOutsideButtonLayout.RowHeight = {'1x'};
viewOutsideButtonLayout.Padding = [1 1 1 1];
viewOutsideButtonLayout.Layout.Row = 4;
viewOutsideButtonLayout.Layout.Column = 1;
handles.viewOutsideButton = uibutton(viewOutsideButtonLayout, 'push','Text','Export');
handles.viewOutsideButton.Layout.Row = 1;
handles.viewOutsideButton.Layout.Column = 2;
handles.helpButton = uibutton(viewOutsideButtonLayout, 'push','Text','Help');
handles.helpButton.Layout.Row = 1;
handles.helpButton.Layout.Column = 3;
handles.lookInsdieButtonB = uibutton(viewOutsideButtonLayout, 'push','Text','');
handles.lookInsdieButtonB.Layout.Row = 1;
handles.lookInsdieButtonB.Layout.Column = 5;
handles.lookInsdieButtonB.Icon = [handles.iconPath '\lookInside.png'];
handles.lookInsdieButtonB.Tooltip = 'Look Inside';

% Check if required python packages are installed
pe = pyenv;
[numpyPackage,~] = system('python -c "import numpy"');
[opencvPackage,~] = system('python -c "import cv2"');
[scikitPackage,~] = system('python -c "import skimage"');

if isempty(pe.Version) || opencvPackage || scikitPackage || numpyPackage
    handles.pythonButton.Enable = 'off';
end

% Set Type option based on choice
if isequal(choice,1)
    handles.modelButton.Value = true;
else
    handles.subsystemButton.Value = true;
end

% Set Model Difference Tool Figure Visible
set(handles.figureH,'Visible','on');

%--------------------------------------------------------------------------
% Set Callback for uicontrols
set(handles.firstModelTree,'SelectionChangedFcn',{@nodeSelectCallback,handles},...
    'NodeExpandedFcn',{@nodeExpandedCallback,handles},...
    'NodeCollapsedFcn',{@nodeCollapsedCallback,handles});
set(handles.secondModelTree,'SelectionChangedFcn',{@nodeSelectCallback,handles},...
    'NodeExpandedFcn',{@nodeExpandedCallback,handles},...
    'NodeCollapsedFcn',{@nodeCollapsedCallback,handles});
set(handles.addToPathButtonA,'ButtonPushedFcn',{@addFolderCallback,handles,1});
set(handles.addToPathButtonB,'ButtonPushedFcn',{@addFolderCallback,handles,2});
set(handles.firstModelBrowseButton,'ButtonPushedFcn',{@browseButtonCallback,handles});
set(handles.secondModelBrowseButton,'ButtonPushedFcn',{@browseButtonCallback,handles});
set(handles.compareButton,'ButtonPushedFcn',{@compareButtonCallback,handles});
set(handles.viewOutsideButton,'ButtonPushedFcn',{@viewOutsideButtonCallback,handles});
set(handles.lookInsdieButtonA,'ButtonPushedFcn',{@lookInsdieButtonCallback,handles,1});
set(handles.lookInsdieButtonB,'ButtonPushedFcn',{@lookInsdieButtonCallback,handles,2});
set(handles.helpButton,'ButtonPushedFcn',{@helpButtonCallback});
set(ButtonGroupA,'SelectionChangedFcn',{@radioButtonChangedCallback,handles});
set(handles.firstModelEditField,'ValueChangedFcn',{@editFieldValueChanged,handles});
set(handles.secondModelEditField,'ValueChangedFcn',{@editFieldValueChanged,handles})

% Set Usse Data uicontrols
set(handles.firstModelBrowseButton,'userData',{});
set(handles.secondModelBrowseButton,'userData',{});

% Handling the return argument.
if nargout == 1
    varargout{1} = handles;
end

end
%==========================================================================
function nodeSelectCallback(src,event,handles)
% Node Selection Change Callback

% Get selected node and find another node
selectedNode = event.SelectedNodes;
userData = selectedNode.UserData;
nodeData = selectedNode.NodeData;
figureUserData = get(handles.figureH,'userData');
[firstModelData,secondModelData] = figureUserData{:};

if strcmp(userData,'A')
    anotherNode = getAnotherNode(secondModelData,nodeData);
    handles.secondModelTree.SelectedNodes = anotherNode;
    % Set Image
    setImage(selectedNode,firstModelData,handles.firstModelAxes)
    setImage(anotherNode,secondModelData,handles.secondModelAxes)
else
    anotherNode = getAnotherNode(firstModelData,nodeData);
    handles.firstModelTree.SelectedNodes = anotherNode;
    % Set Image
    setImage(selectedNode,secondModelData,handles.secondModelAxes)
    setImage(anotherNode,firstModelData,handles.firstModelAxes)
end

end
%==========================================================================
function nodeExpandedCallback(src,event,handles)
% Node Expansion Callback

% Get selected node and find another node
selectedNode = event.Node;
userData = selectedNode.UserData;
nodeData = selectedNode.NodeData;
figureUserData = get(handles.figureH,'userData');
[firstModelData,secondModelData] = figureUserData{:};

if strcmp(userData,'A')
    anotherNode = getAnotherNode(secondModelData,nodeData);
else
    anotherNode = getAnotherNode(firstModelData,nodeData);
end
% Expand the another node
expand(anotherNode);

end
%==========================================================================
function nodeCollapsedCallback(src,event,handles)
% Node Expansion Callback

% Get selected node and find another node
selectedNode = event.Node;
userData = selectedNode.UserData;
nodeData = selectedNode.NodeData;
figureUserData = get(handles.figureH,'userData');
[firstModelData,secondModelData] = figureUserData{:};

if strcmp(userData,'A')
    anotherNode = getAnotherNode(secondModelData,nodeData);
else
    anotherNode = getAnotherNode(firstModelData,nodeData);
end
% Collapse the another node
collapse(anotherNode);

end
%==========================================================================
function browseButtonCallback(src,event,handles)
% Browse the simulink models

currentText = event.Source.Text;
% Get thw row index
rowIndex = event.Source.Layout.Row;

if rowIndex == 2
    handle = handles.firstModelEditField;
else
    handle = handles.secondModelEditField;
end

switch currentText
    case 'Browse'
        [ModelName,PathName] = uigetfile({'*.slx';'*.mdl'},'Select the Model');
        figure(handles.figureH);
        if ~(isequal(PathName,0))
            addpath(PathName);
            modelName = split(ModelName,'.');
            handle.Value = modelName{1};
        end
        firstModel = handles.firstModelEditField.Value;
        secondModel = handles.secondModelEditField.Value;
        userData{1} = firstModel;
        userData{2} = secondModel;
        handles.modelButton.UserData = userData;
    case 'GCB'
        value = gcb;
        handle.Value = value;
        firstModel = handles.firstModelEditField.Value;
        secondModel = handles.secondModelEditField.Value;
        userData{1} = firstModel;
        userData{2} = secondModel;
        handles.subsystemButton.UserData = userData;
end

end
%==========================================================================
function compareButtonCallback(src,event,handles)
% Compare the given simulink models

% Check if both the model names are provided
if isempty(handles.firstModelEditField.Value) || isempty(handles.secondModelEditField.Value)
    return
end

% Change the RowHeight of the basicTreeLayout
handles.basicTreeLayout.RowHeight = {0,'1x'};
drawnow();

% Clear the current image from axes
cla(handles.firstModelAxes);
set(handles.firstModelAxes,'XTick',[],'YTick',[],'Box','on');
cla(handles.secondModelAxes);
set(handles.secondModelAxes,'XTick',[],'YTick',[],'Box','on');

firstModelData.image = {};
firstModelData.handles = [];
secondModelData.image = {};
secondModelData.handles = [];

currentText = handles.firstModelBrowseButton.Text;
switch currentText
    case 'Browse'
        % Get the Simulink model name
        [~,firstModelName,~] = fileparts(handles.firstModelEditField.Value);
        [~,secondModelName,~] = fileparts(handles.secondModelEditField.Value);
        firstModelPath = handles.firstModelEditField.Value;
        secondModelPath = handles.secondModelEditField.Value;
    case 'GCB'
        firstModelName = strtok(handles.firstModelEditField.Value,'/');
        secondModelName = strtok(handles.secondModelEditField.Value,'/');
        firstModelPath = handles.firstModelEditField.Value;
        secondModelPath = handles.secondModelEditField.Value;
end
try
    % Load the Simulink model into the memory
    load_system(firstModelName);
    load_system(secondModelName);
catch
    errordlg('Error in loading the models.', 'Loading Error', 'modal');
end

% Set axes title
handles.firstModelAxes.Title.Interpreter= 'none';
handles.firstModelAxes.Title.String = firstModelName;
handles.secondModelAxes.Title.Interpreter= 'none';
handles.secondModelAxes.Title.String = secondModelName;

% Check if tree is empty
isfirstTreeEmpty = handles.firstModelTree.Children;
isSecondTreeEmpty = handles.secondModelTree.Children;
if ~(isempty(isfirstTreeEmpty) && isempty(isSecondTreeEmpty))
    isfirstTreeEmpty.delete;
    isSecondTreeEmpty.delete;
end

% Get firstModel and secondModel handles
stackA = get_param(firstModelPath,'Handle');
stackB = get_param(secondModelPath,'Handle');

% Get the system name
NameA = get_param(firstModelPath,'Name');
NameB = get_param(secondModelPath,'Name');

treeStackA = uitreenode(handles.firstModelTree,'Text',NameA);
treeStackB  = uitreenode(handles.secondModelTree,'Text',NameB);

% Storing each tree nodes handles in seperate structure
firstModelData.handles = [firstModelData.handles treeStackA];
secondModelData.handles = [secondModelData.handles treeStackB];

folderNamesA = get(handles.firstModelBrowseButton,'userData');
if isempty(folderNamesA)
    folderNamesA = {''};
end
folderNamesB = get(handles.secondModelBrowseButton,'userData');
if isempty(folderNamesB)
    folderNamesB = {''};
end

% Get image of both the models at top level and set an icon for the tree nodes
firstModelData = getImage(handles.imagesPath,stackA(end),firstModelData);
secondModelData = getImage(handles.imagesPath,stackB(end),secondModelData);
[firstModelData,secondModelData] = getEqualSizeImage(handles.imagesPath,firstModelData,secondModelData,stackA(end),stackB(end),folderNamesA,folderNamesB);
setIcon(firstModelData.handles,secondModelData.handles,firstModelData.image,secondModelData.image,handles.iconPath);

previouslyOpenedLibrary = {};
while (~isempty(stackA))
    % Pop the stack
    [stackA,outputA] = pop(stackA);
    [stackB,outputB] = pop(stackB);
    
    % Check if the handles are equal
    index = 0;
    if isequal(outputA,outputB)
        % Find the parent model
        index = findParentModel(outputA,firstModelName,secondModelName);
    end
    
    % Pop the treeStack
    [treeStackA,treeOutputA] = pop(treeStackA);
    [treeStackB,treeOutputB] = pop(treeStackB);
    
    previouslyOpenedLibrary = checkSameLibrary(outputA,outputB,previouslyOpenedLibrary,folderNamesA,folderNamesB);
    
    % Get the childs from both the models
    addpath(folderNamesA{:});
    childLevelsA = find_system(outputA,'Findall','on','LookUnderMasks','all','FollowLinks','on','Variants','All','SearchDepth',1,'BlockType','SubSystem');
    rmpath(folderNamesA{:});
    
    addpath(folderNamesB{:});
    childLevelsB = find_system(outputB,'Findall','on','LookUnderMasks','all','FollowLinks','on','Variants','All','SearchDepth',1,'BlockType','SubSystem');
    rmpath(folderNamesB{:});
    
    childLevelsA = setdiff(childLevelsA,outputA);
    childLevelsB = setdiff(childLevelsB,outputB);
    childLevelsA = getSubsystemBlocks(childLevelsA);
    childLevelsB = getSubsystemBlocks(childLevelsB);
    
    % Merging handles
    [extraA,childLevelsA] = checkIsPresent(childLevelsA,childLevelsB);
    [extraB,childLevelsB] = checkIsPresent(childLevelsB,childLevelsA);
    
    % Re-arranging according to first model
    [childLevelsA,childLevelsB] = rearrangeHandles(childLevelsA,childLevelsB);
    
    % Getting Images
    if index == 0
        addpath(folderNamesA{:});
        firstModelData = printImage(handles.imagesPath,childLevelsA,extraA,firstModelData);
        rmpath(folderNamesA{:});
        
        addpath(folderNamesB{:});
        secondModelData = printImage(handles.imagesPath,childLevelsB,extraB,secondModelData);
        rmpath(folderNamesB{:});
        
        [firstModelData,secondModelData] = getEqualSizeImage(handles.imagesPath,firstModelData,secondModelData,childLevelsA,childLevelsB,folderNamesA,folderNamesB);
    elseif index == 1
        addpath(folderNamesA{:});
        firstModelData = printImage(handles.imagesPath,childLevelsA,extraA,firstModelData);
        rmpath(folderNamesA{:});
        secondModelData = printWhiteImage(childLevelsB,secondModelData);
    else
        firstModelData = printWhiteImage(childLevelsA,firstModelData);
        addpath(folderNamesB{:});
        secondModelData = printImage(handles.imagesPath,childLevelsB,extraB,secondModelData);
        rmpath(folderNamesB{:});
    end
    
    childHandlesA = [];
    childHandlesB = [];
    childNodesA = [];
    childNodesB = [];
    % Creating treenodes for each child and save the handles
    for ii = 1:length(childLevelsA)
        childHandlesA(ii) = childLevelsA(ii);
        childNodesA(ii) = uitreenode(treeOutputA,'Text',get_param(childHandlesA(ii),'Name'));
        firstModelData.handles = [firstModelData.handles childNodesA(ii)];
        childHandlesB(ii) = childLevelsB(ii);
        childNodesB(ii) = uitreenode(treeOutputB,'Text',get_param(childHandlesB(ii),'Name'));
        secondModelData.handles = [secondModelData.handles childNodesB(ii)];
    end
    
    % Pushing to stack and tree stack
    stackA = push(stackA,childHandlesA);
    treeStackA = push(treeStackA,childNodesA);
    stackB = push(stackB,childHandlesB);
    treeStackB = push(treeStackB,childNodesB);
end

% Load previously loaded library model
try
    open_system(previouslyOpenedLibrary{:});
catch
end
% Finding image difference between both the images and set icon for each nodes
[firstModelData,secondModelData] = findImageDifference(firstModelData,secondModelData,handles);
checkImageDifference(firstModelData,secondModelData,handles.iconPath);

[firstModelData,secondModelData] = setNodeData(firstModelData,secondModelData);
[firstModelData,secondModelData] = setUserData(firstModelData,secondModelData);
set(handles.figureH,'UserData',{firstModelData,secondModelData});

handles.basicTreeLayout.RowHeight = {'1x',0};

% Expand all the nodes of the tree
expand(handles.firstModelTree,'all');
expand(handles.secondModelTree,'all');

end
%==========================================================================
function [stack,output] = pop(stack)
% Removes the last element from the stack

output = stack(end);
stack(end) = [];

end
%==========================================================================
function stack = push(stack,node)
% Add elements to the stack

stack = [stack node];

end
%==========================================================================
function [extras,extraH] = checkIsPresent(childA,childB)
% Check subsystems that have same name in both the models

extraH = childA;
extras = [];

for ii = 1:length(childB)
    name = get_param(childB(ii),'Name');
    count = 0;
    for jj = 1:length(childA)
        name1 = get_param(childA(jj),'Name');
        if isequal(name,name1)
            count = count+1;
        end
    end
    if count == 0
        extraH = [extraH;childB(ii)];
        extras = [extras childB(ii)];
    end
end

end
%==========================================================================
function source = printImage(path,systemNames,extras,source)
% Print the image of the system and save in modelData

for ii = 1:length(systemNames)
    count = 0;
    for jj = 1:length(extras)
        if isequal(systemNames(ii),extras(jj))
            source = getWhiteImage(source);
            count = count+1;
        end
    end
    if count == 0
        source = getImage(path,systemNames(ii),source);
    end
end

end
%==========================================================================
function source = printWhiteImage(systemNames,source)
% Print the whiteimage for the system that doesn't exists

for ii = 1:length(systemNames)
    source = getWhiteImage(source);
end

end
%==========================================================================
function source = getImage(path,systemName,source)
% Get the images of top-model and its subsytems
try
    sfBlockType = get_param(systemName,'SFBlockType');
catch
    sfBlockType = '';
end
fullPath = [path '\Image.png'];
if isequal(sfBlockType,'Chart') || isequal(sfBlockType,'State Transition Table')
    stateFlowObject = findStateflowObjects(systemName);
    sfprint(stateFlowObject,'png',fullPath)
else
    print(systemName,'-dpng',fullPath)
end
im = imread(fullPath);
delete(fullPath);
% Stores image data
source.image = [source.image im];

end
%==========================================================================
function source = getWhiteImage(source)
% Get white images for subsytems that doesn't exists

whiteImage = 255 * ones(648,1152,3,'uint8');
im = whiteImage;
% Stores image data
source.image = [source.image im];

end
%==========================================================================
function setIcon(handleA,handleB,imageA,imageB,iconPath)
% Set icons for each nodes

[bool,index] = checkWhite(imageA,imageB);
if bool
    if isequal(imageA,imageB)
        handleA.Icon = [iconPath '\greenTick.png'];
        handleB.Icon = [iconPath '\greenTick.png'];
    else
        handleA.Icon = [iconPath '\greenTick.png'];
        handleB.Icon = [iconPath '\redTick.png'];
    end
else
    if index == 1
        handleA.Icon = [iconPath '\notPresent.png'];
        handleB.Icon = [iconPath '\present.png'];
    elseif index == 2
        handleA.Icon = [iconPath '\present.png'];
        handleB.Icon = [iconPath '\notPresent.png'];
    end
end

end
%==========================================================================
function [bool,handleindex] = checkWhite(imageA,imageB)
% Check for white images

bool = true;
handleindex = 0;
whiteImage = 255 * ones(648, 1152, 3, 'uint8');

if isequal(imageA,whiteImage)
    handleindex = 1;
    bool = false;
elseif isequal(imageB,whiteImage)
    handleindex = 2;
    bool = false;
end

end
%==========================================================================
function [handleA,handleB] = rearrangeHandles(handleA,handleB)
% Rearrange the order of the subsystems handles based on first model

tempH = [];
count = 0;
for ii = 1:length(handleA)
    nameA = get_param(handleA(ii),'name');
    for jj = 1:length(handleB)
        nameB = get_param(handleB(jj),'name');
        if isequal(nameA,nameB)
            count = count+1;
            tempH(count) = handleB(jj);
            
        end
    end
end
handleB = tempH;

end
%==========================================================================
function index = findParentModel(output,firstModelName,secondModelName)
% Find the parent model of the handle

path = get(output,'path');
path = split(path,'/');
if isequal(firstModelName,path{1})
    index = 1;
elseif isequal(secondModelName,path{1})
    index = 2;
end

end
%==========================================================================
function checkImageDifference(sourceA,sourceB,iconPath)
% Check the difference between the image and set icon

for ii = 2:length(sourceA.handles)
    setIcon(sourceA.handles(ii),sourceB.handles(ii),sourceA.image{ii},sourceB.image{ii},iconPath);
end

end
%==========================================================================
function setImage(node,source,axesH)
% Set the image in Image Tab

for ii = 1:length(source.handles)
    if node == source.handles(ii)
        im = source.image{ii};
        imagesc(im,'Parent',axesH);
        set(axesH,'userData',{im});
        return
    end
end

end
%==========================================================================
function node = getAnotherNode(source,nodeData)
% Get the another node corresponding to the selected node

for ii = 1:length(source.handles)
    node = source.handles(ii);
    otherNodeData = node.NodeData;
    if isequal(nodeData,otherNodeData)
        return
    end
end

end
%==========================================================================
function [sourceA,sourceB] = setNodeData(sourceA,sourceB)
% Set Node data for each node

for ii = 1:length(sourceA.handles)
    sourceA.handles(ii).NodeData = ii;
    sourceB.handles(ii).NodeData = ii;
end

end
%==========================================================================
function [sourceA,sourceB] = setUserData(sourceA,sourceB)
% Set User data for each node

for ii = 1:length(sourceA.handles)
    sourceA.handles(ii).UserData = 'A';
    sourceB.handles(ii).UserData = 'B';
end

end
%==========================================================================
function [firstModelData,secondModelData] = getEqualSizeImage(imagesPath,firstModelData,secondModelData,childLevelsA,childLevelsB,folderNamesA,folderNamesB)
% Get equally sized image's from both the models

% Get total number of image data's
numberOfImageData = length(firstModelData.image);
jj = length(childLevelsA);
for ii = numberOfImageData:-1:(numberOfImageData - length(childLevelsA)+1)
    imageA = firstModelData.image{ii};
    imageB = secondModelData.image{ii};
    whiteImage = 255 * ones(648, 1152, 3, 'uint8');
    % Check if any one of the image is white
    if ~(isequal(imageA,whiteImage) || isequal(imageB,whiteImage))
        sizeA = size(imageA);
        sizeB = size(imageB);
        % Check if image's are of equal size
        if ~isequal(sizeA,sizeB)
            % Get both the subsystem handles
            handleA = childLevelsA(numberOfImageData-ii+jj);
            handleB = childLevelsB(numberOfImageData-ii+jj);
            % Check whether the subsytem is Simulink subsytem or Stateflow chart.
            try
                sfBlockTypeA = get_param(handleA,'SFBlockType');
            catch
                sfBlockTypeA = '';
            end
            try
                sfBlockTypeB = get_param(handleA,'SFBlockType');
            catch
                sfBlockTypeB = '';
            end
            % Get handles of all the objects from both subsytem's
            addpath(folderNamesA{:});
            if isequal(sfBlockTypeA,'Chart') || isequal(sfBlockTypeA,'State Transition Table')
                objectsA = findStateflowObjects(handleA);
                subsystemTypeA = 'stateFlow';
            else
                objectsA = find_system(handleA,'FindAll','on','LookUnderMasks','all','FollowLinks', 'on','Variants','All','SearchDepth',1);
                subsystemTypeA = 'simulink';
            end
            rmpath(folderNamesA{:});
            
            addpath(folderNamesB{:});
            if isequal(sfBlockTypeB,'Chart') || isequal(sfBlockTypeB,'State Transition Table')
                objectsB = findStateflowObjects(handleA);
                subsystemTypeB = 'stateFlow';
            else
                objectsB = find_system(handleB,'FindAll','on','LookUnderMasks','all','FollowLinks', 'on','Variants','All','SearchDepth',1);
                subsystemTypeB = 'simulink';
            end
            rmpath(folderNamesB{:});
            
            % Get positions of all the objects and find the four corners of
            % the system
            [posA,pointsA] = findPosAndPoints(objectsA,handleA,subsystemTypeA);
            [posB,pointsB] = findPosAndPoints(objectsB,handleB,subsystemTypeB);
            leftPos = [posA(:,1);posB(:,1)];rightPos = [posA(:,3);posB(:,3)];
            topPos = [posA(:,2);posB(:,2)];bottomPos = [posA(:,4);posB(:,4)];
            combinedPoints = [pointsA;pointsB];
            yPoints = [leftPos;rightPos;combinedPoints(:,1)];
            xPoints = [topPos;bottomPos;combinedPoints(:,2)];
            sizeCheck = true;
            cornerValue = 5;
            folderNames = {folderNamesA;folderNamesB};
            while(sizeCheck)
                topLeftCorner = [min(yPoints)-cornerValue min(xPoints)-cornerValue];
                topRigthCorner = [max(yPoints)+cornerValue min(xPoints)-cornerValue];
                bottomLeftCorner = [min(yPoints)-cornerValue max(xPoints)+cornerValue];
                bottomRigthCorner = [max(yPoints)+cornerValue max(xPoints)+cornerValue];
                annotationPositions = [topLeftCorner;topRigthCorner;bottomLeftCorner;bottomRigthCorner];
                subsystemTypes = {subsystemTypeA;subsystemTypeB};
                handles = [handleA;handleB];
                annotationObjects = [];
                symbols = {['/' char(9121)],['/' char(9124)],['/' char(9123)],['/' char(9126)]};
                % Add corner's for both the subsystem and print image's of the
                % subsytem's
                for jj = 1:length(handles)
                    subsystemType = subsystemTypes{jj};
                    folderName = folderNames{jj};
                    addpath(folderName{:});
                    if isequal(subsystemType,'stateflow')
                        object = findStateflowObjects(handles(jj));
                    else
                        parentPath = get_param(handles(jj),'Parent');
                        if ~isempty(parentPath)
                            parentPath = [parentPath '/'];
                        end
                        path = [parentPath get_param(handles(jj),'Name')];
                    end
                    for pos = 1:size(annotationPositions,1)
                        if strcmpi(subsystemType,'simulink')
                            annotationObject = Simulink.Annotation([path symbols{pos}],'Position',[annotationPositions(pos,1) annotationPositions(pos,2)]);
                            annotationObjects = [annotationObjects annotationObject];
                        else
                            annotationObject = Stateflow.Annotation(object,'Position',[annotationPositions(pos,1) annotationPositions(pos,2)]);
                            annotationObjects = [annotationObjects annotationObject];
                        end
                    end
                    rmpath(folderName{:});
                end
                fullPath = [imagesPath '\Image.png'];
                addpath(folderNamesA{:});
                if isequal(subsystemTypeA,'stateflow')
                    sfprint(handleA,'png',fullPath)
                    imageA = imread(fullPath);
                else
                    print(handleA,'-dpng',fullPath)
                    imageA = imread(fullPath);
                end
                % Remove the added corner's
                for jj = 1:length(annotationObjects)-4
                    annotationObjects(jj).delete;
                end
                rmpath(folderNamesA{:});
                
                
                addpath(folderNamesB{:});
                if isequal(subsystemTypeB,'stateflow')
                    sfprint(handleB,'png',fullPath)
                    imageB = imread(fullPath);
                else
                    print(handleB,'-dpng',fullPath)
                    imageB = imread(fullPath);
                end
                % Remove the added corner's
                for jj = length(annotationObjects):-1:5
                    annotationObjects(jj).delete;
                end
                rmpath(folderNamesB{:});
                
                delete(fullPath);
                if isequal(size(imageA),size(imageB))
                    sizeCheck = false;
                else
                    cornerValue = cornerValue+20;
                end
            end
            % Store the image data
            firstModelData.image{ii} = imageA;
            secondModelData.image{ii} = imageB;
        end
    end
    jj = jj-1;
end
end
%==========================================================================
function [positions,points] = findPosAndPoints(objects,parentHandle,subsystemType)
% Get the position or point's of each objects

positions = [];
points = [];
% Check if the subsystem is Simulink subsytem or Stateflow chart
if isequal(subsystemType,'stateflow')
    objectType = {'Annotation','AtomicBox','Box','Charts','EMFunction','Event','Function',...
        'SimulinkBasedState','SLFunction','State','Transition','TruthTable'};
    for ii = 1:length(objectType)
        % Get all the objects from current level of the chart
        objectValues = stateFlowObject.find('-isa',['Stateflow.' objectType{ii}],'-depth',1);
        % Iterate through each object
        for jj = 1:length(objectValues)
            try
                position = objectValues(jj).Position;
            catch
                try
                    midPoints = objectValues(jj).MidPoint;
                    srcPoints = objectValues(jj).SourceEndpoint;
                    destinationPoints = objectValues(jj).DestinationEndpoint;
                    points = [points;midPoints;srcPoints;destinationPoints];
                catch
                    position = [];
                end
            end
            positions = [positions;position];
        end
    end
else
    % Iterate through each object
    for ii = 1:length(objects)
        type = get_param(objects(ii),'type');
        if isequal(objects(ii),parentHandle)
            continue;
        end
        switch type
            case 'block'
                positionValue = get_param(objects(ii),'Position');
                positions = [positions;positionValue];
            case 'line'
                pointValue = get_param(objects(ii),'points');
                points = [points;pointValue];
            case 'annotation'
                positionValue = get_param(objects(ii),'Position');
                positions = [positions;positionValue];
        end
    end
end

end
%==========================================================================
function stateFlowObject = findStateflowObjects(handle)
% Get the stateflow object handle

blockDiagramObject = get_param(handle,'object');
stateFlowObject = blockDiagramObject.find('-isa','Stateflow.Chart','-depth',1);

end
%==========================================================================
function [firstModelData,secondModelData] = findImageDifference(firstModelData,secondModelData,handles)
% Find the exact difference between the images

imagePath = handles.imagesPath;
if isequal(handles.pythonButton.Value,1)
    choice = 'python';
else
    choice = 'matlab';
end
for ii = 1:length(firstModelData.handles)
    firstImage = firstModelData.image{ii};
    secondImage = secondModelData.image{ii};
    [bool,~] = checkWhite(firstImage,secondImage);
    if bool
        % Get the difference between the image's and mark the differnce
        if ~isequal(firstImage,secondImage)
            fullPathA = [imagePath '\ImageA.png'];
            fullPathB = [imagePath '\ImageB.png'];
            getImageDifference(firstImage,secondImage,choice,fullPathA,fullPathB);
            im = imread(fullPathA);
            delete(fullPathA);
            firstModelData.image{ii} = im;
            im = imread(fullPathB);
            delete(fullPathB);
            secondModelData.image{ii} = im;
        end
    end
end

end
%==========================================================================
function getImageDifference(firstImage,secondImage,choice,fullPathA,fullPathB)
% Get the difference between the image's and mark the differnce

if strcmpi(choice,'python')
    % Load the two input images
    imwrite(firstImage,fullPathA);
    imageA = py.cv2.imread(fullPathA);
    imwrite(secondImage,fullPathA);
    imageB = py.cv2.imread(fullPathA);
    % Convert the images to grayscale
    grayA = py.cv2.cvtColor(imageA, py.cv2.COLOR_BGR2GRAY);
    grayB = py.cv2.cvtColor(imageB, py.cv2.COLOR_BGR2GRAY);
    % Compute the Structural Similarity Index (SSIM) between the two
    % images, ensuring that the difference image is returned
    diff = py.skimage.measure.compare_ssim(grayA,grayB,pyargs('full',py.True));
    diff = py.numpy.asarray(diff(2));
    diff = (diff * 255);
    diff = py.numpy.asmatrix(diff);
    diff = diff.astype('uint8');
    % Threshold the difference image, followed by finding contours to
    % obtain the regions of the two input images that differ
    thresh = py.cv2.threshold(diff,0,255,py.cv2.THRESH_BINARY_INV+py.cv2.THRESH_OTSU);
    thresh = py.numpy.asarray(thresh(2));
    thresh = py.numpy.asmatrix(thresh);
    thresh = thresh.astype('uint8');
    cnts = py.cv2.findContours(thresh.copy(), py.cv2.RETR_EXTERNAL,py.cv2.CHAIN_APPROX_SIMPLE);
    cnts = py.imutils.grab_contours(cnts);
    % Loop over the contours
    for ind = 1:length(cnts)
        % Compute the bounding box of the contour and then draw the
        % bounding box on both input images to represent where the two
        % images differ
        cnt = cnts(ind);
        cnt = py.numpy.asarray(cnt);
        cnt = py.numpy.asmatrix(cnt);
        rectangleValues = py.cv2.boundingRect(cnt);
        rectangleValues = rectangleValues.cell;
        x = rectangleValues{1};
        y = rectangleValues{2};
        w = rectangleValues{3};
        h = rectangleValues{4};
        py.cv2.rectangle(imageA,{x,y},{x + w, y + h},{0, 255, 0},py.int(2));
        py.cv2.rectangle(imageB,{x,y},{x + w, y + h},{0, 0, 255},py.int(2));
    end
    % Write the images modified images in the given path
    py.cv2.imwrite(fullPathA,imageA);
    py.cv2.imwrite(fullPathB,imageB);
else
    % Convert the images to grayscale
    grayA = rgb2gray(firstImage);
    grayB = rgb2gray(secondImage);
    % Compute the difference between the images
    difference_image = grayB - grayA;
    [rows,columns] = find(~ismember(difference_image,0));
    % Difference between the images is shown by green and red colors
    for ii = 1:length(rows)
        firstImage(rows(ii),columns(ii),1) = 0;
        firstImage(rows(ii),columns(ii),2) = 255;
        firstImage(rows(ii),columns(ii),3) = 0;
    end
    difference_image = grayA - grayB;
    [rows,columns] = find(~ismember(difference_image,0));
    for ii = 1:length(rows)
        secondImage(rows(ii),columns(ii),1) = 255;
        secondImage(rows(ii),columns(ii),2) = 0;
        secondImage(rows(ii),columns(ii),3) = 0;
    end
    % Write the images modified images in the given path
    imagePaths = {fullPathA,fullPathB};
    imageDatas = {firstImage,secondImage};
    for ii = 1:length(imageDatas)
        imwrite(imageDatas{ii},imagePaths{ii});
    end
end

end
%==========================================================================
function viewOutsideButtonCallback(src,event,handles)
% To view the images in seperate figure

% Check if a node is selected
if isempty(handles.firstModelTree.SelectedNodes)
    return
end
% Check whether the figure is already created
axesFigure = findall(0,'type','figure','Tag','figure2');
if isempty(axesFigure)
    % If empty axesFigure then create a new figure
    scrsz = get(0,'ScreenSize');
    screensize_factor = 0.7;
    figsize = [(scrsz(3)*(1-screensize_factor))/2 (scrsz(4)*(1-screensize_factor))/2 ...
        scrsz(3)*screensize_factor scrsz(4)*screensize_factor];
    selectedNode = handles.firstModelTree.SelectedNodes.Text;
    axesFigure = figure('Name',selectedNode,'NumberTitle','off','Visible','off','Tag','figure2');
    set(axesFigure,'Position',figsize);
    set(axesFigure,'Visible','on');
end
% Get current image data
imageA = get(handles.firstModelAxes,'userData');
imageA = imageA{:};
imageB = get(handles.secondModelAxes,'userData');
imageB = imageB{:};
firstModelName = handles.firstModelAxes.Title.String;
secondModelName = handles.secondModelAxes.Title.String;
% Set the image's in the axes of new figure
subPlot1 = subplot(211,'parent',axesFigure,'Box','on');subPlot1.XTick = [];subPlot1.YTick = [];
imagesc(imageA);
subPlot1.XTick = [];subPlot1.YTick = [];
firstAxestitle = title(firstModelName,'Interpreter','none');
subPlot1.Title = firstAxestitle;
subPlot2 = subplot(212,'parent',axesFigure,'Box','on');subPlot2.XTick = [];subPlot2.YTick = [];
imagesc(imageB);
subPlot2.XTick = [];subPlot2.YTick = [];
secondAxestitle = title(secondModelName,'Interpreter','none');
subPlot2.Title = secondAxestitle;

end
%==========================================================================
function previouslyOpenedLibrary = checkSameLibrary(handleA,handleB,previouslyOpenedLibrary,folderNamesA,folderNamesB)
% Get the previuosly opened library blocks

% Get library blocks in the current system
libraryInfoA = libinfo(handleA,'searchdepth',1);
libraryInfoB = libinfo(handleB,'searchdepth',1);

for ii = 1:length(libraryInfoA)
    libraryA = libraryInfoA(ii).Library;
    for jj = 1:length(libraryInfoB)
        libraryB = libraryInfoB(ii).Library;
        % check if both the model refers to same library model
        if isequal(libraryA,libraryB)
            % check if library is loaded
            isLoaded = bdIsLoaded(libraryA);
            if isLoaded
                try
                    library = Simulink.MDLInfo(libraryA);
                catch
                    library = '';
                end
                % Check if path of boh the library block is given
                boolA = isLibraryPathGiven(folderNamesA,libraryA);
                boolB = isLibraryPathGiven(folderNamesB,libraryB);
                if boolA && boolB
                    % Close the already loaded library block
                    previouslyOpenedLibrary = [previouslyOpenedLibrary library];
                    close_system(libraryA,0);
                end
            end
        end
    end
end

end
%==========================================================================
function bool = isLibraryPathGiven(folderNames,libraryName)
% Check whether the libray model is present in the given path

bool = false;
for ii = 1:length(folderNames)
    fileslx = dir(fullfile(folderNames{ii},[libraryName '.slx']));
    filemdl = dir(fullfile(folderNames{ii},[libraryName '.mdl']));
    if ~isempty(fileslx) || ~isempty(filemdl)
        bool = true;
        return
    end
end

end
%==========================================================================
function lookInsdieButtonCallback(src,event,handles,choice)
% Locate to the Selected System

% Check if a node is selected
if isempty(handles.firstModelTree.SelectedNodes)
    return
end

if isequal(choice,1)
    handle = handles.firstModelTree;
    existingPath = handles.firstModelEditField.Value;
else
    handle = handles.secondModelTree;
    existingPath = handles.secondModelEditField.Value;
end

parentPath = {};
% Get the name of the selected system
parentPath{1} = handle.SelectedNodes.Text;
index = 2;
check = true;
curentNode = handle.SelectedNodes;
% Iterate to each node and get it's parent node
while(check)
    curentNode = curentNode.Parent;
    if strcmpi(curentNode.Type,'uitree')
        check = false;
    else
        parentPath{index} = curentNode.Text;
        index = index+1;
    end
end
% Get the path of the selected system
systemPath = [];
for ii = length(parentPath):-1:1
    parent = parentPath{ii};
    systemPath = [systemPath parent '/'];
end
systemPath(end) = '';
existingPath = split(existingPath,'/');
existingPath(end) = [];
existingPath = join(existingPath,'/');
systemPath = horzcat(existingPath{:},systemPath);
% Check if the Given path exists in the model
try
    open_system(systemPath);
catch
    msgbox('Selected System doesn''t exists','Error','modal');
end

end
%==========================================================================
function helpButtonCallback(src,event)
% Help Button Callback

open('ModelImageComparison_doc.pdf');

end
%==========================================================================
function radioButtonChangedCallback(src,event,handles)
% Type radio button's changed Callback

% Get the existing value
modelButtonUserData = handles.modelButton.UserData;
subsystemButtonUserData = handles.subsystemButton.UserData;
% Get the newly selected values
selectedOption = event.NewValue.Text;
switch selectedOption
    case 'Simulink Model'
        value = 'Browse';
        labelA = 'First Model';
        labelB = 'Second Model';
        if isempty(modelButtonUserData)
            handles.firstModelEditField.Value = '';
            handles.secondModelEditField.Value = '';
        else
            handles.firstModelEditField.Value = modelButtonUserData{1};
            handles.secondModelEditField.Value = modelButtonUserData{2};
        end
    case 'Simulink Subsystem'
        value = 'GCB';
        labelA = 'First System Path';
        labelB = 'Second System Path';
        if isempty(subsystemButtonUserData)
            handles.firstModelEditField.Value = '';
            handles.secondModelEditField.Value = '';
        else
            handles.firstModelEditField.Value = subsystemButtonUserData{1};
            handles.secondModelEditField.Value = subsystemButtonUserData{2};
        end
end
% Change the name of the buttons
handles.firstModelBrowseButton.Text = value;
handles.secondModelBrowseButton.Text = value;
handles.firstModelLabel.Text = labelA;
handles.secondModelLabel.Text = labelB;

end
%==========================================================================
function editFieldValueChanged(src,event,handles)
% Edit field Value changed Callback

% Get the row index
rowIndex = event.Source.Layout.Row;

% Set the existing edit field value to user data
if rowIndex == 2
    firstModel = handles.firstModelEditField.Value;
    secondModel = handles.secondModelEditField.Value;
    userData{1} = firstModel;
    userData{2} = secondModel;
    handles.modelButton.UserData = userData;
else
    firstModel = handles.firstModelEditField.Value;
    secondModel = handles.secondModelEditField.Value;
    userData{1} = firstModel;
    userData{2} = secondModel;
    handles.subsystemButton.UserData = userData;
end

end
%==========================================================================
function [modelName,choice] = inputValidation(modelName,preferredChoice)
% Input validation

if ~isempty(strfind(modelName,'.slx')) || ~isempty(strfind(modelName,'.mdl')) || isequal(preferredChoice,1)
    % Check for valid simulink model
    [~,modelName] = fileparts(modelName);
    if ~exist(modelName)
        error('Please provide a valid simulink model');
    end
    choice = 1;
elseif any(ismember(modelName,'/')) || isequal(preferredChoice,2)
    splittedValue = strtok(modelName,'/');
    % Check if valid simulink system path is provided
    if ~exist(splittedValue,'file')
        error('Add the simulink model to path');
    end
    blockHandle = getSimulinkBlockHandle(modelName);
    if isequal(blockHandle,-1)
        error('Please provide a valid simulink system path');
    end
    choice = 2;
else
    % Check for valid simulink model
    if exist(modelName,'file')
        [~,modelName] = fileparts(modelName);
    else
        error('Please provide a valid simulink model')
    end
    choice = 1;
end

end