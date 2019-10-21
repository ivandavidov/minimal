import React from 'react';
import {Component} from 'react';

import Home from "./sections/Home";
import ChangeLog from "./sections/ChangeLog";
import About from "./sections/About";
import Tutorial from "./sections/Tutorial";
import Emulator from "./sections/Emulator";
import Download from "./sections/Download";

class Sections extends Component {
  render() {
    return (
      <div id="sections">
        <Home />
        <ChangeLog />
        <About />
        <Tutorial />
        <Emulator />
        <Download />
      </div>
    );
  }
}

export default Sections;
