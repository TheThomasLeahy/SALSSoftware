%SALS Analyis Program
%Object Oriented Matlab Code w/ Guide Implemented GUI
%Written by John Lesicko, Jordan Graves and Thomas Leahy

% Additions for Transumral SALS 

classdef SALSAnalysis_v2 <handle
    
    
    %create properties for the class
    properties (Access = public)
        %gui stuff?
        Figure
        Pop
        
        %file location stuff?
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
        numDegrees = 360;
        radList
        
        %radian distance
        distRads=genRadsList(0,180);
        %NxN identity matrix
        KronDel=eye(2);
        
        %angle for PD
        centroidTheta
        
        %what is cent? also have max color, bl color, linear/natural log
        %avg, and oi color
        meanData_ODF
        meanData_ODD
        oiData_ODF
        oiData_ODD
        skew_ODD
        skew_ODF
        kurtosis_ODD
        kurtosis_ODF
        correlationCoeff

        
        forCent
        forCentDeg
        forMaxColor
        forBLColor
        forLnAvg
        
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
        
        forDegAng
        forPeaks
        
        currentColor;
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
        
        data_points
        
        colorGraphRangeMap
        dataMap
        colorGraphColorMap
        colorGraphColorStringsMap
    end
    
    methods
        
        %get the 
        function this = SALSAnalysis_v2
            %Create the objects on the figure
            this.Figure = guihandles(SALSAnalysis_GUI);
            
            % Change the current folder to the folder of this m-file.
            if(~isdeployed)
                cd(fileparts(which(mfilename)));
            end
            
            addpath(genpath('..'));
            
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
            set(this.Figure.quiverButton, 'callback', @(src, event) reDraw2(this, 0, 'quiverchange'));
