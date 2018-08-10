load CFB2016_scores.csv
names=importdata('TeamNames.txt');
X=CFB2016_scores;
Mhat=zeros(760,760);
for i=1:length(X);
    if X(i,2)>X(i,4),
        Mhat(X(i,1),X(i,1))=Mhat(X(i,1),X(i,1))+1+X(i,2)/(X(i,2)+X(i,4));
        Mhat(X(i,3),X(i,1))=Mhat(X(i,3),X(i,1))+1+X(i,2)/(X(i,2)+X(i,4));
        Mhat(X(i,3),X(i,3))=Mhat(X(i,3),X(i,3))+X(i,4)/(X(i,2)+X(i,4));
        Mhat(X(i,1),X(i,3))=Mhat(X(i,1),X(i,3))+X(i,4)/(X(i,2)+X(i,4));
    else
        Mhat(X(i,3),X(i,3))=Mhat(X(i,3),X(i,3))+1+X(i,4)/(X(i,2)+X(i,4));
        Mhat(X(i,1),X(i,3))=Mhat(X(i,1),X(i,3))+1+X(i,4)/(X(i,2)+X(i,4));
        Mhat(X(i,1),X(i,1))=Mhat(X(i,1),X(i,1))+X(i,2)/(X(i,2)+X(i,4));
        Mhat(X(i,3),X(i,1))=Mhat(X(i,3),X(i,1))+X(i,2)/(X(i,2)+X(i,4));
    end
end

for i=1:760
      M(i,:)=Mhat(i,:)/sum(Mhat(i,:));
end

w0=zeros(1,760);
w0(1,:)=1/760;
t=[10 100 1000 10000];

for i=1:4,
    w(i,:)=w0*(M^t(i));
end

A=[1:25]';
%t=10
w10=w(1,:);
[val10, ind10]=sort(w10,'descend');
teams10=names(ind10(1:25));
ranking10=table(A,(val10(1:25))',teams10);
ranking10.Properties.VariableNames={'Rank' 'Score' 'Team'};
%t=100
w100=w(2,:);
[val100, ind100]=sort(w100,'descend');
teams100=names(ind100(1:25));
ranking100=table(A,(val100(1:25))',teams100);
ranking100.Properties.VariableNames={'Rank' 'Score' 'Team'};
%t=1000;
w1000=w(3,:);
[val1000, ind1000]=sort(w1000,'descend');
teams1000=names(ind1000(1:25));
ranking1000=table(A,(val1000(1:25))',teams1000);
ranking1000.Properties.VariableNames={'Rank' 'Score' 'Team'};
%t=10000;
w10000=w(4,:);
[val10000, ind10000]=sort(w10000,'descend');
teams10000=names(ind10000(1:25));
ranking10000=table(A,(val10000(1:25))',teams10000);
ranking10000.Properties.VariableNames={'Rank' 'Score' 'Team'};
