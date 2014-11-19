%% CannyEdgeDetection: This function applies canny edge detection algorithm given an image
function OutImage = EdgeDetection(InImage)

	%applying Gaussian filter to blur and remove the noise
	GaussianMask=fspecial('Gaussian',[5 5],1.4);
	FilteredImage=imfilter(InImage,GaussianMask);
	
	%applying Medain filter to remove Salt and Pepper noise from images
	Filtered=medfilt2(FilteredImage,[7 7]);


	%applying sobel operator for gradients along x and y direction
	SobelMaskX=fspecial('sobel')';
	SobelMaskY=fspecial('sobel');

	NewSobelImageX=imfilter(FilteredImage,SobelMaskX);
	NewSobelImageY=imfilter(FilteredImage,SobelMaskY);
	

	NewSobelImage=sqrt(NewSobelImageX.^2+NewSobelImageY.^2);

	NewSobelImageGradient=atan2(abs(NewSobelImageY),abs(NewSobelImageX))*180/pi;

	NewSobelImageGradientRounding=arrayfun(@GradientRounding,NewSobelImageGradient);	

	[r,c]=size(NewSobelImageGradientRounding);

	ZeroPaddedImage=zeros(size(NewSobelImage)+2);
	ZeroPaddedImage(2:end-1,2:end-1)=NewSobelImage;
	EdgeDetectedImage=zeros(size(NewSobelImage));

	for i=[2:r+1]
		for j=[2:c+1]
			if NewSobelImageGradientRounding(i-1,j-1)==0
				if ZeroPaddedImage(i,j)>=ZeroPaddedImage(i,j-1) & ZeroPaddedImage(i,j)>=ZeroPaddedImage(i,j+1)
					EdgeDetectedImage(i-1,j-1)=ZeroPaddedImage(i,j);
				end	
			elseif NewSobelImageGradientRounding(i-1,j-1)==45
				if ZeroPaddedImage(i,j)>=ZeroPaddedImage(i-1,j+1) & ZeroPaddedImage(i,j)>=ZeroPaddedImage(i+1,j-1)
					EdgeDetectedImage(i-1,j-1)=ZeroPaddedImage(i,j);
				end
			elseif NewSobelImageGradientRounding(i-1,j-1)==90
				if ZeroPaddedImage(i,j)>=ZeroPaddedImage(i-1,j) & ZeroPaddedImage(i,j)>=ZeroPaddedImage(i+1,j)
					EdgeDetectedImage(i-1,j-1)=ZeroPaddedImage(i,j);
				end
			else
				if ZeroPaddedImage(i,j)>=ZeroPaddedImage(i-1,j-1) & ZeroPaddedImage(i,j)>=ZeroPaddedImage(i+1,j-1)
					EdgeDetectedImage(i-1,j-1)=ZeroPaddedImage(i,j);
				end
			end	
		end
	end

	EdgeDetectedImage=arrayfun(@DoubleThresholding,EdgeDetectedImage);
	EdgeDetectedImage=arrayfun(@ImageToLogical,EdgeDetectedImage);

	% EdgeDetectionImage=255*(EdgeDetectedImage-min(min(EdgeDetectedImage)))/(max(max(EdgeDetectedImage))-min(min(EdgeDetectedImage)));


	OutImage=EdgeDetectedImage;

	
	

	% imagesc(OutImage);
	% imshow(OutImage);

	%applying Medain filter to remove Salt and Pepper noise from images


	




end

%% GradientRounding : This funciton rounds gradients to nearest 45 degrees
function [Outval] = GradientRounding (Inval)

	if (Inval>=-22.5 & Inval<22.5) | (Inval>=157.5 & Inval<=180) | (Inval>=-180 & Inval<-180+22.5)	
		Outval=0;
	elseif (Inval>=22.5 & Inval<67.5) | (Inval>=-180+22.5 & Inval<-180+67.5)
		Outval=45;
	elseif (Inval>=67.5 & Inval<112.5) | (Inval>=-180+67.5 & Inval<-67.5)
		Outval=90;
	elseif (Inval>=112.5 & Inval<157.5) | (Inval>=-67.5 & Inval<-22.5)
		Outval=135;
	end
end

%% DoubleThresholding: Thresholding the image
function [Outval] = DoubleThresholding(Inval)
	HighThreshold=80;
	LowThreshold=20;
	%  double thresholding
			if Inval<LowThreshold
				Outval=0;
			elseif Inval>=HighThreshold
				Outval=Inval;
			else
				Outval=LowThreshold;
			end
end

%% ImageToLogical: making image to logical
 function [Outval] = ImageToLogical(Inval)
 	if Inval>0
 		Outval=1;
 	else
 		Outval=0;
 	end
 end
 


