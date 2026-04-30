# Changelog

All notable changes to this configuration are documented here.

---

## [3.3] — 2026-04-30

### Added
- ACL `google_admin_ui` (`analytics.google.com`, `tagmanager.google.com`,
  `search.google.com`, `.clients6.google.com`) — whitelist for Google admin tools
  (Search Console, Google Analytics admin UI, Tag Manager admin UI)
- `http_access allow google_admin_ui` placed before `http_access deny CONNECT ads_block`
  — ensures admin UIs reach the upstream Google servers even though the same domains
  may appear in the ad-block list

### Changed
- ACL `yoyo_ads` renamed to `ads_block` — reflects current source list (HaGeZi PRO++,
  not Peter Lowe / pgl.yoyo.org)
- ACL source path: `/etc/squid/acl/pgl_yoyo.domains` → `/etc/squid/acl/hagezi_pro.domains`
- Ad blocking source updated: pgl.yoyo.org (~3,500 domains) → HaGeZi PRO++ (~233,600 domains)
  — significantly broader coverage

### Notes
- Trackers blocked at DNS level (`www.google-analytics.com`, `googletagmanager.com`,
  `doubleclick.net`, …) remain fully blocked — see
  [unbound-tumbleweed-config](https://github.com/crisis1er/unbound-tumbleweed-config)
- Whitelist scope is intentionally narrow: only first-party admin UIs are unblocked,
  third-party tracker beacons stay blocked via DNS

---

## [3.2] — 2026-04-18

### Security
- Added `acl URN proto URN` + `http_access deny URN` — mitigation CVE-2025-54574 (heap buffer overflow RCE via URN)
- Added `acl HTTP_TRACE method TRACE` + `http_access deny HTTP_TRACE` — blocks HTTP TRACE method (XST prevention)
- Both deny rules placed after all `http_access allow` entries — AI/web traffic unaffected
- Removed redundant `cachemgr_passwd` directive — access already restricted via `http_access allow localhost manager` + `http_access deny manager`

### Changed
- Removed `acl gopher_proto proto GOPHER` — Gopher protocol removed from Squid 7.4
- Updated Squid version reference: 6.x → 7.4

---

## [3.1] — 2026-04-13

### Security
- Restricted `squid.conf` permissions to `640` (root:root) — prevents world-readable access to proxy configuration (Lynis SQD-3613)

---

## [3.0] — 2026-04-04

### Added
- ACLs: `ai_zml` (.z.ai), `ai_kimi` (.kimi.ai .moonshot.cn .moonshot.ai)
- ACLs: `vpn_nordvpn` (.nordvpn.com .nordvpn.net) — NordVPN browser extension support
- ACLs: `dev_github` (.github.com .githubusercontent.com .githubassets.com)
- Streaming: extended `streaming_twitch` with full CDN (.twitchscdn.net .jtvnw.net)
- WebSocket (`CONNECT`) support for ZML and Kimi AI services
- `refresh_pattern` for `.iso` and `.img` files (cache up to 1 year)
- Delay pools: ISO/image downloads throttled to 10 MB/s (burst 20 MB)
- `cache deny` entries for ai_zml and ai_kimi

### Changed
- `pipeline_prefetch` set to 0 (was 128) — prevents head-of-line blocking on multi-worker setup
- Removed unused ACL `0.0.0.1-0.255.255.255` (non-standard range, leftover from Squid defaults)

---

## [2.0] — 2026-03-14

### Added
- Initial production configuration
- 4-worker setup with `diskd` cache (1 GB) and `cache_mem` 512 MB per worker
- Full header anonymization (forwarded_for, via, User-Agent replacement)
- Ad blocking via pgl.yoyo.org domain list
- AI services: ChatGPT, Copilot, Gemini, Claude, Perplexity, DeepSeek, Qwen, Grok
- Streaming: YouTube, Twitch, Netflix, Vimeo
- TLS hardening: PROFILE=SYSTEM cipher, NO_SSLv3/TLSv1/TLSv1.1
- DNS via local Unbound (127.0.0.1)
- DoH local endpoint (doh.lan) passthrough
- `collapsed_forwarding on` for concurrent request deduplication
- `cache_replacement_policy heap LFUDA`
