function reDraw(this,val,strDo)
%   hold on;
    if isequal(strDo,'rescale')
        if val==2
            maxscale=get(this.Figure.editMaxScale,'String');
            maxscale=str2double(maxscale);
            if this.currentColor==1
                maxscale=maxscale;
            end
            this.forRedrawStats(this.currentColor,val)=maxscale;
            fillAxes(this,this.currentColor,this.tval,1,this.quiverOn,0,0);
        else
            minscale=get(this.Figure.editMinScale,'String');
            minscale=str2double(minscale);
            if this.currentColor==1 && minscale~=0
                minscale=minscale;
            end
            this.forRedrawStats(this.currentColor,val)=minscale;
            fillAxes(this,this.currentColor,this.tval,1,this.quiverOn,0,0);
        end
    elseif isequal(strDo,'colorchange')
        fillAxes(this,this.currentColor,this.tval,1,this.quiverOn,0,0)
    elseif isequal(strDo,'quiverchange') % needs global variable to store on or off
        if get(this.Figure.quiverButton,'Value')==0
            this.quiverOn=0;
            fillAxes(this, this.currentColor,this.tval,1,this.quiverOn,0,0);
        else
            this.quiverOn=1;
            fillAxes(this,this.currentColor,this.tval,1,this.quiverOn,0,0);
        end
    end
end

