<template>
    <div>
        <el-row :gutter="0">
            <el-col :span="4">
                <el-select v-model="logName" filterable placeholder="请选择日志">
                    <el-option
                        v-for="item in logNameList"
                        :key="item.value"
                        :label="item.label"
                        :value="item.value">
                    </el-option>
                </el-select>
            </el-col>

            <el-col :span="4">
                <label>导出格式:</label>
                <el-select v-model="bookType" style="width:120px;">
                <el-option
                    v-for="item in bookTypeOptions"
                    :key="item"
                    :label="item"
                    :value="item"
                />
                </el-select>
            </el-col>

            <el-col :span="3">
                <el-button :loading="downloadLoading" style="margin:0 0 20px 20px;" type="primary" icon="el-icon-document" @click="handleDownload">
                    {{ downloadText }}
                </el-button>
            </el-col>
        </el-row>
       
        <el-row :gutter="20">
            <el-col :span="4"><div>
                <el-input v-model="setSvrType" placeholder="服务类型"></el-input>
                <el-input v-model="setSvrId" placeholder="服务ID"></el-input>
            </div></el-col>
            <el-col :span="6"><div>
                <el-date-picker
                    v-model="setTimeValue"
                    type="datetimerange"
                    value-format="timestamp"
                    range-separator="至"
                    start-placeholder="开始日期"
                    end-placeholder="结束日期">
                </el-date-picker>
            </div></el-col>
            <el-col :span="4" v-for="item in indexs_list" :key="item.key"><div>
                <el-input v-for="it in item.list" :key="it" v-model="indexs_value[it]" :placeholder="it"></el-input>
            </div></el-col>
        </el-row>

        <div>
            <el-table border stripe :data="data_list" style="width: 100%" height="600">
                <el-table-column v-for="item in field_list" :key="item" :label="item" resizable min-width="50" >
                    <template slot-scope="scope">
                        {{ parseItemShow(item, scope.row[item]) }}
                    </template>
                </el-table-column>
            </el-table>
        </div>

        <div align="center" style="padding-top: 15px;">
            <el-button-group>
                <el-button :loading="loadingFirst" type="primary" icon="el-icon-arrow-left" @click="onClickFirst">首页</el-button>
                <el-button :loading="loadingPre" type="primary" icon="el-icon-arrow-left" @click="onClickPre">上一页</el-button>
                <el-button :loading="loadingNext" type="primary" @click="onClickNext">下一页<i class="el-icon-arrow-right el-icon--right"></i></el-button>
            </el-button-group>
            <p>{{ this.pagenum + "/" + this.totalPageNum }}</p>
        </div>
    </div>
</template>

<script>

import { getLogNameList, getLogDesc, getLogList } from '@/api/log_pannel'

