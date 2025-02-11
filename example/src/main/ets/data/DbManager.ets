import { relationalStore } from '@kit.ArkData';
import { Simple } from 'simple-ohos';
import { MainTableDao } from './MainTableDao';

export class DbManager {
  private _dao?: MainTableDao
  private _rdbStore?: relationalStore.RdbStore

  get dao(): MainTableDao {
    return this._dao!!
  }

  get rdbStore(): relationalStore.RdbStore {
    return this._rdbStore!!
  }

  async init(context: Context) {
    if (this._dao) {
      return
    }
    await relationalStore.deleteRdbStore(context, "example.db")
    const LIB_SIMPLE = await Simple.getNativeLibraryPath(context)
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "example.db",
      securityLevel: relationalStore.SecurityLevel.S1,
      pluginLibs: [LIB_SIMPLE]
    }
    this._rdbStore = await relationalStore.getRdbStore(context, STORE_CONFIG)
    this._dao = new MainTableDao(this.rdbStore)
  }
}