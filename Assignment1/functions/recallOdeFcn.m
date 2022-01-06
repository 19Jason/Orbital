function [allSteps] = recallOdeFcn(fun, T, Y, varargin)
%
% recallOdeFcn - This function allows to compute some parameters used
%                inside the ODE integrations.
% 
% INPUTS:
%         - fun, function, ode function used;
%         - T, double [n° variation, 1], integration time vector;
%         - Y, double [n° variation, 16], state matrix,
%                             [ x y z | u v w | p q r | q0 q1 q2 q3 | m | Ixx Iyy Izz ]:
%                             * (x y z), NED{north, east, down} horizontal frame;
%                             * (u v w), body frame velocities;
%                             * (p q r), body frame angular rates;
%                             * m , total mass;
%                             * (Ixx Iyy Izz), Inertias;
%                             * (q0 q1 q2 q3), attitude unit quaternion.
% 
% OUTPUTS:
%         - allSteps, struct, which contains all the parameters needed.
% 
% CALLED FUNCTIONS: -
% 
% CONTRIBUTORS:
%   Rosato Davide               10618468
%   Saba Mohammadi Yengeje      10789462
%   Spinelli Jason              10618465
%   Tagliati Alessia            10635119
%
% VERSIONS
%   2021-10-21: Release
%
% -------------------------------------------------------------------------

%% MAIN ROUTINE
[~,firstStep] = fun(T(1),Y(1,:),varargin{:});

namesFields = fieldnames(firstStep);
NT = length(T);

steps = cell(NT,1);
for k = 1:NT
    [~,steps{k}] = fun(T(k),Y(k,:),varargin{:});
end

for i = 1:numel(namesFields)
    currentFieldName = namesFields{i};
    currentField = firstStep.(currentFieldName);
    
    if isstruct(currentField)
        namesArrays = fieldnames(currentField);
        
        for j = 1:numel(namesArrays)
            currentArrayName = namesArrays{j};
            currentArray = currentField.(currentArrayName);
            sizeArray = size(currentArray);
            sizeArrayCut = sizeArray;
            
            if any(sizeArray == 1)
                sizeArrayCut = max(sizeArray);
            end
            
            allSteps.(currentFieldName).(currentArrayName) = zeros([sizeArrayCut,NT]);
            
            for k = 1:NT
                currentStep = steps{k};
                
                if all(sizeArray ~= 1)
                    allSteps.(currentFieldName).(currentArrayName)(:,:,k) =...
                        currentStep.(currentFieldName).(currentArrayName);
                else
                    allSteps.(currentFieldName).(currentArrayName)(:,k) =...
                        currentStep.(currentFieldName).(currentArrayName);
                end
            end
            
        end
        
    else
        sizeArray = size(currentField);
        
        sizeArrayCut = sizeArray;
        if any(sizeArray == 1)
            sizeArrayCut = max(sizeArray);
        end
        
        allSteps.(currentFieldName) = zeros([sizeArrayCut,NT]);
        
        for k = 1:NT
            currentStep = steps{k};
            
            if all(sizeArray ~= 1)
                allSteps.(currentFieldName)(:,:,k) =...
                    currentStep.(currentFieldName);
            else
                allSteps.(currentFieldName)(:,k) =...
                    currentStep.(currentFieldName);
            end
        end
        
    end
    
end
end
