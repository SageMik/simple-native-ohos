import { TextOverflowPosition } from '@candies/extended_text'
import { MainTableRow } from '../data/MainTableRow'
import { HomeViewModel, Tokenizer } from './HomeViewModel'
import { material3PrimaryColor, P } from './Theme'
import HighlightText, { highlightSpecialText } from './component/HighlightText'


@Entry
@Component
struct HomePage {
  @Builder
  NavigationTitle() {
    Column() {
      Text($r("app.string.HomePageAppTitle"))
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bolder)
        .fontSize(24)
        .width('100%')
        .padding(P.MIDDLE)
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }

  private readonly _viewModel = new HomeViewModel()

  viewModel() {
    return this._viewModel
  }

  uiState() {
    return this.viewModel().uiState
  }

  // readonly dataSource = new DataSource(this.viewModel.results)

  private readonly tokenizer2string = new Map([
    [Tokenizer.JIEBA, $r("app.string.HomePageTokenizerJieba")],
    [Tokenizer.SIMPLE, $r("app.string.HomePageTokenizerSimple")]
  ])

  aboutToAppear(): void {
    this.viewModel().insertRandomData()
  }

  build() {
    Navigation() {
      Column({ space: P.MIDDLE }) {
        // 搜索栏
        Search()
          .borderRadius(P.SMALL)
          .margin({
            left: P.MIDDLE,
            right: P.MIDDLE,
            top: P.MIDDLE,
            bottom: 0
          })
          .onChange((value) => this.uiState().searchValue = value)

        // 搜索栏下方选项
        Row({ space: P.MIDDLE }) {
          Row() {
            Text($r("app.string.HomePageTokenizer"))
            Select(
              Array.from(this.tokenizer2string.values())
                .map<SelectOption>((value, _index) => {
                  return { value: value }
                })
            )
              .value(this.tokenizer2string.get(this.uiState().tokenizer))
              .selected(this.uiState().tokenizer)
              .onSelect((index) => this.uiState().tokenizer = index)
              .controlSize(ControlSize.SMALL)
              .borderRadius(P.SMALL)
          }

          Blank().layoutWeight(1)

          Button() {
            Text() {
              SymbolSpan($r('sys.symbol.arrow_clockwise'))
                .fontSize(16)
            }
            .padding(P.EXTRA_SMALL * 2)
          }
          .backgroundColor(Color.Transparent)
          .onClick((_) => this.viewModel().updateAll())
        }
        .padding({ left: P.MIDDLE, right: P.MIDDLE })
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        // 搜索结果
        List() {
          ForEach(this.viewModel().results, (item: MainTableRow) => {
            ListItem() {
              Row({ space: P.SMALL }) {
                Text(`${item.id}`.padStart(`${this.viewModel().selectCount()}`.length, "0"))
                  .fontSize(48)
                  .fontWeight(600)
                  .fontFeature('"ss01" on') // 等宽数字
                Column({ space: P.EXTRA_SMALL }) {
                  Column({ space: P.EXTRA_SMALL }) {
                    HighlightText({
                      text: item.title,
                      fontSize: 20,
                      overflowPosition: TextOverflowPosition.end
                    })
                    HighlightText({
                      text: item.content,
                      fontSize: 12,
                      overflowPosition: highlightSpecialText.regExp.test(item.content)
                        ? TextOverflowPosition.auto // 有高亮文本才寻找高亮文本的位置进行显示，否则会崩溃
                        : TextOverflowPosition.end
                    })
                  }
                  .alignItems(HorizontalAlign.Start)

                  Text(`${item.insertDate.toLocaleDateString()}  ${item.insertDate.toLocaleTimeString()}`)
                    .fontSize(10)
                    .width('100%')
                    .textAlign(TextAlign.End)
                    .fontColor(Color.Grey)
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)
              }
              .padding({ left: P.MIDDLE, right: P.MIDDLE })
            }
            .onClick(() => {
              // this.dialogController.open()
            })
          })
        }
        .cachedCount(5)
        .width('100%')
        .height(0)
        .layoutWeight(1)
      }
    }
    .title(this.NavigationTitle, { backgroundColor: material3PrimaryColor })
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(true)
    .height('100%')
    .width('100%')
  }
}
