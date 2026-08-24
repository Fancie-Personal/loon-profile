# Loon profile

多设备用同一个配置 URL 订阅。节点订阅密钥不进这个仓库。

## 导入（每台设备做一次）

1. Loon → 配置 → 从 URL 下载 / 更新配置，填下面其中一个：

   - GitHub：`https://raw.githubusercontent.com/Fancie-Personal/loon-profile/main/Loon.conf`
   - jsDelivr：`https://cdn.jsdelivr.net/gh/Fancie-Personal/loon-profile@main/Loon.conf`

2. 立刻补回远程节点订阅（配置里 `[Remote Proxy]` 是空的，避免把订阅 token 公开）：
   - 配置 → 订阅 → 用你原来的 Flower / 机场链接
   - UDP、跳过证书校验等选项与现网保持一致

3. 去广告 Lite 需要 HTTPS 解密时：安装并信任 Loon CA（MitM）。只靠 `Advertising.list` 拦域名时可以不装证书。

4. 资源更新：远程规则 / 插件建议开定时更新（每天即可）。

## 日常改什么

| 想改的东西 | 改哪个文件 | 生效方式 |
| --- | --- | --- |
| 策略组、DNS、规则顺序 | `Loon.conf` | 各设备「更新配置」 |
| 强制直连 | `rules/custom-direct.list` | 只更新远程规则 |
| 强制代理 | `rules/custom-proxy.list` | 只更新远程规则 |
| 额外拦截 | `rules/custom-reject.list` | 只更新远程规则 |

改 `Loon.conf` 会覆盖本地配置里同名段。更新前确认订阅还在；若被冲掉，再贴一次订阅 URL。

## 分流逻辑

局域网 / Tailscale → 广告 → 自定义 → Apple / AI / Telegram / YouTube / Google / GitHub / Microsoft → 全球代理列表 → 国内直连 → GEOIP CN → `Final`（默认走 `Proxy`，可手动改 DIRECT）。

`Auto` 只收录带地区名的节点，不会把 Traffic / Expire 这种信息节点拿去测速。

## 插件

- **去广告 Lite**：rewrite 级广告拦截（可选 MitM）
- **订阅解析器**：Sub-Store parser，方便机场订阅转 Loon
- **出口 IP 查询**：插件页点运行，看当前节点出口
