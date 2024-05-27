website:
		flutter build web --web-renderer canvaskit
		cp -r build/web/* ../depystfam/
		cd ../depystfam && git add . && git commit -m "web update" && git push

bios:
		flutter clean
		flutter build ipa

bapk:
		flutter clean
		flutter build apk --split-per-abi

bapp:
		flutter clean
		flutter build appbundle --release
	