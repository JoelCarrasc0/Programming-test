clear
close all
%% INPUT DATA
%Definition of the position of every node and force value
H1 = 0;
H2 = 0.2;
H3 = 0.4;
H4 = 0.6;
H5 = 0.5;
H6 = 0.6;
H7 = 0.7;
H8 = 0.8;
L1 = 0;
L2 = 0.5;
L3 = 1;
L4 = 1.5;
L5 = 0;
L6 = 0.5;
L7 = 1;
L8 = 1.5;
F = 720;
%Definition of the material bar parameters
E = 68000e6;
A = 150e-6;
rho = 3100;

%% PREPROCESS (Definition of cParams)
% Nodal coordinates matrix
cParams.nodalCoordinates = [L1,    H1;
                            L2,    H2;
                            L3,    H3;
                            L4,    H4;
                            L5,    H5;
                            L6,    H6;
                            L7,    H7;
                            L8,    H8
                            ];
% Nodal connectivities matrix
cParams.nodalConnectivities = [1 2;
                               2 3;
                               3 4;
                               5 6;
                               6 7;
                               7 8;
                               1 5;
                               1 6;
                               5 2;
                               2 6;
                               2 7;
                               6 3;
                               3 7;
                               3 8;
                               7 4;
                               4 8   
                               ];
% Material properties matrix
cParams.materialProperties = [E A rho];
% Material connectivities matrix
cParams.materialConnectivities = [1;
                                  1;
                                  1;
                                  1;
                                  1;
                                  1;
                                  1;
                                  1;
                                  1;
                                  1;
                                  1;
                                  1;
                                  1;
                                  1;
                                  1;
                                  1
                                  ];

% Point loads matrix (number of node, direction, magnitude)
cParams.forces = [2,2,F;
                  3,2,F;
                  4,2,F
                  ];
% Fixed nodes matrix (number of node, direction, magnitude)
cParams.fixedNodes = [1,1,0;
                      1,2,0;
                      5,1,0;
                      5,2,0
                      ];

%% SOLVER
structure = StructureCalculator(cParams);
structure.solveStructure();
structure.verifySolutions();
% structure.plotDeformedStructure();



