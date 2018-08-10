## Implement the exact same design as Mal et al., 2003 paper (see the reference)

Database (CASIA Iris Image Database Version 1.0): contains 108 eyes, 7 iris images per eye, which were captured in two sessions 
(3 in the first session, 4 in the second session). All images are stored as BMP format with 320x280 pixel size.

Database download link:
http://biometrics.idealtest.org/findTotalDbByMode.do?mode=Iris

Experiment design: images from the first session will be used for training and images from the second session will be used for testing

## IrisRecognition.m:
When running this file, it will prompt a window asking to select a folder. Please select database folder, for example 
“CASIA Iris Image Database (version 1.0)”, which contains both train and test images so the function will work properly.
This function Loop over all image folders and takes IrisLocalization, IrisNormalization, ImageEnhancement and FeatureExtraction 
functions to generate x_train, y_train, x_test, and y_test data. 
We will use these 4 data for IrisMatching and PerformanceEvaluation to calculate CRR for each feature reduction method and distance method. It outputs table containing CRR
for each method:

| Similarity Measure       | Original Feature Set        | Reduced Feature Set using PCA only |   Reduced Feature Set using PCA & LDA   |
| -------------            |:-------------:              | :-----:|:-----:|
| L1 Distance     | 0.8750 | 0.8796 |  0.8634    |
| L2 Distance      | 0.8287      |  0.8287  |  0.8773    |
| Cosine Similarity | 0.8264      |    0.8264 |    0.8681   |


It also outputs CRR against dimensionality of feature vector:

<p align="center">
  <img width="560" height="400" src="https://user-images.githubusercontent.com/16806108/43931414-46608fd2-9c0c-11e8-933d-dbbcbf2bbc64.PNG">
</p>


## IrisLocalization.m:
[pupil_centor, iris_centor] = IrisRecognition(I) finds circles for pupil and iris in image I. It returns
two column vectors, each containing center row coordinate, column coordinate, and radius.
Logic: For pupil detection, I use threshold value based on histogram of each image. Find the
maximum count for bins less than 100, and use it as a threshold. Change all other values greater
than threshold to 255. Then apply imfindcircles to locate the pupil circle. For iris detection, use
median filter with 9x9 window and canny edge detection. Then use imfindcircles to locate iris
circle. If multiple circles are found, use the one closest to pupil center. If distance between iris
center and pupil center is greater than 10, use pupil center as iris center.

## IrisNormalization.m:
normalized_image = IrisNormalization(pupil_centor, iris_centor) takes pupil_centor and
iris_centor from IrisRecognition as input and outputs 64x512 normalized image.

Logic: Set M (row) to 64 and N (column) to 512 and use Daugman transform to project iris in
Cartesian coordinate to polar coordinates

## ImageEnhancement.m:
enhance_image = ImageEnhancement(normalized_image) takes 64x512 normalized image as
input and outputs same size enhanced image.
Logic: Get mean for each 16x16 small block of the normalized image, which returns 4x32 size
image. Then expand 4x32 image to 64x512 image A by bicubic interpolation. Use histogram
equalization in each 32x32 region of A, and it returns enhanced image of function output.

## FeatureExtraction.m:
feature_vector= FeatureExtraction(enhance_image) takes enhanced image as input and outputs
1x1536 feature vector.
Logic: First write a gabor filter function, which takes input of dimension, sigma_x and sigma_y. In
our example, dimension is 8x8, sigma_x1=3, sigma_y1=1.5, sigma_x2=4.5, sigma_y2=1.5. Create
2 filters from previous input values and use conv2 function to filter ROI (48x512) image. In each
8x8 block of the 2 filtered images, calculate absolute man and absolute standard deviation. Each
filter image has 768 feature components. Combine two feature components into 1D vector,
which returns a 1x1536 vector.

## IrisMatching.m:
pred_y= IrisMatching(x_train, y_train, x_test,feature_type,distance_type,numb_features) takes
training data (both x and y) and testing data (only x), returns predicted y value, specified by
feature_type and distance_type.

Feature_type:

‘all’ – using all features;

‘pca’ – using pca with default of 323 features;

‘lda’ – apply pca first then apply lda. If feature_type is ‘lda’, should also input numb_features
(number of features).

distance_type:

‘d1’ – L1 distance;

‘d2’ – L2 distance;

‘d3’ – Cosine similarity distance.

Logic: For feature reduction, since the dimension of each data is 1536 and number of training
data is 324, when apply LDA directly to the training data, it will cause singular matrix issue so I
apply PCA to reduce number of features to 323 then use LDA to further reduce number of
features to 107. LDA function is also included in this module. Apply feature reduction on both
train and test data. Calculate fi (mean vector) for each class. For each test data, calculate the
distance using three distance measures between test data and each fi. Then select the minimum
distance and classify it to that class.

## PerformanceEvaluation.m:
crr=PerformanceEvaluation(pred_y,y_test) takes predicted y value from IrisMatching and
returns crr (correct recognition rate). crr is calculate as number of correct prediction divide by
number of total samples.




Reference

• Ma et al., Personal Identification Based on IrisTexture Analysis, IEEE TRANSACTIONS ON
PATTERN ANALYSIS AND MACHINE INTELLIGENCE, VOL. 25, NO. 12, DECEMBER 2003


