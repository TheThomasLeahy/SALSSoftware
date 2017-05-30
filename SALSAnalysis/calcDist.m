%%
function [mean,meanpos,variance,sk,kurt, symcoeff, coeff] = calcDist(Idist,this,recon)
    %s is the size of the Intensity distribution
    s=size(Idist);
    %distmax is the max of the intensity distribution (up to 65520)
    distmax=max(Idist);
    %Idist is the normalized size of the intensity distribution
    %(min = 0, max = 1)
    Idist=Idist/distmax;
    %ihalf1 is the lower half of the vector (1-180)
    ihalf1=Idist(1:s(2)/2);
    %run normalize dist and outputs ihalf1 as the normalized
    %distribution, ha as the minD before normalization, haa as maxD
    %before normalization, and haaa as the area
    [ihalf1,ha,haa,haaa]=NormalizeDist(ihalf1,this.distRads);
%            ihalf1=ihalf1/distmax;
    ihalf2=Idist(((s(2)/2)+1):s(2));
    %run normalize dist and outputs ihalf1 as the normalized
    %distribution, ha as the minD before normalization, haa as maxD
    %before normalization, and haaa as the area
    [ihalf2,ha,haa,haaa]=NormalizeDist(ihalf2,this.distRads);
%            ihalf2=ihalf2/distmax;
    %average the intensity vectors between the first and second halves
    iavg=(ihalf1+ihalf2)/2.0;
    %normalize the avg now.
    [iavg,ha,haa,haaa]=NormalizeDist(iavg,this.distRads);
    %shalf is half the size of the original
    shalf=size(iavg);
    %d2r???? is the distance to the radius
    d2r=double(pi/180.0);
    %output recon as the reconstructed normalized distribution of
    %whatever was inputed as recon into the CalcDist fcn
    [recon,ha,haa,haaa]=NormalizeDist(recon,this.distRads);
    %declare/clear stats
    mean=0;meanpos=0;variance=0;sk=0;kurt=0;
    %declare/clear these values
    cent=0;a=0;fm=0;da=0; meanh1=0;meanh2=0;fm1=0;fm2=0;da1=0;a1=0;da2=0;a2=0;dare=0;fmre=0;are=0;
    %for each value of intensity from 1 to 180
    for i=1:1:shalf(2)
        %da is the avg intensity at each angle
        da=iavg(i);
        %fm is the sum of the avg intensity at each angle
        %multiplied by the angle
        fm=fm+(da*(i*1.0));
        %a is the sum of the avg angles
        a=a+da;
        %da1 is the intensity at the angle for peak 1
        da1=ihalf1(i);
        %da2 is the intensity at the angle for peak 2
        da2=ihalf2(i);
        %fm1 is the sum of the avg intensity at each angle
        %multiplied by the angle for peak 1
        fm1=fm1+(da1*(i*1.0));
        %fm2 is the sum of the avg intensity at each angle
        %multiplied by the angle for peak 2
        fm2=fm2+(da2*(i*1.0));
        %a1 is a steak sauce
        a1=a1+da1;
        %a2 is the sum of the avg anglesf for peak 2
        a2=a2+da2;
        %dare is the recon dist at the angle i
        dare=recon(i);
        %fmre is the sum of the avg recon at each angle multiplied
        %by the angle
        fmre=fmre+(dare*(i*1.0));
        %are is the sum of the avg angles for recon
        are=are+dare;
    end
    %mm is the sum of the avg angles for the entire intensity
    %distribution over 180 (normalized)
    mm=a/180.0;
    %cent is the (center/centroid?) found by taking the sum of the
    %avg intensity at each angle multiplied by the angle all over
    %the sum of the avg of the angles
    cent=fm/a;
    %mm1 is the sum of the avg angles for the first half of the
    %intensity distribution over 180 (normalized)
    mm1=(a1/180.0);
    %cent1 is same as cent but for first peak
    cent1=fm1/a1;
    %mm2 same as others but for second peak
    mm2=a2/180.0;
    %cent2 is same as cent but for second peak
    cent2=fm2/a2;
    %mmre same as mm but for reconstruction
    mmre=(are/180.0);
    %centre same as cent but for reconstruction
    centre=(fmre/are);

    %set these all to 0 (declare)
    ms1=0;ms2=0;ms3=0;ms4=0;mtemp=0;r=0;rt=0;rbx=0;rby=0;ret=0;rebx=0;reby=0;

    %from j=1 to 180
    for j=1:1:shalf(2)

        %mtemp is the average intensity at each angle minus the
        %normalized area?
        mtemp=(iavg(j)-mm);
        %ms1 is the sum of mtemp
        ms1=ms1+(mtemp);

        %mtemp^2
        mtemp=mtemp*(iavg(j)-mm);
        %sum of mtemp^2
        ms2=ms2+(mtemp);

        %mtemp^3
        mtemp=mtemp*(iavg(j)-mm);
        %sum of mtemp^3
        ms3=ms3+(mtemp);

        %mtemp^4
        mtemp=mtemp*(iavg(j)-mm);
        %sum of mtemp^4
        ms4=ms4+(mtemp);

        %rt is the sum of (ihalf1-mm)*(ihalf2(j)-mm2)
        rt=rt+((ihalf1(j)-mm1)*(ihalf2(j)-mm2));
        %sum of (ihalf1(j)-mm1)^2 (uses mm1)
        rbx=rbx+((ihalf1(j)-mm1)^2);
        %same as mtemp^2 but uses mm2
        rby=rby+((ihalf2(j)-mm2)^2);

        %sum of mtemp*recontemp
        ret=ret+((iavg(j)-mm)*(recon(j)-mmre));
        %sum of mtemp^2
        rebx=rebx+((iavg(j)-mm)^2);
        %sum of recontemp^2
        reby=reby+((recon(j)-mmre)^2);
    end

    r=rt/(sqrt(rbx)*sqrt(rby));
    rre=ret/(sqrt(rebx)*sqrt(reby));

    ms1=ms1/(180.0);
    ms2=ms2/(180.0);
    ms3=ms3/(180.0);
    ms4=ms4/(180.0);

    sk=ms3/(sqrt(ms2*ms2*ms2));
    kurt=(ms4/(ms2*ms2))-3;
    meanpos=cent;
    symcoeff=r;
    coeff=rre;


end