%% GIF
function makeGIF(U,x0,xend)
h = figure;
axis tight manual % this ensures that getframe() returns a consistent size
set(gca,'YLim', [-2 2]);
set(gca,'XLim', [x0 xend]);
set(gca,'nextplot','replacechildren')
filename = 'fem.gif';
for n = 1:size(U,2)
    % Draw plot for y = x.^n
    
    
    plot(x,U(:,n)) 
    drawnow 
      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if n == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
      end 
 end
end