function [data_out, headers_out]=gradient3d(data_in,xdim,ydim,zdim)

% Written by Kristen Feaver
% This code uses finite differences to compute 3D gradients
% Inputs include columnar data that are ordered as follows:

%         x  y  z  data
%____________________________
%         1  1  1  data1  
%         1  1  2  data2
%         1  1  3  data3
%         1  2  1  data4
%         1  2  2  data5
%         1  2  3  data6
%         1  3  1  data7
%         1  3  2  data8
%         1  3  3  data9
%         2  1  1  data10
%         2  1  2  data11
%         2  1  3  data12
%         etc.

% As well as x, y, and z dimensions. If the input data is one column, it is
% interpreted as scalar data; if the input data is 3 columns, vector; if 9
% columns, tensor. Files needed for this code to run properly include 
% 'cent_diff_n.m' and if tensor glyphs are to be plotted, 'plotDTI.m'

% [X,Y,Z]=meshgrid(1:1:xdim,1:1:ydim,1:1:zdim); %make 3D grid


%Node=linspace(1, xdim*ydim*zdim, xdim*ydim*zdim)'; %Don't really need to
%have node number in output

sz=size(data_in);
if sz(2)==1
    %scalar
    
    data_re=reshape(data_in,[xdim*ydim, zdim]);
    mydata=reshape(data_re,[xdim, ydim, zdim]);
    %loop to calc cent diff at each point
    for m=1:xdim
        for n=1:ydim
            for o=1:zdim
                dzt=reshape(mydata(m,n,:),[1,zdim]);
                dyt=reshape(mydata(m,:,o),[1,ydim]);
                dxt=reshape(mydata(:,n,o),[1,xdim]);
                dz(m,n,:)=holechecker(dzt);
                dy(m,:,o)=holechecker(dyt);
                dx(:,n,o)=holechecker(dxt);
                
            end
        end
    end
    
    %tecplotdata
        
    newdx=reshape(dx,[xdim*ydim*zdim,1]);
    newdy=reshape(dy,[xdim*ydim*zdim,1]);
    newdz=reshape(dz,[xdim*ydim*zdim,1]);
    
    newData=reshape(mydata,[xdim*ydim*zdim,1]);
    
    data_out=[newdx newdy newdz];
    headers_out={'dx','dy','dz'};
    
    %%
elseif sz(2)==3
    
    % vector
    
    % resulting tensor:
    %  _             _
    % |  Vxx Vxy Vxz  |
    % |  Vyx Vyy Vyz  |
    % |_ Vzx Vzy Vzz _|
    
    dx_re=reshape(data_in(:,1),[xdim*ydim, zdim]);
    dx=reshape(dx_re,[xdim, ydim, zdim]);
    
    dy_re=reshape(data_in(:,2),[xdim*ydim, zdim]);
    dy=reshape(dy_re,[xdim, ydim, zdim]);
    
    dz_re=reshape(data_in(:,3),[xdim*ydim, zdim]);
    dz=reshape(dz_re,[xdim, ydim, zdim]);

    
    for m=1:xdim
        for n=1:ydim
            for o=1:zdim
                Vxz(m,n,:)=holechecker(reshape(dx(m,n,:),[1,zdim])); %dx/dz
                Vyz(m,n,:)=holechecker(reshape(dy(m,n,:),[1,zdim])); %dy/dz
%                Vzz(m,n,:)=holechecker(reshape(dz(m,n,:),[1,zdim])); %dz/dz
                
                Vxy(m,:,o)=holechecker(reshape(dx(m,:,o),[1,ydim])); %dx/dy
                Vyy(m,:,o)=holechecker(reshape(dy(m,:,o),[1,ydim])); %dy/dy
%                Vzy(m,:,o)=holechecker(reshape(dz(m,:,o),[1,ydim])); %dz/dy
                
                Vxx(:,n,o)=holechecker(reshape(dx(:,n,o),[1,xdim])); %dx/dx
                Vyx(:,n,o)=holechecker(reshape(dy(:,n,o),[1,xdim])); %dy/dx
