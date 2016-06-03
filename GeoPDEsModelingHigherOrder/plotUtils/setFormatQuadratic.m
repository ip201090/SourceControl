%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ ] = setFormat( handles, fontSizes )
%SETFORMAT Set format for figures

set(gcf, 'PaperSize', [18 18], 'PaperPositionMode',...
    'auto', 'Units', 'Centimeters', 'Position', [1 1 17 17]);
set(gca, 'LineWidth', 1)
set(gca, 'GridLineStyle', ':')
set (gca, 'TickLength', [0.016 0.025]);

if nargin==0
set (gca, 'FontSize', 13)
set(findall(gcf,'type','text'),'FontSize',13);
set(findobj(gcf, 'type', 'line'), 'LineWidth', 2)
%grid on;
else
    for i=1:length(handles)
        set (handles(i), 'FontSize', fontSizes(i))
    end
    set(findobj(gcf, 'type', 'line'), 'LineWidth', 2)
end
end

