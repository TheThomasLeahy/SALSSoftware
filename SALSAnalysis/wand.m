wandpointer = [NaN   NaN   NaN   NaN   NaN   NaN     1   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN;
   NaN   NaN     1   NaN   NaN   NaN   NaN   NaN   NaN   NaN     1   NaN   NaN   NaN   NaN   NaN;
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN;
   NaN   NaN   NaN   NaN     1   NaN     1   NaN     1   NaN   NaN   NaN   NaN   NaN   NaN   NaN;
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN;
   NaN     1   NaN   NaN     1   NaN     1   NaN     NaN   NaN   NaN     1   NaN   NaN   NaN   NaN;
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   1       1   NaN   NaN   NaN   NaN   NaN   NaN   NaN;
   NaN   NaN   NaN   NaN     1   NaN   NaN   1       1     1   NaN   NaN   NaN   NaN   NaN   NaN;
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     1     1     1   NaN   NaN   NaN   NaN   NaN;
   NaN   NaN     1   NaN   NaN   NaN   NaN   NaN   NaN     1     1     1   NaN   NaN   NaN   NaN;
   NaN   NaN   NaN   NaN   NaN   NaN     1   NaN   NaN   NaN     1     1     1   NaN   NaN   NaN;
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     1     1     1   NaN   NaN;
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     1     1     1   NaN;
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     1     1     1;
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN     1     1;
   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN   NaN];
temp = gcf;
%the selection occurs at the tip of the wand
set(temp,'PointerShapeHotSpot',[6 7])
set(temp,'PointerShapeCData',wandpointer)
set(temp,'Pointer','custom')