%                Vzx(:,n,o)=holechecker(reshape(dz(:,n,o),[1,xdim])); %dz/dx
                
                Vzx(:,n,o)=zeros(size(reshape(dz(:,n,o),[1,xdim])));
                Vzy(m,:,o)=zeros(size(reshape(dz(m,:,o),[1,ydim])));
                Vzz(m,n,:)=zeros(size(reshape(dz(m,n,:),[1,zdim])));
            end
        end
    end
    
    
    newVxx=reshape(Vxx,[xdim*ydim*zdim,1]);
    newVyx=reshape(Vyx,[xdim*ydim*zdim,1]);
    newVzx=reshape(Vzx,[xdim*ydim*zdim,1]);
    
    newVxy=reshape(Vxy,[xdim*ydim*zdim,1]);
    newVyy=reshape(Vyy,[xdim*ydim*zdim,1]);
    newVzy=reshape(Vzy,[xdim*ydim*zdim,1]);
    
    newVxz=reshape(Vxz,[xdim*ydim*zdim,1]);
    newVyz=reshape(Vyz,[xdim*ydim*zdim,1]);
    newVzz=reshape(Vzz,[xdim*ydim*zdim,1]);
    
%     %for glyph plot of Vnn components...
%     V=zeros(3,3,8000);
%     V(1,1,:)=newVxx;
%     V(1,2,:)=newVxy;
%     V(1,3,:)=newVxz;
%     V(2,1,:)=newVyx;
%     V(2,2,:)=newVyy;
%     V(2,3,:)=newVyz;
%     V(3,1,:)=newVzx;
%     V(3,2,:)=newVzy;
%     V(3,3,:)=newVzz;
%     newV=reshape(V,[3,3,xdim,ydim,zdim]);
%     
%     plotDTI(newV,300)
    
    data_out=[newVxx newVxy newVxz newVyx newVyy newVyz newVzx newVzy newVzz];
    headers_out={'Vxx','Vxy','Vxz','Vyx','Vyy','Vyz','Vzx','Vzy','Vzz'};
    %%
elseif sz(2)==4
    % tensor

    % resulting tensor:
    
    %  _                _
    % |  Txxx Txxy Txxz  |
    % |  Txyx Txyy Txyz  |
    % |_ Txzx Txzy Txzz _|
    %  _                _
    % |  Tyxx Tyxy Tyxz  |
    % |  Tyyx Tyyy Tyyz  |
    % |_ Tyzx Tyzy Tyzz _|
    %  _                _
    % |  Tzxx Tzxy Tzxz  |
    % |  Tzyx Tzyy Tzyz  |
    % |_ Tzzx Tzzy Tzzz _|
    
    Vxx_re=reshape(data_in(:,1),[xdim*ydim, zdim]);
    Vxx=reshape(Vxx_re,[xdim, ydim, zdim]);
    
    Vxy_re=reshape(data_in(:,2),[xdim*ydim, zdim]);
    Vxy=reshape(Vxy_re,[xdim, ydim, zdim]);
    
    Vyx_re=reshape(data_in(:,4),[xdim*ydim, zdim]);
    Vyx=reshape(Vyx_re,[xdim, ydim, zdim]);
    
    Vyy_re=reshape(data_in(:,5),[xdim*ydim, zdim]);
    Vyy=reshape(Vyy_re,[xdim, ydim, zdim]);
    

    for m=1:xdim
        for n=1:ydim
            for o=1:zdim
                Txxz(m,n,:)=holechecker(reshape(Vxx(m,n,:),[1,zdim])); %dx2/dxdz
                Tyxz(m,n,:)=holechecker(reshape(Vyx(m,n,:),[1,zdim])); %dy2/dxdz
%                Tzxz(m,n,:)=holechecker(reshape(Vzx(m,n,:),[1,zdim])); %dz2/dxdz
                
                Txxy(m,:,o)=holechecker(reshape(Vxx(m,:,o),[1,ydim])); %dx2/dxdy
                Tyxy(m,:,o)=holechecker(reshape(Vyx(m,:,o),[1,ydim])); %dy2/dxdy
%                Tzxy(m,:,o)=holechecker(reshape(Vzx(m,:,o),[1,ydim])); %dz2/dxdy
                
                Txxx(:,n,o)=holechecker(reshape(Vxx(:,n,o),[1,xdim])); %dx2/dxdx
                Tyxx(:,n,o)=holechecker(reshape(Vyx(:,n,o),[1,xdim])); %dy2/dxdx
