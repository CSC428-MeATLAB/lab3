% Load images
color_im = imread("go1.jpg");
im = rgb2gray(color_im);
template = rgb2gray(imread("goStone2.jpg"));

% Normalized cross correlation against the template
res = normxcorr2(template,im);
figure;
imshow(res,[])

% Nonmaxima suppression
res = nonMaxSupp(res, 3, .6);
figure;
imshow(res,[])

% Display with bounding boxes
displayBoundingBox(color_im, res, template)


function [R] = nonMaxSupp(M, radius, threshold)
    % Initialize output
    R = zeros(size(M));
    % Threshold the image to only keep values close to max
    M=M.*(M>threshold*max(max(M)));
    % Iterate over the image
    for x=1:size(R,1)
        for y=1:size(R,2)
            xmax = min([x+radius, size(R,1)]);
            xmin = max([x-radius,1]);
            ymax = min([y+radius, size(R,2)]);
            ymin = max([y-radius,1]);
            maxval = true;
            % Iterate over a region around each pixel
            for i=xmin:xmax
                for j=ymin:ymax
                    % If it is not max inside that region, mark it
                    if M(i,j) >= M(x,y) && ~(x==i && y==j)
                        maxval = false;
                    end
                end
            end
            % If we never marked it as not a max, mark it as max
            if maxval
               R(x,y) = 1; 
            end
        end
    end
end

function [R] = displayBoundingBox(im, supp_im, template)
    hFig = figure;
    hAx = axes;
    imshow(im);
    % Iterate and find each maxima pixel
    for x=1:size(supp_im,2)
        for y=1:size(supp_im,1)
            if supp_im(y,x)==1
                % Align and draw a bounding box
                imrect(hAx, [x-size(template,2),y-size(template,1),size(template,2),size(template,1)]);
            end
        end
    end
end


