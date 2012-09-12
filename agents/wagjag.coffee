
# Create a new agent with a parsing routine
wagjag = new Agent 'wagjag', (task, errors, window) ->
      $ = window.$

      console.log( task )
      # 11/01/2011 12:00 am GMT-0400
      #console.log( /TargetDate = "(\d{2})/(\d{2})/(\d{4}) (\d{2}):(\d{2})"/.exec( $('#deal_countdown').text() ) )
      date = /TargetDate = "(\d{2})\/(\d{2})\/(\d{4}) (\d{2}):(\d{2}) ([ap]m) (.*)"/.exec( $('#deal_countdown').text() )

      deals = [
        _id: "/listing/wagjag/" + task.uri.substr( 26 )
        type: "/type/listing"
        lister: "wagjag"
        dtexpired: if date then new Date( date[3], date[1] - 1, date[2] ) else NULL
        price: $('.buy_btn').text().substr( 9 )
        item_info_url: task.uri
        summary: $('.deal_details').html()
        description: $('#deal_information').html()
      ]

      queue.push

wagjag.test = (task) -> task.uri.match /http:\/\/wagjag\.com\/\?wagjag=/

if typeof(exports) != 'undefined'
    exports.agent = wagjag
