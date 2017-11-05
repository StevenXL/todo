import React from "react";
import * as Ramda from "ramda";

class SignUp extends React.Component {
  state = {
    firstName: { value: "" },
    lastName: { value: "" },
    email: { value: "" },
    password: { value: "" }
  };

  valueFor = field => {
    return this.state[field].value;
  };

  updateValueFor = field => event => {
    const currentFieldData = this.state[field];

    const newFieldData = Ramda.merge(currentFieldData, {
      value: event.target.value
    });

    this.setState({ [field]: newFieldData });
  };

  render() {
    const onSubmit = event => {
      event.preventDefault();

      const postParams = Ramda.map(valueObj => valueObj.value, this.state);

      const body = JSON.stringify(postParams);

      return fetch("api/users", {
        method: "POST",
        body,
        headers: { "Content-Type": "application/json" }
      });
    };

    return (
      <div>
        <form onSubmit={onSubmit}>
          <fieldset>
            <div>
              <label htmlFor="firstName">First Name</label>
              <input
                name="firstName"
                onChange={this.updateValueFor("firstName")}
                required
                type="text"
                value={this.valueFor("firstName")}
              />
            </div>

            <div>
              <label htmlFor="lastName">Last Name</label>
              <input
                name="lastName"
                onChange={this.updateValueFor("lastName")}
                required
                type="text"
                value={this.valueFor("lastName")}
              />
            </div>

            <div>
              <label htmlFor="email">Email</label>
              <input
                name="email"
                onChange={this.updateValueFor("email")}
                required
                type="email"
                value={this.valueFor("email")}
              />
            </div>

            <div>
              <label htmlFor="password">Password</label>
              <input
                name="password"
                onChange={this.updateValueFor("password")}
                required
                type="password"
                value={this.valueFor("password")}
              />
            </div>

            <div>
              <button type="submit">Sign Up</button>
            </div>
          </fieldset>
        </form>
      </div>
    );
  }
}

export default SignUp;

/*
 * We need a form
 *  Form represents user
 *    On the back-end, the user has a first_name
 *                   , the user has a last_name
 *                   , the user has an email
 *                   , user WILL NEED password
 *                   , user WILL NEED password confirmation
 *  We need widgets for each of these fields
*/
