import React, {Component} from 'react';
import {logSwap} from '../../ts/main';

type LogActionProps = {
  entry: number,
  version: string;
}


class LogAction extends Component<LogActionProps> {
  render() {
    return (
      <React.Fragment>
        <div id={"show" + this.props.entry} style={{display: "none"}}>
          <strong>{this.props.version}</strong>&nbsp;
          <a href="#changes" onClick={() => {logSwap(this.props.entry, true); return false;}}>show</a>
        </div>
        <div id={"hide" + this.props.entry} style={{display: "block"}}>
          <strong>{this.props.version}</strong>&nbsp;
          <a href="#changes" onClick={() => {logSwap(this.props.entry, false); return false;}}>hide</a>
        </div>
      </React.Fragment>
    )
  }
}

export default LogAction;
