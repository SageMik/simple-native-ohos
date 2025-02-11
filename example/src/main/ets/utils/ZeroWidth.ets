import { InlineSpan, RegExpSpecialText, RegExpSpecialTextSpanBuilder, TextSpan } from '@candies/extended_text';
import text from '@ohos.graphics.text';
import { mergeNonNull } from './MergeNonNull';

export class ZeroWidth {
  private constructor() {
  }

  static readonly start = "\u200B"
  static readonly end = "\u200C"
}

export class ZeroWidthText extends RegExpSpecialText {
  readonly textStyle: text.TextStyle;

  constructor(textStyle: text.TextStyle) {
    super()
    this.textStyle = textStyle
  }

  get regExp(): RegExp {
    return new RegExp(`${ZeroWidth.start}(.*?)${ZeroWidth.end}`, "g")
  }

  finishText(start: number,
    match: RegExpExecArray,
    context: Context,
    textStyle?: text.TextStyle
  ): InlineSpan {
    return new TextSpan({
      text: match[0],
      style: mergeNonNull(textStyle, this.textStyle),
      actualText: match[0],
      start: start,
      keepVisible: true,
    });
  }
}

export class CustomTextSpanBuilder extends RegExpSpecialTextSpanBuilder {
  private readonly _custom: Array<RegExpSpecialText>

  constructor(custom: Array<RegExpSpecialText>) {
    super()
    this._custom = custom
  }

  get regExps() {
    return this._custom;
  }
}