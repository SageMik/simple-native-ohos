
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

  get insertDateDB(): number {
    return this.insertDate.getTime()
  }

  static dateFromDB(insertDateFromDB: number): Date {
    return new Date(insertDateFromDB)
  }
}