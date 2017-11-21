import React from 'react';
import './UserOutput.css';

const useroutput = (props) => {
    const style = {
        fontFamily: 'Impact'
    }

    return (
        <div className="UserOutput">
            <p>
                {props.user}
            </p>
            <p>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit.
            Donec auctor, risus vitae gravida sollicitudin, augue risus fringilla dolor,
            quis scelerisque justo metus eu justo. Nulla sed sodales quam.
            Sed vitae libero sit amet leo lobortis pulvinar vitae id justo.
            Maecenas aliquet erat massa, nec aliquet elit faucibus at.
            Ut mauris urna, lacinia eu accumsan cursus, faucibus vel nisi.
            Sed nulla purus, cursus quis ante sed, aliquet consequat nibh.
            Phasellus aliquam ipsum sit amet maximus luctus.
        </p>
            <p style={style}>
                Lorem ipsum dolor sit amet, consectetur adipiscing elit.
            Donec auctor, risus vitae gravida sollicitudin, augue risus fringilla dolor,
            quis scelerisque justo metus eu justo. Nulla sed sodales quam.
            Sed vitae libero sit amet leo lobortis pulvinar vitae id justo.
            Maecenas aliquet erat massa, nec aliquet elit faucibus at.
            Ut mauris urna, lacinia eu accumsan cursus, faucibus vel nisi.
            Sed nulla purus, cursus quis ante sed, aliquet consequat nibh.
            Phasellus aliquam ipsum sit amet maximus luctus.
        </p>
        </div>
    )
}

export default useroutput;