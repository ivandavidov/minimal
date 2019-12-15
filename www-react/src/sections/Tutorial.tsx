import React, {Component} from 'react';

class Tutorial extends Component {
  render() {
    return (
      <div id="item4" style={{display: "none"}}>
        <div className="row">
          <div className="twelve columns">
            <h4>Minimal Linux Live Tutorial</h4>
          </div>
        </div>
        <div className="row">
          <div className="twelve columns">
            Would you like to learn how to build your own minimal live Linux OS?
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            <a target="_blank" rel="noopener noreferrer" href="./the_dao_of_minimal_linux_live.txt">The Dao of Minimal Linux Live</a> is a tutorial based on the first published version of Minimal Linux Live. The tutorial explains in detail what steps are involved in the creation of simple live Linux OS entirely from scratch, the inner structure of the build scripts and provides you with more information on how to improve/upgrade the generated OS with other generic stuff (e.g. users &amp; groups, /etc/inittab).
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            You can also refer to the <a href="http://github.com/ivandavidov/minimal-linux-script" target="_blank" rel="noopener noreferrer">Minimal Linux Script</a> project which provides you with the minimal set of shell script commands that you need in order to create simple, yet fully functional Linux based operating system.
          </div>
        </div>
      </div>
    );
  }
}

export default Tutorial;
