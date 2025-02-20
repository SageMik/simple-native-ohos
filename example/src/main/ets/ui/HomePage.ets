import { TextOverflowPosition } from '@candies/extended_text'
import { HomeViewModel, Tokenizer } from './HomeViewModel'
import { Material3OnPrimaryColor, Material3PrimaryColor, P } from './Theme'
import HighlightText, { ColorfulHighlightText } from './component/HighlightText'
import { DialogHelper } from '@pura/harmony-dialog'
import buildMainTableRowDialog from './component/MainTableRowDialog'
import { IMainTableRowVO } from './model/MainTableRowVO'
import { JSON } from '@kit.ArkTS'

@Entry
@Component
struct HomePage {
  private readonly _viewModel = new HomeViewModel()

  viewModel() {
    return this._viewModel
  }

  uiState() {
    return this.viewModel().uiState
  }

  private readonly tokenizer2string = new Map([
    [Tokenizer.JIEBA, $r("app.string.HomePageTokenizerJieba")],
    [Tokenizer.SIMPLE, $r("app.string.HomePageTokenizerSimple")]
  ])

  aboutToAppear() {
    this.viewModel().insertRandomData()
  }

  build() {
    Navigation() {
      Column({ space: P.Middle }) {
        // 搜索栏
        Search()
          .borderRadius(P.Small)
          .margin({
            left: P.Middle,
            right: P.Middle,
            top: P.Middle,
            bottom: 0
          })
          .onChange((value) => this.uiState().searchValue = value)

        // 搜索栏下方选项
        Row({ space: P.Middle }) {
          Row() {
            Text($r("app.string.HomePageTokenizer"))
            Select(
              Array.from(this.tokenizer2string.values())
                .map<SelectOption>((value) => {
                  return { value: value }
                })
            )
              .value(this.tokenizer2string.get(this.uiState().tokenizer))
              .selected(this.uiState().tokenizer)
              .onSelect((index) => this.uiState().tokenizer = index)
              .controlSize(ControlSize.SMALL)
              .borderRadius(P.Small)
          }

          Blank().layoutWeight(1)
          Button() {
            Text() {
              SymbolSpan($r('sys.symbol.arrow_clockwise')).fontSize(16)
            }.padding(P.ExtraSmall * 2)
          }
          .backgroundColor(Color.Transparent)
          .onClick(() => this.viewModel().updateAll())
        }
        .padding({ left: P.Middle, right: P.Middle })
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        // 搜索结果
        List() {
          ForEach(this.viewModel().results, (row: IMainTableRowVO) => {
            ListItem() {
              Row({ space: P.Small }) {
                Text(row.idFormatted)
                  .fontSize(48)
                  .fontWeight(600)
                  .fontFeature('"ss01" on') // 等宽数字
                Column({ space: P.ExtraSmall }) {
                  Column({ space: P.ExtraSmall }) {
                    HighlightText({
                      text: row.title,
                      fontSize: 20,
                      overflowPosition: TextOverflowPosition.end
                    })
                    HighlightText({
                      text: row.content,
                      fontSize: 12,
                      overflowPosition: ColorfulHighlightText.regExp.test(row.content)
                        ? TextOverflowPosition.auto // 有高亮文本才寻找高亮文本的位置进行显示，否则会崩溃
                        : TextOverflowPosition.end
                    })
                  }
                  .alignItems(HorizontalAlign.Start)

                  Text(row.insertDateFormatted)
                    .fontSize(10)
                    .width('100%')
                    .textAlign(TextAlign.End)
                    .fontColor(Color.Grey)
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .padding({ left: P.Middle, right: P.Middle })
            }
            .onClick(() => {
              const dialogId = "MainTableRowDialog"
              this.getUIContext().getFocusController().clearFocus()
              DialogHelper.showCustomDialog(wrapBuilder(buildMainTableRowDialog), {
                item: row,
                dialogId: dialogId
              })
            })
          }, (item: IMainTableRowVO) => JSON.stringify(item))
        }
        .cachedCount(5)
        .width('100%')
        .height(0)
        .layoutWeight(1)
      }
    }
    .title(NavigationTitle, { backgroundColor: Material3PrimaryColor })
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(true)
    .height('100%')
    .width('100%')
  }
}

@Builder
function NavigationTitle() {
  Column() {
    Text($r("app.string.HomePageAppTitle"))
      .fontColor(Material3OnPrimaryColor)
      .fontWeight(FontWeight.Bolder)
      .fontSize(24)
      .width('100%')
      .padding(P.Middle)
  }
  .justifyContent(FlexAlign.Center)
  .height('100%')
  .width('100%')
}
