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