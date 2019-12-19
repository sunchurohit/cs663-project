close all;

v = VideoReader('o.mp4');
d = vision.DeployableVideoPlayer;

i = 0;

while hasFrame(v)
    i=i+1;
    if(rem(i,10)==1)
        images(:,:,:,ceil(i/10)) = readFrame(v); 
    end
    if i==1000
        break;
    end
end
 
im = mode(images,4);

I=rgb2gray(im);
I = imgaussfilt(I,3);

ed = edge(I,'canny',[0.15 0.25]);

%      [H,T,R]=hough(ed,'RhoResolution',0.5,'Theta',-80:0.5:80);
[H,T,R]=hough1(ed,0.5,[-80:0.5:80]);
P = houghpeaks(H,20,'threshold',ceil(0.5*max(H(:))));
lines = houghlines(ed,T,R,P,'FillGap',20,'MinLength',size(im,1)/4);

v.currenttime=0;

while hasFrame(v)
    rf = readFrame(v);
    step(d,mat2gray(rf-im));
    z=rf-im;

    imgaussfilt(z,3);
    
    z=im2bw(z,0.05);
    
    
    imshow(rf),hold on;
    
    st=regionprops(z);
  
    
    for k = 1 : length(st)
        if st(k).Area > 50
        rectangle('position',st(k).BoundingBox,'EdgeColor','b');
        end
    end
     
    

    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
       

    end
    
    hold off;
    

    pause(0.4/v.FrameRate);
    
    if not(isOpen(d))
      break;
    end
end

 


release(d);






