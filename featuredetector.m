%% SURF features method:
close all 
clear
clc
%
%
%% Load reference image, and Extract/Detect SURF Feature Points
%% -> Gate Image
img_gate = imread('g.png');
gate_gray = rgb2gray(img_gate);
gate_pts = detectSURFFeatures(gate_gray);
[gate_features,  gate_validPts] = extractFeatures(gate_gray,  gate_pts);
figure; 
imshow(img_gate);
hold on; 
plot(gate_pts.selectStrongest(50));
%
%% -> Feed Image
img_feed = imread('gg.jpg');
feed_gray = rgb2gray(img_feed);
feed_pts = detectSURFFeatures(feed_gray);
[feed_features, feed_validPts] = extractFeatures(feed_gray, feed_pts);
figure;
imshow(img_feed);
hold on; 
plot(feed_pts.selectStrongest(50));
%
%
%% Visualize/Display of SURF features
%% ->
%
figure;
subplot(5,5,3); 
title('SURF Features');
for i=1:6
    scale = gate_pts(i).Scale;
    image = imcrop(img_gate,[gate_pts(i).Location-10*scale 20*scale 20*scale]);
    subplot(5,5,i);
    imshow(image);
    hold on;
    rectangle('Position',[5*scale 5*scale 10*scale 10*scale],'Curvature',1,'EdgeColor','g');
end
%
%
%% Find Putative Point Matches
%% ->
%
index_pairs = matchFeatures(gate_features, feed_features);
gate_matched_pts = gate_pts(index_pairs(:, 1), :);
feed_matched_pts = feed_pts(index_pairs(:, 2), :);
figure
showMatchedFeatures(img_gate, img_feed, gate_matched_pts, feed_matched_pts, 'montage');
title('Showing all matches');
%
%
%% Locate the Object in the Scene Using Putative Matches
%% ->
%
[tform_matrix, gate_inlier_pts, feed_inlier_pts] = estimateGeometricTransform(gate_matched_pts, feed_matched_pts, 'similarity');
figure
showMatchedFeatures(img_gate, img_feed, gate_inlier_pts, feed_inlier_pts, 'montage');
title('Showing match only with Inliers');
%
%
%% Transform the points of the rectangle and enclose the detected gate with the rectangle  
%% ->
%
boxPolygon = [1, 1; size(img_gate, 2), 1; size(img_gate, 2), size(img_gate, 1); 1, size(img_gate, 1); 1, 1];
newBoxPolygon = transformPointsForward(tform_matrix, boxPolygon);
figure
imshow(img_feed);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'k', 'LineWidth', 4);
title('Detected Gate');
%
%
%% ------------------------------------------------END-----------------------------------------------------------