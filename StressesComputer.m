classdef StressesComputer < handle

    properties (Access = public)
       stress
    end
    
    properties (Access = private)
       dim
       nodalCoordinates
       materialProperties 
       materialConnectivities
       nodalConnectivities
       Td
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
            obj.nodalCoordinates = cParams.nodalCoordinates;
            obj.materialProperties = cParams.materialProperties;
            obj.materialConnectivities = cParams.materialConnectivities;
            obj.nodalConnectivities = cParams.nodalConnectivities;
            obj.Td = cParams.Td;
            obj.displacements = cParams.displacements;
        end
        
        function calculateBarStress(obj)
            obj.stress = obj.calculateStress();
        end
        
        function sig = calculateStress(obj)
            x = obj.nodalCoordinates;
            mat = obj.materialProperties;
            Tmat = obj.materialConnectivities;
            Tn = obj.nodalConnectivities;
            sig = zeros(obj.dim.nel,1);
            for e=1:obj.dim.nel
                Ee=mat(Tmat(e),1);
                x1=x(Tn(e,1),1);
                y1=x(Tn(e,1),2);
                x2=x(Tn(e,2),1);
                y2=x(Tn(e,2),2);
                l=sqrt((x2-x1)^2+(y2-y1)^2);
                se=(y2-y1)/l;
                ce=(x2-x1)/l;
                Re=[ce se 0 0;
                    -se ce 0 0;
                    0 0 ce se;
                    0 0 -se ce];
                ue=zeros(obj.dim.nne*obj.dim.ni,1);
                for i=1:obj.dim.nne*obj.dim.ni
                    I=obj.Td(e,i);
                    ue(i,1)=obj.displacements(I);
                end
                ue_local=Re*ue;
                epsilon=1/l*[-1 0 1 0]*ue_local;
                sig(e,1) = Ee*epsilon;
            end
        end  
    end
end

