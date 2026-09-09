@echo off
rem Aseprite 1.3.18.5 build script (configure + build)
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat" >nul
set "PATH=C:\Program Files\CMake\bin;%PATH%"

set SRC=C:\Users\fanqu\Downloads\Aseprite-v1.3.18.5-Source (1)
set BUILD=C:\aseprite-build
set SKIA=C:/deps/m124

echo ================== CMAKE CONFIGURE ==================
cmake -B "%BUILD%" -S "%SRC%" -G Ninja ^
  -DCMAKE_BUILD_TYPE=RelWithDebInfo ^
  -DUPDATE_VERSION_WITH_GIT=off ^
  -DLAF_BACKEND=skia ^
  -DSKIA_DIR="%SKIA%" ^
  -DSKIA_LIBRARY_DIR="%SKIA%/out/Release-x64"
if errorlevel 1 (
  echo CONFIGURE FAILED
  exit /b 1
)

echo ================== BUILDING ASEPRITE ==================
cmake --build "%BUILD%" -- aseprite
if errorlevel 1 (
  echo BUILD FAILED
  exit /b 1
)

echo ================== BUILD DONE ==================
dir "%BUILD%\bin"
