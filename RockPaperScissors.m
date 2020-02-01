
% Read in all the images
rock_template = rgb2gray(imread('rock_template.jpg'));
paper_template = rgb2gray(imread('paper_template.jpg'));
scissors_template = rgb2gray(imread('sissors_template.jpg'));
original_test_img = imread('paper_test_img2.jpg');
%original_test_img = rot90(original_test_img, 3);
test_img = rgb2gray(original_test_img);
%test_img = rot90(test_img, 3);

% Calculate normalized coefficient with each template
rock_corr = normxcorr2(rock_template, test_img);
paper_corr = normxcorr2(paper_template, test_img);
scissors_corr = normxcorr2(scissors_template, test_img);
figure, surf(rock_corr), shading flat
figure, surf(paper_corr), shading flat
figure, surf(scissors_corr), shading flat

%Display matched area.
hFig = figure;
hold on;
imshow(original_test_img);

% Find the max value in each template matching
max_corr_rock = max(rock_corr(:));
max_corr_paper = max(paper_corr(:));
max_corr_scissors = max(scissors_corr(:));

% Box the hand with the prediction
if (max_corr_rock > max_corr_paper) && (max_corr_rock > max_corr_scissors)
    [ypeak, xpeak] = find(rock_corr == max(rock_corr(:)));
    yoffSet = gather(ypeak - size(rock_template,1));
    xoffSet = gather(xpeak - size(rock_template,2));
    rectangle('Position',[xoffSet, yoffSet, size(scissors_template,2), size(scissors_template,1)], 'LineWidth',5, 'EdgeColor','red');
elseif (max_corr_paper > max_corr_rock) && (max_corr_paper > max_corr_scissors)
    [ypeak, xpeak] = find(paper_corr == max(paper_corr(:)));
    yoffSet = gather(ypeak - size(paper_template,1));
    xoffSet = gather(xpeak - size(paper_template,2));
    rectangle('Position',[xoffSet, yoffSet, size(scissors_template,2), size(scissors_template,1)], 'LineWidth',5, 'EdgeColor','white');
else
    [ypeak, xpeak] = find(scissors_corr == max(scissors_corr(:)));
    yoffSet = gather(ypeak - size(scissors_template,1));
    xoffSet = gather(xpeak - size(scissors_template,2));
    rectangle('Position',[xoffSet, yoffSet, size(scissors_template,2), size(scissors_template,1)], 'LineWidth',5, 'EdgeColor','blue');
end

%saveas(hFig,'bad_image1.png');

