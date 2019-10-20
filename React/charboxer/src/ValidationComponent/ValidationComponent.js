import React from 'react'

const validationcomponent = (props) => {
    let rstr="Undefined";
    if (props.inputLength >= 5) {
        rstr="Text long enough.";
    } else {
        rstr="Text too short.";
    }
    return (
        <div className="ValidationComponent">
            <p>{rstr}</p>
        </div>
    )
}

export default validationcomponent;