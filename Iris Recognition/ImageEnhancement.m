


function [enhance_image] = ImageEnhancement (normalize_img)

f = @(x) round((mean(mean(x))));
%The mean of each 16x16 small block constitutes a coarse estimate of the
%background illumination
coarse_img = blkproc(normalize_img,[16 16],f);
%expanded to the same size as the normalized image by bicubic interpolation
est_img = round(imresize(coarse_img,16,'bicubic'));
est_img = uint8(est_img);
%The estimated background illumination is subtracted from the normalized image
Z = imsubtract(normalize_img,est_img);

f1 = @(x) histeq(x);
%Apply histrogram equation in estimation of the background illumination
%32x32
enhance_img = blkproc(Z,[32 32],f1);

enhance_image=enhance_img;

%figure(4)
%subplot(5,1,1),imshow(normalize_img)
%title('Normalized image')
%subplot(5,1,2),imshow(est_img)
%title('Estimated background illumination')
%subplot(5,1,3),imshow(enhance_img)
%title('Normalized image after enhancement')
end



