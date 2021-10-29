function testSolutions
    %PREAMBLE
    initialData = load('TesterData\cParams.mat');
    dimensions = load('TesterData\dim.mat');
    connectivities = load('TesterData\Td.mat');
    stiffnessMatrix = load('TesterData\KG.mat');
    externalForce = load('TesterData\Fext.mat');
    restrictions = load('TesterData\restrictions.mat');
    displacements = load('TesterData\u.mat');
    precalculatedData.dim = dimensions.dim;
    precalculatedData.Td = connectivities.Td;
    precalculatedData.KG = stiffnessMatrix.KG;
    precalculatedData.Fext = externalForce.Fext;
    precalculatedData.restrictions = restrictions.restrictions;
    precalculatedData.u = displacements.displacements;
    %TESTERS
    StructureCalculatorTester(initialData);
    DOFComputerTester(initialData,precalculatedData);
    GlobalStiffnessMatrixTester(initialData,precalculatedData);
    ExternalForceComputerTester(initialData,precalculatedData);
    DOFixerTester(initialData,precalculatedData);
    DisplacementsComputerTester(initialData,precalculatedData);
    %SystemSolverTester(initialData,precalculatedData);
    StressesComputerTester(initialData,precalculatedData);
end