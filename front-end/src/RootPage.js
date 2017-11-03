import React, { Component } from "react";
import { Link } from "react-router-dom";

import logo from "./logo.svg";

import User from "./User";

class RootPage extends Component {
  state = { users: [] };

  componentDidMount() {
    fetch("/api/users")
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
        <div>
          <nav>
            <Link to="/sign-up">Sign Up</Link>
          </nav>
        </div>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
        {this.state.users.map(user => <User key={user.id} {...user} />)}
      </div>
    );
  }
}

export default RootPage;
