function smooth(path_input)
	
	list_files = dir(path_input);
	szFiles = size(list_files);
	
	for f = 3:szFiles(1)
		check_rFile = startsWith(list_files(f).name, 'rsub');
		
		if check_rFile == true
			path_file = fullfile(path_input, list_files(f).name);
	
			smooth = struct;
            
			% Data
			smooth.matlabbatch{1}.spm.spatial.smooth.data = cellstr(path_file);
			smooth.matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
			smooth.matlabbatch{1}.spm.spatial.smooth.dtype = 0;
			smooth.matlabbatch{1}.spm.spatial.smooth.prefix = 's';
         
			% Run
			spm_jobman('run',smooth.matlabbatch);
		
			clear matlabbatch;
		
		end
	end	 
 end