import { MainTableRow } from '../../data/MainTableRow';
import { dbManger } from '../ExampleAbility';
import HomeUiState, { Highlight, Tokenizer } from './HomeUiState';

@ObservedV2
export default class HomeViewModel {
  readonly uiState: HomeUiState = new HomeUiState()
  @Trace results: Array<MainTableRow> = []

  selectAll() {
    this.results = dbManger.dao.selectAll()
  }

  insertRandomData() {
    dbManger.dao.insertRandomData(30)
    this.selectAll()
  }

  updateAll() {
    dbManger.dao.updateAll()
    this.selectAll()
  }

  search() {
    if (this.uiState.isSearchValueEmpty()) {
      this.selectAll()
      return
    }
    this.results = dbManger.dao.search(
      this.uiState.searchValue,
      Tokenizer[this.uiState.tokenizer].toLocaleLowerCase()
    )
  }
}