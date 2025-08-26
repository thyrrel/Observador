@echo off
rem ----------------------------------------------------------------------
rem Gradle start up script for Windows
rem ----------------------------------------------------------------------

rem Check if JAVA_HOME is set
if "%JAVA_HOME%" == "" (
    echo ERROR: JAVA_HOME is not set and no Java could be found in PATH.
    exit /b 1
)

rem Determine script directory
set DIRNAME=%~dp0
set GRADLE_HOME=%DIRNAME%gradle\wrapper
set CLASSPATH=%GRADLE_HOME%\gradle-wrapper.jar

rem Execute Gradle Wrapper
"%JAVA_HOME%\bin\java.exe" -cp "%CLASSPATH%" org.gradle.wrapper.GradleWrapperMain %*
