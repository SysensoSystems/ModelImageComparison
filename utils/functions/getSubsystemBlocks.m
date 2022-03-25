function subBlocks = getSubsystemBlocks(subsystems)
% Get Simulink subsytem blocks and Stateflow charts

subBlocks = [];
% Iterate through each block and filter in-built simulink blocks.
for listIndex = 1:length(subsystems)
    subSystemH = subsystems(listIndex);
    linkStatus = get_param(subSystemH,'linkStatus');
    maskStatus = get_param(subSystemH,'mask');
    if ~(strcmp(linkStatus,'none'))
        blockReferencePath = get_param(subSystemH,'ReferenceBlock');
        if isSimulinkBlock(blockReferencePath) && isStateFlowObjectByPath(blockReferencePath)
            subBlocks = [subBlocks;subSystemH];
        end
    elseif strcmp(maskStatus,'on')
        maskType = get_param(subSystemH,'masktype');
        if checkExistingMaskType(maskType)
            subBlocks = [subBlocks;subSystemH];
        end
    elseif isStateFlowObjectByType(subSystemH)
        subBlocks = [subBlocks;subSystemH];
    end
end

end
%==========================================================================
function bool = checkExistingMaskType(maskType)
% To filter in-built simulink masked blocks

bool = 1;
% TODO: Have to filter simulink mask subsystems with empty mask type.
existingMaskTypes = {'','Sigbuilder block'};

for index = 1:length(existingMaskTypes)
    existingMasktype = existingMaskTypes{index};
    if strcmp(maskType,existingMasktype)
        bool = 0;
    end
end

end
%==========================================================================
function bool = isSimulinkBlock(blockReferencePath)
% To filter in-built simulink referenced blocks

bool = 1;
splitedPath = split(blockReferencePath,'/');

for index = 1:length(splitedPath)
    path = splitedPath{index};
    if strcmp(path,'simulink')
        bool = 0;
    end
end

end
%==========================================================================
function bool = isStateFlowObjectByPath(blockReferencePath)
% To filter in-built stateflow blocks

bool = 1;
splitedPath = split(blockReferencePath,'/');

for index = 1:length(splitedPath)
    path = splitedPath{index};
    if strcmp(path,'sflib')
        bool = 0;
    end
end

end
%==========================================================================
function bool = isStateFlowObjectByType(subSystem)
% To filter in-built stateflow blocks

bool = 1;
existingSFBlockTypes = {'Truth Table'};

try
    SFBlockType = get_param(subSystem,'SFBlockType');
catch
    SFBlockType = '';
end

for listIndex = 1:length(existingSFBlockTypes)
    existingSFBlockType = existingSFBlockTypes(listIndex);
    if strcmp(SFBlockType,existingSFBlockType)
        bool = 0;
    end
end

end