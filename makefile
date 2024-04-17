website:
		flutter build web --web-renderer canvaskit
		cp -r build/web/* ../depystfam/
		cd ../depystfam && git add . && git commit -m "web update" && git push