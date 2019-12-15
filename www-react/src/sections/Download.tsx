import React, {Component} from 'react';
import {MLL_VERSION} from '../ts/main';

class Download extends Component {
  render() {
    return (
      <div id="item6" style={{display: "none"}}>
        <div className="row">
          <div className="twelve columns">
            <h4>Download Section</h4>
          </div>
        </div>
        <div className="row">
          <div className="twelve columns">
            The build scripts for version <code>{MLL_VERSION}</code> are available as <strong>tar.xz</strong> archive.
            <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
            <ul>
              <li>
                <a href={"http://github.com/ivandavidov/minimal/releases/download/" + MLL_VERSION + "/minimal_linux_live_" + MLL_VERSION + "_src.tar.xz"} title="Minimal Linux Live - shell scripts">minimal_linux_live_{MLL_VERSION}_src.tar.xz</a> - from GitHub.
              </li>
            </ul>
          </div>
        </div>
        <div className="row">
          <div className="twelve columns">
            The link below provides pre-built ISO image with support for legacy BIOS (64-bit, Intel CPUs).
            <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
            <ul>
              <li>
                <a href={"http://github.com/ivandavidov/minimal/releases/download/" + MLL_VERSION + "/minimal_linux_live_" + MLL_VERSION + "_64-bit_bios.iso"} title="Minimal Linux Live - ISO image file for 64-bit CPUs (legacy BIOS)">minimal_linux_live_{MLL_VERSION}_64-bit_bios.iso</a> - 64-bit ISO image from GitHub.
              </li>
            </ul>
          </div>
        </div>
        <div className="row">
          <div className="twelve columns">
            You can browse the <a target="_blank" rel="noopener noreferrer" href="http://github.com/ivandavidov/minimal/releases">GitHub releases</a> where you will find all source archives, as well as pre-built ISO images with support for BIOS, UEFI and mixed BIOS/UEFI mode.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            You can take a look at the latest development sources in the <a target="_blank" rel="noopener noreferrer" href="http://github.com/ivandavidov/minimal">GitHub project</a>.
          </div>
        </div>
      </div>
    );
  }
}

export default Download;
