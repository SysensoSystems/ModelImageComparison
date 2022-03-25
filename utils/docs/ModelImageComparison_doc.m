%% *|Model Image Comparison Tool|*
%
% Model Image Comparison Tool helps to compare two Simulink models and
% finds the difference between the models using image comparison approach.
%
% Developed by: Sysenso Systems, https://sysenso.com/
%
% Contact: contactus@sysenso.com
%
% Version:
%
% * 1.0 - Initial Version.
%
%
%%
% *|Launching the tool|*
%
% * Before launching the tool, add the ModelImageComparison folder to the MATLAB path.
%
% <<..\images\path.png>>
%
%%
%
% * The tool can be launched by typing following the command as below in the MATLAB command window.
%
% * >> micTool
%
% <<..\images\commandWindow.png>>
%
% * Model Image Comparison Tool can be launched from the model context menu.
% If the menu is not available, run the following command in the MATLAB
% command window and then start using Simulink.
% >> sl_refresh_customizations
%
% <<..\images\modelMenu.png>>
%
% * Model Image Comparison Tool GUI launches with the current system name.
%
% <<..\images\modelDifferenceTool.png>>
%
%%
% *|Type|*
%
% "Type" option contains two radio buttons. Select anyone of the appropriate option.
%
% * Simulink Model(Default) - To compare two Simulink models and its Children.
% * Simulink Subsystem - To compare two Simulink Subsystems and its Children.
%
% <<..\images\typeOption.png>>
%%
% *|Browse|*
%
% * On clicking the Browse button on top of the GUI, a model dialog box
% opens, which enables the user to select the model to be compared.
%
% * Selected Model name will be displayed on the corresponding edit field.
%
% <<..\images\browseButton.png>>
%%
% *|Folder Icon|*
%
% * By selecting the button with folder icon, a GUI opens with the following actions.
%
% 1. *Add Folder* -  A dialog box opens enabling the user to select a
% folder and the selected folder will be added to MATLAB path.
%
% 2. *Add with SubFolder* - A dialog box opens enabling the user to select
% a folder. The selected folder and its sub-folders will be added to MATLAB path.
%
% 3. *Remove* - On clicking the Remove Folder Button, the selected folder
% will be removed from the MATLAB path.
%
% <<..\images\addFolderGUI.png>>
%%
% *|Show Difference Using|*
%
% "Show Difference Using" panel contains two choices.
%
% * MATLAB - Pixel Differences - Finds pixel-wise image differences using MATLAB code.
% * Python - scikit-image Processing - Uses "scikit-image: Image processing in Python" package to find image differences.
%
% Note: Python - scikit-image Processing radio button will be disabled if anyone of the following package is not installed
% within Python. Refer the links below for installing those packages.
%
% * OpenCV - <https://pypi.org/project/opencv-python/>
% * skimage - <https://scikit-image.org/docs/stable/install.html>
%
% Select anyone of the options to highlight the difference between the images.
%
% <<..\images\showDifference.png>>
%%
% *|Compare Button|*
%
% * Upon pressing the compare button, both the models are traversed
% simultaneously and then tree structure of the models are displayed with
% four different icons.
%
% * Green icon on both the sides - No Significant difference on the current level
% * Green icon and Red icon either sides - Significant difference on the current level
% * Filled Blue circle and Empty Blue circle on either side - Represents
% the current block is present only in one of the models.
%
% <<..\images\compareButton.png>>
%%
% *|Image Difference|*
%
% * When the Node from any one of the trees, it automatically selects the
% corresponding node on other tree and the image of the systems will be
% displayed on two separate axes.
%
% * If MATLAB - Pixel Differences radio button is selected.
%
% <<..\images\nodeSelectionMatlab.png>>
%
% * If Python - scikit-image Processing radio button is selected.
%
% <<..\images\nodeSelectionPython.png>>
%%
% *|Look Inside Icon|*
%
% * By using "Look Inside" button, the selected system will be opened in
% the corresponding model.
%
% <<..\images\lookInside.png>>
%%
% *|Export Button|*
%
% * By using the Export button, the images of the selected system will be
% displayed in a separate figure.
%
% <<..\images\viewButton.png>>
%
% * Now the images in the separate figure can also be edited and saved separately.
%
% <<..\images\exportFigure.png>>
