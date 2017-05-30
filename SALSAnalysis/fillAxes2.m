%% function- fillAxes
%
%this is the vector draw method
%called after doAnalysis completes
function fillAxes2(this,valueToMap,thresh,colorchangeBool,quiverBool,threshBool,rescaleBool)
    
    %Clear axes
    cla(this.Figure.mainAxes);
    
    hold on;
    
    if strcmp(valueToMap,'Grey')
        %If we're doing a greyscale, keep it as it is currently
        stats = this.colorGraphRangeMap(this.currentColor);
    else
        %Not a grayscale, plot the other item
        stats = this.colorGraphRangeMap(valueToMap);
    end

    set(this.Figure.editMaxScale,'String',num2str(stats(2)));
    set(this.Figure.editMinScale,'String',num2str(stats(1)));

    dataForFigure = this.dataMap(this.currentColor);
    
    if ~isempty(strfind(this.currentColor,'PrefD'))
        dataForFigure = dataForFigure*180/pi;
        if max(dataForFigure) > stats(2)
            dataForFigure = dataForFigure - 180;
        elseif min(dataForFigure) < stats(1)
            dataForFigure = dataForFigure + 180;
        end
    elseif strcmp(this.currentColor, 'Baseline') || strcmp(this.currentColor, 'Max Intensity')
        orig_max = max(dataForFigure(:));
        orig_min = min(dataForFigure(:));
        dataForFigure = ((dataForFigure - orig_min) * 255) / (orig_max - orig_min);
    end
    
    colorStringToUse = this.colorGraphColorStringsMap(valueToMap);
    this.colorMap=num2colormap(dataForFigure,colorStringToUse,stats);
    this.img =imagesc(this.colorMap);
    colormap(this.colorGraphColorMap(this.currentColor));
    caxis(stats);
    colorbar;
    this.cDat= get(this.img, 'CData');

    for numx=1:this.input_size(2)
        for numy=1:this.input_size(1)
            %if the threshold is greater than the individual point
            %make it black (cDat), set OI OI, centroid, and max int
            %to -1
            if this.forThresh(numy,numx)<thresh
                this.cDat(numy,numx,:)=[0,0,0];
                this.forOIHist(numy,numx)=-1;
                this.forCentHist(numy,numx)=-1;
                this.forMaxIntHist(numy,numx)=-1;
                
                this = setTissueFlag(this, 0, numx, numy);
                
            else
                this.forOIHist(numy,numx)=this.oiData_ODF(numy,numx);
                this.forCentHist(numy,numx)=this.forCent(numy,numx);
                this.forMaxIntHist(numy,numx)=this.forMaxIntNorm(numy,numx);
                this = setTissueFlag(this,1,numx,numy);
            end
            if this.AxesFilled==false
                this.XQuiv(numy,numx)=cos(this.centroidTheta(numy,numx));
                this.YQuiv(numy,numx)=sin(this.centroidTheta(numy,numx));
                this.Xdat(numy,numx)=this.Xdat(numy,numx)-0.3535*this.XQuiv(numy,numx);
                this.Ydat(numy,numx)=this.Ydat(numy,numx)-0.3535*this.YQuiv(numy,numx);

            end
        end
    end
    set(this.img,'CData',this.cDat);


%             set(this.Figure.blTable,'Data',this.forCentHist);
    if quiverBool==1
%                 if colorval~=4 && colorval~=5 && colorval~=6
        this.qq=quiver(this.Figure.mainAxes,this.Xdat,this.Ydat,this.XQuiv,this.YQuiv,0.6,'k','ShowArrowHead','off','LineWidth',2,'Parent',this.Figure.mainAxes);
        set(this.qq,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
            @(s,e) getMPos(gca,this));
%                 xx3=1
%                 end
    else
        this.qq=quiver(this.Figure.mainAxes,nan,nan,nan,nan);
        set(this.qq,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
            @(s,e) null(this));
%                 xx3=2
    end

    set(this.img,'ButtonDownFcn',...   %# Set the ButtonDownFcn for the image
        @(s,e) getMPos(gca,this));

%             toc
    this.AxesFilled=true;
    hold off;
end
