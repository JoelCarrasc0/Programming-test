classdef TdTester < handle
    
    properties (Access = private)
        dim
        nodes
    end
  
    properties (Access = public)
        Td
    end
    
    methods (Access = public)
        
        function obj = TdTester(cParams)
            obj.init(cParams);
        end
        
        function computeTd(obj)
            obj.calculate();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.nodes = cParams.nodes;
        end
        
        function calculate(obj)
            s.dim = obj.dim;
            s.nodes = obj.nodes;
            c = DofComputer(s);
            c.computeConnectivity();
            obj.Td = c.Td;
            obj.verify();
        end
        
        function verify(obj)
            data = load('Tester\Td.mat');
            if (data.Td == obj.Td) 
                cprintf('green', 'Test pass (Correct Td).\n');
            else
                cprintf('red', 'Test NO pass (Wrong Td).\n');
            end
        end
        
    end
end

