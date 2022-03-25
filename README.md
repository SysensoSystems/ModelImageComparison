# ModelImageComparison

Helps to compare two Simulink models and finds the difference between the models using image comparison approach.

To compare the Simulink models and find/merge differences, MATLAB has an inbuilt tool: https://mathworks.com/help/simulink/model-comparison.html. There are other commercial tools available in the market.

This utility will also help to compare models but it uses image comparison approach. Other tools does model/block property/parameter comparison.
Even though the other tools has paramater-value comparison features, this utility has some advantages.
- Easy to use and does comparison similar to manual approach(view and compare)
- It can even extended to compare model/block dialogs(still using image comparison!) and hence model/block parameters
- With the source code available, the user can customize it for their specific usage.

Usage:
- Add the ModelImageComparison folder or ModelImageComparison/utils folder to the MATLAB path.
- Use "micTool" command to launch the tool.
- Use "Help" button to launch the detailed help document.

The model differences will be highlighted either by using two approaches,
* MATLAB - Pixel Differences: Finds pixel-wise image differences using MATLAB code.
* Python - scikit-image Processing: Uses "scikit-image: Image processing in Python" package to find image differences.

Note: Please share your comments and contact us if you are interested in updating the features further.
The GUI developed using AppDesigner commands. Hence this tool useful from R2018B version. If the utility need to be used for previous versions, then please let us know. We will upload a compatible version.

Developed by: Sysenso Systems, https://sysenso.com/
Contact: contactus@sysenso.com


MATLAB Release Compatibility: Created with R2019b
Compatible with R2019b and later releases
