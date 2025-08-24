import React, { useState } from 'react';
import CurrencyConvertor from './CurrencyConvertor';

const App = () => {
  const [count, setCount] = useState(0);

  const increment = () => {
    setCount(prev => prev + 1);
    sayHello();
  };

  const decrement = () => {
    setCount(prev => prev - 1);
  };

  const sayHello = () => {
    alert("Hello World!");
  };

  const sayWelcome = (msg) => {
    alert(msg);
  };

  const onPress = () => {
    alert("I was clicked");
  };

  return (
    <div style={{ padding: '20px' }}>

      <h2>Counter: {count}</h2>
      <button onClick={increment}>Increment</button><br/>
      <button onClick={decrement}>Decrement</button><br/>

      <button onClick={() => sayWelcome("Welcome!")}>Say Welcome</button><br/>
      
      <button onClick={onPress}>Click on me!</button><br/>

      <CurrencyConvertor />
    </div>
  );
};

export default App;
