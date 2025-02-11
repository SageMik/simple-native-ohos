import { MainTableRow } from '../data/MainTableRow'
import HomeViewModel from './viewmodel/HomeViewModel'

class P {
  static readonly MIDDLE = 16
  static readonly SMALL = 8
  static readonly EXTRA_SMALL = 2
}

@Entry
@Component
struct HomePage {
  readonly viewModel = new HomeViewModel()

  get uiState() {
    return this.viewModel.uiState
  }

  // readonly dataSource = new DataSource(this.viewModel.results)


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

  aboutToAppear(): void {
    this.viewModel.insertRandomData()
  }

  build() {
    Navigation() {
      Column() {
        Search()
          .borderRadius(P.SMALL)
          .margin(P.MIDDLE)
          .onChange((value, _) => this.viewModel.search(value))
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
          ForEach(this.viewModel.results, (item: MainTableRow) => {
            ListItem() {
              Row({ space: P.SMALL }) {
                Text(item.id.toString().padStart(this.viewModel.selectCount().toString().length, "0"))
                  .fontSize(48)
                  .fontWeight(600)
                  .fontFeature('"ss01" on') // 等宽数字
                Column({ space: P.EXTRA_SMALL }) {
                  Scroll() {
                    Column({ space: P.EXTRA_SMALL }) {
                      Text(item.title)
                        .fontSize(20)
                        .fontWeight(FontWeight.Medium)
                        .maxLines(1)
                      Text(item.content)
                        .fontSize(12)
                        .maxLines(1)
                    }
                    .alignItems(HorizontalAlign.Start)
                  }
                  .scrollable(ScrollDirection.Horizontal)
                  .scrollBar(BarState.Off)

                  Text(`${item.insertDate.toLocaleDateString()}  ${item.insertDate.toLocaleTimeString()}`)
                    .fontSize(10)
                    .width('100%')
                    .textAlign(TextAlign.End)
                    .fontColor(Color.Grey)
                }
                .alignItems(HorizontalAlign.Start)
                .width(0)
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
    .title(this.NavigationTitle, {
      backgroundColor: 0x6750A4
    })
    .titleMode(NavigationTitleMode.Mini)
    .hideBackButton(true)
    .height('100%')
    .width('100%')
  }
}