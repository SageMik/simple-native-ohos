import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { Simple } from 'simple-ohos';
import { relationalStore } from '@kit.ArkData';

const DOMAIN = 0x0000;

export default class ExampleAbility extends UIAbility {
  async openDatabase() {
    const libSimple = await Simple.getNativeLibraryPath(this.context) ?? ""
    const dbConfig: relationalStore.StoreConfig = {
      name: "example.db",
      pluginLibs: [libSimple],
      securityLevel: relationalStore.SecurityLevel.S1
    }
    relationalStore.getRdbStore(this.context, dbConfig, async (err, rdbStore) => {
      if (err) {
        hilog.error(DOMAIN, 'RdbStore', `打开失败：${JSON.stringify(err)}`)
        return
      }
      const resultSet = await rdbStore.querySql("SELECT simple_query('Simple分词器鸿蒙示例')")
      for (let i = 0; i < resultSet.rowCount; i++) {
        resultSet.goToRow(i)
        const row = resultSet.getRow()
        Object.keys(resultSet.getRow()).forEach((key) => {
          hilog.info(DOMAIN, "RdbStore", `${key}: ${row[key]}`);
        });
      }
    })
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.openDatabase()
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'Home', `打开失败：${JSON.stringify(err)}`)
        return
      }
    });
  }
}
