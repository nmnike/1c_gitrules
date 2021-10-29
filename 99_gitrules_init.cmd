@chcp 65001
REM @set LOGOS_LEVEL=DEBUG
@call opm install gitrules
@call git init .
@call gitrules install .
pause