export default {
    data() {
        return {
          pagecount : 20,
          count : 0,
          totalPageNum : 0,
          logNameList : [],
          field_list : [],
          field_map : {},
          indexs_list : [],
          indexs_value : {},
          logName : "",
          pagenum : 1,
          pageCachMap : {},
          data_list : [],
          cursor : null,
          nextOffset : 0,
          setSvrType : "",
          setSvrId : "",
          setTimeValue : "",
          loadingFirst : false,
          loadingPre : false,
          loadingNext : false,
          downloadLoading : false,
          downloadProgress : 0,
          bookType : 'xlsx',
          bookTypeOptions : ['xlsx', 'csv']
        }
    },

    computed: {
        downloadText() {
            if (this.downloadLoading) {
                return `导出中 ${this.downloadProgress}%`
            }
            return '导出数据'
        }
    },

    created() {
        this.getLogNameList()
    },

    watch: {
        logName : {
            handler(val) {
                this.getLogInfo(val)
                this.clearData()
                this.getLogList()
            }
        },
    },
   
    methods: {
        clearData() {
            this.pageCachMap = {}
            this.pagenum = 1
            this.totalPageNum = 0
            this.cursor = null
            this.data_list = []
            this.setSvrType = ""
            this.setSvrId = ""
            this.setTimeValue = ""
            this.indexs_value = {}
            this.field_map = {}
        },

        async getLogNameList() {
            const res = await getLogNameList()
            if (Array.isArray(res.data)) {
                this.logNameList = []
                for (let i = 0; i < res.data.length; i++) {
                    let name = res.data[i]
                    this.logNameList[i] = {
                        label : 'label:' + name,
                        value : name,
                    }
                }
            } else {
                this.logNameList = []
            }
        },

        async getLogInfo(logName) {
            const res = await getLogDesc(logName)
            console.log("res >>> ", res)
            this.field_list = []
            for (let i = 0; i < res.data.field_list.length; i++) {
                let field_name = res.data.field_list[i]
                if (field_name != '_log_name') {
                    this.field_list.push(field_name)
                }
            }
            this.indexs_list = []
            for (let key in res.data.indexs_list) {
                let list = res.data.indexs_list[key]
                if (key != "time_index" && key != "svr_index") {
                    this.indexs_list.push({key : key, list : list})
                }
            }

            this.indexs_list.sort(function(a,b) {
                return a.key - b.key
            })

            this.field_map = res.data.field_map
        },

        buildQuery() {
            let query = {}
            if (this.setSvrType != "" && !isNaN(Number(this.setSvrType))) {
                query._svr_type = Number(this.setSvrType)
            }
            if (this.setSvrId != "" && !isNaN(Number(this.setSvrId))) {
                query._svr_id = Number(this.setSvrId)
            }
            
            if (this.setTimeValue) {
                query._time = {
                    ['$gte'] : Math.floor(this.setTimeValue[0] / 1000),
                    ['$lte'] : Math.floor(this.setTimeValue[1] / 1000),
                }
            }

            for (let field_name in this.indexs_value) {
                let field_value = this.indexs_value[field_name]
                if (field_value != '') {
                    let ft = this.field_map[field_name]
                    if (ft < 20) {
                        const numbers = field_value.replace(/\s+/g, "").match(/-?\d+/g)?.map(Number) || [];
                        const regexs = field_value.match(/(>=|<=|>|<)/g) || [];
                        if (!isNaN(Number(field_value))) {
                            query[field_name] = Number(field_value)
                        }
                        
                        let len = numbers.length;
                        for (let i = 0; i < len; i++) {
                            let number = numbers[i];
                            let regex = regexs[i];
                            if (regex) {
                                if (!query[field_name]) {
                                    query[field_name] = {}
                                }
                                if (regex == '>') {
                                    query[field_name]['$gt'] = number
                                } else if (regex == '>=') {
                                    query[field_name]['$gte'] = number
                                } else if (regex == '<=') {
                                    query[field_name]['$lte'] = number
                                } else if (regex == '<') {
                                    query[field_name]['$lt'] = number
                                } else {
                                    delete query[field_name]
                                }
                            } else {
                                query[field_name] = number
                            }
                        }
                    } else {
                        query[field_name] = field_value
                    }
                }
            }
            return query
        },

        async getLogList() {
            if (this.pagenum != 1 && this.pageCachMap[this.pagenum]) {
                this.data_list = this.pageCachMap[this.pagenum]
                return;
            }
            if (this.pagenum == 1) {
                this.pageCachMap = {}
                this.cursor = null
                this.nextOffset = 0
            }

            const query = this.buildQuery()

            const res = await getLogList({
                logname : this.logName,
                pagenum : this.pagenum,
                cursor : this.cursor,
                query : query,
                next_offset : this.nextOffset,
            })
            
            let data = res.data
            this.cursor = data.cursor
            this.pagenum = data.pagenum
            this.nextOffset = data.next_offset

            if (data.count) {
                this.count = data.count
                this.totalPageNum = Math.ceil(this.count / this.pagecount)
            }
            
            if (Array.isArray(data.list)) {
                this.data_list = data.list
            } else {
                this.data_list = []
            }
            this.pageCachMap[this.pagenum] = this.data_list
            
            return data
        },

        // 新增：获取指定页的数据（不更新当前页面状态）
        async fetchPageData(pagenum, cursor, nextOffset) {
            const query = this.buildQuery()

            const res = await getLogList({
                logname : this.logName,
                pagenum : pagenum,
                cursor : cursor,
                query : query,
                next_offset : nextOffset,
            })
            
            return res.data
        },

        parseItemShow(field_name, field_value) {
            if (field_name.includes('time')) {
                return new Date(field_value * 1000).toLocaleString('zh-CN')
            } else {
                if (typeof(field_value) == 'object') {
                    return  JSON.stringify(field_value)
                } else {
                    return '' + field_value
                }
            }
        },

        async onClickFirst() {
            this.cursor = null
            this.pagenum = 1
            this.data_list = []
            this.loadingFirst = true
            await this.getLogList()
            this.loadingFirst = false
        },

        async onClickPre() {
            if (this.pagenum <= 1) {
                this.$notify({
                    title: '已经到第一页了',
                })
                return;
            }
            this.pagenum -= 1
            this.data_list = []
            this.loadingPre = true
            await this.getLogList()
            this.loadingPre = false
        },

        async onClickNext() {
            if (this.pagenum >= this.totalPageNum) {
                this.$notify({
                    title: '已经到最后一页了',
                })
                return;
            }
            this.pagenum += 1
            this.data_list = []
            this.loadingNext = true
            await this.getLogList()
            this.loadingNext = false
        },

        // 重构后的下载方法
        async handleDownload() {
            if (this.downloadLoading) {
                this.$notify.warning({
                    title: '提示',
                    message: '正在导出中，请稍候...'
                })
                return
            }

            // 确认导出数量
            if (this.totalPageNum === 0) {
                this.$notify.warning({
                    title: '提示',
                    message: '暂无数据可导出'
                })
                return
            }

            const totalCount = this.count
            if (totalCount > 10000) {
                const confirm = await this.$confirm(
                    `当前共有 ${totalCount} 条数据，导出可能需要较长时间，是否继续？`,
                    '提示',
                    {
                        confirmButtonText: '确定',
                        cancelButtonText: '取消',
                        type: 'warning'
                    }
                ).catch(() => false)

                if (!confirm) {
                    return
                }
            }

            this.downloadLoading = true
            this.downloadProgress = 0

            try {
                // 保存当前页面状态
                const currentPagenum = this.pagenum
                const currentCursor = this.cursor
                const currentNextOffset = this.nextOffset

                // 收集所有数据
                const allData = []
                let tempCursor = null
                let tempNextOffset = 0

                // 串行请求所有页面数据
                for (let page = 1; page <= this.totalPageNum; page++) {
                    // 检查缓存
                    if (this.pageCachMap[page]) {
                        allData.push(...this.pageCachMap[page])
                    } else {
                        // 请求数据
                        const data = await this.fetchPageData(page, tempCursor, tempNextOffset)
                        
                        if (Array.isArray(data.list) && data.list.length > 0) {
                            allData.push(...data.list)
                            // 缓存数据
                            this.pageCachMap[page] = data.list
                        }

                        // 更新游标
                        tempCursor = data.cursor
                        tempNextOffset = data.next_offset
                    }

                    // 更新进度
                    this.downloadProgress = Math.floor((page / this.totalPageNum) * 100)
                }

                // 恢复页面状态
                this.pagenum = currentPagenum
                this.cursor = currentCursor
                this.nextOffset = currentNextOffset

                console.log("导出数据总数:", allData.length)

                // 导出数据
                const data = this.formatJson(this.field_list, allData)
                const excel = await import('@/vendor/Export2Excel')
                excel.export_json_to_excel({
                    header: this.field_list,
                    data,
                    filename: `${this.logName}_${new Date().toLocaleDateString()}`,
                    autoWidth: true,
                    bookType: this.bookType
                })

                this.$notify.success({
                    title: '成功',
                    message: `成功导出 ${allData.length} 条数据`
                })

            } catch (error) {
                console.error('导出失败:', error)
                this.$notify.error({
                    title: '导出失败',
                    message: error.message || '导出过程中发生错误'
                })
            } finally {
                this.downloadLoading = false
                this.downloadProgress = 0
            }
        },

        formatJson(filterVal, jsonData) {
            return jsonData.map(v => filterVal.map(j => {
                return this.parseItemShow(j, v[j])
            }))
        }
    }
}
</script>

