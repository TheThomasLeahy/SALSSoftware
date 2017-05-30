%SALS Analyis Program
%Object Oriented Matlab Code w/ Guide Implemented GUI

% Create a class for SALSA. 
classdef SALSAnalysis <handle
    
    
    %create properties for the class
    properties (Access = public)
        %gui stuff?
        Figure
        Pop
         
        %file location stuff
        salsFile
        salsFilePath
        
        %output location stuff
        outputPath
        outputFile
        
        %original matrix and size
        origMat
        input_size
        
        %position, raw intensity, major axis intensity, structure tensor,
        %and centroid (PD)
        pos
        rawInt
        majorAxisI
        htens
        centroid
        
        %Shifted intensity
        shiftInt
        
        %new? do fourth order?
        new
        doFourth=0;
        
        %idk
        numDegrees
        radList
        
        %radian distance
        distRads=genRadsList(0,180);
        %NxN identity matrix
        KronDel=eye(2);
        
        %angle for PD
        centroidTheta
        
        %what is cent? also have max color, bl color, linear/natural log
        %avg, and oi color
        forCent
        forCentDeg
        forMaxColor
        forBLColor
        forLnAvg
        forOIColor
        
        %bw out, gray out options
        forBWOut
        forGrayOUT
        
        
        coordShift
        forDistMean
        forDistMeanPos
        forDistVariance
        forDistSkew
        forDistKurt
        symmetryCoeff
        correlationCoeff
        
        
        forDegAng
        forPeaks
        
        currentColor=1;
        quiverOn=1;
        forRedrawStats
        
        forThresh
        OrThresh
        forMaxIntNorm
        
        forOIHist
        forCentHist
        forMaxIntHist
        
        forIET
        ietMult=1;
        
        colorMap
        cDat
        Xdat
        Ydat
        XQuiv
        YQuiv
        img
        qq

        
        F
        V
        
        forOutputNodeNumber
        forOutX
        forOutY
        OUT
        
        transOUT
        fortransOutputNodeNumber
        fortransOutX
        fortransOutY
        totalnodes
        
        Mesh2D
        tE
        zN
        
        htens1
        htens2
        htens4 
        
        AxesFilled=false;
        popped=0;
        tval=0;
        
        popGraphYLim = [-100 (65520+1000)];
        popGraphOldYLim= [-1 256];
        
        ckey
        pkey
        lkey
        
        transFile
        transFilePath
        transsizes
        transbitmap
        tempBitmapTArray

        Tec
        
        Ival=1;
        forRecon;
        
        repRawInt;
        repShiftInt;
        
        distSaveRaw
        distSave1
        distSave2
        distSaveAvg
    end
    
    methods
        
        %get the 
        function this = SALSAnalysis
            
            %Create the objects on the figure
     
            this.Figure = guihandles(SALSAnalysis_GUI);
            
            set(this.Figure.mainFig,'Units','normalized','OuterPosition',[0,0,1,1]);
            
            set(this.Figure.mainFig,'closerequestfcn',@(src,event) Close_fcn(this,src,event));

            set(this.Figure.closeProgram, 'callback', @(src,event) Close_fcn(this,src,event));
            
            set(this.Figure.fileIn, 'callback', @(src, event) Open_File(this, src, event));
            
            set(this.Figure.colorControl, 'selectionchangefcn', @(src,event) chooseColor(this,src,event));
            
            set(this.Figure.threshold, 'callback',@(src,event) activeThresh(this,src,event));
            
            set(this.Figure.saveJpeg, 'callback', @(src, event) saveJpeg(this, src, event));
            
            set(this.Figure.saveTiff, 'callback', @(src, event) saveTiff(this, src, event));
            
            set(this.Figure.saveBitmap, 'callback', @(src, event) saveBitmap(this, src, event));
            
            set(this.Figure.deletePoints, 'callback', @(src,event) deletePoints(this, src, event));
            
            set(this.Figure.deletePointsWand, 'callback', @(src, event) deletePointsWand(this, src, event));
            
            set(this.Figure.insertPoints, 'callback', @(src, event) insertPoints(this, src, event));
            
            set(this.Figure.insertPointsWand, 'callback', @(src, event) insertPointsWand(this, src, event));
            
            set(this.Figure.editMaxScale, 'callback', @(src, event) reDraw(this, 2,'rescale'));
            
            set(this.Figure.editMinScale, 'callback', @(src, event) reDraw(this, 1,'rescale'));
            
            set(this.Figure.quiverButton, 'callback', @(src, event) reDraw(this, 0, 'quiverchange'));
            
            set(this.Figure.bwOutButton, 'callback', @(src, event) outputBW(this));
            
            set(this.Figure.outTrans, 'callback', @(src, event) transmuralOutput(this));
            
            set(this.Figure.OIinFile, 'callback', @(src, event) reDraw(this, 0, 'OIinFile'));
            
            set(this.Figure.baselineInFile, 'callback', @(src, event) reDraw(this, 1, 'baselineInFile'));
             
            set(this.Figure.maxiInFile, 'callback', @(src, event) reDraw(this, 0, 'maxiInFile'));
            
            set(this.Figure.prefdInFile, 'callback', @(src, event) reDraw(this, 0, 'prefdInFile'));
            
            set(this.Figure.skewInFile, 'callback', @(src, event) reDraw(this, 0, 'skewInFile'));
            
            set(this.Figure.kurtosisInFile, 'callback', @(src, event) reDraw(this, 0, 'kurtosisInFile'));
            
            set(this.Figure.coeffInFile, 'callback', @(src, event) reDraw(this, 0, 'coeffInFile'));
            
            set(this.Figure.tensorInFile, 'callback', @(src, event) reDraw(this, 0, 'tensorInFile'));
 
            set(this.Figure.tecUI, 'callback', @(src, event) tecplotUI(this, src, event));

%             fillAxes(this);
%             jFrame = get(this.Figure.mainFig,'JavaFrame');
%             jFrame.setMaximized(true);
%             this.Axis = axes('Parent',this.Figure,'Position',[.13 .15 .78 .75]);
%             this.fileopenButton=uicontrol('Parent',this.Figure,...
%                 'Style','pushbutton','Position',[.14 .16 .75 .8],...
%                 'String','Open SALS File');
% 
%             set(this.Figure.fileXY,'Data', this.input_size);

        end
    end
    
  
    methods (Access=private)
        %% Class deconstructor - handles the cleaning up of the class &
        %figure. Either the class or the figure can initiate the closing
        %condition, this function makes sure both are cleaned up
        function delete(this)
            %remove the closerequestfcn from the figure, this prevents an
            %infinite loop with the following delete command
            set(this.Figure.mainFig,  'closerequestfcn', '');
            %delete the figure
            delete(this.Figure.mainFig);
            %clear out the pointer to the figure - prevents memory leaks
            this.Figure = [];
        end
        
        %% function - Close_fcn
        %
        %this is the closerequestfcn of the figure. All it does here is
        %call the class delete function (presented above)
        function this = Close_fcn(this, src, event)        
            
            delete(this);
        end
        
%         function regClick(this,src,event)
%            F=get(gca,'CurrentPoint')
%         end
        
        %% Function- Open_File
        %
        %this is the text file loader of the application
        %can be called twice, but only after the first call is completed
        %opens the file, pulls the data, separates first line, and throws
        %to app properties origMat and input_size;
        function this = Open_File(this,src,event)
            this.AxesFilled=false;
            [this.salsFile, this.salsFilePath]=uigetfile('\*.txt','Pick a SALS Output File to Analyze');
            set(gcf, 'Pointer', 'watch')
            drawnow;            
            if isequal(this.salsFile,0)
                set(this.Figure.fileChosen,'String','No File Selected');
                set(gcf, 'Pointer', 'arrow')
                drawnow;    

            else       
                set(this.Figure.fileChosen,'String',strcat(this.salsFilePath,this.salsFile));
%                 disp('Initial File Open');
%                 tic
                fid=fopen(strcat(this.salsFilePath,this.salsFile),'r');
                st = fread(fid,'*char')';
                fclose(fid);
                N=1;
                this.input_size=sscanf(st,'%e',[2,N])';
%                 toc
    %             y=size(1,1);x=size(1,2);
                data=sscanf(st,'%f',inf)';
%                 set(this.Figure.fileXY,'Data',this.input_size);
                this.origMat=data(3:end);
%                 set(this.Figure.mainData,'Data',this.origMat(1:768));
                doThings(this,src);
                
                    button = questdlg('Would you like to select a Threshold Data File');
                    switch button
                        case 'Yes'
                            loadtrans(this, src, event)
                        case 'No'
                            set(this.Figure.OIinFile,'Value',1)
                            set(this.Figure.baselineInFile,'Value',1)
                            set(this.Figure.maxiInFile,'Value',1)
                            set(this.Figure.prefdInFile,'Value',1)
                            set(this.Figure.skewInFile,'Value',1)
                            set(this.Figure.kurtosisInFile,'Value',1)
                            set(this.Figure.coeffInFile,'Value',1)
                            set(this.Figure.tensorInFile,'Value',1)
                        case 'Cancel'
                    end 
            end
        end
        
        %% Function- doThings
        %
        %acts as a director for the rest of the analysis methods
        %decides which analysis type to do, old or new
        %decides to draw, etc..=
        function doThings(this,src)
%             disp('doThings Timer:');
%             tic

            this.numDegrees=360;
            rads=zeros(this.numDegrees);
            for i=0:this.numDegrees-1
                rads(i+1)=i*(pi/180);
            end
            this.radList=rads;
%             toc
            if (this.origMat(364)~= 0)
                this.new=1;
                doAnalysis(this,src);
            else
                this.new=0;
                doOldAnalysis(this,src);
            end

            
        end
        
        
        %% Function- calcCentroid
        %
        %this is the method called to compute intensity centroid for old
        %SALS Data
        %called by doOldAnalysis
        function [OI,outAng,degree,corr,reconstruct,htens] = calcCentroid(Itheta,this)
%             numele = this.numDegrees;
%             clear [Htens ang dist testh4 Htens listuniqueH B4 B2 ndist minDist maxDist are];
%             Itheta=Itheta-min(Itheta);
            doFour = 0;
            if isequal(doFour,0)
        % orig 2nd order code
                Htens=zeros(2);
                for c=2:1:this.numDegrees
                    Htens(1,1)=Htens(1,1)+(((Itheta(c)*cos(this.radList(c))^2)+(Itheta(c-1)*cos(this.radList(c-1))^2))*pi/360.0);
                    Htens(1,2)=Htens(1,2)+(((Itheta(c)*cos(this.radList(c))*sin(this.radList(c)))+(Itheta(c-1)*cos(this.radList(c-1))*sin(this.radList(c))))*pi/360.0);
                    Htens(2,2)=Htens(2,2)+(((Itheta(c)*sin(this.radList(c))^2)+(Itheta(c-1)*sin(this.radList(c-1))^2))*pi/360.0);
                end
                Htens(2,1)=Htens(1,2); 
                reconstruct=ones(1,180);
        %% 4th order code
            elseif isequal(doFour,1)
                dist=(Itheta(1:180)+Itheta(181:360))/2.0;
                [ndist,minDist,maxDist,are]=NormalizeDist(dist, this.distRads);
            
                [testh4,Htens,listuniqueH,B4,B2] = returnH(ndist , this.distRads, this.KronDel);
             
             

              
%              HERE'S WHERE THE NEGATIVE VALUES IN THE RECONSTRUCTED ODF
%              ARE INTRODUCED.... SEE 'CONSTRUCTPART2' AND 'CONSTRUCTPART3';
                part1 = 1.0/pi;
                part2=constructPart2(this.distRads,B2,this.KronDel);
                part3=constructPart3(this.distRads,B4,this.KronDel);
                nreconstruct=(part1+part2+part3);
                reconstruct=(nreconstruct*are);
                
                a=areaundercurve(ndist)
                b=areaundercurve(nreconstruct)

                
            end
            htens=[Htens(1,1) Htens(1,2) Htens(2,1) Htens(2,2)];
%             are 
%             minDist
%             

%             primeang=atan2(V(2,1),V(1,1));
%             crossang=atan2(V(1,2),V(2,2));
            
            [this.V,D]=eig(Htens);
%             primeang = atan2(this.V(2,1), this.V(1,1));
%             crossang = atan2(this.V(2,2), this.V(1,2));

%             if (ang < 0)
%                 ang=ang+pi;
%             elseif ang>=pi
%                 ang=ang-pi;
%             end

%%%% Problems here%%%
%             switchvec = 0;

            if  D(1,1) > D(2,2)                
%                 htens=[Htens(2,1) Htens(2,2) Htens(1,1) Htens(1,2)];
                %                Htens = (htens(1) htens(2); htens(3) htens(4));
%                 [this.V,D]=eig(Htens);  
                tempd=D(1,1);
                D(1,1)=D(2,2);
                D(2,2)=tempd;
                tempv1=this.V(1,1);
                this.V(1,1)=this.V(1,2);
                this.V(1,2)=tempv1;
                tempv2=this.V(2,1);
                this.V(2,1)=this.V(2,2);
                this.V(2,2)=tempv2;
%             switchvec = 1;
                
            end
               
            OI=1-(D(1,1)/D(2,2));
            if OI<=0
                OI=0.01;
                
            end
            
%             if switchvec
%             
%                 crossang = atan(this.V(2,1)/this.V(1,1));
%                 primeang = atan(this.V(2,2)/this.V(1,2));
%                 outAng=primeang;
%                 switchvec = 0;
%             end
            
            primeang = atan(this.V(2,1)/this.V(1,1));
            crossang = atan(this.V(2,2)/this.V(1,2));
            outAng=primeang

            ppp=double(primeang*(180.0/pi))+90.0;
            ccc=double(crossang*(180.0/pi))+90.0;

            
            clearvars greaterflag;
%             ppp=ppp+90.0;
%             ccc=ccc+90.0;
            
            if ppp < 0
                ppp=ppp+180;
            elseif ppp > 180
                ppp=ppp-180;
            end
            
            if ccc<0
                ccc=ccc+180;
            elseif ccc>180
                ccc=ccc-180;
            end
            degree=ppp;
            corr=round(ppp)-90;
%             h11=Htens(1,1);
%             h11=det(Htens/(sqrt(det(Htens))));
            


%                 OI=.5;outAng=.5;degree=30;,corr=5;
        end

        
       %%
%         function [OI,outAng,degree] = calcCentroid(htens,this)
% %             numele = this.numDegrees;
%             clear [Htens ang];
%             Htens= [htens(1) htens(2);
%                    htens(3) htens(4)];
%             [V,D]=eig(Htens);
% 
%             ang=atan2(V(1,1),V(2,1));
% %             if (ang < 0)
% %                 ang=ang+pi;
% %             elseif ang>=pi
% %                 ang=ang-pi;
% %             end
%             
%             outAng=ang;
%             ddd=double((ang+90)*(180.0/pi));
%             if ddd<0
%                 ddd=ddd+180;
%             elseif ddd> 180
%                 ddd=ddd-180;
%             end
%             degree=ddd;
%             OI=1-(D(1,1)/D(2,2));
% %             h11=Htens(1,1);
% %             h11=det(Htens/(sqrt(det(Htens))));
%         end
        %%
%         function [distshift,set1,set2]=splitDistCoord(dist,this,coord,s)
%             if coord<0
%                 distshift=circhift(dist,coord);
%             else
%                 distshift=circshift(dist,-coord);
%             end
%             set1=distshift(1:s/2);
%             set2=distshift((s/2)+1:s); 
%         end
        function distshift=splitDistCoord(this,dist,coord)
            if coord<0
                distshift=circshift(dist,[0 -coord]);
            else
                distshift=circshift(dist,[0 -coord]);
            end

        end

        %%
        function [mean,meanpos,variance,sk,kurt, symcoeff, coeff] = calcDist(Idist,this,recon)
