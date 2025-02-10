import { MainTableRow } from "./data/MainTableRow";
import { dbManger } from "./ExampleAbility";

@ObservedV2
export class HomeViewModel {
  @Trace results: Array<MainTableRow> = []

  constructor() {
    this.selectAll()
  }

  selectAll() {
    this.results = dbManger.dao.selectAll()
  }
}