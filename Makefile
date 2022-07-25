# NOTE: Windows commands. Not compatible with UNIX OSs

.PHONY: unpack generate-key clear, pack, align, sign, build

# extract the APK file
unpack:
	java -jar .\apktool.jar d .\original.apk -o .\extracted_apk

# generate a self-signed key with one century of validity to sign the APK
generate-key:
	keytool -genkey -v -keystore key.keystore -alias apk_key -keyalg RSA -keysize 2048 -validity 36500

# delete build artifacts and the extracted APK folder
clear-all: clear-build
	- rmdir /s /q extracted_apk

# delete build artifacts
clear-build:
	- rmdir /s /q build

# re-pack the folder into an APK file
pack:
	java -jar .\apktool.jar b .\extracted_apk\ -o .\build\packed.apk

# zipalign the APK file
align:
	zipalign -v 4 .\build\packed.apk .\build\aligned.apk

# sign the APK file with a key
sign:
	apksigner sign -v --out .\build\signed.apk --ks .\key.keystore --ks-key-alias apk_key .\build\aligned.apk

# delete unneeded files and re-pack/align/sign the APK from the `extracted_apk` folder
build: clear-build pack align sign
