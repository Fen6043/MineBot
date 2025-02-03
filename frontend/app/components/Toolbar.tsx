import Image from 'next/image'
function Toolbar(){
    const TurtleName: string[] = ["Turtle01","Turtle02"]
return(
    <div className=" bg-teal-500 flex justify-between">
        <div className=" px-2 py-1">
            <Image src= "/images/Mining_Turtle.webp" alt="Logo" width={40} height={40} />
        </div>
        <div className=" p-2 select-none text-xl">Turtle Storage</div>
        <div className=" p-2">
            <select className=" text-slate-950 p-1 rounded-sm">
                <option>Select Turtle</option>
                {TurtleName.map((turtle,index) => (
                    <option key={index} value={turtle}>
                        {turtle}
                    </option>
                ))}
            </select>
        </div>
    </div>
)
}

export default Toolbar;