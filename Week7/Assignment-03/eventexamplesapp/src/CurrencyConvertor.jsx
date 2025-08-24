import React, { useState } from 'react';

const CurrencyConvertor = () => {
  const [amount, setAmount] = useState('');
  const [currencyText, setCurrencyText] = useState('');
  const [result, setResult] = useState('');

  const handleAmountChange = (e) => {
    setAmount(e.target.value);
  }

  const handleCurrencyTextChange = (e) => {
    setCurrencyText(e.target.value);
  }

  const handleSubmit = () => {
    const rupeeToEuro = 0.0125;
    const euroToRupee = 1 / rupeeToEuro;
    
    const currency = currencyText.trim().toLowerCase();
    let result = '';

    if (currency === 'rupees') {
      result = (amount * rupeeToEuro).toFixed(0) + ' EUR';
    } else if (currency === 'euro') {
      result = (amount * euroToRupee).toFixed(0) + ' INR';
    } else {
      result = 'Please enter valid currency: Euro or Rupees';
    }

    setResult(result);
    alert(result);
  }

  return (
    <div>
      <h2 style={{ color: 'green' }}>Currency Convertor!!!</h2>

      Amount : <input
        type="number"
        placeholder="Enter amount"
        value={amount}
        onChange={handleAmountChange}
      />
      <br />

      Currency : <input
        type="text"
        placeholder="Enter currency (Euro or Rupees)"
        value={currencyText}
        onChange={handleCurrencyTextChange}
      />
      <br />

      <button onClick={handleSubmit}>Convert</button>
    </div>
  );
}

export default CurrencyConvertor;
