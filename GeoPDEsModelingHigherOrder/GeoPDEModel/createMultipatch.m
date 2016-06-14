% Copyright (c) 2015 Augusto Garcia Agundez

% Create a multipatch from text files for NURBS obtained through nrbexport. Input is structure multiPatchStruct described as follows:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% multiPatchStruct(1).multiPatchAddress must contain the address for the multipatch txt to be built
%
%
% multiPatchStruct(1).nDimensions,nPatches,nInterfaces,nSubdomains,nBoundaries are the number of dimensions,patches,interfaces,subdomains and
% boundaries for the multipatch, as integers
%
% multiPatchStruct(i).patchAddress is the address to the different patch .txt files,i from 1 to nPatches
%
% multiPatchStruct(i).interface is a vector containing the information of each interface,i from 1 to nInterfaces. The information is as follows:
% [patch1 side1 patch2 side2 flag], where patch1 is the first patch of the interface, and side1 the side of that patch that forms the interface
% and so on. Flag is 1 if the unitary direction vector of both nurbs lines have the same direction
%
% multiPatchStruct(i).subdomain is a vector containing the patches that belong to said subdomain, i from 1 to nSubdomains
%
% multiPatchStruct(i).boundary is a vector containing the information of each boundary, from 1 to nBoundaries. The information is as follows:
% [npatches patch1 side1 patch2...] where npatches is the number of patches that form part of the boundary, patch1 the first patch that belongs
% to the boundary and side1 the side of that patch that belongs to the boundary, and so on.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function [multiPatchAddress] = createMultipatch(multiPatchStruct)

% Open file
Multipatchfile=fopen(multiPatchStruct(1).multiPatchAddress,'wt');

% Write multipatch header and initial parameters
fprintf(Multipatchfile, '# nurbs mesh v.0.7\n#\n# 03-Jul-2014\n#\n%g %g %g %g\n', [multiPatchStruct(1).nDimensions multiPatchStruct(1).nPatches multiPatchStruct(1).nInterfaces multiPatchStruct(1).nSubdomains]);

% Add patches
counter=1;
while (counter <= multiPatchStruct(1).nPatches )
	fprintf(Multipatchfile, '# Patch %g\nPATCH %g\n',[counter counter]);
    fid=fopen(multiPatchStruct(counter).patchAddress);
    auxcounter=1;
        while (auxcounter <7)
            line=fgetl(fid);
            auxcounter=auxcounter+1;
        end
        while (line~=-1)
            line=fgetl(fid);
            if (line~=-1) 
                fprintf(Multipatchfile,'%s\n',line);
            end
        end
    auxcounter=1;
    fclose(fid);
	counter=counter+1;
end

% Add interfaces
counter=1;
while (counter <=multiPatchStruct(1).nInterfaces)
	fprintf(Multipatchfile, 'INTERFACE %g\n%g %g\n%g %g\n%g\n',[counter multiPatchStruct(counter).interface(1) multiPatchStruct(counter).interface(2) multiPatchStruct(counter).interface(3) multiPatchStruct(counter).interface(4) multiPatchStruct(counter).interface(5)]);
	counter=counter+1;
end

% Add subdomains
counter=1;
while(counter <=multiPatchStruct(1).nSubdomains)
	fprintf(Multipatchfile, 'SUBDOMAIN %g\n',counter);
	for i=1:length(multiPatchStruct(counter).subdomain)
		fprintf(Multipatchfile, '%g ', multiPatchStruct(counter).subdomain(i));
	end
	fprintf(Multipatchfile, '\n');
	counter=counter+1;
end

% Add boundaries
counter=1;
while(counter <=multiPatchStruct(1).nBoundaries)
	fprintf(Multipatchfile, 'BOUNDARY %g\n',counter);
	fprintf(Multipatchfile, '%g\n',multiPatchStruct(counter).boundary(1));
	for i=1:floor(length(multiPatchStruct(counter).boundary)/2)
		fprintf(Multipatchfile, '%g %g\n',[multiPatchStruct(counter).boundary(2*i) multiPatchStruct(counter).boundary(2*i+1)]);
	end
	counter=counter+1;
end

% Close file and return multipatch address
fclose(Multipatchfile);
multiPatchAddress=multiPatchStruct(1).multiPatchAddress;
end
