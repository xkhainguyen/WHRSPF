function [Img,stat,sigma,rad,wg,wl,small]=selectImage(index);
switch index
    case 1
        Img = imread('1.bmp');
        stat = 40;
        sigma = 1.5;
        rad = 5;
        wg = 0.9;
        wl = 0.1;
        small = 20;
    case 2
        Img = imread('2.pgm');
        stat = 30;
        sigma = 1.5;
        rad = 5;
        wg = 0.4;
        wl = 0.6;   
        small = 20;
    case 3
        Img = imread('3.pgm');
        stat = 60;
        sigma = 1.5;
        rad = 5;
        wg = 0.9;
        wl = 0.1;     
        small = 20;
    case 4
        Img = imread('4.pgm');
        stat = 30;
        sigma = 4;
        rad = 15;
        wg = 1;
        wl = 0.1;   
        small = 20;
    case 5
        Img = imread('5.bmp');
        stat = 10;
        sigma = 1.5;
        rad = 5;  
        wg = 0.9;
        wl = 0.1;    
        small = 20;
    case 10
        Img = imread('10.bmp');
        stat = 20;
        sigma = 1.5;
        rad = 5;
        wg = 0.9;
        wl = 0.1;    
        small = 20;
    case 14
        Img = imread('14.jpg');
        stat = 40;
        sigma = 2;
        rad = 10;   
        wg = 0.8;
        wl = 0.2;  
        small = 300;
end
end

