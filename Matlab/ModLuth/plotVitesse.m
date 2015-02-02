function plotVitesse (temps, vitesses, handles, fileName)

jour2sec = 24*60*60;

dataTime = (temps - temps(1))/jour2sec;
if (nargin == 4)
	figure;
	title(['Vitesses: ', fileName]);
end

if (nargin == 3)
	axes(handles.axes_u);	
	cla;
else
	subplot(3,1,1);
	
end

plot (dataTime(1:end-1), vitesses(1:end-1,1))
legend('U (m/s)');
grid on;
if (nargin == 4)
	title(['Vitesses: ', fileName]);
end

if (nargin ==3)
	axes(handles.axes_v);
	cla;
else
	subplot(3,1,2);
	
end
plot (dataTime(1:end-1), vitesses(1:end-1,2))
legend('V (m/s)');
grid on;


if (nargin == 3)
	axes(handles.axes_total);
	cla;
else
	subplot(3,1,3);
end

plot (dataTime(1:end-1), vitesses(1:end-1,3))
xlabel('temps (jours)','FontSize',12)
legend('Total (m/s)');
grid on;



