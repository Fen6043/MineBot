const Websocket = require("ws")
const wss = new Websocket.Server({port:3001});
const statusdetails = new Map()
statusdetails.set("Turtle1" , true)
statusdetails.set("Turtle2" , true)
statusdetails.set("Turtle3" , false)
const itemdetails = new Map()
itemdetails.set("Turtle1" , {"diamond" : 61, "iron":2 , "netherite":1 , "redstone":3})
itemdetails.set("Turtle2" , {"diamond" : 10 , "iron":2, "netherite":0 , "redstone":5})
itemdetails.set("Turtle2" , {"diamond" : 12 , "netherite":2 , "redstone":5})

const data = {
  statusdetails : Object.fromEntries(statusdetails),
  locationdetails : {"Turtle1" : "1000 12 300","Turtle2" : "200 10 350"},
  fueldetails : {"Turtle1" : 100,"Turtle2" : 1200},
  itemdetails : Object.fromEntries(itemdetails),
  turtleName : ["Turtle1","Turtle2","Turtle3"]
}

wss.on('connection', (ws) => {
    console.log('someone connected!');

    ws.send(JSON.stringify(data))

    ws.on('message', (message) => {
        console.log(`Received message: ${message}`);
    
        // You can send a response back to the client
        ws.send(`Server says: ${message}`);
      });
    
      // Handle when the connection is closed
      ws.on('close', () => {
        console.log('A client disconnected');
      });
    
      // Handle error events
      ws.on('error', (err) => {
        console.error('WebSocket error: ', err);
      });
  });

  console.log('WebSocket server is running on ws://localhost:3001');