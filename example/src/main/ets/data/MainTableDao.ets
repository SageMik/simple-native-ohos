import { relationalStore } from '@kit.ArkData'
import randomWords from '../utils/RandomWords'
import { ZeroWidth } from '../utils/ZeroWidth'
import { MainTableRow } from './MainTableRow'

// const tokenizer = "simple 0";  // 关闭拼音搜索
const tokenizer = "simple"
const mainTable = "custom"
const id = "id"
const title = "title"
const content = "content"
const insertDate = "insert_date"
const fts5Table = "t1"

export class MainTableDao {
  readonly db: relationalStore.RdbStore

  constructor(db: relationalStore.RdbStore) {
    this.db = db
    this._initFts5()
  }

  /**
   * 初始化 SQLite FTS5 虚表。
   *
   * 参考：https://sqlite.org/fts5.html
   */
  private _initFts5() {
    // 主表
    this.db.executeSync(`
      CREATE TABLE ${mainTable} (
        ${id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${title} TEXT,
        ${content} TEXT,
        ${insertDate} INTEGER
      );
    `)

    /// FTS5虚表
    this.db.executeSync(`
      CREATE VIRTUAL TABLE ${fts5Table} USING fts5(
        ${title}, ${content}, ${insertDate} UNINDEXED,
        tokenize = '${tokenizer}',
        content = '${mainTable}',
        content_rowid = '${id}'
      );
    `);

    /// 触发器
    const newInsert = `
      INSERT INTO ${fts5Table}(rowid, ${title}, ${content})
        VALUES (new.${id}, new.${title}, new.${content});
    `;
    const deleteInsert = `
      INSERT INTO ${fts5Table}(${fts5Table}, rowid, ${title}, ${content})
        VALUES ('delete', old.${id}, old.${title}, old.${content});
    `;
    this.db.executeSync(`
      CREATE TRIGGER ${mainTable}_insert AFTER INSERT ON ${mainTable} BEGIN
        ${newInsert}
      END;
    `);
    this.db.executeSync(`
      CREATE TRIGGER ${mainTable}_delete AFTER DELETE ON ${mainTable} BEGIN
        ${deleteInsert}
      END;
    `);
    this.db.executeSync(`
      CREATE TRIGGER ${mainTable}_update AFTER UPDATE ON ${mainTable} BEGIN
        ${deleteInsert}
        ${newInsert}
      END;
    `);
  }

  /**
   * @param resultSet 查询结果
   * @returns 查询结果转换为的实体类
   */
  private _toMainTableRows(resultSet: relationalStore.ResultSet): MainTableRow[] {
    return Array.from<void, MainTableRow>({ length: resultSet.rowCount }, (_, index) => {
      resultSet.goToRow(index)
      const row = resultSet.getRow()
      return new MainTableRow({
        id: row[id] as number,
        title: row[title] as string,
        content: row[content] as string,
        insertDate: MainTableRow.dateFromDB(row[insertDate] as number)
      })
    })
  }

  /**
   * @returns 随机中文词组数据
   */
  private _buildData(): MainTableRow {
    return new MainTableRow({
      id: 0,
      title: randomWords(2, 3),
      content: randomWords(6, 16),
      insertDate: new Date(Date.now())
    })
  }

  /**
   * 插入 `length` 条随机数据
   * @param length 需要多少条随机数据
   */
  insertRandomData(length: number) {
    for (let i = 0; i < length; i++) {
      const newRow = this._buildData()
      this.db.executeSync(
        `INSERT INTO ${mainTable} VALUES(?, ?, ?, ?);`,
        [null, newRow.title, newRow.content, newRow.insertDateDB]
      )
    }
  }

  private readonly _selectAllPredicates = new relationalStore.RdbPredicates(mainTable)

  /**
   * @returns 主表的所有数据
   */
  selectAll(): MainTableRow[] {
    const resultSet = this.db.querySync(this._selectAllPredicates)
    return this._toMainTableRows(resultSet)
  }

  /**
   * @returns 主表的数据数量
   */
  selectCount(): number {
    const resultSet = this.db.querySqlSync(`SELECT COUNT(*) FROM ${mainTable}`)
    resultSet.goToFirstRow()
    return resultSet.getLong(0)
  }

  /**
   * 通过指定分词器 `tokenizer` 搜索
   * @param value 关键词
   * @param tokenizer 分词器，取值：jieba, simple
   * @returns 搜索结果
   */
  search(value: string, tokenizer: string): MainTableRow[] {
    const wrapperSql = `'${ZeroWidth.start}', '${ZeroWidth.end}'`
    const resultSet = this.db.querySqlSync(`
      SELECT
        rowid AS ${id},
        simple_highlight(${fts5Table}, 0, ${wrapperSql}) AS ${title},
        simple_highlight(${fts5Table}, 1, ${wrapperSql}) AS ${content},
        ${insertDate}
      FROM ${fts5Table}
      WHERE ${fts5Table} MATCH ${tokenizer}_query(?);
    `, [value])
    return this._toMainTableRows(resultSet)
  }

  /**
   * 修改所有数据，测试触发器
   */
  updateAll() {
    const mainTableRowList = this.selectAll()
    for (let i = 0; i < mainTableRowList.length; i++) {
      const newRow = this._buildData()
      this.db.executeSync(
        `UPDATE ${mainTable} SET ${title} = ?, ${content} = ?, ${insertDate} = ? WHERE ${id} = ?;`,
        [newRow.title, newRow.content, newRow.insertDateDB, mainTableRowList[i].id]
      )
    }
  }
}