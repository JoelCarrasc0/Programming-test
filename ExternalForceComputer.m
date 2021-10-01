classdef ExternalForceComputer < handle
    
    properties (Access = public)
        Fext
    end
    
    properties (Access = private)
        dim
        forces    
    end
    
    methods (Access = public)
        
        function obj = ExternalForceComputer(cParams)
            obj.init(cParams);
        end
        
        function placeTheExternalForce(obj)
            obj.setForce();
        end

    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.forces = cParams.forces;
        end
        
        function setForce(obj)
            obj.Fext = obj.placeTheForce();
        end
        
        function Fext = placeTheForce(obj)
            nNodeDOF = obj.dim.ni;
            allDOF = obj.dim.ndof;
            f = obj.forces;
            Fext = zeros(allDOF,1);
            for iForce = 1:size(f,1) 
                nodeNumber = f(iForce,1);
                direction = f(iForce,2);
                module = f(iForce,3);
                I = nod2dof(nodeNumber,direction,nNodeDOF);
                Fext(I) = Fext(I)+module;
            end
        end
        
%         function I = setForceInRightDOF(nodeNumber,direction,nNodeDOF)
%             I = nNodeDOF*(nodeNumber-1)+direction;
%         end

    end
    
end

