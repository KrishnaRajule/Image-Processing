% Main Program 
%% -> Image Detection and Tracking by Color and Masking/Threshold Methods
close all
clc
clear

%
%% Setup and Video Configuration of Web Cam
vid = videoinput('winvideo');
set(vid,'FramesPerTrigger',Inf);
set(vid,'ReturnedColorspace','rgb');
vid.FrameGrabInterval = 5;
%
start(vid);
%
%% Image Processing, Masking and Tracking Operations
while vid.FramesAcquired <= 1000
%   
    imgrgb = getsnapshot(vid);
    imghrgb = histeq(imgrgb);
    [BW,imgmrgb] = createMaskRGB(imgrgb);                   % Masking from RAL 1023 Color
    BW = medfilt2(BW,[3,3]);                                % Median Filitering/Remove Noise
    BW = bwareaopen(BW, 1000);                              % Remove small pixels/Remove Noise
%    
    %l = bwlabel(BW, 8);                                    % Label all the connected compenents which are bright   
    stats = regionprops(BW, 'BoundingBox', 'Centroid');     % Measure properties of image regions
    imshow(imgrgb);
%    
    hold on
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
%        
        rectangle('Position', bb, 'EdgeColor', 'k', 'LineWidth', 4);       % To generate a rectangle of size of the object detected
        plot(bc(1), bc(2) , '-k+');                                        % To plot the rectangle at the centroid of the object detected
    end
%    
    hold off
    flushdata(vid);
end
%
%% Stop Video Capture and Flush the data captured and stored to the buffer
%
stop(vid);
flushdata(vid);
%
%% --------------------------------------------------END----------------------------------------------------------