Movies=importdata('movies.txt');
load ratings.csv
load ratings_test.csv

n1=length(unique(ratings(:,1)));  % number of users
n2=length(Movies);  % number of movies on training set
M=zeros(n1,n2);
testno=size(ratings_test,1);
uind=ratings(:,1);
vind=ratings(:,2);
val=ratings(:,3);


d=10;
lamda=1;
var=0.25;

for z=1:10;
v=randn(n2,d);
u=randn(d, n1);
I=eye(d);

for t=1:100;
for i=1:n1;
    idx=find (ratings(:,1)==i);
    j=ratings(idx,2); % set of movies rated by user i
    mij=ratings(idx,3);
    vj=v(j,:);
    u(:,i)=inv(lamda*var*I+vj'*vj)*(vj'*mij);

end


for m=1:n2;
    idx2=find (ratings(:,2)==m);% users who rated movie i
    j2=ratings(idx2,1); % set of users rated movie i
    mij2=ratings(idx2,3); 
    ui=u(:,j2);
    v(m,:)=inv(lamda*var*I+ui*ui')*(ui*mij2);
end

M0=u'*v';

for a=1:95000;
    ratings_new(a,1)=M0(uind(a),vind(a));
end

L(t)=-1/(2*var)*sum((ratings(:,3)-ratings_new).^2)-lamda*sum(sum(u.^2))/2-lamda*sum(sum(v.^2,2))/2;

end

utest=ratings_test(:,1);
vtest=ratings_test(:,2);

for b=1:5000;
    ratings_p(b,1)=M0(utest(b),vtest(b));
end

RMSE(z,1)=sqrt(sum((ratings_test(:,3)-ratings_p).^2)/testno);

L_all(z,:)=L;
end


plot(2:100, L_all(:,2:100),'linewidth', 1.5);

xlabel('Iteration')
ylabel('Log Joint Likelihood')
legend('T=1','T=2','T=3','T=4','T=5','T=6','T=7','T=8','T=9','T=10')

tab=table(RMSE,L_all(:,100));
tab.Properties.VariableNames={'RMSE' 'L'};
tab = sortrows(tab,'L','descend');


%b)
Index1 =  strfind(Movies, 'Star Wars');
Index1 = find(not(cellfun('isempty', Index1))); %50
Index2 =  strfind(Movies, 'My Fair Lady');
Index2 = find(not(cellfun('isempty', Index2))); %485
Index3 =  strfind(Movies, 'GoodFellas');
Index3 = find(not(cellfun('isempty', Index3))); %182


for i=1:size(v,1);
    Dist1(i,1)=norm (v(Index1,:)-v(i,:));
end

[Var1,i1]=sort(Dist1,'ascend');
SW=table(Movies(i1(1:11)),Var1(1:11)); % 10 cloest for star wars
SW.Properties.VariableNames={'Ten_Closest_Movies_to_Star_Wars','Distance'};


for i=1:size(v,1);
    Dist2(i,1)=norm (v(Index2,:)-v(i,:));
end

[Var2,i2]=sort(Dist2,'ascend');
MFL=table(Movies(i2(1:11)),Var2(1:11)); 
MFL.Properties.VariableNames={'Ten_Closest_Movies_to_My_Fair_Laday','Distance'};

for i=1:size(v,1);
    Dist3(i,1)=norm (v(Index3,:)-v(i,:));
end

[Var3,i3]=sort(Dist3,'ascend');
GF=table(Movies(i3(1:11)),Var3(1:11)); 
GF.Properties.VariableNames={'Ten_Closest_Movies_to_GoodFellas','Distance'};
