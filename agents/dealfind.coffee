
# Create a new agent with a parsing routine
agent = new Agent 'wagjag', (task, errors, window) ->
      $ = window.$

      to_queue = new Array()
      $('.side-deal a').each( ->
        to_queue.push( 'http://www.dealfind.ca'.concat( $(this).attr('href') ) )
      )
      to_queue = _.uniq( to_queue, true )
      console.log( to_queue )
      # TODO: add items to queue

      console.log( task )

      deals = [
        _id: 'www.dealfind.com/mississauga/divineshineautosalon'
        type: '/type/offer'
        lister: "dealfind"
        name: 'divineshineautosalon'
        merchant: '/merchant/dealfind-20219'
        price: $('.db_price:first').text()
        sold: $('.vouchersPurchased:first').text()
        item_info_url: task.uri
        summary: null
        description: null
      ]

agent.test = (task) -> task.uri.match /http:\/\/dealfind\.com\//

if typeof(exports) != 'undefined'
    exports.agent = agent

