function [y,u,v] = read_frame_qcif(filename,framenum)

% Reads a designated frame from a qcif sequence and outputs
% the y, u, and v components for that frame.  For the provided
% qcif sequences, all of the data for all of the frames is
% contained in a single file.
%
% [y,u,v] = read_frame_qcif(filename,framenum)
%
% Arguments:
%     filename is a string, e.g. 'foreman.qcif' (including quotes)
%     framenum is an integer (the first frame is frame 0)
%
% John Apostolopoulos (EE392J)

rows = 144;   % qcif resolution (quarter-CIF)
cols = 176;

fid = fopen(filename,'r');
fseek(fid,(framenum*rows*cols*1.5),-1);     % Jumps to the desired frame
[temp,count] = fread(fid,[cols,rows],'uchar');
y = temp';
[temp2,count] = fread(fid,[cols/2,rows/2],'uchar');   
u = temp2';
[temp2,count] = fread(fid,[cols/2,rows/2],'uchar');
v = temp2';
fclose(fid);