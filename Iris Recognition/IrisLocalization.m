
function [pupil_centroid, iris_centroid]=IrisLocalization3(image)


[counts,binLocations] = imhist(image); %get histogram
[val,idx]=max(counts(1:100));%get pupil color
level=idx;
I1=image;
I1(I1>level)=255;%change any values greater than pupil color to white
bw=im2bw(I1);
[centers,radius] = imfindcircles(bw,[30 60],'ObjectPolarity','dark',...
          'Sensitivity',0.91,'Method','twostage');

     
pupil_c=[round(centers(1)), round(centers(2))];

med_img = medfilt2(image,[9 9],'symmetric'); % median filter on all images
edg = edge(med_img,'canny'); %canny on median filter image

% gau_img = imgaussfilt(image,3);
% edg = edge(gau_img,'canny');

% figure;   
% subplot(2, 2, 1); 
% imshow(image)
% title('Original')
% subplot(2, 2, 2);  
% imshow(gau_img)
% title('Gaussian Image');
% subplot(2, 2, 3);  
% imshow(edg); 
% title('Canny edge'); 

[centers_2,radius_2] = imfindcircles(edg,[95 130],'ObjectPolarity','bright',...
          'Sensitivity',0.96,'Method','twostage','EdgeThreshold',0.1);
      
if size(centers_2,1)==1 %if only one iris circle
    iris_c=[round(centers_2(1,1)), round(centers_2(1,2))];
    i_radius=radius_2;
end

if size(centers_2,1)>1 %if multiple iris circles are found
    n=size(centers_2,1);
    for i=1:n
        %distance between all iris center to pupil center
        m(i)=sqrt((centers_2(i,1)-centers(1))^2+(centers_2(i,2)-centers(2))^2);
    end
    %select the one with min distance
    [min_val,min_idx]=min(m);
    iris_c=[round(centers_2(min_idx,1)), round(centers_2(min_idx,2))];  
               
    
    i_radius=radius_2(min_idx);
end

%if iris_centroid is greater than 10, use pupil centroid
if sqrt((iris_c(1)-centers(1))^2+(iris_c(2)-centers(2))^2)>10
    iris_c=[round(centers(1)),round(centers(2))];
end

%column vector contains center row, column and radius
pupil_centroid=[pupil_c,radius];

iris_centroid=[iris_c,i_radius];

% subplot(2, 2, 4); 
% imshow(image);
% hold on
% theta = 0 : 0.01 : 2*pi;
% x = radius * cos(theta) + pupil_c(1);
% y = radius * sin(theta) + pupil_c(2);
% plot(x, y, 'b-');
% hold on
% theta = 0 : 0.01 : 2*pi;
% x_2 = i_radius * cos(theta) + iris_c(1);
% y_2 = i_radius * sin(theta) + iris_c(2);
% plot(x_2, y_2, 'b-');
% title('Original Image with boundary'); 
end

