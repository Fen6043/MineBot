const Websocket = require("ws")
const wss = new Websocket.Server({port:3001});

wss.on('connection', (ws) => {
    console.log('someone connected!');

    ws.send('Welcome to server');

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