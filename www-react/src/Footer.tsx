import React, {Component} from 'react';
import {COPYRIGHT} from './ts/main';

class Footer extends Component {
  render() {
    return (
      <React.Fragment>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns" style={{textAlign: "center"}}>
            <a className="button" href="# " onClick={(e) => {window.scrollTo(0, 0);}}>Go to top</a>
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div id="footer" className="row" style={{textAlign: "center"}}>
          <div className="twelve columns">
            <a href="." title="Minimal Linux Live">Minimal Linux Live</a>&nbsp;
            <span className="separator">|</span>&nbsp;Copyright &copy; {COPYRIGHT}
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
      </React.Fragment>
    );
  }
}

export default Footer;
