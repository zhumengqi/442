clear; close all; clc;
imageName = 'uttower_left.jpg';
img1 = imread(fullfile('..','data', imageName));
imageName = 'uttower_right.jpg';
img2 = imread(fullfile('..','data', imageName));
new_img = stitch_images(img1, img2);