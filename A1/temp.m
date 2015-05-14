if size(chosen, 3) == 3
    bald = whitebalance(chosen);
    bald = rgb2gray(bald);
else
    bald = chosen;
end
imshow(histeq(bald))
figure(2), imshow(bald)

% Label the image - do connected components analysis.
[labeledImage, numberOfBlobs] = bwlabel(binaryImage, 4);     % Label each blob so we can make measurements of it
% Find the label that they clicked on
for k = 1 : length(x)
	row = round(y(k))
	column = round(x(k))
	labelNumber(k) = labeledImage(row, column)
end
outputImage = ismember(labeledImage, labelNumber);

%also look into ocr for text recog on numberplates :)