export enum Tokenizer {
  JIEBA,
  SIMPLE
}

@ObservedV2
export default class HomeUiState {
  @Trace tokenizer = Tokenizer.JIEBA
  @Trace isHighlight = true
}