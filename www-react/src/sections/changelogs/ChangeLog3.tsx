import React, {Component} from 'react';
import LogAction from './LogAction';

class ChangeLog3 extends Component {
  render() {
    return (
      <React.Fragment>
        <LogAction entry={3} version="07-Feb-2015" expanded={false} />
        <div id="text3" style={{display: "none"}}>
          <ul>
            <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
            <li>
              <strong>Minimal Linux Live</strong> is now based on <strong>Linux kernel 3.18.6</strong> and <strong>Busybox 1.23.1</strong>.
            </li>
          </ul>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
      </React.Fragment>
    );
  }
}

export default ChangeLog3;
