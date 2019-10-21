import React, {Component} from 'react';
import {logSwap} from '../../ts/main';

class ChangeLog5 extends Component {
  render() {
    return (
      <div>
        <div id="show5" style={{display: "block"}}>
          <strong>03-Apr-2016</strong>&nbsp;
          <a href="#changes" onClick={() => {logSwap(5, true); return false;}}>show</a>
        </div>
        <div id="hide5" style={{display: "none"}}>
          <strong>03-Apr-2016</strong>&nbsp;
          <a href="#changes" onClick={() => {logSwap(5, false); return false;}}>hide</a>
        </div>
        <div id="text5" style={{display: "none"}}>
          <ul>
            <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
            <li>
              <strong>Minimal Linux Live</strong> is now based on <strong>Linux kernel 4.4.6</strong>, <strong>GNU C library 2.23</strong> and <strong>Busybox 1.24.2</strong>. The generated ISO image file is ~4MB larger due to glibc overhead and requires more RAM (64MB is enough).
            </li>
            <li>
              The build architecture has been revised and now the only core dependency to the host OS is the actual C compiler along with the related binary utils. Kernel headers and main C library (which used to be implicit dependencies) are now automatically generated and used as part of the overall build process.
            </li>
            <li>
              The DNS resolving issue has been fixed and the network/internet related Busybox applets (ping, wget, etc.) now work fine.
            </li>
            <li>
              The ISO image generation process is now in a separate script file, completely detached from the kernel build infrastructure. This allows the Minimal Linux Live users to modify the ISO image file/directory structure before the actual ISO generation.
            </li>
            <li>
              The internal script comments have been revised and now they are more descriptive than before.
            </li>
            <li>
              The experimental folder has been removed.
            </li>
          </ul>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
      </div>
    );
  }
}

export default ChangeLog5;
