echo "Clonando o SDK do Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 --branch stable ./flutter-sdk

export PATH="$PATH:`pwd`/flutter-sdk/bin"

echo "Executando flutter doctor..."
flutter doctor

flutter config --enable-web

echo "Baixando dependências com 'flutter pub get'..."
flutter pub get

echo "Compilando a aplicação web com 'flutter build web --release'..."
flutter build web --release