%             Idist=Idist-min(Idist);

            %s is the size of the Intensity distribution
            s=size(Idist);
            %distmax is the max of the intensity distribution (up to 65520)
            distmax=max(Idist);
            %Idist is the normalized size of the intensity distribution
            %(min = 0, max = 1)
            Idist=Idist/distmax;
            %ihalf1 is the lower half of the vector (1-180)
            ihalf1=Idist(1:s(2)/2);
            %run normalize dist and outputs ihalf1 as the normalized
            %distribution, ha as the minD before normalization, haa as maxD
            %before normalization, and haaa as the area
            [ihalf1,ha,haa,haaa]=NormalizeDist(ihalf1,this.distRads);
%            ihalf1=ihalf1/distmax;
            ihalf2=Idist(((s(2)/2)+1):s(2));
            %run normalize dist and outputs ihalf1 as the normalized
            %distribution, ha as the minD before normalization, haa as maxD
            %before normalization, and haaa as the area
            [ihalf2,ha,haa,haaa]=NormalizeDist(ihalf2,this.distRads);
%            ihalf2=ihalf2/distmax;
            %average the intensity vectors between the first and second halves
            iavg=(ihalf1+ihalf2)/2.0;
            %normalize the avg now.
            [iavg,ha,haa,haaa]=NormalizeDist(iavg,this.distRads);
            %shalf is half the size of the original
            shalf=size(iavg);
            %d2r???? is the distance to the radius
            d2r=double(pi/180.0);
            %output recon as the reconstructed normalized distribution of
            %whatever was inputed as recon into the CalcDist fcn
            [recon,ha,haa,haaa]=NormalizeDist(recon,this.distRads);
            %declare/clear stats
            mean=0;meanpos=0;variance=0;sk=0;kurt=0;
            %declare/clear these values
            cent=0;a=0;fm=0;da=0; meanh1=0;meanh2=0;fm1=0;fm2=0;da1=0;a1=0;da2=0;a2=0;dare=0;fmre=0;are=0;
            %for each value of intensity from 1 to 180
            for i=1:1:shalf(2)
                %da is the avg intensity at each angle
                da=iavg(i);
                %fm is the sum of the avg intensity at each angle
                %multiplied by the angle
                fm=fm+(da*(i*1.0));
                %a is the sum of the avg angles
                a=a+da;
                %da1 is the intensity at the angle for peak 1
                da1=ihalf1(i);
                %da2 is the intensity at the angle for peak 2
                da2=ihalf2(i);
                %fm1 is the sum of the avg intensity at each angle
                %multiplied by the angle for peak 1
                fm1=fm1+(da1*(i*1.0));
                %fm2 is the sum of the avg intensity at each angle
                %multiplied by the angle for peak 2
                fm2=fm2+(da2*(i*1.0));
                %a1 is a steak sauce
                a1=a1+da1;
                %a2 is the sum of the avg anglesf for peak 2
                a2=a2+da2;
                %dare is the recon dist at the angle i
                dare=recon(i);
                %fmre is the sum of the avg recon at each angle multiplied
                %by the angle
                fmre=fmre+(dare*(i*1.0));
                %are is the sum of the avg angles for recon
                are=are+dare;
            end
            %mm is the sum of the avg angles for the entire intensity
            %distribution over 180 (normalized)
            mm=a/180.0;
            %cent is the (center/centroid?) found by taking the sum of the
            %avg intensity at each angle multiplied by the angle all over
            %the sum of the avg of the angles
            cent=fm/a;
            %mm1 is the sum of the avg angles for the first half of the
            %intensity distribution over 180 (normalized)
            mm1=(a1/180.0);
            %cent1 is same as cent but for first peak
            cent1=fm1/a1;
            %mm2 same as others but for second peak
            mm2=a2/180.0;
            %cent2 is same as cent but for second peak
            cent2=fm2/a2;
            %mmre same as mm but for reconstruction
            mmre=(are/180.0);
            %centre same as cent but for reconstruction
            centre=(fmre/are);
            
            %set these all to 0 (declare)
            ms1=0;ms2=0;ms3=0;ms4=0;mtemp=0;r=0;rt=0;rbx=0;rby=0;ret=0;rebx=0;reby=0;
            
            %from j=1 to 180
            for j=1:1:shalf(2)
                
                %mtemp is the average intensity at each angle minus the
                %normalized area?
                mtemp=(iavg(j)-mm);
                %ms1 is the sum of mtemp
                ms1=ms1+(mtemp);
                
                %mtemp^2
                mtemp=mtemp*(iavg(j)-mm);
                %sum of mtemp^2
                ms2=ms2+(mtemp);
                
                %mtemp^3
                mtemp=mtemp*(iavg(j)-mm);
                %sum of mtemp^3
                ms3=ms3+(mtemp);
                
                %mtemp^4
                mtemp=mtemp*(iavg(j)-mm);
                %sum of mtemp^4
                ms4=ms4+(mtemp);
                
                %rt is the sum of (ihalf1-mm)*(ihalf2(j)-mm2)
                rt=rt+((ihalf1(j)-mm1)*(ihalf2(j)-mm2));
                %sum of (ihalf1(j)-mm1)^2 (uses mm1)
                rbx=rbx+((ihalf1(j)-mm1)^2);
                %same as mtemp^2 but uses mm2
                rby=rby+((ihalf2(j)-mm2)^2);
                
                %sum of mtemp*recontemp
                ret=ret+((iavg(j)-mm)*(recon(j)-mmre));
                %sum of mtemp^2
                rebx=rebx+((iavg(j)-mm)^2);
                %sum of recontemp^2
                reby=reby+((recon(j)-mmre)^2);
            end
            
            r=rt/(sqrt(rbx)*sqrt(rby));
            rre=ret/(sqrt(rebx)*sqrt(reby));
    
            ms1=ms1/(180.0);
            ms2=ms2/(180.0);
            ms3=ms3/(180.0);
            ms4=ms4/(180.0);
            
            sk=ms3/(sqrt(ms2*ms2*ms2));
            kurt=(ms4/(ms2*ms2))-3;
            meanpos=cent;
            symcoeff=r;
            coeff=rre;

            
        end
        
        %% Function- doAnalysis
        %
        %this is the method called to process new SALS data
        %called by doThings
        function doAnalysis(this,src)
            
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
            testFunc=zeros(y,x);
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
                    [m,in]=max(this.rawInt(count+j,:));
                    temp(j,i)=in+90;
                    if temp(j,i)>360
                        temp(j,i)=temp(j,i)-360;
                    end
                    
                    mValue(j,i)=m;
                    peakLoc(j,i)=in;
                    minValue(j,i)=min(this.rawInt(count+j,:));
                    avgValue(j,i)=sum(this.rawInt(count+j,:));
%                     [o,c,d]=calcCentroid(this.htens(count+j,:),this);
                    [o,c,d,coord,recon,Htens]=calcCentroid(this.rawInt(count+j,:),this);

                    this.shiftInt(count+j,:)=splitDistCoord(this,this.rawInt(count+j,:),coord);
                    reconstructed(j,i,:)=splitDistCoord(this,recon,coord);
                    [mean,meanpos,sec,sk,kurt,symcoeff,coeff]=calcDist(this.shiftInt(count+j,:),this,reconstructed(j,i,:));
                    means(j,i)=mean;
                    meanp(j,i)=meanpos;
                    vari(j,i)=sec;
                    skew(j,i)=sk;
                    kurtosis(j,i)=kurt;
                    symCoeff(j,i)=symcoeff;
                    rCoeff(j,i)=coeff;
                    testFunc(j,i)=c;
                    oFunc(j,i)=o;
                    cDeg(j,i)=d;
                    eigenVecCoord(j,i)=coord;
%                     htensFunc1(j,i) = this.htens(count+j,1);
%                     htensFunc2(j,i) = this.htens(count+j,2);
%                     htensFunc4(j,i) = this.htens(count+j,4);
                    htensFunc1(j,i) = Htens(1);
                    htensFunc2(j,i) = Htens(2);
                    htensFunc4(j,i) = Htens(4);
                
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
                testFunc(:,k)=flipud(testFunc(:,k));
                oFunc(:,k)=flipud(oFunc(:,k));
                temp(:,k) = flipud(temp(:,k));
                means(:,k) = flipud(means(:,k));
                meanp(:,k) = flipud(meanp(:,k));
                vari(:,k)=flipud(vari(:,k));
                skew(:,k) = flipud(skew(:,k));
                kurtosis(:,k)=flipud(kurtosis(:,k));
                symCoeff(:,k)=flipud(symCoeff(:,k));
                rCoeff(:,k)=flipud(rCoeff(:,k));
                cDeg(:,k)=flipud(cDeg(:,k));
                eigenVecCoord(:,k)=flipud(eigenVecCoord(:,k));
                peakLoc(:,k)=flipud(peakLoc(:,k));
                htensFunc1(:,k) = flipud(htensFunc1(:,k));
                htensFunc2(:,k) = flipud(htensFunc2(:,k));
                htensFunc4(:,k) = flipud(htensFunc4(:,k));
                for t=1:180
                    reconstructed(:,k,t)=flipud(reshape(reconstructed(:,k,t),y,1));
                end
            end
            count=0;
            
            % Set analyzed data to global variables
            this.forCent=temp;
            this.forMaxColor=mValue;
            this.forBLColor=minValue;
            this.forLnAvg=avgValue;
            this.centroidTheta=testFunc;
            this.forCentDeg=testFunc*(double(180.0/pi));
            this.forOIColor=oFunc;
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
                    threshFunc(j,i)=((((mValue(j,i)/maxmax)*100))+((oFunc(j,i))*100))/2;
                end
            end
            
            % Global variables for vect, Thresh, and Histograms
            this.forThresh=threshFunc;
            this.OrThresh=threshFunc;
            this.forOIHist=oFunc;
            this.forMaxIntNorm=round((mValue/65520)*100);
            this.forMaxIntHist=this.forMaxIntNorm;
            this.forCentHist=temp;
            this.colorMap=zeros(this.input_size(1),this.input_size(2),3);

            
            set(gcf, 'Pointer', 'arrow');
            drawnow;
            
            %move to initAxes or arrayWrite
            initAxes(this,src)
%             arrayWrite(this,src)
            

            
        end
        
        %% function- test array writing to temp file
        function arrayWrite(this,src)
            fID=fopen('tempArray.txt' , 'w');
            fprintf(fID,'%d %d\n',this.input_size);
            fprintf(fID,'%f\n',round((this.forOIColor*100)));
            fclose(fID);
            initAxes(this,src);
        end
        
        
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
            testFunc=zeros(y,x);
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
                    testFunc(j,i)=c;
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
%                 testFunc(:,k)=flipud(testFunc(:,k));
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
                testFunc(k,:)=fliplr(testFunc(k,:));
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
            this.centroidTheta=testFunc;
            this.forCentDeg=testFunc*(double(180.0/pi));
            this.forOIColor=oFunc;
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
        
        %% function- doOldAnalysis
        %
        %this is the method called to process old SALS data
        %called by doThings
