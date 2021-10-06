function lookForMistakes(obj)
u = load('u.mat');
sig = load('sig.mat');
    if (u.displacements == obj.displacements) 
        cprintf('green', 'Test 1 pass (Correct Displacements).\n');
    else
        cprintf('red', 'Test 1 NO pass (Wrong Displacements).\n');
    end
   
    if(sig.stresses == obj.stress)
        cprintf('green', 'Test 2 pass (Correct Stresses).\n');
    else
        cprintf('red', 'Test 2 NO pass (Wrong Stresses).\n');
    end
end

