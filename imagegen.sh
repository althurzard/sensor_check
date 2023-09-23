icons_dir="assets/icons"
images_dir="assets/images"
currentPackage=$(basename "$PWD")
output="lib/generated_images.dart"
touch "$output"
: > $output
echo "import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
">> $output


if [ "$(ls -A $icons_dir)" ]; then
    echo "enum Ic {" >> $output
    for entry in "$icons_dir"/*
    do
        if [ -f "$entry" ]; then
            fname=$(basename $entry)
            name="${fname%%.*}"
            lowercase=$(echo "$name" | awk '{print tolower($0)}')
            camelCase=$(echo "$lowercase" | perl -pe 's/_([a-z])/uc($1)/ge')
            echo "  $camelCase," >> $output
        fi
    done
    echo "}
" >> $output
else
    echo ''
fi

if [ "$(ls -A $icons_dir)" ]; then
    echo "extension FilePath on Ic {
  String get path {
    var value = '';
    switch (this) {" >> $output
    for entry in "$icons_dir"/*
    do
        if [ -f "$entry" ]; then
            fname=$(basename $entry)
            name="${fname%%.*}"
            lowercase=$(echo "$name" | awk '{print tolower($0)}')
            camelCase=$(echo "$lowercase" | perl -pe 's/_([a-z])/uc($1)/ge')
            echo "      case Ic.$camelCase:
            value = '$entry';
            break;" >> $output
        fi
    done
    echo "    }
    return value;
  }

  SvgPicture get svg {
    return SvgPicture.asset(path);
  }

}" >> $output
else
    echo ''
fi

if [ "$(ls -A $images_dir)" ]; then
    echo "enum Img {" >> $output
    for entry in "$images_dir"/*
    do
        if [ -f "$entry" ]; then
            fname=$(basename $entry)
            name="${fname%%.*}"
            lowercase=$(echo "$name" | awk '{print tolower($0)}')
            camelCase=$(echo "$lowercase" | perl -pe 's/_([a-z])/uc($1)/ge')
            echo "  $camelCase," >> $output
        fi
    done
    echo "}
" >> $output
else
    echo ''
fi

if [ "$(ls -A $images_dir)" ]; then
    echo "extension FilePathImg on Img {
  String get path {
    var value = '';
    switch (this) {" >> $output
    for entry in "$images_dir"/*
    do
        if [ -f "$entry" ]; then
            fname=$(basename $entry)
            name="${fname%%.*}"
            lowercase=$(echo "$name" | awk '{print tolower($0)}')
            camelCase=$(echo "$lowercase" | perl -pe 's/_([a-z])/uc($1)/ge')
            echo "      case Img.$camelCase:
            value = '$entry';
            break;" >> $output
        fi
    done
    echo "    }
    return value;
  }

  Image get image {
    return Image.asset(path);
  }
}" >> $output
else
    echo ''
fi