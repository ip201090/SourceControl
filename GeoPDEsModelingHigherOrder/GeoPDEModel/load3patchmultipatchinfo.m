## Copyright (C) 2015 Andreas Pels, pels@gsc.tu-darmstadt.de

% % Example of a multiPatchStruct and how it should look like, for the 3-patch stern gerlach model


task=getCurrentTask();
if (isempty(task))
    taskID=1;
else
    taskID=task.ID;
end
multiPatchStruct(1).multiPatchAddress=sprintf('multipatch%d.txt', taskID);
multiPatchStruct(1).patchAddress=sprintf('nurbsLeftPolePatch%d.txt', taskID);
multiPatchStruct(2).patchAddress=sprintf('nurbsAirGapPatch%d.txt', taskID);
multiPatchStruct(3).patchAddress=sprintf('nurbsRightPolePatch%d.txt', taskID);
multiPatchStruct(1).nDimensions=2;
multiPatchStruct(1).nPatches=3;
multiPatchStruct(1).nInterfaces=2;
multiPatchStruct(1).nSubdomains=2;
multiPatchStruct(1).nBoundaries=4;
multiPatchStruct(1).interface=[1 2 2 1 1];
multiPatchStruct(2).interface=[2 2 3 1 1];
multiPatchStruct(1).subdomain=[1 3];
multiPatchStruct(2).subdomain=[2];
multiPatchStruct(1).boundary=[1 1 1];
multiPatchStruct(2).boundary=[1 3 2];
multiPatchStruct(3).boundary=[3 1 3 2 3 3 3];
multiPatchStruct(4).boundary=[3 1 4 2 4 3 4];