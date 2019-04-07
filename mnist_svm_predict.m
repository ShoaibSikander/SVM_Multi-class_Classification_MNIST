clear all;
close all;
%% Load Files
alpha = xlsread('alpha.xlsx', 'alpha');
bias = xlsread('bias.xlsx', 'bias');
support_vectors = xlsread('xi.xlsx', 'xi');
no_SV = xlsread('no_SV.xlsx', 'no_SV');
labels_SV = xlsread('labels_SV.xlsx', 'labels_SV');
predictions_python = xlsread('predictions.xlsx', 'predictions');
test_data = xlsread('test_data.xlsx', 'test_data');
test_labels = xlsread('test_labels.xlsx', 'test_labels');
parameters = xlsread('parameters.xlsx');
gamma = parameters(2,1);

%% Reshape Vector
all_SV = cumsum(no_SV);
all_SV_new = [0; all_SV];

predictions_matlab = [];
for s=1:1:size(test_data,1)
    %% Load single Test Vector
    test_element = test_data(s,:);

    %% Calculate Norm, square, multiply with -gamma and take exponential
    norm_result = pdist2(support_vectors, test_element, 'euclidean');
    result_1 = exp(-1*gamma*power(norm_result, 2));

    %% Multiply with alpha
    sum=0;
    k=1;
    result_2 = zeros(size(alpha,1),size(no_SV,1));
    for i=1:1:size(alpha,1)
        for j=1:1:size(alpha,2)
            val = alpha(i,j)*result_1(j,1);
            sum = sum+val;
            found = ismember(j, all_SV);
%           disp('found');
            if found==1
                result_2(i,k) = sum;
                k=k+1;
                sum=0;
            end
        end
        k=1;
    end

    %% Load diagonals of matrix and store in a vector
    % Load upper diagonal of matrix and store in a vector
    val=0;
    data_1 = [];
    for i=1:1:size(alpha,1)
        for j=i:size(alpha,1)
            val = result_2(j,i);
            data_1 = [data_1; val];
        end
    end
    % Load lower diagonal of matrix and store in a vector
    val=0;
    data_2 = [];
    for i=1:size(alpha,1)+1
        for j=i+1:size(alpha,1)+1
            val = result_2(i,j);
            data_2 = [data_2; val];
        end
    end

    %% Add two vectors and then add bias values
    data = data_1 + data_2;
    result_match_sklearn = data + bias;

    %% Make matrix containing zeros in diagonal from final vector
    val=0;
    result_diagonal_matrix = zeros(10,10);
    r=1;
    for i=1:1:size(alpha,1)+1
        for j=i+1:1:size(alpha,1)+1
            val = result_match_sklearn(r,1);
            result_diagonal_matrix(i,j) = val; 
            result_diagonal_matrix(j,i) = val;
            r=r+1;
        end
    end

    %% Define Labels for n(n-1)/2 OVO classifiers
    % Define values for Positive Class
    val = 0;
    cls_1 = [];
    for i=0:1:size(alpha,1)
        for j=i+1:1:size(alpha,1)
            val = i;
            cls_1 = [cls_1; val];
        end
    end
    % Define values for Negative Class
    val=0;
    cls_2 = [];
    for i=1:1:size(alpha,1)
        for j=i:1:size(alpha,1)
            val=j;
            cls_2 = [cls_2; val];
        end
    end
    % Combine Positive and Negative Classes into one variable for decision making
    cls = cat(2, cls_1, cls_2);

    %% Decide either Positive or Negative Class
    val = 0;
    decide_class = [];
    for i=1:1:size(result_match_sklearn,1)
        val = result_match_sklearn(i,1);
        if val>0
            decide_class = [decide_class; cls(i,1)];
        else
            decide_class = [decide_class; cls(i,2)];
        end
    end

    %% Find the number of occurrences of each class
    val=0;
    quantity_classes = [];
    for i=0:1:9
        val = length(find(decide_class==i));
        quantity_classes = [quantity_classes; val];
    end

    %% Find the class which has maximum occurrence
    [max_class, max_index] = max(quantity_classes);

    %% Solve Indexing issue and push the predicted value in an array
    pred = max_index-1;
%   fprintf('Predicted Value : %d \n', pred);
    predictions_matlab = [predictions_matlab; pred];
end

%% Compute Accuracy
count_python = 0;
count_real = 0;
for i=1:1:size(predictions_python,1)
    pred_matlab  = predictions_matlab(i,1);
    pred_python = predictions_python(i,1);
    real_label = test_labels(i,1);
    if pred_matlab == pred_python
        count_python = count_python+1;
    end
    if pred_matlab == real_label
        count_real = count_real+1;
    end
end

accuracy_python = count_python/size(predictions_python,1)*100;
accuracy = count_real/size(test_labels,1)*100;

fprintf('Accuracy compared with Python Predictions: %d \n', accuracy_python);
fprintf('Accuracy : %d \n', accuracy);