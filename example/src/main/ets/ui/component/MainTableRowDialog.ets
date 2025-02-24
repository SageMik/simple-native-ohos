import { TextOverflowPosition } from '@candies/extended_text'
import HighlightText, { ColorfulHighlightText } from './HighlightText'
import { text } from '@kit.ArkGraphics2D'
import { P } from '../Theme'
import { DialogHelper } from '@pura/harmony-dialog'
import { IMainTableRowVO } from '../model/MainTableRowVO'

export interface MainTableRowDialogOption {
  item: IMainTableRowVO;
  dialogId: string;
}

@Builder
export default function buildMainTableRowDialog(option: MainTableRowDialogOption) {
  Column({ space: P.Small + P.ExtraSmall }) {
    Text(option.item.idFormatted)
      .fontSize(64)
      .fontWeight(600)
      .fontFeature('"ss01" on')
    HighlightText({
      text: option.item.title,
      fontSize: 28,
      overflowPosition: TextOverflowPosition.end,
      maxLines: undefined,
      textAlign: text.TextAlign.CENTER
    })
    HighlightText({
      text: option.item.content,
      fontSize: 18,
      overflowPosition: ColorfulHighlightText.regExp.test(option.item.content)
        ? TextOverflowPosition.auto
        : TextOverflowPosition.end,
      maxLines: undefined
    })
    Button($r('app.string.HomePageDialogConfirm'))
      .onClick(() => DialogHelper.closeDialog(option.dialogId))
      .type(ButtonType.Normal)
      .borderRadius(P.Small)
      .backgroundColor(0x6750A4)
      .width('100%')
  }
  .padding(P.Middle)
  .backgroundColor(Color.White)
}
