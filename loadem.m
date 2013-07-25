%[y1,u1,v1]=read_frame_qcif('/local/class/ee392j/sequences/qcif_sequences/mthr_dotr.qcif',nf1);
%[y2,u2,v2]=read_frame_qcif('/local/class/ee392j/sequences/qcif_sequences/mthr_dotr.qcif',nf2);
[y1,u1,v1]=read_frame_qcif('seq/salesman.qcif',nf1);
[y2,u2,v2]=read_frame_qcif('seq/salesman.qcif',nf2);
[NY,NX]=size(y1);
u1b=interp2(u1,1); u1b=[u1b u1b(:,end); u1b(end,:) u1b(end,end)];
v1b=interp2(v1,1); v1b=[v1b v1b(:,end); v1b(end,:) v1b(end,end)];
u2b=interp2(u2,1); u2b=[u2b u2b(:,end); u2b(end,:) u2b(end,end)];
v2b=interp2(v2,1); v2b=[v2b v2b(:,end); v2b(end,:) v2b(end,end)];

