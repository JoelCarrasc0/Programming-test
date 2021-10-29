classdef DOFixer < handle
 
    properties (Access = public)
        vl
        vr
        ur
    end
    
    properties (Access = private)
        dim
        nodes
    end
    
    methods (Access = public)
                
        function obj = DOFixer(cParams)
            obj.init(cParams);
        end
        
        function computeRestrictions(obj)
            obj.computeRestrictedDOF();
            obj.computeFreeDOFs();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.nodes = cParams.nodes;
        end
        
        function computeRestrictedDOF(obj)
            nNodeDOF = obj.dim.ni;
            fixnod = obj.nodes.fixed;
            resDOF = size(fixnod,1);
            obj.vr = zeros(resDOF,1);
            obj.ur = zeros(resDOF,1);
            for iRDOF = 1:resDOF
                iNode = fixnod(iRDOF,1);
                iDir = fixnod(iRDOF,2);
                iMod = fixnod(iRDOF,3);
                I = nod2dof(iNode,iDir,nNodeDOF);
                obj.vr(iRDOF) = obj.vr(iRDOF)+I;
                obj.ur(iRDOF) = obj.ur(iRDOF)+iMod;
            end
        end
        
        function computeFreeDOFs(obj)
            fixnod = obj.nodes.fixed;
            allDOF = obj.dim.ndof;
            resDOF = size(fixnod,1);
            nonResDOF = abs(resDOF-allDOF);
            obj.vl = zeros(nonResDOF,1);
            aux = (1:allDOF)';
            cont = 1;
            for iDOF = 1:allDOF
                bool = 0;
                for iRDOF = 1:resDOF
                    if aux(iDOF) == obj.vr(iRDOF)
                        bool = 1;
                    end
                end
                if bool == 0
                    obj.vl(cont) = aux(iDOF);
                    cont = cont+1;
                end
            end
        end
    end
end

