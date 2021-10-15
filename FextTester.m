classdef FextTester < ExternalForceComputer
    
    methods (Access = public)
        function obj = FextTester(cParams)
            obj.init(cParams);
        end
    end
    
    methods (Access = protected)
        
        function verify(obj)
            obj.placeFext();
            data = load('Tester\Fext.mat');
            if (data.Fext == obj.Fext) 
                cprintf('green', 'Test pass (Correct Fext).\n');
            else
                cprintf('red', 'Test NO pass (Wrong Fext).\n');
            end
        end
        
    end

end

