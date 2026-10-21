# Loon profile

在 Mac 上编辑一份 `Loon.conf`，iPhone / iPad / Apple TV 订阅同一份，改完跑一次脚本即可全设备更新。
节点订阅密钥不进这个仓库：配置里 `[Remote Proxy]` 是空的，每台设备自己补。

## 更新到 2026-10-21 DNS 配置（先设置，再更新）

默认 DNS 改为 Cloudflare / Google DoH，经 `Proxy` 查询；现有国内域名 Host 映射继续使用国内 DoH。
Mac 已在 Net.Coffee 复测显示 Google DNS / 未检测到泄露；手机仍需逐台验证。

更新前，每台设备先完成以下设置：

1. 使用 Loon **3.5.2（996）或以上版本**（Mac 为 0.5.0 / 1009）。
2. 在「节点 → 订阅」编辑自己的机场订阅，将**节点服务器 DNS**设为 `https://223.5.5.5/dns-query`。对应配置参数是 `server-dns="https://223.5.5.5/dns-query"`；只在本机订阅设置，不要把订阅 URL 粘进本仓库。它只解析节点服务器域名，不用于普通网页域名。
3. DNS 设置：**DoH 流量模式 = Rule**；**包含系统 DNS = 关闭**；**查询回落 = 关闭**。
4. 更新远程配置并「应用」，重新连接 Loon，再运行 DNS 检测。即使当前能连接，也要重连一次验证节点的启动解析。

若订阅编辑界面没有独立 DNS 选项，可在本机 Host 映射中把实际节点服务器域名指定到 `server:https://223.5.5.5/dns-query`，与 Mac 的私有启动映射作用相同；机场更换服务器域名后需同步维护。未设置独立启动解析前，不要切换到这份境外默认 DNS 配置，否则可能出现 DNS 与代理相互等待。

这些 App 设置和私人节点订阅不会由公共 `Loon.conf` 自动下发。不要把 Mac 的 `default.lcf` 上传到仓库。

若更新后无法联网：先断开 Loon，在本机把默认 DoH 恢复成 `https://223.5.5.5/dns-query,https://doh.pub/dns-query`，DoH 流量模式恢复 DIRECT，再重连排查；不要通过打开明文 DNS 回落来绕过问题。

