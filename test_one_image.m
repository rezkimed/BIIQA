 
close all; clear all; clc;
addpath('tools\');


image='17_1';
method='herling';   % herling/xu/tv
mask_f='images\mask1.png'; % mask1/mask3

 
image_f=['images\',method,'_',image,'.png' ];
BIIQA=BIIQA_computer(image_f, mask_f);
  
fprintf('BIIQA score = %f \n',BIIQA.score);

subplot(1,2,1);imshow(image_f);
subplot(1,2,2);imshow(mask_f);
 
 