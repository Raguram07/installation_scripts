@echo off

rem Set the paths for the source folders A, B, and destination folder C
set folderA=C:\FolderA
set folderB=C:\FolderB
set folderC=C:\FolderC

rem Loop through each PDF file in folder B
for %%f in ("%folderB%\*.pdf") do (
    rem Check if a file with the same name exists in folder A
    if exist "%folderA%\%%~nxf" (
        rem If a file with the same name exists, move the file to folder C
        move "%%f" "%folderC%"
    )
)

echo PDF file comparison and move completed.