官方说明：[节点 DNS](https://nsloon.app/docs/Node/)、[订阅 server-dns](https://nsloon.app/docs/Node/subscription)。检测页的解析器地区不等于物理网卡抓包结论，本次仍未完成全设备零泄漏验收。

## 同步到 iOS / iPadOS

仓库已设为 public，手机端直接订阅 jsDelivr —— 国内可直连，不需要任何镜像。
跟踪的文件和历史提交里都没有订阅 token（`[Remote Proxy]` 是空的），机场订阅只留在设备本地。

### 手动导入（推荐路径）

Loon → 配置 → 右上角 `+` → 从 URL 下载，粘贴：

```
https://cdn.jsdelivr.net/gh/Fancie-Personal/loon-profile@main/Loon.conf
```

取不到内容时按顺序换备用地址：

```
# jsDelivr 备用线路
https://fastly.jsdelivr.net/gh/Fancie-Personal/loon-profile@main/Loon.conf

# Gist 镜像
https://gist.githubusercontent.com/Fancie-Personal/916675be5dbf03d0d9128e1e4c14c67a/raw/Loon.conf

# GitHub 代理镜像
https://ghfast.top/https://raw.githubusercontent.com/Fancie-Personal/loon-profile/main/Loon.conf
```

导入前先关掉状态栏 VPN / 当前 Loon 隧道，否则容易出现「配置文件下载失败」。
Loon 只给「从 URL 下载」来的配置显示「更新」；从文件导入、复制出来的本地副本没有这一项，只能重新导入。

### 离线导入（可选，不依赖网络）

从 Mac 用 AirDrop 把 `Loon.conf` 发到手机，然后在 Loon → 配置 → `+` → 从文件导入。
这种是本地副本，列表里没有「更新」菜单，不会跟着 URL 走；日常请用上面的远程配置。

### 一键导入链接

在 Safari（不要用微信 / QQ 内置浏览器，query 可能被丢掉）里打开：

`https://www.nsloon.com/openloon/import?sub=https%3A%2F%2Fcdn.jsdelivr.net%2Fgh%2FFancie-Personal%2Floon-profile%40main%2FLoon.conf`

备用（Gist 镜像）：

`https://www.nsloon.com/openloon/import?sub=https%3A%2F%2Fgist.githubusercontent.com%2FFancie-Personal%2F916675be5dbf03d0d9128e1e4c14c67a%2Fraw%2FLoon.conf`

### 每台设备只做一次

1. **节点订阅**：配置里 `[Remote Proxy]` 是空的，用原来的机场 / 自建节点链接添加；订阅 token 只留在本机。
   推荐在 Loon → 配置 → 节点 / 订阅里添加，而不是把订阅行粘进配置文本：远程配置更新时会整段覆盖，粘在文本里的订阅会被冲掉。
2. **策略组**：在 `Proxy` / `Auto` / `AI` / `YouTube` 等组里选好节点，`AI` 组建议选美国或日本。
3. **MitM**：只有需要「去广告 Lite」做 HTTPS 解密时才安装并信任 Loon CA；只靠域名拦截可以不装。
4. **DNS**：按上面的 2026-10-21 设置完成订阅节点独立 DNS、DoH Rule 模式，并关闭系统 DNS 与查询回落，再应用配置。
5. **资源更新**：远程规则 / 插件开定时更新，每天一次即可。

iPhone 与 iPad 之间还可以另外打开 Loon 自带的 iCloud 同步（同一 Apple ID）。
Mac 版 Loon 不参与这套 iCloud 容器，所以 Mac ↔ 手机之间用上面的订阅地址同步。

### 改完配置怎么同步

```sh
# 在 Mac 上改完 Loon.conf 之后
cd ~/loon-profile && ./publish.sh
```

脚本会提交并推送仓库、调用 jsDelivr 的缓存刷新接口，并同步 Gist 备份和 iCloud 副本。
然后回到设备的 Loon → 配置 → 该配置右侧「更新」（或等自动更新）。

jsDelivr 对分支引用有缓存，脚本里的刷新调用通常几秒内生效；没生效就等几分钟，或把地址换成 `fastly.jsdelivr.net`。
Gist ID 存在 `.gist-id`（已 gitignore），作为备用订阅地址保留。

## 日常改什么

| 想改的东西 | 改哪个文件 | 生效方式 |
| --- | --- | --- |
| 策略组、DNS、规则顺序 | `Loon.conf` | `./publish.sh` → 各设备「更新配置」 |
| 强制直连 / 强制代理 / 额外拦截 | `Loon.conf` 的 `[Rule]`（`rules/*.list` 是同一份内容的镜像，便于查找） | 同上 |
| 只改这台 Mac | `/Library/Application Support/com.loon.Loon/config/default.lcf` | 重新加载配置 + 重连 |

改 `Loon.conf` 会覆盖设备上同名段。更新前确认订阅还在；若被冲掉，再贴一次订阅 URL。

## 分流逻辑

本地规则优先；远程规则按 HTTPDNS 防绕过 → 广告 → AI / Telegram / YouTube / Google / Copilot / GitHub / Apple / Microsoft → 全球代理列表 → 国内直连 → GEOIP CN → `Final`。
`Final` 默认走 `Proxy`，可手动改成 DIRECT。

局域网、Tailscale、Apple / Microsoft 连通性检测走直连；`Auto` 只收录带地区名的节点，不会把 Traffic / Expire 这类信息节点拿去测速。

`HK` / `TW` / `SG` / `JP` / `KR` / `US` 每个地区组的第一项都是「自动选择」（`HK_Auto`、`US_Auto` 等，`url-test`，每 600 秒测速、`tolerance = 100`），在该地区内自动挑延迟最低的节点；后面跟着该地区的完整节点列表，想固定用某个节点时手动选它就行。

`其他国家` 收的是不匹配上面六个地区的节点（欧洲、中东等，过滤器 `OTHER_Filter`），同样第一项是自动选择 `其他国家_Auto`，并已加入 `Proxy` 的可选列表；订阅里 `Traffic` / `Expire` / 流量 / 到期 这类信息行会被过滤掉。

## 插件

- **去广告 Lite**：rewrite 级广告拦截（可选 MitM）
- **订阅解析器**：Sub-Store parser，方便机场订阅转 Loon

## 变更记录

### 2026-10-21 默认 DNS 经代理查询

- 默认 DoH 改为 Cloudflare / Google，增加两个 `/32` 本地代理规则。
- 保留国内域名的加密 DNS 映射和原有策略组。
- 节点启动解析由设备内 `server-dns` 或私有 Host 映射承担，私人订阅和节点地址不发布。


### 2026-10-16 改为公开仓库 + jsDelivr 订阅

- 仓库从 private 改为 public（切换前确认过跟踪文件和全部历史提交里没有订阅 token），设备订阅地址改为 `https://cdn.jsdelivr.net/gh/Fancie-Personal/loon-profile@main/Loon.conf`，国内可直连。
- `publish.sh` 增加 jsDelivr 缓存刷新调用，继续同步 Gist 备份和 iCloud 副本；Gist、ghfast.top、raw 保留为备用地址。
- 之前私有仓库时期的 Gist 方案仍然可用，但不再是主路径。

### 2026-10-16 地区分组支持自动选择

- `HK` / `TW` / `SG` / `JP` / `KR` / `US` 组的第一项改为地区自动组（`HK_Auto` 等，`url-test` + 地区过滤器，`interval = 600`、`tolerance = 100`）。
- 地区组同时保留该地区全部节点（过滤器），仍可手动固定某个节点；全局 `Auto`（`fallback` + `ALL_Filter`）不变。
- Mac 本机配置 `default.lcf` 同步做了同样调整，需要重新加载配置后生效。

### 2026-10-16 新增「其他国家」分组

- 新增过滤器 `OTHER_Filter`：只收不匹配港 / 台 / 日 / 韩 / 新 / 美关键词的节点，并排除 `Traffic`、`Expire`、流量、到期等信息行（Mac 本机配置用自己的地区关键词做排除）。
- 新增 `其他国家`（`select`，首项为自动）和 `其他国家_Auto`（`url-test`，`interval = 600`、`tolerance = 100`）两个组，并把 `其他国家` 加进 `Proxy` 的可选列表。
- Mac 本机配置同步更新，重新加载配置后生效。

### 2026-10-16 iOS / iPadOS 同步

- 仓库是私有的，匿名 raw / jsDelivr 全部 404；设备订阅地址改为 secret gist 镜像（`916675be…`），内容与 `Loon.conf` 一致。
- 清理 `[Rule]` 中重复的 Tailscale / PROCESS-NAME / GEOIP 行（上次内联个人规则时残留），现在 `FINAL` 只有一条。
- 新增 `publish.sh`：一条命令完成提交、推送、刷新 Gist。
- 三个地址实测返回同一份完整配置：gist 直连、cdn.statically.io、ghfast.top。

### 2026-10-15 DNS 与分流优化

Mac 端配置源 `/Library/Application Support/com.loon.Loon/config/default.lcf`，保留原有节点、远程订阅、代理链、MitM、端口和 `Available` 策略组；运行中的 `.tunnelConf` 是生成快照，没有手工覆盖。

- 开启 `hijack-dns = *:53`，接管进入 Loon 的 UDP 53 DNS 查询。
- 保留 IPv4 模式和 STUN 阻止，增加 `udp-fallback-mode = REJECT`，节点不支持 UDP 时拒绝转发，避免回退直连。
- 全局优先使用阿里、腾讯 DoH；`[Host]` 的明文 DNS 映射改成 DoH，删除 TestFlight 明文 DNS 特例和过期的 mtalk 固定 IP。
- 补齐 Advertising、Apple、Proxy、China 的 `_Domain.list`（上游主文件不含这些域名）。
- Cursor、Claude、Copilot 固定走 `AI`，Gemini 排在 Google 前；删除会抢先命中 Google 专用策略的宽泛域名。
- HTTPDNS 使用独立 `DNSGuard` 策略组，默认 REJECT；如 App 出现兼容问题，可临时选 DIRECT 排查。

**需在 App 中关闭 DNS「查询回落」。** Loon 默认在加密 DNS 失败时使用普通 DNS 回落，这个开关在 App 设置里；只改配置文本不能保证关闭。
配置里保留 `dns-server` 作为显式回落列表，因此关闭前不能声称「无明文查询」。

阿里 / 腾讯 DoH 保护的是传输链路，解析服务本身仍能看到查询。该方案以国内 CDN 可达性为先，不保证检测页面只显示代理出口地区的 DNS。
独立 DoH、DoT、TCP DNS，以及绕过 TUN 的请求不在 UDP 53 接管的保证范围内。

### 本地文件与回滚

`private/` 已被 Git 忽略，里面有修改前的备份（`backup-*/active-default.lcf`）、上游可达性检查结果和导入副本。
`private/Loon-optimized.lcf` 内联个人规则、可直接导入，但不含私人节点订阅；`private/Loon-active-optimized.lcf` 含本机订阅，仅供本机恢复，勿分享。
恢复备份并重新加载、重连即可回滚 Mac 端改动。

### 验证生效

1. 在 Loon 确认当前配置为修改后的那份，重新加载、重连，更新所有远程规则，检查无下载或语法错误。
2. 关闭 DNS 查询回落；在 DNS 记录里确认正常解析走 DoH。
3. 请求记录里核对：Cursor / Claude / Gemini / Copilot 走 `AI`，YouTube 走 `YouTube`，Google 走 `Google`，国内站点与 Tailscale 直连。
4. 用多个随机域名做 DNS 泄漏测试，并对照 Loon 的 DNS 记录；检测站显示的解析器地区不能单独证明是否明文泄漏。
5. 要证明隧道外没有明文 DNS，需在实际联网接口抓取 TCP / UDP 53 流量；本次未对重连后的流量抓包，未宣称已通过零泄漏验收。

## GitHub 参考仓库

| 仓库 | 用途 | 采用方式 |
| --- | --- | --- |
| [luestr/ProxyResource](https://github.com/luestr/ProxyResource) | Loon 配置及 HTTPDNS / DNS 防泄漏插件入口 | 参考 UDP 拒绝回落、STUN、HTTPDNS 防绕过思路；插件地址返回 403，未导入未检查的插件 |
| [luestr/ShuntRules](https://github.com/luestr/ShuntRules) | 为 Loon 合并上游拆分规则 | 用其说明核对拆分问题，继续用可直接下载的上游文件 |
| [blackmatrix7/ios_rule_script](https://github.com/blackmatrix7/ios_rule_script) | 分流、HTTPDNS 拦截及服务专用规则 | 保留现有来源，补齐拆分域名文件，增加 BlockHttpDNS / Copilot |
| [Loon0x00/LoonManual](https://github.com/Loon0x00/LoonManual) | 官方手册仓库 | 结合当前官方在线文档核对参数，旧仓库部分字段说明较旧 |

当前官方说明：[通用配置](https://nsloon.app/docs/General/)、[DNS 回落](https://nsloon.app/docs/DNS/)、[规则优先级](https://nsloon.app/docs/Rule/)。
