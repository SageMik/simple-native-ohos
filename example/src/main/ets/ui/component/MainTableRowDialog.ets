import { TextOverflowPosition } from '@candies/extended_text'
import { MainTableRow } from '../../data/MainTableRow'
import HighlightText, { highlightSpecialText } from './HighlightText'
import { text } from '@kit.ArkGraphics2D'
import { P } from '../Theme'

@CustomDialog
struct MainTableRowDialog {
  controller?: CustomDialogController
  @Prop item: MainTableRow
  @Prop itemCount: number = 30

  build() {
    Column({ space: P.SMALL + P.EXTRA_SMALL }) {
      Text(`${this.item.id}`.padStart(`${this.itemCount}`.length, "0"))
        .fontSize(64)
        .fontWeight(600)
        .fontFeature('"ss01" on')
      HighlightText({
        text: this.item.title,
        fontSize: 28,
        overflowPosition: TextOverflowPosition.end,
        maxLines: undefined,
        textAlign: text.TextAlign.CENTER
      })
      HighlightText({
        text: this.item.content,
        fontSize: 18,
        overflowPosition: highlightSpecialText.regExp.test(this.item.content)
          ? TextOverflowPosition.auto // 有高亮文本才寻找高亮文本的位置进行显示，否则会崩溃
          : TextOverflowPosition.end,
        maxLines: undefined
      })
      Button($r('app.string.HomePageDialogConfirm'))
        .onClick(() => this.controller?.close())
        .type(ButtonType.Normal)
        .borderRadius(P.SMALL)
        .backgroundColor(0x6750A4)
        .width('100%')
    }
    .padding(P.MIDDLE)
  }
}
