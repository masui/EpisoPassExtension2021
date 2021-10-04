#
# Facebookなどのログイン画面でEpisoPassを呼び出すブラウザ拡張機能
# ChromeでもFirefoxでも使えるはず
#
# Googleログインは?
#

$ ->
  $('body').on 'click', ->
    # email, usernameぽいものがあればLocalStorageにセーブしておく
    # (パスワード入力が別画面のことがあるので)
    if $('input[name="email"]').val() != undefined
      chrome.storage.local.set
        'username': $('input[name="email"]').val()
        , ->
          console.log "emailセーブ"
    if $('input[name="username"]').val() != undefined
      chrome.storage.local.set
        'username': $('input[name="username"]').val()
        , ->
          console.log "usernameセーブ"

    passelement = $("input[type='password']")
    if passelement
      service = null
      id = null
    
      if location.href.match /amazon/
        id = $('#ap_email').val()
        service = 'Amazon'
      if location.href.match /gyazo.com/
        id = $('input[name="email"]').val()
        service = 'Gyazo'
      if location.href.match /github.com/
        id = $('#login_field').val()
        service = 'GitHub'
      if location.href.match /linkedin.com/
        id = $('#username').val()
        service = 'LinkedIn'
      if location.href.match /facebook.com/
        id = $('#email').val()
        service = 'Facebook'
      if location.href.match /heroku.com/
        id = $('#email').val()
        service = 'Heroku'
      if location.href.match /value-domain.com/
        id = $('#username').val()
        service = 'ValueDomain'
      #
      # Tumblr, Twitterはパスワード欄に入った文字列をコピー/ペーストする操作が必要
      # 
      if location.href.match /tumblr.com/
        id = $('input[name="email"]').val()
        service = 'Tumblr'
      if location.href.match /twitter.com/
        service = 'Twitter'
      #
      # Pinterestはパスワード欄に何か文字を入力/削除する必要がある
      # 
      if location.href.match /pinterest\./
        id = $('#email').val()
        service = 'Pinterest'

      passelement.on 'click', ->
        if window.clicked == undefined
          chrome.storage.local.get "username", (value) ->
            id = value.username if id == null
            id = 'masui' if !id || id == ''
            name = "#{service}_#{id}"
  
            # セーブされてるデータを読む
            chrome.storage.local.get "episodata", (value) ->
              episodata = value.episodata
              for entry in episodata
                if entry.name == name
                  div = $('<div>')
                    .css 'position','absolute'
                    .css 'left','5px'
                    .css 'top','120px'
                    .css 'width','400px'
                    .css 'height','450px'
                    .css 'background-color','#ddd'
                    .css 'border-radius','5px'
                    .css 'z-index',9999
                    .attr 'id','episopass'
                  $('body').append div
  
                  exports.run entry,id,entry.seed,passelement
                  passelement.focus()
                  
                  window.clicked = true

  #
  # EpisoPass問題ページか判定
  #
  # これだけでは不充分な気がするな?
  # 
  if $('#question') && $('#question').length > 0
    #
    # 新しいデータを追加
    #
    data = JSON.parse($('body').attr('episodata'))

    episodata = []
    chrome.storage.local.get "episodata", (value) ->
      if Object.keys(value).length == 0
        episodata = []
      else
        episodata = value.episodata

      # 古いのを消す
      newdata = []
      for entry in episodata
        console.log "each - " + entry.name
        if entry.name != data.name
          newdata.push entry
      episodata = newdata

      # 新しいのを足す
      episodata.push data
    
      # データをセーブ
      chrome.storage.local.set
        'episodata': episodata
        , ->
          console.log "saved episodata"
          console.log episodata
