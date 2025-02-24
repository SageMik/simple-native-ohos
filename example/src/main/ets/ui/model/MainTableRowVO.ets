import { IMainTableRow } from "../../data/MainTableRow"

export interface IMainTableRowVO extends IMainTableRow {
  readonly idFormatted: string
  readonly insertDateFormatted: string
}