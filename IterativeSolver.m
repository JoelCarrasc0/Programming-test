classdef IterativeSolver < SystemSolver

    methods (Access = public)
        function obj = IterativeSolver(cParams)
            obj.init(cParams);
        end
    end
    
    methods (Access = protected)
        
        function compute(obj)
            obj.solution = pcg(obj.LHS,obj.RHS);
        end
        
    end
end