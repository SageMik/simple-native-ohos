import {
  ColorUtils,
  ExtendedText,
  InlineSpan,
  RegExpSpecialText,
  RegExpSpecialTextSpanBuilder,
  SpecialTextSpanBuilder,
  TextOverflowPosition,
  TextOverflowWidget,
  TextSpan
} from '@candies/extended_text'
import { text } from '@kit.ArkGraphics2D'
import { mergeNonNull } from '../../utils/MergeNonNull';
import { ZeroWidth } from '../../utils/ZeroWidth';

export class HighlightSpecialText extends RegExpSpecialText {
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
      text: match[1],
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


export const highlightSpecialText = new HighlightSpecialText({
  color: ColorUtils.numberTo2DColor(0xFF0000)
})

export const highlightTextBuilder = new CustomTextSpanBuilder([highlightSpecialText]);

@ComponentV2
export default struct HighlightText {
  @Param @Require readonly text: string
  @Param @Require readonly fontSize: number
  @Param readonly specialTextSpanBuilder: SpecialTextSpanBuilder = highlightTextBuilder
  @Param @Require readonly overflowPosition: TextOverflowPosition
  @Param readonly maxLines: number = 1
  @Param readonly textAlign: text.TextAlign | undefined = undefined

  build() {
    ExtendedText({
      text: this.text,
      specialTextSpanBuilder: this.specialTextSpanBuilder,
      paragraphStyle: {
        textStyle: {
          color: ColorUtils.resourceColorTo2DColor($r('sys.color.font'), getContext(this)),
          fontSize: vp2px(this.fontSize),
          fontWeight: text.FontWeight.W500
        },
        align: this.textAlign,
        maxLines: this.maxLines,
      },
      overflowWidget: new TextOverflowWidget({
        builder: wrapBuilder(buildEllipsisText),
        position: this.overflowPosition
      }),
    })
  }
}

@Builder
function buildEllipsisText() {
  Text("...")
}
