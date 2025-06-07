@echo off
setlocal

:: --- Configuration ---
set "INSTALL_DIR=%CD%\conda_embeded"
set "ENV_DIR=%CD%\env_facefusion"
set "PYTHON_VERSION=3.12"
set "PIP_VERSION=25.0"
set "CUDA_VERSION=12.8.1"
set "CUDNN_VERSION=9.8.0.87"
set "RepoUrl=https://github.com/facefusion/facefusion"
set "ProjectDir=%CD%\facefusion"
set "MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
:: -------------------

GOTO MAIN
:: check  NVIDIA CUDA Driver  
:check_cuda_driver
    color 0A
    SETLOCAL ENABLEDELAYEDEXPANSION
    echo Checking for NVIDIA CUDA Driver...  
    where nvidia-smi >nul 2>&1
    if errorlevel 1 (
        echo.   
        echo ERROR: NVIDIA CUDA Driver not found.   
        echo Please install the latest NVIDIA driver with CUDA support. 
        echo.
        echo Press any key to exit... 
        pause >nul
        exit
    )
    nvidia-smi  
    echo NVIDIA CUDA Driver is installed. 
    ENDLOCAL
EXIT /B 0

:: Check if a program exists, if not, attempt to install it
:check_installation
    SETLOCAL ENABLEDELAYEDEXPANSION
    set "program_name=%1"
    set "install_command=%2"

    echo Checking program: %program_name%  :: Check if program_name is correct
    echo Installation command: %install_command%  :: Check if install_command is correct
	 
    where %program_name% >nul 2>nul
    if %errorlevel% neq 0 (
        echo ERROR: %program_name% not found. Attempting installation...
        %install_command%
        if %errorlevel% neq 0 (
            echo ERROR: Failed to install %program_name%. Please check your system configuration.
            EXIT /B 0
        )
    ) else (
        echo %program_name% is already installed.
    )
    ENDLOCAL
EXIT /B 0

:: Check if Miniconda is already installed, if not, download and install
:check_and_install_miniconda
    SETLOCAL ENABLEDELAYEDEXPANSION

    if exist "%INSTALL_DIR%\conda.exe" (
        echo Miniconda is already installed at %INSTALL_DIR%. Skipping installation.   
        ENDLOCAL & EXIT /B 0
    )

    echo Miniconda not found. Proceeding to download and install...   
    call :check_and_download "miniconda.exe" "%MINICONDA_URL%" 
    call :install_miniconda
    ENDLOCAL
EXIT /B 0

:: Check if a file exists, if not, download it
:check_and_download
    SETLOCAL ENABLEDELAYEDEXPANSION
    set "file_path=%1"
    set "url=%2"
    
    if "%file_path%"=="" (
        echo ERROR: No file path provided for download.   
        EXIT /B 0
    )
    if "%url%"=="" ( 
        echo ERROR: No URL provided for download.   
        EXIT /B 0
    )

    if not exist "%file_path%" (
        echo Downloading %file_path%...     
        curl -L "%url%" -o "%file_path%"   
        if not exist "%file_path%" (
            echo ERROR: Failed to download %file_path%.    
            EXIT /B 0
        )
    ) else (
        echo %file_path% already exists. Skipping download.   
    )
    ENDLOCAL
EXIT /B 0

:: Install Miniconda portably
:install_miniconda
    SETLOCAL ENABLEDELAYEDEXPANSION
    echo Installing Miniconda portably...   
    start /wait "" miniconda.exe /InstallationType=JustMe /AddToPath=0 /S /RegisterPython=0 /NoRegistry=1 /NoScripts=1 /NoShortcuts=1 /D=%INSTALL_DIR%   
    if not exist "%INSTALL_DIR%" (
        echo ERROR: Miniconda installation failed.   
        goto :eof
    )
    echo Rename _conda.exe to conda.exe for easier use.   
    move "%INSTALL_DIR%\_conda.exe" "%INSTALL_DIR%\conda.exe" 2>nul   
    echo Remove miniconda.exe that was downloaded.   
    del "miniconda.exe" 2>nul   
    ENDLOCAL
EXIT /B 0

:: Check if Conda environment already exists
:check_conda_environment
    SETLOCAL ENABLEDELAYEDEXPANSION
    set "env_path=%1"

    if "%env_path%"=="" (
        echo ERROR: No environment path provided.  
        ENDLOCAL & EXIT /B 1
    )
    
    echo Checking if Conda environment "%env_path%" exists...  
    conda info --envs | findstr /i "%env_path%" >nul  
    if %errorlevel% neq 0 (
        echo ERROR: Conda environment "%env_path%" does not exist. Creating environment... 
        conda create --no-shortcuts -y --prefix "%env_path%" python=%PYTHON_VERSION% pip=%PIP_VERSION%  
        echo Conda create command finished 
    ) else (
        echo Conda environment "%env_path%" already exists. 
    )
    ENDLOCAL
