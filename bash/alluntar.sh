#! /bin/bash

base_dir=$(cd `dirname $0`;pwd)


cd $base_dir


untgz(){
  for i in `find . -name "*.tar.gz"`
    do
      dir=`echo $(dirname $i)`
      tar zxvf $i -C $dir
      rm -rf $i
  done
}

untgz1(){
  for i in `find . -name "*.tgz"`
    do
      dir=`echo $(dirname $i)`
      tar zxvf $i -C $dir
      rm -rf $i
  done
}

untgz2(){
  for i in `find . -name "*.tar"`
    do
      dir=`echo $(dirname $i)`
      tar xvf $i -C $dir
      rm -rf $i
  done
}

un_zip(){
  for i in `find . -name "*.zip"`
    do
      dir=`echo $(dirname $i)`
      unzip -o -d $dir $i
      rm -rf $i
  done
}

num=`find . -name "*.tar.gz"|wc -l`
while [ $num -gt 0 ]
  do
    untgz
    num=`find . -name "*.tar.gz"|wc -l`
done

num=`find . -name "*.tgz"|wc -l`
while [ $num -gt 0 ]
  do
    untgz1
    num=`find . -name "*.tgz"|wc -l`
done

num=`find . -name "*.tar"|wc -l`
while [ $num -gt 0 ]
  do
    untgz2
    num=`find . -name "*.tar"|wc -l`
done

num=`find . -name "*.zip"|wc -l`
while [ $num -gt 0 ]
  do
    un_zip
    num=`find . -name "*.zip"|wc -l`
done
