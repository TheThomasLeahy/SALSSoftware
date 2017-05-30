%% wand insertion code
clc; clear
this.forThresh = [-1 99 99 -1; -1 -1 -1 99; 99 99 -1 -1];
xRound = 2;
yRound = 2;
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
        
        if  this.forThresh(i,queue(1,2)) == -1;
            this.forThresh(i,queue(1,2)) = 99;
            %update completed vector for debugging purposes
            completed = [completed; i,queue(1,2)];
            if i ~= queue(1,1);
                queue = [queue; queue(1,2),j];
            end
        end
    end
    for j=xmin:xmax
        %if the point left/right is blanked, fill it in
        if  this.forThresh(queue(1,1),j) == -1;
            this.forThresh(queue(1,1),j) = 99;
            %update completed vector for debugging purposes
            completed = [completed; queue(1,1),j];
            if j ~= queue(1,2)
                queue = [queue; queue(1,1),j];
            end
        end  
    end
        %clear any completed values
        queue(1,:) = [];
end

