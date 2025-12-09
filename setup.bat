@echo off
REM NeoCare+ - Script de nettoyage et installation
REM Pour Windows

echo ========================================
echo    NeoCare+ - Setup Script
echo ========================================
echo.

echo [1/5] Nettoyage du cache Flutter...
call flutter clean

echo.
echo [2/5] Suppression des fichiers Gradle...
if exist android\.gradle rmdir /s /q android\.gradle
if exist android\app\build rmdir /s /q android\app\build
if exist build rmdir /s /q build

echo.
echo [3/5] Installation des packages...
call flutter pub get

echo.
echo [4/5] Verification de l'environnement...
call flutter doctor -v

echo.
echo [5/5] Pret a lancer!
echo.
echo ========================================
echo   Setup termine avec succes!
echo ========================================
echo.
echo Pour lancer l'application:
echo   flutter run
echo.
pause
