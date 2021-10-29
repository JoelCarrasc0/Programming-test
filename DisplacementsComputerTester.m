classdef DisplacementsComputerTester < handle
    
    properties (Access = private)
        data
        displacements
    end
    
    methods (Access = public)

        function obj = DisplacementsComputerTester(D0,PD)
            obj.data = D0.cParams;
            obj.data.dim = PD.dim;
            obj.data.KG = PD.KG;
            obj.data.Fext = PD.Fext;
            obj.data.restrictions = PD.restrictions;
            obj.obtainCalculatedData();
            obj.verifysolutions();
        end
        
    end
    
    methods (Access = private)
            
        function obtainCalculatedData(obj)
            solution = DisplacementsComputer(obj.data);
            solution.computeU();
            obj.displacements = solution.displacements;
        end
        
        function verifysolutions(obj)
            u = load('TesterData\u.mat');
            if (u.displacements == obj.displacements) 
                cprintf('green', 'Test pass (DisplacementsComputer working properly).\n');
            else
                cprintf('red', 'Test NO pass (DisplacementsComputer failure).\n');
            end
        end
        
    end

end

