classdef DofComputer < handle
    
    properties (Access = public)
        Td
    end
    
    properties (Access = private)
        dim
        Tn
    end
   
    methods (Access = public)
        
        function obj = DofComputer(cParams)
            obj.init(cParams);
        end
        
        function computeConnectivity(obj)
            obj.obtainStructureConnectivityMatrix();
        end

    end
    
     methods (Access = private)
        
       function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.Tn = cParams.nodalConnectivities;
       end
       
       function obtainStructureConnectivityMatrix(obj)
           obj.Td = obj.connectDOF();
       end
       
       function Td = connectDOF(obj)
           nBar = obj.dim.nel;
           nBarNode = obj.dim.nne;
           nNodeDOF = obj.dim.ni;
           barDOFs = nNodeDOF*nBarNode;
           Td = zeros(nBar,barDOFs);
            for iBar = 1:nBar
                for iNode = 1:nBarNode
                    for iDOF = 1:nNodeDOF
                        I = nod2dof(iNode,iDOF,nNodeDOF);
                        nodeNumber = obj.Tn(iBar,iNode);
                        Td(iBar,I) = nod2dof(nodeNumber,iDOF,nNodeDOF);
                    end
                end
            end
       end
       
%        function I = obtainDOFmatrixColumns(iNode,iDOF,nNodeDOF)
%            I = nNodeDOF*(iNode-1)+iDOF;
%        end
%        
%        function Td = computeDOFnumberConnection(nodeNumber,iDOF,nNodeDOF)
%            Td = nNodeDOF*(nodeNumber-1)+iDOF;
%        end
        
    end
end

