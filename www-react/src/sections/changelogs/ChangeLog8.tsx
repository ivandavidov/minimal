import React, {Component} from 'react';
import LogAction from './LogAction';

class ChangeLog8 extends Component {
  render() {
    return (
      <React.Fragment>
        <LogAction entry={8} version="15-Dec-2019" expanded={true} />
        <div id="text8" style={{display: "block"}}>
          <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
          <ul>
            <li>
              <strong>Updated software base</strong> - Minimal Linux Live (MLL) is based on Linux kernel 5.4.3, GNU C library 2.30 and Busybox 1.31.1. The generated ISO image file is 10MB (x86_64) and requires 256MB RAM in order to run properly.
            </li>
            <li>
              <strong>CloudFlare DNS resolvers</strong> - by default Minimal Linux Live has 3 DNS resolvers: Gogle Public DNS (8.8.8.8), Quad4 (4.4.4.4) and CloudFlare DNS (1.1.1.1).
            </li>
            <li>
              <strong>GraalVM overlay bundle</strong> - this overlay bundle provides JDK, Python, Ruby and Node.JS/JavaScript.
            </li>
            <li>
              <strong>Adopt OpenJDK overlay bundle</strong> - this overlay bundle provides JDK from the AdoptOpenJDK project.
            </li>
            <li>
              <strong>Zulu JDK overlay bundle</strong> - this overlay bundle provides JDK from Azul Systems.
            </li>
            <li>
              <strong>GoLang overlay bundle</strong> - this overlay bundle provides Go (programming language) in MLL.
            </li>
            <li>
              <strong>Python overlay bundle</strong> - this overlay bundle provides Python (programming language) in MLL.
            </li>
            <li>
              <strong>Install software on demand</strong> - you can use <code>static-get</code> to search and install software directly in MLL. If you use persistent storage, your installed software will be persisted after reboot.
            </li>
            <li>
              <strong>Other overlay bundle changes</strong> - you can build all overlay bundles with special meta-bundle, vitetris has been added (tetris game), java bundle (Oracle JDK) has been deprecated and removed, util_linux no longer requires root privileges to build.
            </li>
            <li>
              <strong>Hello MLL overlay bundle</strong> - the bundle <code>mll_hello</code> provides detailed explanation on how to write your own overlay bundle. This particular overlay bundle compiles simple C program and installs it in MLL as executable command.
            </li>
            <li>
              <strong>Pure QEMU console mode</strong> - this allows you to run MLL entirely in your console. This is useful if you don't work with graphical UI or if you work remotely, e.g. via SSH.
            </li>
          </ul>
        </div>
        <div style={{fontSize: 10 + "%"}}>&nbsp;</div>
      </React.Fragment>
    );
  }
}

export default ChangeLog8;
