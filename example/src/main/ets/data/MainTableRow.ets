import { relationalStore } from '@kit.ArkData';
import randomWords from '../utils/RandomWords';
import ZeroWidth from '../utils/ZeroWidth';

export interface IMainTableRow {
  readonly id: number
  readonly title: string
  readonly content: string
  readonly insertDate: Date
}

export class MainTableRow implements IMainTableRow {
  readonly id: number
  readonly title: string
  readonly content: string
  readonly insertDate: Date

  constructor(i: IMainTableRow) {
    this.id = i.id
    this.title = i.title
    this.content = i.content
    this.insertDate = i.insertDate
  }

  static dateFromDB(insertDateFromDB: number): Date {
    return new Date(insertDateFromDB)
  }

  static dateToDB(date: Date): number {
    return date.getUTCMilliseconds()
  }

  // copy(i: IMainTableRow) {
  //   return new MainTableRow(
  //     i.id ?? this.id,
  //     i.title ?? this.title,
  //     i.content ?? this.content,
  //     i.insertDate ?? this.insertDate
  //   )
  // }
}