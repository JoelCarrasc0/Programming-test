classdef ExternalForceComputerTester < handle
    
    properties (Access = private)
        data
        Fext
    end
    
    methods (Access = public)

        function obj = ExternalForceComputerTester(D0,PD)
            obj.data = D0.cParams;
            obj.data.dim = PD.dim;
            obj.obtainCalculatedData();
            obj.verifysolutions();
        end
        
    end
    
    methods (Access = private)
            
        function obtainCalculatedData(obj)
            solution = ExternalForceComputer(obj.data);
            solution.placeFext();
            obj.Fext = solution.Fext;
        end
        
        function verifysolutions(obj)
            externalForce = load('TesterData\Fext.mat');
            if (externalForce.Fext == obj.Fext) 
                cprintf('green', 'Test pass (ExternalForceComputer working properly).\n');
            else
                cprintf('red', 'Test NO pass (ExternalForceComputer failure).\n');
            end
        end
        
    end

end

