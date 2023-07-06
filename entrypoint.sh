#!/bin/sh
pwd

cd ../..

ls -a

#echo repo name that called this action
echo "repo name is " $GITHUB_REPOSITORY

#echo what is in .env
echo "contents of .env"
cat .env

#get base_uri from .env file 
INPUT_BASEURI=$(grep -oP '(?<=base_uri=).+' .env)
echo "base_uri is " $INPUT_BASEURI

tree -a ./src

#perform a tree on the github workspace
tree -a ./github/workspace



#make a folder in ./src called data
mkdir ./src/data

#copy all files from ./github/workspace to  ./src/data including hidden files
rsync --recursive --progress -avzh ./github/workspace/* ./src/data
#copy the .git folder from ./github/workspace to ./src/data
rsync --recursive --progress -avzh ./github/workspace/.git ./src/data/

#install all requirements
pip install -r requirements.txt

#echo "files in ./src/data"
#tree -a ./src/data

#run the python script
cd src/
python main.py $INPUT_BASEURI
cd ..

#make a folder in ./github/workspace called unicornpages
mkdir ./github/workspace/unicornpages

pwd

#echo all files from ./src/build
#echo "files in ./src/build"
#tree -a ./src/build

#copy over all files from ./src/data to ./github/workspace/unicornpages with rsync except for the .git folder
rsync --recursive --progress --exclude '.git' ./src/build/* ./github/workspace/unicornpages

#list everything that is in unicornpages
ls -a ./github/workspace/unicornpages
