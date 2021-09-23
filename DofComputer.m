classdef DofComputer < handle
    
    properties (Access = public)
        Td
    end
    
    properties (Access = private)
        dim
        nodalConnectivities
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
            obj.nodalConnectivities = cParams.nodalConnectivities;
       end
       
       function obtainStructureConnectivityMatrix(obj)
           obj.Td = obj.connectDOF();
       end
       
       function Td = connectDOF(obj)
           Td = zeros(obj.dim.nel,obj.dim.nne*obj.dim.ni);
            for e=1:obj.dim.nel
                for i=1:obj.dim.nne
                    for j=1:obj.dim.ni
                        I=nod2dof(i,j,obj.dim.ni);
                        Td(e,I)=nod2dof(obj.nodalConnectivities(e,i),j,obj.dim.ni);
                    end
                end
            end
       end
       
    end
end

