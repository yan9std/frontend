<!--
 * 登录信息管理
 *
 * @Author: ShanZhu
 * @Date: 2023-12-03
-->
<template>
    <div>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item><i
                    class="iconfont icon-log-menu"
                    style="margin: 5px; font-size: 22px"
                >
                    登录日志查询</i></el-breadcrumb-item>
        </el-breadcrumb>

        <!-- 卡片视图区域 -->
        <el-card>
            <el-row :gutter="20">
                <el-col :span="4">
                    <el-input
                        placeholder="用户名"
                        v-model="queryInfo.person"
                        clearable
                    ></el-input>
                </el-col>
                <el-col :span="4">
                    <el-input
                        placeholder="ip地址"
                        v-model="queryInfo.ip"
                        clearable
                    ></el-input>
                </el-col>
                <el-col :span="3">
                    <el-button
                        size="small"
                        type="success"
                        @click="getList"
                        icon="iconfont icon-search-menu"
                        style="font-size: 18px"
                        > 搜索</el-button
                    >
                </el-col>
            </el-row>

            <el-table v-loading="loading" :data="loginInfos" border stripe>
                <el-table-column
                    width="50"
                    label="序号"
                    align="center"
                    type="index"
                ></el-table-column>
                <el-table-column
                    label="用户名"
                    prop="person"
                    align="center"
                ></el-table-column>
                <el-table-column
                    label="ip地址"
                    prop="ip"
                    align="center"
                ></el-table-column>
                <el-table-column
                    label="浏览器"
                    prop="browser"
                    align="center"
                ></el-table-column>
                <el-table-column
                    label="操作系统"
                    prop="os"
                    align="center"
                ></el-table-column>
                <el-table-column
                    label="登录时间"
                    prop="loginTime"
                    align="center"
                ></el-table-column>
            </el-table>

            <el-pagination
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                :current-page="queryInfo.pagenum"
                :page-sizes="[5, 10, 15, 20]"
                :page-size="queryInfo.pageSize"
                layout="total, sizes, prev, pager, next"
                :total="total"
            >
            </el-pagination>
        </el-card>
    </div>
</template>
<script>
import axios from "axios";
export default {
    data() {
        return {
            total: 0,
            loading: true,
            queryInfo: {
                person: "",
                ip: "",
                pagenum: 1,
                pageSize: 5,
            },
            loginInfos: [],
        };
    },
    methods: {
        getList() {
            axios
                .post("/api/login-info/getLoginInfoList", this.queryInfo)
                .then((res) => {
                    this.loading = false;
                    this.total = res.data.data.total;
                    this.loginInfos = res.data.data.records;
                });
        },
        handleSizeChange(newSize) {
            this.queryInfo.pageSize = newSize;
            this.getList();
        },
        handleCurrentChange(newPage) {
            this.queryInfo.pagenum = newPage;
            this.getList();
        },
    },
    mounted() {
        this.getList();
    },
};
</script>
