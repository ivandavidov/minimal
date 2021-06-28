import React, {Component} from 'react';
import LogAction from './LogAction';

class ChangeLog2 extends Component {
  render() {
    return (
      <React.Fragment>
        <LogAction entry={2} version="25-Aug-2014" expanded={false} />
        <div id="text2" style={{display: "none"}}>
          <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
          <ul>
            <li>
              <strong>Minimal Linux Live</strong> is now based on <strong>Linux kernel 3.16.1</strong> and <strong>Busybox 1.22.1</strong>.
            </li>
            <li>
              The boot process is now based on <strong>/sbin/init</strong> and <strong>/etc/inittab</strong>. There are four available consoles. You can switch between them with <strong>Alt + F1</strong> up to <strong>Alt + F4</strong>.
            </li>
            <li>
              Shell scripts have been updated. Now the downloaded source bundles are stored in separate folder. If the download process is interrupted, it will continue the next time the scripts are executed. The most notable change is in <strong>5_generate_rootfs.sh</strong> which now generates root file system with structure compatible with <strong>/sbin/init</strong> and <strong>/etc/inittab</strong>.
            </li>
          </ul>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
      </React.Fragment>
    );
  }
}

export default ChangeLog2;
