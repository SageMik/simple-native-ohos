export enum Tokenizer {
  JIEBA,
  SIMPLE
}

@ObservedV2
export default class HomeUiState {
  @Trace searchValue = ""
  @Trace tokenizer = Tokenizer.JIEBA
  @Trace isHighlight = true

  isSearchValueEmpty() {
    return this.searchValue.trim().length === 0
  }
}