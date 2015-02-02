function value=GetDepth(x,y,BATHY);

% PURPOSE
% Bidimensional interpolation at points given by [x,y];
% returns an interpolated value given some scalar field
% defined by (lon,lat).

n=length(x);
value=zeros(n,1);

for l=1:n,
    indi=x(l)-BATHY.lon;
    indi=max(find(indi>0));
    indj=y(l)-BATHY.lat;
    indj=max(find(indj>0));
    i1=indi;
    j1=indj;
    i2=i1+1;
    j2=j1;
    i3=i1+1;
    j3=j1+1;
    i4=i1;
    j4=j1+1;
    r(1)=sqrt((x(l)-BATHY.lon(i1))^2+(y(l)-BATHY.lat(j1))^2);
    r(2)=sqrt((x(l)-BATHY.lon(i2))^2+(y(l)-BATHY.lat(j2))^2);
    r(3)=sqrt((x(l)-BATHY.lon(i3))^2+(y(l)-BATHY.lat(j3))^2);
    r(4)=sqrt((x(l)-BATHY.lon(i4))^2+(y(l)-BATHY.lat(j4))^2);
    %P=sqrt((r2*r3*r4)^2+(r1*r3*r4)^2+(r1*r2*r4)^2+(r1*r2*r3)^2);
    %value(l)=(BATHY.data(j1,i1)*r2*r3*r4+BATHY.data(j2,i2)*r1*r3*r4+BATHY.data(j3,i3)*r2*r1*r4+BATHY.data(j4,i4)*r2*r3*r1)/P;
    if any(r),
        r(find(r==0))=0.0001;
    end;
    P=1/r(1)+1/r(2)+1/r(3)+1/r(4);
    value(l)=(BATHY.data(j1,i1)/r(1)+BATHY.data(j2,i2)/r(2)+BATHY.data(j3,i3)/r(3)+BATHY.data(j4,i4)/r(4))/P;
end;