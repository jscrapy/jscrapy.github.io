#!/usr/bin/env bash

cd ..
rm -rf jscrapy.github.io

git clone https://github.com/jscrapy/jscrapy.github.io.git
cd jscrapy.github.io

git config user.name "${U_NAME}"
git config user.email "${U_EMAIL}"

git checkout source
python hi_page.py  ./post   ./html
mv html  ../
rm -rf html

git checkout master

branch=$(git symbolic-ref --short -q HEAD)
echo "检测到的branch是${branch}"
if [[ ${branch} == 'master' ]]
then
    echo "分支位于master，开始更新博客内容"
    rm -rf *
	git add .
	git commit -m"delete old"
	
    mv ../html/*  .
    rmdir ../html
	
	echo "准备提交的编译结果如下："
	ls -lt

	git add .
	git commit -m "Update blog"
	git push -f "https://${GITHUB_TK}@github.com/jscrapy/jscrapy.github.io.git" master
else
    echo "分支切换不成功，更新失败"
	exit 1
fi
