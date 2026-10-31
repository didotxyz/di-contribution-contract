# DI 贡献存证合约 · 审计源码包

[English](README.md) · [简体中文](README_CN.md)

这个独立公开仓库供审计方审查 **DIContributionRegistry**。这是送审材料，**不是已审计通过的声明**。

## 审计入口

- [主合约源码](contracts/DIContributionRegistry.sol)
- [ERC1967Proxy 代理源码](contracts/vendor/openzeppelin-5.4.0/@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol)
- [完整编译输入 Standard JSON](artifacts/standard-input.json)
- [ABI、字节码、存储布局和 immutable 位置](artifacts/registry-artifact.json)
- [BSC 部署记录摘要](deployments/bsc-mainnet.json)
- [审计范围与信任边界](AUDIT_SCOPE.md)

用户实际调用、状态及事件记录所在的代理地址：

```text
0x99eF9777462152Fe2d0271FC326022a639B3810b
```

部署记录中的逻辑实现地址：

```text
0xD4ec25b03926cb2452BD57B88931b3cAf8CA31bF
```

两者是同一套 UUPS 可升级存证功能。地址来自 2026-10-17 部署记录；本次导出没有重新查询当前实现槽、管理员或浏览器源码验证状态，请审计方独立核实。

## 合约做什么

用户自付 Gas，通过代理调用 `contribute(commitment, protocolVersion)`，写入钱包与承诺哈希的映射并产生 `ContributionRecorded` 事件。协议版本为 1；空哈希、错误协议版本和同钱包同哈希的重复提交会失败。

报告正文、问题、训练数据、UID 和积分不写入本合约。用户授权、报告归属、贡献快照、后台链核验和积分结算属于链下产品。链上存在一个哈希不等于内容真实、已经训练或已被量化采用。

## 如何复现编译

使用 Solidity **0.8.30+commit.73712a01**，优化 200 次，EVM Paris，`bytecodeHash=none`、`appendCBOR=false`。完整输入包含主合约和 OpenZeppelin 5.4.0 的 14 份固定依赖源码。

```sh
solc --version
solc --standard-json < artifacts/standard-input.json > compiler-output.json
shasum -a 256 -c SHA256SUMS
```

2026-10-31 已用现有固定版本 solc-js 离线复编，主合约与代理 ABI、创建/运行字节码，以及主合约存储布局和 immutable 引用均匹配保存产物。该结果仅证明编译一致，不代表安全审计、当前链上状态核验或重新跑过 EVM 测试。

本仓库仅包含合约审计范围，不包含应用测试框架、生产配置、密钥或用户数据。审计方可直接下载或克隆，不需要访问产品私有仓库。建议同时检查管理员升级能力与链下信任边界；细项见 AUDIT_SCOPE.md。
