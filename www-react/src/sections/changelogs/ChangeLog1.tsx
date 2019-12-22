import React, {Component} from 'react';
import LogAction from './LogAction';

class ChangeLog1 extends Component {
  render() {
    return (
      <React.Fragment>
        <LogAction entry={1} version="28-Jul-2014" expanded={false} />
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
      </React.Fragment>
    );
  }
}

export default ChangeLog1;
