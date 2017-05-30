function [ out ] = setSkewAndKurtosis(this, skew, kurtosis, row, col)
    y=this.input_size(1,1);
    x=this.input_size(1,2);
    
    
    
    j = y - row + 1;
    i = x - col + 1;
    index = (j-1)*x + i;
    this.data_points(index).skew = skew;
    this.data_points(index).kurtosis = kurtosis;
end