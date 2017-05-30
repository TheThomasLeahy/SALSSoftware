function chooseColor(this, hObject, eventdata)
    if this.AxesFilled
        switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
            case 'OrientationIndex'
                this.currentColor=1;
                set(this.Figure.colorChosen,'String','Orientation Index');
            case 'Baseline'
                % Code for when BL is selected.
                this.currentColor=2;
                set(this.Figure.colorChosen,'String','Baseline');
            case 'MaxIntensity'
                % Code for when MI is selected.
                this.currentColor=3;
                set(this.Figure.colorChosen,'String','Maximum Intensity'); 
            case 'Centroid'
                % Code for when Cent is selected.
                this.currentColor=4;
                set(this.Figure.colorChosen,'String','Centroid');
            case 'iet'
                this.currentColor=5;
                set(this.Figure.colorChosen,'String','IET');
            case 'skew'
                this.currentColor=6;
                set(this.Figure.colorChosen,'String','Skew');
            case 'SymCoeff'
                this.currentColor=7;
                set(this.Figure.colorChosen,'String','Symmetry Coeff');
            case 'rCoeff'
                this.currentColor=8;
                set(this.Figure.colorChosen,'String','Correlation Coeff');
            otherwise
                disp('Other');
        end
        
        reDraw2(this, this.currentColor,'colorchange');

    end
end
        