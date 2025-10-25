(function(){
  // State and elements
  const STATE = { entries: [], lang: 'ru', chart: null };
  const KEYS = { entries: 'moodEntriesV1', lang: 'lang', pin: 'pin', unlocked: 'pinUnlocked' };

  const lastValueEl = document.getElementById('lastValue');
  const entriesEl = document.getElementById('entries');
  const toast = document.getElementById('toast');
  const chartCanvas = document.getElementById('moodChart');

  const navHome = document.getElementById('navHome');
  const navHistory = document.getElementById('navHistory');
  const navChart = document.getElementById('navChart');
  const navSettings = document.getElementById('navSettings');
  const navTips = document.getElementById('navTips');
  const chartSection = document.getElementById('chartSection');
  const settingsPanel = document.getElementById('settingsPanel');
  const homeSection = document.getElementById('homeSection');
  const tipsSection = document.getElementById('tipsSection');
  const tipsList = document.getElementById('tipsList');
  const undoBar = document.getElementById('undoBar');
  const undoBtn = document.getElementById('undoBtn');
  const statAvg = document.getElementById('statAvg');
  const statMed = document.getElementById('statMed');
  const statMin = document.getElementById('statMin');
  const statMax = document.getElementById('statMax');
  const heatmapEl = document.getElementById('heatmap');
  const rangeDayBtn = document.getElementById('rangeDay');
  const rangeWeekBtn = document.getElementById('rangeWeek');
  const rangeMonthBtn = document.getElementById('rangeMonth');

  const sheet = document.getElementById('sheet');
  const sheetBackdrop = document.getElementById('sheetBackdrop');
  const slider = document.getElementById('slider');
  const note = document.getElementById('note');
  const sheetValue = document.getElementById('sheetValue');
  const fineBtn = document.getElementById('fineBtn');
  const saveBtn = document.getElementById('saveBtn');
  const cancelBtn = document.getElementById('cancelBtn');

  const langSelect = document.getElementById('langSelect');
  const exportJsonBtn = document.getElementById('exportJsonBtn');
  const exportCsvBtn = document.getElementById('exportCsvBtn');
  const enableNotifsBtn = document.getElementById('enableNotifsBtn');
  const testNotifBtn = document.getElementById('testNotifBtn');

  const lockOverlay = document.getElementById('lockOverlay');
  const unlockPin = document.getElementById('unlockPin');
  const unlockBtn = document.getElementById('unlockBtn');
  const lockHint = document.getElementById('lockHint');
  const forgotPinBtn = document.getElementById('forgotPinBtn');
  const pinInput = document.getElementById('pinInput');
  const setPinBtn = document.getElementById('setPinBtn');
  const clearPinBtn = document.getElementById('clearPinBtn');

  const T = {
    ru: {
      lastNone: 'Последнее: —',
      last: v => `Последнее: ${v}/10`,
      saved: 'Сохранено',
      precise: 'Точно',
      nothing: 'Ничего',
      save: 'Сохранить',
    history: 'История',
    chart: 'График',
    settings: 'Настройки',
    tips: 'Советы',
    home: 'Домой',
      notePh: 'Коротко: что произошло?',
      allow: 'Разрешить',
      test10s: 'Тест через 10с',
      pinNew: 'Новый PIN',
      pinSet: 'PIN установлен',
      pinCleared: 'PIN сброшен',
      pinEnter: 'Введите PIN',
      unlock: 'Разблокировать',
      pinWrong: 'Неверный PIN',
      notifOk: 'Уведомления разрешены',
      notifNo: 'Уведомления не поддерживаются',
      today: 'Сегодняшний срез',
      noData: 'Нет данных. Сначала добавьте запись.',
      mini: 'Мини-фразы',
      trendUp: 'Поддерживающий режим: зафиксируйте триггеры (музыка, спорт, общение).',
      trendDown: 'Бережный режим: сон, вода, короткие прогулки, тёплые контакты.',
      trendFlat: 'Держим стабильность: поддерживайте рабочие ритуалы.',
      undo: 'Отменить',
      added: 'Запись добавлена',
      day: 'День', week: 'Неделя', month: 'Месяц',
      avg: 'Среднее', median: 'Медиана', min: 'Мин', max: 'Макс',
    },
    en: {
      lastNone: 'Last: —',
      last: v => `Last: ${v}/10`,
      saved: 'Saved',
      precise: 'Fine-tune',
      nothing: 'Nothing',
      save: 'Save',
    history: 'History',
    chart: 'Chart',
    settings: 'Settings',
    tips: 'Tips',
    home: 'Home',
      notePh: 'Brief note: what happened?',
      allow: 'Allow',
      test10s: 'Test in 10s',
      pinNew: 'New PIN',
      pinSet: 'PIN set',
      pinCleared: 'PIN cleared',
      pinEnter: 'Enter PIN',
      unlock: 'Unlock',
      pinWrong: 'Wrong PIN',
      notifOk: 'Notifications allowed',
      notifNo: 'Notifications not supported',
      today: 'Today snapshot',
      noData: 'No data. Add an entry first.',
      mini: 'Mini phrases',
      trendUp: 'Supportive mode: lock in triggers (music, sport, social).',
      trendDown: 'Gentle mode: sleep, water, short walks, warm contacts.',
      trendFlat: 'Keep it steady: maintain your working rituals.',
      undo: 'Undo',
      added: 'Entry added',
      day: 'Day', week: 'Week', month: 'Month',
      avg: 'Avg', median: 'Median', min: 'Min', max: 'Max',
    }
  };

  // Phrases bank (embedded, mirrors PhrasesBank.json)
  const PHRASES = {
    '0-2': [
      'Тяжёлый момент — это не навсегда.',
      'Подыши глубже, дай себе 2 минуты тишины.',
      'Напомни себе: ты уже справлялся раньше.'
    ],
    '3-4': [
      'Кажется, всё тянет вниз — сделай один маленький шаг.',
      'Стакан воды и короткая прогулка могут помочь.'
    ],
    '5': [
      'Нейтрально — тоже состояние. Что одно маленькое улучшит день?',
      'Проверь базовые потребности: сон, вода, еда.'
    ],
    '6-8': [
      'Отмечай приятные мелочи — они накапливаются.',
      'Поддержи это состояние: музыка, движение, свет.'
    ],
    '9-10': [
      'Класс! Зафиксируй, что помогло — пригодится потом.',
      'Поделись теплом с кем-то ещё — усилит эффект.'
    ]
  };

  function vibrate(ms=10){ if(navigator.vibrate) navigator.vibrate(ms); }
  function fmtDate(d){
    try { return d.toLocaleString(STATE.lang === 'ru' ? 'ru-RU' : 'en-US'); }
    catch { return d.toLocaleString(); }
  }
  function emoji(v){ return v<3?'😞': v<5?'😐': v<8?'🙂':'😄'; }
  function escapeHtml(s){ return s.replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;','\'':'&#39;'}[c])); }

  // Storage
  function loadEntries(){
    try{
      const raw = localStorage.getItem(KEYS.entries);
      if(!raw) return [];
      const arr = JSON.parse(raw);
      return arr.map(e => ({...e, date: new Date(e.date)}));
    }catch{ return []; }
  }
  function saveEntries(){
    try{
      const arr = STATE.entries.map(e => ({...e, date: e.date.toISOString()}));
      localStorage.setItem(KEYS.entries, JSON.stringify(arr));
    }catch{}
  }
  function saveLang(){ try{ localStorage.setItem(KEYS.lang, STATE.lang); }catch{} }

  // UI updates
  function updateLast(){
    if(STATE.entries.length){
      const last = STATE.entries[STATE.entries.length-1];
      lastValueEl.textContent = T[STATE.lang].last(last.value);
    } else {
      lastValueEl.textContent = T[STATE.lang].lastNone;
    }
  }
  function renderList(){
    entriesEl.innerHTML = STATE.entries.slice().reverse().map(e => (
      `<div class="entry">
        <div><span style="font-size:20px;margin-right:8px">${emoji(e.value)}</span><strong>${e.value}/10</strong></div>
        ${e.note ? `<div style="margin-top:6px">${escapeHtml(e.note)}</div>` : ''}
        <div class="date">${fmtDate(e.date)}</div>
      </div>`
    )).join('');
  }
  function filteredByRange(){
    const now = new Date();
    let start = new Date(0);
    const active = document.querySelector('.seg-btn.active');
    const sel = active?.dataset.range || 'week';
    if(sel==='day') start = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    else if(sel==='week') start = new Date(now.getFullYear(), now.getMonth(), now.getDate()-6);
    else if(sel==='month') start = new Date(now.getFullYear(), now.getMonth(), now.getDate()-29);
    return STATE.entries.filter(e => e.date >= start);
  }

  function renderChart(){
    if(!chartCanvas) return;
    const data = filteredByRange();
    const labels = data.map(e => e.date.toLocaleDateString(STATE.lang==='ru'?'ru-RU':'en-US', {month:'short', day:'numeric'}));
    const values = data.map(e => e.value);
    if(STATE.chart){ STATE.chart.data.labels = labels; STATE.chart.data.datasets[0].data = values; STATE.chart.update(); return; }
    const ctx = chartCanvas.getContext('2d');
    STATE.chart = new Chart(ctx, {
      type: 'line',
      data: { labels, datasets: [{ label: 'Mood', data: values, borderColor: '#4f7cff', backgroundColor: 'rgba(79,124,255,.2)', tension:.3, pointRadius:3 }] },
      options: { scales: { y: { min:0, max:10 } }, plugins:{ legend:{ display:false } }, responsive:true, maintainAspectRatio:false }
    });
  }

  function updateStats(){
    const data = filteredByRange().map(e=>e.value).sort((a,b)=>a-b);
    if(!(statAvg && statMed && statMin && statMax)) return;
    if(!data.length){ statAvg.textContent='–'; statMed.textContent='–'; statMin.textContent='–'; statMax.textContent='–'; return; }
    const avg = (data.reduce((s,v)=>s+v,0)/data.length).toFixed(1);
    const med = data.length%2? data[(data.length-1)/2] : ((data[data.length/2-1]+data[data.length/2])/2).toFixed(1);
    statAvg.textContent = avg; statMed.textContent = String(med); statMin.textContent = Math.min(...data); statMax.textContent = Math.max(...data);
  }

  function renderHeatmap(){
    if(!heatmapEl) return;
    const now = new Date();
    const start = new Date(now.getFullYear(), now.getMonth(), now.getDate()-6);
    const grid = Array.from({length:7},()=>Array(24).fill(null).map(()=>[]));
    STATE.entries.filter(e=>e.date>=start).forEach(e=>{
      const dayIndex = Math.floor((e.date - start)/86400000);
      const hour = e.date.getHours();
      if(dayIndex>=0 && dayIndex<7) grid[dayIndex][hour].push(e.value);
    });
    heatmapEl.innerHTML = '';
    for(let r=0;r<7;r++){
      for(let c=0;c<24;c++){
        const arr = grid[r][c];
        const avg = arr.length ? arr.reduce((s,v)=>s+v,0)/arr.length : 0;
        const hue = avg/10*120;
        const opacity = arr.length ? 0.75 : 0.08;
        const cell = document.createElement('div');
        cell.className='cell';
        cell.style.backgroundColor = `hsla(${hue}, 70%, 50%, ${opacity})`;
        heatmapEl.appendChild(cell);
      }
    }
  }

  // Tips rendering
  function trend7d(){
    const now = new Date();
    const startToday = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const last7 = STATE.entries.filter(e => e.date >= new Date(startToday.getTime() - 6*86400000));
    const prev7 = STATE.entries.filter(e => e.date < new Date(startToday.getTime() - 6*86400000) && e.date >= new Date(startToday.getTime() - 13*86400000));
    const avg = arr => arr.length ? arr.reduce((s,e)=>s+e.value,0)/arr.length : NaN;
    const a = avg(last7), b = avg(prev7);
    const delta = (isNaN(a) || isNaN(b)) ? 0 : (a - b);
    if(delta >= 1) return {kind:'up', delta};
    if(delta <= -1) return {kind:'down', delta};
    return {kind:'flat', delta};
  }

  function phrasesFor(value){
    if(value<=2) return PHRASES['0-2'];
    if(value<=4) return PHRASES['3-4'];
    if(value===5) return PHRASES['5'];
    if(value<=8) return PHRASES['6-8'];
    return PHRASES['9-10'];
  }

  function renderTips(){
    if(!tipsList) return;
    if(!STATE.entries.length){ tipsList.innerHTML = `<div class="muted">${T[STATE.lang].noData}</div>`; return; }
    const latest = STATE.entries[STATE.entries.length-1].value;
    const tr = trend7d();
    const bank = phrasesFor(latest).slice().sort(()=>Math.random()-0.5).slice(0,3);
    const trendText = tr.kind==='up'?T[STATE.lang].trendUp: tr.kind==='down'?T[STATE.lang].trendDown: T[STATE.lang].trendFlat;
    tipsList.innerHTML = `
      <div class="entry"><strong>${T[STATE.lang].today}: ${latest}/10</strong></div>
      <div class="entry">${trendText}</div>
      <div class="entry"><strong>${T[STATE.lang].mini}</strong></div>
      ${bank.map(p=>`<div class="entry">${p}</div>`).join('')}
    `;
  }

  function addEntry(value, note){
    STATE.entries.push({ id: (crypto.randomUUID?crypto.randomUUID():String(Date.now())), date: new Date(), value, note: note || null });
    saveEntries();
    updateLast();
    renderList();
    renderChart();
    renderTips();
    updateStats();
    renderHeatmap();
    if(undoBar){
      undoBar.hidden = false;
      undoBar.dataset.ts = String(Date.now());
      setTimeout(()=>{
        if(undoBar.dataset.ts && Date.now() - Number(undoBar.dataset.ts) >= 10000){ undoBar.hidden = true; }
      }, 10050);
    }
  }

  function showToast(msg){
    toast.textContent = msg; toast.classList.add('show');
    setTimeout(()=> toast.classList.remove('show'), 1200);
  }

  function openSheet(){
    sheet.classList.add('open'); sheetBackdrop.classList.add('open');
    slider.value = 5; note.value=''; updateSheetValue();
  }
  function closeSheet(){ sheet.classList.remove('open'); sheetBackdrop.classList.remove('open'); }
  function updateSheetValue(){ sheetValue.textContent = `${slider.value} / 10`; }

  // i18n apply
  function applyLang(){
    if(navHome) navHome.textContent = T[STATE.lang].home;
    navHistory.textContent = T[STATE.lang].history;
    navChart.textContent = T[STATE.lang].chart;
    navSettings.textContent = T[STATE.lang].settings;
    navTips.textContent = T[STATE.lang].tips;
    document.getElementById('sheetTitle').textContent = T[STATE.lang].precise;
    note.placeholder = T[STATE.lang].notePh;
    cancelBtn.textContent = T[STATE.lang].nothing;
    saveBtn.textContent = T[STATE.lang].save;
    enableNotifsBtn.textContent = T[STATE.lang].allow;
    testNotifBtn.textContent = T[STATE.lang].test10s;
    document.querySelector('label[for="langSelect"]').textContent = 'Язык / Language';
    document.querySelector('#settingsPanel h2').textContent = T[STATE.lang].settings;
    document.querySelector('#lockOverlay h3').textContent = T[STATE.lang].pinEnter;
    unlockBtn.textContent = T[STATE.lang].unlock;
    pinInput.placeholder = T[STATE.lang].pinNew;
    document.getElementById('fineBtn').title = STATE.lang==='ru' ? 'Точно/подробно' : 'Fine / detailed';
    if(undoBtn) undoBtn.textContent = T[STATE.lang].undo;
    if(document.getElementById('rangeDay')){
      document.getElementById('rangeDay').textContent = T[STATE.lang].day;
      document.getElementById('rangeWeek').textContent = T[STATE.lang].week;
      document.getElementById('rangeMonth').textContent = T[STATE.lang].month;
      const pills = document.querySelectorAll('#statPills .pill span');
      if(pills.length>=4){ pills[0].textContent = T[STATE.lang].avg; pills[1].textContent = T[STATE.lang].median; pills[2].textContent = T[STATE.lang].min; pills[3].textContent = T[STATE.lang].max; }
    }
    updateLast();
    renderList();
    renderChart();
    renderTips();
    updateStats();
    renderHeatmap();
  }

  // Navigation
  function showSection(sec){
    if(homeSection) homeSection.hidden = (sec !== 'home');
    // Toggle each section directly
    if(entriesEl) entriesEl.hidden = (sec !== 'history');
    chartSection.hidden = (sec !== 'chart');
    settingsPanel.hidden = (sec !== 'settings');
    tipsSection.hidden = (sec !== 'tips');
    if(sec === 'chart') renderChart();
  }

  // Export
  function download(filename, text){
    const a = document.createElement('a');
    a.href = URL.createObjectURL(new Blob([text], {type:'text/plain'}));
    a.download = filename;
    a.click();
    URL.revokeObjectURL(a.href);
  }
  function exportJSON(){ download('moods.json', JSON.stringify(STATE.entries.map(e=>({...e, date:e.date.toISOString()})), null, 2)); }
  function exportCSV(){
    const lines = ['id,date,value,note'];
    for(const e of STATE.entries){
      const note = (e.note||'').replaceAll('"','""');
      lines.push(`${e.id},${e.date.toISOString()},${e.value},"${note}"`);
    }
    download('moods.csv', lines.join('\n'));
  }

  // Notifications
  async function enableNotifications(){
    if(!('Notification' in window)) { showToast(T[STATE.lang].notifNo); return; }
    const perm = await Notification.requestPermission();
    if(perm === 'granted') showToast(T[STATE.lang].notifOk);
  }
  function testNotification(){
    if(!('Notification' in window)) { showToast(T[STATE.lang].notifNo); return; }
    setTimeout(()=>{ new Notification('Mood Diary', { body: STATE.lang==='ru'?'Пора отметить настроение':'Time to log your mood' }); vibrate(40); }, 10000);
  }

  // PIN lock (lightweight demo)
  function isLocked(){ try{ return !!localStorage.getItem(KEYS.pin) && !localStorage.getItem(KEYS.unlocked); }catch{ return false; } }
  function showLockIfNeeded(){ lockOverlay.hidden = !isLocked(); }

  // Events
  document.querySelectorAll('.emoji').forEach(btn => {
    btn.addEventListener('click', () => {
      if(btn.id === 'fineBtn'){ openSheet(); return; }
      const val = parseInt(btn.dataset.value, 10);
      addEntry(val);
      showToast(T[STATE.lang].saved);
      vibrate(20);
    });
  });
  slider.addEventListener('input', () => { updateSheetValue(); vibrate(10); });
  saveBtn.addEventListener('click', () => {
    addEntry(parseInt(slider.value,10), note.value.trim());
    showToast(T[STATE.lang].saved);
    vibrate(30);
    closeSheet();
  });
  cancelBtn.addEventListener('click', () => { closeSheet(); });
  sheetBackdrop.addEventListener('click', () => { closeSheet(); });

  navHistory.addEventListener('click', ()=> showSection('history'));
  navChart.addEventListener('click', ()=> showSection('chart'));
  navSettings.addEventListener('click', ()=> showSection('settings'));
  navTips.addEventListener('click', ()=> showSection('tips'));
  if(navHome) navHome.addEventListener('click', ()=> showSection('home'));

  // Segmented control (chart range)
  function onRangeClick(btn){
    document.querySelectorAll('.seg-btn').forEach(b=>b.classList.remove('active'));
    btn.classList.add('active');
    renderChart();
    updateStats();
    renderHeatmap();
  }
  if(rangeDayBtn) rangeDayBtn.addEventListener('click', ()=> onRangeClick(rangeDayBtn));
  if(rangeWeekBtn) rangeWeekBtn.addEventListener('click', ()=> onRangeClick(rangeWeekBtn));
  if(rangeMonthBtn) rangeMonthBtn.addEventListener('click', ()=> onRangeClick(rangeMonthBtn));

  // Undo last entry (10s window visually, but allow anytime here)
  if(undoBtn){
    undoBtn.addEventListener('click', ()=>{
      if(STATE.entries.length){
        STATE.entries.pop();
        saveEntries();
        updateLast();
        renderList();
        renderChart();
        renderTips();
        updateStats();
        renderHeatmap();
      }
      if(undoBar) { undoBar.hidden = true; undoBar.dataset.ts = ''; }
      vibrate(20);
    });
  }

  exportJsonBtn.addEventListener('click', exportJSON);
  exportCsvBtn.addEventListener('click', exportCSV);
  enableNotifsBtn.addEventListener('click', enableNotifications);
  testNotifBtn.addEventListener('click', testNotification);

  setPinBtn.addEventListener('click', ()=>{
    const v = pinInput.value.trim();
    try{ if(v){ localStorage.setItem(KEYS.pin, v); localStorage.removeItem(KEYS.unlocked); showToast(T[STATE.lang].pinSet); showLockIfNeeded(); } }catch{}
    pinInput.value='';
  });
  clearPinBtn.addEventListener('click', ()=>{ try{ localStorage.removeItem(KEYS.pin); localStorage.removeItem(KEYS.unlocked); showToast(T[STATE.lang].pinCleared); showLockIfNeeded(); }catch{} });
  unlockBtn.addEventListener('click', ()=>{
    const v = unlockPin.value.trim();
    try{
      const pin = localStorage.getItem(KEYS.pin);
      if(v && pin && v === pin){ localStorage.setItem(KEYS.unlocked,'1'); lockOverlay.hidden = true; lockHint.textContent=''; }
      else { lockHint.textContent = T[STATE.lang].pinWrong; vibrate(60); }
    }catch{}
    unlockPin.value='';
  });
  if(forgotPinBtn){
    forgotPinBtn.addEventListener('click', ()=>{
      try{
        localStorage.removeItem(KEYS.pin);
        localStorage.setItem(KEYS.unlocked,'1'); // keep unlocked for this session
      }catch{}
      lockOverlay.hidden = true;
      lockHint.textContent='';
      showToast(T[STATE.lang].pinCleared);
      // Navigate straight to settings so user can set a new PIN
      showSection('settings');
    });
  }

  langSelect.addEventListener('change', ()=>{ STATE.lang = langSelect.value; saveLang(); applyLang(); });

  // init
  try{ STATE.lang = localStorage.getItem(KEYS.lang) || (navigator.language?.startsWith('ru')?'ru':'en'); }catch{}
  langSelect.value = STATE.lang;
  STATE.entries = loadEntries();
  applyLang();
  // Ensure a default active range
  if(!document.querySelector('.seg-btn.active') && rangeWeekBtn){ rangeWeekBtn.classList.add('active'); }
  showSection('home');
  showLockIfNeeded();
  renderTips();
})();
