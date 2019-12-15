import React, {Component} from 'react';
import {loadTab, MLL_VERSION} from '../ts/main';

class Home extends Component {
  render() {
    return (
      <div id="item1" style={{display: "none"}}>
        <div className="row">
          <div className="twelve columns">
            <h4>Home</h4>
          </div>
        </div>
        <div className="row">
          <div className="twelve columns">
            Minimal Linux Live is a tiny educational Linux distribution, which is designed to be built from scratch by using a collection of automated shell scripts. Minimal Linux Live offers a core environment with just the <a target="_blank" rel="noopener noreferrer" href="http://kernel.org">Linux kernel</a>, <a target="_blank" rel="noopener noreferrer" href="http://gnu.org/software/libc">GNU C library</a> and <a target="_blank" rel="noopener noreferrer" href="http://busybox.net">Busybox</a> userland utilities. Additional software can be included in the ISO image at build time by using a well-documented configuration file. Minimal Linux Live can be downloaded as a pre-built image, built from scratch or run in a web browser by using a JavaScript PC emulator.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            <iframe width="560" height="315" title="Minimal Linux Live - YouTube Channel" src="https://youtube.com/embed/L6ahv5NuwNg?list=PLe3TW5jDbUAiN9E9lvYFLIFFqAjjZS9xS" frameBorder={0} allowFullScreen></iframe>
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            Steps to follow if you want to build your own Minimal Linux Live ISO image file:
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            <ul>
              <li>
                Get the latest source code archive from the <a href="#download" onClick={() => {loadTab("#download"); return false;}}>download</a> section.
              </li>
              <li>
                Extract the source code archive. Note that even though the extracted scripts are relatively small in size (~1MB), you need ~2GB free disk space for the actual build process.
              </li>
              <li>
                Resolve the build dependencies (e.g. GCC, make, etc.). On <a target="_blank" rel="noopener noreferrer" href="http://www.ubuntu.com/">Ubuntu</a> you can use the following command:
                <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <code>sudo apt install wget make gawk gcc bc bison flex xorriso libelf-dev libssl-dev</code>
              </li>
              <li>
                Execute the script <strong>build_minimal_linux_live.sh</strong> and get some coffee. The whole build process should take less than 30 minutes on a modern computer.
              </li>
              <li>
                In the end you will find the generated ISO image file <strong>minimal_linux_live.iso</strong> in the same folder where you started the build process.
              </li>
            </ul>
          </div>
        </div>
        <div className="row">
          <div className="twelve columns">
            The default build process for version <strong>{MLL_VERSION}</strong> generates ~10MB ISO image on 64-bit host machines, but you can make the ISO image even smaller if you exclude the default <a target="_blank" rel="noopener noreferrer" href="https://github.com/ivandavidov/minimal#overlay-bundles">overlay bundles</a> from the main <a target="blank" rel="noopener noreferrer" href="http://github.com/ivandavidov/minimal/blob/master/src/.config">.config</a> file.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            If your build fails for some reason, most probably there are unresolved build dependencies. Please have in mind that the build dependencies can vary a lot depending on the Linux OS that you use and the software that you have already installed. If you still have troubles, you should be able to identify the failing script from the console output. You may find it useful to enable "debug" logging in the failing shell script like this: <code>set -ex</code>. Manually run the failing script and identify the failing part. If you are unable to find a solution to your problem, then you can ask someone more experienced Linux guy around you or as alternative you can <a href="http://github.com/ivandavidov/minimal/issues" target="_blank" rel="noopener noreferrer">submit an issue</a>.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            You can run the ISO image in virtual machine, e.g. <a target="_blank" rel="noopener noreferrer" href="http://www.qemu.org">QEMU</a>, <a target="_blank" rel="noopener noreferrer" href="http://www.virtualbox.org">VirtualBox</a> or <a target="_blank" rel="noopener noreferrer" href="http://www.vmware.com/products/workstation-player.html">VMware Workstation Player</a> (free for non-commercial use). You can also burn the ISO image file on CD/DVD or on USB flash device by issuing <code>dd if=minimal_linux_live.iso of=/dev/xxx</code> where <code>/dev/xxx</code> is your USB flash device.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            You can also use Minimal Linux Live as Docker container. The build process generates very small Docker compatible container image which you can import and use.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            The generated ISO image file contains Linux kernel, GNU C library compiled with default options, Busybox compiled with default options, quite simple initramfs structure and some "overlay bundles" (the default build process provides few overlay bundles). You don't get Windows support out of the box, nor you get any fancy desktop environment. All you get is a simple shell console with default Busybox applets, network support via DHCP and... well, that's all. This is why it's called "minimal".
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            Note that by default Minimal Linux Live provides support for legacy BIOS systems. You can change the build configuration settings in the <a target="blank" href="http://github.com/ivandavidov/minimal/blob/master/src/.config">.config</a> file and rebuild MLL with support for modern UEFI systems.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            All build scripts are well organized and quite small in size. You can easily learn from the scripts, reverse engineer the build process and later modify them to include more stuff (I encourage you to do so). After you learn the basics, you will have all the necessary tools and skills to create your own fully functional Linux based operating system which you have  built entirely from scratch.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            You are encouraged to read the <a href="#tutorial" onClick={() => {loadTab("#tutorial"); return false;}}>tutorial</a> which explains the MLL build process. The same tutorial, along with all MLL source code, can be found in the ISO image structure in the <strong>/minimal/rootfs/usr/src</strong> directory.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="twelve columns">
            Below you can find several screenshots from version <strong>{MLL_VERSION}</strong> which demonstrate what the MLL environment looks like.
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="four columns">
            <a href="assets/img/mll_01.png" target="_blank" title="Minimal Linux Live - screenshot 1">
              <img alt="Minimal Linux Live" id="screenshot1" width="100%" height="100%" src="assets/img/mll_01.png" />
            </a>
          </div>
          <div className="four columns">
            <a href="assets/img/mll_02.png" target="_blank" title="Minimal Linux Live - screenshot 2">
              <img alt="Minimal Linux Live" id="screenshot2" width="100%" height="100%" src="assets/img/mll_02.png" />
            </a>
          </div>
          <div className="four columns">
            <a href="assets/img/mll_03.png" target="_blank" title="Minimal Linux Live - screenshot 3">
              <img alt="Minimal Linux Live" id="screenshot3" width="100%" height="100%" src="assets/img/mll_03.png" />
            </a>
          </div>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
        <div className="row">
          <div className="four columns">
            <a href="assets/img/mll_04.png" target="_blank" title="Minimal Linux Live - screenshot 4">
              <img alt="Minimal Linux Live" id="screenshot4" width="100%" height="100%" src="assets/img/mll_04.png" />
            </a>
          </div>
          <div className="four columns">
            <a href="assets/img/mll_05.png" target="_blank" title="Minimal Linux Live - screenshot 5">
              <img alt="Minimal Linux Live" id="screenshot5" width="100%" height="100%" src="assets/img/mll_05.png" />
            </a>
          </div>
          <div className="four columns">
            <a href="assets/img/mll_06.png" target="_blank" title="Minimal Linux Live - screenshot 6">
              <img alt="Minimal Linux Live" id="screenshot6" width="100%" height="100%" src="assets/img/mll_06.png" />
            </a>
          </div>
        </div>
      </div>
    );
  }
}

export default Home;
