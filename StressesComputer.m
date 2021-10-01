classdef StressesComputer < handle

    properties (Access = public)
       stress
    end
    
    properties (Access = private)
       dim
       x
       matProp 
       Tmat
       Tn
       Td
       Ee
       le
       se
       ce
       Re
       displacements
    end
    
    methods (Access = public)
        
        function obj = StressesComputer(cParams)
            obj.init(cParams);
        end
        
        function obtainStresses(obj)
            obj.calculateBarStress();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.x = cParams.nodalCoordinates;
            obj.matProp = cParams.materialProperties;
            obj.Tmat = cParams.materialConnectivities;
            obj.Tn = cParams.nodalConnectivities;
            obj.Td = cParams.Td;
            obj.displacements = cParams.displacements;
        end
        
        function calculateBarStress(obj)
            obj.stress = obj.calculateStress();
        end
        
        function sig = calculateStress(obj)
            nBar = obj.dim.nel;
            nBarNode = obj.dim.nne;
            nNodeDOF = obj.dim.ni;
            barDOFs = nNodeDOF*nBarNode;
            sig = zeros(nBar,1);
            for iBar = 1:nBar
                obj.computeBarProperties(iBar);
                obj.computeBarLength(iBar);
                obj.computeRotationMatrix();
                ue = zeros(barDOFs,1);
                for iDOF = 1:barDOFs
                    dofNumber = obj.Td(iBar,iDOF);
                    ue(iDOF,1) = obj.displacements(dofNumber);
                end
                ue_local = obj.Re*ue;
                epsilon = 1/obj.le*[-1 0 1 0]*ue_local;
                sig(e,1) = obj.Ee*epsilon;
            end
        end  
        
        function computeBarProperties(obj,iBar)
           typeOfBar = obj.Tmat(iBar); 
           obj.Ee = obj.matProp(typeOfBar,1);
        end
        
        function computeBarLength(obj,iBar)
            firstNodeNumber = obj.Tn(iBar,1);
            secondNodeNumber = obj.Tn(iBar,2);
            x1 = obj.x(firstNodeNumber,1);
            y1 = obj.x(firstNodeNumber,2);
            x2 = obj.x(secondNodeNumber,1);
            y2 = obj.x(secondNodeNumber,2);
            obj.le = sqrt((x2-x1)^2+(y2-y1)^2);
            obj.se = (y2-y1)/obj.le;
            obj.ce = (x2-x1)/obj.le;
        end
        
        function computeRotationMatrix(obj)
            cos = obj.ce;
            sin = obj.se;
            obj.Re = [cos sin 0 0;
                      -sin cos 0 0;
                      0 0 cos sin;
                      0 0 -sin cos];
        end
        
    end
end