%         function doOldAnalysis(this,src)
% 
% 
%             % from do analysis
%             y=this.input_size(1,1); x=this.input_size(1,2);
%             
%             TE=y*x;
%             
%             %allocate memory for raw data
%             this.pos=zeros(TE,2);
%             this.rawInt=zeros(TE,360);
%             this.shiftInt=zeros(TE,360);
%             this.majorAxisI=zeros(TE,400);
%             this.centroid=zeros(TE,1);
%             this.htens=zeros(TE,4);
%             this.forBWOut=zeros(y,x);
%             
%             %parse input data string
%             for lc=1:1:(TE)
% %                this.pos(i,:)=this.origMat((1+((i-1)*767)):(2+((i-1)*767)));
% %                this.rawInt(i,:)=this.origMat((3+((i-1)*767)):362+((i-1)*767));
% %                this.majorAxisI(i,:)=this.origMat((363+((i-1)*767)):762+((i-1)*767));
% %                this.centroid(i,:)=this.origMat((763+((i-1)*767)));
% %                this.htens(i,:)=this.origMat((764+((i-1)*767)):767+((i-1)*767));
% 
%                this.pos(lc,:)=this.origMat((1+((lc-1)*362)):(2+((lc-1)*362)));
%                this.rawInt(lc,:)=this.origMat((3+((lc-1)*362)):(362+((lc-1)*362)));
%             end
%             this.repRawInt=reshape(this.rawInt,[y,x,360]);
%             %allocate memory for analyzed data
%             temp=zeros(y,x);
%             mValue=zeros(y,x);
%             minValue=zeros(y,x);
%             avgValue=zeros(y,x);
%             testFunc=zeros(y,x);
%             oFunc=zeros(y,x);
%             means=zeros(y,x);
%             meanp=zeros(y,x);
%             vari=zeros(y,x);
%             skew=zeros(y,x);
%             kurtosis=zeros(y,x);
%             eigenVecCoord=zeros(y,x);
%             symCoeff=zeros(y,x);
%             rCoeff=zeros(y,x);
%             cDeg=zeros(y,x);
%             peakLoc=zeros(y,x);
%             threshFunc = zeros(y,x);
%             htensFunc1 = zeros(y,x);
%             htensFunc2 = zeros(y,x);
%             htensFunc4 = zeros(y,x);
%             reconstructed = zeros(y,x,180);
% 
%             count=0;
%             i=1;
%             j=1;
%             for i=1:x
%                 for j=1:y
% %                     this.pos(count+i,:);
%                     [m,in]=max(squeeze(this.repRawInt(j,i,:)));
%                     temp(j,i)=in+90;
%                     if temp(j,i)>360
%                         temp(j,i)=temp(j,i)-360;
%                     end
%                     
%                     mValue(j,i)=m;
%                     peakLoc(j,i)=in;
%                     minValue(j,i)=min(squeeze(this.repRawInt(j,i,:)));
%                     avgValue(j,i)=sum(squeeze(this.repRawInt(j,i,:)));
% %                     [o,c,d]=calcCentroid(this.htens(count+j,:),this);
%                     [o,c,d,coord,recon,Htens]=calcCentroid(squeeze(this.repRawInt(j,i,:)),this);
% 
%                     this.repShiftInt(j,i,:)=splitDistCoord(this,squeeze(this.repRawInt(j,i,:)),coord);
%                     reconstructed(j,i,:)=splitDistCoord(this,recon,coord);
%                     [mean,meanpos,sec,sk,kurt,symcoeff,coeff]=calcDist(reshape(this.repShiftInt(j,i,:),[1,360]),this,reconstructed(j,i,:));
%                     means(j,i)=mean;
%                     meanp(j,i)=meanpos;
%                     vari(j,i)=sec;
%                     skew(j,i)=sk;
%                     kurtosis(j,i)=kurt;
%                     symCoeff(j,i)=symcoeff;
%                     rCoeff(j,i)=coeff;
%                     testFunc(j,i)=c;
%                     oFunc(j,i)=o;
%                     cDeg(j,i)=d;
%                     eigenVecCoord(j,i)=coord;
% %                     htensFunc1(j,i) = this.htens(count+j,1);
% %                     htensFunc2(j,i) = this.htens(count+j,2);
% %                     htensFunc4(j,i) = this.htens(count+j,4);
%                     htensFunc1(j,i) = Htens(1);
%                     htensFunc2(j,i) = Htens(2);
%                     htensFunc4(j,i) = Htens(4);
%                 
%                 if i>=x
%                    i=1;
%                    j=j+1;
%                    count=count+x;
%                 else i=i+1;
%                 end
%                 
% %                 if i>=x
% %                    i=1; j=j+1; count=count+x;
% %                 else i=i+1; end
%                 
%                 end
%             end
%             
% %             this.repShiftInt=reshape(this.shiftInt,[y,x,360]);
%             
%             % flip data of up-down-columns 
% %             for k = 2:2:x
% %                 avgValue(:,k)=flipud(avgValue(:,k));
% %                 mValue(:,k)=flipud(mValue(:,k));
% %                 minValue(:,k)=flipud(minValue(:,k));
% %                 testFunc(:,k)=flipud(testFunc(:,k));
% %                 oFunc(:,k)=flipud(oFunc(:,k)); 
% %                 temp(:,k) =flipud(temp(:,k)); 
% %                 means(:,k) = flipud(means(:,k));
% %                 meanp(:,k) = flipud(meanp(:,k));
% %                 vari(:,k)=flipud(vari(:,k)); 
% %                 skew(:,k) =flipud(skew(:,k)); kurtosis(:,k)=flipud(kurtosis(:,k));
% %                 symCoeff(:,k)=flipud(symCoeff(:,k));
% %                 rCoeff(:,k)=flipud(rCoeff(:,k));
% %                 cDeg(:,k)=flipud(cDeg(:,k));
% %                 eigenVecCoord(:,k)=flipud(eigenVecCoord(:,k));
% %                 peakLoc(:,k)=flipud(peakLoc(:,k)); 
% %                 htensFunc1(:,k) =flipud(htensFunc1(:,k)); 
% %                 htensFunc2(:,k) = flipud(htensFunc2(:,k));
% %                 htensFunc4(:,k) =flipud(htensFunc4(:,k));
% %                 for t=1:180 %
% %                     reconstructed(:,k,t)=flipud(reshape(reconstructed(:,k,t),y,1)); %
% %                 end
% %             end
%             
% %             
%             % flip data of l-r rows
%             for k = 2:2:y
%                 avgValue(k,:)=fliplr(avgValue(k,:));
%                 mValue(k,:)=fliplr(mValue(k,:));
%                 minValue(k,:)=fliplr(minValue(k,:));
%                 testFunc(k,:)=fliplr(testFunc(k,:));
%                 oFunc(k,:)=fliplr(oFunc(k,:));
%                 temp(k,:) = fliplr(temp(k,:));
%                 means(k,:) = fliplr(means(k,:));
%                 meanp(k,:) = fliplr(meanp(k,:));
%                 vari(k,:)=fliplr(vari(k,:));
%                 skew(k,:) = fliplr(skew(k,:));
%                 kurtosis(k,:)=fliplr(kurtosis(k,:));
%                 symCoeff(k,:)=fliplr(symCoeff(k,:));
%                 rCoeff(k,:)=fliplr(rCoeff(k,:));
%                 cDeg(k,:)=fliplr(cDeg(k,:));
%                 eigenVecCoord(k,:)=fliplr(eigenVecCoord(k,:));
%                 peakLoc(k,:)=fliplr(peakLoc(k,:));
%                 htensFunc1(k,:) = fliplr(htensFunc1(k,:));
%                 htensFunc2(k,:) = fliplr(htensFunc2(k,:));
%                 htensFunc4(k,:) = fliplr(htensFunc4(k,:));
%                 for t=1:180
%                     reconstructed(k,:,t)=fliplr(reshape(reconstructed(k,:,t),[x,1]));
%                 end
%             end
%             count=0;
%             
%             % Set analyzed data to global variables
%             this.forCent=temp;
%             this.forMaxColor=mValue;
%             this.forBLColor=minValue;
%             this.forLnAvg=avgValue;
%             this.centroidTheta=testFunc;
%             this.forCentDeg=testFunc*(double(180.0/pi));
%             this.forOIColor=oFunc;
%             this.forDistSkew=skew;
%             this.forDistMean=means;
%             this.forDistMeanPos=meanp;
%             this.forDistVariance=vari;
%             this.forDistKurt=kurtosis;
%             this.symmetryCoeff=symCoeff;
%             this.correlationCoeff=rCoeff;
%             this.forDegAng=cDeg;
%             this.coordShift=eigenVecCoord;
%             this.forPeaks=peakLoc;
%             this.htens1 = htensFunc1;
%             this.htens2 = htensFunc2;
%             this.htens4 = htensFunc4;
%             this.forRecon = reconstructed;
%             
%             % Perform preferred direction prep for vector display Set up
%             % threshold values based on OI and Max Int
%             maxmax=max(max(mValue));
%             for c1 = 1:x
%                 for c2=1:y
%                     if this.forCentDeg(c2,c1)<0
%                             this.forCentDeg(c2,c1)=this.forCentDeg(c2,c1)+180;
%                     end
%                     if this.forCentDeg(c2,c1)>=90.0
%                         this.forCentDeg(c2,c1)=this.forCentDeg(c2,c1)-180;
%                     end
%                     threshFunc(c2,c1)=((((mValue(c2,c1)/maxmax)*100))+((oFunc(c2,c1))*100))/2;
%                 end
%             end
%             
%             % Global variables for vect, Thresh, and Histograms
%             this.forThresh=threshFunc;
%             this.OrThresh=threshFunc;
%             this.forOIHist=oFunc;
%             
%             this.forMaxIntNorm=round((mValue/255)*100);
%             this.forMaxIntHist=this.forMaxIntNorm;
%             this.forCentHist=temp;
%             this.colorMap=zeros(this.input_size(1),this.input_size(2),3);
% 
%             
%             set(gcf, 'Pointer', 'arrow');
%             drawnow;
%             
%             %move to initAxes or arrayWrite
%             initAxes(this,src)
% %             arrayWrite(this,src)
% 
%         end
        
        %% function - Initialize Axes
        function initAxes(this,src)
%             hold on
            set(this.Figure.mainAxes,'Visible', 'on');
            colorbar;
%             drawnow;
%             set(this.Figure.mainAxes,'OuterPosition',[0,0,1,1]);

            if this.input_size(1,1)>this.input_size(1,2)
                set(this.Figure.mainAxes,'Position',[0.12,0.05,0.75,0.9]);
            else
                set(this.Figure.mainAxes,'Position',[0.03,0.1,0.9,.75]);
            end
            
            axes(this.Figure.mainAxes);
            set(this.Figure.mainAxes,'XLim',[1 (this.input_size(2))]);
            set(this.Figure.mainAxes,'YLim',[1 (this.input_size(1))]);
%             hold off
            
%            set(this.Figure.OrientationIndex,'Value',1);
            set(this.Figure.editMaxScale,'String','100');
            set(this.Figure.editMinScale,'String','0');
            if this.new==1
                this.forRedrawStats=[0.0, 100.0; 0.0, 32000.0; 0, 65535.0; -90.0, 90.0; -1.0,1.0; -10, 10; 0, 1; 0, 1]; %min(min(this.correlationCoeff)), max(max(this.correlationCoeff))];
            else
                this.forRedrawStats=[0.0, 100.0; 0.0, 255.0; 0, 255.0; -90.0, 90.0; -1.0,1.0; -10, 10;  0, 1; 0, 1];%min(min(this.correlationCoeff)), max(max(this.correlationCoeff))];
            end
%             this.AxesFilled=true;
%             disp('fillAxes Timer:');
%             tic

            xorig = (1:1:this.input_size(1,2));
            xorig= repmat(xorig,this.input_size(1,1),1);
            this.Xdat= xorig;
            yorig = 1:1:this.input_size(1,1);
            yorig=reshape(yorig,this.input_size(1,1),1);
            yorig = repmat(yorig,1,this.input_size(1,2));
            this.Ydat=yorig;
%             [xx,yy] = meshgrid(x,y);
%             zz = peaks(xx,yy);

            set(this.Figure.mainAxes,'XLim',[1 (this.input_size(1,2))]);
            set(this.Figure.mainAxes,'YLim',[1 (this.input_size(1,1))]);
%             hold off;
%             size(xorig)
%             size(yorig)
%             size(this.forMaxColor)
%             size(this.forBLColor)

%             px=1; py=1;
            this.XQuiv=zeros(this.input_size(1,1),this.input_size(1,2)); this.YQuiv=zeros(this.input_size(1,1),this.input_size(1,2));
%             px(:,:)=1;py(:,:)=1; 
            fillAxes(this,1,0,1,1,0,0);
        end
            

        %% function - Do Smoothing
        function mat= processSomeData(this)
            tempy=this.input_size(1,1);
            tempx=this.input_size(1,2);
            multy=tempy*this.ietMult;
            multx=tempx*this.ietMult;
            outi=zeros(multy,multx);
            countx=0;
            county=0;
            cx=1;
            cy=1;
            for i=1:this.ietMult:multy
                cx=1;
                for j=1:this.ietMult:multx
                    countx=0;
                    county=0;
                    val = this.forOIColor(cy,cx);
                    outi(i,j)=val;
                    while county<this.ietMult
                        countx=0;
                        while countx<this.ietMult
                            outi(i+county,j)=val;
                            outi(i+county, j+countx) = val;
                            outi(i,j+countx)=val;
                            countx=countx+1;
                        end
                        county=county+1;
                    end
                    cx=cx+1;
                end
                cy=cy+1;
            end
            
            reoverMat=outi;
            for i=4:1:multy-3
                for j=4:1:multx-3
                    reoverMat(i,j)=localAv(this,outi,i,j);
                end
            end
            mat=reoverMat;
        end
        
        function pointAv= localAv(this,inputMat,y,x)
            
            runningSum=0;
            count=0;
            for i=y-3:1:y+3
                count=count+1;
                for j=x-3:1:x+3
                    count=count+1;
                     runningSum=inputMat(i,j)+runningSum;
                end
            end
            pointAv=runningSum/count;
        end
        
        
        %%
        function getMPos(gca, this)
           this.F=get(gca,'CurrentPoint'); 
%            set(this.Figure.mouseposr,'Data',this.F);
           this.V=round([this.F(1,1) this.F(1,2)]);
%            set(this.Figure.mouseposp,'Data',this.V);
           this.popped=1;
           this.Pop=guihandles(SALSA_POP);
           set(this.Pop.FigPop,'Name',mat2str(this.V));
           set(this.Pop.closePop,'callback', @(src,event) closePop(this,src,event));
           set(this.Pop.dataDisplay,'selectionchangefcn', @(src,event) chooseIData(this,src,event));
           set(this.Pop.pdHist,'callback', @(src,event) dispOrientationHist(this,src,event));
           set(this.Pop.baselineToggle,'callback', @(src,event) drawIData(this,this.Ival));
           set(this.Pop.maxiToggle,'callback', @(src,event) drawIData(this,this.Ival));
           set(this.Pop.reconToggle,'callback', @(src,event) drawIData(this,this.Ival));
           set(this.Pop.savePop,'callback',@(src,event) saveIData(this));
           drawIData(this,1);
        end
          %% 
        function drawIData(this,Ival)
           cla(this.Pop.iTheta,'reset');
           p=1;
           if this.new==1
               if mod(this.V(1),2)==0
                   p=((this.input_size(1)-(this.V(2)-1))+this.input_size(1)*(this.V(1)-1));
               else
                   p=(this.V(2)+this.input_size(1)*(this.V(1)-1));
               end
               ITheta=this.rawInt(p,:);
               IThetaShift=this.shiftInt(p,:);
           
               IBeta=this.majorAxisI(p,:);
           else
               if mod(this.V(2),2)==0
                   ITheta=reshape(this.repRawInt(this.input_size(2) - (this.V(1)-1),this.V(2),:),[1,360]);
                   IThetaShift=reshape(this.repShiftInt(this.input_size(2) - (this.V(1)-1),this.V(2),:),[1,360]);
               else
                   ITheta=reshape(this.repRawInt((this.V(1)),this.V(2),:),[1,360]);
                   IThetaShift=reshape(this.repShiftInt(this.V(1),this.V(2),:),[1,360]);
               end
               IBeta=this.majorAxisI(1,:);
           end

           
           cShift=this.coordShift(this.V(2),this.V(1));
           cS180=cShift+180;
           
           cross1=cShift;
           cross2=cS180;
           
           if cross1<0
               cross1=cross1+360;
           elseif cross1>360
               cross1=cross1-360;
           end
           if cross2<0
               cross2=cross2+360;
           elseif cross2>360
               cross2=cross2-360;
           end
               
           this.distSaveRaw=ITheta;
           this.distSave1=IThetaShift(1:180);
           this.distSave2=IThetaShift(181:360);
           this.distSaveAvg=(this.distSave1+this.distSave2)/2.0;
           
           centDist=this.forDegAng(this.V(2),this.V(1));
           
           set(this.Pop.scoeff,'String',num2str(this.symmetryCoeff(this.V(2),this.V(1))));
           set(this.Pop.ccoeff,'String',num2str(this.correlationCoeff(this.V(2),this.V(1))));
           
           if this.new==1
               set(this.Pop.iTheta,'YLim',this.popGraphYLim);
           else
               set(this.Pop.iTheta,'YLim',this.popGraphOldYLim);
           end
%            set(this.Figure.calcPoint,'Data',p);    
%            set(this.Figure.blTable,'Data',jkl);
           if Ival==1
               set(this.Pop.iTheta,'XLim',[0 360]);
               drawthis1=ITheta;
