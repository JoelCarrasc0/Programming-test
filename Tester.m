%% PRUEBA DE CLASE MADRE QUE SUSTENTA LOS METODOS DE TODAS LAS CLASES TEST
classdef Tester < handle

    properties (Access = protected)
        initialData
        correctSolutions
    end
    
    methods (Access = public, Static)
        
        function obj = create(cParams)
            obj = SolverFactory.create(cParams);            
            obj.compute();
        end
        
    end
    
    methods (Access = protected)
        
        function init(obj)
            obj.initialData = load('Tester\cParams.mat');
            obj.correctSolutions = load('Tester\cParams.mat');
        end
        
        function verify(obj)
            
        end
        
    end
    
end

