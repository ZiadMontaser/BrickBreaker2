@echo off

rem Assemble all .asm files
for %%f in (*.asm) do echo masm %%f
for %%f in (*.asm) do masm %%f;

echo Started Linking
link main.obj bar.obj;
echo Done Buidling

MAIN.EXE