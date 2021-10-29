classdef DofComputer < handle
    
    properties (Access = public)
        Td
    end
    
    properties (Access = private)
        dim
        nodes
    end
   
    methods (Access = public)
                
        function obj = DofComputer(cParams)
            obj.init(cParams);
        end
                
        function computeConnectivity(obj)
            obj.calculate();
        end
        
    end

    methods (Access = private)
        
       function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.nodes = cParams.nodes;
       end
       
       function calculate(obj)
           obj.Td = obj.connectDOF();
       end
       
       function Td = connectDOF(obj)
           nBar = obj.dim.nel;
           nBarNode = obj.dim.nne;
           nNodeDOF = obj.dim.ni;
           barDOFs = nNodeDOF*nBarNode;
           Tn = obj.nodes.Connectivities;
           Td = zeros(nBar,barDOFs);
            for iBar = 1:nBar
                for iNode = 1:nBarNode
                    for iDOF = 1:nNodeDOF
                        I = nod2dof(iNode,iDOF,nNodeDOF);
                        nodeNumber = Tn(iBar,iNode);
                        Td(iBar,I) = nod2dof(nodeNumber,iDOF,nNodeDOF);
                    end
                end
            end
        end
    end
end

