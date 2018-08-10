%When running this file, it will prompt a window asking to select a folder. 
%Please select folder “CASIA Iris Image Database (version 1.0)”,
%which contains both train and test images so the function will work properly. 

format long g;
format compact;

% Define a starting folder.
path = fullfile('CASIA Iris Image Database (version 1.0)/');
%ask to select a folder
topfolder = uigetdir(path);
if topfolder == 0
	return;
end
subfolders = genpath(topfolder);

remain = subfolders;
folderNames = {};
while true
	[sub_folder, remain] = strtok(remain, ';');
	if isempty(sub_folder)
		break;
	end
	folderNames = [folderNames sub_folder];
end
no_folders = length(folderNames);
i=0;
i_t=0;
% Loop over all image files inside folders
for k = 1 : no_folders
	current = folderNames{k};
	fprintf('Processing folder %s\n', current);
	
	% Get bmp files.
	filePattern = sprintf('%s/*.bmp', current);
	names = dir(filePattern);
    
	no_images = length(names);
	% if folder has 3 images,process following
	if no_images ==3
		% loop over all those images
		for f = 1 : no_images            
            %store classes in y_train
            C = strsplit(names(f).name,'_');
            y=str2num(C{1});
            i=i+1;
            y_train(i,:)=y;         
                        
			full_names = fullfile(current, names(f).name);
			fprintf('     Processing image file %s\n', full_names);
            
            %show image with pupil and iris circle
            img = imread(full_names);
             
            [pupil_centor, iris_centor] = IrisLocalization(img);
            
            subplot(3,1,f),imshow(img);

            hold on

            theta = 0 : 0.01 : 2*pi;
            pupil_x = pupil_centor(3) * cos(theta) + pupil_centor(1);
            pupil_y = pupil_centor(3)  * sin(theta) + pupil_centor(2);
            plot(pupil_x, pupil_y, 'b-'); 

            iris_x = iris_centor(3) * cos(theta) + (iris_centor(1));
            iris_y = iris_centor(3)  * sin(theta) + (iris_centor(2));
            plot(iris_x, iris_y, 'b-');
            
            %get normalized image
            imageNormalized = IrisNormalization(img, pupil_centor, iris_centor,64,512);
            %get enhanced image     
            enhance_img = ImageEnhancement(imageNormalized);
            %get image feature vector
            f_vector=FeatureExtraction(enhance_img);
            x_train(i,:)=f_vector;
            
            %save all trainimages to train folder
            %img = getframe(gcf);
            %write images to folder
            %imwrite(img.cdata,sprintf('iris/train/train %d.jpg',y));
        end
    end
    %if folder has 4 images, process following
    if no_images ==4
		%loop over all images
		for f_t = 1 : no_images            
            %store classes in y_test
            C_t = strsplit(names(f_t).name,'_');
            y_t=str2num(C_t{1});
            i_t=i_t+1;
            y_test(i_t,:)=y_t;         
                        
			full_names_t = fullfile(current, names(f_t).name);
			fprintf('     Processing image file %s\n', full_names_t);
            
            %show image with pupil and iris circle
            img_t = imread(full_names_t);
             
            [pupil_center_t, iris_center_t] = IrisLocalization(img_t); 
            
            subplot(2,2,f_t),imshow(img_t);

            hold on

            theta = 0 : 0.01 : 2*pi;
            pupil_x_t = pupil_center_t(3) * cos(theta) + pupil_center_t(1);
            pupil_y_t = pupil_center_t(3)  * sin(theta) + pupil_center_t(2);
            plot(pupil_x_t, pupil_y_t, 'b-'); 

            iris_x_t = iris_center_t(3) * cos(theta) + (iris_center_t(1));
            iris_y_t = iris_center_t(3)  * sin(theta) + (iris_center_t(2));
            plot(iris_x_t, iris_y_t, 'b-');
            
            %get normalized image for test image
            imageNormalized_t = IrisNormalization(img_t, pupil_center_t, iris_center_t,64,512);
            %get enhanced image for test image      
            enhance_img_t = ImageEnhancement(imageNormalized_t);
            %get feature vector for test images
            f_vector_t=FeatureExtraction(enhance_img_t);
            %get x_test matrix
            x_test(i_t,:)=f_vector_t;
            
            %img_t = getframe(gcf);
            %imwrite(img_t.cdata,sprintf('iris/test/test %d.jpg',y_t));
        end 
    end
    
