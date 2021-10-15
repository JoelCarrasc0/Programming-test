classdef Tester < handle
    
    properties (Access = public)
        data
        stress
        displacements
    end
    
    methods (Access = public)

        function obj = Tester()
            obj.data = load('Tester\cParams.mat');
            solution = StructureCalculator(obj.data.cParams);
            solution.solveStructure();
            obj.displacements = solution.displacements;
            obj.stress = solution.stress;
            obj.verifysolutions();
        end
        
    end
    
    methods (Access = private)
        
        function verifysolutions(obj)
            u = load('Tester\u.mat');
            sig = load('Tester\sig.mat');
                if (u.displacements == obj.displacements) 
                    cprintf('green', 'Test pass (Correct Displacements).\n');
                else
                    cprintf('red', 'Test NO pass (Wrong Displacements).\n');
                end
   
                if(sig.stresses == obj.stress)
                    cprintf('green', 'Test pass (Correct Stresses).\n');
                else
                    cprintf('red', 'Test NO pass (Wrong Stresses).\n');
                end
        end
    end
    
end