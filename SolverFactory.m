classdef SolverFactory < handle
    methods (Access = public, Static) 
        function obj = create(cParams)
            switch cParams.type
                case 'DIRECT'
                    obj = DirectSolver(cParams);
                case 'ITERATIVE'
                    obj = IterativeSolver(cParams);
            end 
        end
    end
end

