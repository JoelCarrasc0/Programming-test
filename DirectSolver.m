classdef DirectSolver < SystemSolver

    methods (Access = public)
        function obj = DirectSolver(cParams)
            obj.init(cParams);
        end
    end
    
    methods (Access = protected)
        
        function compute(obj)
            obj.solution = obj.LHS\obj.RHS;
        end
        
    end
end

