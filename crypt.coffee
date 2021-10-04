#
# crypt.coffee - EpisoPassでの文字置換
#
# Toshiyuki Masui @ Pitecan.com
# Last Modified: 2019/12/27
#

md5 = if typeof require == 'undefined' then exports else require('./md5.js')
# md5 = require "./md5.js"

#  文字種ごとに置換を行なうためのテーブル
origcharset = [
  'abcdefghijklmnopqrstuvwxyz'
  'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
  '0123456789'
  '-'
  '~!@#$%^&*()_=+[{]}|;:.,?'
  ' '
  "\"'/<>\\`"
]

hexcharset = [
  "0123456789abcdef"
]

charset = origcharset

charkind = (c) ->
  ind = null
  [0...charset.length].forEach (i) ->
    ind = i if charset[i].indexOf(c) >= 0
  ind
    
# crypt_char(crypt_char(c,n),n) == c になるような文字置換関数
crypt_char = (c, n) ->
  kind = charkind(c)
  chars = charset[kind]
  cind = chars.indexOf(c)
  len = chars.length
  ind = (n - cind + len) % len
  chars[ind]

#
# UTF8文字列をバイト文字列(?)に変換
# (MD5_hexhashがUTF8データをうまく扱えないため)
#
utf2bytestr = (text) ->
  result = ""
  return result if text == null
  [0...text.length].forEach (i) ->
    c = text.charCodeAt(i)
    if c <= 0x7f
      result += String.fromCharCode(c)
    else
      if c <= 0x07ff
        result += String.fromCharCode(((c >> 6) & 0x1F) | 0xC0)
        result += String.fromCharCode((c & 0x3F) | 0x80)
      else
        result += String.fromCharCode(((c >> 12) & 0x0F) | 0xE0)
        result += String.fromCharCode(((c >> 6) & 0x3F) | 0x80)
        result += String.fromCharCode((c & 0x3F) | 0x80)
  result

#
# secret_stringとcharset[]にもとづいてseedを暗号的に変換する
# crypt(crypt(s,data),data) == s になる
#
crypt = (seed,secret_string) ->
  # ハッシュ値ぽいときHex文字だけ使うことにする。ちょっと心配だが...
  # Hex文字が32文字以上で、数字と英字が入ってればまぁハッシュ値と思って良いのではないか...
  if seed.match(/[0-9a-f]{32}/) && seed.match(/[a-f]/) && seed.match(/[0-9]/)
    charset = hexcharset
  else
    charset = origcharset
  
  # secret_stringのMD5の32バイト値の一部を取り出して数値化し、
  # その値にもとづいて文字置換を行なう
  hash = md5.MD5_hexhash(utf2bytestr(secret_string))
  res = ''
  [0...seed.length].forEach (i) ->
    j = i % 8

    if j == 0 && i > 0 # 1ビットシフト
      hash = hash[31] + hash.substr(0,31)

    s = hash.substring(j*4,j*4+4)
    n = parseInt(s,16)
    res += crypt_char(seed[i],n+i)
  res

exports.crypt = crypt
