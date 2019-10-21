import React from 'react';
import {Component} from 'react';

import {logSwap, loadTab} from '../ts/main';

class ChangeLog extends Component {
  render() {
    return (
      <div id="item2" style={{display: "none"}}>
        <div className="row">
          <div className="twelve columns">
            <h4>Change Log</h4>
          </div>
        </div>
        <div className="row">    
          <div className="twelve columns">
            <div id="show7" style={{display: "none"}}>
              <strong>28-Jan-2018</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(7, true); return false;}}>show</a>
            </div>
            <div id="hide7" style={{display: "block"}}>
              <strong>28-Jan-2018</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(7, false); return false;}}>hide</a>
            </div>
            <div id="text7" style={{display: "block"}}>
              <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
              <ul>
                <li>
                  <strong>Updated software base</strong> - Minimal Linux Live (MLL) is based on Linux kernel 4.14.12, GNU C library 2.26 and Busybox 1.27.2. The generated ISO image file is 9MB and requires 256MB RAM in order to run properly.
                </li>
                <li>
                  30+ available <a target="_blank" rel="noopener noreferrer" href="https://github.com/ivandavidov/minimal/blob/master/src/README#L19">overlay bundles</a> with new additions like nano, vim, Cloud Foundry and BOSH clients, Open JDK, keyboard layouts, the game 2048 and many more. 
                </li>
                <li>
                  <strong>Bundle dependency management</strong> - good example is the Open JDK overlay bundle which depends on GLIBC and ZLIB. From end user perspective all you need to do is to add Open JDK to the list of overlay bundles that you want to include in MLL and the overlay build system will automatically prepare the overlay bundles required by Open JDK.
                </li>
                <li>
                  <strong>Separate configuration file for overlay bundles</strong> - all bundle specific configuration can be externalized in separate configuration file. This makes the main configuration file much smaller and easier to maintain. The entries in the bundle configuration file take precedence over the entries in the main configuration file.
                </li>
                <li>
                  <strong>Autorun functionality in the initramfs</strong> - all scripts in <code>/etc/autorun</code> are automatically executed on boot. This feature is used by some overlay bundles which require some functionality to be triggered on boot (e.g. the DHCP overlay bundle).
                </li>
                <li>
                  <strong>DHCP functionality as separate overlay bundle</strong> - the DHCP client functionality is triggered automatically on boot. The default DNS resolver is changed to <a target="_blank" rel="noopener noreferrer" href="http://quad9.net">Quad 9</a>. The public Google DNS resolvers are still present and used as backup. This overlay bundle is enabled by default.
                </li>
                <li>
                  <strong>Source code as separate overlay bundle</strong> - previous MLL versions used to include the MLL source code both in the initramfs structure and in the ISO image structure. Now the same source code is included as overlay bundle and can be found either in <code>/minimal/rootfs/usr/src</code> (ISO image) or in <code>/usr/src</code> (initramfs). This overlay bundle is enabled by default.
                </li>
                <li>
                  <strong>Docker compatible image</strong> - The MLL build process generates Docker compatible image <code>mll_image.tgz</code> which contains all available software from the MLL ISO image. This image can be imported and used in Docker or in any other container system which supports raw filesystem import. You could add your own software in MLL (e.g. simple HTTP server like 'nweb' which is provided as overlay bundle) and then use Docker instead of running the entire OS.
                </li>
                <li>
                  <strong>Overlay bundles can be merged in the initramfs</strong> - all overlay bundles can be "merged" with the initramfs structure. In this way all overlay bundle functionality is available on boot, ragrdless of the limited hardware detection support. This makes the initramfs structure significantly larger and as consequence you need more RAM since all overlay bundles are available as part of the initramfs.
                </li>
                <li>
                  <strong>Structural improvements</strong> - the overlay build system is completely separated from the main build system. The main shell scripts are more, but each individual shell script has simpler structure. Both the main build process and the overlay build system rely on "common" logic from separate shell script, which is included in all other relevant shell scripts. The "sparse" image file size has been increased to 3MB in order to handle the size of the default overlay bundles.
                </li>
                <li>
                  <strong>UEFI and BIOS support</strong> - MLL provides different build flavors, depending on the targeted firmware compatibility. The "bios" build flavor targets legacy BIOS systems and uses precompiled boot loaders provided by the <a target="_blank" rel="noopener noreferrer" href="http://syslinux.org">syslinux</a> project. The "uefi" build flavor targets modern UEFI systems and uses precompiled boot loaders provided by the <a target="_blank" rel="noopener noreferrer" href="http://github.com/ivandavidov/systemd-boot">systemd-boot</a> project. You can also generate "mixed" ISO image which can boot on both legacy BIOS and modern UEFI systems. The default build flavor is "bios".
                </li>
                <li>
                  <strong>ISO image restructuring</strong> - the main ISO image directory no longer contains individual files. One exception is "minimal.img" if the "sparse" overlay location has been enabled in the main configuration file. This makes the ISO image structure easier for future maintenance.
                </li>
                <li>
                  <strong>Custom MLL boot logo</strong> - the MLL boot logo is provided as separate overlay bundle. However, it is different from the other overlay bundles because it doesn't add overlay functionality. Instead, this overlay bundle "injects" the custom MLL boot logo in the kernel source tree and triggers small kernel rebuild. This overlay bundle is enabled by default.
                </li>
              </ul>
            </div>
            <div style={{fontSize: 10 + "%"}}>&nbsp;</div>        
            <div id="show6" style={{display: "block"}}>
              <strong>20-Jan-2017</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(6, true); return false;}}>show</a>
            </div>
            <div id="hide6" style={{display: "none"}}>
              <strong>20-Jan-2017</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(6, false); return false;}}>hide</a>
            </div>
            <div id="text6" style={{display: "none"}}>
              <ul>
                <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
                <li>
                  <strong>Updated software base</strong> - Minimal Linux Live (MLL) is based on Linux kernel 4.4.44, GNU C library 2.24 and Busybox 1.26.2. The generated ISO image file is 7MB and requires 256MB RAM in order to run properly.
                </li>
                <li>
                  <strong>UEFI support</strong> - MLL provides experimental UEFI support and the live CD can boot on UEFI based systems which provide UEFI shell.
                </li>
                <li>
                  <strong>Additional software via overlay bundles</strong> - the MLL architecture has been significantly improved and you can add more software via the so-called "overlay bundles". This feature has been documented in the ".config" file, as well as in the internal README documents. By default these overlay bundles are not part of the build process because they rely on the host machine environment and they may or may not be built correctly on your particular machine. Nevertheless, turning this feature on is very simple and I encourage you to experiment with it.
                </li>
                <li>
                  <strong>Persistence support</strong> - MLL has the ability to transparently persist the changes that have been made during the live session and these changes will be preserved between reboots. You can use this feature to add your own software in MLL, change the MLL file/directory structure or simply to persist whatever changes you've made during the live session. This feature has been documented in the ".config" file, the internal README documents and in the internal shell script comments.
                </li>
                <li>
                  <strong>Smaller ISO image size</strong> - one of the goals for this release was to minimize the ISO image size and make it as small as possible. The final result is ISO image, which is now less than 7MB when MLL has been generated with the default configuration options. However, the smaller ISO image size comes at cost and you need more RAM (256MB) in order to boot MLL properly.
                </li>
                <li>
                  <strong>GCC optimization flags</strong> - the MLL configuration allows you to provide your own GCC flags which are used when the software pieces are compiled. These GCC optimization flags are not magical and they may or may not work fine on your particular host machine. They work fine on Ubuntu/Mint host machines and should work fine on other Debian based host machines. You can disable this feature if you get weird compilation issues on your host machine during the build process.
                </li>
                <li>
                  <strong>Syslinux as download dependency</strong> - the "Syslinux" build dependency is no longer mandatory prerequisite requirement because the Syslinux source package is downloaded automatically as part of the build process.
                </li>
                <li>
                  <strong>Graphical boot mode with configurable screen resolution</strong> - MLL can boot in graphical mode. At the beginning of the boot process you are presented with option to choose the screen resolution. This feature currently works only in BIOS boot mode.
                </li>
                <li>
                  <strong>Rescue shells during boot</strong> - the MLL boot process has been enhanced and you can temporarily "exit" the boot process in the so-called "rescue shell". In fact, this is a normal shell which runs with PID 1. This is useful if you want to have interactive environment (i.e. shell) while you are still in early "pre-init" boot stage.
                </li>
                <li>
                  <strong>Initial RAM filesystem in separate directory structure</strong> - the initramfs structure has been externalized in separate directory. This makes it easier to modify the initramfs environment.
                </li>
                <li>
                  <strong>Optional use of preconfigured Linux kernel and Busybox</strong> - you can provide custom Linux kernel and Busybox configurations. This is useful if you want to build MLL with many non-default options or if you want to distribute your own version of MLL.
                </li>
                <li>
                  <strong>Optional use of already downloaded sources</strong> - this feature does what it says: if you turn it on, you don't need internet connection and you will be using already downloaded sources. This is useful if you don't want to use internet connection or if you want to distribute your own version of MLL which includes specific sources.
                </li>
                <li>
                  <strong>Many more internal improvements</strong> - script enhancements, improved comments and better documentation, the newly introduced overlay build subsystem, additional helpful scripts, etc. Check the ".config" file and the internal README documents for more details.
                </li>
              </ul>
            </div>
            <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
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
            <div id="show4" style={{display: "block"}}>
              <strong>14-Sep-2015</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(4, true); return false;}}>show</a>
            </div>
            <div id="hide4" style={{display: "none"}}>
              <strong>14-Sep-2015</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(4, false); return false;}}>hide</a>
            </div>
            <div id="text4" style={{display: "none"}}>
              <ul>
                <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
                <li>
                  <strong>Minimal Linux Live</strong> is now based on <strong>Linux kernel 4.1.6</strong> and <strong>Busybox 1.23.2</strong>.
                </li>
                <li>
                  The build process is now parallelized between all available CPU cores, therefore the overall build time is significantly reduced.
                </li>
                <li>
                  There is DHCP network support for all network devices detected by the kernel. Note that DNS is not working due to well-known static linking issues caused by glibc.
                </li>
                <li>
                  The ISO image is now generated by using <strong>genisoimage</strong>. This fixes some issues with Debian and Arch based host operating systems.
                </li>
                <li>
                  In addition to the above changes, if you <a href="#download" onClick={() => {loadTab("#download"); return false;}}>download</a> the current stable build scripts, you will notice a folder named <strong>experimental</strong>. This folder contains some interesting scripts which produce ISO based on Linux kernel and <a href="http://landley.net/toybox" target="_blank" rel="noopener noreferrer">ToyBox</a> instead of Busybox. Please have in mind that this is work in progress and these scripts may not work on your host OS.
                </li>
              </ul>
            </div>
            <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
            <div id="show3" style={{display: "block"}}>
              <strong>07-Feb-2015</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(3, true); return false;}}>show</a>
            </div>
            <div id="hide3" style={{display: "none"}}>
              <strong>07-Feb-2015</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(3, false); return false;}}>hide</a>
            </div>
            <div id="text3" style={{display: "none"}}>
              <ul>
                <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
                <li>
                  <strong>Minimal Linux Live</strong> is now based on <strong>Linux kernel 3.18.6</strong> and <strong>Busybox 1.23.1</strong>.
                </li>
              </ul>
            </div>
            <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
            <div id="show2" style={{display: "block"}}>
              <strong>25-Aug-2014</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(2, true); return false;}}>show</a>
            </div>
            <div id="hide2" style={{display: "none"}}>
              <strong>25-Aug-2014</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(2, false); return false;}}>hide</a>
            </div>
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
            <div id="show1" style={{display: "block"}}>
              <strong>28-Jul-2014</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(1, true); return false;}}>show</a>
            </div>
            <div id="hide1" style={{display: "none"}}>
              <strong>28-Jul-2014</strong>&nbsp;
              <a href="#changes" onClick={() => {logSwap(1, false); return false;}}>hide</a>
            </div>
            <div id="text1" style={{display: "none"}}>
              <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
              <ul>
                <li>
                  <strong>Minimal Linux Live</strong> is now based on <strong>Linux kernel 3.15.6</strong> and <strong>Busybox 1.22.1</strong>.
                </li>
                <li>
                  The boot process is based on simple <strong>/init</strong> script.
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default ChangeLog;
