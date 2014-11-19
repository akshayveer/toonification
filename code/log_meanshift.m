%% toonification1: toonificarion of an image
function toonification1(imgSrc,output)

	myNumOfColors=256;
	myColorScale=[transpose([0:1/(myNumOfColors-1):1]),transpose([0:1/(myNumOfColors-1):1]),transpose([0:1/(myNumOfColors-1):1])];
	imagesc(single(phantom)); 
	colormap(myColorScale); 
	colormap jet;

	origImg=imread(imgSrc);

	imgRed=origImg(:,:,1);
	imgGreen=origImg(:,:,2);
	imgBlue=origImg(:,:,3);

	% applying Medain filter to remove Salt and Pepper noise from images
	imgRed=medfilt2(imgRed,[7 7]);
	imgGreen=medfilt2(imgGreen,[7 7]);
	imgBlue=medfilt2(imgBlue,[7 7]);

	toon(:,:,1)=imgRed;
	toon(:,:,2)=imgGreen;
	toon(:,:,3)=imgBlue;

	grayImage=rgb2gray(toon);

	binImage=edge(grayImage,'log');

	imwrite(uint8(255*binImage),strcat(output,'1','.png'));
	
	structureElement=strel('square',1);
	binImage=imdilate(binImage,structureElement);

	% imwrite(uint8(255*binImage),strcat(output,'2','.png'));

	%thresholding to remove small contours picked by canny edge detection
	connectImage = bwconncomp(binImage,18);
	threshold=10;
	connectImageSize=cellfun(@numel,connectImage.PixelIdxList);
	for i=(1:size(connectImageSize,2))
		if connectImageSize(i)<threshold
			binImage(connectImage.PixelIdxList{i}) = 0;
		end
	end

	% imshow(binImage);
	% imwrite(uint8(255*binImage),strcat(output,'3','.png'));


	% smoothing and quantizing colors
	toon=meanShift(double(toon));
	imgRed=toon(:,:,1);
	imgGreen=toon(:,:,2);
	imgBlue=toon(:,:,3);
	% imshow(toon);

	tempRed=imgRed.*(binImage*-1);
	imgRed=tempRed+imgRed;

	tempGreen=imgGreen.*(binImage*-1);
	imgGreen=tempGreen+imgGreen;

	tempBlue=imgBlue.*(binImage*-1);
	imgBlue=tempBlue+imgBlue;

	% color quantization
	quantize=30;
	imgRed=floor(imgRed/quantize)*quantize;
	imgGreen=floor(imgGreen/quantize)*quantize;
	imgBlue=floor(imgBlue/quantize)*quantize;


	toon(:,:,1)=imgRed;
	toon(:,:,2)=imgGreen;
	toon(:,:,3)=imgBlue;
	% imshow(uint8(toon));
	imwrite(uint8(toon),strcat(output,'4','.png'));

end