classdef GlobalStiffnesMatrixTester < handle
    
    properties (Access = public)
        data
        KG
    end
    
    methods (Access = public)

        function obj = DOFComputerTester(D0,PD)
            obj.data = D0.cParams;
            obj.data.dim = PD.dim;
            obj.obtainCalculatedData();
            obj.verifysolutions();
        end
        
    end
    
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

