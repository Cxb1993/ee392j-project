function [y,u,v] = read_frame_sif(filename,framenum)

% Reads a designated frame from a sif sequence and outputs
% the y, u, and v components for that frame.  For the provided
% sif sequences, the data for each frame is contained in a
% separate file, e.g. y, u, and v for frame 0 is in file 000.yuv 
%
% [y,u,v] = read_frame_sif(filename,framenum)
%
% Arguments:
%     filename is a string, e.g. 'bus' (including quotes)
%     framenum is an integer (the first frame is frame 0)
%
% John Apostolopoulos (EE392J)

rows = 240;
cols = 352;

% Create the filename beginning with the directory, e.g. 'bus\000.yuv' for
% a PC running Windows and bus/000.yuv for a UNIX box
computer_type = computer;
if (computer_type == 'PCWIN')  % PC running Windows
   file_yuv = strcat(filename,sprintf('\\%.3d.yuv',framenum));  % \\ produces \
else	                        % UNIX
   file_yuv = strcat(filename,sprintf('/%.3d.yuv',framenum));  
end

fid = fopen(file_yuv,'r');
[temp,count] = fread(fid,[cols,rows],'uchar');
y = temp';
[temp2,count] = fread(fid,[cols/2,rows/2],'uchar');
u = temp2';
[temp2,count] = fread(fid,[cols/2,rows/2],'uchar');
v = temp2';
fclose(fid);