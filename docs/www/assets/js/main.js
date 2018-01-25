function menuSwap(itemIndex) {
  for(var i = 1; i <= 6; i++) {
    var strItem = "item" + i;
    var objItem = document.getElementById(strItem);
    objItem.style.display = (i == itemIndex) ? "block" : "none";
  }
}

function logSwap(itemIndex, show) {
  for(var i = 1; i <= 7; i++) {
    var showObj = document.getElementById("show" + i);
    var hideObj = document.getElementById("hide" + i);
    var textObj = document.getElementById("text" + i);

    if(i == itemIndex) {
      if(show == true) {
        showObj.style.display = "none";
        hideObj.style.display = "block";
        textObj.style.display = "block";
      } else {
        showObj.style.display = "block";
        hideObj.style.display = "none";
        textObj.style.display = "none";
      }
    } else if(show == true) {
      showObj.style.display = "block";
      hideObj.style.display = "none";
      textObj.style.display = "none";
    }
  }
}

function defaultTab(item) {
  var hrefPart = document.location.href.split('#')[1];

  if(hrefPart == undefined) {
    hrefPart = item;
  }

  loadTab('#' + hrefPart);
}

function loadTab(hrefPart) {
  document.location.href=hrefPart;
  loadUrl();
}

function loadUrl() {
  var hrefPart = document.location.href.split('#')[1];
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

function pageLoaded() {
  defaultTab('home');
  thankYou();
}

function thankYou() {
  var footer = document.getElementById("footer");
  var footerDiv = footer.getElementsByTagName("div")[0];
  var html = footerDiv.innerHTML;

  var sepa = ' <span class="separator">|</span> ';
  var afterSepa = '<a target="_blank" href="http://{1}">{2}</a>'

  var hostname = window.location.hostname;

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
      if(hostname != "") {
        html += sepa;
        html += afterSepa.replace("{1}", hostname).replace("{2}", hostname);

        footerDiv.innerHTML = html;
      }
    }
  }
}
