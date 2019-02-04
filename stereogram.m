function stereoImage = stereogram(DepthMapFile,StripFile);

% %map = imread('S:\Creative Projects\After Effects\Stereo Eyes\Depth Maps\TestDepth.JPG');
% map = imread(DepthMapFile);
% s = size(map);
% size_y = s(1);
% size_x = s(2);
% stereo = [size_y, size_x];
% %strip = imread('S:\Creative Projects\After Effects\Stereo Eyes\Strips\TestStrip.JPG');
% strip = imread(StripFile);
% s2 = size(strip);
% stripsize_y = s2(1);
% stripsize_x = s2(2);
% pattern_width = stripsize_x;
% pattern_ = strip;
%  
% i = double(1);
% for j=1:size_y
%     while i<=size_x
%         x=double(i);
%         y=double(j);
%         z = map(j,i);
%         color2 = z;
%         %d = double(pattern_width-(color2*(20.0/255.0)));
%         d = pattern_width;
%         for k=1:d
%             if x+k < size_x
%                 stereo(y,x+k,1) = pattern_(y,k,1);
%                 stereo(y,x+k,2) = pattern_(y,k,2);
%                 stereo(y,x+k,3) = pattern_(y,k,3);
%             end
%         end
%         i = i+d;
%     end
%     i = double(1);
% end
% %% now create the stereogram based on the pattern we just laid down
%  
% kx=1;
% for j=1:size_y
%     for i=1:size_x
%         x=double(i);
%         y=j;
%         if [stereo(y,x,1), stereo(y,x,2), stereo(y,x,3)] == [255,255,255]
%             pat_x = double(rem(kx, pattern_width)+1);
%             color = [pattern_(y,pat_x,1), pattern_(y,pat_x,2), pattern_(y,pat_x,3)];
%         else
%             color = [stereo(y,x,1), stereo(y,x,2), stereo(y,x,3)];
%         end
%         stereo(y,x,1) = color(1);
%         stereo(y,x,2) = color(2);
%         stereo(y,x,3) = color(3);
%         z = map(y,x);
%         %color2 = 255-z;
%         color2 = z;
%         %stereo(x,y) = color2;
%         %d = double(100+(color2/2.0));%*(150.0/255.0)));
%         d = double(pattern_width-(color2*(25.0/255.0)));
%         x=x+d;
%         if x<=size_x
%            stereo(y,x,1) = color(1);
%            stereo(y,x,2) = color(2);
%            stereo(y,x,3) = color(3);
%         end
%         kx=kx+1;
%     end
% end
% imagesc(uint8(double(stereo)))

%Alternate function I wrote

%Set depthmap conversion factor
factor = 32/255;

%set stereo array default
default = 256;

%Read in data
map = imread(DepthMapFile);
strip = imread(StripFile);

%Set dimension variables
mapSize = size(map);
mapSize_y = mapSize(1);
mapSize_x = mapSize(2);

stripSize = size(strip);
stripSize_y = stripSize(1);
stripSize_x = stripSize(2);

%define blank array of pixels for stereogram, all values 256
for j=1:mapSize_y
    for i=1:mapSize_x
        for k = 1:3
    stereoImage(j,i,k)=default;
    %stereoImage(j,i,k)=256;
        end
    end
end

%assuming stripSize_y = mapSize[y] here.

%Find Center Point
mapCenter_x = floor(mapSize_x/2);
stripCenter_x = floor(stripSize_x/2);

%Center strip is squeezed by center depth values

for j=1:mapSize_y
    squeeze(j) = (double(stripCenter_x)-0.5*factor*double(map(j,mapCenter_x)))/double(stripCenter_x);
end

%Lay down squeezed center strip
for j=1:stripSize_y
	for i=1:stripSize_x
		stereoImage(j,mapCenter_x+int64(fix((i-stripCenter_x)*squeeze(j))),1) = strip(j,i,1);
		stereoImage(j,mapCenter_x+int64(fix((i-stripCenter_x)*squeeze(j))),2) = strip(j,i,2);
		stereoImage(j,mapCenter_x+int64(fix((i-stripCenter_x)*squeeze(j))),3) = strip(j,i,3);
	end
end

% %Center strip is unchanged.
% for j=1:stripSize_y
% 	for i=1:stripSize_x
% 		stereoImage(j,i+mapCenter_x-stripCenter_x,1) = strip(j,i,1);
% 		stereoImage(j,i+mapCenter_x-stripCenter_x,2) = strip(j,i,2);
% 		stereoImage(j,i+mapCenter_x-stripCenter_x,3) = strip(j,i,3);
% 	end
% end

%We now have a blank array except for a center strip
%Let's do left of the strip first.

x_position = mapCenter_x;

while x_position>0
	for j=1:stripSize_y
		%Define displacement to take value from
		z = int64(floor(double(map(j,x_position+stripCenter_x))*factor));
        %z=int64(5);
		%Shifted pixel one strip over is mapped to this pixel
        if stereoImage(j,x_position)==default
            stereoImage(j,x_position,1) = stereoImage(j,x_position+stripSize_x-z,1);
            stereoImage(j,x_position,2) = stereoImage(j,x_position+stripSize_x-z,2);
            stereoImage(j,x_position,3) = stereoImage(j,x_position+stripSize_x-z,3);
        end
        %Fill in white spaces that overshot with the equivalent pixel from
        %a strip to the left.
        if stereoImage(j,x_position)==default
            stereoImage(j,x_position,1) = stereoImage(j,x_position+stripSize_x-z-int64(stripSize_x*squeeze(j)),1);
            stereoImage(j,x_position,2) = stereoImage(j,x_position+stripSize_x-z-int64(stripSize_x*squeeze(j)),2);
            stereoImage(j,x_position,3) = stereoImage(j,x_position+stripSize_x-z-int64(stripSize_x*squeeze(j)),3);
        end
	end
	x_position = x_position - 1;
end

%Now to the right of the strip

x_position = mapCenter_x;
		
while x_position<=mapSize_x
	for j=1:stripSize_y
		%Define displacement to take value from
        %z = int64(ceil(double(map(j,x_position+stripCenter_x-stripSize_x))*factor));
	    z = int64(ceil(double(map(j,x_position-stripCenter_x))*factor));
        %z = 0;
		%Shifted pixel one strip over is mapped to this pixel
        if stereoImage(j,x_position)==default
		stereoImage(j,x_position,1) = stereoImage(j,x_position-stripSize_x+z,1);
		stereoImage(j,x_position,2) = stereoImage(j,x_position-stripSize_x+z,2);
		stereoImage(j,x_position,3) = stereoImage(j,x_position-stripSize_x+z,3);
        end
	end
	x_position = x_position + 1;
end

%once-over to remove holes
for j=1:mapSize_y
    for i=1:mapSize_x
        for k = 1:3
            if i<mapCenter_x&&stereoImage(j,i,k)==default
                stereoImage(j,i,k)=stereoImage(j,i+1,k);
            end
            if i>mapCenter_x&&stereoImage(j,i,k)==default
                stereoImage(j,i,k)=stereoImage(j,i-1,k);
            end
        
    %stereoImage(i,j,k)=256;
        end
    end
end

imagesc(uint8(double(stereoImage)))
