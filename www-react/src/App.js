import React from 'react';
import {Component} from 'react';

import Header from './Header.js';
import Menu from './Menu.js';
import Sections from './Sections.js';
import Footer from './Footer.js';

import {pageLoaded} from './js/main.js';

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
