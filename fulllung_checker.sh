#! /bin/bash
# @Author  : jetyau
# @Contact : jieqiu@mori.m.is.nagoya-u.ac.jp
# Please contact author for further support
time_stamp=$(date +"%Y%m%d_%H%M%S")
PYTHON=python3
docker_path=/homes/jieqiu/code_store/NICT/detectlung/

current_path=${PWD}

file=$1

if ! command -v docker &> /dev/null 
then
    echo 'docker not exists'
    exit
fi

if  [[ "$(docker images -q moda/lungseg 2> /dev/null)" == "" ]];
then 
    cd ${docker_path}
    docker build -f Dockerfile -t moda/lungseg .
    #echo ${PWD}
    cd ${current_path}
fi
if   [ -d "${file}" ]
then docker run -it --gpus all --rm --volume ${file}:/data --workdir /usr/src/app --name moda_lung moda/lungseg ${PYTHON} /usr/src/app/lungsegmentation_test_2d.py
elif [ -f "${current_path}/${file}" ]
then docker run -it --gpus all --rm --volume ${current_path}/${file}:/data/${file} --workdir /usr/src/app --name moda_lung moda/lungseg ${PYTHON} /usr/src/app/lungsegmentation_test_2d.py
else echo "please ensure the given arg to be file in current dir or path to a dir"
    exit
fi
#echo 'test2'