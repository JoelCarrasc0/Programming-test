classdef StressesComputer < handle

    properties (Access = public)
       stress
    end
    
    properties (Access = private)
       dim
       material
       nodes
       displacements
       Td
    end
    
    methods (Access = public)
        
        function obj = StressesComputer(cParams)
            obj.init(cParams);
        end
        
        function obtainStresses(obj)
            obj.compute();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.nodes = cParams.nodes;
            obj.material = cParams.material;
            obj.Td = cParams.Td;
            obj.displacements = cParams.displacements;
        end
        
        function compute(obj)
            obj.stress = obj.calculateStress();
        end
        
        function sig = calculateStress(obj)
            nBar = obj.dim.nel;
            nBarNode = obj.dim.nne;
            nNodeDOF = obj.dim.ni;
            barDOFs = nNodeDOF*nBarNode;
            c = obj.obtainLocalProperties();
            sig = zeros(nBar,1);
            for iBar = 1:nBar
                Ee = c.Ee(nBar);
                le = c.le(nBar);
                Re = c.Re(:,:,nBar);
                ue = zeros(barDOFs,1);
                for iDOF = 1:barDOFs
                    dofNumber = obj.Td(iBar,iDOF);
                    ue(iDOF,1) = obj.displacements(dofNumber);
                end
                ue_local = Re*ue;
                epsilon = 1/le*[-1 0 1 0]*ue_local;
                sig(iBar,1) = Ee*epsilon;
            end
        end  
        
        function c = obtainLocalProperties(obj)
            s.nodes = obj.nodes;
            s.material = obj.material;
            s.dim = obj.dim;
            c = GeometryBarCalculator(s);
            c.obtainBarProperties();
            c.computeRotation();
        end
    end
end

