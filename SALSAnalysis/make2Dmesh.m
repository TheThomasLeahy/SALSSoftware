                %%
        function make2Dmesh(this,outputStr);

        %WILL NEED TO REMOVE THIS AFTER ADDING IN SKEW AND KURTOSIS DATA
            this.OUT(11:13,:)=0; %Add in a blanked space for the x-component of the centroid, y-component of the centroid, skew and kurtosis
            this.OUT(14,:)=this.OUT(10,:); %Add the nodes to the end of the data set
            this.OUT(10,:)=0; %Blank original node values

            
%       Create 2D Rectilinear Mesh
            x=1;
            s=1;

           for f=1:(this.input_size(1,2)-1);      

                this.Mesh2D (s,1) = x;
                this.Mesh2D (s,2) = x+this.input_size(1,1);
                this.Mesh2D (s,3) = x+this.input_size(1,1)+1;  
                this.Mesh2D (s,4) = x + 1;


                s=s+1;

                       for n=1:(this.input_size(1,1)-2)    %  Writes the bricks adding one to the previous line node number

                               this.Mesh2D (s,1) = this.Mesh2D(s-1,1)+1;
                               this.Mesh2D (s,2) = this.Mesh2D(s-1,2)+1;
                               this.Mesh2D (s,3) = this.Mesh2D(s-1,3)+1;
                               this.Mesh2D (s,4) = this.Mesh2D(s-1,4)+1;

                            s=s+1;

                       end
                               x=x+this.input_size(1,1);
                       
           end


             
            f=fopen((strcat(outputStr,'_TECPLOT_1slice','.plt')),'w'); %Need to write a variable output name
            this.tE = num2str((this.input_size(1,2)-1)*(this.input_size(1,1)-1)); %Calculates the total number of elements based on row and column data
            this.zN = num2str(this.OUT(14,end)); %Determines the Total Number of nodes           
            fprintf(f,'TITLE= "Tecplot 2D Slice Mesh Data" \n');
            fprintf(f,'VARIABLES = "X", "Y", "OI", "Max Int", "Min Int", "Pref Dir", "TV1", "TV2", "TV4","X_comp Centroid", "Y_comp Centroid", "Skew", "Kurtosis", "ID" \n'); 
            fprintf(f,'ZONE N= %s, E= %s, F=FEPOINT, ET=QUADRILATERAL \n', this.zN , this.tE);
            fprintf(f,'%2.4f\t%2.4f\t%d\t%d\t%d\t%2.2f\t%2.2f\t%2.2f\t%2.2f\t%1.4f\t%1.4f\t%3.3f\t%3.3f\t%d\n',this.OUT);
            fprintf(f,'\n');
            dlmwrite (strcat(outputStr,'_TECPLOT_1slice','.plt'), this.Mesh2D, 'precision', 7, 'delimiter', ' ', '-append');  % All the bricks are in the file with consecutive ID number
            fclose(f);
            
        end