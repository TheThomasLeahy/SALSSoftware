 %% function - Initialize Axes
function initAxes(this,src)
    set(this.Figure.mainAxes,'Visible', 'on');
    colorbar;

    if this.input_size(1,1)>this.input_size(1,2)
        set(this.Figure.mainAxes,'Position',[0.12,0.05,0.75,0.9]);
    else
        set(this.Figure.mainAxes,'Position',[0.03,0.1,0.9,.75]);
    end

    axes(this.Figure.mainAxes);
    set(this.Figure.mainAxes,'XLim',[1 (this.input_size(2))]);
    set(this.Figure.mainAxes,'YLim',[1 (this.input_size(1))]);

    %set(this.Figure.OrientationIndex,'Value',1);
    set(this.Figure.editMaxScale,'String','100');
    set(this.Figure.editMinScale,'String','0');


    if this.new==1
        this.forRedrawStats=[0.0, 100.0; 0.0, 32000.0; 0, 65535.0; 0.0, 180.0; -1.0,1.0; -10, 10; 0, 1; 0, 1];     %min(min(this.correlationCoeff)), max(max(this.correlationCoeff))];
    else
        this.forRedrawStats=[0.0, 100.0; 0.0, 255.0; 0, 255.0; 0.0, 180.0; -1.0,1.0; -10, 10;  0, 1; 0, 1];    %min(min(this.correlationCoeff)), max(max(this.correlationCoeff))];
    end

    xorig = (1:1:this.input_size(1,2));
    xorig= repmat(xorig,this.input_size(1,1),1);
    this.Xdat= xorig;
    yorig = 1:1:this.input_size(1,1);
    yorig=reshape(yorig,this.input_size(1,1),1);
    yorig = repmat(yorig,1,this.input_size(1,2));
    this.Ydat=yorig;

    set(this.Figure.mainAxes,'XLim',[1 (this.input_size(1,2))]);
    set(this.Figure.mainAxes,'YLim',[1 (this.input_size(1,1))]);

    this.XQuiv=zeros(this.input_size(1,1),this.input_size(1,2)); this.YQuiv=zeros(this.input_size(1,1),this.input_size(1,2));

    fillAxes(this,1,0,1,1,0,0);
end