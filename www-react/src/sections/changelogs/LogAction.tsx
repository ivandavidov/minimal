import React, {Component} from 'react';
import {logSwap} from '../../ts/main';

type LogActionProps = {
  entry: number,
  version: string;
  expanded: boolean;
}

type LogActionState = {
  show: boolean;
}

class LogAction extends Component<LogActionProps, LogActionState> {
  constructor(props: LogActionProps) {
    super(props);
    this.state = {show: props.expanded};
  }
  
  handleLogEntryChange(e: React.MouseEvent) {
    let newState: boolean = !this.state.show;
    this.setState({show: newState});
    logSwap(this.props.entry, newState);
    e.preventDefault();
  }
    
  render() {
    return (
      <React.Fragment>
        <strong>{this.props.version}</strong>&nbsp;
        <a href="# " onClick={(e) => {this.handleLogEntryChange(e);}}>{this.state.show ? "hide" : "show"}</a>
      </React.Fragment>
    )
  }
}

export default LogAction;
