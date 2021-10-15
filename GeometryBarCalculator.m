classdef GeometryBarCalculator < handle
    
    properties (Access = public)
        Ke
        Re
        Ee
        le
        Ae
    end
    
    properties (Access = private)
        nodes
        material
        dim
        se
        ce
    end
    
    methods (Access = public)
        
        function obj = GeometryBarCalculator(cParams)
            obj.init(cParams);
        end
        
        function obtainBarProperties(obj)
            obj.computeMat();
            obj.computeLength();
        end
        
        function computeBarK(obj)
            obj.computeK();
        end
        
        function computeRotation(obj)
            obj.computeR();
        end
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.dim = cParams.dim;
            obj.nodes = cParams.nodes;
            obj.material = cParams.material;
        end
        
        function computeMat(obj)
            nBar = obj.dim.nel;
            Tmat = obj.material.Connectivities;
            mat = obj.material.Properties;
            obj.Ee = zeros(nBar,1);
            obj.Ae = zeros(nBar,1);
            for iBar = 1:nBar
                typeOfBar = Tmat(iBar); 
                obj.Ee(iBar) = mat(typeOfBar,1);
                obj.Ae(iBar) = mat(typeOfBar,2);
            end
        end
        
        function computeLength(obj)
            nBar = obj.dim.nel;
            Tn = obj.nodes.Connectivities;
            x = obj.nodes.Coordinates;
            for iBar = 1:nBar
                nodeA = Tn(iBar,1);
                nodeB = Tn(iBar,2);
                x1 = x(nodeA,1);
                y1 = x(nodeA,2);
                x2 = x(nodeB,1);
                y2 = x(nodeB,2);
                obj.le(iBar) = sqrt((x2-x1)^2+(y2-y1)^2);
                obj.se(iBar) = (y2-y1)/obj.le(iBar);
                obj.ce(iBar) = (x2-x1)/obj.le(iBar);
            end
        end
        
        function computeK(obj)
            nBar = obj.dim.nel;
            nBarNode = obj.dim.nne;
            nNodeDOF = obj.dim.ni;
            barDOFs = nNodeDOF*nBarNode;
            obj.Ke = zeros(barDOFs,barDOFs,nBar);
            for iBar = 1:nBar
                cos = obj.ce(iBar);
                sin = obj.se(iBar);
                k = (obj.Ee(iBar)*obj.Ae(iBar))/obj.le(iBar);
                obj.Ke(:,:,iBar) = k.*[cos^2 cos*sin -cos^2 -cos*sin;
                                       cos*sin sin^2 -cos*sin -sin^2;
                                       -cos^2 -cos*sin cos^2 cos*sin;
                                       -cos*sin -sin^2 cos*sin sin^2];
            end
        end
        
        function computeR(obj)
            nBar = obj.dim.nel;
            nNodeDOF = obj.dim.ni;
            nBarNode = obj.dim.nne;
            barDOFs = nNodeDOF*nBarNode;
            obj.Re = zeros(barDOFs,barDOFs,nBar);
            for iBar = 1:nBar
                cos = obj.ce(iBar);
                sin = obj.se(iBar);
                obj.Re(:,:,iBar) = [cos sin 0 0;
                                    -sin cos 0 0;
                                    0 0 cos sin;
                                    0 0 -sin cos];
            end
        end
    end
end

