export function menuSwap(itemIndex: number) {
  for(let i: number = 1; i <= 6; i++) {
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

export function logSwap(itemIndex: number, show: boolean) {
  for(let i: number = 1; i <= 8; i++) {
    let showObj: HTMLElement | null = document.getElementById("show" + i);
    if(!showObj) {
      throw new Error("logSwap: showObj is null");
    }
    
    let hideObj: HTMLElement | null = document.getElementById("hide" + i);
    if(!hideObj) {
      throw new Error("logSwap: hideObj is null");
    }

    let textObj: HTMLElement | null = document.getElementById("text" + i);
    if(!textObj) {
      throw new Error("logSwap: textObj is null");
    }

    if(i === itemIndex) {
      if(show === true) {
        showObj.style.display = "none";
        hideObj.style.display = "block";
        textObj.style.display = "block";
      } else {
        showObj.style.display = "block";
        hideObj.style.display = "none";
        textObj.style.display = "none";
      }
    } else if(show === true) {
      showObj.style.display = "block";
      hideObj.style.display = "none";
      textObj.style.display = "none";
    }
  }
}

export function defaultTab(item: string) {
  let hrefPart: string = document.location.href.split('#')[1];

  if(hrefPart === undefined) {
    hrefPart = item;
  }

  loadTab('#' + hrefPart);
}

export function loadTab(hrefPart: string) {
  document.location.href = hrefPart;
  loadUrl();
}

export function loadUrl() {
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

export function pageLoaded() {
  defaultTab('home');
  thankYou();
}

export function thankYou() {
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
      if(!document) {
        throw new Error("thankYou: document is null.");
      }
      
      let hm5: HTMLElement | null = document.getElementById('hm5');
      if(!hm5) {
        throw new Error("thankYou: hm5 is null.");
      }
      hm5.style.display="none";

      let d12: HTMLElement | null = document.getElementById('dl2');
      if(!d12) {
        throw new Error("thankYou: d12 is null.");
      }
      d12.style.display="none";
      
      let d15: HTMLElement | null = document.getElementById('dl5');
      if(!d15) {
        throw new Error("thankYou: d15 is null.");
      }
      d15.style.display="none";
      
      let d16: HTMLElement | null = document.getElementById('dl6');
      if(!d16) {
        throw new Error("thankYou: d16 is null.");
      }
      d16.style.display="none";

      let gh1: HTMLElement | null = document.getElementById('gh1');
      if(!gh1) {
        throw new Error("thankYou: gh1 is null.");
      }
      gh1.style.display="none";

      html += sepa;
      html += 'Development website - may not be fully functional.';

      footerDiv.innerHTML = html;

      break;
    }
    case 'linux.idzona.com' : {
      if(!document) {
        throw new Error("thankYou: document is null.");
      }

      let hm5: HTMLElement | null = document.getElementById('hm5');
      if(!hm5) {
        throw new Error("thankYou: hm5 is null.");
      }
      hm5.style.display="none";

      let d12: HTMLElement | null = document.getElementById('dl2');
      if(!d12) {
        throw new Error("thankYou: d12 is null.");
      }
      d12.style.display="none";
      
      let d15: HTMLElement | null = document.getElementById('dl5');
      if(!d15) {
        throw new Error("thankYou: d15 is null.");
      }
      d15.style.display="none";
      
      let d16: HTMLElement | null = document.getElementById('dl6');
      if(!d16) {
        throw new Error("thankYou: d16 is null.");
      }
      d16.style.display="none";

      let gh1: HTMLElement | null = document.getElementById('gh1');
      if(!gh1) {
        throw new Error("thankYou: gh1 is null.");
      }
      gh1.style.display="none";

      html += sepa;
      html += 'Development website - may not be fully functional.';

      footerDiv.innerHTML = html;

      break;
    }
    default: {
      if(hostname !== "") {
        html += sepa;
        html += afterSepa.replace("{1}", hostname).replace("{2}", hostname);

        footerDiv.innerHTML = html;
      }
    }
  }
}
