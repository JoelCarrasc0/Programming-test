classdef StructureCalculator < handle
    
    properties (Access = public)
        displacements
        stress
    end
    
    properties (Access = private)
        dim
        nodalCoordinates
        nodalConnectivities
        materialProperties
        materialConnectivities
        forces
        fixedNodes
        Td
        KG
        Fext
        ur
        vr
        vl
    end    
    
    methods (Access = public)
        
        function obj = StructureCalculator(cParams)
            obj.init(cParams);
        end
        
        function solveStructure(obj)
            obj.obtainDimensions();
            obj.connectBarsDOFs();
            obj.computeStiffnessMatrix();
            obj.computeExternalForces();
            obj.computeFixDOF();
            obj.solveDisplacements();
            obj.solveStress();
        end
        
        function verifySolutions(obj)
            obj.checkResults();
        end
        
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.nodalCoordinates = cParams.nodalCoordinates;
            obj.nodalConnectivities = cParams.nodalConnectivities;
            obj.materialProperties = cParams.materialProperties;
            obj.materialConnectivities = cParams.materialConnectivities;
            obj.forces = cParams.forces;
            obj.fixedNodes = cParams.fixedNodes;
        end
        
        function obtainDimensions(obj)
            obj.dim.nd = size(obj.nodalCoordinates,2);      
            obj.dim.nel = size(obj.nodalConnectivities,1);  
            obj.dim.nnod = size(obj.nodalCoordinates,1);    
            obj.dim.nne = size(obj.nodalConnectivities,2);  
            obj.dim.ni = 2;                                     
            obj.dim.ndof = obj.dim.nnod*obj.dim.ni;             
        end
        
        function connectBarsDOFs(obj)
            s.dim = obj.dim;
            s.nodalConnectivities = obj.nodalConnectivities;
            c = DofComputer(s);
            c.computeConnectivity()
            obj.Td = c.Td; 
        end
        
        function computeStiffnessMatrix(obj)
            s.dim = obj.dim;
            s.Td = obj.Td;
            s.nodalCoordinates = obj.nodalCoordinates;
            s.materialProperties = obj.materialProperties;
            s.materialConnectivities = obj.materialConnectivities;
            s.nodalConnectivities = obj.nodalConnectivities;
            c = GlobalStiffnessMatrix(s);
            c.computeTheGlobalStiffnessMatrix();
            obj.KG = c.KG;     
        end
        
        function computeExternalForces(obj)
            s.dim = obj.dim;
            s.forces = obj.forces;
            c = ExternalForceComputer(s);
            c.placeTheExternalForce()
            obj.Fext = c.Fext;
        end
        
        function computeFixDOF(obj)
            s.dim = obj.dim;
            s.fixedNodes = obj.fixedNodes;
            c = DOFixer(s);
            c.FixDOFs();
            obj.ur = c.ur;
            obj.vr = c.vr;
            obj.vl = c.vl;  
        end
        
        function solveDisplacements(obj)
            s.dim = obj.dim;
            s.Fext = obj.Fext;
            s.KG = obj.KG;
            s.ur = obj.ur;
            s.vr = obj.vr;
            s.vl = obj.vl;
            c = DisplacementsComputer(s);
            c.obtainNodeDisplacements();
            obj.displacements = c.displacements;        
        end

        function solveStress(obj)
            s.dim = obj.dim;
            s.nodalCoordinates = obj.nodalCoordinates;
            s.materialProperties = obj.materialProperties;
            s.materialConnectivities = obj.materialConnectivities;
            s.nodalConnectivities = obj.nodalConnectivities;
            s.Td = obj.Td;
            s.displacements = obj.displacements;
            c = StressesComputer(s);
            c.obtainStresses();
            obj.stress = c.stress;  
        end
        
        function checkResults(obj)
            lookForMistakes(obj);
        end
    end
end

