function makeStereoSeries();

%Get all the relevant information.

prompt = 'Give me the file type (PNG, JPG, TIFF, BMP): ';
fileType = input(prompt,'s');
fprintf('\n');
% fprintf(['Your file type is',' [FILENAME].', fileType]);
% fprintf('\n');
% fprintf('\n');

prompt = 'Give me a series of maps (Format: fileLocation\fileName_[#####]): ';
mapSeriesString = input(prompt,'s');
fprintf('\n');
% fprintf(['Your map series will be:',' ', mapSeriesString, '_[#####].',fileType]);
% fprintf('\n');
% fprintf('\n');

prompt = 'Give me a series of strips (Format: fileLocation\fileName_[#####]): ';
stripSeriesString = input(prompt,'s');
fprintf('\n');
% fprintf(['Your strip series location is:',' ', stripSeriesString, '_[#####].',fileType]);
% fprintf('\n');
% fprintf('\n');

prompt = 'Give me an output series (Format: fileLocation\fileName_[#####]:) ';
outputSeriesString = input(prompt,'s');
fprintf('\n');
% fprintf(['Your output series location will be:',' ', outputSeriesString, '_[#####].',fileType]);
% fprintf('\n');
% fprintf('\n');

prompt = 'Start at frame: ';
startValue = input(prompt);
fprintf('\n');

prompt = 'End at frame: ';
endValue = input(prompt);

frameNumber = startValue;
odometer = '00000';

while frameNumber<=endValue
    fprintf('\n');
    fprintf('Now rendering frame %d of %d', frameNumber, endValue); 

    odometer = sprintf('%05.0f',frameNumber);
    
    mapFileName = [mapSeriesString, '_', odometer,'.',fileType];
    stripFileName = [stripSeriesString, '_', odometer,'.',fileType];
    outputFileName = [outputSeriesString, '_', odometer,'.',fileType];
    
    currentStereogram = stereogram(mapFileName,stripFileName);
    imwrite(uint8(double(currentStereogram)),outputFileName);
    
    frameNumber = frameNumber + 1;
end

numberOfFrames = endValue - startValue + 1;

fprintf('\n\n');
fprintf('Done! %d frames successfully rendered!',numberOfFrames');
fprintf('\n\n');