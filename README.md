<h1>EpisoPass拡張機能</h1>

<ul>
  <li><a href="https://EpisoPass.com/">EpisoPass</a>のブラウザ拡張機能です</li>
  <li>Amazonなどのログイン画面でEpisoPassを使うことができます</li>
  <li><a href="https://chrome.google.com/webstore/detail/episopass/hfjimamacnmcakocjkkabpmfkaomadja?hl=ja&">Chrome Webストア</a>
  からインストールできます</li>
  <li>Googleストアは審査に時間がかかるので、このリポジトリの最新版をWebストアからインストールできない可能性があります</li>
  <li>最新版を使いたい場合、このリポジトリをダウンロードし、
    拡張機能管理画面で「パッケージ化されていない拡張機能を読み込む」でインストールしてください</li>
  <li>最新版はAmazon, Facebook, Twitter, GitHub, LinkedIn, Gyazo, Heroku, Value-Domain, Tumblr, Pinterestで使えます</li>
</ul>

<h2>使いかた</h2>

<ul>
  <li>EpisoPassの問題HTMLを<code>サービス名_アカウント.html</code>という名前で用意します</li>
  <li>たとえば私のAmazonアカウントは<a href="http://www.pitecan.com/p/Amazon_masui@pitecan.com.html">http://www.pitecan.com/p/Amazon_masui@pitecan.com.html</a>という名前のHTMLファイルで管理しています
  <li>これにアクセスするとブラウザのlocalStorageに問題がセーブされます</li>
  <li>このサービスのログイン画面でパスワード入力フォームをクリックするとEpisoPass問題が表示され、
    ユーザが問題を解くと生成された文字列がパスワードフォームに入力されます</li>
  <li>ログインボタンを押す前にユーザ操作が必要な場合があります</li>
  <ul>
    <li>Twitter, Tumblrの場合、生成されたパスワード文字列を手動でコピーしてペーストしなおす必要があります</li>
    <li>Pinterestの場合、生成されたパスワードの後に何か文字を追加/削除する必要があります</li>
    <li>何かユーザのインタラクションを確認しているからかもしれません</li>
  </ul>
</ul>

<img src="https://gyazo.com/1b5c0b7d37b5415b2641bb6fe77a486e.png">
