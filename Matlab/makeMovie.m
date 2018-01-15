%% Movie
function makeMovie(U,x,x0,xend)
figure();
nframe=size(U,2);
mov(1:nframe)= struct('cdata',[],'colormap',[]);
axis tight manual % this ensures that getframe() returns a consistent size;
set(gca,'nextplot','replacechildren')
set(gca,'YLim', [-2 2]);
set(gca,'XLim', [x0 xend]);

v = VideoWriter('test.avi');
open(v);
%v.FrameRate = 15;

for k=1:nframe
  plot(x,U(:,k))
  frame=getframe(gcf);
  %pause(0.1);
  %v.writeVideo(mov(k));
  writeVideo(v,frame);
end
close(v); 
end
