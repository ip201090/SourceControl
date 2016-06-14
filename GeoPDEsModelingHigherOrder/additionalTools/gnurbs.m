function out = gnurbs(mode,res)
% GNURBS  Interactive manipulation of NURBS surface/curve
%
%    For use with the NURBS toolbox, GNURBS allows the user to have an
%    intuitive manipulation of a NURBS surface/curve via control points.  
%
%    GNURBS with no inputs will generate a test surface for manipulation.
%    GNURBS(NRB), where NRB is a structure defining a NURBS surface/curve
%    (as defined in the NURBS toolbox).
%    GNURBS(NRB,RES), where RES is a 2 element vector defines the
%    resolution of surface/curve rendering in the u and v directions, 
%    ie RES = [URES,VRES].  The default is [20,20] if no argument is
%    specified.
%    
%    <a href="http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=312&objectType=file">NURBS toolbox</a> can be downloaded for free at
%    http://www.mathworks.com/matlabcentral/fileexchange/
%
%    Example usage:
%    % Generate a NURBS surface
%    gnurbs



if ~nargin
    mode = 'start';
    nrb = nrbtestsrf; % Default Surface
    res = [20 20]; % Default Resolution
elseif isstruct(mode)
    nrb=mode;
    mode='start';
    if nargin<2
        res = [20 20]; % Default Resolution
    end
elseif isempty(mode)
    nrb=nrbtestsrf;
    mode='start';
    if nargin<2
        res = [20 20]; % Default Resolution
    end
elseif ischar(mode)
    fig = gcf;
    ud = get(gcbo,'userdata');
    if strcmp(get(gcbo,'type'),'axes')
        hnet = get(gcbo,'userdata');
        ud = get(hnet,'userdata');
    end
%     disp(mode)
else
    error('GNURBS: Wrong type of input')
end


switch mode
    case 'start'
        % Build surface from NURBS structure
        [x,y,z] = nrb2xyz(nrb,res);
        % Get control net
        [xn,yn,zn] = nrb2net(nrb);
        % Plot
        fig = gcf;
        ax = gca;
        axis equal
        
        n = length(nrb.order);
        
        if n > 1
            hsurf = surface(x,y,z,'parent',ax,'facecolor','interp',...
                        'facealpha',.5,'edgealpha',.2);
            hnet  = surface(xn,yn,zn,'parent',ax,'facecolor','none',...
                        'edgecolor','k','marker','o','linestyle',':',...
                        'markeredgecolor','k','markerfacecolor','r',...
                        'markersize',5);
        else            
            hsurf = line(x,y,z,'parent',ax,'linestyle','-','color','k');
            hnet  = line(xn,yn,zn,'parent',ax,...
                        'color','k','marker','o','linestyle',':',...
                        'markeredgecolor','k','markerfacecolor','r',...
                        'markersize',5);                       
        end            
        hcur  = line(0,0,0,'marker','o','markerfacecolor','g',...
                     'markeredgecolor','k','hittest','off','visible','off',...
                     'markersize',5);
                    

      
        % Store handles and data in figure userdata
        ud.ax    = ax;
        ud.hsurf = hsurf;
        ud.hnet  = hnet;
        ud.hcur  = hcur;
        ud.nrb   = nrb;
        ud.res   = res;
        set(hnet,'UserData',ud);
        
        % Set Callbacks
        set(hsurf,'ButtonDownFcn','','hittest','off');
        set([hnet gca], 'ButtonDownFcn','gnurbs(''click'')');
        set(gca,'userdata',hnet);
        
        % Outputs
        if nargout
            out = hsurf;
        end
        
    case 'click'        
        [dist,ind] = getClosestPtToLine(ud.hnet);
        
        % Don't do anything if too far from closest point
        if dist > selectThreshold
           return 
        end
        ud.ind = ind;
        [xn,yn,zn] = nrb2net(ud.nrb);
        setxyz(ud.hcur,xn(ind),yn(ind),zn(ind));
        set(ud.hcur,'visible','on');  
        storeparams(fig,ud);
        set(fig,'WindowButtonMotionFcn','gnurbs(''move'')');
        set(fig,'WindowButtonUpFcn','gnurbs(''up'')');
%         set(fig,'UserData',ud);
        
    case 'move'
        stabVector = get(ud.ax,'CurrentPoint');
        [xn,yn,zn] = nrb2net(ud.nrb);
        ind = ud.ind;
        ptOnViewPlane = [xn(ind),yn(ind),zn(ind)];
        [x,y,z] = vectorPlaneIntersect(stabVector,getViewPlane,ptOnViewPlane);
        xn(ind) = x;
        yn(ind) = y;
        zn(ind) = z;
        coefs = net2nrb(xn,yn,zn);
        ud.nrb.coefs = coefs;
        [X,Y,Z] = nrb2xyz(ud.nrb,ud.res);
        setxyz(ud.hcur,x,y,z);     % Update Highlight point
        setxyz(ud.hsurf,X,Y,Z);    % Update Surface
        setxyz(ud.hnet,xn,yn,zn);  % Update Control Net
        setxyz(ud.hcur,x,y,z);     % Update Hightlight point
        set(fig,'UserData',ud);
        set(ud.hnet,'userdata',ud);
        set(ud.hsurf,'userdata',ud.nrb);
    case 'up'
        set(ud.hcur,'visible','off');
        resetparams(fig);
    otherwise
        error('GNURBS: Wrong input string')
