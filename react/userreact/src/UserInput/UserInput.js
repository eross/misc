import React from 'react'

const userinput = (props) => {
    return (
        <div className="UserInput">
            UserInput Testing: 
            <input type="text" onChange={props.changed} value={props.user}/>
        </div>
    )
}
export default userinput;