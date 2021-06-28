import React, {Component} from 'react';

class Emulator extends Component {
  render() {
    return (
      <div id="item5" style={{display: "none"}}>
        <div className="row">
          <div className="twelve columns">
            <h4>Online PC Emulator</h4>
          </div>
        </div>
        <div className="row">
          <div className="twelve columns">
            You can try <b>Minimal Linux Live</b> directly in your browser. The link below will open new browser window (or tab) with JavaScript based PC emulator which will automatically run Minimal Linux Live version <strong>28-Jan-2018</strong>. Please be advised that this PC emulator runs entirely in your browser and therefore it is not very fast.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            <a target="_blank" href="emulator">Minimal Linux Live - emulator</a>
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            Some screenshots with Minimal Linux Live running in the JavaScript PC emulator:
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="three columns">
            <a href="assets/img/emulator_01.jpg" target="_blank" title="Minimal Linux Live in JavaScript PC emulator- screenshot 1">
              <img alt="Minimal Linux Live" id="emulator1" width="100%" height="100%" src="assets/img/emulator_01.jpg" />
            </a>
          </div>
          <div className="three columns">
            <a href="assets/img/emulator_02.jpg" target="_blank" title="Minimal Linux Live in JavaScript PC emulator- screenshot 2">
              <img alt="Minimal Linux Live" id="emulator2" width="100%" height="100%" src="assets/img/emulator_02.jpg" />
            </a>
          </div>
          <div className="three columns">
            <a href="assets/img/emulator_03.jpg" target="_blank" title="Minimal Linux Live in JavaScript PC emulator- screenshot 3">
              <img alt="Minimal Linux Live" id="emulator3" width="100%" height="100%" src="assets/img/emulator_03.jpg" />
            </a>
          </div>
          <div className="three columns">
            <a href="assets/img/emulator_04.jpg" target="_blank" title="Minimal Linux Live in JavaScript PC emulator- screenshot 4">
              <img alt="Minimal Linux Live" id="emulator4" width="100%" height="100%" src="assets/img/emulator_04.jpg" />
            </a>
          </div>
        </div>
      </div>
    );
  }
}

export default Emulator;
