classdef DOFComputerTester < handle
    
    properties (Access = private)
        data
        Td
    end
    
    methods (Access = public)

        function obj = DOFComputerTester(D0,PD)
            obj.data = D0.cParams;
            obj.data.dim = PD.dim;
            obj.obtainCalculatedData();
            obj.verifysolutions();
        end
        
    end
    
    methods (Access = private)
        
        function obtainCalculatedData(obj)
            solution = DofComputer(obj.data);
            solution.computeConnectivity();
            obj.Td = solution.Td;
        end
        
        function verifysolutions(obj)
            DOFconnectivityMatrix = load('TesterData\Td');
            if (DOFconnectivityMatrix.Td == obj.Td)
                cprintf('green', 'Test pass (DOFComputer working properly).\n');
            else
                cprintf('red', 'Test NO pass (DOFcomputer failure).\n');
            end
        end
        
    end
end

