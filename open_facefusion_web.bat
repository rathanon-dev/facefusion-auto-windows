@echo off
setlocal

:: --- Configuration ---
set "INSTALL_DIR=%CD%\conda_embeded"
set "ENV_DIR=%CD%\env_facefusion"
set "ProjectDir=%CD%\facefusion"
set "PATH=%INSTALL_DIR%;%INSTALL_DIR%\Scripts;%PATH%" 
:: -------------------

echo =================================================================
echo                      Start FaceFusion                
echo                   http://127.0.0.1:7860
echo                  [ ctrl + double click ]
echo =================================================================

cd %ProjectDir%

conda run --prefix "%ENV_DIR%" python facefusion.py run --open-browser
 
endlocal

