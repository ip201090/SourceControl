% Copyright (c) 2015 Andreas Pels

function [ ] = setFormat( handles, fontSizes )
%SETFORMAT Set format for figures

set(gcf, 'PaperSize', [29.7 21.0], 'PaperPositionMode',...
    'auto', 'Units', 'Centimeters', 'Position', [1 1 28.7 20.0]);
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

