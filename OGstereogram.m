function stereo = OGstereogram(DepthMapFile,PatternFile);

%% Import the image
map = imread(DepthMapFile);
s = size(map);
size_y = s(1);
size_x = s(2);
stereo = [size_y, size_x];
 
%create a blank image upon which to create our stereogram
for i=1:size_y
    for j=1:size_x
        stereo(i,j,1)=255;
        stereo(i,j,2)=255;
        stereo(i,j,3)=255;
    end
end
 
%% create the stereogram
for j=1:size_y
    for i=1:size_x
        x=double(i);
        y=j;
        if [stereo(y,x,1), stereo(y,x,2), stereo(y,x,3)] == [255,255,255]
            color = [rand()*255,rand()*150, rand()*120];
        else
            color = [stereo(y,x,1), stereo(y,x,2), stereo(y,x,3)];
        end
        stereo(y,x,1) = color(1);
        stereo(y,x,2) = color(2);
        stereo(y,x,3) = color(3);
        z = map(y,x);
        color2 = z;
        d = double(70-(color2*(25.0/255.0)));   %this is the real one
        %d = double(50+(color2*(50/255.0)));  %this was the first attempt
        x=x+d;
        if x<size_x
           stereo(y,x,1) = color(1);
           stereo(y,x,2) = color(2);
           stereo(y,x,3) = color(3);
        end
    end
end
imagesc(uint8(double(stereo)))
 
%% create a stereogram using a patterned image
 
%% import and resize the pattern image
 
pattern = imread(PatternFile);
pattern_width = 70;
pattern = imresize(pattern, [pattern_width pattern_width]);
pattern_ = [pattern_width size_y];
 
for j=1:pattern_width
    for i=1:size_y
        pattern_(i,j,1)=pattern(rem(i,pattern_width)+1,j,1);
        pattern_(i,j,2)=pattern(rem(i,pattern_width)+1,j,2);
        pattern_(i,j,3)=pattern(rem(i,pattern_width)+1,j,3);
    end
end
%% pattern the image before we alter it
 
i = double(1);
for j=1:size_y
    while i<=size_x
        x=double(i);
        y=double(j);
        z = map(y,x);
        color2 = z;
        %d = double(pattern_width-(color2*(20.0/255.0)));
        d = pattern_width;
        for k=1:d
            if x+k < size_x
                stereo(y,x+k,1) = pattern_(y,k,1);
                stereo(y,x+k,2) = pattern_(y,k,2);
                stereo(y,x+k,3) = pattern_(y,k,3);
            end
        end
        i = i+d;
    end
    i = double(1);
end
%% now create the stereogram based on the pattern we just laid down
 
kx=1;
for j=1:size_y
    for i=1:size_x
        x=double(i);
        y=j;
        if [stereo(y,x,1), stereo(y,x,2), stereo(y,x,3)] == [255,255,255]
            pat_x = double(rem(kx, pattern_width)+1);
            color = [pattern_(y,pat_x,1), pattern_(y,pat_x,2), pattern_(y,pat_x,3)];
        else
            color = [stereo(y,x,1), stereo(y,x,2), stereo(y,x,3)];
        end
        stereo(y,x,1) = color(1);
        stereo(y,x,2) = color(2);
        stereo(y,x,3) = color(3);
        z = map(y,x);
        %color2 = 255-z;
        color2 = z;
        %stereo(x,y) = color2;
        %d = double(100+(color2/2.0));%*(150.0/255.0)));
        d = double(pattern_width-(color2*(25.0/255.0)));
        x=x+d;
        if x<=size_x
           stereo(y,x,1) = color(1);
           stereo(y,x,2) = color(2);
           stereo(y,x,3) = color(3);
        end
        kx=kx+1;
    end
end
imagesc(uint8(double(stereo)))