%                drawthis2=ITheta-min(ITheta);
               
               hold on;
               axis(this.Pop.iTheta);
               plot(this.Pop.iTheta,drawthis1,'black','LineWidth',2);
               

               if this.new==1
                y1=(1:1000:65520);
                y2=(1:1000:65520);
               else
                y1=(1:5:255);
                y2=(1:5:255);
               end
               x1=repmat(cross1,1,length(y1));
               plot(this.Pop.iTheta,x1,y1,'Color','b','LineStyle','none','Marker','s','LineWidth',2,'MarkerFaceColor','b','MarkerSize',2);

               x2=repmat(cross2,1,length(y2));
               plot(this.Pop.iTheta,x2,y2,'Color','g','LineStyle','none','Marker','s','LineWidth',2,'MarkerFaceColor','b','MarkerSize',2);
               legen=legend(this.Pop.iTheta,'Intensity Data','Centroid 1','Centroid 2');
               set(legen,'FontSize',14,'Color','none','Box','off');
               set(this.Pop.iTheta,'YTickLabel',num2str(get(gca,'YTick').'));
  %For plotting or not plotting the baseline, max intensity, and reconstruction
               if get(this.Pop.baselineToggle,'Value')==1
                        x3=(1:1:360);
                        y3=repmat(this.forBLColor(this.V(2),this.V(1)),1,length(x3));
                        plot(this.Pop.iTheta,x3,y3,'--m','LineWidth',2);
               else
               end
               
               if get(this.Pop.maxiToggle,'Value')==1
                        x4=(1:1:360);
                        y4=repmat(this.forMaxColor(this.V(2),this.V(1)),1,length(x4));
                        plot(this.Pop.iTheta,x4,y4,'--m','LineWidth',2);
               else
               end
               
               if get(this.Pop.reconToggle,'Value')==1
                        x5=(1:1:360);
                        y5=reshape(this.forRecon(this.V(2),this.V(1),1:180),1,180);
                        recon = [y5 y5];
                        back = recon(1,360-cross2+1:360);
                        front = recon(1,1:360-cross2);
                        recon = [back front];
                        plot(this.Pop.iTheta,x5,recon,'--s','LineWidth',2);
               else
               end
               hold off;

           elseif Ival==2           
               set(this.Pop.iTheta,'XLim',[0 180]);
               set(this.Pop.iTheta,'XTickLabel',round((centDist-90)):20:round((centDist+90)));
               drawthis1=IThetaShift(1:180);
               drawthis2=IThetaShift(181:360);
               drawthis3=(drawthis1+drawthis2)/2.0;
               
               [m180, in180]= max(drawthis3);
               hold on;
               axis(this.Pop.iTheta);
               plot(this.Pop.iTheta,drawthis1,'blue','LineWidth',2);
               plot(this.Pop.iTheta,drawthis2,'cyan','LineWidth',2);
               plot(this.Pop.iTheta,drawthis3,'--r','LineWidth',2);
               if this.new==1
                y1=(1:1000:m180);
                y2=(1:1000:65520);
               else
                y1=(1:5:m180);
                y2=(1:5:255);
               end
               x1=repmat(in180,1,length(y1));
               plot(this.Pop.iTheta,x1,y1,'Color','r','LineStyle','none','Marker','s','LineWidth',2,'MarkerFaceColor','r','MarkerSize',2);
%                plot(this.Pop.iTheta,in180,(1:1000:m180),'--rs','LineWidth',2,...
%                     'MarkerFaceColor','r',...
%                     'MarkerSize',2);
%                plot(this.Pop.iTheta,this.forDegAng(this.V(2),this.V(1)),(1:1000:65520),':gs','LineWidth',2,...
%                     'MarkerFaceColor','g',...
%                     'MarkerSize',2);
               x2=repmat(this.forDistMeanPos(this.V(2),this.V(1)),1,length(y2));
               plot(this.Pop.iTheta,x2,y2,'Color','b','LineStyle','none','Marker','s','LineWidth',2,'MarkerFaceColor','b','MarkerSize',2);
%                y4=(1:1000:65520);
%                x4=repmat(this.forDistMeanPos(this.V(2),this.V(1)),1,length(y4));
%                plot(this.Pop.iTheta,x4,y4,'Color','g','LineStyle','none','Marker','s','LineWidth',2,'MarkerFaceColor','g','MarkerSize',2);
               set(this.Pop.iTheta,'YTickLabel',num2str(get(gca,'YTick').'));

                          %For plotting or not plotting the baseline, max intensity, and
           %reconstruction
               if get(this.Pop.baselineToggle,'Value')==1
%                         hold on
                        x3=(1:1:180);
                        y3=repmat(this.forBLColor(this.V(2),this.V(1)),1,length(x3));
                        plot(this.Pop.iTheta,x3,y3,'--m','LineWidth',2);
%                         legend(this.Pop.iTheta,'Baseline')
%                         hold off
               else
               end
               
               if get(this.Pop.maxiToggle,'Value')==1
%                         hold on
                        x4=(1:1:180);
                        y4=repmat(this.forMaxColor(this.V(2),this.V(1)),1,length(x4));
                        plot(this.Pop.iTheta,x4,y4,'--m','LineWidth',2);
%                         legend(this.Pop.iTheta,'Baseline')
%                         hold off
               else
               end
               if get(this.Pop.reconToggle,'Value')==1
%                         hold on
                        x5=(1:1:180);
                        y5=reshape(this.forRecon(this.V(2),this.V(1),1:180),1,180);
                        plot(this.Pop.iTheta,x5,y5,'--s','LineWidth',2);
%                         legend(this.Pop.iTheta,'Baseline')
%                         hold off
               else
               end
% 
               lege=legend(this.Pop.iTheta,'180-Degree Segment 1','180-Degree Segment 2','Average of the Two Segments','Average Peak Location','Original Peak Location');
               set(lege,'FontSize',14,'FontWeight','bold','Color','none','Box','off');
               hold off;
           else
               set(this.Pop.iTheta,'XLim',[0 400]);
               drawthis1=IBeta;
               hold on;
               axis(this.Pop.iTheta);
               plot(this.Pop.iTheta,drawthis1,'blue','LineWidth',2);
               leg=legend(this.Pop.iTheta,'Intensity Decay along Major Axis');
               set(leg,'FontSize',14,'FontWeight','bold','Color','none','Box','off');
               set(this.Pop.iTheta,'YTickLabel',num2str(get(gca,'YTick').'));
               hold off;
           end
        end
        
        %%
        function saveIData(this)
           
            [singleDistFileOut,singleDistFolderOut]=uiputfile('.txt','Please select an output path for the selected point:');
            if isequal(singleDistFileOut,0)||isequal(singleDistFolderOut,0)
                return          
            else
                    if ismac
                        tempfldr=strcat(singleDistFolderOut,'/');
                    else
                        tempfldr=strcat(singleDistFolderOut,'\');
                    end
                    strRaw=strcat(tempfldr,'RAW360',singleDistFileOut);
                    strPost=strcat(tempfldr,'POST',singleDistFileOut);
                    fidr=fopen(strRaw,'w');
                    fidp=fopen(strPost,'w');
                    fprintf(fidr,'%5.2f \n',this.distSaveRaw);
                    fprintf(fidp,'%5.2f\t %5.2f\t %5.2f\n',[this.distSave1,this.distSave2,this.distSaveAvg]);
                    
                    
                    fclose(fidr);
                    fclose(fidp);

                    h = msgbox('Single Point Selection - Save Completed');
            end 
            
            
        end
        %%
        function chooseIData(this,hobject,eventdata)
            switch get(eventdata.NewValue,'Tag')
                
                case 'full'
%                     disp('full');
                    this.Ival=1
                    drawIData(this,this.Ival);
                    
                case 'one80'
%                     disp('180');
                    this.Ival=2
                    drawIData(this,this.Ival);
                    
                case 'Idecay'
%                     disp('Idecay');
                    this.Ival=3
                    drawIData(this,this.Ival);
                    
                otherwise
%                     disp('Other');
                    % Code for when there is no match.
            end
        end
        
        %% 
        function dispOrientationHist(this,src,event)
            cla(this.Pop.iTheta,'reset');
            temp=reshape(this.forCentHist,1,size(this.forCentHist,1)*size(this.forCentHist,2));
            hold on

            
            axis(this.Pop.iTheta);
            PDHist=buildHists(this,this.currentColor);
            sizetemp=size(PDHist);
            x=(1:1:sizetemp(2));
            set(this.Pop.iTheta,'XLim',[0 sizetemp(2)])
            set(this.Pop.iTheta,'YLimMode','auto');
            bar(x,PDHist);
            if this.currentColor==1
                title(this.Pop.iTheta,'Orientation Index','FontSize',30,'FontWeight','bold')
            elseif this.currentColor==3
                title(this.Pop.iTheta,'Maximum Intensity','FontSize',30,'FontWeight','bold')
            elseif this.currentColor==4
                title(this.Pop.iTheta,'Preferred Direction','FontSize',30,'FontWeight','bold')
            end
            hold off
            
        end
        
        %%
        function outHist=buildHists(this,histType)
            
            if histType==1
                array=ceil(this.forOIHist*100);
                arraySize=size(array);
                tempHist=zeros(1,100);
                for i=1:1:arraySize(1)
                    for j=1:1:arraySize(2)
                        if array(i,j) ~= -100
                            tempHist(array(i,j))=tempHist(array(i,j))+1;
                        end
                    end
                end
            end
            if histType==3     
                array=this.forMaxIntHist;
                arraySize=size(array);
                tempHist=zeros(1,100);
                for i=1:1:arraySize(1)
                    for j=1:1:arraySize(2)
                        if array(i,j) ~= -1
                            tempHist(array(i,j))=tempHist(array(i,j))+1;
                        end
                    end
                end
            end
            if histType==4
                array=this.forCentHist;
                arraySize=size(array);
                tempHist=zeros(1,180);
                for i=1:1:arraySize(1)
                    for j=1:1:arraySize(2)
                        if array(i,j) ~= -1
                            if array(i,j) >180
                                tempHist(array(i,j)-180)= tempHist(array(i,j)-180)+1;
                            else
                                tempHist(array(i,j))= tempHist(array(i,j))+1;
                            end
                        end
                    end
                end
            end 
            
            outHist=tempHist;
        end
            
                    
      
        %%
        function chooseColor(this, hObject, eventdata)
            if this.AxesFilled
                switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
                
                    case 'OrientationIndex'
                        this.currentColor=1;
                        set(this.Figure.colorChosen,'String','Orientation Index');
                        reDraw(this,1,'colorchange');
                    case 'Baseline'
                        % Code for when BL is selected.
                        this.currentColor=2;
                        set(this.Figure.colorChosen,'String','Baseline');
                        reDraw(this,2,'colorchange');
                    case 'MaxIntensity'
                        % Code for when MI is selected.
                        this.currentColor=3;
                        set(this.Figure.colorChosen,'String','Maximum Intensity'); 
                        reDraw(this,3,'colorchange');
                    case 'Centroid'
                        % Code for when Cent is selected.
                        this.currentColor=4;
                        set(this.Figure.colorChosen,'String','Centroid');
                        reDraw(this,4,'colorchange');
                    case 'iet'
                        this.currentColor=5;
                        set(this.Figure.colorChosen,'String','IET');
                        reDraw(this, 5, 'colorchange');
                    case 'skew'
                        this.currentColor=6;
                        set(this.Figure.colorChosen,'String','Skew');
                        reDraw(this, 6, 'colorchange');
                    case 'SymCoeff'
                        this.currentColor=7;
                        set(this.Figure.colorChosen,'String','Symmetry Coeff');
                        reDraw(this, 7, 'colorchange');
                    case 'rCoeff'
                        this.currentColor=8;
                        set(this.Figure.colorChosen,'String','Correlation Coeff');
                        reDraw(this, 8, 'colorchange');
                    otherwise
                        disp('Other');
                        % Code for when there is no match.
                end
            end
        end
        
        %%
        function activeThresh(this, hObject, eventdata)
            if this.AxesFilled
                %get the threshold from the slider
                this.tval=get(hObject,'Value');
                %update string for threshold value
                set(this.Figure.editCheck,'String',strcat('Threshold Value:   ',int2str(this.tval)));
                
                fillAxes(this,this.currentColor,this.tval,1,this.quiverOn,1,0);
                
                
            end
        end
        
        %% Delete Points Function
        % Manually Delete Points That were not thresholded
        function deletePoints(this,src,eventdata)
            button_state = get(src,'Value');
            if button_state == get(src,'Max')
                % Toggle button is pressed-take appropriate action
                delete =1;
                set(this.qq,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) null(this));
                set(this.img,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) null(this));
                axes(this.Figure.mainAxes);
                on=1;
                while on==1;    
                    guidata(src,eventdata);
                    pause(0.2);
                    button_state=get(src,'Value');
                    if button_state==get(src,'Min')
                        
                        on=0;
                    else 
%                     [xD,yD]=ginput(2)
                    rect=getrect(gca);
                    xD=[rect(1);rect(1)+rect(3)];
                    yD=[rect(2);rect(2)+rect(4)];
                    hold on;
                    InsDel(this,0,xD,yD);
                    hold off;
                    end
                    
                    choice = questdlg('Keep Deleting?', ...
                        'Delete?', ...
                        'Yes','No','Yes');
                    % Handle response
                    switch choice
                        case 'Yes'
                            disp([choice 'Keep']);
                            on = 1;
                        case 'No'
                            disp([choice 'Stop']);
                            on = 0;
                            set(src,'Value',0);
       
                    end

%                     pause(2);
                        
                end

            elseif button_state == get(src,'Min')
                % Toggle button is not pressed-take appropriate action
                set(this.qq,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) getMPos(gca,this));
                set(this.img,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) getMPos(gca,this));
                delete=0;

            end
        end
        
        %% Delete Points Wand Function
        %  Manually delete points not thresholded by use of a "Magic Wand"
        %  selection method
        function deletePointsWand(this,src,eventdata)
            button_state = get(src,'Value');
            if button_state == get(src,'Max')
                % Toggle button is pressed-take appropriate action
                delete =1;
                set(this.qq,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) null(this));
                set(this.img,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) null(this));
                axes(this.Figure.mainAxes);
                on=1;
                while on==1;    
                    guidata(src,eventdata);
                    pause(0.2);
                    button_state=get(src,'Value');
                    if button_state==get(src,'Min')
                        
                        on=0;
                    else 
%                     [xD,yD]=ginput(2)
                    
%                     location = get(gca,'CurrentPoint');
%                     [xD yD] = [location(1,1) location(2,1)];
                    gca;
                    [yD,xD] = ginput(1);
                    hold on;
                    InsDelWand(this,0,xD,yD);
                    hold off;
                    end
                    
                    choice = questdlg('Keep Deleting?', ...
                        'Delete?', ...
                        'Yes','No','Yes');
                    % Handle response
                    switch choice
                        case 'Yes'
                            disp([choice 'Keep']);
                            on = 1;
                        case 'No'
                            disp([choice 'Stop']);
                            on = 0;
                            set(src,'Value',0);
       
                    end

%                     pause(2);
                        
                end

            elseif button_state == get(src,'Min')
                % Toggle button is not pressed-take appropriate action
                set(this.qq,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) getMPos(gca,this));
                set(this.img,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) getMPos(gca,this));
                delete=0;

            end
        end        
        %% Insert Points Function
        %  This allows users to insert thresholded points back into map
        function insertPoints(this,src,eventdata)
            button_state = get(src,'Value');
            if button_state == get(src,'Max')
                % Toggle button is pressed-take appropriate action
                insert =1;
                %what is the difference between this.qq and this.img?
                %set the coordinates for the mouse to null
                set(this.qq,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) null(this));
                set(this.img,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) null(this));
                axes(this.Figure.mainAxes);
                on=1;
                %while insert is selected
                while on==1;    
                    %store eventdata in the handle src
                    guidata(src,eventdata);
%                     pause(0.2);
                    %wait
                    pause(0.1);
                    %find if the button
                    button_state=get(src,'Value');
                    if button_state==get(src,'Min')
                        on=0;
                    else 
%                     [xD,yD]=ginput(2)
                    %awaits user input rectangle, obtains the coordinates
                    %for each corner
                    rect=getrect(gca);
                    %gets x min and max values
                    xD=[rect(1);rect(1)+rect(3)];
                    %gets y min and max values
                    yD=[rect(2);rect(2)+rect(4)];
                    hold on;
                    %call insert/delete with handle this, 1 for do
                    %insertion, and x and y positions
                    InsDel(this,1,xD,yD);
                    hold off;
                    end
                    
                    choice = questdlg('Keep Inserting?', ...
                        'Insert?', ...
                        'Yes','No','Yes');
                    % Handle response
                    switch choice
                        case 'Yes'
                            disp([choice 'Keep'])
                            on = 1;
                        case 'No'
                            disp([choice 'Stop'])
                            on = 0;
                            set(src,'Value',0);
       
                    end
%                     pause(2);
                        
                end

            elseif button_state == get(src,'Min')
                % Toggle button is not pressed-take appropriate action
                set(this.qq,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) getMPos(gca,this));
                set(this.img,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) getMPos(gca,this));
                delete=0

            end
        end
        
         %% Insert Points Wand Function
        %  This allows users to insert thresholded points back into map
        %  using a "Magic Wand" selection method
        function insertPointsWand(this,src,eventdata)
        button_state = get(src,'Value');
            if button_state == get(src,'Max')
                % Toggle button is pressed-take appropriate action
                insert =1;
                %what is the difference between this.qq and this.img?
                %set the coordinates for the mouse to null
                set(this.qq,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) null(this));
                set(this.img,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) null(this));
                axes(this.Figure.mainAxes);
                on=1;
                %while insert is selected
                while on==1;    
                    %store eventdata in the handle src
                    guidata(src,eventdata);
                    pause(0.2);
                    %find if the button
                    button_state=get(src,'Value')
                    if button_state==get(src,'Min')
                        
                        on=0;
                    else 
