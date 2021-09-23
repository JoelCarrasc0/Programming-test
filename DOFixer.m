classdef DOFixer < handle
 
    properties (Access = public)
        vl
        vr
        ur
    end
    
    properties (Access = private)
        dim
        fixedNodes
    end
    
    methods (Access = public)
        
        function obj = DOFixer(cParams)
            obj.init(cParams);
        end
        
        function FixDOFs(obj)
            obj.computeRestrictedDOF();
        end

    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.fixedNodes = cParams.fixedNodes;
        end
        
        function computeRestrictedDOF(obj)
            [obj.ur,obj.vr,obj.vl]= obj.setFixedDOF();
        end
        
        function [ur,vr,vl] = setFixedDOF(obj)
            fixnod = obj.fixedNodes;
            vr=zeros(size(fixnod,1),1);
            vl=zeros(abs(size(fixnod,1)-obj.dim.ndof),1);
            ur=zeros(size(fixnod,1),1);
            aux=(1:obj.dim.ndof)';
            for i=1:size(fixnod,1)
                I=nod2dof(fixnod(i,1),fixnod(i,2),obj.dim.ni);
                vr(i)=vr(i)+I;
                ur(i)= ur(i)+fixnod(i,3);
            end
            cont=1;
            for j=1:obj.dim.ndof
                w=0;
                for k=1:size(fixnod,1)
                    if aux(j)==vr(k)
                        w=1;
                    end
                end
                if w==0
                    vl(cont)=aux(j);
                    cont=cont+1;
                end
            end
        end 
    end
end

