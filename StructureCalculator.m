classdef StructureCalculator < handle
    
    properties (Access = public)
        displacements
        stress
    end
    
    properties (Access = private)
        dim
        nodes
        material
        forces
        type
        Td
        KG
        Fext
        restrictions
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
    end
    
    methods (Access = private)
        
        function init(obj,cParams)
            obj.nodes = cParams.nodes;
            obj.material = cParams.material;
            obj.forces = cParams.forces;
            obj.type = cParams.type;
        end
        
        function obtainDimensions(obj)
            obj.dim.nd = size(obj.nodes.Coordinates,2);      
            obj.dim.nel = size(obj.nodes.Connectivities,1);  
            obj.dim.nnod = size(obj.nodes.Coordinates,1);    
            obj.dim.nne = size(obj.nodes.Connectivities,2);  
            obj.dim.ni = 2;                                     
            obj.dim.ndof = obj.dim.nnod*obj.dim.ni;             
        end
        
        function connectBarsDOFs(obj)
            s.dim = obj.dim;
            s.nodes = obj.nodes;
            c = DofComputer(s);
            c.computeConnectivity();
            obj.Td = c.Td; 
        end
        
        function computeStiffnessMatrix(obj)
            s.dim = obj.dim;
            s.Td = obj.Td;
            s.nodes = obj.nodes;
            s.material = obj.material;
            c = GlobalStiffnessMatrix(s);
            c.computeKG();
            obj.KG = c.KG;     
        end
        
        function computeExternalForces(obj)
            s.dim = obj.dim;
            s.forces = obj.forces;
            c = ExternalForceComputer(s);
            c.placeFext();
            obj.Fext = c.Fext;
        end
        
        function computeFixDOF(obj)
            s.dim = obj.dim;
            s.nodes = obj.nodes;
            c = DOFixer(s);
            c.computeRestrictions();
            obj.restrictions.imposedU = c.ur;
            obj.restrictions.imposedDOFs = c.vr;
            obj.restrictions.freeDOFs = c.vl;  
        end
        
        function solveDisplacements(obj)
            s.dim = obj.dim;
            s.Fext = obj.Fext;
            s.KG = obj.KG;
            s.restrictions = obj.restrictions;
            s.type = obj.type;
            c = DisplacementsComputer(s);
            c.computeU();
            obj.displacements = c.displacements;        
        end

        function solveStress(obj)
            s.dim = obj.dim;
            s.nodes = obj.nodes;
            s.material = obj.material;
            s.Td = obj.Td;
            s.u = obj.displacements;
            c = StressesComputer(s);
            c.obtainStresses();
            obj.stress = c.stress;  
        end
    end
end