EXIT /B 0

:: Check if CUDA and cuDNN are installed in the environment
:check_cuda_cudnn
    SETLOCAL ENABLEDELAYEDEXPANSION
    set "env_path=%1"
    if "%env_path%"=="" (
        echo ERROR: No environment path provided.  
        ENDLOCAL & EXIT /B 1
    )

    set "missing="

    echo Checking for CUDA Runtime in environment "%env_path%"...
    conda list --prefix "%env_path%" | findstr /i "cuda-runtime" >nul  
    if !errorlevel! neq 0 (
        echo Missing: cuda-runtime   
        set "missing=1"
    )
    echo Checking for cuDNN in environment "%env_path%"...
    conda list --prefix "%env_path%" | findstr /i "cudnn" >nul 
    if !errorlevel! neq 0 (
        echo Missing: cudnn   
        set "missing=1"
    )

    if defined missing (
        echo CUDA or cuDNN not found in the environment.   
        echo Installing CUDA Runtime v%CUDA_VERSION% and cuDNN v%CUDNN_VERSION% into %env_path% ...   
        conda install --prefix "%env_path%" -y -c conda-forge cuda-runtime=%CUDA_VERSION% cudnn=%CUDNN_VERSION% 
        echo CUDA and cuDNN installation finished.
    ) else (
        echo CUDA and cuDNN are already installed in the environment "%env_path%".
    )

    ENDLOCAL
EXIT /B 0

:check_and_clone_facefusion
    SETLOCAL ENABLEDELAYEDEXPANSION
    echo Checking if FaceFusion repository is already cloned...   

    :: Check if the .git folder exists in the project directory
    if not exist "%ProjectDir%\.git" (
        echo FaceFusion repository not found. Cloning repository...   
        git clone %RepoUrl% %ProjectDir%
        if %errorlevel% neq 0 (
            echo ERROR: Failed to clone the FaceFusion repository.   
            EXIT /B 0
        )
    ) else (
        echo FaceFusion directory already exists. Checking repository status...   
        cd "%ProjectDir%"
        git fetch
        set "git_status="
        for /f "delims=" %%i in ('git status --porcelain') do set "git_status=%%i"
        
        if defined git_status (
            echo WARNING: Local repository is not up-to-date. You may want to pull the latest changes.   
        ) else (
            echo FaceFusion repository is up-to-date.   
        )
    )
    ENDLOCAL
    EXIT /B 0
 
:: Function to check if all requirements from requirements.txt are installed
:check_install_facefusion
    echo Checking installed packages against requirements.txt... 

    :: ???? list ?????????????????????? temp file ????
    conda run --prefix "%ENV_DIR%" python -m pip list --format=freeze > "%TEMP%\installed_pkgs.txt"   

    set "missing_packages="

    cd "%ProjectDir%"
    for /f "usebackq tokens=1 delims== " %%P in ("%ProjectDir%\requirements.txt") do (
        set "pkg=%%P"
        :: ??? findstr ??????????? installed_pkgs.txt
        findstr /i "^!pkg!=.*" "%TEMP%\installed_pkgs.txt" >nul  
        if errorlevel 1 (
            set "missing_packages=!missing_packages! !pkg!"
        )
    )

    if defined missing_packages (
        echo Missing packages:%missing_packages%   
        echo Installing missing dependencies...   
        call :install_install_facefusion 
    ) else (
        echo All required packages are already installed.   
    )
    EXIT /B 0

:: Function to run install.py
:install_install_facefusion
    echo %ProjectDir%
    echo Running install.py to install requirements...   
    cd "%ProjectDir%"
    call conda run --prefix "%ENV_DIR%" python "%ProjectDir%\install.py"  --onnxruntime cuda --skip-conda  
    if %errorlevel% neq 0 (
        echo ERROR: install_debug.py failed.   
        EXIT /B 1
    )
    echo Dependencies installed successfully.   
    EXIT /B 0
    

:: MAIN SCRIPT
:MAIN
call :check_cuda_driver 
call :check_installation git "winget install --id=Git.Git -e --source winget"
call :check_installation ffmpeg "winget install --id=Gyan.FFmpeg -e --source winget"
call :check_installation curl "winget install --id=cURL.cURL  -e --source winget"
call :check_and_install_miniconda 
echo Setting up environment for this session...
set "PATH=%INSTALL_DIR%;%INSTALL_DIR%\Scripts;%PATH%"   
echo Checking if Conda environment exists...
call :check_conda_environment "%ENV_DIR%"  
call :check_cuda_cudnn "%ENV_DIR%" 
call :check_and_clone_facefusion
call :check_install_facefusion
echo.
echo =================================================================
echo                      Installation Complete!
echo                      Press any key to exit...
echo =================================================================
echo.
pause >nul
endlocal
