classdef TdTester < DofComputer
    
    methods (Access = public)
        function obj = TdTester(cParams)
            obj.init(cParams);
        end
    end
    
    methods (Access = protected)
        
        function verify(obj)
            obj.computeConnectivity();
            data = load('Tester\Td.mat');
            if (data.Td == obj.Td) 
                cprintf('green', 'Test pass (Correct Td).\n');
            else
                cprintf('red', 'Test NO pass (Wrong Td).\n');
            end
        end
        
    end
end

