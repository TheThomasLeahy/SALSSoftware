        %% function- doOldAnalysis
        %
        %this is the method called to process old SALS data
        %called by doThings
        function doOldAnalysis(this,src)


            % from do analysis
            y=this.input_size(1,1); x=this.input_size(1,2);
            
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
            for lc=1:1:(TE)
%                this.pos(i,:)=this.origMat((1+((i-1)*767)):(2+((i-1)*767)));
%                this.rawInt(i,:)=this.origMat((3+((i-1)*767)):362+((i-1)*767));
%                this.majorAxisI(i,:)=this.origMat((363+((i-1)*767)):762+((i-1)*767));
%                this.centroid(i,:)=this.origMat((763+((i-1)*767)));
%                this.htens(i,:)=this.origMat((764+((i-1)*767)):767+((i-1)*767));

               this.pos(lc,:)=this.origMat((1+((lc-1)*362)):(2+((lc-1)*362)));
               this.rawInt(lc,:)=this.origMat((3+((lc-1)*362)):(362+((lc-1)*362)));
            end
            this.repRawInt=reshape(this.rawInt,x,y,360);
            %allocate memory for analyzed data
%             co=reshape(this.rawInt(x+1,:),[1,360]);
%             cr=reshape(this.repRawInt(1,2,:),[1,360]);
%             if co==cr
%                 check=1
%             else 
%                 check=0
%             end
            temp=zeros(y,x);
            mValue=zeros(y,x);
            minValue=zeros(y,x);
            avgValue=zeros(y,x);
            meanFunc=zeros(y,x);
            oFunc=zeros(y,x);
            means=zeros(y,x);
            meanp=zeros(y,x);
            vari=zeros(y,x);
            skew=zeros(y,x);
            kurtosis=zeros(y,x);
            eigenVecCoord=zeros(y,x);
            symCoeff=zeros(y,x);
            rCoeff=zeros(y,x);
            cDeg=zeros(y,x);
            peakLoc=zeros(y,x);
            threshFunc = zeros(y,x);
            htensFunc1 = zeros(y,x);
            htensFunc2 = zeros(y,x);
            htensFunc4 = zeros(y,x);
            reconstructed = zeros(y,x,180);

            count=0;
            i=1;
            j=1;
            for Ti=1:TE
                    this.pos(count+i,:);
                    [m,in]=max(this.rawInt(count+i,:));
                    temp(j,i)=in+90;
                    if temp(j,i)>360
                        temp(j,i)=temp(j,i)-360;
                    end
                    
                    mValue(j,i)=m;
                    peakLoc(j,i)=in;
                    minValue(j,i)=min(this.rawInt(count+i,:));
                    avgValue(j,i)=sum(this.rawInt(count+i,:));
%                     [o,c,d]=calcCentroid(this.htens(count+j,:),this);
                    [o,c,d,coord,recon,Htens]=calcCentroid(this.rawInt(count+i,:),this);

                    this.shiftInt(count+i,:)=splitDistCoord(this,this.rawInt(count+i,:),coord);
                    reconstructed(j,i,:)=splitDistCoord(this,recon,coord);
                    [mean,meanpos,sec,sk,kurt,symcoeff,coeff]=calcDist(this.shiftInt(count+i,:),this,reconstructed(j,i,:));
                    means(j,i)=mean;
                    meanp(j,i)=meanpos;
                    vari(j,i)=sec;
                    skew(j,i)=sk;
                    kurtosis(j,i)=kurt;
                    symCoeff(j,i)=symcoeff;
                    rCoeff(j,i)=coeff;
                    meanFunc(j,i)=c;
                    oFunc(j,i)=o;
                    cDeg(j,i)=d;
                    eigenVecCoord(j,i)=coord;
%                     htensFunc1(j,i) = this.htens(count+j,1);
%                     htensFunc2(j,i) = this.htens(count+j,2);
%                     htensFunc4(j,i) = this.htens(count+j,4);
                    htensFunc1(j,i) = Htens(1);
                    htensFunc2(j,i) = Htens(2);
                    htensFunc4(j,i) = Htens(4);
                
                if i>=x
                   i=1;
                   j=j+1;
                   count=count+x;
                else i=i+1;
                end
                
%                 if i>=x
%                    i=1; j=j+1; count=count+x;
%                 else i=i+1; end
                
            end
            
            this.repShiftInt=reshape(this.shiftInt,[x,y,360]);
            
