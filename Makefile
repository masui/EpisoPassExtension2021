all: js xpi

#
# Firefox/Chrome用EpisoPass拡張機能
#
js:
	coffee -c crypt.coffee
	coffee -c app.coffee
	coffee -c episopass.coffee

XPIFILES=manifest.json app.js crypt.js episopass.js exports.js jquery-3.6.0.js md5.js episopass.png icons
xpi: js
	/bin/rm -f episopass.xpi
	zip -r episopass.xpi ${XPIFILES}

#
# Chromeエクステンション公開用のzipを作る
#
ZIPFILES=manifest.json app.js crypt.js episopass.js exports.js jquery-3.6.0.js md5.js episopass.png icons
zip: xpi
	/bin/rm -f episopass.zip
	zip -r episopass.zip ${ZIPFILES}

#
# Firefox拡張機能を署名する
# manifest.json中のバージョン番号を更新してから動かすこと
#
sign: xpi
	web-ext build --overwrite-dest
	web-ext sign --api-key $(MOZILLA_USER) --api-secret $(MOZILLA_SECRET)
	/bin/cp web-ext-artifacts/`ls -1 -t web-ext-artifacts | head -1` episopass.xpi

lint: xpi
	web-ext lint

clean:
	/bin/rm -r -f *~
	/bin/rm -f crypt.js
	/bin/rm -f app.js
	/bin/rm -f episopass.js
	/bin/rm -f episopass.xpi
	/bin/rm -f episopass.zip
