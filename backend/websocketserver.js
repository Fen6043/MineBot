const Websocket = require("ws")
const wss = new Websocket.Server({port:3001});
const data = {
  statusdetails : {"Turtle1" : true,"Turtle2" : false,"Turtle3": false},
  locationdetails : {"Turtle1" : "1000 12 300","Turtle2" : "200 10 350"},
  fueldetails : {"Turtle1" : 100,"Turtle2" : 1200},
  itemdetails : {"Turtle1" :{"diamond" : 62, "iron":2 , "netherite":1 , "redstone":3},"Turtle2" :{"diamond" : 10 , "iron":2, "netherite":0 , "redstone":5}},
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