%             set(this.Figure.bwOutButton, 'callback', @(src, event) outputBW(this));
%             set(this.Figure.outTrans, 'callback', @(src, event) transmuralOutput(this));
%             set(this.Figure.OIinFile, 'callback', @(src, event) reDraw(this, 0, 'OIinFile'));
%             set(this.Figure.baselineInFile, 'callback', @(src, event) reDraw(this, 1, 'baselineInFile'));
%             set(this.Figure.maxiInFile, 'callback', @(src, event) reDraw(this, 0, 'maxiInFile'));
%             set(this.Figure.prefdInFile, 'callback', @(src, event) reDraw(this, 0, 'prefdInFile'));
%             set(this.Figure.skewInFile, 'callback', @(src, event) reDraw(this, 0, 'skewInFile'));
%             set(this.Figure.kurtosisInFile, 'callback', @(src, event) reDraw(this, 0, 'kurtosisInFile'));       
%             set(this.Figure.coeffInFile, 'callback', @(src, event) reDraw(this, 0, 'coeffInFile'));
%             set(this.Figure.tensorInFile, 'callback', @(src, event) reDraw(this, 0, 'tensorInFile'));
            set(this.Figure.tecUI, 'callback', @(src, event) tecplotUI(this, src, event));
            
            set(this.Figure.pushbutton15, 'callback', @(src, event) saveToMFile(this, src, event));

            set(this.Figure.popupmenu5, 'callback', @(src, event) colorMapValueSelected(this, src, event));
        
            % default
            str = get(this.Figure.popupmenu5, 'String');
            val = get(this.Figure.popupmenu5, 'Value');
            this.currentColor=str{val};
            
            % Ranges for the color map
            this.colorGraphRangeMap = containers.Map;
            this.colorGraphRangeMap('OI (ODF)') = [0 1];
            this.colorGraphRangeMap('OI (ODD)') = [0 1];
            this.colorGraphRangeMap('PrefD (ODF)') = [-90 90];
            this.colorGraphRangeMap('PrefD (ODD)') = [-90 90];
            this.colorGraphRangeMap('Skew (ODD)') = [-10 10];
            this.colorGraphRangeMap('Skew (ODF)') = [-10 10];
            this.colorGraphRangeMap('Kurtosis (ODD)') = [-1 1];
            this.colorGraphRangeMap('Kurtosis (ODF)') = [-1 1];
            this.colorGraphRangeMap('Max Intensity') = [0 255];
            this.colorGraphRangeMap('Baseline') = [0 255];
            this.colorGraphRangeMap('Correlation Coefficient') = [0 1];
        
            %Colors for the color map
            this.colorGraphColorStringsMap = containers.Map;
            this.colorGraphColorStringsMap('OI (ODF)') = 'jet';
            this.colorGraphColorStringsMap('OI (ODD)') = 'jet';
            this.colorGraphColorStringsMap('PrefD (ODF)') = 'hsv';
            this.colorGraphColorStringsMap('PrefD (ODD)') = 'hsv';
            this.colorGraphColorStringsMap('Skew (ODD)') = 'hsv';
            this.colorGraphColorStringsMap('Skew (ODF)') = 'hsv';
            this.colorGraphColorStringsMap('Kurtosis (ODD)') = 'jet';
            this.colorGraphColorStringsMap('Kurtosis (ODF)') = 'jet';
            this.colorGraphColorStringsMap('Max Intensity') = 'jet';
            this.colorGraphColorStringsMap('Baseline') = 'jet';
            this.colorGraphColorStringsMap('Correlation Coefficient') = 'spring';
            this.colorGraphColorStringsMap('Grey') = 'gray';

            
            %Colors for the color map
            this.colorGraphColorMap = containers.Map;
            this.colorGraphColorMap('OI (ODF)') = jet(1000);
            this.colorGraphColorMap('OI (ODD)') = jet(1000);
            this.colorGraphColorMap('PrefD (ODF)') = hsv;
            this.colorGraphColorMap('PrefD (ODD)') = hsv;
            this.colorGraphColorMap('Kurtosis (ODD)') = jet(1000);
            this.colorGraphColorMap('Skew (ODD)') = hsv(10000);
            this.colorGraphColorMap('Kurtosis (ODF)') = jet(1000);
            this.colorGraphColorMap('Skew (ODF)') = hsv(10000);
            this.colorGraphColorMap('Max Intensity') = jet(1000);
            this.colorGraphColorMap('Baseline') = jet(1000);
            this.colorGraphColorMap('Correlation Coefficient') = spring(1000);
            this.colorGraphColorMap('Grey') = gray;
            
            this.dataMap = containers.Map;
        end
    end
    
    methods (Access=public)
        %% Class deconstructor - handles the cleaning up of the class &
        %figure. Either the class or the figure can initiate the closing
        %condition, this function makes sure both are cleaned up
        function delete(this)
            %remove the closerequestfcn from the figure, this prevents an
            %infinite loop with the following delete command
            set(this.Figure.mainFig,  'closerequestfcn', '');
            delete(this.Figure.mainFig);
            this.Figure = [];
        end
        
        %% function - Close_fcn
        %
        %this is the closerequestfcn of the figure. All it does here is
        %call the class delete function (presented above)
        function this = Close_fcn(this, src, event)        
            delete(this);
        end
        
        %% Function- Open_File
        %
        %this is the text file loader of the application
        %can be called twice, but only after the first call is completed
        %opens the file, pulls the data, separates first line, and throws
        %to app properties origMat and input_size;
        function this = Open_File(this,src,event)
            %Ask for the file
            this.AxesFilled=false;
            [this.salsFile, this.salsFilePath]=uigetfile('\*.txt','Pick a SALS Output File to Analyze');
            set(gcf, 'Pointer', 'watch')
            drawnow;
            if isequal(this.salsFile,0)
                %Some weirdness loading the file
                set(this.Figure.fileChosen,'String','No File Selected');
                set(gcf, 'Pointer', 'arrow')
                drawnow;
                
            else
                %Load the file
                set(this.Figure.fileChosen,'String',strcat(this.salsFilePath,this.salsFile));
                fid=fopen(strcat(this.salsFilePath,this.salsFile),'r');
                st = fread(fid,'*char')';
                
                addpath('../Transmural');
                file_path = strcat(this.salsFilePath,this.salsFile);
                this.data_points = parseSection(file_path);
                
                fclose(fid);
                N=1;
                this.input_size=sscanf(st,'%e',[2,N])';
                data=sscanf(st,'%f',inf)';
                this.origMat=data(3:end);
                
                %Analyze Data
                %Create theta values in radians
                this.radList=0:(pi/180):(2*pi - pi/180);
                %Analyze it
                doAnalysis(this,src);
                
                %Ask for threshold data file
                button = questdlg('Would you like to select a Threshold Data File');
                switch button
                    case 'Yes'
                        loadtrans(this, src, event)
                    case 'No'
