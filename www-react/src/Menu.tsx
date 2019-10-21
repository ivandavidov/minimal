import React from 'react';
import {Component} from 'react';

import {loadTab} from './ts/main';

class Menu extends Component {
  render() {
    return (
      <div className="row">
        <div className="twelve columns" style={{textAlign: "center"}}>
          <a id="hm1" className="button button-primary" href="#home" onClick={() => {loadTab("#home"); return false;}}>Home</a>&nbsp;
          <a id="hm2" className="button button-primary" href="#changes" onClick={() => {loadTab("#changes"); return false;}}>Changes</a>&nbsp;
          <a id="hm3" className="button button-primary" href="#about" onClick={() => {loadTab("#about"); return false;}}>About</a>&nbsp;
          <a id="hm4" className="button button-primary" href="#tutorial" onClick={() => {loadTab("#tutorial"); return false;}}>Tutorial</a>&nbsp;
          <a id="hm5" className="button button-primary" href="#emulator" onClick={() => {loadTab("#emulator"); return false;}}>Emulator</a>&nbsp;
          <a id="hm6" className="button button-primary" href="#download" onClick={() => {loadTab("#download"); return false;}}>Download</a>&nbsp;
          <a id="hm7" className="button" target="_blank" rel="noopener noreferrer" href="http://github.com/ivandavidov/minimal">GitHub</a>
          <hr />
        </div>
      </div>
    );
  }
}

export default Menu;
