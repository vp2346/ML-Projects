

function pred_y=IrisMatching(x_train,y_train,x_test,y_test,feature_type,distance_type,numb_features)

%%%% using all features
if feature_type=='all'
    x_train_new=x_train; 
    x_test_new=x_test;
end

%%%%%%using PCA
if feature_type=='pca'

    no_d = 323;
    coeff = pca(x_train); %get pca coefficient matrix 
    reduce_d = coeff(:,1:no_d); 
    x_train_new = x_train * reduce_d; %reduce x_train to 323 features
    x_test_new = x_test * reduce_d; %reduce x_test to 323 features
end

%%%%%using PCA+LDA
if feature_type=='lda'
    no_d = 323;
    coeff = pca(x_train);  
    reduce_d = coeff(:,1:no_d); 
    x_train_pca = x_train * reduce_d;
    x_test_pca = x_test * reduce_d; 
    
    W=LDA(x_train_pca,y_train,numb_features); %get weight matrix for LDA
    x_train_new=W'*x_train_pca'; %apply LDA on already reduced feature data. 
    x_train_new=x_train_new';
    x_test_new=W'*x_test_pca'; %transpose data so dimension will match
    x_test_new=x_test_new';
end
% 
[n1 m1] = size(x_train_new);
[n2 m2] = size(x_test_new);

[n m] = size(x_train); %n=324, m=1536;
ClassLabel = unique(y_train); %class names
l = length(ClassLabel); %number of classes
fi=zeros(l,m1);

%get mean vector fi for each class
for i=1:l
    idx_2 = find(y_train==i);
    group = x_train_new(idx_2,:);
    no_group = size(group,1);
    fi(i,:)=(mean(group));    
end

d=zeros(n2,l);
pred_y=zeros(n2,1);
%calculate the distance between each test data to mean vector and select the minimum distance
for i=1:n2
    for j=1:l
        
        if distance_type=='d1'
            %manhattan distance
            d(i,j) = sum(abs((x_test_new(i,:)-fi(j,:)))); 
        end

        if distance_type=='d2'
            %Euclidean distance
            d(i,j) = sum((x_test_new(i,:)-fi(j,:)).^2); 
        end

        if distance_type=='d3'
            %cosine similarity distance             
            d(i,j) = 1-(x_test_new(i,:)*fi(j,:)')/(norm(x_test_new(i,:))*norm(fi(j,:)));
        end

    [val, min_ind] = min(d(i,:));
    pred_y(i,:)=min_ind;
    end
end

    


function W=LDA(x_train,y_train, no_f);
    

    [n m] = size(x_train); %n=324, m=1536;
    Label = unique(y_train);
    k = length(Label);
    SW = zeros(m,m); 
    Mi = zeros(k,m);
    M = mean(x_train); %overall mean
    SB = zeros(m,m);
    SI = zeros(m,m);  

    for i=1:k;
    idx = find(y_train==i);
    group = x_train(idx,:);
    no_group = size(group,1);
    Mi(i,:)=(mean(group));

    %Sb = zeros(m,m);
    %between classes covariance
    Sb = no_group*((Mi(i,:)-M)'*(Mi(i,:)-M));
    SB=SB+Sb;

        %within class covariance
        for j=1:no_group
        %Si = zeros(m,m); 
            Si = (group(j,:)-Mi(i,:))'*(group(j,:)-Mi(i,:));
            SI = SI+Si;
        end

    SW=SW+SI;

    end

    [V, D]=eig(SB,SW);
    [uselessVariable, sort_idx]=sort(abs(diag(D)),'descend');
    D_1=D(sort_idx, sort_idx);
    V_1=V(:,sort_idx);
    %select number of features
    W=V_1(:,1:no_f);
end
end
