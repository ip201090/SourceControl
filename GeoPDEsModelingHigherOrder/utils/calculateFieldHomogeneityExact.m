## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

function [ fieldHomogeneity ] = calculateFieldHomogeneityExact( u, space, geometry, xRange, yRange, averageGradient )
%CALCULATEFIELDHOMOGENEITY Calculates the field homogeneity in the given
%area in x-direction
%   [ fieldHomogeneity ] = CALCULATEFIELDHOMOGENEITY( fieldGradient, averageFieldGradient )
%   calculates the field homogeneity to the B-field gradients given
%   in 'fieldGradient' and the average field gradient given in 'averageFieldGradient'. 
%   It uses the simple rectangle method to approximate integrals. 


absTolInvMap=1e-5;
% Find the middle of the area to be evaluated
[ut0, vt0]=inv_map_2d(geometry.nurbs, [(xRange(2)+xRange(1))./2; (yRange(2)-yRange(1))./2], [0; 0]);

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
            
            if mod(size(x,2),2)==1
                j=size(x,2);
                
                [ut, vt] = inv_map_2d(geo, [x(i,j); y(i,j)], [ut0; vt0]);
                
                [eu, ~]=sp_eval(u, space, geometry, {[ut, vt], [vt, ut]}, 'hessian');
                %[euGrad, ~]=sp_eval(u, space, geometry, {ut, vt}, 'gradient');
                euHess=eu.euHess;
                euGrad=eu.euGrad;
                
                BX=euGrad(2,1,1)*1e3; % Transformation to Wb/m^2 from Wb/mm^2; only 1e3 because for the boundary condition potentials the standard units have been used. The unit mm only arises through the derivative.
                BY=-euGrad(1,1,1)*1e3; % Transformation to Wb/m^2 from Wb/mm^2
                BAbs=sqrt(BX.^2+BY.^2);
                
                gradient=1./BAbs(:,:).*(BY(:,:).*(-euHess(1,1,1,1)*1e6)+BX(:,:).*euHess(1,2,1,1)*1e6); % Transformation to Wb/m^3 from Wb/mm^3; 1e6 only because A is in standard units and is derived after mm.
                
                tempValue(j)=(gradient./averageGradient-1).^2;
            end
            if size(x,2)>1
                for j=1:2:size(x,2)-1
                    [ut, vt] = inv_map_2d(geo, [x(i,j); y(i,j)], [ut0; vt0]);
                    [utt, vtt] = inv_map_2d(geo, [x(i,j+1); y(i,j+1)], [ut0; vt0]);
                    
                    [eu, ~]=sp_eval(u, space, geometry, {[ut, utt], [vt, vtt]}, 'hessian');
                    %[euGrad, ~]=sp_eval(u, space, geometry, {ut, vt}, 'gradient');
                    euHess=eu.euHess;
                    euGrad=eu.euGrad;
                    
                    % First point
                    BX=euGrad(2,1,1)*1e3; % Transformation to Wb/m^2 from Wb/mm^2; only 1e3 because for the boundary condition potentials the standard units have been used. The unit mm only arises through the derivative.
                    BY=-euGrad(1,1,1)*1e3; % Transformation to Wb/m^2 from Wb/mm^2
                    BAbs=sqrt(BX.^2+BY.^2);
                    
                    gradient=1./BAbs(:,:).*(BY(:,:).*(-euHess(1,1,1,1)*1e6)+BX(:,:).*euHess(1,2,1,1)*1e6); % Transformation to Wb/m^3 from Wb/mm^3; 1e6 only because A is in standard units and is derived after mm.
                    
                    tempValue(j)=(gradient./averageGradient-1).^2;
                    
                    % Second point
                    BX=euGrad(2,2,2)*1e3; % Transformation to Wb/m^2 from Wb/mm^2; only 1e3 because for the boundary condition potentials the standard units have been used. The unit mm only arises through the derivative.
                    BY=-euGrad(1,2,2)*1e3; % Transformation to Wb/m^2 from Wb/mm^2
                    BAbs=sqrt(BX.^2+BY.^2);
                    
                    gradient=1./BAbs(:,:).*(BY(:,:).*(-euHess(1,1,2,2)*1e6)+BX(:,:).*euHess(1,2,2,2)*1e6); % Transformation to Wb/m^3 from Wb/mm^3; 1e6 only because A is in standard units and is derived after mm.
                    
                    tempValue(j+1)=(gradient./averageGradient-1).^2;
                end
            end
            
            
            value(i,:)=tempValue(:);
            
        end
end
    
    fieldHomogeneity=sqrt(quad2d(@evalphysquad, xRange(1), xRange(2), yRange(1), yRange(2), 'AbsTol', 1e-10, 'RelTol', 1e-1, 'FailurePlot',true, 'Singular', true)./abs((xRange(1)-xRange(2))*(yRange(1)-yRange(2))));


end

