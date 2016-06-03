%% Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

%%
% u, space, geometry are values from GeoPDEs for the patch which should be
% used.
% options specifies which kind of field shall be extracted: 'values',
% 'gradient', 'hessian' where 'hessian' especially extracts the B-field
% gradient in x-direction
% xRange and yRange specify the physical area to perform the integration on
% in mm.
% The result is in Tmm ***Careful here***, NOT Tm

function [ q ] = sp_int_phys_2d( u, space, geometry, xRange, yRange, options )
absTolInvMap=1e-5;
% Find the middle of the area to be evaluated
[ut0, vt0]=inv_map_2d(geometry.nurbs, [(xRange(2)+xRange(1))./2; (yRange(2)+yRange(1))./2], [0;0]);

    function [value]=evalphysquad(x,y)
        value=zeros(size(x));
        geo=geometry.nurbs;
        [minXDistances, ~]=min(abs(diff(x(1,:))));
        [minYDistances, ~]=min(abs(diff(y(:,1))));
        
        if (minXDistances<1*absTolInvMap || minYDistances<1*absTolInvMap)
            warning('The relative error tolerance of the inverse mapping is only as big as the distance between points requested! A refinement of absTol is ABSOLUTELY NECESSARY!');
        elseif (minXDistances<2*absTolInvMap || minYDistances<2*absTolInvMap)
            warning('The relative error tolerance of the inverse mapping is only 1/2 as big as the distance between points requested! A refinement of absTol is RECOMMENDED!');
        elseif (minXDistances<5*absTolInvMap || minYDistances<5*absTolInvMap)
            warning('The relative error tolerance of the inverse mapping is only 1/5 as big as the distance between points requested! The accuracy might not be good!');
        elseif (minXDistances<10*absTolInvMap || minYDistances<10*absTolInvMap)
            warning('The relative error tolerance of the inverse mapping is only 1/10 as big as the distance between points requested! The accuracy might not be very good!');
        end
        
        parfor i=1:size(x,1)
            tempValue=zeros(1, size(x,2));
            for j=1:size(x,2)
                [ut, vt] = inv_map_2d(geo, [x(i,j); y(i,j)], [ut0; vt0]);
                if (strcmp(options, 'gradient'))
                    [eu, ~] = sp_eval (u, space, geometry, {ut, vt}, 'gradient');
                    
                    BX=eu(2)*1e3; % Transformation to Wb/m^2 from Wb/mm^2; only 1e3 because for the boundary condition potentials the standard units have been used. The unit mm only arises through the derivative.
                    BY=-eu(1)*1e3; % Transformation to Wb/m^2 from Wb/mm^2
                    tempValue(j)=sqrt(BX.^2+BY.^2);
                elseif (strcmp(options, 'values'))
                    [eu, ~] = sp_eval (u, space, geometry, {ut, vt}, 'value');
                    tempValue(j)=eu;
                elseif (strcmp(options, 'hessian'))
                    
                    [eu, ~]=sp_eval(u, space, geometry, {[ut, vt], [vt, ut]}, 'hessian');
                    %[euGrad, ~]=sp_eval(u, space, geometry, {ut, vt}, 'gradient');
                    euHess=eu.euHess;
                    euGrad=eu.euGrad;
                    
                    BX=euGrad(2,1,1)*1e3; % Transformation to Wb/m^2 from Wb/mm^2; only 1e3 because for the boundary condition potentials the standard units have been used. The unit mm only arises through the derivative.
                    BY=-euGrad(1,1,1)*1e3; % Transformation to Wb/m^2 from Wb/mm^2
                    BAbs=sqrt(BX.^2+BY.^2);
                    
                    tempValue(j)=1./BAbs(:,:).*(BY(:,:).*(-euHess(1,1,1,1)*1e6)+BX(:,:).*euHess(1,2,1,1)*1e6); % Transformation to Wb/m^3 from Wb/mm^3; 1e6 only because A is in standard units and is derived after mm.
                    
                end
            end
            value(i,:)=tempValue(:);
        end
    end


q=quad2d(@evalphysquad, xRange(1), xRange(2), yRange(1), yRange(2), 'AbsTol', 1e-10, 'RelTol', 1e-1, 'FailurePlot',true,'Singular', true);
end

