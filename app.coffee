display = (data,name,seed,passelement,qno,answer) ->
  episodiv  = $('#episopass')
  episodiv.children().remove()

  qtext = data['qas'][qno]['question']

  center = $('<center>')
  episodiv.append(center)
  center.css 'width','100%'

  if qtext.match(/\/([^\/]+\.(gif|png|jpg|jpeg))$/i)
    div = $('<img>')
      .css 'width',120
      .attr 'src',qtext
  else
    div = $('<div>')
      .text qtext
      .css 'background-color','#ccc'
      .css 'width','400px'
      .css 'border-radius','5px'
      #.css 'margin','4px'
      .css 'padding','4px'
      .css 'margin','2 auto'

  center.append div
  center.append $('<p>')
  div = $('<div>')
  center.append div
    
  answers = data['qas'][qno]['answers']
  for i in [0...answers.length]
    input = $('<input>')
    input.attr 'type','button'
      .attr 'value',answers[i]
      .attr 'anumber',i
      .css 'margin','2pt'
      .css 'padding','1pt'
      .css 'width', '50pt'
      .css 'height', '25pt'
      .css 'border-radius','4px'
      .css 'background-color','#ccc'
      .click (event) ->
        event.preventDefault()
        answer[qno] = Number($(this).attr('anumber'))
        if qno < data['qas'].length - 1
          display(data,name,seed,passelement,qno+1,answer)
        else
          newpass = exports.crypt(seed,secretstr(data,answer))
          passelement.val(newpass)
          episodiv.remove() #  質問ウィンドウを消す
        
    div.append input

secretstr = (data,answer) ->
  secret = ""
  qas = data['qas']
  for i in [0...qas.length]
    secret += qas[i]['question']
    secret += qas[i]['answers'][answer[i]]
  secret

exports.run = (data,name,seed,passelement) ->
  display data,name,seed,passelement,0,[]
