import React, { Component } from "react";
import "./App.css";
import ValidationComponent from './ValidationComponent/ValidationComponent';
import CharComponent from './CharComponent/CharComponent';

class App extends Component {
  state = {
    inputchars: "Input Something",
    inputLength: "Input Something".length
  };
  textChange = (newString) => {
    this.setState({ inputchars: newString });
    this.setState({inputLength: newString.length})
  };

  deleteCharHandler = (charIndex) => {
    console.log("deleteCharHandler", charIndex);
    let c = this.state.inputchars.split('');
    c.splice(charIndex,1)
    const updatedText = c.join('');
    this.setState({inputchars:updatedText});
    this.setState({inputLength: updatedText.length});
  }


  render() {
    const charList = this.state.inputchars.split('').map((ch, index) => {
      return <CharComponent 
        character={ch} 
        key={index}
        clicked={() => this.deleteCharHandler(index)} />;
    });
    return (
      <div className="App">
        <header className="App-header">
          <h1>String Parser Example</h1>
        </header>
        <div>
          <input
            type="text"
            onChange={event => this.textChange(event.target.value)}
            value={this.state.inputchars}
          />
        </div>
        <div className="Thick">
          Length is {this.state.inputchars.length}
        </div>
        <div className="Thick">
          <ValidationComponent inputLength={this.state.inputLength}/>
        </div>
        {charList}
      </div>
    );
  }
}

export default App;
