classdef GlobalStiffnessMatrix < handle

    properties (Access = public)
        KG
    end
    
    properties (Access = private)
        Kel
        dim
        Td
        nodes
        material
    end
    
    methods (Access = public)
        
       function obj = GlobalStiffnessMatrix(cParams)
            obj.init(cParams);
       end
       
       function computeKG(obj)
           obj.compute();
       end
 
    end
    
    methods (Access = private)
        
       function init(obj,cParams)
           obj.dim = cParams.dim;
           obj.Td = cParams.Td;
           obj.nodes = cParams.nodes;
           obj.material = cParams.material;
       end
        
       function compute(obj)
           obj.Kel = obj.calculateEveryBar();
           obj.KG = obj.assembleK();
       end
       
       function Kel = calculateEveryBar(obj) 
           s.nodes = obj.nodes;
           s.material = obj.material;
           s.dim = obj.dim;
           c = GeometryBarCalculator(s);
           c.obtainBarProperties();
           c.computeBarK();
           Kel = c.Ke;
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
                    iRow = obj.Td(iBar,iDOF);
                    for jDOF = 1:barDOFs
                        iCol = obj.Td(iBar,jDOF);
                        KG(iRow,iCol) = KG(iRow,iCol)+obj.Kel(iDOF,jDOF,iBar);
                    end
                end
            end
        end
    end
end