%                     [xD,yD]=ginput(2)
                    %awaits user input rectangle, obtains the coordinates
                    %for each corner
                    
                    gca;
                    [yD,xD] = ginput(1)
                    hold on;
                    InsDelWand(this,1,xD,yD)
                    hold off;
                    end
                    
                    choice = questdlg('Keep Inserting?', ...
                        'Insert?', ...
                        'Yes','No','Yes');
                    % Handle response
                    switch choice
                        case 'Yes'
                            disp([choice 'Keep'])
                            on = 1;
                        case 'No'
                            disp([choice 'Stop'])
                            on = 0;
                            set(src,'Value',0);
       
                    end
%                     pause(2);
                        
                end

            elseif button_state == get(src,'Min')
                % Toggle button is not pressed-take appropriate action
                set(this.qq,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) getMPos(gca,this));
                set(this.img,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
                    @(s,e) getMPos(gca,this));
                delete=0

            end
        end
        %% function- Insert or Delete Points
        %the function for inserting or deleting points with the handle
        %this, doWhat specifies insertion or deletion, and x and y points
        %are the inputs
        function InsDel(this,doWhat,xPoints,yPoints)
            %round the x and y points to the nearest integer
            xRound=round(xPoints)
            yRound=round(yPoints)
            
            yInc=1;
            xInc=1;
            if yRound(2)<yRound(1)
                yInc=-1;
            end
            if xRound(2)<xRound(1)
                xInc=-1;
            end
            if yRound(1)<1
                yRound(1)=1;
            end
            if yRound(2)<1
                yRound(2)=1;
            end
            if xRound(1)<1
                xRound(1)=1;
            end
            if xRound(2)<1
                xRound(2)=1;
            end
            
            %insertion for doWhat>0    
            if doWhat>0
                %from the minimum x position to the maximum x position
                for i=xRound(1):xInc:xRound(2)
                    %from the minimum y position to the maximum y position
                    for j=yRound(1):yInc:yRound(2)
                        %set the threshold at 99 to include these points
                        this.forThresh(j,i)=99;
                    end
                end
            %deletion for doWhat<0    
            else
                %from the minimum x position to the maximum x position
                for i=xRound(1):xInc:xRound(2)
                    %from the minimum y position to the maximum y position
                    for j=yRound(1):yInc:yRound(2)
                        %set thresh to -1 such that it is below 0
                        this.forThresh(j,i)=-1;
                    end
                end 
            end
            %update the axes
            fillAxes(this,this.currentColor,this.tval,1,1,1,0);  
        end
        
        %% function- Insert or Delete Points With Wand
        %the function for inserting or deleting points with the handle
        %this, doWhat specifies insertion or deletion, and x and y points
        %are the inputs
        function InsDelWand(this,doWhat,xPoints,yPoints)
            %round the x and y points to the nearest integer
            yRound=round(xPoints);
            xRound=round(yPoints);
            
            %insertion for doWhat>0    
            if doWhat>0
                queue = [yRound, xRound];
                completed = [];
                lim = size(this.forThresh);
                xlim = lim(2);
                ylim = lim(1);
                while (1-isempty(queue));
                    %check to see if selected point on upper bounds
                    %look into using switch rather than multiple if/else statements
                    if queue(1,2) >=xlim;
                        xmax = queue(1,2);
                    else
                        xmax = queue(1,2)+1;
                    end
                    if queue(1,2) ==1;
                        xmin = queue(1,2);
                    else
                        xmin = queue(1,2)-1;
                    end
                    if queue(1,1) >=ylim;
                        ymax = queue(1,1);
                    else
                        ymax = queue(1,1)+1;
                    end
                    if queue(1,1) ==1;
                        ymin = queue(1,1);
                    else
                        ymin = queue(1,1)-1;
                    end
                    for i=ymin:ymax;

                        if  this.forThresh(i,queue(1,2)) < this.tval;
%                             if this.forThresh(i,queue(1,2))~= -1
%                                 this.forThresh(i,queue(1,2)) =
                            this.forThresh(i,queue(1,2)) = 99;
                            %update completed vector for debugging purposes
%                             completed = [completed; i,queue(1,2)];
                            if i ~= queue(1,1);
                                queue = [queue; i,queue(1,2)];
                            end
                        end
                    end
                    for k=xmin:xmax
                        %if the point left/right is blanked, fill it in
                        if  this.forThresh(queue(1,1),k) < this.tval;
                            this.forThresh(queue(1,1),k) = 99;
                            %update completed vector for debugging purposes
%                             completed = [completed; queue(1,1),k];
                            if k ~= queue(1,2)
                                queue = [queue; queue(1,1),k];
                            end
                        end  
                    end
                        %clear any completed values
                        queue(1,:) = [];
                end
            else
                queue = [yRound, xRound];
                completed = [];
                lim = size(this.forThresh);
                xlim = lim(2);
                ylim = lim(1);
                while (1-isempty(queue));
                    %check to see if selected point on upper bounds
                    %look into using switch rather than multiple if/else statements
                    if queue(1,2) >=xlim;
                        xmax = queue(1,2);
                    else
                        xmax = queue(1,2)+1;
                    end
                    if queue(1,2) ==1;
                        xmin = queue(1,2);
                    else
                        xmin = queue(1,2)-1;
                    end
                    if queue(1,1) >=ylim;
                        ymax = queue(1,1);
                    else
                        ymax = queue(1,1)+1;
                    end
                    if queue(1,1) ==1;
                        ymin = queue(1,1);
                    else
                        ymin = queue(1,1)-1;
                    end
                    for i=ymin:ymax;

                        if  this.forThresh(i,queue(1,2)) > this.tval;
%                             if this.forThresh(i,queue(1,2))~= -1
%                                 this.forThresh(i,queue(1,2)) =
                            this.forThresh(i,queue(1,2)) = -1;
                            %update completed vector for debugging purposes
%                             completed = [completed; i,queue(1,2)];
                            if i ~= queue(1,1);
                                queue = [queue; i,queue(1,2)];
                            end
                        end
                    end
                    for k=xmin:xmax
                        %if the point left/right is blanked, fill it in
                        if  this.forThresh(queue(1,1),k) > this.tval;
                            this.forThresh(queue(1,1),k) = -1;
                            %update completed vector for debugging purposes
%                             completed = [completed; queue(1,1),k];
                            if k ~= queue(1,2)
                                queue = [queue; queue(1,1),k];
                            end
                        end  
                    end
                        %clear any completed values
                        queue(1,:) = [];
                end
            end
 
            
