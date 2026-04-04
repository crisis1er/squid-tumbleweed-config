# Changelog

All notable changes to this configuration are documented here.

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
