import React, {Component} from 'react';
import Home from "./sections/Home";
import ChangeLog from "./sections/ChangeLog";
import About from "./sections/About";
import Tutorial from "./sections/Tutorial";
import Emulator from "./sections/Emulator";
import Download from "./sections/Download";

class Sections extends Component {
  render() {
    const shadow = {
      boxShadow: "0px 2px 8px rgba(0, 0, 0, 0.2)",
      paddingLeft: "4px",
      paddingRight: "4px"
    };

    return (
      <div id="sections" style={shadow}>
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
