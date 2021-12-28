function [boundary] = trace(image)
%TRACE the bouandary of a given image
%   returns a 2xn matrix containing the coordinates of the image boundary (n is the legth of the boundary) and
%   a binary image showing only the contour of the shape.

%   this function works only on images containing one shape and the result
%   of the object segmantation and edge detection should return a connected
%   contour

image = im2gray(image);
image = imadjust(image);
image = imbinarize(image,"adaptive","ForegroundPolarity","dark");
[image_hight, image_width] = size(image);
start_pixel_found = 0;

for i = 1:image_hight
    for j = 1:image_width
        if image(i,j) == 0
            start_pixel_found = 1;
            break;
        end
    end
    if start_pixel_found
        break;
    end
end

starting_pixel = [i j];

offset = [0 -1; -1 -1; -1 0; -1 1; 0 1; 1 1; 1 0; 1 -1];
switch_indx = [7 7 1 1 3 3 5 5];
offset_indx = 1;

p = starting_pixel;
c = p + offset(offset_indx,:);

B = starting_pixel;


steps = 0;
% max_steps = 2000;
% && steps < max_steps

while ~isequal(c, starting_pixel) 
    steps = steps +1;
    if image(c(1), c(2)) == 0
        B = [B; c];
        p = c;
        offset_indx = switch_indx(offset_indx);
        c = p + offset(offset_indx,:);
    else
        if offset_indx == 8
            offset_indx = 1;
        else
            offset_indx = offset_indx + 1;
        end
        c = p + offset(offset_indx,:);
    end
end

boundary = B;

end

