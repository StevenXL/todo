import React from "react";
import { Switch, Route } from "react-router-dom";

import "./App.css";

import RootPage from "./RootPage";
import SignUp from "./SignUp";
import NoMatch from "./NoMatch";

const App = () => {
  return (
    <Switch>
      <Route exact path="/" component={RootPage} />
      <Route path="/sign-up" component={SignUp} />
      <Route component={NoMatch} />
    </Switch>
  );
};

export default App;
