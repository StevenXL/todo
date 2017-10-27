import React from "react";

export default function User({ email, firstName, lastName, id }) {
  return (
    <div>
      <p>
        Id: {id}
      </p>
      <p>
        First Name: {firstName}
      </p>
      <p>
        Last Name: {lastName}
      </p>
    </div>
  );
}