%             % flip data of up-down-columns for k = 2:2:x
%                 avgValue(:,k)=flipud(avgValue(:,k));
%                 mValue(:,k)=flipud(mValue(:,k));
%                 minValue(:,k)=flipud(minValue(:,k));
%                 meanFunc(:,k)=flipud(meanFunc(:,k));
%                 oFunc(:,k)=flipud(oFunc(:,k)); temp(:,k) =
%                 flipud(temp(:,k)); means(:,k) = flipud(means(:,k));
%                 meanp(:,k) = flipud(meanp(:,k));
%                 vari(:,k)=flipud(vari(:,k)); skew(:,k) =
%                 flipud(skew(:,k)); kurtosis(:,k)=flipud(kurtosis(:,k));
%                 symCoeff(:,k)=flipud(symCoeff(:,k));
%                 rCoeff(:,k)=flipud(rCoeff(:,k));
%                 cDeg(:,k)=flipud(cDeg(:,k));
%                 eigenVecCoord(:,k)=flipud(eigenVecCoord(:,k));
%                 peakLoc(:,k)=flipud(peakLoc(:,k)); htensFunc1(:,k) =
%                 flipud(htensFunc1(:,k)); htensFunc2(:,k) =
%                 flipud(htensFunc2(:,k)); htensFunc4(:,k) =
%                 flipud(htensFunc4(:,k));
% %                 for t=1:180 %
% reconstructed(:,k,t)=flipud(reshape(reconstructed(:,k,t),y,1)); %
% end
%             end
%             
            % flip data of l-r rows
            for k = 2:2:y
                avgValue(k,:)=fliplr(avgValue(k,:));
                mValue(k,:)=fliplr(mValue(k,:));
                minValue(k,:)=fliplr(minValue(k,:));
                meanFunc(k,:)=fliplr(meanFunc(k,:));
                oFunc(k,:)=fliplr(oFunc(k,:));
                temp(k,:) = fliplr(temp(k,:));
                means(k,:) = fliplr(means(k,:));
                meanp(k,:) = fliplr(meanp(k,:));
                vari(k,:)=fliplr(vari(k,:));
                skew(k,:) = fliplr(skew(k,:));
                kurtosis(k,:)=fliplr(kurtosis(k,:));
                symCoeff(k,:)=fliplr(symCoeff(k,:));
                rCoeff(k,:)=fliplr(rCoeff(k,:));
                cDeg(k,:)=fliplr(cDeg(k,:));
                eigenVecCoord(k,:)=fliplr(eigenVecCoord(k,:));
                peakLoc(k,:)=fliplr(peakLoc(k,:));
                htensFunc1(k,:) = fliplr(htensFunc1(k,:));
                htensFunc2(k,:) = fliplr(htensFunc2(k,:));
                htensFunc4(k,:) = fliplr(htensFunc4(k,:));
                for t=1:180
                    reconstructed(k,:,t)=fliplr(reshape(reconstructed(k,:,t),[x,1]));
                end
            end
            count=0;
            
            % Set analyzed data to global variables
            this.forCent=temp;
            this.forMaxColor=mValue;
            this.forBLColor=minValue;
            this.forLnAvg=avgValue;
            this.centroidTheta=meanFunc;
            this.forCentDeg=meanFunc*(double(180.0/pi));
            this.oiData=oFunc;
            this.forDistSkew=skew;
            this.forDistMean=means;
            this.forDistMeanPos=meanp;
            this.forDistVariance=vari;
            this.forDistKurt=kurtosis;
            this.symmetryCoeff=symCoeff;
            this.correlationCoeff=rCoeff;
            this.forDegAng=cDeg;
            this.coordShift=eigenVecCoord;
            this.forPeaks=peakLoc;
            this.htens1 = htensFunc1;
            this.htens2 = htensFunc2;
            this.htens4 = htensFunc4;
            this.forRecon = reconstructed;
            
            % Perform preferred direction prep for vector display Set up
            % threshold values based on OI and Max Int
            maxmax=max(max(mValue));
            for c1 = 1:x
                for c2=1:y
                    if this.forCentDeg(c2,c1)<0
                            this.forCentDeg(c2,c1)=this.forCentDeg(c2,c1)+180;
                    end
                    if this.forCentDeg(c2,c1)>=90.0
                        this.forCentDeg(c2,c1)=this.forCentDeg(c2,c1)-180;
                    end
                    threshFunc(c2,c1)=((((mValue(c2,c1)/maxmax)*100))+((oFunc(c2,c1))*100))/2;
                end
            end
            
            % Global variables for vect, Thresh, and Histograms
            this.forThresh=threshFunc;
            this.OrThresh=threshFunc;
            this.forOIHist=oFunc;
            
            this.forMaxIntNorm=round((mValue/255)*100);
            this.forMaxIntHist=this.forMaxIntNorm;
            this.forCentHist=temp;
            this.colorMap=zeros(this.input_size(1),this.input_size(2),3);

            
            set(gcf, 'Pointer', 'arrow');
            drawnow;
            
            %move to initAxes or arrayWrite
            initAxes(this,src)
%             arrayWrite(this,src)

        end