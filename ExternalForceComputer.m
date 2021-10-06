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
        
        function placeFext(obj)
            obj.compute();
        end

    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.forces = cParams.forces;
        end
        
        function compute(obj)
            obj.Fext = obj.placeF();
        end
        
        function Fext = placeF(obj)
            nNodeDOF = obj.dim.ni;
            allDOF = obj.dim.ndof;
            f = obj.forces;
            Fext = zeros(allDOF,1);
            for iForce = 1:size(f,1) 
                iNode = f(iForce,1);
                iDir = f(iForce,2);
                iMod = f(iForce,3);
                I = nod2dof(iNode,iDir,nNodeDOF);
                Fext(I) = Fext(I)+iMod;
            end
        end

    end
    
end

