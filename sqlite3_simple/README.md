# sqlite3-simple

[![OpenHarmony 三方库中心仓](https://img.shields.io/badge/dynamic/json?label=OpenHarmony%20%E4%B8%89%E6%96%B9%E5%BA%93%E4%B8%AD%E5%BF%83%E4%BB%93&style=for-the-badge&logo=harmonyos&url=https%3A%2F%2Fohpm.openharmony.cn%2Fohpmweb%2Fregistry%2Foh-package%2Fopenapi%2Fv1%2Fdetail%2Fsqlite3-simple&query=%24.body.version)](https://ohpm.openharmony.cn/#/cn/detail/sqlite3-simple)

基于 [Simple](https://github.com/wangfenjin/simple) (支持中文和拼音的 SQLite fts5 全文搜索扩展) 的 HarmonyOS NEXT 库，用于 [@ohos.data.relationalStore (关系型数据库)](https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/js-apis-data-relationalstore-V5?catalogVersion=V5) 的中文和拼音全文搜索。

| 示例                                        | 示例                                        |
|-------------------------------------------|-------------------------------------------|
| ![1.png](../sqlite3_simple/example/1.png) | ![2.png](../sqlite3_simple/example/2.png) |

## 目录

- [前置准备](#前置准备)
- [快速开始](#快速开始)
  - [1. 添加本库](#1-添加本库)
  - [2. 作为数据库插件加载](#2-作为数据库插件加载)
  - [3. 查询](#3-查询)
- [致谢](#致谢)
- [相关项目](#相关项目)

## 前置准备

SQLite 通过 [SQLite FTS5 Extension](https://sqlite.org/fts5.html) 提供 全文搜索 (Full-Text Search) 功能；

[Simple](https://github.com/wangfenjin/simple) 在 FTS5 的基础上扩展支持了中文和拼音全文搜索。

为支持 [Simple](https://github.com/wangfenjin/simple) 在鸿蒙平台上的使用，本库通过 [simple-native-ohos](../simple_native_ohos) 维护原生库，编译脚本在 [simple-native](https://github.com/SageMik/sqlite3_simple/tree/simple-native) 。

请参阅相关文档，或 [`example`](../example) 的具体示例，以构建和管理数据库。

## 快速开始

### 1. 添加本库

```shell
ohpm install sqlite3-simple
```

### 2. 作为数据库插件加载

通过 `Simple.getNativeLibraryPath(context)` 获取 Simple 原生库路径，并将其作为数据库插件配置加载，例如 [`../example/src/main/ets/data/DbManager.ets`](../example/src/main/ets/data/DbManager.ets) ：

```typescript
import { Simple } from 'sqlite3-simple';

const libSimple = await Simple.getNativeLibraryPath(context)
const storeConfig: relationalStore.StoreConfig = {
    name: "example.db",
    securityLevel: relationalStore.SecurityLevel.S1,
    pluginLibs: [libSimple]
}
this._db = await relationalStore.getRdbStore(context, storeConfig)
```

如需启用 结巴分词 (Jieba) ，请通过 `Simple.getJiebaDictPath(context)` 获取结巴分词字典文件路径，并执行如下 SQL 语句修改 Simple 扩展查找字典文件的路径：

```typescript
await this.db.executeSql("SELECT jieba_dict(?)", [Simple.getJiebaDictPath(context)])
```

推荐在正式查询前执行一次查询，例如：

```typescript
this.db.querySql("SELECT jieba_query('Jieba分词初始化（提前加载避免后续等待）')")
  .then((resultSet) => {
    resultSet.goToFirstRow()
    hilog.debug(0xABCD, DbManager.name, JSON.stringify(Object.entries(resultSet.getRow())))
  });
```

### 3. 查询

请参阅 [SQLite FTS5 Extension](https://sqlite.org/fts5.html) 和 [Simple](https://github.com/wangfenjin/simple) 的说明，根据需要调用相应函数如 `jieba_query`、`simple_query`、`highlight`、  `simple_highlight` 等，执行所需的查询，例如 [`../example/src/main/ets/data/MainTableDao.ets`](../example/src/main/ets/data/MainTableDao.ets) ：

```typescript
/**
 * 通过指定分词器 `tokenizer` 搜索
 * @param value 关键词
 * @param tokenizer 分词器，取值：jieba, simple
 * @returns 搜索结果
 */
async search(value: string, tokenizer: string): Promise<MainTableRow[]> {
  const wrapperSql = `'${ZeroWidth.start}', '${ZeroWidth.end}'`
  const resultSet = await this.db.querySql(`
    SELECT
      rowid AS ${id},
      simple_highlight(${fts5Table}, 0, ${wrapperSql}) AS ${title},
      simple_highlight(${fts5Table}, 1, ${wrapperSql}) AS ${content},
      ${insertDate}
    FROM ${fts5Table}
    WHERE ${fts5Table} MATCH ${tokenizer}_query(?);
  `, [value])
  return this.toMainTableRows(resultSet)
}
```

## 致谢

[Simple](https://github.com/wangfenjin/simple)：支持中文和拼音的 SQLite FTS5 全文搜索扩展。

[extended_text](https://github.com/HarmonyCandies/extended_text)：一个文本组件，支持特殊文本效果。

[harmony-dialog](https://gitee.com/tongyuyan/harmony-utils/tree/master/harmony_dialog)：一款极为简单易用的零侵入弹窗，仅需一行代码即可轻松实现，无论在何处都能够轻松弹出。

## 相关项目

[sqlite3_simple](https://github.com/SageMik/sqlite3_simple)：基于 [Simple](https://github.com/wangfenjin/simple) (支持中文和拼音的 SQLite fts5 全文搜索扩展) 和 [sqlite3.dart](https://github.com/simolus3/sqlite3.dart) 的 Flutter 库，用于 SQLite 中文和拼音全文搜索。
