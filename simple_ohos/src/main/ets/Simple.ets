import { fileIo as fs } from '@kit.CoreFileKit';
import { deviceInfo } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

export class Simple {
  /**
   * @param context `Application` 或 `Ability` 的上下文。
   * @returns 根据当前设备 ABI 获取的 Simple 分词器原生库路径。若原生库不存在，则返回空值。
   */
  static async getNativeLibraryPath(context: Context): Promise<string> {
    const libSimple = `${context.bundleCodeDir}/libs/${deviceInfo.abiList}/libsimple.so`
    try {
      if (await fs.access(libSimple, fs.AccessModeType.EXIST)) {
        return libSimple
      }
      return ""
    } catch (e) {
      hilog.isLoggable(DOMAIN, TAG, hilog.LogLevel.ERROR)
      hilog.error(DOMAIN, TAG, e)
      return ""
    }
  }
}

const DOMAIN = 0x0A0B
const TAG = Simple.name
