import { MainTableRow } from '../data/MainTableRow';
import { mergeNonNull } from '../utils/MergeNonNull';
import { dbManger } from './ExampleAbility';
import { IMainTableRowVO } from './model/MainTableRowVO';

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
  @Trace results: IMainTableRowVO[] = []

  private selectAll() {
    this.results = this.toMainTableRowVO(dbManger.dao.selectAll())
  }

  private toMainTableRowVO(rows: MainTableRow[]): IMainTableRowVO[] {
    return rows.map<IMainTableRowVO>((v) => {
      return {
        id: v.id,
        idFormatted: `${v.id}`.padStart(`${this.selectCount()}`.length, '0'),
        title: v.title,
        content: v.content,
        insertDate: v.insertDate,
        insertDateFormatted: `${v.insertDate.toLocaleDateString()}  ${v.insertDate.toLocaleTimeString()}`
      }
    })
  }

  selectCount() {
    return dbManger.dao.selectCount()
  }

  insertRandomData() {
    dbManger.dao.insertRandomData(30)
    this.selectAll()
  }

  updateAll() {
    dbManger.dao.updateAll()
    this.search()
  }

  @Monitor("uiState.searchValue", "uiState.tokenizer")
  search() {
    if (this.uiState.isSearchValueEmpty()) {
      this.selectAll()
      return
    }
    this.results = this.toMainTableRowVO(
      dbManger.dao.search(
        this.uiState.searchValue,
        Tokenizer[this.uiState.tokenizer].toLocaleLowerCase()
      )
    )
  }
}