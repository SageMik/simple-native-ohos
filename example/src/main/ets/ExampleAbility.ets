import { UIAbility } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { DbManager } from './data/DbManager';

const DOMAIN = 0x0000;

export const dbManger = new DbManager()

export default class ExampleAbility extends UIAbility {

  // async openDatabase() {
  //   const resultSet = await this.dbManger.rdbStore.querySql("SELECT simple_query('Simple分词器鸿蒙示例')")
  //   for (let i = 0; i < resultSet.rowCount; i++) {
  //     resultSet.goToRow(i)
  //     const row = resultSet.getRow()
  //     Object.keys(resultSet.getRow()).forEach((key) => {
  //       hilog.info(DOMAIN, "RdbStore", `${key}: ${row[key]}`);
  //     });
  //   }
  // }

  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    await dbManger.init(this.context)
    windowStage.loadContent('HomePage', new LocalStorage(), (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'Home', `打开失败：${JSON.stringify(err)}`)
        return
      }
    });
  }
}