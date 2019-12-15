import React, {Component} from 'react';
import ChangeLog8 from './changelogs/ChangeLog8';
import ChangeLog7 from './changelogs/ChangeLog7';
import ChangeLog6 from './changelogs/ChangeLog6';
import ChangeLog5 from './changelogs/ChangeLog5';
import ChangeLog4 from './changelogs/ChangeLog4';
import ChangeLog3 from './changelogs/ChangeLog3';
import ChangeLog2 from './changelogs/ChangeLog2';
import ChangeLog1 from './changelogs/ChangeLog1';

class ChangeLog extends Component {
  render() {
    return (
      <div id="item2" style={{display: "none"}}>
        <div className="row">
          <div className="twelve columns">
            <h4>Change Log</h4>
          </div>
        </div>
        <div className="row">
          <div className="twelve columns">
            <ChangeLog8 />
            <ChangeLog7 />
            <ChangeLog6 />
            <ChangeLog5 />
            <ChangeLog4 />
            <ChangeLog3 />
            <ChangeLog2 />
            <ChangeLog1 />
          </div>
        </div>
      </div>
    );
  }
}

export default ChangeLog;
