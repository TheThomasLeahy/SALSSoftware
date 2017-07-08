%% Function- calcCentroid
function [OI,outAng,degree,corr,reconstruct,htens] = calcCentroid(Itheta,this)

    Htens=zeros(2);
    for c=2:1:this.numDegrees
        Htens(1,1)=Htens(1,1)+(((Itheta(c)*cos(this.radList(c))^2)+(Itheta(c-1)*cos(this.radList(c-1))^2))*pi/360.0);
        Htens(1,2)=Htens(1,2)+(((Itheta(c)*cos(this.radList(c))*sin(this.radList(c)))+(Itheta(c-1)*cos(this.radList(c-1))*sin(this.radList(c))))*pi/360.0);
        Htens(2,2)=Htens(2,2)+(((Itheta(c)*sin(this.radList(c))^2)+(Itheta(c-1)*sin(this.radList(c-1))^2))*pi/360.0);
    end
    Htens(2,1)=Htens(1,2); 
    reconstruct=ones(1,180);

    htens=[Htens(1,1) Htens(1,2) Htens(2,1) Htens(2,2)];

    [this.V,D]=eig(Htens);

    if  D(1,1) > D(2,2)                

        tempd=D(1,1);
        D(1,1)=D(2,2);
        D(2,2)=tempd;
        tempv1=this.V(1,1);
        this.V(1,1)=this.V(1,2);
        this.V(1,2)=tempv1;
        tempv2=this.V(2,1);
        this.V(2,1)=this.V(2,2);
        this.V(2,2)=tempv2;
%             switchvec = 1;

    end

    %What?
    OI=1-(D(1,1)/D(2,2));
    if OI<=0
        OI=0.01;
    end

    primeang = atan(this.V(2,1)/this.V(1,1));
    crossang = atan(this.V(2,2)/this.V(1,2));
    outAng=primeang;

    ppp=double(primeang*(180.0/pi))+90.0;
    ccc=double(crossang*(180.0/pi))+90.0;

    clearvars greaterflag;
    if ppp < 0
        ppp=ppp+180;
    elseif ppp > 180
        ppp=ppp-180;
    end

    if ccc<0
        ccc=ccc+180;
    elseif ccc>180
        ccc=ccc-180;
    end
    degree=ppp;
    corr=round(ppp)-90;
end