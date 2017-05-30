%% function- fillAxes
%
%this is the vector draw method
%called after doAnalysis completes
function fillAxes(this,colorval,thresh,colorchangeBool,quiverBool,threshBool,rescaleBool)
    hold on;
    if colorchangeBool==1
        if colorval~=9
           stats=this.forRedrawStats(colorval,:);
        else
            stats=[0 1];
        end

        set(this.Figure.editMaxScale,'String',num2str(stats(2)));
        set(this.Figure.editMinScale,'String',num2str(stats(1)));
        if colorval==1||colorval==0
            % default behavior, no value selected yet by user
            set(this.Figure.popupmenu5,'Value',1);
            
            this.colorMap=num2colormap(this.oiData_ODF,'jet',stats/100.0);
            this.img =imagesc(this.colorMap);
            colormap(jet(1000));
            caxis(stats);
            colorbar;
            this.cDat= get(this.img, 'CData');

        elseif colorval==2
            this.colorMap=num2colormap(this.forBLColor,'jet',stats);
            this.img =imagesc(this.colorMap);
%                 colorbar;
%                 caxis([0 50000]);
            colormap(jet(1000));
            caxis(stats);
            this.cDat= get(this.img, 'CData');


        elseif colorval==3
            this.colorMap=num2colormap(this.forMaxColor,'jet',stats);
            this.img =image(this.colorMap);
            colorbar;
            colormap(jet(1000));
            caxis(stats);
            this.cDat= get(this.img, 'CData');


        elseif colorval==4
            this.colorMap=num2colormap(this.forCentDeg,'hsv',stats);
            this.img =image(this.colorMap);
            colormap(hsv);
            colorbar;
            caxis(stats);
            this.cDat= get(this.img, 'CData');


        elseif colorval==5                    
            this.colorMap=num2colormap(this.forDistKurt,'jet',stats);
            this.img =imagesc(this.colorMap);
%                 colorbar;
%                 caxis([0 50000]);
            colormap(jet(1000));
            caxis(stats);
            this.cDat= get(this.img, 'CData');

        elseif colorval==6
            this.colorMap=num2colormap(this.forDistSkew,'hsv',stats);
            this.img =imagesc(this.colorMap);
%                 colorbar;
%                 caxis([0 50000]);
            colormap(hsv(10000));
            caxis(stats);
            this.cDat= get(this.img, 'CData');

        elseif colorval==7
             this.colorMap=num2colormap(this.symmetryCoeff,'jet',stats);
             this.img =imagesc(this.colorMap);
             colormap(jet(1000));
             caxis(stats);
             colorbar;
             this.cDat= get(this.img, 'CData');

        elseif colorval==8
            this.colorMap=num2colormap(this.correlationCoeff,'spring',stats);
            this.img =imagesc(this.colorMap);
            colormap(spring(1000));
            caxis(stats);
            colorbar;
            this.cDat= get(this.img, 'CData');

         elseif colorval==9
             this.colorMap=num2colormap(this.forGrayOUT,'gray',[0 1]);
             this.img =imagesc(this.colorMap);
             this.cDat= get(this.img, 'CData');
        end
    end


    for numx=1:this.input_size(2)
        for numy=1:this.input_size(1)
            %if the threshold is greater than the individual point
            %make it black (cDat), set OI OI, centroid, and max int
            %to -1
            if this.forThresh(numy,numx)<thresh
%                         this.XQuiv(numy,numx)=0;
%                         this.YQuiv(numy,numx)=0;
                this.cDat(numy,numx,:)=[0,0,0];
                this.forOIHist(numy,numx)=-1;
                this.forCentHist(numy,numx)=-1;
                this.forMaxIntHist(numy,numx)=-1;
            else
                this.forOIHist(numy,numx)=this.oiData_ODF(numy,numx);
                this.forCentHist(numy,numx)=this.forCent(numy,numx);
                this.forMaxIntHist(numy,numx)=this.forMaxIntNorm(numy,numx);

            end
            if this.AxesFilled==false
                this.XQuiv(numy,numx)=cos(this.meanData_ODF(numy,numx));
                this.YQuiv(numy,numx)=sin(this.meanData_ODF(numy,numx));
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