end



function thresh = selectThreshold
axesSize = diff([get(gca,'xlim'); get(gca,'ylim'); get(gca,'zlim')],[],2);
thresh = sqrt(sum(axesSize.^2))/50;
        

function N = getViewPlane
M = view;               % Current View matrix
up = [0 0 1]';          % Up vector
N = (M(1:3,1:3)\up)';   % Normal vector to viewing plane


function [X,Y,Z] = vectorPlaneIntersect(vec,N,pt)

P0 = vec(1,:);         % 1st point on stabbing vector
P1 = vec(2,:);         % 2nd point on stabbing vector
P2 = pt(:)';           % Point on viewing plane (constrains depth ambiguity)

% Solve for point where stabbing vector intersects viewing plane
u = dot(N,P2-P0)./dot(N,P1-P0);
s = (P1-P0)*u + P0;

% Separate components
X = s(1);
Y = s(2);
Z = s(3);


function [dist,ind] = getClosestPtToLine(h)
% GETCLOSESTPTTOLINE  Finds the closest point in a data set to a line
%    In this case, the data set is defined by a surface and the line is
%    simply the result of get(gca,'CurrentPoint').
%    I = GETCLOSESTPTTOLINE(H) returns the index of the point in H closest to a 
%    mouse click in the figure.  H is a handle to a surface object.

% Daniel Claxton
% 02-Mar-2007
% dclaxton@ufl.edu

x = get(h,'xdata');
y = get(h,'ydata');
z = get(h,'zdata');
if isempty(z), z = x*0; end
n = numel(x);
ax = get(h,'parent');
cpt = get(ax,'CurrentPoint');
% Find vector in direction of line
u = diff(cpt);
% Normalize line vector
mag = sqrt(sum(u.^2));
mag = max(eps,mag);
u = u/mag;
% First Point on line (P1)
v = cpt(1,:);
d = zeros(n,1);
for i=1:n
    pt = [x(i) y(i) z(i)];
    % Make vector between P1 and point
    w = pt - v;
    % Dot product gives us the magnitude of projection of w onto line
    f = u*w';
    % Multiply magnitude of projection times unit vector u (direction of line)
    % Shift from orgin to P1
    p = f*u + v;
    % Find shortest distance from point to point on line
    d(i) = sqrt(sum((pt-p).^2,2));
end
[dist,ind] = min(d);


function [x,y,z] = nrb2net(srf)
% NRB2NET  Get control net from NURBS structure
x=squeeze(srf.coefs(1,:,:));
y=squeeze(srf.coefs(2,:,:));
z=squeeze(srf.coefs(3,:,:));


function nrb = net2nrb(x,y,z)
% NET2NRB Get NURBS coefficients from control net
[m,n]=size(x);
x = reshape(x,1,m,n);
y = reshape(y,1,m,n);
z = reshape(z,1,m,n);
one = ones(1,m,n);

nrb = cat(1,x,y);
nrb = cat(1,nrb,z);
nrb = cat(1,nrb,one);


function [x,y,z] = nrb2xyz(nrb,res)
% NRB2XYZ  Evaluate NURBS with a given resolution

n = length(nrb.order);
if n > 1
    nu = res(1);
    nv = res(2);
    p = nrbeval(nrb,{linspace(0,1,nu),linspace(0,1,nv)});
else
    p = nrbeval(nrb,linspace(0,1,res(1)));
end
x = squeeze(p(1,:,:));
y = squeeze(p(2,:,:));
z = squeeze(p(3,:,:));


function setxyz(h,x,y,z)
% SETXYZ  Set X,Y,Z Data of graphics handle object
set(h,'Xdata',x);
set(h,'Ydata',y);
set(h,'Zdata',z);

if strcmp(get(h,'type'),'surface')
    set(h,'cdata',z/max(z(:)));
end
                  

function ud = storeparams(fig,ud)
ud.udata = get(fig,'userdata');
ud.down  = get(fig,'windowbuttondownfcn');
ud.move  = get(fig,'windowbuttonmotionfcn');
ud.up    = get(fig,'windowbuttonupfcn');
set(fig,'userdata',ud);

function resetparams(fig)
ud = get(fig,'userdata');
set(fig,'userdata',ud.udata','windowbuttondownfcn',ud.down,...
    'windowbuttonmotionfcn',ud.move,'windowbuttonupfcn',ud.up);