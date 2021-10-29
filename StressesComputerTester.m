classdef StressesComputerTester < handle
    
    properties (Access = private)
        data
        sig
    end
    
    methods (Access = public)

        function obj = StressesComputerTester(D0,PD)
            obj.data = D0.cParams;
            obj.data.dim = PD.dim;
            obj.data.Td = PD.Td;
            obj.data.u = PD.u;
            obj.obtainCalculatedData();
            obj.verifysolutions();
        end
        
    end
    
    methods (Access = private)
            
        function obtainCalculatedData(obj)
            solution = StressesComputer(obj.data);
            solution.obtainStresses();
            obj.sig = solution.stress;
        end
        
        function verifysolutions(obj)
            stresses = load('TesterData\sig.mat');
            if (stresses.stresses == obj.sig) 
                cprintf('green', 'Test pass (StressesComputer working properly).\n');
            else
                cprintf('red', 'Test NO pass (StressesComputer failure).\n');
            end
        end
        
    end

end