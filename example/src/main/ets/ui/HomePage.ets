import {
  ColorUtils,
  ExtendedText,
  SpecialTextSpanBuilder,
  TextOverflowPosition,
  TextOverflowWidget
} from '@candies/extended_text'
import { MainTableRow } from '../data/MainTableRow'
import { CustomTextSpanBuilder, ZeroWidthText } from '../utils/ZeroWidth'
import HomeViewModel from './viewmodel/HomeViewModel'
import { text } from '@kit.ArkGraphics2D'
import { Tokenizer } from './viewmodel/HomeUiState'

class P {
  static readonly MIDDLE = 16
  static readonly SMALL = 8
  static readonly EXTRA_SMALL = 2
}

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
        .width("100%")
        .padding(P.MIDDLE)
    }
    .justifyContent(FlexAlign.Center)
    .height("100%")
    .width("100%")
  }

  private readonly _viewModel = new HomeViewModel()
  private readonly _highlightTextBuilder = new CustomTextSpanBuilder([
    new ZeroWidthText({
      color: ColorUtils.numberTo2DColor(0xFF0000)
    })
  ]);

  viewModel() {
    return this._viewModel
  }

  uiState() {
    return this.viewModel().uiState
  }

  // readonly dataSource = new DataSource(this.viewModel.results)

  private readonly _tokenizer2string = new Map([
    [Tokenizer.JIEBA, $r("app.string.HomePageTokenizerJieba")],
    [Tokenizer.SIMPLE, $r("app.string.HomePageTokenizerSimple")]
  ])

  aboutToAppear(): void {
    this.viewModel().insertRandomData()
  }

  build() {
    Navigation() {
      Column({ space: P.MIDDLE }) {
        Search()
          .borderRadius(P.SMALL)
          .margin({
            left: P.MIDDLE,
            right: P.MIDDLE,
            top: P.MIDDLE,
            bottom: 0
          })
          .onChange((value, _) => {
            this.uiState().searchValue = value
            this.viewModel().search()
          })

        Row({ space: P.MIDDLE }) {
          SelectInMap({
            label: $r("app.string.HomePageTokenizer"),
            t2string: this._tokenizer2string as Map<ESObject, ResourceStr>,
            getValue: () => this.uiState().tokenizer,
            setValue: (index) => this.uiState().tokenizer = index
          })

          Blank().layoutWeight(1)

          Button() {
            Text() {
              SymbolSpan($r('sys.symbol.arrow_clockwise'))
                .fontSize(16)
            }
            .padding(P.EXTRA_SMALL * 2)
          }
          .backgroundColor(Color.Transparent)
          .onClick(async (_) => {
            this.viewModel().updateAll()
          })
        }
        .padding({ left: P.MIDDLE, right: P.MIDDLE })
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        List() {
          ForEach(this.viewModel().results, (item: MainTableRow) => {
            ListItem() {
              Row({ space: P.SMALL }) {
                Text(item.id.toString()
                  .padStart(this.viewModel()
                    .results
                    .length
                    .toString()
                    .length, "0"))
                  .fontSize(48)
                  .fontWeight(600)
                  .fontFeature('"ss01" on') // 等宽数字
                Column({ space: P.EXTRA_SMALL }) {
                  Column({ space: P.EXTRA_SMALL }) {
                    HighlightText({
                      text: item.title,
                      fontSize: 20,
                      specialTextSpanBuilder: this._highlightTextBuilder,
                      overflowPosition: TextOverflowPosition.end
                    })
                    HighlightText({
                      text: item.content,
                      fontSize: 12,
                      specialTextSpanBuilder: this._highlightTextBuilder,
                      overflowPosition: this.uiState().isSearchValueEmpty()
                        ? TextOverflowPosition.end
                        : TextOverflowPosition.auto
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
          })
        }
        .cachedCount(5)
        .width('100%')
        .height(0)
        .layoutWeight(1)
      }
    }
    .title
    (this
      .NavigationTitle
      , {
        backgroundColor: 0x6750A4
      }

    )
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(true)
    .height('100%')
    .width('100%')
  }
}

@ComponentV2
struct HighlightText {
  @Param @Require readonly text: string
  @Param @Require readonly fontSize: number
  @Param @Require specialTextSpanBuilder: SpecialTextSpanBuilder
  @Param @Require readonly overflowPosition: TextOverflowPosition

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
        maxLines: 1,
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
  Text("\u2026") // 省略号
}


@ComponentV2
struct SelectInMap {
  @Param @Require readonly label: ResourceStr
  @Param @Require readonly t2string: Map<ESObject, ResourceStr>
  @Param @Require readonly getValue: () => ESObject
  @Param @Require readonly setValue: (index: number, value: string) => void

  build() {
    Row() {
      Text(this.label)
      Select(
        Array.from(this.t2string.values())
          .map<SelectOption>((value, _index) => {
            return { value: value }
          })
      )
        .value(this.t2string.get(this.getValue()))
        .selected(this.getValue())
        .onSelect(this.setValue)
        .controlSize(ControlSize.SMALL)
        .borderRadius(P.SMALL)
    }
  }
}
