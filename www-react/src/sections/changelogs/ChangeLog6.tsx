import React, {Component} from 'react';
import LogAction from './LogAction';

class ChangeLog6 extends Component {
  render() {
    return (
      <React.Fragment>
        <LogAction entry={6} version="20-Jan-2017" expanded={false} />
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
      </React.Fragment>
    );
  }
}

export default ChangeLog6;
