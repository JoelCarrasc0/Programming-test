classdef StructureCalculatorTester < handle
    
    properties (Access = private)
        data
        stress
        displacements
    end
    
    methods (Access = public)

        function obj = StructureCalculatorTester(D0)
            obj.data = D0.cParams;
            obj.obtainCalculatedData();
            obj.verifysolutions();
        end
        
    end
    
    methods (Access = private)
        
        function obtainCalculatedData(obj)
            solution = StructureCalculator(obj.data);
            solution.solveStructure();
            obj.displacements = solution.displacements;
            obj.stress = solution.stress;
        end
        
        function verifysolutions(obj)
            u = load('TesterData\u.mat');
            sig = load('TesterData\sig.mat');
                if (u.displacements == obj.displacements)
                    if (sig.stresses == obj.stress)
                        cprintf('green', 'Test pass (StructureCalculator working properly).\n');
                    else
                        cprintf('red', 'Test NO pass (StructureCalculator failure).\n');
                    end
                else
                    cprintf('red', 'Test NO pass (StructureCalculator failure).\n');
                end
        end
    end
end