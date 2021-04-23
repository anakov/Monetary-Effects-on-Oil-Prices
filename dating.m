clear all; clc
 start='2/1/1957'
% start='7/1/1958'
breakpt=[122 192 305 422];
dates = [];
startdate=datevec(start);
for i = 1:length(breakpt),
dates=[dates '   ' datestr(startdate+[floor(breakpt(i)/12) rem(breakpt(i),12) 0 0 0 0],28)];
end
dates

