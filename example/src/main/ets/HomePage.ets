import { HomeViewModel } from './HomeViewModel'

const padding = 16

@Entry
@Component
struct HomePage {
  viewModel: HomeViewModel = new HomeViewModel()

  @Builder
  NavigationTitle() {
    Column() {
      Text($r("app.string.ExampleAbility_label"))
        .fontColor(Color.White)
        .fontWeight(700)
        .fontSize(24)
        .width("100%")
        .padding(padding)
    }
    .justifyContent(FlexAlign.Center)
    .height("100%")
    .width("100%")
  }

  @Builder
  Padding() {
    Blank().height(padding)
  }

  build() {
    Navigation() {
      Column() {
        Search().margin(padding)
        List() {
          LazyForEach(new MyDataSource(), (item: string) => {
            ListItem() {
              Row() {
                Text(item).fontSize(30)
                  .onAppear(() => {
                    console.info("appear:" + item)
                  })
              }.padding({ left: padding, right: padding })
            }
          })
        }
        .cachedCount(5)
        .width("100%")
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

// BasicDataSource实现了IDataSource接口，用于管理listener监听，以及通知LazyForEach数据更新
class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: string[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): string {
    return this.originDataArray[index];
  }

  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener');
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.ADD, index: index}]);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.CHANGE, index: index}]);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
      // 写法2：listener.onDatasetChange([{type: DataOperationType.DELETE, index: index}]);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
      // 写法2：listener.onDatasetChange(
      //         [{type: DataOperationType.EXCHANGE, index: {start: from, end: to}}]);
    })
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    })
  }
}


class MyDataSource extends BasicDataSource {
  private dataArray: string[] = []

  constructor() {
    super()
    for (let i = 0; i <= 30; i++) {
      this.pushData('Hello' + i);
    }
  }

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): string {
    return this.dataArray[index];
  }

  public pushData(data: string): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }
}
