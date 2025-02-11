import { MainTableRow } from "../../data/MainTableRow";
import { dbManger } from "../ExampleAbility";
import { Type } from "@ohos.arkui.StateManagement";

@ObservedV2
export default class HomeViewModel {
  @Trace results: Array<MainTableRow> = []

  selectAll() {
    this.results = dbManger.dao.selectAll()
  }

  selectCount(): number {
    return dbManger.dao.selectCount()
  }

  insertRandomData() {
    dbManger.dao.insertRandomData(30)
    this.selectAll()
  }

  updateAll() {
    dbManger.dao.updateAll()
    this.selectAll()
  }
}