@ECHO OFF

Rscript.exe --vanilla _script\build_site.R clean
Rscript.exe --vanilla _script\check_errors.R 	

:end

