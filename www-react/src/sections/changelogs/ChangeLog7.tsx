import React, {Component} from 'react';
import LogAction from './LogAction';

class ChangeLog7 extends Component {
  render() {
    return (
      <React.Fragment>
        <LogAction entry={7} version="28-Jan-2018" expanded={false} />
        <div id="text7" style={{display: "none"}}>
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
      </React.Fragment>
    );
  }
}

export default ChangeLog7;
