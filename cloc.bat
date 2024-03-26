@echo off
cloc-2.00.exe . --include-lang=gdscript --quiet
cloc-2.00.exe . --by-file --include-lang=gdscript --quiet
pause
