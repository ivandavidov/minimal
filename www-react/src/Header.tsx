import React, {Component} from 'react';

class Header extends Component {
  render() {
    return (
      <div className="row">
        <div className="twelve columns" style={{textAlign: "center"}}>
          <h2><a href="." style={{textDecoration: "none", color: "#000"}}>Minimal Linux Live</a></h2>
        </div>
      </div>
    );
  }
}

export default Header;
