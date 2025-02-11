import { relationalStore } from '@kit.ArkData';
import { Simple } from 'sqlite3_simple';
import { MainTableDao } from './MainTableDao';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { JSON } from '@kit.ArkTS';

export class DbManager {
  private _dao?: MainTableDao
  private _db?: relationalStore.RdbStore

  get dao(): MainTableDao {
    return this._dao!!
  }

  get db(): relationalStore.RdbStore {
    return this._db!!
  }

  async init(context: Context) {
    if (this._dao) {
      return
    }
    await relationalStore.deleteRdbStore(context, "example.db")

    // 加载 Simple 扩展
    const LIB_SIMPLE = await Simple.getNativeLibraryPath(context)
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: "example.db",
      securityLevel: relationalStore.SecurityLevel.S1,
      pluginLibs: [LIB_SIMPLE]
    }
    this._db = await relationalStore.getRdbStore(context, STORE_CONFIG)

    // 修改 Simple 加载结巴分词字典的路径
    await this.db.executeSql(`SELECT jieba_dict(?)`, [Simple.getJiebaDictPath(context)])
    this.db.querySql("SELECT jieba_query('Jieba分词初始化（提前加载避免后续等待）')")
      .then((resultSet) => {
        resultSet.goToFirstRow()
        hilog.debug(0xABCD, DbManager.name, JSON.stringify(Object.entries(resultSet.getRow())))
      });

    this._dao = new MainTableDao(this.db)
  }
}