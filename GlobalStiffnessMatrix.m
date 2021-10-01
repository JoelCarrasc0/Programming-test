classdef GlobalStiffnessMatrix < handle

    properties (Access = public)
        KG
    end
    
    properties (Access = private)
        Kel
        dim
        Td
        x
        Tn
        matProp
        Tmat
        Ee
        Ae
        le
        Ke
        se
        ce
    end
    
    methods (Access = public)
        
       function obj = GlobalStiffnessMatrix(cParams)
            obj.init(cParams);
       end
       
       function computeTheGlobalStiffnessMatrix(obj)
           obj.assembleTheGlobalStiffnessMatrix();
       end
 
    end
    
    methods (Access = private)
        
       function init(obj,cParams)
           obj.dim = cParams.dim;
           obj.Td = cParams.Td;
           obj.x = cParams.nodalCoordinates;
           obj.matProp = cParams.materialProperties;
           obj.Tmat = cParams.materialConnectivities;
           obj.Tn = cParams.nodalConnectivities;
       end
        
       function assembleTheGlobalStiffnessMatrix(obj)
           obj.Kel = obj.calculateEveryBar();
           obj.KG = obj.assembleK();
       end
       
       function Kel = calculateEveryBar(obj) 
           nBar = obj.dim.nel;
           nBarNode = obj.dim.nne;
           nNodeDOF = obj.dim.ni;
           barDOFs = nNodeDOF*nBarNode;
           Kel = zeros(barDOFs,barDOFs,nBar);
           for iBar = 1:nBar
               obj.computeBarProperties(iBar);
               obj.computeBarLength(iBar);
               obj.computeBarMatrix();
               for iDOF = 1:barDOFs
                    for jDOF = 1:barDOFs
                        Kel(iDOF,jDOF,nBar) = obj.Ke(iDOF,jDOF);
                    end
                end
            end
       end
       
       function computeBarProperties(obj,iBar)
           typeOfBar = obj.Tmat(iBar); 
           obj.Ee = obj.matProp(typeOfBar,1);
           obj.Ae = obj.matProp(typeOfBar,2);
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
       
       function computeBarMatrix(obj)
           cos = obj.ce;
           sin = obj.se;
           obj.Ke =((obj.Ee*obj.Ae)/obj.le).*[cos^2 cos*sin -cos^2 -cos*sin;
                                        cos*sin sin^2 -cos*sin -sin^2;
                                        -cos^2 -cos*sin cos^2 cos*sin;
                                        -cos*sin -sin^2 cos*sin sin^2];
       end
       
       function KG = assembleK(obj)
           nBar = obj.dim.nel;
           nBarNode = obj.dim.nne;
           nNodeDOF = obj.dim.ni;
           barDOFs = nNodeDOF*nBarNode;
           allDOF = obj.dim.ndof;
           KG = zeros(allDOF,allDOF);
           for iBar = 1:nBar
                for iDOF = 1:barDOFs
                    rightRow = obj.Td(iBar,iDOF);
                    for jDOF = 1:barDOFs
                        rightCol = obj.Td(iBar,jDOF);
                        KG(rightRow,rightCol) = KG(rightRow,rightCol)+obj.Kel(iDOF,jDOF,iBar);
                    end
                end
           end

       end
 
    end
    
end

