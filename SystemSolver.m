classdef SystemSolver < handle
    
    properties (Access = protected)
        LHS
        RHS
    end
    
    properties (Access = public)
        solution
    end
    
    methods (Access = public, Static)
        
        function obj = create(cParams)
            obj = SolverFactory.create(cParams);            
            obj.compute();
        end
        
    end
    
    methods (Access = protected)
        
        function init(obj,cParams)
            obj.LHS = cParams.LHS;
            obj.RHS = cParams.RHS;
        end
        
    end
    
    methods (Access = protected, Abstract)
        
        compute(obj);
        
    end
end

