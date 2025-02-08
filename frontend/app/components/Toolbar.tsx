'use client'
import Image from 'next/image'
import Turtlepage from './Turtlepage';
import { useState, useEffect } from 'react';

function Toolbar(){
    const [turtleName,setTurtleName] = useState<string[]>([])
    const [selectTurtle,setSelectTurtle] = useState("")

    // Set connection with websocket
    useEffect(() => {
            const socket = new WebSocket('ws://localhost:3001')
            socket.onopen = () => {
                console.log("Connected to Web socket")
            };
            
            socket.onmessage = (event) => {
                console.log('Message from server: ', event.data);
                const socketdata = JSON.parse(event.data)
                setTurtleName(socketdata.turtleName)
            };
            
            socket.onclose = () => {
                console.log('Disconnected from WebSocket server');
            };
          
            socket.onerror = (error) => {
                console.log('WebSocket Error: ', error);
            };
            // Clean up WebSocket connection when the component unmounts
            return () => {
                console.log("closing websocket")
                socket.close();
            };
    }, []);

    return(
        <>
        <div className=" bg-teal-500 flex justify-between">
            <div className=" px-2 py-1">
                <Image src= "/images/Mining_Turtle.webp" alt="Logo" width={40} height={40} />
            </div>
            <div className=" p-2 select-none text-xl">Turtle Storage</div>
            <div className=" p-2">
                <select className=" text-slate-950 p-1 rounded-sm" onChange={(e) => {setSelectTurtle(e.target.value)}}>
                    <option>Select Turtle</option>
                    {turtleName.map((turtle,index) => (
                        <option key={index} value={turtle}>
                            {turtle}
                        </option>
                    ))}
                </select>
            </div>
        </div>
        <Turtlepage turtle = {selectTurtle}/>
        </>
    
    )
}

export default Toolbar;