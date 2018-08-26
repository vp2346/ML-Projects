%function returns localized image and normalized image. 
%Input variables: image,pupil_circle,iris_circle, M and N. 
%pupil_circle,iris_circle are outputs from IrisLocalization function.
%They are 1x3 vectors containing row-centroid, column-centroid and radius. 
%M and N are height and weight of the normalized image. I use 64 and 512 
%according to ma's paper. 

function [N_image] = IrisNormalization(img,pupil_circle,iris_circle,M,N) 

[col,row]=size(img);  
for i = 1:col  
    for j = 1:row     
        %calculate distance between each pixel and iris centroid
        dis_iris = sqrt((i-iris_circle(2)).^2+(j-iris_circle(1)).^2);  
        if dis_iris > iris_circle(3)   
            %for pixels outside iris, set to black
            img(i,j) = 0;  
        end  
    end  
end  
for i = 1:col 
    for j = 1:row     
        %calculate distance between each pixel and pupil centroid
        dis_pupil = sqrt((i-pupil_circle(2)).^2+(j-pupil_circle(1)).^2);  
        if dis_pupil < pupil_circle(3)  
            %for pixels inside pupil, set to black
            img(i,j) = 0;  
        end  
    end  
end  

%I_circle: pupil and iris only image
I_circle = img; 


%map the original iris in a Cartesian coordinate system into a doubly dimensionless pseudopolar coordinate system
theta=2*pi/N;

for p=1:N
    Xp(1,p)=pupil_circle(2) + pupil_circle(3)*cos(p*theta); 
    Yp(1,p)=pupil_circle(1) + pupil_circle(3)*sin(p*theta); 
    Xi(1,p)=iris_circle(2) + iris_circle(3)*cos(p*theta);
    Yi(1,p)=iris_circle(1) + iris_circle(3)*sin(p*theta); 
end

for i = 1:M
    x(i,:)=round(Xp(1,:) + (Xi(1,:) - Xp(1,:))*i/M) ;
    y(i,:)=round(Yp(1,:) + (Yi(1,:) - Yp(1,:))*i/M) ; 
end

%change negative value to 1 (negative means circles are out of upper or left
%bound of image)
x=max(1,x);
y=max(1,y);
%map
for i=1:M
    for j=1:N
        %use min(x(i,j),280) in case x is over 280.
        N_image(i,j)=I_circle(min(x(i,j),280),min(y(i,j),320));
    end
end







