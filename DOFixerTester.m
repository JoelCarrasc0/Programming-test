classdef DOFixerTester < handle
    
    properties (Access = private)
        data
        vl
        vr
        ur
    end
    
    methods (Access = public)

        function obj = DOFixerTester(D0,PD)
            obj.data = D0.cParams;
            obj.data.dim = PD.dim;
            obj.obtainCalculatedData();
            obj.verifysolutions();
        end
        
    end
    
    methods (Access = protected)
        
        function obtainCalculatedData(obj)
            solution = DOFixer(obj.data);
            solution.computeRestrictions();
            obj.vr = solution.vr;
            obj.vl = solution.vl;
            obj.ur = solution.ur;
        end
        
        function verifysolutions(obj)
            vlData = load('TesterData\vl.mat');
            vrData = load('TesterData\vr.mat');
            urData = load('TesterData\ur.mat');
            if (vlData.vl == obj.vl)
                if (vrData.vr == obj.vr)
                    if (urData.ur == obj.ur)
                        cprintf('green', 'Test pass (DOFixer working properly).\n');
                    else
                        cprintf('red', 'Test NO pass (DOFixer failure).\n');
                    end
                else
                    cprintf('red', 'Test NO pass (DOFixer failure).\n');
                end
            else
                cprintf('red', 'Test NO pass (DOFixer failure).\n');
            end
        end
    end
    
end

