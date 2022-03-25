function sl_customization(cm)
% Simulink Customization for the Model Image Comparison Tool.
%
% Developed by: Sysenso Systems, https://sysenso.com/
% Contact: contactus@sysenso.com
%

% Register custom menu item in the tool menu
cm.addCustomMenuFcn('Simulink:PreContextMenu', @setModelContextMenuItems);

end
%==========================================================================
function schemaFcns = setModelContextMenuItems(callbackInfo)
% Define the custom menu function.

% Define the Item in Menu
schemaFcns = {@setModelDifferenceToolMenu};

end
%==========================================================================
function schema = setModelDifferenceToolMenu(callbackInfo)

schema = sl_action_schema;
schema.label = 'micTool';
schema.callback = @ModelDifferenceTool_Callback;

end
%==========================================================================
function ModelDifferenceTool_Callback(callbackInfo)
% Launch the Model Image Comparison Tool.

currentSystem = split(gcs);
micTool(currentSystem{1});

end