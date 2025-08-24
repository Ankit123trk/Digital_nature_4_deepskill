import React from 'react';
import './App.css';

function App() {
  const sr = "https://t4.ftcdn.net/jpg/03/84/55/29/240_F_384552930_zPoe9zgmCF7qgt8fqSedcyJ6C6Ye3dFs.jpg";

  const element = "Office Space";

  const jsxatt = <img src={sr} width="25%" height="25%" alt="Office Space" />;

  const ItemName = {
    Name: "DBS",
    Rent: 50000,
    Address: "Chennai"
  };

  let colors = [];
  if (ItemName.Rent <= 60000) {
    colors.push("textRed");
  } else {
    colors.push("textGreen");
  }

  return (
    <div className='App'>
      <h1>{element}, at Affordable Range</h1>
      {jsxatt}
      <h1>Name: {ItemName.Name}</h1>
      <h3 className={colors[0]}>Rent: Rs. {ItemName.Rent}</h3>
      <h3>Address: {ItemName.Address}</h3>
    </div>
  );
}

export default App;
