# #91 CI action error: Extract container image digest from bake output

## 现象

在 GitHub Actions CI 运行时，步骤 `Extract container image digest from bake output` 稳定失败，报错：

```
/home/runner/work/_temp/00e2f62c-b993-48c5-9b72-4c5ac9d5d463.sh: line 277: syntax error near unexpected token `<'
##[error]Process completed with exit code 2.
```

触发场景为 dependabot PR（如 `build(action): bump softprops/action-gh-release from 2 to 3`，PR #89）触发的 `docker-buildx-bake-hubdocker-latest` 工作流。

## 根因

问题出在以下步骤（`docker-buildx-bake-hubdocker-latest.yml` / `docker-buildx-bake-hubdocker-tag.yml`）：

```yaml
- name: Extract container image digest from bake output
  id: bake-output-container-image-digest
  run: |
    echo "digest=$(echo '${{ steps.bake.outputs.metadata }}' | jq -cr '.["${{ inputs.docker_bake_targets }}"]["containerimage.digest"]')" >>$GITHUB_OUTPUT
```

这里通过 `${{ steps.bake.outputs.metadata }}` **直接把 bake 输出的 metadata JSON 内联进 bash 单引号字符串**。

`steps.bake.outputs.metadata` 的内容并非纯净的镜像 digest 表，它还包含 `buildx.build.provenance` 字段，而 provenance 里嵌入了**完整的 GitHub 事件 payload**（`github_event_payload`），其中包含触发该次构建的 PR body 文本。

dependabot 生成的 PR body 是 Markdown + HTML 混合文本，例如：

```
Bumps [softprops/action-gh-release](https://github.com/softprops/action-gh-release) from 2 to 3.
<details>
<summary>Release notes</summary>
<p><em>Sourced from <a href="...">softprops/action-gh-release's releases</a>.</em></p>
...
```

这段文本中：

1. `action-gh-release's` 的 **单引号（apostrophe）** 提前关闭了 bash 的 `echo '...'` 单引号上下文。
2. 随后的 `<details>`、`</a>` 等 HTML 标签的 `<` 被 bash 解释为**输入重定向**，于是报 `syntax error near unexpected token '<'`。

简而言之：**把不可信/未转义的富文本（PR body）直接拼进 shell 单引号字符串，导致 shell 语法被破坏。** 这是一个 GitHub Actions 表达式注入（expression injection）类问题，触发条件是 provenance 中携带的 event payload 含单引号或 `<`/`>` 字符（dependabot PR body 几乎必然命中）。

## 影响

- 所有由 dependabot PR 触发的 `latest` 构建在 digest 提取步骤失败（exit code 2）。
- 由于该步骤在 `build` job 内，会导致后续 `merge` / push 流程被阻断，`latest` / `latest-just` 镜像无法发布。
- 普通提交（非 dependabot、PR body 无特殊字符）通常不触发，属于"稳定偶发"型故障。

## 修复方案

核心原则：**不要把 workflow 表达式直接拼接进 shell 命令字符串**，应通过 `env:` 上下文把值作为环境变量传给 shell，shell 再从环境变量读取（环境变量内容不会被 shell 二次解析）。

修复后写法：

```yaml
- name: Extract container image digest from bake output
  id: bake-output-container-image-digest
  env:
    BAKE_METADATA: ${{ steps.bake.outputs.metadata }}
    BAKE_TARGET: ${{ inputs.docker_bake_targets }}
  run: |
    echo "digest=$(echo "$BAKE_METADATA" | jq -cr '.["'"$BAKE_TARGET"'"]["containerimage.digest"]')" >>$GITHUB_OUTPUT
```

要点：

1. `BAKE_METADATA` 通过 `env:` 注入，其内容（即使含单引号、`<`、`>`）不会被 shell 当作命令语法解析。
2. `jq` 的目标键改用 `'"$BAKE_TARGET"'` 拼接（关闭单引号、进入双引号变量展开、再回到单引号），避免 `${{ }}` 直接出现在命令行。
3. 该模式是 GitHub Actions 处理"任意文本插值"的推荐做法，可彻底消除表达式注入与 shell 引号冲突。

> 备选方案（更彻底）：让 `docker/bake-action` 直接输出到文件（`set: *.output=type=oci,...` 或使用 `metadata-file`），再 `jq` 读取文件，完全不经过 shell 字符串。本次修复采用最小改动的 `env:` 方案。

## 涉及文件

- `.github/workflows/docker-buildx-bake-hubdocker-latest.yml` — `Extract container image digest from bake output` 步骤
- `.github/workflows/docker-buildx-bake-hubdocker-tag.yml` — 同名步骤

两处实现一致，需同步修改。

## 验证

- 本地无法直接触发 GitHub Actions，需推送修复后由 dependabot PR（或任意 PR）触发 CI 验证。
- 验证标准：`Extract container image digest from bake output` 步骤成功输出 `digest=sha256:...`，后续 `Export digest` / `Upload digest` 正常完成。
- 回归用例：用一个 body 含单引号 + HTML 标签的 PR 触发构建，确认不再报 `syntax error near unexpected token`。