%                 %from the minimum x position to the maximum x position
%                 for i=xRound(1):xInc:xRound(2)
%                     %from the minimum y position to the maximum y position
%                     for j=yRound(1):yInc:yRound(2)
%                         %set thresh to -1 such that it is below 0
%                         this.forThresh(j,i)=-1;
%                     end
%                 end 
%             end
            %update the axes
            fillAxes(this,this.currentColor,this.tval,1,1,1,0);  
        end
        
        %% Null
        function null(this)
            return
        end

        %% Close Pop up
        function closePop(this, hObject, eventdata)
            this.popped=0;
            set(this.Pop.FigPop,  'closerequestfcn', '');
            %delete the figure
            delete(this.Pop.FigPop);
            %clear out the pointer to the figure - prevents memory leaks
            this.Pop = [];
            
        end
        
        %% File Output Functions
        %  Begins File Output Writing
        function setOutputPath(this,src,event)
            this.outputPath=uigetdir('\Users\John\SALSA New\','Please select an output path');
            if isequal(this.outputPath,0)
                set(this.Figure.outputPath,'String','No Path Selected');
                setOutputPath(this,src,event);
            else
                
                this.outputFile=get(this.Figure.outputFile,'String');
                if isequal(this.outputFile,'Output File Name')
                    set(this.Figure.outputPath,'String','No File Selected');
                else
                    tempstr=strcat(this.outputPath,'/',this.outputFile);
                    set(this.Figure.outputPath,'String',tempstr);
                    organizeOutputData(this,tempstr);
                end
            end
        end
        
        function organizeOutputData(this,outputStr)
            this.OUT=zeros(10,this.input_size(1,1)*this.input_size(1,2));
            this.forOutputNodeNumber=zeros(this.input_size(1,1)*this.input_size(1,2),1);
            for i=1:1:this.input_size(1,1)*this.input_size(1,2)
                this.forOutputNodeNumber(i,1)=i;
            end
            this.OUT(10,:)=this.forOutputNodeNumber;
            configPos(this);
            configOI(this);
            configMaxI(this);
            configMinI(this);
            configPD(this);
            configTensor(this);
            writeOutput(this,outputStr);
        end
        
        function configPos(this)
            this.forOutX=flipud(this.pos(:,2));
            this.OUT(1,:)=this.forOutX;
            tempy=ones(this.input_size(1,1),this.input_size(1,2));
            tempyy=[];
            for i=1:1:this.input_size(1,1);
                tempy(i,:)=this.pos(i,1);
            end
            for i=1:1:this.input_size(1,2);
                tempyy=[tempyy,transpose(tempy(:,i))];
            end
            this.forOutY=tempyy;
            this.OUT(2,:)=this.forOutY;
%             set(this.Figure.mainData,'Data',tempyy);
            
        end
        
        function configOI(this)
            tempoi=[];
            for i=1:1:this.input_size(1,2);
                tempoi=[tempoi,transpose(this.forOIColor(:,(this.input_size(1,2)+1)-i))];
            end
            tempoi=round(tempoi*100);
            this.OUT(3,:)=tempoi;
%             set(this.Figure.mainData,'Data',tempoi);

        end
        
        function configMaxI(this)
            tempmaxi=[];
            for i=1:1:this.input_size(1,2);
                tempmaxi=[tempmaxi,transpose(this.forMaxColor(:,(this.input_size(1,2)+1)-i))];
            end
            this.OUT(4,:)=tempmaxi;
        end
        
        function configMinI(this)
            tempmini=[];
            for i=1:1:this.input_size(1,2);
                tempmini=[tempmini,transpose(this.forBLColor(:,(this.input_size(1,2)+1)-i))];
            end
            this.OUT(5,:)=tempmini;
        end
         
        function configPD(this)
            tempPD=[];
            for i=1:1:this.input_size(1,2);
                tempPD=[tempPD,transpose(this.forCentDeg(:,(this.input_size(1,2)+1)-i))];
            end
            this.OUT(6,:)=tempPD;
        end        
      
        function configTensor(this)
            temptensor=[];
            for i=1:1:this.input_size(1,2);
                temptensor=[temptensor,transpose(this.htens1(:,(this.input_size(1,2)+1)-i))];
            end
            this.OUT(7,:)=temptensor;
            
            temptensor = [];
            for i=1:1:this.input_size(1,2);
                temptensor=[temptensor,transpose(this.htens2(:,(this.input_size(1,2)+1)-i))];
            end
            this.OUT(8,:)=temptensor;   
            
            temptensor = [];
            for i=1:1:this.input_size(1,2);
                temptensor=[temptensor,transpose(this.htens4(:,(this.input_size(1,2)+1)-i))];
            end
            this.OUT(9,:)=temptensor;   
        end
        
        function writeOutput(this,outputStr)
            thresh=get(this.Figure.threshold,'Value');
            count=this.input_size(1,1)*this.input_size(1,2);
            if mod(this.input_size(1,2),2)~=0
                count=count-this.input_size(1);
                for i=1:1:this.input_size(1,2)
                    for j=this.input_size(1,1):-1:1
                        if this.forThresh(j,i)<=thresh
                            this.OUT(3:end-1,count+(j))=-100;

                        end
                    end
                    count=count-this.input_size(1,1);
                end
            else
                for i=1:1:this.input_size(1,2)
                    temp=count;
                    for j=this.input_size(1,1):-1:1
                        if this.forThresh(j,i)<=thresh
                            this.OUT(3:end-1,temp)=-100;
                           
                        end
                        temp=temp-1;
                    end
                    count=count-this.input_size(1,1);
                end
                
            end


%             set(this.Figure.mainData,'Data',this.OUT);
            f=fopen(outputStr,'w');
            fprintf(f,'%d\t %d\n',this.input_size);
            fprintf(f,'Xpos\t Ypos\t OI\t Max\t Min\t PD\t T1\t T2\t T4\t Node#\n');
            fprintf(f,'%2.4f\t%2.4f\t%d\t%d\t%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%d\n',this.OUT);
            fclose(f);
            
            make2Dmesh(this,outputStr);

        end
                  
        
        %% 
        % bw tiff output for registration
        %tissue goes to white, rest goes to black
        function outputBW(this)
           hold on;
           
           axes(this.Figure.mainAxes);
           axis off;
           colorbar off;
           testststst=1
            
           for numx=1:this.input_size(2)
               for numy=1:this.input_size(1)
                    if this.forThresh(numy,numx)<this.tval

                        this.forBWOut(numy,numx)=0;
                    else
                        this.forBWOut(numy,numx)=1;   
                    end
                end
            end
            
            this.colorMap=num2colormap(this.forBWOut,'gray',[0 1]);
            this.img =imagesc(this.colorMap);
            hold off;
        end
        
                %%
        function saveTiff(this, src, event)
              [tiffoutfile,tiffoutfolder]=uiputfile('*.tif','Please select an output path');
            if isequal(tiffoutfolder,0)||isequal(tiffoutfolder,0)
                set(this.Figure.outputPath,'String','No Path Selected');
            else
                
                % create gray image array
                this.forGrayOUT=this.OrThresh/100.0;
                temp=(this.forDistMeanPos/180.0);
                this.forGrayOUT=temp.*this.forGrayOUT;
                
                tempstr=strcat(tiffoutfolder,tiffoutfile);
                
                %Get this image lookin pretty
                this.quiverOn=0;
                fillAxes(this, 9 ,this.tval,1,this.quiverOn,0,0);
                axes(this.Figure.mainAxes);
                
                axis off;
                colorbar off;

                %Create separate figure - so we can make it square
                GUI_fig_children=get(gcf,'children');
                Fig_Axes=findobj(GUI_fig_children,'type','Axes');
                fig=figure;ax=axes;clf;
                new_handle=copyobj(Fig_Axes,fig);
                % Enlarge figure to full screen.
                set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                axis square;

                
                %Send that baby off to print
                export_fig(gca,tempstr,'-grey');

                
                %Close our new image and restore the original image
                close(fig);
                axes(this.Figure.mainAxes);
                set(this.Figure.outputPath,'String',tempstr)
                axes(this.Figure.mainAxes);
                axis on;
                this.quiverOn=1;
                fillAxes(this, this.currentColor,this.tval,1,this.quiverOn,0,0);
                colorbar;
                h = msgbox('Greyscale Image Save Completed');
            end   
        end
        
                        %%
        function saveJpeg(this, src, event)
              %imwrite(imresize(flipdim(this.colorMap,1), 5, 'nearest'), 'Image', 'jpeg')
              [jpegoutfile,jpegoutfolder]=uiputfile('*.jpeg','Please select an output path');
            if isequal(jpegoutfolder,0)||isequal(jpegoutfolder,0)
                set(this.Figure.outputPath,'String','No Path Selected');
            else
                    tempstr=strcat(jpegoutfolder,jpegoutfile);
%                     export_fig(this.Figure.mainAxes,tempstr)
                    this.quiverOn=0;
                    fillAxes(this, this.currentColor,this.tval,1,this.quiverOn,0,0);
                    axes(this.Figure.mainAxes);
                    axis off;
                    export_fig(this.Figure.mainAxes,tempstr);
                    set(this.Figure.outputPath,'String',tempstr)
                    axes(this.Figure.mainAxes);
                    axis on;
                    this.quiverOn=1;
                    fillAxes(this, this.currentColor,this.tval,1,this.quiverOn,0,0);
                    h = msgbox('Color Image Save Completed');
            end   
        end
        
                %%
        function saveBitmap(this, src, event)
            %dlmwrite('bitmap.txt',this.colorMap) 
            %[file, folder]=uigetfile('\*.txt','Save the Bitmap');
            [bmpoutfile,bmpoutfolder]=uiputfile('*.txt','Please select an output path');
            if isequal(bmpoutfolder,0)||isequal(bmpoutfile,0)
                set(this.Figure.outputPath,'String','No Path Selected');
            else
                
            tempstr=strcat(bmpoutfolder,bmpoutfile);

            end
            num = this.currentColor;
            fID = fopen(tempstr, 'w+');
            j=1;
            if num == 1               
                fprintf(fID,'%d\t %d\n',this.input_size);
             while j <= this.input_size(2)
                     i = 1; 
                 while i <= this.input_size(1)
                    fprintf(fID,'%d\t',round((this.forBWOut(i,j))));
                    i = i+1;
                 end
                 j = j+1;
                 fprintf(fID,'\n');
             end 
            elseif num == 2
                fprintf(fID,'%d %d\n',this.input_size);
             while j <= this.input_size(2)
                 i = 1; 
                 while i <= this.input_size(1)
                    fprintf(fID,'%d\t',round((this.forBLColor(i,j)*100)));
                    i = i+1;
                 end
                 j = j+1;
                 fprintf(fID,'\n');
             end          
            elseif num == 3
                fprintf(fID,'%d %d\n',this.input_size);
             while j <= this.input_size(2)
                 i = 1; 
                 while i <= this.input_size(1)
                    fprintf(fID,'%d\t',round((this.forMaxColor(i,j)*100)));
                    %fprintf(fID,'%d\t',round((this.forBWOut(i,j))));
                    i = i+1;
                 end
                 j = j+1;
                 fprintf(fID,'\n');
             end            
            elseif num == 4               
                fprintf(fID,'%d %d\n',this.input_size);
             while j <= this.input_size(2)
                 i = 1; 
                 while i <= this.input_size(1)
                    fprintf(fID,'%d\t',round((this.forCentDeg(i,j)*100)));
                    i = i+1;
                 end
                 j = j+1;
                 fprintf(fID,'\n');
             end             
            elseif num == 5               
                fprintf(fID,'%d %d\n',this.input_size);
             while j <= this.input_size(2)
                 i = 1; 
                 while i <= this.input_size(1)
                    fprintf(fID,'%d\t',round((this.forIET(i,j)*100)));
                    i = i+1;
                 end
                 j = j+1;
                 fprintf(fID,'\n');
             end 
            elseif val == 6
                
            end
            fclose(fID);
            set(this.Figure.outputPath,'String',tempstr)
            h = msgbox('Bitmap File Save Completed');
        end
        
        %% Function- Load transmural txt files that were previously thresholded and identify the data present in them
        function loadtrans(this,src,event)
            %Load in transmural txt file previously created for this SALS file
            [this.transFile, this.transFilePath]=uigetfile('\*.txt','Pick the corresponding transmural txt file');
%             fid=fopen(strcat(this.transFilePath,this.transFile),'a+');
            this.transsizes = dlmread(strcat(this.transFilePath,this.transFile),'\t',[0 0 0 1]);
            this.transbitmap=dlmread(strcat(this.transFilePath,this.transFile),'\t',2,0);

            %Apply the bit values from the transmural txt file to threshold the data
            t=1;
            this.tempBitmapTArray=zeros(this.transsizes(1,1),this.transsizes(1,2));
            for j=1:this.input_size(1,2)
                for i=1:this.input_size(1,1)
                    this.tempBitmapTArray(i,j) = this.transbitmap(t,4);  %Create an array of the bits
                    t=t+1;
                end
            end
            this.forThresh = this.tempBitmapTArray;  %Overwrite threshold array
            this.tval=1;
            fillAxes(this,this.currentColor,this.tval,1,1,1,0);  %Redraw thresholded image
            
            %Identify which data types (OI,Max Intensity, etc.) are in the data file and fill in check boxes
            fid=fopen(strcat(this.transFilePath,this.transFile));
            ftext=fread(fid,'*char')';
            newStr=strsplit(ftext,'\n');
%             numchar = length(cell2mat(newStr(1,2)))
            findOI = strfind(newStr(1,2), 'OI');
            if isempty(cell2mat(findOI)) == 1
                set(this.Figure.OIinFile,'Value',0)
            else
                set(this.Figure.OIinFile,'Value',1)
            end
            findBaseline = strfind(newStr(1,2), 'BL');
            if isempty(cell2mat(findBaseline)) == 1
                set(this.Figure.baselineInFile,'Value',0)
            else
                set(this.Figure.baselineInFile,'Value',1)
            end
            findMaxI = strfind(newStr(1,2), 'MaxI');
            if isempty(cell2mat(findMaxI)) == 1
                set(this.Figure.maxiInFile,'Value',0)
            else
                set(this.Figure.maxiInFile,'Value',1)
            end
            findPrefD = strfind(newStr(1,2), 'PrefD');
            if isempty(cell2mat(findPrefD)) == 1
                set(this.Figure.prefdInFile,'Value',0)
            else
                set(this.Figure.prefdInFile,'Value',1)
            end
            findSkew = strfind(newStr(1,2), 'Skew');
            if isempty(cell2mat(findSkew)) == 1
                set(this.Figure.skewInFile,'Value',0)
            else
                set(this.Figure.skewInFile,'Value',1)
            end
            findKurtosis = strfind(newStr(1,2), 'Kurtosis');
            if isempty(cell2mat(findKurtosis)) == 1
                set(this.Figure.kurtosisInFile,'Value',0)
            else
                set(this.Figure.kurtosisInFile,'Value',1)
            end
            findcoeff = strfind(newStr(1,2), 'Coeff');
            if isempty(cell2mat(findcoeff)) == 1
                set(this.Figure.coeffInFile, 'Value',0)
            else
                set(this.Figure.coeffInFile,'Value',1);
            end
            findTensor = strfind(newStr(1,2), 'Tensor');
            if isempty(cell2mat(findTensor)) == 1
                set(this.Figure.tensorInFile,'Value',0)
            else
                set(this.Figure.tensorInFile,'Value',1)
            end
        end
            
                %%
        function make2Dmesh(this,outputStr);

        %WILL NEED TO REMOVE THIS AFTER ADDING IN SKEW AND KURTOSIS DATA
            this.OUT(11:13,:)=0; %Add in a blanked space for the x-component of the centroid, y-component of the centroid, skew and kurtosis
            this.OUT(14,:)=this.OUT(10,:); %Add the nodes to the end of the data set
            this.OUT(10,:)=0; %Blank original node values

            
%       Create 2D Rectilinear Mesh
            x=1;
            s=1;

           for f=1:(this.input_size(1,2)-1);      

                this.Mesh2D (s,1) = x;
                this.Mesh2D (s,2) = x+this.input_size(1,1);
                this.Mesh2D (s,3) = x+this.input_size(1,1)+1;  
                this.Mesh2D (s,4) = x + 1;


                s=s+1;

                       for n=1:(this.input_size(1,1)-2)    %  Writes the bricks adding one to the previous line node number

                               this.Mesh2D (s,1) = this.Mesh2D(s-1,1)+1;
                               this.Mesh2D (s,2) = this.Mesh2D(s-1,2)+1;
                               this.Mesh2D (s,3) = this.Mesh2D(s-1,3)+1;
                               this.Mesh2D (s,4) = this.Mesh2D(s-1,4)+1;

                            s=s+1;

                       end
                               x=x+this.input_size(1,1);
                       
           end


             
            f=fopen((strcat(outputStr,'_TECPLOT_1slice','.plt')),'w'); %Need to write a variable output name
            this.tE = num2str((this.input_size(1,2)-1)*(this.input_size(1,1)-1)); %Calculates the total number of elements based on row and column data
            this.zN = num2str(this.OUT(14,end)); %Determines the Total Number of nodes           
            fprintf(f,'TITLE= "Tecplot 2D Slice Mesh Data" \n');
            fprintf(f,'VARIABLES = "X", "Y", "OI", "Max Int", "Min Int", "Pref Dir", "TV1", "TV2", "TV4","X_comp Centroid", "Y_comp Centroid", "Skew", "Kurtosis", "ID" \n'); 
            fprintf(f,'ZONE N= %s, E= %s, F=FEPOINT, ET=QUADRILATERAL \n', this.zN , this.tE);
            fprintf(f,'%2.4f\t%2.4f\t%d\t%d\t%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%1.4f\t%1.4f\t%3.3f\t%3.3f\t%d\n',this.OUT);
            fprintf(f,'\n');
            dlmwrite (strcat(outputStr,'_TECPLOT_1slice','.plt'), this.Mesh2D, 'precision', 7, 'delimiter', ' ', '-append');  % All the bricks are in the file with consecutive ID number
            fclose(f);
            
        end 
        
        %%
        function transmuralOutput(this)
            this.totalnodes = this.input_size(1,1)*this.input_size(1,2);
            checks = findchecks(this); %Finds the number of options that are checked
            this.transOUT=zeros(checks,this.totalnodes);            
            %Configuring the node numbers
            this.fortransOutputNodeNumber=zeros(this.totalnodes,1);
            for i=1:1:this.totalnodes
                this.fortransOutputNodeNumber(i,1)=i;
            end
            this.transOUT(1,:)=this.fortransOutputNodeNumber;
            %Configuring X, Y, and Bit
            configTransPos(this);
            bwList(this);
            %Adding data that is checked to the file
            checks = 4;
            headerstr = ' Node#\t Xpos\t Ypos\t Bit\t ';
            formatstr = '%d\t%2.2f\t%2.2f\t%d\t';
            %If OI is checked, add it to the data
            if get(this.Figure.OIinFile,'Value')==1
                checks=checks+1;
                OInum = checks;
                headerstr = strcat(headerstr,'OI\t ');
                formatstr = strcat(formatstr,'%1.3f\t');
                t=1;
                forOutOI = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutOI(t,1) = this.forOIColor(i,j);  %Create column of OI to append
                        t=t+1;
                    end
                end 
                this.transOUT(OInum,:)=forOutOI;
            end
            %If Baseline is checked, add it to the data file
            if get(this.Figure.baselineInFile,'Value')==1
                checks=checks+1;
                Bnum=checks;
                headerstr = strcat(headerstr,'BL\t ');
                formatstr = strcat(formatstr,'%d\t');
                t=1;
                forOutBase = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutBase(t,1) = this.forBLColor(i,j);  %Create column of Baseline to append
                        t=t+1;
                    end
                end 
                this.transOUT(Bnum,:)=forOutBase;
            end
            %If Max Intensity is checked, add it to the data file
            if get(this.Figure.maxiInFile,'Value')==1
                checks=checks+1;
                MInum=checks;
                headerstr = strcat(headerstr,'MaxI\t ');
                formatstr = strcat(formatstr,'%d\t');
                t=1;
                forOutMaxI = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutMaxI(t,1) = this.forMaxColor(i,j);  %Create column of Max I to append
                        t=t+1;
                    end
                end 
                this.transOUT(MInum,:)=forOutMaxI;
            end
            %If Preferred Direction is checked, add it to the data file
            if get(this.Figure.prefdInFile,'Value')==1
                checks=checks+1;
                PDnum=checks;
                headerstr = strcat(headerstr,'PrefD\t ');
                formatstr = strcat(formatstr,'%2.2f\t');
                t=1;
                forOutPD = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutPD(t,1) = this.forCentDeg(i,j)+90;  %Create column of Preferred Direction to append
                        t=t+1;
                    end
                end 
                this.transOUT(PDnum,:)=forOutPD;
            end
            %If Skew is checked, add it to the data file
            if get(this.Figure.skewInFile,'Value')==1
                checks=checks+1;
                Snum=checks;
                headerstr = strcat(headerstr,'Skew\t ');
                formatstr = strcat(formatstr,'%3.3f\t');
                t=1;
                forOutSkew = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutSkew(t,1) = this.forDistSkew(i,j);  %Create column of Skew to append
                        t=t+1;
                    end
                end 
                this.transOUT(Snum,:)=forOutSkew;
            end
            %If Kurtosis is checked, add it to the data file
            if get(this.Figure.kurtosisInFile,'Value')==1
                checks=checks+1;
                Knum=checks;
                headerstr = strcat(headerstr,'Kurtosis\t ');
                formatstr = strcat(formatstr,'%3.3f\t');
                t=1;
                forOutKurtosis = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutKurtosis(t,1) = this.forDistKurt(i,j);  %Create column of Kurtosis to append
                        t=t+1;
                    end
                end 
                this.transOUT(Knum,:)=forOutKurtosis;
            end
            %If Coeff is checked, add it to the data file
            if get(this.Figure.coeffInFile,'Value')==1
                checks=checks+1;
                Cnum=checks;
                headerstr = strcat(headerstr,'Coeff\t ');
                formatstr = strcat(formatstr,'%3.3f\t');
                t=1;
                forOutcoeff = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutcoeff(t,1) = this.correlationCoeff(i,j);  %Create column of coeff to append
                        t=t+1;
                    end
                end
                this.transOUT(Cnum,:)=forOutcoeff;
            end
            %If Tensor is checked, add it to the data file 
            if get(this.Figure.tensorInFile,'Value')==1
                checks=checks+1;
                Tnum=checks;
                headerstr = strcat(headerstr,'h11\t h12\t h21\t h22\t');
                formatstr = strcat(formatstr,'       %2.3f\t%2.3f\t  %2.3f\t  %2.3f\t');
                t=1;
                forOutTensor1 = zeros(this.totalnodes,1);
                forOutTensor2 = zeros(this.totalnodes,1);
                forOutTensor3 = zeros(this.totalnodes,1);
                forOutTensor4 = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutTensor1(t,1) = this.htens1(i,j); 
                        forOutTensor2(t,1) = this.htens2(i,j); 
                        forOutTensor3(t,1) = this.htens2(i,j); 
                        forOutTensor4(t,1) = this.htens4(i,j); %Create column of Tensors to append
                        t=t+1;
                    end
                end 
                this.transOUT(Tnum,:)=forOutTensor1;
                this.transOUT(Tnum+1,:)=forOutTensor2;
                this.transOUT(Tnum+2,:)=forOutTensor3;
                this.transOUT(Tnum+3,:)=forOutTensor4;
            end
            %Saving the file
            trial=inputdlg('What is the sectioning thickness of your specimen? (in microns)');
            secThick=str2num(char(trial));
            [transfile,transfilepath]=uiputfile('*.txt','Please select an output path (Format: Section#_SampleName)');
            transfile=strcat(transfile(1,1:end-4),'_',num2str(secThick),'.txt');
            transfull=fullfile(transfilepath,transfile);
            f=fopen(transfull,'w');
            fprintf(f,'%d\t %d\n',this.input_size);
            headerstr = strcat(headerstr,'\n');
            fprintf(f,headerstr);
            formatstr = strcat(formatstr,'\n');
            fprintf(f,formatstr,this.transOUT);
            fclose(f);
            set(this.Figure.outputPath,'String',transfull);
            msgbox('Transmural File Save Completed');
        end
        
        function configTransPos(this)
            this.forOutX=this.pos(:,2);
            this.transOUT(2,:)=this.forOutX;
            tempy=ones(this.input_size(1,1),this.input_size(1,2));
            tempyy=[];
            for i=1:1:this.input_size(1,1);
                tempy(i,:)=this.pos(i,1);
            end
            for i=1:1:this.input_size(1,2);
                tempyy=[tempyy,transpose(tempy(:,i))];
            end
            this.forOutY=tempyy;
            this.transOUT(3,:)=this.forOutY;
%             set(this.Figure.mainData,'Data',tempyy);
        end
         
        function bwList(this)        
            outputBW(this);
            i=1;
             for numx=1:this.input_size(1,2)
                for numy=1:this.input_size(1,1)
                        tempmatrix(1,i)=this.forBWOut(numy,numx);
                        i=i+1;
                end
             end
             this.transOUT(4,:)=tempmatrix';
        end
        %Finds out how many checkboxes are checked and returns that +4
        function checks = findchecks(this)
            checks = 4;
            if get(this.Figure.OIinFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.baselineInFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.maxiInFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.prefdInFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.skewInFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.kurtosisInFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.coeffInFile,'Value')==1
                checks=checks+1
            end
            if get(this.Figure.tensorInFile,'Value')==1
                checks=checks+4;
            end
        end
        
        %%
        function tecplotUI(this,src,event);
            this.Tec = guihandles(TECPLOT_UI);
            set(this.Tec.bmpReg,'callback', @(src,event) bmpRegistration(this,src,event));
            set(this.Tec.xyReg,'callback', @(src,event) xyRegistration(this,src,event));
            set(this.Tec.addTec,'callback', @(src,event) addTecplotDataSet(this,src,event));
            set(this.Tec.appendTec,'callback', @(src,event) appendTecplot(this,src,event));
            set(this.Tec.createTec,'callback', @(src,event) createTecplot(this,src,event));
            
        end
        
      function bmpRegistration(this,src,event);
            [picFile, picFilePath] = uigetfile('*.tif','Select an Original (aka not Transformed) Fiji Picture')
            origPic= imread(fullfile(picFilePath,picFile)); %Read in pic to determine pixel size for later comparison
            imagesize=size(origPic);
            X=imagesize(1,2);
            Y=imagesize(1,1);
            NamesArray(1,:)=strsplit(picFile(1,1:(end-4)),'_'); %Separate the picture name file to obtain section number
%             SourceSliceNum=str2num(char(NamesArray(1,1))); %Determine the slice number of the Source Pic
            SourceSliceNum=char(NamesArray(1,1)); %The first part of the name must be section number. Determine the slice number of the Source Pic

            %Read in xml files
            path =uigetdir('C:/','Please select the XML transforms folder'); 
            files = dir([path '/*.xml']); %Grabs all the xml files in the selected folder
            sourcefile=dir([path strcat('/*',SourceSliceNum,'*')]); %Determines the xml slice that is the same section as source picture
            for i=1:size(files)
                if isequal(files(i,:).name,sourcefile.name)
                    SourceIndexNum=i;   %Grabs index number of the source file
                else              
                    filelist(i,:)=char(files(i,:).name); %Creates character array of list of files that does not include source file
                end
            end
            filelist(SourceIndexNum,:)=[]; %Clear a space in the filelist for the source picture
%             sourcePicture=textread(strcat(path,'/',filelist(1,:)),'%s','delimiter','"'); %Grabs the transform from the picture that was used as the source for the transforms. Currently the default source is the first picture
%             sourceTransform = str2num(char(sourcePicture(4,1))); %Grabs the correct transform
            for a=1:(size(filelist))
                Picture(a,:)=textread(strcat(path,'/',filelist(a,:)),'%s','delimiter','"');
            end
            Transform = [str2num(char(Picture(:,5))) str2num(char(Picture(:,12)))];
%             finalTransform = [Transform(:,1) Transform(:,2) Transform(:,3) Transform(:,4) Transform(:,5)]; %Final output is [theta tx ty]
            TransSize = size(Transform);
            SourceTransform = [zeros(1,TransSize(2))]; %Creates a zero array for later insertion into the source pictures place in the transform array
            finalTransform = cat(1,Transform(1:SourceIndexNum-1,:),SourceTransform,Transform(SourceIndexNum:end,:)); %Inserts the zeroed matrix into the transform list
           
            %Bitmap reader
            path = uigetdir('C:/','Please select the Transmural SALS file folder'); %
            files = dir([path '/*.txt']);
            

            fid=fopen(strcat(path,'/',files(1).name)); %Read in the first file to obtain row and column information
            ftext=fread(fid,'*char')'; %Read in as character string
            teststring=strsplit(ftext,'\t'); %Split the string based on tab
            teststring=ftext;
            splitTest=char(strsplit(teststring(1,:),'\n')); %Split the string based on rows
            rowcol=str2num(splitTest(1,:)); %Choose first row 
            rowcolString=length([num2str(rowcol(1,1)) num2str(rowcol(1,2))])+3; %Determine the length of the row/col line
            variable= strsplit(char(splitTest(2,:)),'\t'); %Split the variables by using the spaces, so we can quantify the total number
            variable=variable(1,1:end-1);
%             totalrow= rowcol(1,1)*rowcol(1,2);
            x=rowcol(1,2);
            y=rowcol(1,1);

%             variableArray=strsplit(ftext(1,rowcolString:end),'\n'); %Split the string of variables from the data using the # symbol. Start at 7 to eliminate the row and column data at beginning of file
%             variableArray=strjoin(cell(variableArray(1,3:end)));

            Names=sort_nat({files(:).name});
            for a=1:(length(Names))
                fid=fopen(strcat(path,'/',Names{a}));
                variableftext=fread(fid,'*char')';
                variableArray=strsplit(variableftext(1,rowcolString:end),'\n'); %Split the string of variables from the data using the # symbol. Start at 7 to eliminate the row and column data at beginning of file
                variableArray=strjoin(cell(variableArray(1,3:end)));
                mydata =sscanf(char(variableArray(1,1:end)),'%e',[length(variable),inf])';

                fclose(fid);

                for var=1:length(variable)
                    flipped = (flipud(reshape(mydata(:,var),y,x))); %Reshapes the data so that it is in Bitmap Format
                    BitArray(:,:,a,var)=flipped; %Takes reshaped data for all the slices and combines them 

                end
%                 BitArray2=BitArray(:,:,:,4:end);
            end

            exp=1;  %expansion factor

            [L,W]=size(finalTransform);
         if isequal(W,5) %Checks to make sure that the Rigid Transformation was selected
            for i=1:L
            %for i=1:2
            %Create a for loop made up of conditional statements. Ie have it cycle through
            %each of the headers and if the header is present then have it create the
            %variables
                theta=finalTransform(i,1);
                tx=finalTransform(i,2)*x/X*exp;
                ty=finalTransform(i,3)*y/Y*exp;
                angle=theta;
                sc = cos(angle);
                ss = sin(angle);

                T1 = [  sc   -ss  0;
                        ss    sc  0;
                        ty    tx  1];

                angle=0;
                tx=finalTransform(i,4)*x/X*exp;
                ty=finalTransform(i,5)*y/Y*exp;
                sc = cos(angle);
                ss = sin(angle);

                T2 = [  sc   -ss  0;
                        ss    sc  0;
                        ty    tx  1];


                Tform1=maketform('affine',T1);
                Tform2=maketform('affine',T2);
                R=makeresampler('cubic','fill');

                for variablecount=4:length(variable) %Calcs the kron for each of the variables
                     KronArray2(:,:,i,variablecount-3)=kron(BitArray(:,:,i,variablecount),ones(exp,exp)); %Apply kronecker delta expansion, in case we need to increase the number of points

                    if isequal(char(variable(:,variablecount)),' PrefD')
                        JArray2(:,:,i,variablecount-3)=tformarray(KronArray2(:,:,i,variablecount-3),Tform1,R,[1 2],[1 2],[y*exp x*exp],[],[])+theta;  
                        JArray1(:,:,i,variablecount-3)=tformarray(JArray2(:,:,i,variablecount-3),Tform2,R,[1 2],[1 2],[y*exp x*exp],[],[]+theta);  
                        flipped=flipud(reshape(JArray1(:,end:-1:1,i,variablecount-3),x*y,1));
                        JReformat(:,variablecount-3,i)=flipped(:,1);
                    else
                        JArray2(:,:,i,variablecount-3)=tformarray(KronArray2(:,:,i,variablecount-3),Tform1,R,[1 2],[1 2],[y*exp x*exp],[],[]);  
                        JArray1(:,:,i,variablecount-3)=tformarray(JArray2(:,:,i,variablecount-3),Tform2,R,[1 2],[1 2],[y*exp x*exp],[],[]);  
                        flipped=flipud(reshape(JArray1(:,end:-1:1,i,variablecount-3),x*y,1));
                        JReformat(:,variablecount-3,i)=flipped(:,1);
                    end

                end

            end
            NewerBit(:,:,1)=[reshape(flipud(BitArray(:,:,1,1)),x*y,1) reshape(flipud(BitArray(:,:,1,2)),x*y,1) flipud(reshape(BitArray(end:-1:1,:,1,3),x*y,1))]; %Obtains original Node, X, and Y info from slices
            NewestBit=repmat(NewerBit,[1 1 length(Names)]); %Replicates Node,X,Y info for each slice
            Array=cat(2,NewestBit,JReformat); %Join the Node,X,Y with the Variable info
            transfilepath2=uigetdir('*/','Please select an output path');
            for i=1:length(Names)
                SliceName=char(Names(1,i));
                NamesArray1(i,:)=strsplit(SliceName(1,1:(end-4)),'_');
%                 NamesArray(i,:)=strsplit(SliceName(1,1:(end-4)),'_');
                transfile=char(strcat(SliceName(1,1:end-4),'_BMPReg.txt'));
%                 transfile=char(strcat(strjoin(NamesArray(i,2:end),'_'),'_BMPReg.txt'));
                transfull=fullfile(transfilepath2,transfile);

                f=fopen(transfull,'w');

                fprintf(f,'%d\t %d\n',y,x);
                fprintf(f,strcat(strjoin(variable(1,1:end),'\t '),' \n')); %Creates variable string
                dlmwrite (transfull, Array(:,:,i),'precision', 8, 'delimiter','\t', '-append');


                fclose(f);
            end
            else
               error('The wrong transform was applied to the pictures. You need to select a rigid transformation');               
            end
            
           set(this.Tec.transText,'String',fullfile(transfilepath2,transfile));
        end
        
        function xyRegistration(this,src,event);
            [picFile, picFilePath] = uigetfile('*.tif','Select an Original (aka not Transformed) Fiji Picture')
            origPic= imread(fullfile(picFilePath,picFile));
            imagesize=size(origPic);
            XO=imagesize(1,2);
            YO=imagesize(1,1);
            NamesPicArray(1,:)=strsplit(picFile(1,1:(end-4)),'_');
            SourceSliceNum=char(NamesPicArray(1,1)); %Determine the slice number of the Source Pic

            %Read in xml files
            path =uigetdir('C:/','Please select the XML transforms folder'); 
            files = dir([path '/*.xml']);
            sourcefile=dir([path strcat('/*',SourceSliceNum,'*')]);
            for i=1:size(files)
                if isequal(files(i,:).name,sourcefile.name)
                    SourceIndexNum=i;
                else              
                    filelist(i,:)=char(files(i,:).name);
                end
            end
            filelist(SourceIndexNum,:)=[];
            sourcePicture=textread(strcat(path,'/',filelist(1,:)),'%s','delimiter','"'); %Grabs the transform from the picture that was used as the source for the transforms. Currently the default source is the first picture
            sourceTransform = str2num(char(sourcePicture(4,1))); %Grabs the correct transform
            for a=1:(size(filelist))
                Picture(a,:)=textread(strcat(path,'/',filelist(a,:)),'%s','delimiter','"');
            end
            Transform = [str2num(char(Picture(:,5))) str2num(char(Picture(:,12)))];
%             finalTransform = [Transform(:,1) Transform(:,2) Transform(:,3) Transform(:,4) Transform(:,5)]; %Final output is [theta tx ty]
            TransSize = size(Transform);
            SourceTransform = [zeros(1,TransSize(2))];
            finalTransform = cat(1,Transform(1:SourceIndexNum-1,:),SourceTransform,Transform(SourceIndexNum:end,:));
           
            % Read in analyzed SALS data
            path = uigetdir('C:/','Please select the Analyzed SALS data'); %
            files = dir([path '/*.txt']);
            Names=sort_nat({files(:).name});

            fid=fopen(char(fullfile(path,Names(1)))); %For Mac Users
%             fid=fopen(char(strcat(path,'\',Names(1))));
            st=fread(fid,'*char')';
            scansize=sscanf(st,'%e',[2,1])';
            x=scansize(2);
            y=scansize(1);
            teststring=st;
            splitTest=char(strsplit(teststring(1,:),'\n'));
            variable= strsplit(char(splitTest(2,:)),'\t'); %Split the variables by using the spaces, so we can quantify the total number
            variable= variable(1,1:end-1);
            fclose(fid);


            for a = 1:length(files)
%                 filename=char(strcat(path,'\',Names(a)));
                filename=char(fullfile(path,Names(a)));
                fid=fopen(filename);
                st=fread(fid,'*char')';
                teststring=st;
                splitTest=char(strsplit(teststring(1,:),'\n'));
                variableArray=strjoin(cellstr(splitTest(3:end,:))');
                data =sscanf(char(variableArray(1,1:end)),'%e',[length(variable),inf])';

                  for varCount = 1:length(variable)
                      varData(a,varCount,:)=data(:,varCount);
                 end
            end

            varData=permute(varData(:,:,:),[1 3 2]);
            maxX2=max(max(varData(:,:,2)));
            minX2=min(min(varData(:,:,2)));
            maxY2=max(max(varData(:,:,3)));
            minY2=min(min(varData(:,:,3)));

            X2=maxX2-minX2;
            Y2=maxY2-minY2;

            [L,W]=size(finalTransform);
         if isequal(W,5)

%             for i=1:length(finalTransform)
              for i=1:L
                theta=finalTransform(i,1);
                tx=finalTransform(i,2)*(X2)/XO;
                ty=finalTransform(i,3)*(Y2)/YO;
                angle=theta+0*pi/180;
                sc = cos(angle);
                ss = sin(angle);

                T1 = [  sc	-ss	0;
                        ss  sc	0;
                        ty	tx	1];

                angle=0;
                tx=finalTransform(i,4)*X2/XO;
                ty=finalTransform(i,5)*Y2/YO;
                sc = cos(angle);
                ss = sin(angle);

                T2 = [  sc	-ss	0;
                        ss	sc	0;
                        ty	tx	1];



                Tform1=maketform('affine',T1);
                Tform2=maketform('affine',T2);
                XY3=[abs(varData(i,:,3)-maxY2); abs(varData(i,:,2)); ones(1,length(varData))];
                XY4=T1'*XY3;
                XY5=T2'*XY4;
                Out2(:,:,i)=[varData(i,:,1)' (abs(varData(i,:,3)-maxY2))' varData(i,:,2)' XY5(1,:)' XY5(2,:)'];
                for k=4:length(variable)
                    Out3(:,:,i)=[varData(i,:,k)'];
                    Out6(:,k-4+1,i)=Out3(:,:,i);
                end    
            end
            Out2=[Out2 Out6];

%             sliceArray(1,:)=strsplit(filelist(1,:),'_'); %Split the string array using underscores, the title MUST begin with the slice number
            transfilepath=uigetdir('*/*','Please select an experimental output path');

             tempvar(1,:)=variable(4:end);
             variable(1,4)={'X2pos'}; %Add in the 2nd X variable to the variable list
             variable(1,5)={'Y2pos'}; %Add in the 2nd Y variable to the variable list
             variable(1,6:(5+length(tempvar)))={0};
             variable(1,6:(end))=tempvar(1,:);

            for i=1:length(files)
                SliceName=char(Names(1,i));
                NamesArray(i,:)=strsplit(SliceName(1,1:(end-4)),'_');

%                 transfile=char(strcat(strjoin(NamesArray(i,2:end),'_'),'_XYEdits.txt'));
                transfile=char(strcat(SliceName(1,1:end-4),'_XYEdits.txt'));
                transfull=fullfile(transfilepath,transfile);

                f=fopen(transfull,'w');

                fprintf(f,'%d\t %d\n',scansize(1),scansize(2));
                fprintf(f,strcat(strjoin(variable(1,1:end),'\t '),' \n'));
                dlmwrite (transfull, Out2(:,:,i),'precision', 8, 'delimiter','\t', '-append');

                fclose(f);
            end
             else
               error('The wrong transform was applied to the pictures. You need to select a rigid transformation');               
            end
            set(this.Tec.transText,'String',transfilepath);

        end
        
        function createTecplot(this,src,event)
            stringSepName=get(this.Tec.sampName,'String');
            if isequal(stringSepName,'Input Sample Name')
                transPath =uigetdir('C:\','Select the folder containing the 3D SALS Files'); %Select the folder with the 3D SALS fles
                transFiles = dir([transPath '/*.txt']);
                 filelist = sort_nat(cellstr(char(transFiles(1:end,:).name)));%Sort the list of file names from 1-n slicse
                 sliceArray=strsplit(filelist{1},'_') %Split the string array using underscores, the title MUST begin with the slice number
                 fid=fopen(fullfile(transPath,filelist{1}))
                 string=fread(fid,'*char'); %Read the 2D slice data in as a string
                 splitTest=char(strsplit(string(:,1)','\n'));
                 rowcol=str2num(splitTest(1,:));
                 rowcolString=length([num2str(rowcol(1,1)) num2str(rowcol(1,2))])+3;
                 variable= strsplit(char(splitTest(2,:)),'\t'); %Split the variables by using the spaces, so we can quantify the total nnumber
                 totalrow= rowcol(1,1)*rowcol(1,2);
                 mm=1;
                for slice = 1:length(filelist) 
                         sliceArray2(slice,:)=strsplit(filelist{slice},'_') %Split the string array using underscores, the title MUST begin with the slice number
                         fid=fopen(fullfile(transPath,filelist{slice}));
                         string=fread(fid,'*char'); %Read the 2D slice data in as a string
                         variableArray=strsplit(string(rowcolString:end,1)','\n'); %Split the string of variables from the data using the # symbol. Start at 7 to eliminate the row and column data at beginning of file
                         variableArray=strjoin(variableArray(1,3:end));
                         data =sscanf(char(variableArray(1,1:end)),'%e',[length(variable),inf])';
                         zcoord = (str2double((sliceArray2(slice,1)))-1)*(str2double(sliceArray2(slice,3))*.001);      %  To get the section number
                         for ka=1:totalrow        %Counter in the total file from 1 to the lastrow
                                ALL(mm,1) = mm;
                                ALL(mm,2:3)=data(ka,2:3);
                                ALL(mm,4) = zcoord;
                                ALL(mm,5) = data(ka,4);
                                ALL(mm,6:(length(variable)+1))= data(ka,5:length(variable));
                                mm= mm+1;       
                          end 
                end
                button2 = questdlg('Is this your final Tecplot File?');
                if isequal(button2,'Yes')
                sections = length(filelist);

                variable(1,5:(end+1))=variable(4:end);
                variable(1,4)={'Zpos'}; %Add in the Z variable to the variable list

                [tranSALoutfile,tranSALoutfolder]=uiputfile('*.plt','Please select an output path for the Tecplot Reconstruction');
                f=fopen((strcat(tranSALoutfolder,tranSALoutfile)),'w'); %Need to write a variable output name
                fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n')
                fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"')); 
                fprintf(f,'ZONE I= %s, J= %s, K=%s, DATAPACKING=POINT \n', num2str(rowcol(1,1)),num2str(rowcol(1,2)),num2str(sections));
                dlmwrite ((fullfile(tranSALoutfolder,tranSALoutfile)), ALL, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
                set(this.Tec.transText,'String',fullfile(tranSALoutfolder,tranSALoutfile));

                else    
                 [tranSALoutfile,tranSALoutfolder]=uiputfile('*.txt','Please select an output path for the Tecplot Reconstruction');
                 dlmwrite ((strcat(tranSALoutfolder,tranSALoutfile(1,1:(end-4)),'_',char(sliceArray2(1,1)),'_',char(sliceArray2(end,1)),'_slicenumbers.txt')), ALL,'precision', 8, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
                 disp ('Done, open the file in notepad and save it as "filename.plt"');   
                 set(this.Tec.transText,'String',strcat(tranSALoutfolder,tranSALoutfile(1,1:(end-4)),'_',char(sliceArray2(1,1)),'_',char(sliceArray2(end,1)),'_slicenumbers.txt'));

                end
                
            else
             separateString=strcat('/*',stringSepName,'*')
             transPath =uigetdir('C:\','Select the folder containing the 3D SALS Files'); %Select the folder with the 3D SALS fles
             transFiles = dir([transPath separateString])
             filelist = sort_nat(cellstr(char(transFiles(1:end,:).name)));%Sort the list of file names from 1-n slicse
             sliceArray=strsplit(filelist{1},'_') %Split the string array using underscores, the title MUST begin with the slice number
             fid=fopen(fullfile(transPath,filelist{1}))
             string=fread(fid,'*char'); %Read the 2D slice data in as a string
             splitTest=char(strsplit(string(:,1)','\n'));
             rowcol=str2num(splitTest(1,:));
             rowcolString=length([num2str(rowcol(1,1)) num2str(rowcol(1,2))])+3;
             variable= strsplit(char(splitTest(2,:)),'\t'); %Split the variables by using the spaces, so we can quantify the total nnumber
             totalrow= rowcol(1,1)*rowcol(1,2);
             mm=1;
            for slice = 1:length(filelist) 
                     sliceArray2(slice,:)=strsplit(filelist{slice},'_') %Split the string array using underscores, the title MUST begin with the slice number
                     fid=fopen(fullfile(transPath,filelist{slice}));
                     string=fread(fid,'*char'); %Read the 2D slice data in as a string
                     variableArray=strsplit(string(rowcolString:end,1)','\n'); %Split the string of variables from the data using the # symbol. Start at 7 to eliminate the row and column data at beginning of file
                     variableArray=strjoin(variableArray(1,3:end));
                     data =sscanf(char(variableArray(1,1:end)),'%e',[length(variable),inf])';
                     zcoord = (str2double((sliceArray2(slice,1)))-1)*(str2double(sliceArray2(slice,3))*.001);      %  To get the section number
                     for ka=1:totalrow        %Counter in the total file from 1 to the lastrow
                            ALL(mm,1) = mm;
                            ALL(mm,2:3)=data(ka,2:3);
                            ALL(mm,4) = zcoord;
                            ALL(mm,5) = data(ka,4);
                            ALL(mm,6:(length(variable)+1))= data(ka,5:length(variable));
                            mm= mm+1;       
                      end 
            end
            button2 = questdlg('Is this your final Tecplot File?');
            if isequal(button2,'Yes')
            sections = length(filelist);

            variable(1,5:(end+1))=variable(4:end);
            variable(1,4)={'Zpos'}; %Add in the Z variable to the variable list

            [tranSALoutfile,tranSALoutfolder]=uiputfile('*.plt','Please select an output path for the Tecplot Reconstruction');
            f=fopen((strcat(tranSALoutfolder,tranSALoutfile)),'w'); %Need to write a variable output name
            fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n')
            fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"')); 
            fprintf(f,'ZONE I= %s, J= %s, K=%s, DATAPACKING=POINT \n', num2str(rowcol(1,1)),num2str(rowcol(1,2)),num2str(sections));
            dlmwrite ((fullfile(tranSALoutfolder,tranSALoutfile)), ALL, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
            set(this.Tec.transText,'String',fullfile(tranSALoutfolder,tranSALoutfile));

            else    
             [tranSALoutfile,tranSALoutfolder]=uiputfile('*.txt','Please select an output path for the Tecplot Reconstruction');
             dlmwrite ((strcat(tranSALoutfolder,tranSALoutfile(1,1:(end-4)),'_',char(sliceArray2(1,1)),'_',char(sliceArray2(end,1)),'_slicenumbers.txt')), ALL,'precision', 8, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
             disp ('Done, open the file in notepad and save it as "filename.plt"');   
             set(this.Tec.transText,'String',strcat(tranSALoutfolder,tranSALoutfile(1,1:(end-4)),'_',char(sliceArray2(1,1)),'_',char(sliceArray2(end,1)),'_slicenumbers.txt'));

            end
          end
        end
        
        function addTecplotDataSet(this,src,event);
        [exFile, exFilePath]=uigetfile('\*.txt','Choose the SALSA file of the first slice in this data set');
        path =uigetdir(exFilePath,'Select the Folder with the SALS Subset Files You Wish To Add Together');
        separateString='/*slicenumbers*';                 %This is the string that will be used to separate out the 3D files from the rest
        files = dir([path separateString]);
        filelist = sort_nat(cellstr(char(files(1:end,:).name)));%Sort the list of file names from 1-n slices
            fid=fopen(fullfile(exFilePath,exFile));
            string=fread(fid,'*char'); %Read the 2D slice data in as a string
            splitTest=char(strsplit(string(:,1)','\n'));
            rowcol=str2num(splitTest(1,:));
            rowcolString=length([num2str(rowcol(1,1)) num2str(rowcol(1,2))])+3;
            variable= strsplit(char(splitTest(2,:)),'\t'); %Split the variables by using the spaces, so we can quantify the total nnumber
            totalrow= rowcol(1,1)*rowcol(1,2);

        mm=1;
        newdata=[];
%         sliceArray=strsplit(filelist{1},'_') %Split the string array using underscores, the title MUST begin with the slice number
        K=0;
        for slice = 1:length(filelist);
                 sliceArray(slice,:)=strsplit(filelist{slice},'_') %Split the string array using underscores, the title MUST begin with the slice number
                 data =dlmread(fullfile(path,filelist{slice}));
                 data(:,1)= data(:,1)+((slice-1).*length(data)); %Renumbers the nodes depending on the slice number
                 newdata=[newdata; data];
                 tempK=str2num(char(sliceArray(slice,3)))-str2num(char(sliceArray(slice,2)))+1;
                 K=K+tempK;
        end
            variable(1,5:(end+1))=variable(4:end);
            variable(1,4)={'Zpos'}; %Add in the Z variable to the variable list


%Mac Version            
%             f=fopen((strcat(path,'/',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt')),'w'); %Need to write a variable output name
%             dlmwrite((strcat(path,'/',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt')), newdata,'precision', 8, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
%             set(this.Tec.transText,'String',strcat(path,'/',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt'));
            
            f=fopen((strcat(path,'\',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt')),'w'); %Need to write a variable output name
            fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n');
            fprintf(f,strcat('VARIABLES = ','"',strjoin(variable(1,1:end),'", "'),'"')); 
            fprintf(f,'ZONE I= %s, J= %s, K=%s, DATAPACKING=POINT \n', num2str(rowcol(1,1)),num2str(rowcol(1,2)),num2str(K));
            dlmwrite((strcat(path,'\',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt')), newdata,'precision', 8, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
            set(this.Tec.transText,'String',strcat(path,'\',char(sliceArray(1,1)),'_add_',num2str(K),'slice.plt'));

        end
         
        function appendTecplot(this,src,event);
            [appFile, appFilePath]=uigetfile('\*.plt','Pick a Tecplot File to Append to');
            fid2=fopen(fullfile(appFilePath,appFile))
            string2=fread(fid2,'*char'); %Read the 2D slice data in as a string
            splitTestCheck=char(strsplit(string2(:,1)',{'\n'}));
            variableList= strsplit(char(splitTestCheck(2,:)),{'VARIABLES =','ZONE'}); %Split the variables by using the spaces, so we can quantify the total nnumber
            variable= strsplit(char(variableList(:,2)),'", "')
            IJKValues= strsplit(splitTestCheck(2,:),{'I=','J=','K=',',',' '})'; %Isolate the I, J, and K values
            I=str2num(cell2mat(IJKValues(end-4,:)));
            J=str2num(cell2mat(IJKValues(end-3,:))); 
            K=str2num(cell2mat(IJKValues(end-2,:)));
            totalrow=I*J;
            mm=totalrow*K+1;
            rowcolString=length([I J])+5;
            variableArray=strsplit(string2(rowcolString:end,1)','\n'); %Split the string of variables from the data using the # symbol. Start at 7 to eliminate the row and column data at beginning of file
            variableArray=strjoin(variableArray(1,3:end));
            ORIG =sscanf(char(variableArray(1,1:end)),'%e',[length(variable),inf])';

            count=1;
            [appedFile, appedFilePath]=uigetfile('\*.txt','Pick the SALS Data Files to Append to the end of the Tecplot Code','MultiSelect', 'on');
            files=appedFile'
            for slice = 1:length(files) 
%             filelist = sort_nat(cellstr(char(files)));%Sort the list of file names from 1-n slicse
                newfiles=cellstr(files');
                 sliceArray=strsplit(char(newfiles(1,slice)),'_')
%                  sliceArray=char(newfiles(slice,:));
                 fid=fopen(fullfile(appedFilePath,char(newfiles(1,slice))));
                 string=fread(fid,'*char'); %Read the 2D slice data in as a string
                 variableArray=strsplit(string(rowcolString:end,1)','\n'); %Split the string of variables from the data using the # symbol. Start at 7 to eliminate the row and column data at beginning of file
                 variableArray=strjoin(variableArray(1,3:end));
                 data =sscanf(char(variableArray(1,1:end)),'%e',[length(variable)-1,inf])';
                 zcoord = (str2double((sliceArray(1,1)))-1)*(str2double(sliceArray(1,3))*.001);      %  To get the section number
                 for ka=1:totalrow        %Counter in the total file from 1 to the lastrow
                        ALL(count,1) = mm;
                        ALL(count,2:3)=data(ka,2:3);
                        ALL(count,4) = zcoord;
                        ALL(count,5) = data(ka,4);
                        ALL(count,6:length(variable))= data(ka,5:(length(variable)-1));
                        mm= mm+1;
                        count=count+1;
                 end 
            end
            K=K+length(files);
            TOTAL = [ORIG; ALL];
            f=fopen((strcat(appFilePath,appFile(1,1:(end-4)),'_append_',num2str(K),'slice.plt')),'w'); %Need to write a variable output name
            fprintf(f,'TITLE= "FE-Volume_Brick_Data" \n');
            fprintf(f,strcat('VARIABLES = ',strjoin(variable(1,1:end),'", "'))); 
            fprintf(f,'ZONE I= %s, J= %s, K=%s, DATAPACKING=POINT \n', num2str(I),num2str(J),num2str(K));
            dlmwrite((strcat(appFilePath,appFile(1,1:(end-4)),'_append_',num2str(K),'slice.plt')), TOTAL,'precision', 8, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number            
%             dlmwrite ((fullfile(appFilePath,appFile)), ALL, 'delimiter','\t', '-append');  % All the sections are in the file with consecutive ID number
             set(this.Tec.transText,'String',strcat(appFilePath,appFile(1,1:(end-4)),'_append_',num2str(K),'slice.plt'));

        end

    end
    
end



