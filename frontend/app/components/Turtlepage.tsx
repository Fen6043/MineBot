'use client'
import { useEffect, useState } from 'react';
import Image from 'next/image';

function Turtlepage({ turtle}: { turtle: string}){
    const [turtleitemdetails , setTurtleitemdetails] = useState<{ [key: string]: number }>({})
    const [itemdetails , setItemdetails] = useState<{ [key: string]: { [key: string]: number } }>({})
    const [location , setLocation] = useState<{ [key: string]: string }>({})
    const [status , setStatus] = useState<{ [key: string]: boolean }>({})
    const [fuelLevel , setFuelLevel] = useState<{ [key: string]: number }>({})

    useEffect(() => {
        const socket = new WebSocket('ws://localhost:3001')

        socket.onopen = () => {
            console.log("Connected to Web socket")
        };

        socket.onmessage = (event) => {
            console.log('Message from server: ', event.data);
            const socketdata = JSON.parse(event.data)
            setItemdetails(socketdata.itemdetails)
            setLocation(socketdata.locationdetails)
            setStatus(socketdata.statusdetails)
            setFuelLevel(socketdata.fueldetails)
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

    useEffect(() => {
        // console.log("change detected")
        if (turtle && itemdetails[turtle])
        {
            // console.log("changing items")
            setTurtleitemdetails(itemdetails[turtle])
        }
        else
        setTurtleitemdetails({})
    },[itemdetails, turtle])

    return(
        <div className=" grid grid-cols-2 gap-2 pt-4">
            <div className=" border-2 rounded-xl border-t-orange-500 border-r-orange-500 p-2 flex flex-col max-h-fit items-center">
                <div className={`p-2 select-none ${status[turtle]?" text-lime-500":"text-red-500"}`}>Status : {status[turtle] ? "On" : "Off"}</div>
                <div className="p-2">Location : {location[turtle]}</div>
                <div className="p-2">Fuel Level : {fuelLevel[turtle]}</div>
            </div>
            <div className=" border-2 rounded-xl border-t-teal-500 border-l-teal-500 p-2 flex flex-wrap max-h-full">
                {Object.entries(turtleitemdetails).map(([key, value], index) => {
                    if(value > 0){
                        return (
                            <div key={index} className="bg-white rounded-md w-12 h-16 p-2 m-2 flex flex-col items-center justify-center text-slate-950">
                                <Image key={"K"+index} src= {`/images/${key}.png`} alt="Logo" width={40} height={40} className='h-10'/> 
                                <div key={"D"+index} className="select-none">{value}</div>
                            </div>
                        )
                    }
                }
                )}
            </div>
        </div>
    )
    }
    
    export default Turtlepage;