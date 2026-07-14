(function () {
  var root = document.documentElement;
  var STORE = "ar-theme";

  // The catalogue. `id` is the data-theme value; `label` is what the menu shows.
  var THEMES = [
    { id: "light",    label: "Light" },
    { id: "dark",     label: "Dark" },
    { id: "japanese", label: "Japanese" },
    { id: "arabic",   label: "Arabic" },
    { id: "indian",   label: "Indian" },
    { id: "codex",    label: "Codex" },
    { id: "terminal", label: "Terminal" },
    { id: "hebrew",   label: "Hebrew" },
    { id: "georgian", label: "Georgian" }
  ];

  function saved() { try { return localStorage.getItem(STORE); } catch (e) { return null; } }
  function store(v) { try { localStorage.setItem(STORE, v); } catch (e) {} }

  // Apply the saved theme before first paint to avoid a flash of the default.
  var s = saved();
  if (s) root.setAttribute("data-theme", s);

  function current() {
    return root.getAttribute("data-theme") ||
      (matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light");
  }
  function apply(id) { root.setAttribute("data-theme", id); store(id); sync(); }

  // Public API. __toggleTheme cycles to the next theme so the inline onclick in
  // the markup keeps working even if the picker below never gets built.
  window.__setTheme = apply;
  window.__toggleTheme = function () {
    var cur = current(), i = 0;
    for (var k = 0; k < THEMES.length; k++) if (THEMES[k].id === cur) { i = k; break; }
    apply(THEMES[(i + 1) % THEMES.length].id);
  };

  var btn, menu;

  function sync() {
    var cur = current();
    if (btn) btn.textContent = "theme: " + cur;
    if (!menu) return;
    var opts = menu.querySelectorAll("[data-theme-id]");
    for (var j = 0; j < opts.length; j++) {
      opts[j].setAttribute("aria-selected",
        opts[j].getAttribute("data-theme-id") === cur ? "true" : "false");
    }
  }

  function open()  { menu.hidden = false; btn.setAttribute("aria-expanded", "true");
    document.addEventListener("click", onDoc, true);
    document.addEventListener("keydown", onKey, true); }
  function close() { menu.hidden = true;  btn.setAttribute("aria-expanded", "false");
    document.removeEventListener("click", onDoc, true);
    document.removeEventListener("keydown", onKey, true); }
  function onDoc(e) { if (!menu.contains(e.target) && !btn.contains(e.target)) close(); }
  function onKey(e) { if (e.key === "Escape") { close(); btn.focus(); } }

  function build() {
    btn = document.querySelector(".theme-btn");
    if (!btn) return;

    // Wrap the button so the menu can anchor to it, and take over the click.
    var wrap = document.createElement("span");
    wrap.className = "theme-picker";
    btn.parentNode.insertBefore(wrap, btn);
    wrap.appendChild(btn);

    btn.removeAttribute("onclick");
    btn.setAttribute("type", "button");
    btn.setAttribute("aria-haspopup", "listbox");
    btn.setAttribute("aria-expanded", "false");

    menu = document.createElement("div");
    menu.className = "theme-menu";
    menu.setAttribute("role", "listbox");
    menu.setAttribute("aria-label", "Colour theme");
    menu.hidden = true;

    THEMES.forEach(function (t) {
      var o = document.createElement("button");
      o.type = "button";
      o.className = "theme-opt";
      o.setAttribute("role", "option");
      o.setAttribute("data-theme-id", t.id);
      o.innerHTML = '<span class="sw sw-' + t.id + '"></span>' + t.label;
      o.addEventListener("click", function () { apply(t.id); close(); btn.focus(); });
      menu.appendChild(o);
    });
    wrap.appendChild(menu);

    btn.addEventListener("click", function (e) {
      e.stopPropagation();
      if (menu.hidden) open(); else close();
    });

    sync();
  }

  if (document.readyState === "loading")
    document.addEventListener("DOMContentLoaded", build);
  else build();
})();
