import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { DbManager } from '../data/DbManager';
import { DialogHelper } from '@pura/harmony-dialog';

const DOMAIN = 0x0000;

export const dbManger = new DbManager()

export default class ExampleAbility extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    DialogHelper.setDefaultConfig((config) => {
      config.uiAbilityContext = this.context;
    })
  }


  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    await dbManger.init(this.context)
    windowStage.loadContent('ui/HomePage', new LocalStorage(), (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'Home', `打开失败：${JSON.stringify(err)}`)
        return
      }
    });
  }
}