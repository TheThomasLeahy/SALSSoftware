function [ output_args ] = colorMapValueSelected( this, src, event )
    %UNTITLED Summary of this function goes here
    %   Detailed explanation goes here
    str = get(this.Figure.popupmenu5, 'String');
    val = get(this.Figure.popupmenu5, 'Value');
       
    if this.AxesFilled
        if ~strcmp(str{val},'Grey')
            this.currentColor=str{val};
        end
        set(this.Figure.colorChosen,'String',str{val});                        
        reDraw2(this, str{val}, 'colorchange');
    end
end

