git clone https://github.com/flutter/flutter.git --depth 1 --branch stable ./flutter-sdk


export PATH="$PATH:`pwd`/flutter-sdk/bin"

flutter doctor


flutter config --enable-web