%                Tzxx(:,n,o)=holechecker(reshape(Vzx(:,n,o),[1,xdim])); %dz2/dxdx
                
                
                Txyz(m,n,:)=holechecker(reshape(Vxy(m,n,:),[1,zdim])); %dx2/dydz
                Tyyz(m,n,:)=holechecker(reshape(Vyy(m,n,:),[1,zdim])); %dy2/dydz
%                Tzyz(m,n,:)=holechecker(reshape(Vzy(m,n,:),[1,zdim])); %dz2/dydz
                
                Txyy(m,:,o)=holechecker(reshape(Vxy(m,:,o),[1,ydim])); %dx2/dydy
                Tyyy(m,:,o)=holechecker(reshape(Vyy(m,:,o),[1,ydim])); %dy2/dydy
%                Tzyy(m,:,o)=holechecker(reshape(Vzy(m,:,o),[1,ydim])); %dz2/dydy
                
                Txyx(:,n,o)=holechecker(reshape(Vxy(:,n,o),[1,xdim])); %dx2/dydz
                Tyyx(:,n,o)=holechecker(reshape(Vyy(:,n,o),[1,xdim])); %dy2/dydz
%                Tzyx(:,n,o)=holechecker(reshape(Vzy(:,n,o),[1,xdim])); %dz2/dydz
                
                
%                Txzz(m,n,:)=holechecker(reshape(Vxz(m,n,:),[1,zdim])); %dx2/dzdz
%                Tyzz(m,n,:)=holechecker(reshape(Vyz(m,n,:),[1,zdim])); %dy2/dzdz
%                Tzzz(m,n,:)=holechecker(reshape(Vzz(m,n,:),[1,zdim])); %dz2/dzdz
                
%                Txzy(m,:,o)=holechecker(reshape(Vxz(m,:,o),[1,ydim])); %dx2/dzdy
%                Tyzy(m,:,o)=holechecker(reshape(Vyz(m,:,o),[1,ydim])); %dy2/dzdy
%                Tzzy(m,:,o)=holechecker(reshape(Vzz(m,:,o),[1,ydim])); %dz2/dzdy
                
