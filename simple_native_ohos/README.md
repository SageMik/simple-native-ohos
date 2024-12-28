# simple-native-ohos

```shell
ohpm install simple-native-ohos
```

[Simple](https://github.com/wangfenjin/simple) 的 HarmonyOS 原生库，用于 [sqlite3_simple](https://github.com/SageMik/sqlite3_simple) Flutter 插件，与 [simple-native-android](https://github.com/SageMik/simple-native-android) 编译同步。

目前，尽管 HarmonyOS 自带的 SQLite 支持 FTS5，但无法加载自定义分词器，因而无法通过 `@ohos.data.relationalStore` 使用。这应该与 [其使用的编译选项](https://gitee.com/openharmony/third_party_sqlite) 有关。
