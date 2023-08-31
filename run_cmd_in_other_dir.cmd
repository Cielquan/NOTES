@echo off

SET SCRIPT_DIR=%~dp0

PUSHD %SCRIPT_DIR%\..\

%*

POPD
