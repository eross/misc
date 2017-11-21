import React from 'react'

const charcomponent = (props) => {
    let resultArray = [];
    if(props.inputText.length > 0){
        resultArray = props.inputText.split("");
    }
    else
    {
        resultArray=["invalid"];

    }
    let resultChars = null;
    resultChars = (
        <div>
            {resultArray.map((mychar) =>  <div className="Boxed">{mychar}</div>).reduce((prev, curr) => [prev,',',curr])}
 
        </div>
    )
    return (
        {resultChars}
    )
}

export default charcomponent;