function newvec=holechecker(vec)

k = 1;
vecValues = [];
Indices = [0 find(vec==0) length(vec)+1];

for (i = 1:length(Indices) - 1)
    Temp = vec(Indices(i) + 1:Indices(i + 1) - 1);
    if (~isempty(Temp))
        vecValues{k} = Temp;
        k = k+1;
    end;
end

vecpart = [];

for i=1:length(vecValues)
    if length(vecValues{i})>2
        vecpart{i} = cent_diff_n(vecValues{i},1,5);    
    elseif length(vecValues{i})==2
        myvector=vecValues{i};
        vecpart{i} = [myvector(2)-myvector(1), myvector(2)-myvector(1)];
    else
        %vecpart{i} =[NaN];
        vecpart{i} =[0];
    end
end


k = 1;
m=1;
newvecValues = [];

for (i = 1:length(Indices) - 1)
    Temp = vec(Indices(i) + 1:Indices(i + 1) - 1);
    if(isempty(Temp))
    	%newvecValues{k}=NaN;
        newvecValues{k}=0;
        k=k+1;
    else
        %newvecValues{k}=[vecpart{m} NaN];
        newvecValues{k}=[vecpart{m} 0];
        k=k+1;
        m=m+1;
    end;
end
newvec_pre=cell2mat(newvecValues);
newvec=newvec_pre(1:length(newvec_pre)-1);

end
