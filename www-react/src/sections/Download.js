import React from 'react';
import {Component} from 'react';

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
            The build scripts for version <code>28-Jan-2018</code> are available as <strong>tar.xz</strong> archive.
            <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
            <ul>
              <li id="dl1">
                <a href="http://github.com/ivandavidov/minimal/releases/download/28-Jan-2018/minimal_linux_live_28-Jan-2018_src.tar.xz" title="Minimal Linux Live - shell scripts">minimal_linux_live_28-Jan-2018_src.tar.xz</a> - from GitHub.
              </li>
              <li id="dl2">
                <a href="./download/2018/minimal_linux_live_28-Jan-2018_src.tar.xz" title="Minimal Linux Live - shell scripts">minimal_linux_live_28-Jan-2018_src.tar.xz</a> - from this website.
              </li>
            </ul>
          </div>
        </div>
        <div className="row">
          <div className="twelve columns">
            The list below provides pre-built ISO images with support for legacy BIOS for <strong>64-bit</strong> and <strong>32-bit</strong> Intel CPUs.
            <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
            <ul>
              <li id="dl3">
                <a href="http://github.com/ivandavidov/minimal/releases/download/28-Jan-2018/minimal_linux_live_28-Jan-2018_64-bit_bios.iso" title="Minimal Linux Live - ISO image file for 64-bit CPUs (legacy BIOS)">minimal_linux_live_28-Jan-2018_64-bit_bios.iso</a> - 64-bit ISO image from GitHub.
              </li>
              <li id="dl4">
                <a href="http://github.com/ivandavidov/minimal/releases/download/28-Jan-2018/minimal_linux_live_28-Jan-2018_32-bit_bios.iso" title="Minimal Linux Live - ISO image file for 32-bit CPUs (legacy BIOS)">minimal_linux_live_28-Jan-2018_32-bit_bios.iso</a> - 32-bit ISO image from GitHub.
              </li>
              <li id="dl5">
                <a href="./download/2018/minimal_linux_live_28-Jan-2018_64-bit_bios.iso" title="Minimal Linux Live - ISO image file for 64-bit CPUs (legacy BIOS)">minimal_linux_live_28-Jan-2018_64-bit_bios.iso</a> - 64-bit ISO image from this website.
              </li>
              <li id="dl6">
                <a href="./download/2018/minimal_linux_live_28-Jan-2018_32-bit_bios.iso" title="Minimal Linux Live - ISO image file for 32-bit CPUs (legacy BIOS)">minimal_linux_live_28-Jan-2018_32-bit_bios.iso</a> - 32-bit ISO image from this website.
              </li>
            </ul>
          </div>
        </div>
        <div className="row">
          <div className="twelve columns">
            You can browse the <a target="_blank" rel="noopener noreferrer" href="http://github.com/ivandavidov/minimal/releases">GitHub releases</a><span id="gh1"> or browse the <a target="_blank" href="./download">download directory</a> in this website</span> where you will find all source archives and pre-built ISO images with support for BIOS, UEFI and mixed BIOS/UEFI.
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
