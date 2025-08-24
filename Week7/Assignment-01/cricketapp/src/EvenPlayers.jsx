import React from 'react';

export function EvenPlayers([, second, , fourth, , sixth]) {
  return (
    <div>
      <li>Second: {second}</li>
      <li>Fourth: {fourth}</li>
      <li>Sixth: {sixth}</li>
    </div>
  );
}
