import React from 'react';
import {Component} from 'react';

import Home from "./sections/Home.js";
import ChangeLog from "./sections/ChangeLog.js";
import About from "./sections/About.js";
import Tutorial from "./sections/Tutorial.js";
import Emulator from "./sections/Emulator.js";
import Download from "./sections/Download.js";

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