%                Txzx(:,n,o)=holechecker(reshape(Vxz(:,n,o),[1,xdim])); %dx2/dzdx
%                Tyzx(:,n,o)=holechecker(reshape(Vyz(:,n,o),[1,xdim])); %dy2/dzdx
%                Tzzx(:,n,o)=holechecker(reshape(Vzz(:,n,o),[1,xdim])); %dz2/dzdx
               
               Tzxx(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
               Tzxy(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
               Tzxz(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
               Tzyx(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
               Tzyy(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
               Tzyz(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));


               Txzz(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
               Tyzz(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
               Tzzz(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));

               Txzy(m,:,o)=zeros(size(reshape(Vxy(m,:,o),[1,ydim])));
               Tyzy(m,:,o)=zeros(size(reshape(Vxy(m,:,o),[1,ydim])));
               Tzzy(m,:,o)=zeros(size(reshape(Vxy(m,:,o),[1,ydim])));

               Txzx(:,n,o)=zeros(size(reshape(Vxz(:,n,o),[1,xdim])));
               Tyzx(:,n,o)=zeros(size(reshape(Vxz(:,n,o),[1,xdim])));
               Tzzx(:,n,o)=zeros(size(reshape(Vxz(:,n,o),[1,xdim])));

            
            end
        end
    end
    
    
    newTxxx=reshape(Txxx,[xdim*ydim*zdim,1]);
    newTyxx=reshape(Tyxx,[xdim*ydim*zdim,1]);
    newTzxx=reshape(Tzxx,[xdim*ydim*zdim,1]);
    
    newTxyx=reshape(Txyx,[xdim*ydim*zdim,1]);
    newTyyx=reshape(Tyyx,[xdim*ydim*zdim,1]);
    newTzyx=reshape(Tzyx,[xdim*ydim*zdim,1]);
    
    newTxzx=reshape(Txzx,[xdim*ydim*zdim,1]);
    newTyzx=reshape(Tyzx,[xdim*ydim*zdim,1]);
    newTzzx=reshape(Tzzx,[xdim*ydim*zdim,1]);
    
    
    newTxxy=reshape(Txxy,[xdim*ydim*zdim,1]);
    newTyxy=reshape(Tyxy,[xdim*ydim*zdim,1]);
    newTzxy=reshape(Tzxy,[xdim*ydim*zdim,1]);
    
    newTxyy=reshape(Txyy,[xdim*ydim*zdim,1]);
    newTyyy=reshape(Tyyy,[xdim*ydim*zdim,1]);
    newTzyy=reshape(Tzyy,[xdim*ydim*zdim,1]);
    
    newTxzy=reshape(Txzy,[xdim*ydim*zdim,1]);
    newTyzy=reshape(Tyzy,[xdim*ydim*zdim,1]);
    newTzzy=reshape(Tzzy,[xdim*ydim*zdim,1]);
    
    
    newTxxz=reshape(Txxz,[xdim*ydim*zdim,1]);
    newTyxz=reshape(Tyxz,[xdim*ydim*zdim,1]);
    newTzxz=reshape(Tzxz,[xdim*ydim*zdim,1]);
    
    newTxyz=reshape(Txyz,[xdim*ydim*zdim,1]);
    newTyyz=reshape(Tyyz,[xdim*ydim*zdim,1]);
    newTzyz=reshape(Tzyz,[xdim*ydim*zdim,1]);
    
    newTxzz=reshape(Txzz,[xdim*ydim*zdim,1]);
    newTyzz=reshape(Tyzz,[xdim*ydim*zdim,1]);
    newTzzz=reshape(Tzzz,[xdim*ydim*zdim,1]);
    
    data_out=[newTxxx newTxxy newTxxz newTxyx newTxyy newTxyz newTxzx newTxzy newTxzz newTyxx newTyxy newTyxz newTyyx newTyyy newTyyz newTyzx newTyzy newTyzz newTzxx newTzxy newTzxz newTzyx newTzyy newTzyz newTzzx newTzzy newTzzz];
    headers_out={'Txxx','Txxy','Txxz','Txyx','Txyy','Txyz','Txzx','Txzy','Txzz','Tyxx','Tyxy','Tyxz','Tyyx','Tyyy','Tyyz','Tyzx','Tyzy','Tyzz','Tzxx','Tzxy','Tzxz','Tzyx','Tzyy','Tzyz','Tzzx','Tzzy','Tzzz'};
    
%end
%%
elseif sz(2)==9
    % tensor

    % resulting tensor:
    
    %  _                _
    % |  Txxx Txxy Txxz  |
    % |  Txyx Txyy Txyz  |
    % |_ Txzx Txzy Txzz _|
    %  _                _
    % |  Tyxx Tyxy Tyxz  |
    % |  Tyyx Tyyy Tyyz  |
    % |_ Tyzx Tyzy Tyzz _|
    %  _                _
    % |  Tzxx Tzxy Tzxz  |
    % |  Tzyx Tzyy Tzyz  |
    % |_ Tzzx Tzzy Tzzz _|
    
    Vxx_re=reshape(data_in(:,1),[xdim*ydim, zdim]);
    Vxx=reshape(Vxx_re,[xdim, ydim, zdim]);
    
    Vxy_re=reshape(data_in(:,2),[xdim*ydim, zdim]);
    Vxy=reshape(Vxy_re,[xdim, ydim, zdim]);
    
    Vxz_re=reshape(data_in(:,3),[xdim*ydim, zdim]);
    Vxz=reshape(Vxz_re,[xdim, ydim, zdim]);

    
    
    Vyx_re=reshape(data_in(:,4),[xdim*ydim, zdim]);
    Vyx=reshape(Vyx_re,[xdim, ydim, zdim]);
    
    Vyy_re=reshape(data_in(:,5),[xdim*ydim, zdim]);
    Vyy=reshape(Vyy_re,[xdim, ydim, zdim]);
    
    Vyz_re=reshape(data_in(:,6),[xdim*ydim, zdim]);
    Vyz=reshape(Vyz_re,[xdim, ydim, zdim]);

    
    
    Vzx_re=reshape(data_in(:,7),[xdim*ydim, zdim]);
    Vzx=reshape(Vzx_re,[xdim, ydim, zdim]);
    
    Vzy_re=reshape(data_in(:,8),[xdim*ydim, zdim]);
    Vzy=reshape(Vzy_re,[xdim, ydim, zdim]);
    
    Vzz_re=reshape(data_in(:,9),[xdim*ydim, zdim]);
    Vzz=reshape(Vzz_re,[xdim, ydim, zdim]);

    
    for m=1:xdim
        for n=1:ydim
            for o=1:zdim
                Txxz(m,n,:)=holechecker(reshape(Vxx(m,n,:),[1,zdim])); %dx2/dxdz
                Tyxz(m,n,:)=holechecker(reshape(Vyx(m,n,:),[1,zdim])); %dy2/dxdz
                Tzxz(m,n,:)=holechecker(reshape(Vzx(m,n,:),[1,zdim])); %dz2/dxdz
                
                Txxy(m,:,o)=holechecker(reshape(Vxx(m,:,o),[1,ydim])); %dx2/dxdy
                Tyxy(m,:,o)=holechecker(reshape(Vyx(m,:,o),[1,ydim])); %dy2/dxdy
                Tzxy(m,:,o)=holechecker(reshape(Vzx(m,:,o),[1,ydim])); %dz2/dxdy
                
                Txxx(:,n,o)=holechecker(reshape(Vxx(:,n,o),[1,xdim])); %dx2/dxdx
                Tyxx(:,n,o)=holechecker(reshape(Vyx(:,n,o),[1,xdim])); %dy2/dxdx
                Tzxx(:,n,o)=holechecker(reshape(Vzx(:,n,o),[1,xdim])); %dz2/dxdx
                
                
                Txyz(m,n,:)=holechecker(reshape(Vxy(m,n,:),[1,zdim])); %dx2/dydz
                Tyyz(m,n,:)=holechecker(reshape(Vyy(m,n,:),[1,zdim])); %dy2/dydz
                Tzyz(m,n,:)=holechecker(reshape(Vzy(m,n,:),[1,zdim])); %dz2/dydz
                
                Txyy(m,:,o)=holechecker(reshape(Vxy(m,:,o),[1,ydim])); %dx2/dydy
                Tyyy(m,:,o)=holechecker(reshape(Vyy(m,:,o),[1,ydim])); %dy2/dydy
                Tzyy(m,:,o)=holechecker(reshape(Vzy(m,:,o),[1,ydim])); %dz2/dydy
                
                Txyx(:,n,o)=holechecker(reshape(Vxy(:,n,o),[1,xdim])); %dx2/dydz
                Tyyx(:,n,o)=holechecker(reshape(Vyy(:,n,o),[1,xdim])); %dy2/dydz
                Tzyx(:,n,o)=holechecker(reshape(Vzy(:,n,o),[1,xdim])); %dz2/dydz
                
                
               Txzz(m,n,:)=holechecker(reshape(Vxz(m,n,:),[1,zdim])); %dx2/dzdz
               Tyzz(m,n,:)=holechecker(reshape(Vyz(m,n,:),[1,zdim])); %dy2/dzdz
               Tzzz(m,n,:)=holechecker(reshape(Vzz(m,n,:),[1,zdim])); %dz2/dzdz
                
               Txzy(m,:,o)=holechecker(reshape(Vxz(m,:,o),[1,ydim])); %dx2/dzdy
               Tyzy(m,:,o)=holechecker(reshape(Vyz(m,:,o),[1,ydim])); %dy2/dzdy
               Tzzy(m,:,o)=holechecker(reshape(Vzz(m,:,o),[1,ydim])); %dz2/dzdy
                
               Txzx(:,n,o)=holechecker(reshape(Vxz(:,n,o),[1,xdim])); %dx2/dzdx
               Tyzx(:,n,o)=holechecker(reshape(Vyz(:,n,o),[1,xdim])); %dy2/dzdx
               Tzzx(:,n,o)=holechecker(reshape(Vzz(:,n,o),[1,xdim])); %dz2/dzdx
               
%                Tzxx(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
%                Tzxy(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
%                Tzxz(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
%                Tzyx(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
%                Tzyy(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
%                Tzyz(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
% 
% 
%                Txzz(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
%                Tyzz(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
%                Tzzz(m,n,:)=zeros(size(reshape(Vxx(m,n,:),[1,zdim])));
% 
%                Txzy(m,:,o)=zeros(size(reshape(Vxy(m,:,o),[1,ydim])));
%                Tyzy(m,:,o)=zeros(size(reshape(Vxy(m,:,o),[1,ydim])));
%                Tzzy(m,:,o)=zeros(size(reshape(Vxy(m,:,o),[1,ydim])));
% 
%                Txzx(:,n,o)=zeros(size(reshape(Vxz(:,n,o),[1,xdim])));
%                Tyzx(:,n,o)=zeros(size(reshape(Vxz(:,n,o),[1,xdim])));
%                Tzzx(:,n,o)=zeros(size(reshape(Vxz(:,n,o),[1,xdim])));

            
            end
        end
    end
    
    
    newTxxx=reshape(Txxx,[xdim*ydim*zdim,1]);
    newTyxx=reshape(Tyxx,[xdim*ydim*zdim,1]);
    newTzxx=reshape(Tzxx,[xdim*ydim*zdim,1]);
    
    newTxyx=reshape(Txyx,[xdim*ydim*zdim,1]);
    newTyyx=reshape(Tyyx,[xdim*ydim*zdim,1]);
    newTzyx=reshape(Tzyx,[xdim*ydim*zdim,1]);
    
    newTxzx=reshape(Txzx,[xdim*ydim*zdim,1]);
    newTyzx=reshape(Tyzx,[xdim*ydim*zdim,1]);
    newTzzx=reshape(Tzzx,[xdim*ydim*zdim,1]);
    
    
    newTxxy=reshape(Txxy,[xdim*ydim*zdim,1]);
    newTyxy=reshape(Tyxy,[xdim*ydim*zdim,1]);
    newTzxy=reshape(Tzxy,[xdim*ydim*zdim,1]);
    
    newTxyy=reshape(Txyy,[xdim*ydim*zdim,1]);
    newTyyy=reshape(Tyyy,[xdim*ydim*zdim,1]);
    newTzyy=reshape(Tzyy,[xdim*ydim*zdim,1]);
    
    newTxzy=reshape(Txzy,[xdim*ydim*zdim,1]);
    newTyzy=reshape(Tyzy,[xdim*ydim*zdim,1]);
    newTzzy=reshape(Tzzy,[xdim*ydim*zdim,1]);
    
    
    newTxxz=reshape(Txxz,[xdim*ydim*zdim,1]);
    newTyxz=reshape(Tyxz,[xdim*ydim*zdim,1]);
    newTzxz=reshape(Tzxz,[xdim*ydim*zdim,1]);
    
    newTxyz=reshape(Txyz,[xdim*ydim*zdim,1]);
    newTyyz=reshape(Tyyz,[xdim*ydim*zdim,1]);
    newTzyz=reshape(Tzyz,[xdim*ydim*zdim,1]);
    
    newTxzz=reshape(Txzz,[xdim*ydim*zdim,1]);
    newTyzz=reshape(Tyzz,[xdim*ydim*zdim,1]);
    newTzzz=reshape(Tzzz,[xdim*ydim*zdim,1]);
    
    data_out=[newTxxx newTxxy newTxxz newTxyx newTxyy newTxyz newTxzx newTxzy newTxzz newTyxx newTyxy newTyxz newTyyx newTyyy newTyyz newTyzx newTyzy newTyzz newTzxx newTzxy newTzxz newTzyx newTzyy newTzyz newTzzx newTzzy newTzzz];
    headers_out={'Txxx','Txxy','Txxz','Txyx','Txyy','Txyz','Txzx','Txzy','Txzz','Tyxx','Tyxy','Tyxz','Tyyx','Tyyy','Tyyz','Tyzx','Tyzy','Tyzz','Tzxx','Tzxy','Tzxz','Tzyx','Tzyy','Tzyz','Tzzx','Tzzy','Tzzz'};
    

end



