classdef GlobalStiffnessMatrixTester < handle
    
    properties (Access = private)
        data
        KG
    end
    
    methods (Access = public)

        function obj = GlobalStiffnessMatrixTester(D0,PD)
            obj.data = D0.cParams;
            obj.data.dim = PD.dim;
            obj.data.Td = PD.Td;
            obj.obtainCalculatedData();
            obj.verifysolutions();
        end
        
    end
    
    methods (Access = private)
        
        function obtainCalculatedData(obj)
            solution = GlobalStiffnessMatrix(obj.data);
            solution.computeKG();
            obj.KG = solution.KG;
        end
        
        function verifysolutions(obj)
            globalStiffnessMatrix = load('TesterData\KG.mat');
            if (globalStiffnessMatrix.KG == obj.KG) 
                cprintf('green', 'Test pass (GlobalStiffnessMatrix working properly).\n');
            else
                cprintf('red', 'Test NO pass (GlobalStiffnessMatrix failure).\n');
            end
        end
        
    end
end

