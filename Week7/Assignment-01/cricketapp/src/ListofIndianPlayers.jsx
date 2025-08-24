import React from 'react';

export function ListofIndianPlayers({IndianPlayers}) {
  return (
    <div>
      {IndianPlayers.map((player, index) => (
        <li key={index}>{player}</li>
      ))}
    </div>
  );
}
