import { fileIo as fs } from '@kit.CoreFileKit';
import { deviceInfo } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class Simple {
  private static readonly _supportedAbiArray = ["x86_64", "arm64"]

  /**
   * @param context `Application` 或 `Ability` 的上下文。
   * @returns 根据当前设备 ABI 获取的 Simple 分词器原生库路径。若原生库不存在，则返回空字符串。打开数据库时，将其作为 `relationalStore.StoreConfig.pluginLibs` 数据库插件配置传入，即可使用 Simple 分词器。
   */
  static async getNativeLibraryPath(context: Context): Promise<string> {
    const currentAbi = deviceInfo.abiList
    const supportedAbi = Simple._supportedAbiArray.find((value) => currentAbi.startsWith(value)) ?? currentAbi
    const libSimple = `${context.bundleCodeDir}/libs/${supportedAbi}/libsimple.so`
    try {
      if (await fs.access(libSimple, fs.AccessModeType.EXIST)) {
        return libSimple
      }
      hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.ERROR)
      hilog.error(DOMAIN, TAG, `找不到 Simple ${supportedAbi} 原生库`)
      return ""
    } catch (e) {
      hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.ERROR)
      hilog.error(DOMAIN, TAG, e)
      return ""
    }
  }

  /**
   * @param context `Application` 或 `Ability` 的上下文。
   * @returns 获取本库内置的结巴分词字典文件的存放位置。若要启用结巴分词，请执行 `SELECT jieba_dict('${Simple.getJiebaDictPath(context)}')` SQL 语句。
   */
  static getJiebaDictPath(context: Context): string {
    return `${context.resourceDir}/cpp_jieba_dict`
  }
}

const DOMAIN = 0x0A0B
const TAG = Simple.name
