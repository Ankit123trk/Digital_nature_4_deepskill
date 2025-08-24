import './App.css';

function App() {

  const books = [
    { id: 101, bname: 'Master React', price: 670 },
    { id: 102, bname: 'Deep Dive into Angular 11', price: 800 },
    { id: 103, bname: 'Mongo Essentials', price: 450 },
  ];


  const bookdet = (
    <ul>
      {books.map((book) => (
        <div key={book.id}>
          <h3>{book.bname}</h3>
          <h4>{book.price}</h4>
        </div>
      ))}
    </ul>
  );

  const content = (
    <div>
      <h2>React Learning</h2>
      <p><strong>Stephen Biz</strong></p>
      <p>Welcome to learning React!</p>
      <h3>Installation</h3>
      <p><strong>Schwezdiener</strong></p>
      <p>You can install React from npm.</p>
    </div>
  );

  const coursedet = (
    <div>
      <h2>Angular</h2>
      <p>4/5/2021</p>
      <h2>React</h2>
      <p>6/3/2021</p>
    </div>
  );

  return (
    <div className="container">
      <div className="column mystyle1">
        <h1>Course Details</h1>
        {coursedet}
      </div>

      <div className="column st2">
        <h1>Book Details</h1>
        {bookdet}
      </div>

      <div className="column v1">
        <h1>Blog Details</h1>
        {content}
      </div>
    </div>
  );
}

export default App;
