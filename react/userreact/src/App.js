import React, { Component } from 'react';
import './App.css';
import UserInput from './UserInput/UserInput';
import UserOutput from './UserOutput/UserOutput';

class App extends Component {
  state = {user: 'Default User'}
  render() {
    return (
      <div className="App">
        <UserInput changed={this.userChangeHandler} user={this.state.user}/>
        <UserOutput user={this.state.user}/>
      </div>
    );
  }
  userChangeHandler = (event) => {
    this.setState({user: event.target.value});
  };
}



export default App;