%                         set(this.Figure.OIinFile,'Value',1)
%                         set(this.Figure.baselineInFile,'Value',1)
%                         set(this.Figure.maxiInFile,'Value',1)
%                         set(this.Figure.prefdInFile,'Value',1)
%                         set(this.Figure.skewInFile,'Value',1)
%                         set(this.Figure.kurtosisInFile,'Value',1)
%                         set(this.Figure.coeffInFile,'Value',1)
%                         set(this.Figure.tensorInFile,'Value',1)
                    case 'Cancel'
                end 
                
                
            end
        end
       
        %%
        function distshift=splitDistCoord(this,dist,coord)
            if coord<0
                distshift=circshift(dist,[0 -coord]);
            else
                distshift=circshift(dist,[0 -coord]);
            end

        end

        %% function- test array writing to temp file
        function arrayWrite(this,src)
            fID=fopen('tempArray.txt' , 'w');
            fprintf(fID,'%d %d\n',this.input_size);
            fprintf(fID,'%f\n',round((this.oiData*100)));
            fclose(fID);
            initAxes(this,src);
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
                    val = this.oiData(cy,cx);
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
        function activeThresh(this, hObject, eventdata)
            if this.AxesFilled
                %get the threshold from the slider
                this.tval=get(hObject,'Value');
                %update string for threshold value
                set(this.Figure.editCheck,'String',strcat('Threshold Value:   ',int2str(this.tval)));
                
                fillAxes2(this,this.currentColor,this.tval,1,this.quiverOn,1,0);
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
                %pause(2);
                        
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
            xRound=round(xPoints);
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
                        setTissueFlag(this, 1, j,i);
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
                        setTissueFlag(this, 0, j,i);
                    end
                end 
            end
            %update the axes
            fillAxes2(this,this.currentColor,this.tval,1,1,1,0);  
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
                tempoi=[tempoi,transpose(this.oiData(:,(this.input_size(1,2)+1)-i))];
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
        
        %% Save Grayscale Tiff of the the image
        function saveTiff(this, src, event)
            newFileName = strrep(this.salsFile, '.txt', '-TIFF.tif');
            [tiffoutfile,tiffoutfolder]=uiputfile('*.tif','Please select an output path',newFileName);
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
                fillAxes2(this, 'Grey' ,this.tval,1,this.quiverOn,0,0);
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

                thisImage = getframe(Fig_Axes);
                [X, Map] = frame2im(thisImage);
                Z = im2bw(X, Map, 0.05);
                Z = Z(1:(end-1), 1:(end-1));
                ZPrime = imresize(Z,[500 500],'bicubic');
                
                imwrite(ZPrime, tempstr);
                
                %Send that baby off to print
                %export_fig(gca,tempstr,'-grey');

                
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
                    fillAxes2(this, this.currentColor,this.tval,1,this.quiverOn,0,0);
                    axes(this.Figure.mainAxes);
                    axis off;
                    export_fig(this.Figure.mainAxes,tempstr);
                    set(this.Figure.outputPath,'String',tempstr)
                    axes(this.Figure.mainAxes);
                    axis on;
                    this.quiverOn=1;
                    fillAxes2(this, this.currentColor,this.tval,1,this.quiverOn,0,0);
                    h = msgbox('Color Image Save Completed');
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
        
        function saveToMFile(this, src, event)
            newFileName = strrep(this.salsFile, '.txt', '-SALSA.mat');
            
            [fileName,pathName] = uiputfile('\*.mat', 'Save data to .mat',newFileName);
            
            %this.data_points = fixTissueFlag(this.data_points, this.forOIHist);
            
            data_points = this.data_points;
            save(strcat(pathName,fileName), 'data_points');
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



