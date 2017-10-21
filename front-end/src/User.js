import React from "react";

export default function User({ userId, userFirstName, userLastName }) {
  return (
    <div>
      <p>
        Id: {userId}
      </p>
      <p>
        First Name: {userFirstName}
      </p>
      <p>
        Last Name: {userLastName}
      </p>
    </div>
  );
}
