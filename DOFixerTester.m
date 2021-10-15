classdef DOFixerTester < DOFixer
    
    methods (Access = public)
        function obj = DOFixerTester(cParams)
            obj.init(cParams);
        end
    end
    
    methods (Access = protected)
        
        function verify(obj)
            obj.computeRestrictions();
            data_1 = load('Tester\vl.mat');
            data_2 = load('Tester\vr.mat');
            data_3 = load('Tester\ur.mat');
            if (data_1.vl == obj.vl)
                cprintf('green', 'Test pass (Correct vl).\n');
            else
                cprintf('red', 'Test NO pass (Wrong vl).\n');
            end
            if (data_2.vr == obj.vr)  
                cprintf('green', 'Test pass (Correct vr).\n');
            else
                cprintf('red', 'Test NO pass (Wrong vr).\n');
            end
            if (data_3.ur == obj.ur)
                cprintf('green', 'Test pass (Correct ur).\n');
            else
                cprintf('red', 'Test NO pass (Wrong ur).\n');
            end
        end
        
    end
    
end

