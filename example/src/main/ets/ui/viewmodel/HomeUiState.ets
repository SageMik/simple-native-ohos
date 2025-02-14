export enum Tokenizer {
  JIEBA,
  SIMPLE
}

export enum Highlight {
  NORMAL,
  SIMPLE
}

@ObservedV2
export default class HomeUiState {
  @Trace searchValue = ""
  @Trace tokenizer = Tokenizer.JIEBA
  @Trace highlight = Highlight.NORMAL

  isSearchValueEmpty() {
    return this.searchValue.trim().length === 0
  }
}