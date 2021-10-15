function I = nod2dof(i,j,ni)
%Routine to insert the necessary information in the variables to
%complete the Td matrix
I = ni*(i-1)+j;
end