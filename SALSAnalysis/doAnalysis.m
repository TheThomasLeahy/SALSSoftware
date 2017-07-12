%% Function- doAnalysis
%
%this is the method called to process new SALS data
%called by doThings
function doAnalysis(this,src)

    y=this.input_size(1,1);
    x=this.input_size(1,2);

    TE=y*x;

    %allocate memory for raw data
    this.pos=zeros(TE,2);
    this.rawInt=zeros(TE,360);
    this.shiftInt=zeros(TE,360);
    this.majorAxisI=zeros(TE,400);
    this.centroid=zeros(TE,1);
    this.htens=zeros(TE,4);
    this.forBWOut=zeros(y,x);

    %parse input data string
    for i=1:1:(TE)
        this.pos(i,:)=this.origMat((1+((i-1)*767)):(2+((i-1)*767)));
        this.rawInt(i,:)=this.origMat((3+((i-1)*767)):362+((i-1)*767));
        this.majorAxisI(i,:)=this.origMat((363+((i-1)*767)):762+((i-1)*767));
        this.centroid(i,:)=this.origMat((763+((i-1)*767)));
        this.htens(i,:)=this.origMat((764+((i-1)*767)):767+((i-1)*767));
    end

    %allocate memory for analyzed data
    temp=zeros(y,x);
    mValue=zeros(y,x);
    minValue=zeros(y,x);
    avgValue=zeros(y,x);
    this.meanData_ODF=zeros(y,x);
    this.meanData_ODD=zeros(y,x);
    this.oiData_ODD=zeros(y,x);
    this.oiData_ODF=zeros(y,x);
    this.skew_ODD=zeros(y,x);
    this.skew_ODF=zeros(y,x);
    this.kurtosis_ODD=zeros(y,x);
    this.kurtosis_ODF=zeros(y,x);
    this.forOIHist=zeros(y,x);
    means=zeros(y,x);
    meanp=zeros(y,x);
    vari=zeros(y,x);
    this.forDistSkew=zeros(y,x);
    kurtosis=zeros(y,x);
    eigenVecCoord=zeros(y,x);
    symCoeff=zeros(y,x);
    this.correlationCoeff=zeros(y,x);
    cDeg=zeros(y,x);
    peakLoc=zeros(y,x);
    threshFunc = zeros(y,x);
    this.htens1 = zeros(y,x);
    this.htens2 = zeros(y,x);
    this.htens4 = zeros(y,x);
    reconstructed = zeros(y,x,180);

    debug_array_1 = cell(y,x);
    debug_array_2 = cell(length(this.data_points));

    h = waitbar(0,'Old Analysis:');
    count=0;
    i=1;
    j=1;
    for Ti=1:TE
        waitbar(Ti/TE);
        
        %Find max intensity of the ODF
        [m,in]=max(this.rawInt(count+j,:));
        temp(j,i)=in+90; %Adjust by 90 for SALS phase shift - Don't do this again
        if temp(j,i)>360
            temp(j,i)=temp(j,i)-360;
        end
        mValue(j,i)=m;
        peakLoc(j,i)=in;
        minValue(j,i)=min(this.rawInt(count+j,:));
        avgValue(j,i)=sum(this.rawInt(count+j,:));

        %Calculate Centroid
        [o,c,d,coord,recon,Htens]=calcCentroid(this.rawInt(count+j,:),this);

        this.shiftInt(count+j,:)=splitDistCoord(this,this.rawInt(count+j,:),coord);
        reconstructed(j,i,:)=splitDistCoord(this,recon,coord);
        [mean,meanpos,sec,sk,kurt,symcoeff,coeff]=calcDist(this.shiftInt(count+j,:),this,reconstructed(j,i,:));
        means(j,i)=mean;
        meanp(j,i)=meanpos;
        vari(j,i)=sec;
        this.forDistSkew(j,i)=sk;
        kurtosis(j,i)=kurt;
        symCoeff(j,i)=symcoeff;
        this.correlationCoeff(j,i)=coeff;
        this.meanData_ODF(j,i)=c;
        this.oiData_ODF(j,i)=o;
        cDeg(j,i)=d;
        eigenVecCoord(j,i)=coord;
        this.htens1(j,i) = Htens(1);
        this.htens2(j,i) = Htens(2);
        this.htens4(j,i) = Htens(4);

        debug_array_1{j,i} = [sk c];
        
        if j>=y
            j=1;
            i=i+1;
            count=count+y;
        else j=j+1;
        end

    end
    
    % flip data of down-columns
    for k = 2:2:x
        
        avgValue(:,k)=flipud(avgValue(:,k));
        mValue(:,k)=flipud(mValue(:,k));
        minValue(:,k)=flipud(minValue(:,k));
        temp(:,k) = flipud(temp(:,k));
        means(:,k) = flipud(means(:,k));
        meanp(:,k) = flipud(meanp(:,k));
        vari(:,k)=flipud(vari(:,k));
        this.forDistSkew(:,k) = flipud(this.forDistSkew(:,k));
        kurtosis(:,k)=flipud(kurtosis(:,k));
        symCoeff(:,k)=flipud(symCoeff(:,k));
        this.correlationCoeff(:,k)=flipud(this.correlationCoeff(:,k));
        cDeg(:,k)=flipud(cDeg(:,k));
        eigenVecCoord(:,k)=flipud(eigenVecCoord(:,k));
        peakLoc(:,k)=flipud(peakLoc(:,k));
        this.htens1(:,k) = flipud(this.htens1(:,k));
        this.htens2(:,k) = flipud(this.htens2(:,k));
        this.htens4(:,k) = flipud(this.htens4(:,k));
        for t=1:180
            reconstructed(:,k,t)=flipud(reshape(reconstructed(:,k,t),y,1));
        end
       
    end
    
    close(h)
    h = waitbar(0,'New Analysis:');

    i=1;
    j=1;
    tic
    for n_index = 1:length(this.data_points)
        waitbar(n_index/length(this.data_points))

        fs_order = 14;
        %Normalize to generate ODF
        this.data_points(n_index) = this.data_points(n_index).Normalize;
        %Generate Fourier Series
        this.data_points(n_index) = this.data_points(n_index).GenerateFourier(fs_order);
        %Compute statistics for the ODF
        this.data_points(n_index) = this.data_points(n_index).ComputeStats;
        
        %Unused kurtosis and skew coefficients (for now)
        %kurtosis(j, i) = this.data_points(n_index).kurtosis;
        %this.forDistSkew(j, i) = this.data_points(n_index).skew;
        
        % write to data arrays used for plotting
        this.meanData_ODF(j, i) = this.data_points(n_index).mean_odf;
        this.meanData_ODD(j, i) = this.data_points(n_index).mean_odd;
        %this.oiData_ODF(j, i) = this.data_points(n_index).oi_odf/100;
        this.oiData_ODD(j, i) = this.data_points(n_index).oi_odd/100;
        this.skew_ODD(j, i) = this.data_points(n_index).skew_odd;
        this.skew_ODD(j, i) = this.data_points(n_index).skew_odf;
        this.kurtosis_ODD(j, i) = this.data_points(n_index).kurtosis_odd;
        this.kurtosis_ODF(j, i) = this.data_points(n_index).kurtosis_odf;
        this.correlationCoeff(j, i) = this.data_points(n_index).corr_coeff;
                
        
        if j>=y
            j=1;
            i=i+1;
        else
            j=j+1;
        end
    end
    close(h)

    this.dataMap('OI (ODF)') = this.oiData_ODF;
    this.dataMap('OI (ODD)') = this.oiData_ODD;
    this.dataMap('PrefD (ODF)') = this.meanData_ODF;
    this.dataMap('PrefD (ODD)') = this.meanData_ODD;
    this.dataMap('Skew (ODD)') = this.skew_ODD;
    this.dataMap('Skew (ODF)') = this.skew_ODF;
    this.dataMap('Kurtosis (ODD)') = this.kurtosis_ODD;
    this.dataMap('Kurtosis (ODF)') = this.kurtosis_ODF;
    
    this.dataMap('Max Intensity') = mValue;
    this.dataMap('Baseline') = mValue;
    this.dataMap('Correlation Coefficient') = this.correlationCoeff;
    
    this.forCent=temp;
    this.forMaxColor=mValue;
    this.forBLColor=minValue;
    this.forLnAvg=avgValue;
    this.forCentDeg=this.meanData_ODF*(double(180.0/pi));
    this.forDistMean=means;
    this.forDistMeanPos=meanp;
    this.forDistVariance=vari;
    this.forDistKurt=kurtosis;
    this.symmetryCoeff=symCoeff;
    this.forDegAng=cDeg;
    this.coordShift=eigenVecCoord;
    this.forPeaks=peakLoc;
    this.forRecon = reconstructed;

    % Perform preferred direction prep for vector display
    % Set up threshold values based on OI and Max Int
    maxmax=max(max(mValue));
    for i = 1:x
        for j=1:y
            if this.forCentDeg(j,i)<0
                this.forCentDeg(j,i)=this.forCentDeg(j,i)+180;
            end
            if this.forCentDeg(j,i)>=90.0
                this.forCentDeg(j,i)=this.forCentDeg(j,i)-180;
            end
            threshFunc(j,i)=((((mValue(j,i)/maxmax)*100))+((this.oiData_ODF(j,i))*100))/2;
        end
    end

    % Global variables for vect, Thresh, and Histograms
    this.forThresh=threshFunc;
    this.OrThresh=threshFunc;
    this.forMaxIntNorm=round((mValue/65520)*100);
    this.forMaxIntHist=this.forMaxIntNorm;
    this.forCentHist=temp;
    this.colorMap=zeros(this.input_size(1),this.input_size(2),3);


    set(gcf, 'Pointer', 'arrow');
    drawnow;

    initAxes(this,src)
end