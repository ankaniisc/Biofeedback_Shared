% Basic Graphical User Interface (GUI) without using GUIDE
% Available at https://dadorran.wordpress.com
 
% There are three basic areas to understand:
%   1. Layout    (how to position objects on the GUI)
%   2. Handles to Objects (used to modify object properties)
%   3. Callback functions (used by User Interface Objects)
 
 
%create a figure to house the GUI
figure
 
                 
%create an annotation object 
ellipse_position = [0.4 0.6 0.1 0.2];
ellipse_h = annotation('ellipse',ellipse_position,...
                    'facecolor', [1 0 0]);
                 
%create an editable textbox object
edit_box_h = uicontrol('style','edit',...
                    'units', 'normalized',...
                    'position', [0.3 0.4 0.4 0.1]);
 
%create a "push button" user interface (UI) object
but_h = uicontrol('style', 'pushbutton',...
                    'string', 'Update Color',...
                    'units', 'normalized',...
                    'position', [0.3 0 0.4 0.2],...
                    'callback', {@eg_fun,edit_box_h, ellipse_h });
             
%Slider object to control ellipse size
uicontrol('style','Slider',...        
            'Min',0.5,'Max',2,'Value',1,...
            'units','normalized',...
            'position',[0.1    0.2    0.08    0.25],...
            'callback',{@change_size,ellipse_h,ellipse_position });
         
uicontrol('Style','text',...
            'units','normalized',...
            'position',[0    0.45    0.2    0.1],...
            'String','Ellipse Size')
 
%eg_fun code ---------------------------------------------------
%copy paste this code into a file called eg_fun.m
% function eg_fun(object_handle, event)
%     disp('hi')
 
%updated eg_fun used to demonstrate passing variables
%copy paste this code into a file called eg_fun.m

                 
%change_size code --------------------------------------------------
%copy paste this code into a file called change_size.m

