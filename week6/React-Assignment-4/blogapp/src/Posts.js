import React, { Component } from 'react';
import PostModel from './Post';

class Posts extends Component {
  constructor(props) {
    super(props);
    this.state = {
      posts: [],
      hasError: false,
    };
  }

  loadPosts = () => {
    fetch('https://jsonplaceholder.typicode.com/posts')
      .then((res) => res.json())
      .then((data) => {
        const postObjects = data.map(
          (item) => new PostModel(item.id, item.title, item.body)
        );
        this.setState({ posts: postObjects });
      })
      .catch((error) => {
        console.error('Error fetching posts:', error);
      });
  };

  componentDidMount() {
    this.loadPosts();
  }

  componentDidCatch(error, info) {
    this.setState({ hasError: true });
    alert('An error occurred while rendering the component.');
    console.error('Caught error:', error, info);
  }

  render() {
    const { posts, hasError } = this.state;

    if (hasError) {
      return <h2>Something went wrong.</h2>;
    }

    return (
      <div>
        <h2>Posts List</h2>
        {posts.map((post) => (
          <div key={post.id} style={{width:'700px', border: '1px solid #ccc', margin: 'auto', padding: '1rem' }}>
            <h3>{post.title}</h3>
            <p>{post.body}</p>
          </div>
        ))}
      </div>
    );
  }
}

export default Posts;
