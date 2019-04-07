# SVM_Multi-class_Classification_MNIST

Support Vector Machine is a supervised machine learning algorithm which can be used for both regression and classification purposes but mostly it is used in classification problems. The working of this algorithm is very simple. Each sample point of data is drawn in an n-dimensional space where n denotes the number of features. It means that value of each feature is actually the value of a particular coordinate. After drawing all the sample points, a Hyperplane is drawn which separates the two classes.


Drawing this Hyperplane can be a bit tricky in some cases. It is possible that two classes can be separated by a Hyperplane at different angle. But the optimal Hyperplane is the one which maximizes the margin of training data points. Support Vectors are the data points closer to Hyperplane and influence the position and orientation of it. Therefore, it is quite obvious that deleting the Support Vectors will change the position of Hyperplane because they are the points which help to build SVM.


In many cases, it becomes impossible to separate the data points using Linear Hyperplane. To solve this issue, Kernel Trick is used which converts not separable problem to separable by transforming low-dimensional inputs space to a high dimensional space.


Parameters ‘C’ and ‘Gamma’ play an important role in drawing a Hyperplane. Parameter ‘C’ is the penalty parameter of error term. It controls the trade-off between smooth decision boundary and classifying the training points correctly. If the value of ‘C’ is small (e.g. 1), then decision boundary is smooth but some data points get misclassify. On the other hand, large vale of C (e.g. 1000) does classify all the data points correctly but the decision boundary is not smooth. Therefore, too large value of C can lead to over-fitting problem. Parameter ‘Gamma’ defines how far the influence of a single training example reaches. If the value of ‘Gamma’ is low (e.g. 0), then the far-off data points also play part in drawing the decision boundary. But if the value of ‘Gamma’ large then only closer to other classes play part in deciding decision boundary.


Support Vector Machine is actually a Binary Classifier which means that it can classify the data into two different classes. If it is required to do Multi-Class classification using SVM, then either of following techniques can be used.


    1. One-vs-Rest SVM (OVR)
    2. One-vs-Ove SVM (OVO)
    
    
In OVR, one classifier is trained per class. It means if there are N classes then N different classifiers will be trained. For example, if a classifier is trained for class ‘i’, then it will assume i-labels as positive and the rest as negative. In OVO approach, a separate classifier is trained for each different pair of labels. It leads to N(N-1)/2 classifiers which is computationally more expensive but provides better performance.


In this repository, Support Vector Machine is used for Multi-Class Classification. Prepossessing and training part has been done in Python3 in Jupyter Notebook. MNIST dataset from Scikit-learn database is loaded which contains 1797 images of hand-written images having a resolution of 8×8 pixels each. The dataset has been split into training and test datasets with a ratio of 80% to 20%. It means 1437 images are used for training whereas 360 images are used for test purpose. An SVM of type ‘One-vs-One’ has been used in this exercise. The function ‘RandomizedSearchCV’ finds the best possible combination of parameters and the trains SVM classifier. After training, trained parameters are saved in MS Excel files which are stored in the directory. Then SVM classifier’s built-in predict function by Scikit-learn is used to predict classes of test data points. It gives a test accuracy of 0.9889.


After that, MATLAB loads the MS Excel files stored by Python program. It uses provided formula to predict the classes of test data points. Again a test accuracy of 0.9889 obtains. Getting same accuracy using both methods proves the correct implementation of prediction part of SVM in MATLAB. 
