#!/usr/bin/env bash

# delete repository files
rm -rf .git
rm README.md
rm LICENSE

# Get variables
echo "Java package?"
read JAVA_PACKAGE

echo "Application name?"
read APP_NAME

# Replace package name in build.gradle
sed -i "s/JAVA_PACKAGE_PLACEHOLDER/$JAVA_PACKAGE/g" build.gradle

# replace existing package structure
pkgDirs=$(echo $JAVA_PACKAGE | tr "." "\n")

prevDirMain="src/main/java"
prevDirTest="src/test/java"
for pkgDir in $pkgDirs
do
	prevDirMain="${prevDirMain}/${pkgDir}"
	prevDirTest="${prevDirTest}/${pkgDir}"
    mkdir -p $prevDirMain
    mkdir -p $prevDirTest
done

# Move Main.java file and rename class
mv src/main/java/Main.java "$prevDirMain/$APP_NAME.java" 
sed -i "s/Main/$APP_NAME/g" "$prevDirMain/$APP_NAME.java"
sed -i "s/JAVA_PACKAGE_PLACEHOLDER/$JAVA_PACKAGE/g" "$prevDirMain/$APP_NAME.java"

#rename Main.java to APP_NAME.java
sed -i "s/Main/$APP_NAME/g" build.gradle

# remane gradle project
sed -i "s/APP_NAME_PLACEHOLDER/$APP_NAME/g" settings.gradle

read -p "Initialize Git repository [y/N]? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    git init
    git add -A
    git reset configureTemplate.sh
    git commit -m "initial commit"
fi

# delete configuration script
rm -- "$0"
