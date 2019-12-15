import React, {Component} from 'react';
import Header from './Header';
import Menu from './Menu';
import Sections from './Sections';
import Footer from './Footer';
import {pageLoaded} from './ts/main';

class App extends Component {
  render() {
    return (
      <div className="container">
        <Header />
        <Menu />
        <Sections />
        <Footer />
      </div>
    );
  }

  componentDidMount() {
    pageLoaded();
  }
}

export default App;
