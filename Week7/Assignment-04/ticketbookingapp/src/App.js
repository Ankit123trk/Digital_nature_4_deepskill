import React, { useState } from 'react';
import './App.css';

function App() {

  const [isLoggedIn, SetIsLoggedIn] = useState(false);

  const handleLogout = () => SetIsLoggedIn(false);
  const handleLogin = () => SetIsLoggedIn(true);

  if (isLoggedIn) {
    return (
      <div className='App'>
        <h2>Welcome back</h2>
        <button onClick={handleLogout}>Logout</button>
      </div>
    )
  }
  else {
    return (
      <div className='App'>
        <h2>Please sign up.</h2>
        <button onClick={handleLogin}>Login</button>
      </div>
    )
  }
}

export default App;
