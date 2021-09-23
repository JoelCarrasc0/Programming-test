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
        %Assembly of the force matrix
            fdata = obj.forces;
            Fext=zeros(obj.dim.ndof,1);
            for e=1:size(fdata,1)
                I=nod2dof(fdata(e,1),fdata(e,2),obj.dim.ni);
                Fext(I)=Fext(I)+fdata(e,3);
            end
        end

    end
    
end

