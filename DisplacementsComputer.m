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
        type
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
            obj.ur = cParams.imposedDisplacements;
            obj.vl = cParams.freeDOFs;
            obj.vr = cParams.imposedDOFs;
            obj.type = cParams.type;
        end
        
        function calculateNodeDisplacements(obj)
            obj.displacements = obj.computeDisplacements();
        end
        
        function u = computeDisplacements(obj)
            K_LL = obj.KG(obj.vl,obj.vl);
            K_LR = obj.KG(obj.vl,obj.vr);
            Fext_L = obj.Fext(obj.vl,1);
            s.LHS = K_LL;
            s.RHS = (Fext_L-K_LR*obj.ur);
            s.type = obj.type;
            ul = SystemSolver.create(s);
            u(obj.vl,1) = ul;
            u(obj.vr,1) = obj.ur;
        end 
    end
end

            
