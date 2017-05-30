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
                            setTissueFlag(this, 1, i,queue(1,2));
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
                            setTissueFlag(this, 1, queue(1,1), k);
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
                            setTissueFlag(this, 0, i,queue(1,2));
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
                            setTissueFlag(this, 0, queue(1,1),k);
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