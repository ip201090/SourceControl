%% Writing the obtained resutls into text-files

% For MC
file_data_id = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\meanMC.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n',[plotRange; meanPlot]);
fclose(fid);

file_data_id = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\sdMC.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [plotRange; sdPlot]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\errorMC.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [plotRange; errorPlot]);
fclose(fid);

% For Quadrature
file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\meanQuad.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbSamplesQuad; mean_quad]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\meanQuadPoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degree; mean_quad]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\sdQuad.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbSamplesQuad; sd_quad]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\sdQuadPoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degree; sd_quad]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\errorQuad.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbSamplesQuad; error_quad]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\errorQuadPoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degree; error_quad]);
fclose(fid);

% For OLS
file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\meanOLS.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbOLSSamp; mean_ols]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\meanOLSPoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degreeOLS; mean_ols]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\sdOLS.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbOLSSamp; sd_ols]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\sdOLSPoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degreeOLS; sd_ols]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\errorOLS.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbOLSSamp; error_ols]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\errorOLSPoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degreeOLS; error_ols]);
fclose(fid);

% Sparse Quaddrature
file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\meanSparse.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbSamplesQuadSparse; mean_quad_sparse]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\meanSparsePoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degreeSparse; mean_quad_sparse]);
fclose(fid);


file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\sdSparse.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbSamplesQuadSparse; sd_quad_sparse]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\sdSparsePoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degreeSparse; sd_quad_sparse]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\errorSparse.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbSamplesQuadSparse; error_quad_sparse]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\errorSparsePoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degreeSparse; error_quad_sparse]);
fclose(fid);

% For LARS
file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\meanLARS.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbSamplesLARS; mean_lars]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\meanLARSPoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degreeLARS; mean_lars]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\sdLARS.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbSamplesLARS; sd_lars]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\sdLARSPoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degreeLARS; sd_lars]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\errorLARS.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [numbSamplesLARS; error_lars]);
fclose(fid);

file_data_id  = 'C:\Users\polonskij\Documents\MATLAB\SourceControl\Ishigami Analysis\Textfiles\errorLARSPoly.txt';
fid = fopen(file_data_id,'w');
fprintf(fid,'%10g %10g\n', [degreeLARS; error_lars]);
fclose(fid);