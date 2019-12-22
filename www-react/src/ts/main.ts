const logs: number = 8
const menus: number = 6;

export const MLL_VERSION: string = '15-Dec-2019';
export const COPYRIGHT: string = '2014 - 2020';

export function menuSwap(itemIndex: number): void {
  for(let i: number = 1; i <= menus; i++) {
    let strItem: string = "item" + i;
    let objItem: HTMLElement | null = document.getElementById(strItem);
    let display: string = (i === itemIndex) ? "block" : "none";
    
    if(objItem) {
      objItem.style.display = display;
    } else {
      throw new Error("menuSwap: objItem is null.");
    }
  }
}

export function logSwap(itemIndex: number, show: boolean): void {
  for(let i: number = 1; i <= logs; i++) {
    let textObj: HTMLElement | null = document.getElementById("text" + i);
    if(!textObj) {
      throw new Error("logSwap: textObj is null");
    }

    if(i === itemIndex) {
      if(show === true) {
        textObj.style.display = "block";
      } else {
        textObj.style.display = "none";
      }
    }
  }
}

export function defaultTab(item: string): void {
  let hrefPart: string = document.location.href.split('#')[1];

  if(hrefPart === undefined) {
    hrefPart = item;
  }

  loadTab('#' + hrefPart);
}

export function loadTab(hrefPart: string): void {
  document.location.href = hrefPart;
  loadUrl();
}

export function loadUrl(): void {
  let hrefPart: string = document.location.href.split('#')[1];
  switch(hrefPart) {
    case 'home' : {
      menuSwap(1);
      break;
    }
    case 'changes' : {
      menuSwap(2);
      break;
    }
    case 'about' : {
      menuSwap(3);
      break;
    }
    case 'tutorial' : {
      menuSwap(4);
      break;
    }
    case 'emulator' : {
      menuSwap(5);
      break;
    }
    case 'download' : {
      menuSwap(6);
      break;
    }
    default: {
      document.location.href='#home';
      menuSwap(1);
    }
  }
}

export function pageLoaded(): void {
  defaultTab('home');
  thankYou();
}

export function hideEmulatorMenu(): void {
  if(!document) {
    throw new Error("thankYou: document is null.");
  }
  
  let hm5: HTMLElement | null = document.getElementById('hm5');
  if(!hm5) {
    throw new Error("thankYou: hm5 is null.");
  }
  hm5.style.display="none";
}

export function thankYou(): void {
  let footer: HTMLElement | null = document.getElementById("footer");
  if(!footer) {
      throw new Error("thankYou: footer is null.");
  }

  let footerDiv: HTMLElement | null = footer.getElementsByTagName("div")[0];
  if(!footerDiv) {
      throw new Error("thankYou: footerDiv is null.");
  }

  let html: string = footerDiv.innerHTML;

  let sepa: string = ' <span class="separator">|</span> ';
  let afterSepa: string = '<a target="_blank" href="http://{1}">{2}</a>'

  let hostname: string = window.location.hostname;

  switch(hostname) {
    case 'minimal.idzona.com' : {
      html += sepa;
      html += afterSepa.replace("{1}", 'microweber.com').replace("{2}", 'Microweber CMS');

      footerDiv.innerHTML = html;

      break;
    }
    case 'skamilinux.hu' : {
      html += sepa;
      html += 'Hosted by <a target="_blank" href="http://skamilinux.hu">skamilinux.hu</a> - thank you!';

      footerDiv.innerHTML = html;

      break;
    }
    case 'minimal.linux-bg.org' : {
      html += sepa;
      html += 'Hosted by <a target="_blank" href="http://linux-bg.org">linux-bg.org</a> - thank you!';

      footerDiv.innerHTML = html;

      break;
    }
    case 'ivandavidov.github.io' : {
      hideEmulatorMenu();

      html += sepa;
      html += 'Development website - may not be fully functional.';

      footerDiv.innerHTML = html;

      break;
    }
    case 'linux.idzona.com' : {
      hideEmulatorMenu();

      html += sepa;
      html += 'Development website - may not be fully functional.';

      footerDiv.innerHTML = html;

      break;
    }
    default: {
      if(hostname !== "") {
        html += sepa;
        html += afterSepa.replace("{1}", hostname + ":"+ window.location.port + window.location.pathname).replace("{2}", hostname);

        footerDiv.innerHTML = html;
      }
    }
  }
}
