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

class P {
  static readonly MIDDLE = 16
  static readonly SMALL = 8
  static readonly EXTRA_SMALL = 2
}

@Entry
@Component
struct HomePage {
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

  aboutToAppear(): void {
    this.viewModel().insertRandomData()
  }

  build() {
    Navigation() {
      Column() {
        Search()
          .borderRadius(P.SMALL)
          .margin(P.MIDDLE)
          .onChange((value, _) => {
            this.uiState().searchValue = value
            this.viewModel().search()
          })
        // Row() {
        //   Button() {
        //     Text() {
        //       SymbolSpan($r('sys.symbol.rectangle_rotate'))
        //         .fontSize(48)
        //     }
        //   }.onClick(async (_) => {
        //     this.viewModel.updateAll()
        //   })
        // }
        List() {
          ForEach(this.viewModel().results, (item: MainTableRow) => {
            ListItem() {
              Row({ space: P.SMALL }) {
                Text(item.id.toString().padStart(this.viewModel().results.length.toString().length, "0"))
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

                  // Text(`${item.insertDate.toLocaleDateString()}  ${item.insertDate.toLocaleTimeString()}`)
                  //   .fontSize(10)
                  //   .width('100%')
                  //   .textAlign(TextAlign.End)
                  //   .fontColor(Color.Grey)
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
    .title(NavigationTitle, {
      backgroundColor: 0x6750A4
    })
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
  Text("!") // 省略号
}