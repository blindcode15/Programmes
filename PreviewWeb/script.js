(function(){
  // Long-term emotional states (20) with day/night palettes and background program
  const LONG_STATES = [
    { id:'serenity', ru:'Спокойствие', en:'Serenity', day:{accent:'#5aa3ff', bg:'#f3f7ff', bg2:'#e9f1ff'}, night:{accent:'#86c5ff', bg:'#0a0d14', bg2:'#0e1420'}, program:'aurora' },
    { id:'joy', ru:'Радость', en:'Joy', day:{accent:'#ffd166', bg:'#fff7e6', bg2:'#ffe9b6'}, night:{accent:'#ffd166', bg:'#20160a', bg2:'#2a1b0c'}, program:'bubbles' },
    { id:'love', ru:'Любовь', en:'Love', day:{accent:'#ff8fab', bg:'#fff0f4', bg2:'#ffe1ea'}, night:{accent:'#ff9fba', bg:'#1b0f13', bg2:'#230f18'}, program:'bubbles' },
    { id:'hope', ru:'Надежда', en:'Hope', day:{accent:'#7be495', bg:'#eefbf2', bg2:'#dff7e6'}, night:{accent:'#9cf0b1', bg:'#0f1713', bg2:'#102018'}, program:'aurora' },
    { id:'pride', ru:'Гордость', en:'Pride', day:{accent:'#9c6cff', bg:'#f4eefe', bg2:'#e7dbff'}, night:{accent:'#b592ff', bg:'#130f1b', bg2:'#1a1426'}, program:'aurora' },
    { id:'curiosity', ru:'Интерес', en:'Curiosity', day:{accent:'#5ad1ff', bg:'#eafaff', bg2:'#d7f4ff'}, night:{accent:'#84e2ff', bg:'#0a1216', bg2:'#0b1820'}, program:'aurora' },
    { id:'calm', ru:'Умиротворение', en:'Calm', day:{accent:'#64b5f6', bg:'#ecf6ff', bg2:'#dfefff'}, night:{accent:'#64b5f6', bg:'#0b0c0f', bg2:'#0f1218'}, program:'aurora' },
    { id:'focus', ru:'Сосредоточенность', en:'Focus', day:{accent:'#6ce0ff', bg:'#eefbff', bg2:'#ddf7ff'}, night:{accent:'#6ce0ff', bg:'#091216', bg2:'#0b1820'}, program:'aurora' },
    { id:'determination', ru:'Решимость', en:'Determination', day:{accent:'#ffa05a', bg:'#fff1e8', bg2:'#ffe2cf'}, night:{accent:'#ffb07a', bg:'#1c120b', bg2:'#24160c'}, program:'fire' },
    { id:'excitement', ru:'Волнение', en:'Excitement', day:{accent:'#ff7ab7', bg:'#fff0f7', bg2:'#ffe1ef'}, night:{accent:'#ff8dc2', bg:'#1b0f18', bg2:'#240f1f'}, program:'bubbles' },
    { id:'nostalgia', ru:'Ностальгия', en:'Nostalgia', day:{accent:'#ffa8a8', bg:'#fff1f1', bg2:'#ffe3e3'}, night:{accent:'#ffb3b3', bg:'#1a1010', bg2:'#211213'}, program:'aurora' },
    { id:'melancholy', ru:'Меланхолия', en:'Melancholy', day:{accent:'#7aa0ff', bg:'#eef2ff', bg2:'#e2e7ff'}, night:{accent:'#8eb0ff', bg:'#0e1119', bg2:'#121624'}, program:'aurora' },
    { id:'sadness', ru:'Грусть', en:'Sadness', day:{accent:'#64b5f6', bg:'#eef7ff', bg2:'#e0f0ff'}, night:{accent:'#64b5f6', bg:'#0b0e14', bg2:'#0f141c'}, program:'rain' },
    { id:'anxiety', ru:'Тревога', en:'Anxiety', day:{accent:'#ffad66', bg:'#fff3e9', bg2:'#ffe8d5'}, night:{accent:'#ffc089', bg:'#1c140c', bg2:'#24190e'}, program:'thunder' },
    { id:'anger', ru:'Злость', en:'Anger', day:{accent:'#ff6b4a', bg:'#fff0ec', bg2:'#ffe0d9'}, night:{accent:'#ff7d61', bg:'#1d0e0b', bg2:'#26100d'}, program:'fire' },
    { id:'fear', ru:'Страх', en:'Fear', day:{accent:'#9aa3b2', bg:'#f3f5f8', bg2:'#e7ebf2'}, night:{accent:'#9aa3b2', bg:'#0b0c0f', bg2:'#0e1116'}, program:'thunder' },
    { id:'shame', ru:'Стыд', en:'Shame', day:{accent:'#ff99a0', bg:'#fff0f2', bg2:'#ffe1e4'}, night:{accent:'#ff9faa', bg:'#1b0e11', bg2:'#221116'}, program:'aurora' },
    { id:'guilt', ru:'Вина', en:'Guilt', day:{accent:'#bfa3ff', bg:'#f7f1ff', bg2:'#efe3ff'}, night:{accent:'#ceb6ff', bg:'#130f1b', bg2:'#1a1426'}, program:'aurora' },
    { id:'fatigue', ru:'Усталость', en:'Fatigue', day:{accent:'#a0b3c8', bg:'#f1f5f8', bg2:'#e4ebf1'}, night:{accent:'#a0b3c8', bg:'#0c0f14', bg2:'#10141a'}, program:'rain' },
    { id:'despair', ru:'Отчаяние', en:'Despair', day:{accent:'#a0a4aa', bg:'#f3f4f6', bg2:'#e8eaee'}, night:{accent:'#aeb3bb', bg:'#0a0b0d', bg2:'#0e1116'}, program:'thunder' },
  ];

  // State and elements
  const STATE = { entries: [], lang: 'ru', chart: null, longState: LONG_STATES[0].id, night: true };
  const KEYS = { entries: 'moodEntriesV1', lang: 'lang', pin: 'pin', unlocked: 'pinUnlocked' };

  const lastValueEl = document.getElementById('lastValue');
  const entriesEl = document.getElementById('entries');
  const toast = document.getElementById('toast');
  const chartCanvas = document.getElementById('moodChart');
  const homeSpark = document.getElementById('homeSpark');
  const homeRecentRow = document.getElementById('homeRecentRow');

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
  const moreEmojiBtn = document.getElementById('moreEmojiBtn');
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
  // Theme/UI additions
  const stateSelect = document.getElementById('stateSelect');
  const dayNightToggle = document.getElementById('dayNightToggle');
  const emojiPanel = document.getElementById('emojiPanel');
  const emojiGrid = document.getElementById('emojiGrid');
  const splashLayer = document.getElementById('splashLayer');
  const bgCanvas = document.getElementById('bgCanvas');

  const T = {
    ru: {
      lastNone: 'Последнее: —',
      last: v => `Последнее: ${v}`,
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
      last: v => `Last: ${v}`,
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
    '0-20': [
      'Тяжёлый момент — это не навсегда.',
      'Подыши глубже, дай себе 2 минуты тишины.',
      'Напомни себе: ты уже справлялся раньше.'
    ],
    '21-40': [
      'Кажется, всё тянет вниз — сделай один маленький шаг.',
      'Стакан воды и короткая прогулка могут помочь.'
    ],
    '41-60': [
      'Нейтрально — тоже состояние. Что одно маленькое улучшит день?',
      'Проверь базовые потребности: сон, вода, еда.'
    ],
    '61-80': [
      'Отмечай приятные мелочи — они накапливаются.',
      'Поддержи это состояние: музыка, движение, свет.'
    ],
    '81-100': [
      'Класс! Зафиксируй, что помогло — пригодится потом.',
      'Поделись теплом с кем-то ещё — усилит эффект.'
    ]
  };

  function vibrate(ms=10){ if(navigator.vibrate) navigator.vibrate(ms); }
  function fmtDate(d){
    try { return d.toLocaleString(STATE.lang === 'ru' ? 'ru-RU' : 'en-US'); }
    catch { return d.toLocaleString(); }
  }
  function emoji(v){ return v<25?'😞': v<50?'😐': v<75?'🙂':'😄'; }
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
      const prev = STATE.entries.length>1 ? STATE.entries[STATE.entries.length-2].value : null;
      const delta = prev!=null ? (last.value - prev) : 0;
      const arrow = delta>5? '↑' : delta<-5? '↓' : '→';
      const color = delta>5? '#27d17f' : delta<-5? '#ff6b6b' : '#9aa3b2';
      lastValueEl.innerHTML = `${T[STATE.lang].last(last.value)} <span style="color:${color}">${arrow}</span>`;
    } else {
      lastValueEl.textContent = T[STATE.lang].lastNone;
    }
  }
  function renderList(){
    entriesEl.innerHTML = STATE.entries.slice().reverse().map(e => {
      const t = (e.value|0);
      const hue = (t/100)*120;
      return `
      <div class="entry">
        <div style="display:flex; align-items:center; gap:8px">
          <div style="font-size:20px">${emoji(t)}</div>
          <div style="flex:1">
            ${e.note ? `<div>${escapeHtml(e.note)}</div>` : '<div class="muted"> </div>'}
            <div class="date">${fmtDate(e.date)}</div>
          </div>
        </div>
        <div class="bar" style="margin-top:8px; background: linear-gradient(90deg, hsla(${hue},70%,55%,.9), hsla(${Math.max(0,hue-40)},70%,55%,.9)); width:${t}%;"></div>
      </div>`;
    }).join('');
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
    const accent = getComputedStyle(document.documentElement).getPropertyValue('--accent').trim() || '#4f7cff';
    // burst points: sharp changes over threshold (15)
    const bursts = values.map((v,i)=> i>0 && Math.abs(v - values[i-1]) >= 15);
    const pRadius = values.map((_,i)=> bursts[i]?5:3);
    const pBg = values.map((_,i)=> bursts[i]? '#ffffff' : hexToRgba(accent, .9));
    const pBorder = values.map((_,i)=> bursts[i]? accent : hexToRgba(accent, .9));
    if(STATE.chart){
      STATE.chart.data.labels = labels;
      STATE.chart.data.datasets[0].data = values;
      STATE.chart.data.datasets[0].borderColor = accent;
      STATE.chart.data.datasets[0].backgroundColor = hexToRgba(accent, .18);
      STATE.chart.data.datasets[0].pointRadius = pRadius;
      STATE.chart.data.datasets[0].pointBackgroundColor = pBg;
      STATE.chart.data.datasets[0].pointBorderColor = pBorder;
      STATE.chart.update();
      return;
    }
    const ctx = chartCanvas.getContext('2d');
    STATE.chart = new Chart(ctx, {
      type: 'line',
      data: { labels, datasets: [{ label: 'Mood', data: values, borderColor: accent, backgroundColor: hexToRgba(accent,.18), tension:.35, pointRadius:pRadius, pointHoverRadius:6, pointBackgroundColor:pBg, pointBorderColor:pBorder }] },
      options: { scales: { y: { min:0, max:100 } }, plugins:{ legend:{ display:false } }, responsive:true, maintainAspectRatio:false }
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
        const hue = (avg/100)*120;
        const opacity = arr.length ? Math.min(.8, .2 + arr.length*.1) : 0.08;
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
    if(delta >= 10) return {kind:'up', delta};
    if(delta <= -10) return {kind:'down', delta};
    return {kind:'flat', delta};
  }

  function phrasesFor(value){
    if(value<=20) return PHRASES['0-20'];
    if(value<=40) return PHRASES['21-40'];
    if(value<=60) return PHRASES['41-60'];
    if(value<=80) return PHRASES['61-80'];
    return PHRASES['81-100'];
  }

  function renderTips(){
    if(!tipsList) return;
    if(!STATE.entries.length){ tipsList.innerHTML = `<div class="muted">${T[STATE.lang].noData}</div>`; return; }
    const latest = STATE.entries[STATE.entries.length-1].value;
    const tr = trend7d();
    const bank = phrasesFor(latest).slice().sort(()=>Math.random()-0.5).slice(0,3);
    const trendText = tr.kind==='up'?T[STATE.lang].trendUp: tr.kind==='down'?T[STATE.lang].trendDown: T[STATE.lang].trendFlat;
    tipsList.innerHTML = `
      <div class="entry"><strong>${T[STATE.lang].today}: ${latest}</strong></div>
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
    renderHomeExtras();
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
    slider.value = 50; note.value=''; updateSheetValue();
  }
  function closeSheet(){ sheet.classList.remove('open'); sheetBackdrop.classList.remove('open'); }
  function updateSheetValue(){ sheetValue.textContent = `${slider.value} / 100`; }

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
    populateStates();
    updateLast();
    renderList();
    renderChart();
    renderHomeExtras();
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

  // Theme and background
  function hexToRgba(hex, a){
    const m = hex.trim().match(/^#([0-9a-f]{6})$/i);
    if(!m) return `rgba(79,124,255,${a})`;
    const i = parseInt(m[1],16);
    const r=(i>>16)&255, g=(i>>8)&255, b=i&255;
    return `rgba(${r},${g},${b},${a})`;
  }
  function applyTheme(){
    const st = LONG_STATES.find(s=>s.id===STATE.longState) || LONG_STATES[0];
    const pal = STATE.night ? st.night : st.day;
    const root = document.documentElement;
    root.style.setProperty('--accent', pal.accent);
    root.style.setProperty('--bg', pal.bg);
    root.style.setProperty('--bg2', pal.bg2);
    // refresh chart colors
    renderChart();
    // restart background program
    startBackgroundProgram(st.program, pal);
  }
  let bgCtx=null, bgW=0, bgH=0, bgRAF=0, bgProgram='';
  function startBackgroundProgram(program, pal){
    if(!bgCanvas) return;
    cancelAnimationFrame(bgRAF);
    bgProgram = program;
    bgCtx = bgCanvas.getContext('2d');
    onResize();
    let t0 = performance.now();
    function loop(ts){
      const t = (ts - t0)/1000;
      drawBackground(program, pal, t);
      bgRAF = requestAnimationFrame(loop);
    }
    bgRAF = requestAnimationFrame(loop);
  }
  function onResize(){ if(!bgCanvas) return; bgW = bgCanvas.width = window.innerWidth; bgH = bgCanvas.height = window.innerHeight; }
  window.addEventListener('resize', onResize);
  function drawBackground(program, pal, t){
    if(!bgCtx) return;
    const ctx = bgCtx;
    ctx.clearRect(0,0,bgW,bgH);
    if(program==='aurora') drawAurora(ctx, pal, t);
    else if(program==='bubbles') drawBubbles(ctx, pal, t);
    else if(program==='fire') drawFire(ctx, pal, t);
    else if(program==='rain') drawRain(ctx, pal, t);
    else if(program==='thunder') drawThunder(ctx, pal, t);
  }
  function drawAurora(ctx, pal, t){
    const lvl = getLatestValue()/100;
    const g = ctx.createLinearGradient(0,0,bgW, bgH);
    g.addColorStop(0, hexToRgba(pal.accent, .06 + .1*lvl));
    g.addColorStop(.5, hexToRgba(pal.accent, .10 + .15*lvl));
    g.addColorStop(1, hexToRgba(pal.accent, .06 + .1*lvl));
    ctx.fillStyle = g;
    const y = bgH*0.2 + Math.sin(t*0.4)*40;
    ctx.beginPath();
    ctx.moveTo(0, y);
    for(let x=0;x<=bgW;x+=20){
      const yy = y + Math.sin(t*0.8 + x*0.01)*30 + Math.sin(t*0.5 + x*0.02)*20;
      ctx.lineTo(x, yy);
    }
    ctx.lineTo(bgW,0); ctx.lineTo(0,0); ctx.closePath();
    ctx.fill();
  }
  const bubbles = Array.from({length:30},()=>({x:Math.random(), y:Math.random(), r:Math.random()*6+3, v:(.2+Math.random())*0.02}));
  function drawBubbles(ctx, pal, t){
    const lvl = getLatestValue()/100;
    ctx.globalAlpha = .15 + .25*lvl;
    ctx.fillStyle = pal.accent;
    for(const b of bubbles){
      const x = b.x*bgW;
      const y = (b.y - (t*b.v)%1 + 1)%1 * bgH;
      ctx.beginPath(); ctx.arc(x, y, b.r, 0, Math.PI*2); ctx.fill();
    }
    ctx.globalAlpha = 1;
  }
  function drawFire(ctx, pal, t){
    const lvl = getLatestValue()/100;
    const grd = ctx.createLinearGradient(0,bgH,0,bgH*0.6);
    grd.addColorStop(0, hexToRgba('#000', 0));
    grd.addColorStop(1, hexToRgba(pal.accent, .10 + .2*lvl));
    ctx.fillStyle = grd;
    ctx.fillRect(0, bgH*0.6 + Math.sin(t*3)*6, bgW, bgH*0.4);
  }
  function drawRain(ctx, pal, t){
    const lvl = getLatestValue()/100;
    ctx.strokeStyle = hexToRgba(pal.accent, .08 + .2*lvl);
    ctx.lineWidth = 1.2;
    for(let i=0;i<120;i++){
      const x = (i*73 % bgW);
      const y = (t*200 + i*37) % (bgH+50) - 50;
      ctx.beginPath(); ctx.moveTo(x, y); ctx.lineTo(x+4, y+10); ctx.stroke();
    }
  }
  function drawThunder(ctx, pal, t){
    if(Math.floor(t)%5===0 && (t%5)<.1){
      ctx.fillStyle = hexToRgba('#fff', .08);
      ctx.fillRect(0,0,bgW,bgH);
    }
    drawRain(ctx, pal, t);
  }

  // State controls
  function populateStates(){
    if(!stateSelect) return;
    stateSelect.innerHTML = LONG_STATES.map(s=>`<option value="${s.id}">${STATE.lang==='ru'?s.ru:s.en}</option>`).join('');
    stateSelect.value = STATE.longState;
    dayNightToggle.checked = !!STATE.night;
  }

  // Home extras: sparkline + recent dots
  function renderHomeExtras(){
    try{
      renderSparkline();
      renderRecentDots();
    }catch{}
  }
  function renderSparkline(){
    if(!homeSpark) return;
    const ctx = homeSpark.getContext('2d');
    const W = homeSpark.width = homeSpark.clientWidth * devicePixelRatio;
    const H = homeSpark.height = 36 * devicePixelRatio;
    ctx.clearRect(0,0,W,H);
    const data = STATE.entries.slice(-24);
    if(!data.length) return;
    const xs = data.map((_,i)=> i/(data.length-1));
    const ys = data.map(e=> 1 - Math.max(0, Math.min(100, e.value))/100);
    const accent = getComputedStyle(document.documentElement).getPropertyValue('--accent').trim() || '#4f7cff';
    // area
    ctx.beginPath();
    ctx.moveTo(0, H*ys[0]);
    for(let i=1;i<xs.length;i++) ctx.lineTo(W*xs[i], H*ys[i]);
    ctx.lineTo(W, H); ctx.lineTo(0, H); ctx.closePath();
    ctx.fillStyle = hexToRgba(accent, .15);
    ctx.fill();
    // line
    ctx.beginPath();
    ctx.moveTo(0, H*ys[0]);
    for(let i=1;i<xs.length;i++) ctx.lineTo(W*xs[i], H*ys[i]);
    ctx.strokeStyle = accent; ctx.lineWidth = 2*devicePixelRatio; ctx.stroke();
  }
  function renderRecentDots(){
    if(!homeRecentRow) return;
    const data = STATE.entries.slice(-24).reverse();
    homeRecentRow.innerHTML = '';
    for(const e of data){
      const t = Math.max(0, Math.min(100, e.value));
      const hue = (t/100)*120;
      const el = document.createElement('div');
      el.className = 'dot';
      el.title = `${fmtDate(e.date)} · ${t}`;
      el.style.background = `hsl(${hue},70%,55%)`;
      homeRecentRow.appendChild(el);
    }
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
      if(btn.id === 'moreEmojiBtn'){ openEmojiPanel(); return; }
      // Map quick emojis to long states
      const emotion = btn.dataset.emotion;
      if(emotion){
        const map = { sad:'sadness', neutral:'calm', joy:'joy', anger:'anger' };
        const target = map[emotion];
        if(target){ STATE.longState = target; if(stateSelect){ stateSelect.value = target; } applyTheme(); }
      }
      const val = parseInt(btn.dataset.value, 10);
      addEntry(val);
      showToast(T[STATE.lang].saved);
      vibrate(20);
      btn.classList.remove('glow');
      void btn.offsetWidth; // restart animation
      btn.classList.add('glow');
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

  // Day/Night + State
  if(stateSelect){
    stateSelect.addEventListener('change', ()=>{ STATE.longState = stateSelect.value; applyTheme(); });
  }
  if(dayNightToggle){
    dayNightToggle.addEventListener('change', ()=>{ STATE.night = dayNightToggle.checked; applyTheme(); });
  }

  // Emoji panel
  const EMOJI_PRESETS = [
    { id:'joy', ch:'😊', v:80 },
    { id:'love', ch:'🥰', v:85 },
    { id:'serenity', ch:'😌', v:60 },
    { id:'hope', ch:'🤞', v:70 },
    { id:'pride', ch:'😎', v:75 },
    { id:'curiosity', ch:'🧐', v:65 },
    { id:'calm', ch:'🌿', v:62 },
    { id:'focus', ch:'🎯', v:60 },
    { id:'determination', ch:'💪', v:72 },
    { id:'excitement', ch:'🤩', v:78 },
    { id:'nostalgia', ch:'📼', v:55 },
    { id:'melancholy', ch:'🎧', v:40 },
    { id:'sadness', ch:'😢', v:20 },
    { id:'anxiety', ch:'😬', v:30 },
    { id:'anger', ch:'😠', v:25 },
    { id:'fear', ch:'😱', v:15 },
    { id:'shame', ch:'🙈', v:30 },
    { id:'guilt', ch:'😔', v:25 },
    { id:'fatigue', ch:'😪', v:35 },
    { id:'despair', ch:'💀', v:10 },
  ];
  function populateEmojiGrid(){
    if(!emojiGrid) return;
    emojiGrid.innerHTML = '';
    for(const e of EMOJI_PRESETS){
      const b = document.createElement('button');
      b.className = 'emoji'; b.textContent = e.ch; b.title = e.id;
      b.addEventListener('click', (ev)=>{
        // selecting in palette switches long state too
        STATE.longState = e.id; if(stateSelect){ stateSelect.value = e.id; }
        applyTheme();
        addEntry(e.v);
        showToast(T[STATE.lang].saved);
        vibrate(25);
        addSplash(ev.clientX, ev.clientY);
        closeEmojiPanel();
      });
      emojiGrid.appendChild(b);
    }
  }
  function openEmojiPanel(){ if(!emojiPanel) return; populateEmojiGrid(); emojiPanel.hidden = false; }
  function closeEmojiPanel(){ if(!emojiPanel) return; emojiPanel.hidden = true; }
  function addSplash(x,y){ if(!splashLayer) return; const d=document.createElement('div'); d.className='splash-dot'; d.style.left=`${x}px`; d.style.top=`${y}px`; splashLayer.appendChild(d); setTimeout(()=>d.remove(), 600); }

  // Helpers
  function getLatestValue(){ return STATE.entries.length ? STATE.entries[STATE.entries.length-1].value : 50; }

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
  populateStates();
  applyTheme();
  applyLang();
  // Ensure a default active range
  if(!document.querySelector('.seg-btn.active') && rangeWeekBtn){ rangeWeekBtn.classList.add('active'); }
  showSection('home');
  showLockIfNeeded();
  renderTips();
  renderHomeExtras();
})();
