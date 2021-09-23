classdef GlobalStiffnessMatrix < handle

    properties (Access = public)
        KG
    end
    
    properties (Access = private)
        Kel
        dim
        Td
        nodalCoordinates
        nodalConnectivities
        materialProperties
        materialConnectivities
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
           obj.nodalCoordinates = cParams.nodalCoordinates;
           obj.materialProperties = cParams.materialProperties;
           obj.materialConnectivities = cParams.materialConnectivities;
           obj.nodalConnectivities = cParams.nodalConnectivities;
       end
        
       function assembleTheGlobalStiffnessMatrix(obj)
           obj.Kel = obj.calculateEveryBar();
           obj.KG = obj.assembleK();
       end
       
       function Kel = calculateEveryBar(obj)
           x=obj.nodalCoordinates;
           mat=obj.materialProperties;
           Tmat=obj.materialConnectivities;
           Tn=obj.nodalConnectivities;
           Kel = zeros(obj.dim.nne*obj.dim.ni,obj.dim.nne*obj.dim.ni,obj.dim.nel);
           for e = 1:obj.dim.nel
                %Computation of every element stiffness matrix
                Ee=mat(Tmat(e),1);
                Ae=mat(Tmat(e),2);
                x1=x(Tn(e,1),1);
                y1=x(Tn(e,1),2);
                x2=x(Tn(e,2),1);
                y2=x(Tn(e,2),2);
                l=sqrt((x2-x1)^2+(y2-y1)^2);
                se=(y2-y1)/l;
                ce=(x2-x1)/l;
                Ke=((Ee*Ae)/l).*[ce^2 ce*se -ce^2 -ce*se;
                                ce*se se^2 -ce*se -se^2;
                                -ce^2 -ce*se ce^2 ce*se;
                                -ce*se -se^2 ce*se se^2];
        
                %Store every element matrix
                for r=1:obj.dim.nne*obj.dim.ni
                    for s=1:obj.dim.nne*obj.dim.ni
                        Kel(r,s,e)=Ke(r,s);
                    end
                end
            end
       end
       
       function KG = assembleK(obj)
           KG = zeros(obj.dim.ndof,obj.dim.ndof);
           for e=1:obj.dim.nel
                for i=1:obj.dim.nne*obj.dim.ni
                    I=obj.Td(e,i);
                    for j=1:obj.dim.nne*obj.dim.ni
                        J=obj.Td(e,j);
                        KG(I,J)=KG(I,J)+obj.Kel(i,j,e);
                    end
                end
           end

       end
 
    end
    
end

