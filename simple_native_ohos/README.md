# simple-native-ohos

[![OpenHarmony 三方库中心仓](https://img.shields.io/badge/dynamic/json?label=OpenHarmony%20%E4%B8%89%E6%96%B9%E5%BA%93%E4%B8%AD%E5%BF%83%E4%BB%93&style=for-the-badge&logo=harmonyos&url=https%3A%2F%2Fohpm.openharmony.cn%2Fohpmweb%2Fregistry%2Foh-package%2Fopenapi%2Fv1%2Fdetail%2Fsimple-native-ohos&query=%24.body.version)](https://ohpm.openharmony.cn/#/cn/detail/simple-native-ohos)

[Simple](https://github.com/wangfenjin/simple) 的 HarmonyOS NEXT 原生库，与 [simple-native-android](https://github.com/SageMik/simple-native-android) 同步。

```shell
ohpm install simple-native-ohos
```

有关如何使用 Simple 原生库，请参考 [sqlite3_simple](../sqlite3_simple)、[example](../example) 模块，其中：

1. [sqlite3_simple](../sqlite3_simple) 依赖于本库，其 [`Simple.getNativeLibraryPath()`](../sqlite3_simple/src/main/ets/Simple.ets) 展示了如何获取 Simple 原生库路径。
2. [example](../example) 基于 [sqlite3_simple](../sqlite3_simple) ，展示了如何将 Simple 原生库加载到数据库中。

## 相关项目

[simple-native](https://github.com/SageMik/sqlite3_simple/tree/simple-native)：维护和编译不同平台的 [Simple](https://github.com/wangfenjin/simple) 原生库。