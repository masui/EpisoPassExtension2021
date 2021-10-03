#
# Facebookなどのログイン画面でEpisoPassを呼び出すブラウザ拡張機能
# ChromeでもFirefoxでも使えるはず
#

episodata = []#

$ ->
  passelement = []
  idelement = null
  service = ''
  
  if location.href.match /amazon/
    idelement = $('#ap_email')
    passelement = $("input[type='password']")
    service = 'Amazon'
  if location.href.match /gyazo.com/
    idelement = $('input[name="email"]')
    passelement = $("input[type='password']")
    service = 'Gyazo'
  if location.href.match /github.com/
    idelement = $('#login_field')
    passelement = $("input[type='password']")
    service = 'GitHub'
  if location.href.match /linkedin.com/
    idelement = $('#username')
    # passelement = $('#password')
    passelement = $("input[type='password']")
    service = 'LinkedIn'
  if location.href.match /facebook.com/
    idelement = $('#email')
    # passelement = $('#pass')
    passelement = $("input[type='password']")
    service = 'Facebook'
  if location.href.match /heroku.com/
    idelement = $('#email')
    # passelement = $('#password')
    passelement = $('input[type="password"]')
    service = 'Heroku'
  if location.href.match /value-domain.com/
    idelement = $('#username')
    # passelement = $('#password')
    passelement = $('input[type="password"]')
    service = 'ValueDomain'
  if location.href.match /tumblr.com/
    # idelement = $('#signup_email')
    idelement = $('input[name="email"]') 
    # passelement = $('#signup_password')
    passelement = $('input[type="password"]')
    service = 'Tumblr'

  # ↑ここまで動いている

  if location.href.match /twitter.com/
    # passelement = $('.js-password-field')
    # idelement = $('.text-input')
    # idelement = $('.email-input')
    # idelement = $('input[name="email"]')
    idelement = $('input[name="username"]')
    if idelement
      console.log idelement
      idelement.on 'change', ->
        console.log 100
        # localStorage.setItem 'idvalue', idelement.value

    # passelement = $('input[name="password"]')
    passelement = $('input[type="password"]')
    service = 'Twitter'

  if location.href.match /pinterest\./
    idelement = $('#email')
    passelement = $('#password')
    service = 'Pinterest'

  # セーブされてるEpisoPassデータを読む
  #episodata = []
  #chrome.storage.local.get "episodata", (value) ->
  #  if Object.keys(value).length == 0
  #    episodata = []
  #  else
  #    episodata = value.episodata

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

  #
  # パスワード入力画面か判定し、
  #
  if idelement && passelement && passelement[0] != undefined && passelement.val() == ''
    console.log passelement.val()
    passelement.on 'click', ->
      if !window.clicked
        id = idelement.val()
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
                .css 'z-index',999
                .attr 'id','episopass'
              $('body').append div

              exports.run entry,id,entry.seed,passelement

      window.clicked = true
