/* SLSD — code commun : outils, panier, comptes, en-tête et pied de page. */
(function () {
  "use strict";
  var C = window.SLSD_CONFIG || {};
  var S = (window.SLSD = {});

  /* ---------- Outils ---------- */
  S.fmt = function (n) { return Number(n).toLocaleString("fr-FR") + " XAF"; };
  S.norm = function (s) { return String(s).toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, ""); };
  S.get = function (k, d) { try { var v = localStorage.getItem(k); return v ? JSON.parse(v) : d; } catch (e) { return d; } };
  S.set = function (k, v) { try { localStorage.setItem(k, JSON.stringify(v)); } catch (e) {} };
  S.del = function (k) { try { localStorage.removeItem(k); } catch (e) {} };
  S.$ = function (s) { return document.querySelector(s); };
  S.param = function (k) { return new URLSearchParams(location.search).get(k) || ""; };
  S.safeNext = function (n) { return /^[a-z0-9\-]+\.html(\?[a-z0-9=&%_\-]*)?$/i.test(n) ? n : "espace.html"; };
  S.photo = function (id, w) { return "https://images.unsplash.com/" + id + "?auto=format&fit=crop&w=" + (w || 700) + "&q=75"; };
  S.TL = { produit: "Produit", service: "Service", talent: "Professionnel" };
  S.ROLES = { client: "Client", vendeur: "Vendeur", freelance: "Professionnel" };
  S.CITIES = ["Douala", "Yaoundé", "Kribi", "Bafoussam", "Garoua", "Limbé", "Bamenda", "Autre ville"];

  var tt;
  S.toast = function (m) {
    var t = document.getElementById("ts");
    if (!t) { t = document.createElement("div"); t.id = "ts"; t.className = "toast"; t.setAttribute("role", "status"); document.body.appendChild(t); }
    t.textContent = m; t.classList.add("on");
    clearTimeout(tt); tt = setTimeout(function () { t.classList.remove("on"); }, 2600);
  };

  /* ---------- Offres et recherche ---------- */
  S.item = function (id) { return (S.ITEMS || []).filter(function (x) { return x.id === Number(id); })[0]; };
  var CITYW = ["douala", "yaounde", "kribi", "bafoussam", "garoua", "limbe", "bamenda", "buea", "bertoua", "maroua"];
  var STOP = "je tu il un une des les mon ma mes pour cherche besoin livre livree a moi pas de du le la en au sur et avec que qui veux voudrais faire".split(" ");
  S.search = function (q) {
    var toks = S.norm(q).split(/[^a-z0-9]+/).filter(function (t) { return t.length > 2 && STOP.indexOf(t) < 0; });
    if (!toks.length) return S.ITEMS.slice();
    return S.ITEMS.map(function (x) {
      var s = 0;
      toks.forEach(function (t) {
        var stem = t.length > 5 ? t.slice(0, 5) : t;
        if (x.h.indexOf(stem) >= 0) s += CITYW.indexOf(t) >= 0 ? 1 : 3;
      });
      return { x: x, s: s };
    }).filter(function (r) { return r.s > 0; }).sort(function (a, b) { return b.s - a.s; }).map(function (r) { return r.x; });
  };
  S.card = function (x) {
    var g = "#222";
    S.UV.forEach(function (u) { if (u[0] === x.u) g = u[3]; });
    var img = x.i ? '<img src="' + S.photo(x.i) + '" alt="" loading="lazy" referrerpolicy="no-referrer" onerror="this.remove()">' : "";
    var ini = x.ini ? '<span class="ini">' + x.ini + "</span>" : "";
    var price = x.p ? (x.pl ? x.pl + " " : "") + S.fmt(x.p) : x.pl;
    var act = x.t === "produit"
      ? '<button class="btn p" data-add="' + x.id + '" type="button">Ajouter</button>'
      : '<a class="btn" href="offre.html?id=' + x.id + '">' + (x.t === "talent" ? "Voir le profil" : "Voir") + "</a>";
    return '<article class="card"><a class="im" href="offre.html?id=' + x.id + '" style="--g1:' + g + '">' + ini + img +
      '<span class="bd">' + S.TL[x.t] + '</span></a><div class="bo"><h3><a href="offre.html?id=' + x.id + '">' + x.n + "</a></h3>" +
      '<div class="se">' + x.s + " <i>✓</i> · " + x.c + '</div><div class="pr"><b>' + price + "</b>" + act + "</div></div></article>";
  };

  /* ---------- Panier (enregistré sur l'appareil) ---------- */
  S.cart = {
    ids: function () { return S.get("slsd_cart", []); },
    add: function (id) { var a = S.cart.ids(); a.push(Number(id)); S.set("slsd_cart", a); S.updateBadge(); },
    remove: function (i) { var a = S.cart.ids(); a.splice(i, 1); S.set("slsd_cart", a); S.updateBadge(); },
    clear: function () { S.del("slsd_cart"); S.updateBadge(); },
    items: function () { return S.cart.ids().map(S.item).filter(Boolean); },
    total: function () { return S.cart.items().reduce(function (t, x) { return t + (x.p || 0); }, 0); }
  };
  S.updateBadge = function () {
    var n = S.cart.ids().length, b = document.getElementById("cn");
    if (b) { b.textContent = n; b.style.display = n ? "block" : "none"; }
  };
  document.addEventListener("click", function (e) {
    var a = e.target.closest ? e.target.closest("[data-add]") : null;
    if (a) { S.cart.add(a.getAttribute("data-add")); S.toast("Ajouté au panier"); }
  });

  /* ---------- Comptes : mode Supabase si configuré, sinon mode démo ---------- */
  var sb = null;
  if (C.SUPABASE_URL && C.SUPABASE_ANON_KEY && window.supabase) {
    sb = window.supabase.createClient(C.SUPABASE_URL, C.SUPABASE_ANON_KEY);
  }
  S.mode = sb ? "supabase" : "demo";
  S.auth = {
    signUp: function (d) {
      if (sb) {
        return sb.auth.signUp({
          email: d.email, password: d.password,
          options: { data: { full_name: d.name, role: d.role, city: d.city, phone: d.phone } }
        }).then(function (r) { if (r.error) throw r.error; return r.data.user; });
      }
      /* Mode démo : on garde le profil sur l'appareil, jamais le mot de passe. */
      var u = { id: "demo-" + Date.now(), email: d.email, name: d.name, role: d.role, city: d.city, phone: d.phone, verified: false };
      S.set("slsd_user", u); S.set("slsd_session", true);
      return Promise.resolve(u);
    },
    signIn: function (email, password) {
      if (sb) {
        return sb.auth.signInWithPassword({ email: email, password: password })
          .then(function (r) { if (r.error) throw r.error; return r.data.user; });
      }
      var u = S.get("slsd_user", null);
      if (u && u.email === email) { S.set("slsd_session", true); return Promise.resolve(u); }
      return Promise.reject(new Error("Mode démo : crée d'abord un compte sur cet appareil."));
    },
    signOut: function () {
      if (sb) return sb.auth.signOut();
      S.del("slsd_session"); return Promise.resolve();
    },
    current: function () {
      if (sb) {
        return sb.auth.getUser().then(function (r) {
          var u = r.data && r.data.user;
          if (!u) return null;
          return sb.from("profiles").select("*").eq("id", u.id).single().then(function (p) {
            var d = p.data || {};
            return { id: u.id, email: u.email, name: d.full_name || "", role: d.role || "client", city: d.city || "", verified: !!d.verified };
          });
        });
      }
      return Promise.resolve(S.get("slsd_session", false) ? S.get("slsd_user", null) : null);
    }
  };

  /* ---------- En-tête et pied de page ---------- */
  S.layout = function (active) {
    document.documentElement.dataset.theme = S.get("slsd_theme", "dark");
    var links = [["catalogue.html?t=produit", "Produits", "produit"], ["catalogue.html?t=talent", "Professionnels", "talent"], ["catalogue.html?t=service", "Services", "service"], ["vision.html", "Vision", "vision"]];
    var h = document.getElementById("hdr");
    if (h) {
      h.innerHTML = '<header><div class="w hd"><a class="brand" href="index.html"><img src="assets/logo.jpg" alt="SLSD"><b>SLSD</b></a>' +
        "<nav id=\"nv\">" + links.map(function (l) { return '<a href="' + l[0] + '"' + (active === l[2] ? ' class="on"' : "") + ">" + l[1] + "</a>"; }).join("") + "</nav>" +
        '<div class="hr"><button class="ib" id="th" type="button" aria-label="Thème">◐</button>' +
        '<a class="ib" href="panier.html" aria-label="Panier">🛒<span class="n" id="cn">0</span></a>' +
        '<span id="au"></span><button class="ib" id="mn" type="button" aria-label="Menu">☰</button></div></div></header>';
      document.getElementById("th").onclick = function () {
        var d = document.documentElement, n = d.dataset.theme === "dark" ? "light" : "dark";
        d.dataset.theme = n; S.set("slsd_theme", n);
      };
      document.getElementById("mn").onclick = function () { document.getElementById("nv").classList.toggle("open"); };
      document.getElementById("nv").onclick = function () { document.getElementById("nv").classList.remove("open"); };
      window.addEventListener("pageshow", function () { document.getElementById("nv").classList.remove("open"); });
      S.updateBadge();
      S.auth.current().then(function (u) {
        var au = document.getElementById("au");
        au.innerHTML = u
          ? '<a class="btn lo" href="espace.html">Mon espace</a>'
          : '<a class="btn lo" href="connexion.html">Connexion</a> <a class="btn p" href="inscription.html">Créer un compte</a>';
      }).catch(function () {});
    }
    var f = document.getElementById("ftr");
    if (f) {
      f.innerHTML = '<footer><div class="w"><span>SLSD · Plateforme universelle · Douala, Cameroun</span><span>' +
        (S.mode === "demo" ? "Mode démo : données fictives, enregistrées sur cet appareil." : "Connecté à la base de données.") + "</span></div></footer>";
    }
  };
})();