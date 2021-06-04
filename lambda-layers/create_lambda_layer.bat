@echo off

REM load layer to build
set "layer=common"
set /p "layer=Enter layer name (sub-folder) or press [ENTER] for default [%layer%]: "

echo Running Docker to pull Python dependencies
pushd %layer%
docker run --rm -v "%cd%":/var/task "lambci/lambda:build-python3.8" /bin/sh -c "rm -R python; pip install -r requirements.txt -t python/; pip freeze --path python/ > freeze.txt; chmod -R 755 python/; zip -rq - python/ > %layer%-layer-1.0.1-py3.8.zip; exit"

popd
echo Success!
