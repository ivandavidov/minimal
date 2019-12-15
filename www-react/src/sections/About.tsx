import React, {Component} from 'react';

class About extends Component {
  render() {
    return (
      <div id="item3" style={{display: "none"}}>
        <div className="row">
          <div className="twelve columns">
            <h4>About This Project</h4>
          </div>
        </div>
        <div className="row">
          <div className="twelve columns">
            My name is <a target="_blank" rel="noopener noreferrer" href="http://linkedin.com/in/ivandavidov">Ivan Davidov</a> and I currently live and work in <a target="_blank" rel="noopener noreferrer" href="http://en.wikipedia.org/wiki/Sofia">Sofia</a>, <a target="_blank" rel="noopener noreferrer" href="http://en.wikipedia.org/wiki/Bulgaria">Bulgaria</a>.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            I am professional Java software engineer (surprisingly, Java developers tend to know some Linux stuff) and I have been trying to create my own Linux OS for a very long time. Over the years I found some good online tutorials, but most of them are not simple to follow and pretty much none of them explains in detail what has been done and why it's done in this particular way. In most cases the tutorials are outdated or incomplete and there is high chance that you will end up with something broken.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            You can learn a lot from these online tutorials, as I did. In fact, the scripts that I created are based on the same information resources which you might have already found. The difference is that this project provides you with fully functional set of shell scripts which automatically build fully functional live Linux OS, detailed tutorial and probably the best internal documentation you will ever find in an open source project.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            You can follow Minimal Linux Live on <a href="http://facebook.com/MinimalLinuxLive" target="_blank" rel="noopener noreferrer">Facebook</a>. If you'd like to contact me, my e-mail is: <strong>davidov [dot] i (at) gmail {"{"}dot{"}"} com</strong>. Let me know if you find this project useful. Thanks! :)
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            My LinkedIn profile is here: <a target="_blank" rel="noopener noreferrer" href="http://linkedin.com/in/ivandavidov">http://linkedin.com/in/ivandavidov</a>
          </div>
        </div>
      </div>
    );
  }
}

export default About;
