import React, {Component} from 'react';
import {loadTab} from './ts/main';

class Menu extends Component {
  handleMenu(e: React.MouseEvent, tab: string) {
    e.preventDefault();
    loadTab(tab);
  }
  
  render() {
    return (
      <div className="row">
        <div className="twelve columns" style={{textAlign: "center"}}>
          <a id="hm1" className="button button-primary" href="# " onClick={(e) => {this.handleMenu(e, '#home');}}>Home</a>&nbsp;
          <a id="hm2" className="button button-primary" href="# " onClick={(e) => {this.handleMenu(e, '#changes');}}>Changes</a>&nbsp;
          <a id="hm3" className="button button-primary" href="# " onClick={(e) => {this.handleMenu(e, '#about');}}>About</a>&nbsp;
          <a id="hm4" className="button button-primary" href="# " onClick={(e) => {this.handleMenu(e, '#tutorial');}}>Tutorial</a>&nbsp;
          <a id="hm5" className="button button-primary" href="# " onClick={(e) => {this.handleMenu(e, '#emulator');}}>Emulator</a>&nbsp;
          <a id="hm6" className="button button-primary" href="# " onClick={(e) => {this.handleMenu(e, '#download');}}>Download</a>&nbsp;
          <a id="hm7" className="button" target="_blank" rel="noopener noreferrer" href="https://github.com/ivandavidov/minimal">GitHub</a>
        </div>
      </div>
    );
  }
}

export default Menu;
