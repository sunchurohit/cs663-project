function [I,T,R] = hough1(Im,rho,th)
sz = size(Im)-1;

mrho = round(sqrt(sz(1)^2+sz(2)^2));
T=th;
dia=rho*ceil(mrho/rho);
R=[-dia:rho:dia];

m=floor(size(R,2)/2);

x=size(th,2);
I=zeros(size(R,2),x);

[rw,cl] = find(Im);
k=[cl-1,rw-1];

for t=1:x
    r = k*[cos(th(t)*pi/180);sin(th(t)*pi/180)];
    yy= m+round(r/rho);
    for i = 1:length(yy)
        I(yy(i)+1,t) = I(yy(i)+1,t) + 1;
    end 
end

