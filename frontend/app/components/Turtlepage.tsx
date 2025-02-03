function Turtlepage(){
    const itemdetails : {[key:string]:number} = {"D" : 62, "I":2 , "N":1 , "R":3}
    let status : boolean = false
    return(
        <div className=" grid grid-cols-2 gap-2 pt-4">
            <div className=" border-2 rounded-xl border-t-orange-500 border-r-orange-500 p-2 flex flex-col max-h-fit items-center">
                <div className={`p-2 select-none ${status?" text-lime-500":"text-red-500"}`}>Status : {status ? "On" : "Off"}</div>
                <div className="p-2">Location :</div>
                <div className="p-2">Fuel Level :</div>
            </div>
            <div className=" border-2 rounded-xl border-t-teal-500 border-l-teal-500 p-2 flex flex-wrap max-h-full">
                {Object.entries(itemdetails).map(([key, value], index) => (
                    <div key={index} className="bg-white rounded-md w-8 h-14 p-2 m-2 flex flex-col items-center justify-center text-slate-950">
                        <div className="select-none">{key}</div>
                        <div className="select-none">{value}</div>
                    </div>
                ))}
            </div>
        </div>
    )
    }
    
    export default Turtlepage;