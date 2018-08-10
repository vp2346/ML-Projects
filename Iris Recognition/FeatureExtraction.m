

function [feature_vector] = FeatureExtraction(enhance_img)
%ROI is 48x512 according to the paper 
ROI=enhance_img(1:48,:);

%using 3x3 gabor filter
gf1=gabor_filter(3,3,3,1.5);
gf2=gabor_filter(3,3,4.5,1.5);
%apply gabor filter in conv2
F1=conv2(ROI,gf1,'same');
F2=conv2(ROI,gf2,'same');

%break each image to 8x8 and calculate absoulte mean for each region.
f=@(x) meanabs(meanabs(x));
m1=blkproc(F1,[8 8],f);
m2=blkproc(F2,[8 8],f);

%%break each image to 8x8 and calculate mean absoulte deviation for each region.
f1=@(x) mean(abs(x(:) - meanabs(x(:))));
sigma1=blkproc(F1,[8 8],f1);
sigma2=blkproc(F2,[8 8],f1);

%rearrage 6x64 array to 1x384 vector
m1_1=m1(:)';
sigma1_1=sigma1(:)';
%combine two vectors in following order, (m1,sigma1,m2,sigma2,...)
f_vector_1((1:length(m1_1))*2 - 1) = m1_1;
f_vector_1((1:length(sigma1_1))*2) = sigma1_1;

m2_2=m2(:)';
sigma2_2=sigma2(:)';
f_vector_2((1:length(m2_2))*2 - 1) = m2_2;
f_vector_2((1:length(sigma2_2))*2) = sigma2_2;

%combine two feature vectors into one
feature_vector=[f_vector_1,f_vector_2];



% MxN garbor filter function, where M & N are even number, f=1/sigma_y
function [gf]=gabor_filter(M,N,sigma_x,sigma_y)
%M,N is odd number
height=(M-1)/2;
width=(N-1)/2;
f=1/sigma_y;
[x,y] = meshgrid(-height:height,-width:width);


M1=cos(2*pi*f*(sqrt(x.^2+y.^2)));
GF=(1/(2*pi*sigma_x*sigma_y))*exp(-0.5*(x.^2/sigma_x^2+y.^2/sigma_y^2)).*M1;

gf=GF;
end

end
