import { MainTableRow } from '../data/MainTableRow'
import DataSource from './model/DataSource'
import HomeViewModel from './viewmodel/HomeViewModel'

class P {
  static readonly MIDDLE = 16
  static readonly SMALL = 8
}

@Entry
@Component
struct HomePage {
  readonly viewModel = new HomeViewModel()
  readonly dataSource = new DataSource(() => this.viewModel.results)

  @Builder
  NavigationTitle() {
    Column() {
      Text($r("app.string.HomePageAppTitle"))
        .fontColor(Color.White)
        .fontWeight(700)
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
        Search().margin(P.MIDDLE)
        Row() {
          Button() {
            Text() {
              SymbolSpan($r('sys.symbol.rectangle_rotate'))
                .fontSize(48)
            }
          }.onClick((_) => {
            this.viewModel.updateAll()
            this.dataSource.notifyDataReload()
          })
        }
        List() {
          LazyForEach(this.dataSource, (item: MainTableRow) => {
            ListItem() {
              Row() {
                Text(item.id.toString().padStart(this.viewModel.selectCount().toString().length, "0"))
                  .fontSize(36)
                  .fontFeature('"ss01" on') // 等宽数字
                Column() {
                  Text(item.content)
                    .fontSize(20)
                    .maxLines(1)
                }.padding({ left: P.SMALL })
              }.padding({ left: P.MIDDLE, right: P.MIDDLE })
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