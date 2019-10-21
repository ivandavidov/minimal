export function menuSwap(itemIndex) {
  for(let i = 1; i <= 6; i++) {
    let strItem = "item" + i;
    let objItem = document.getElementById(strItem);
    let display = (i === itemIndex) ? "block" : "none";
    objItem.style.display = display;
  }
}

export function logSwap(itemIndex, show) {
  for(let i = 1; i <= 7; i++) {
    let showObj = document.getElementById("show" + i);
    let hideObj = document.getElementById("hide" + i);
    let textObj = document.getElementById("text" + i);

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

export function defaultTab(item) {
  let hrefPart = document.location.href.split('#')[1];

  if(hrefPart === undefined) {
    hrefPart = item;
  }

  loadTab('#' + hrefPart);
}

export function loadTab(hrefPart) {
  document.location.href=hrefPart;
  loadUrl();
}

export function loadUrl() {
  let hrefPart = document.location.href.split('#')[1];
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
  let footer = document.getElementById("footer");
  let footerDiv = footer.getElementsByTagName("div")[0];
  let html = footerDiv.innerHTML;

  let sepa = ' <span class="separator">|</span> ';
  let afterSepa = '<a target="_blank" href="http://{1}">{2}</a>'

  let hostname = window.location.hostname;

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
      document.getElementById('hm5').style.display="none";

      document.getElementById('dl2').style.display="none";
      document.getElementById('dl5').style.display="none";
      document.getElementById('dl6').style.display="none";

      document.getElementById('gh1').style.display="none";

      html += sepa;
      html += 'Development website - may not be fully functional.';

      footerDiv.innerHTML = html;

      break;
    }
    case 'linux.idzona.com' : {
      document.getElementById('hm5').style.display="none";

      document.getElementById('dl2').style.display="none";
      document.getElementById('dl5').style.display="none";
      document.getElementById('dl6').style.display="none";

      document.getElementById('gh1').style.display="none";

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
