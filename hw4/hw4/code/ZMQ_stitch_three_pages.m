clear; close all; clc;
imagepath = 'pier'; % hill or ledge or pier
imageName = '1.jpg';
img1 = imread(fullfile('..','data',imagepath,imageName));
imageName = '2.jpg';
img2 = imread(fullfile('..','data',imagepath,imageName));
imageName = '3.jpg';
img3 = imread(fullfile('..','data',imagepath,imageName));
imgs = {img1,img2,img3};
new_img = stitch_multiple_images(imgs);
