import React, {Component} from 'react';
import {logSwap} from '../../ts/main';

class ChangeLog3 extends Component {
  render() {
    return (
      <div>
        <div id="show3" style={{display: "block"}}>
          <strong>07-Feb-2015</strong>&nbsp;
          <a href="#changes" onClick={() => {logSwap(3, true); return false;}}>show</a>
        </div>
        <div id="hide3" style={{display: "none"}}>
          <strong>07-Feb-2015</strong>&nbsp;
          <a href="#changes" onClick={() => {logSwap(3, false); return false;}}>hide</a>
        </div>
        <div id="text3" style={{display: "none"}}>
          <ul>
            <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
            <li>
              <strong>Minimal Linux Live</strong> is now based on <strong>Linux kernel 3.18.6</strong> and <strong>Busybox 1.23.1</strong>.
            </li>
          </ul>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
      </div>
    );
  }
}

export default ChangeLog3;
