#!/bin/bash

export LC_ALL=en_US.UTF-8

if [ -z "$1" ]; then
    echo "Usage: $0 <repository-directory>"
    exit 1
fi

FLUTTER_MODULE_DIR=$1

# Check if the specified directory exists
if [ ! -d "$FLUTTER_MODULE_DIR" ]; then
    echo "Error: Directory $FLUTTER_MODULE_DIR does not exist."
    exit 1
fi

# Change to the FLUTTER directory
cd "$FLUTTER_MODULE_DIR" || exit

git fetch origin
git checkout develop
git pull origin develop
dart run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart
dart run build_runner build  --delete-conflicting-outputs

APP_DIR=$2

if [ ! -d "$APP_DIR" ]; then
    echo "Error: Directory $APP_DIR does not exist."
    exit 1
fi

cd "$APP_DIR" || exit

ls
pod install

echo "success"
