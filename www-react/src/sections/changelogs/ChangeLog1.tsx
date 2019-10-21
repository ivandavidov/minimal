import React, {Component} from 'react';
import {logSwap} from '../../ts/main';

class ChangeLog1 extends Component {
  render() {
    return (
      <div>
        <div id="show1" style={{display: "block"}}>
          <strong>28-Jul-2014</strong>&nbsp;
          <a href="#changes" onClick={() => {logSwap(1, true); return false;}}>show</a>
        </div>
        <div id="hide1" style={{display: "none"}}>
          <strong>28-Jul-2014</strong>&nbsp;
          <a href="#changes" onClick={() => {logSwap(1, false); return false;}}>hide</a>
        </div>
        <div id="text1" style={{display: "none"}}>
          <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
          <ul>
            <li>
              <strong>Minimal Linux Live</strong> is now based on <strong>Linux kernel 3.15.6</strong> and <strong>Busybox 1.22.1</strong>.
            </li>
            <li>
              The boot process is based on simple <strong>/init</strong> script.
            </li>
          </ul>
        </div>
      </div>
    );
  }
}

export default ChangeLog1;
