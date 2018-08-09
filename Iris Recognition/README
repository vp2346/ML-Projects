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




##IrisRecognition.m:
[pupil_centor, iris_centor] = IrisRecognition(I) finds circles for pupil and iris in image I. 
It returns two column vectors, each containing center row coordinate, column coordinate, and radius. 
Logic: For pupil detection, threshold value is determined based on histogram of each image. The algorithm first finds the maximum count 
for bins less than 100, and uses it as a threshold. Then it changes all other values greater than threshold to 255. 
After pre-processing, use imfindcircles to locate the pupil circle.  
For iris detection, use median filter with 9x9 window and canny edge detection. Then use imfindcircles to locate iris circle. If multiple circles are detected, use the one closest to pupil center. If distance between iris center and pupil center is greater than 10, use pupil center as iris center. 







Reference
• Ma et al., Personal Identification Based on IrisTexture Analysis, IEEE TRANSACTIONS ON
PATTERN ANALYSIS AND MACHINE INTELLIGENCE, VOL. 25, NO. 12, DECEMBER 2003
