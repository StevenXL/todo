import React, { Component } from "react";
import logo from "./logo.svg";
import "./App.css";
import User from "./User";

class App extends Component {
  state = { users: [] };

  componentDidMount() {
    fetch("/users")
      .then(response => response.json())
      .then(users => this.setState({ users }));
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to React</h1>
        </header>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
        {this.state.users.map(user => <User key={user.userId} {...user} />)}
      </div>
    );
  }
}

export default App;
