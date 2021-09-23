function lookForMistakes(obj)
u = load('u.mat');
sig = load('sig.mat');
    if (u.displacements == obj.displacements) 
        cprintf('green', 'Test 1 pass (Correct Displacements).\n');
    end
   
    if(sig.stresses == obj.stress)
        cprintf('green', 'Test 2 pass (Correct Stresses).\n');
    end
end

