 %%
        function transmuralOutput(this)
            this.totalnodes = this.input_size(1,1)*this.input_size(1,2);
            checks = findchecks(this); %Finds the number of options that are checked
            this.transOUT=zeros(checks,this.totalnodes);            
            %Configuring the node numbers
            this.fortransOutputNodeNumber=zeros(this.totalnodes,1);
            for i=1:1:this.totalnodes
                this.fortransOutputNodeNumber(i,1)=i;
            end
            this.transOUT(1,:)=this.fortransOutputNodeNumber;
            %Configuring X, Y, and Bit
            configTransPos(this);
            bwList(this);
            %Adding data that is checked to the file
            checks = 4;
            headerstr = ' Node#\t Xpos\t Ypos\t Bit\t ';
            formatstr = '%d\t%2.2f\t%2.2f\t%d\t';
            %If OI is checked, add it to the data
            if get(this.Figure.OIinFile,'Value')==1
                checks=checks+1;
                OInum = checks;
                headerstr = strcat(headerstr,'OI\t ');
                formatstr = strcat(formatstr,'%1.3f\t');
                t=1;
                forOutOI = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutOI(t,1) = this.oiData(i,j);  %Create column of OI to append
                        t=t+1;
                    end
                end 
                this.transOUT(OInum,:)=forOutOI;
            end
            %If Baseline is checked, add it to the data file
            if get(this.Figure.baselineInFile,'Value')==1
                checks=checks+1;
                Bnum=checks;
                headerstr = strcat(headerstr,'BL\t ');
                formatstr = strcat(formatstr,'%d\t');
                t=1;
                forOutBase = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutBase(t,1) = this.forBLColor(i,j);  %Create column of Baseline to append
                        t=t+1;
                    end
                end 
                this.transOUT(Bnum,:)=forOutBase;
            end
            %If Max Intensity is checked, add it to the data file
            if get(this.Figure.maxiInFile,'Value')==1
                checks=checks+1;
                MInum=checks;
                headerstr = strcat(headerstr,'MaxI\t ');
                formatstr = strcat(formatstr,'%d\t');
                t=1;
                forOutMaxI = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutMaxI(t,1) = this.forMaxColor(i,j);  %Create column of Max I to append
                        t=t+1;
                    end
                end 
                this.transOUT(MInum,:)=forOutMaxI;
            end
            %If Preferred Direction is checked, add it to the data file
            if get(this.Figure.prefdInFile,'Value')==1
                checks=checks+1;
                PDnum=checks;
                headerstr = strcat(headerstr,'PrefD\t ');
                formatstr = strcat(formatstr,'%2.2f\t');
                t=1;
                forOutPD = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutPD(t,1) = this.forCentDeg(i,j)+90;  %Create column of Preferred Direction to append
                        t=t+1;
                    end
                end 
                this.transOUT(PDnum,:)=forOutPD;
            end
            %If Skew is checked, add it to the data file
            if get(this.Figure.skewInFile,'Value')==1
                checks=checks+1;
                Snum=checks;
                headerstr = strcat(headerstr,'Skew\t ');
                formatstr = strcat(formatstr,'%3.3f\t');
                t=1;
                forOutSkew = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutSkew(t,1) = this.forDistSkew(i,j);  %Create column of Skew to append
                        t=t+1;
                    end
                end 
                this.transOUT(Snum,:)=forOutSkew;
            end
            %If Kurtosis is checked, add it to the data file
            if get(this.Figure.kurtosisInFile,'Value')==1
                checks=checks+1;
                Knum=checks;
                headerstr = strcat(headerstr,'Kurtosis\t ');
                formatstr = strcat(formatstr,'%3.3f\t');
                t=1;
                forOutKurtosis = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutKurtosis(t,1) = this.forDistKurt(i,j);  %Create column of Kurtosis to append
                        t=t+1;
                    end
                end 
                this.transOUT(Knum,:)=forOutKurtosis;
            end
            %If Coeff is checked, add it to the data file
            if get(this.Figure.coeffInFile,'Value')==1
                checks=checks+1;
                Cnum=checks;
                headerstr = strcat(headerstr,'Coeff\t ');
                formatstr = strcat(formatstr,'%3.3f\t');
                t=1;
                forOutcoeff = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutcoeff(t,1) = this.correlationCoeff(i,j);  %Create column of coeff to append
                        t=t+1;
                    end
                end
                this.transOUT(Cnum,:)=forOutcoeff;
            end
            %If Tensor is checked, add it to the data file 
            if get(this.Figure.tensorInFile,'Value')==1
                checks=checks+1;
                Tnum=checks;
                headerstr = strcat(headerstr,'h11\t h12\t h21\t h22\t');
                formatstr = strcat(formatstr,'       %2.3f\t%2.3f\t  %2.3f\t  %2.3f\t');
                t=1;
                forOutTensor1 = zeros(this.totalnodes,1);
                forOutTensor2 = zeros(this.totalnodes,1);
                forOutTensor3 = zeros(this.totalnodes,1);
                forOutTensor4 = zeros(this.totalnodes,1);
                for j=1:this.input_size(1,2)
                    for i=1:this.input_size(1,1)
                        forOutTensor1(t,1) = this.htens1(i,j); 
                        forOutTensor2(t,1) = this.htens2(i,j); 
                        forOutTensor3(t,1) = this.htens2(i,j); 
                        forOutTensor4(t,1) = this.htens4(i,j); %Create column of Tensors to append
                        t=t+1;
                    end
                end 
                this.transOUT(Tnum,:)=forOutTensor1;
                this.transOUT(Tnum+1,:)=forOutTensor2;
                this.transOUT(Tnum+2,:)=forOutTensor3;
                this.transOUT(Tnum+3,:)=forOutTensor4;
            end
            %Saving the file
            trial=inputdlg('What is the sectioning thickness of your specimen? (in microns)');
            secThick=str2num(char(trial));
            [transfile,transfilepath]=uiputfile('*.txt','Please select an output path (Format: Section#_SampleName)');
            transfile=strcat(transfile(1,1:end-4),'_',num2str(secThick),'.txt');
            transfull=fullfile(transfilepath,transfile);
            f=fopen(transfull,'w');
            fprintf(f,'%d\t %d\n',this.input_size);
            headerstr = strcat(headerstr,'\n');
            fprintf(f,headerstr);
            formatstr = strcat(formatstr,'\n');
            fprintf(f,formatstr,this.transOUT);
            fclose(f);
            set(this.Figure.outputPath,'String',transfull);
            msgbox('Transmural File Save Completed');
        end
        
        function configTransPos(this)
            this.forOutX=this.pos(:,2);
            this.transOUT(2,:)=this.forOutX;
            tempy=ones(this.input_size(1,1),this.input_size(1,2));
            tempyy=[];
            for i=1:1:this.input_size(1,1);
                tempy(i,:)=this.pos(i,1);
            end
            for i=1:1:this.input_size(1,2);
                tempyy=[tempyy,transpose(tempy(:,i))];
            end
            this.forOutY=tempyy;
            this.transOUT(3,:)=this.forOutY;
%             set(this.Figure.mainData,'Data',tempyy);
        end
         
        function bwList(this)        
            outputBW(this);
            i=1;
             for numx=1:this.input_size(1,2)
                for numy=1:this.input_size(1,1)
                        tempmatrix(1,i)=this.forBWOut(numy,numx);
                        i=i+1;
                end
             end
             this.transOUT(4,:)=tempmatrix';
        end
        %Finds out how many checkboxes are checked and returns that +4
        function checks = findchecks(this)
            checks = 4;
            if get(this.Figure.OIinFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.baselineInFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.maxiInFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.prefdInFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.skewInFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.kurtosisInFile,'Value')==1
                checks=checks+1;
            end
            if get(this.Figure.coeffInFile,'Value')==1
                checks=checks+1
            end
            if get(this.Figure.tensorInFile,'Value')==1
                checks=checks+4;
            end
        end