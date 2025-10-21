(function(){
  const entries = [];
  const lastValueEl = document.getElementById('lastValue');
  const entriesEl = document.getElementById('entries');
  const toast = document.getElementById('toast');

  const sheet = document.getElementById('sheet');
  const sheetBackdrop = document.getElementById('sheetBackdrop');
  const slider = document.getElementById('slider');
  const note = document.getElementById('note');
  const sheetValue = document.getElementById('sheetValue');
  const fineBtn = document.getElementById('fineBtn');
  const saveBtn = document.getElementById('saveBtn');
  const cancelBtn = document.getElementById('cancelBtn');

  function vibrate(ms=10){ if(navigator.vibrate) navigator.vibrate(ms); }

  function fmtDate(d){ return d.toLocaleString(); }

  function updateLast(){
    if(entries.length){
      const last = entries[entries.length-1];
      lastValueEl.textContent = `Последнее: ${last.value}/10`;
    } else {
      lastValueEl.textContent = 'Последнее: —';
    }
  }

  function renderList(){
    entriesEl.innerHTML = entries.slice().reverse().map(e => (
      `<div class="entry">
        <div><span style="font-size:20px;margin-right:8px">${emoji(e.value)}</span><strong>${e.value}/10</strong></div>
        ${e.note ? `<div style="margin-top:6px">${escapeHtml(e.note)}</div>` : ''}
        <div class="date">${fmtDate(e.date)}</div>
      </div>`
    )).join('');
  }

  function emoji(v){
    if(v < 3) return '😞';
    if(v < 5) return '😐';
    if(v < 8) return '🙂';
    return '😄';
  }

  function escapeHtml(s){
    return s.replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;','\'':'&#39;'}[c]));
  }

  function addEntry(value, note){
    entries.push({ id: crypto.randomUUID(), date: new Date(), value, note: note || null });
    updateLast();
    renderList();
  }

  function showToast(msg){
    toast.textContent = msg; toast.classList.add('show');
    setTimeout(()=> toast.classList.remove('show'), 1200);
  }

  function openSheet(){
    sheet.classList.add('open'); sheetBackdrop.classList.add('open');
    slider.value = 5; note.value=''; updateSheetValue();
  }
  function closeSheet(){
    sheet.classList.remove('open'); sheetBackdrop.classList.remove('open');
  }

  function updateSheetValue(){ sheetValue.textContent = `${slider.value} / 10`; }

  // Events
  document.querySelectorAll('.emoji').forEach(btn => {
    btn.addEventListener('click', e => {
      if(btn.id === 'fineBtn'){ openSheet(); return; }
      const val = parseInt(btn.dataset.value, 10);
      addEntry(val);
      showToast('Сохранено');
      vibrate(20);
    });
  });

  slider.addEventListener('input', () => { updateSheetValue(); vibrate(10); });
  saveBtn.addEventListener('click', () => {
    addEntry(parseInt(slider.value,10), note.value.trim());
    showToast('Сохранено');
    vibrate(30);
    closeSheet();
  });
  cancelBtn.addEventListener('click', () => { closeSheet(); });
  sheetBackdrop.addEventListener('click', () => { closeSheet(); });

  // init
  updateLast();
})();
