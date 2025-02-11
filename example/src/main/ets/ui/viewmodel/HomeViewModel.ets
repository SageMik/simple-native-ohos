import { MainTableRow } from '../../data/MainTableRow';
import { dbManger } from '../ExampleAbility';
import HomeUiState, { Tokenizer } from './HomeUiState';

@ObservedV2
export default class HomeViewModel {
  readonly uiState = new HomeUiState()
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

  search(value: string) {
    if (value.trim().length === 0) {
      this.selectAll()
      return
    }
    this.results = dbManger.dao.search(value, Tokenizer[this.uiState.tokenizer])
  }
}