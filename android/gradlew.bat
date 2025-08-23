#!/usr/bin/env sh
exec "$PWD/gradle/wrapper/gradle-wrapper.jar" "$@"

@echo off
"%JAVA_HOME%\bin\java.exe" -jar "%~dp0gradle\wrapper\gradle-wrapper.jar" %*
