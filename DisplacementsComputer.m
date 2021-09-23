classdef DisplacementsComputer < handle

    properties (Access = public)
        displacements
    end
    
    properties (Access = private)
        dim
        Fext
        KG
        ur
        vl
        vr 
    end
    
    methods (Access = public)
        
        function obj = DisplacementsComputer(cParams)
            obj.init(cParams);
        end
        
        function obtainNodeDisplacements(obj)
            obj.calculateNodeDisplacements();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.Fext = cParams.Fext;
            obj.KG = cParams.KG;
            obj.ur = cParams.ur;
            obj.vl = cParams.vl;
            obj.vr = cParams.vr;
        end
        
        function calculateNodeDisplacements(obj)
            obj.displacements = obj.computeDisplacements();
        end
        
        function u = computeDisplacements(obj)
            K_LL=obj.KG(obj.vl,obj.vl);
            K_LR=obj.KG(obj.vl,obj.vr);
            K_RL=obj.KG(obj.vr,obj.vl);
            K_RR=obj.KG(obj.vr,obj.vr);
            Fext_L=obj.Fext(obj.vl,1);
            Fext_R=obj.Fext(obj.vr,1);
            %Resolution of the system of equations:
            ul=K_LL\(Fext_L-K_LR*obj.ur);
            R=K_RR*obj.ur+K_RL*ul-Fext_R;
            %Unification of the displacements:
            u=zeros(obj.dim.nne*obj.dim.ni,1);
            u(obj.vl,1)=ul;
            u(obj.vr,1)=obj.ur;
        end 
    end
end

