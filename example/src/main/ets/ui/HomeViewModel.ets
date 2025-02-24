import { MainTableRow } from '../data/MainTableRow';
import { dbManger } from './ExampleAbility';
import { IMainTableRowVO } from './model/MainTableRowVO';

export enum Tokenizer {
  JIEBA,
  SIMPLE
}

type MainTableResultArray = IMainTableRowVO[] | undefined
type OnResultsChangedListener = (results: MainTableResultArray) => void

@ObservedV2
export class HomeUiState {
  @Trace searchValue = ""
  @Trace tokenizer = Tokenizer.JIEBA
}

@ObservedV2
export class HomeViewModel {
  readonly uiState = new HomeUiState()
  @Trace results: MainTableResultArray

  private async selectAll() {
    this.results = await this.toMainTableRowVO(
      await dbManger.dao.selectAll()
    )
  }

  private async toMainTableRowVO(rows: MainTableRow[]): Promise<IMainTableRowVO[]> {
    const count = await this.selectCount()
    return rows.map<IMainTableRowVO>((v) => {
      return {
        id: v.id,
        idFormatted: `${v.id}`.padStart(`${count}`.length, '0'),
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

  async insertRandomData(): Promise<void> {
    await dbManger.dao.insertRandomData(30)
    return this.selectAll()
  }

  async updateAll() {
    this.results = undefined
    await dbManger.dao.updateAll()
    return this.search()
  }

  @Monitor("uiState.searchValue", "uiState.tokenizer")
  async search(): Promise<void> {
    const searchValue = this.uiState.searchValue.trim()
    if (searchValue.length === 0) {
      return this.selectAll()
    }
    this.results = await this.toMainTableRowVO(
      await dbManger.dao.search(
        searchValue,
        Tokenizer[this.uiState.tokenizer].toLocaleLowerCase()
      )
    )
  }

  readonly onResultsChangedSet: Set<OnResultsChangedListener> = new Set()

  @Monitor("results")
  onResultsChanged() {
    this.onResultsChangedSet.forEach((l) => l(this.results))
  }
}