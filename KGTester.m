classdef KGTester < GlobalStiffnessMatrix
    
    methods (Access = public)
        function obj = KGTester(cParams)
            obj.init(cParams);
        end
    end
    
    methods (Access = protected)
        
        function verify(obj)
            obj.computeKG();
            data = load('Tester\KG.mat');
            if (data.KG == obj.KG) 
                cprintf('green', 'Test pass (Correct KG).\n');
            else
                cprintf('red', 'Test NO pass (Wrong KG).\n');
            end
        end
        
    end
end

