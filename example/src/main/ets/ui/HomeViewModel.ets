import { MainTableRow } from '../data/MainTableRow';
import { dbManger } from './ExampleAbility';

export enum Tokenizer {
  JIEBA,
  SIMPLE
}

@ObservedV2
export class HomeUiState {
  @Trace searchValue = ""
  @Trace tokenizer = Tokenizer.JIEBA

  isSearchValueEmpty() {
    return this.searchValue.trim().length === 0
  }
}

@ObservedV2
export class HomeViewModel {
  readonly uiState: HomeUiState = new HomeUiState()
  @Trace results: Array<MainTableRow> = []

  private _selectAll() {
    this.results = dbManger.dao.selectAll()
  }

  selectCount() {
    return dbManger.dao.selectCount()
  }

  insertRandomData() {
    dbManger.dao.insertRandomData(30)
    this._selectAll()
  }

  updateAll() {
    dbManger.dao.updateAll()
    this.search()
  }

  @Monitor("uiState.searchValue", "uiState.tokenizer")
  search() {
    if (this.uiState.isSearchValueEmpty()) {
      this._selectAll()
      return
    }
    this.results = dbManger.dao.search(
      this.uiState.searchValue,
      Tokenizer[this.uiState.tokenizer].toLocaleLowerCase()
    )
  }
}