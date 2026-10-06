// Kopiert die Kontaktadresse in die Zwischenablage. Externe Datei, damit die CSP ohne 'unsafe-inline' für Skripte auskommt.
(function () {
  var link = document.getElementById('mail-link');
  var button = document.getElementById('mail-copy');
  if (!link || !button) return;
  var address = (link.textContent || '').trim();
  function reset() { setTimeout(function () { button.textContent = 'Adresse kopieren'; }, 2500); }
  button.addEventListener('click', function () {
    var select = function () {
      var range = document.createRange();
      range.selectNodeContents(link);
      var sel = window.getSelection();
      if (sel) { sel.removeAllRanges(); sel.addRange(range); }
      button.textContent = 'Markiert, bitte kopieren';
      reset();
    };
    if (navigator.clipboard && navigator.clipboard.writeText) {
      navigator.clipboard.writeText(address).then(function () { button.textContent = 'Kopiert'; reset(); }, select);
    } else { select(); }
  });
})();
