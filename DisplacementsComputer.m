classdef DisplacementsComputer < handle

    properties (Access = public)
        displacements
    end
    
    properties (Access = private)
        dim
        Fext
        KG
        restrictions
        type
    end
    
    methods (Access = public)
        
        function obj = DisplacementsComputer(cParams)
            obj.init(cParams);
        end
        
        function computeU(obj)
            obj.calculate();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.Fext = cParams.Fext;
            obj.KG = cParams.KG;
            obj.restrictions = cParams.restrictions;
            obj.type = cParams.type;
        end
        
        function calculate(obj)
            obj.displacements = obj.computeDisplacements();
        end
        
        function u = computeDisplacements(obj)
            vr = obj.restrictions.imposedDOFs;
            vl = obj.restrictions.freeDOFs;
            ur = obj.restrictions.imposedU;
            K_LL = obj.KG(vl,vl);
            K_LR = obj.KG(vl,vr);
            Fext_L = obj.Fext(vl,1);
            s.LHS = K_LL;
            s.RHS = (Fext_L-K_LR*ur);
            s.type = obj.type;
            solver = SystemSolver.create(s);
            ul = solver.solution();
            u(vl,1) = ul;
            u(vr,1) = ur;
        end 
    end
end

            
