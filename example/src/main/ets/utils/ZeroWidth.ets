import { InlineSpan, RegExpSpecialText, RegExpSpecialTextSpanBuilder, TextSpan } from '@candies/extended_text';
import text from '@ohos.graphics.text';
import { mergeNonNull } from './MergeNonNull';

export class ZeroWidth {
  private constructor() {
  }

  static readonly start = "\u200B"
  static readonly end = "\u200C"
}