end


pred_y_all_d1=IrisMatching(x_train,y_train,x_test,y_test,'all','d1');
crr_all_d1=PerformanceEvaluation(pred_y_all_d1,y_test)
pred_y_all_d2=IrisMatching(x_train,y_train,x_test,y_test,'all','d2');
crr_all_d2=PerformanceEvaluation(pred_y_all_d2,y_test)
pred_y_all_d3=IrisMatching(x_train,y_train,x_test,y_test,'all','d3');
crr_all_d3=PerformanceEvaluation(pred_y_all_d3,y_test)
pred_y_pca_d1=IrisMatching(x_train,y_train,x_test,y_test,'pca','d1');
crr_pca_d1=PerformanceEvaluation(pred_y_pca_d1,y_test)
pred_y_pca_d2=IrisMatching(x_train,y_train,x_test,y_test,'pca','d2');
crr_pca_d2=PerformanceEvaluation(pred_y_pca_d2,y_test)
pred_y_pca_d3=IrisMatching(x_train,y_train,x_test,y_test,'pca','d3');
crr_pca_d3=PerformanceEvaluation(pred_y_pca_d3,y_test)
pred_y_lda_d1=IrisMatching(x_train,y_train,x_test,y_test,'lda','d1',107);
crr_lda_d1=PerformanceEvaluation(pred_y_lda_d1,y_test)
pred_y_lda_d2=IrisMatching(x_train,y_train,x_test,y_test,'lda','d2',107);
crr_lda_d2=PerformanceEvaluation(pred_y_lda_d2,y_test)
pred_y_lda_d3=IrisMatching(x_train,y_train,x_test,y_test,'lda','d3',107);
crr_lda_d3=PerformanceEvaluation(pred_y_lda_d3,y_test)

Similarity_Measure = {'L1 Distance Measure';'L2 Distance Measure';'Cosine Similarity Measure'};
Original_Feature_Set = {crr_all_d1;crr_all_d2;crr_all_d3};
Reduced_Feature_Set_PCA_only = {crr_pca_d1;crr_pca_d2;crr_pca_d3};
Reduced_Feature_Set_PCA_LDA = {crr_lda_d1;crr_lda_d2;crr_lda_d3};
T = table(Similarity_Measure,Original_Feature_Set,Reduced_Feature_Set_PCA_only,Reduced_Feature_Set_PCA_LDA)

j=1;
for i=20:10:100
      pred_y_lda_1=IrisMatching(x_train,y_train,x_test,y_test,'lda','d1',i);
      pred_y_lda_2=IrisMatching(x_train,y_train,x_test,y_test,'lda','d2',i);
      pred_y_lda_3=IrisMatching(x_train,y_train,x_test,y_test,'lda','d3',i);
      crr_d1(j) = PerformanceEvaluation(pred_y_lda_1,y_test);
      crr_d2(j) = PerformanceEvaluation(pred_y_lda_2,y_test);
      crr_d3(j) = PerformanceEvaluation(pred_y_lda_3,y_test);
      j=j+1;
end


figure; hold on
x_axis=(20:10:100);
plot(x_axis,crr_d1,'-*');
plot(x_axis,crr_d2,'-*');
plot(x_axis,crr_d3,'-*');
title('CRR vs Dimentionality');
xlabel('Dimensionality of the feature vector'); %x-axis label
ylabel('Correct recognition rate'); %y-axis label
legend('L1 distance','L2 distance','Cosine Similarity','Location','northwest');%legend



% dlmwrite('x_train.csv',x_train, 'delimiter', ',', 'precision', 17); 
% dlmwrite('y_train.csv',y_train, 'delimiter', ',', 'precision', 17); 
% dlmwrite('x_test.csv',x_test, 'delimiter', ',', 'precision', 17); 
% dlmwrite('y_test.csv',y_test, 'delimiter', ',', 'precision', 17); 
% writetable(T,'T.csv');
% x_train = csvread('x_train.csv');
% y_train = csvread('y_train.csv');
% x_test = csvread('x_test.csv');
% y_test = csvread('y_test.csv');

