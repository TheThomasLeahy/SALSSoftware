function [ this ] = setTissueFlag(this, flagVal, row, col)
    x=this.input_size(1,1);
    y=this.input_size(1,2);
    
    j = y - row + 1; % corr row num
    i = col - 1; % corr col num
    %index = i*x + j + 1;
    index = (row-1)*x + col;
    this.data_points(index).tissue_flag = flagVal;
end