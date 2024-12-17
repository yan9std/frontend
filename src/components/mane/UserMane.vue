<!--
 * 用户信息管理
 *
 * @Author: ShanZhu
 * @Date: 2023-12-03
-->
<template>
    <div>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item><i
                    class="iconfont icon-user-menu"
                    style="margin: 5px; font-size: 22px"
                >用户信息管理</i></el-breadcrumb-item>
        </el-breadcrumb>

        <el-card>
            <el-row :gutter="20">
                <el-col :span="4">
                    <el-input
                        placeholder="请输入用户名"
                        v-model="queryInfo.username"
                        clearable
                    ></el-input>
                </el-col>
                <el-col :span="4">
                    <el-input
                        placeholder="请输入姓名"
                        v-model="queryInfo.nike"
                        clearable
                    ></el-input>
                </el-col>
                <el-col :span="4">
                    <el-input
                        placeholder="请输入车牌号"
                        v-model="queryInfo.card"
                        clearable
                    ></el-input>
                </el-col>
                <el-col :span="2">
                    <el-button
                        size="small"
                        type="success"
                        icon="iconfont icon-search-menu"
                        style="font-size: 18px"
                        @click="getList"
                    >
                        搜索</el-button
                    >
                </el-col>
                <el-col :span="2">
                    <el-button
                        size="small"
                        type="primary"
                        icon="iconfont icon-add-button"
                        style="font-size: 18px"
                        @click="addUser"
                    >
                        新增</el-button
                    >
                </el-col>
                <el-col :span="4">
                    <el-button
                        size="small"
                        type="warning"
                        icon="iconfont icon-stall-fee-menu"
                        style="font-size: 18px"
                        @click="feeUserShow = true"
                    >
                        充值</el-button
                    >
                </el-col>
            </el-row>

            <!-- 车位信息区域 -->
            <el-table v-loading="loading" :data="users" border stripe>
                <el-table-column
                    width="50"
                    label="序号"
                    align="center"
                    type="index"
                ></el-table-column>
                <el-table-column label="用户名" prop="username" align="center">
                </el-table-column>
                <el-table-column label="姓名" prop="nike" align="center">
                </el-table-column>
                <el-table-column label="性别" prop="sex" align="center">
                </el-table-column>
                <el-table-column label="联系电话" prop="phone" align="center">
                </el-table-column>
                <el-table-column label="车牌号" prop="card" align="center">
                </el-table-column>
                <el-table-column label="账户余额" prop="money" align="center">
                    <template slot-scope="scope">
                        <span v-if="scope.row.money"
                            >{{ scope.row.money }}元</span
                        >
                        <span v-else>0元</span>
                    </template>
                </el-table-column>
                <el-table-column label="操作" align="center" fixed="right" width="200">
                    <template slot-scope="scope">
                        <el-button
                            v-if="scope.row.username != 'admin'"
                            @click="toEdit(scope.row)"
                            type="primary"
                            circle
                        ><i class="iconfont icon-edit-button" style="font-size: 22px"></i></el-button>
                        <el-button
                            v-if="scope.row.username != 'admin'"
                            @click="rePassword(scope.row.uid)"
                            type="warning"
                            circle
                        ><i class="iconfont icon-reset-button" style="font-size: 22px"></i></el-button>
                        <el-button
                            v-if="scope.row.username != 'admin'"
                            @click="userDelete(scope.row.uid)"
                            type="danger"
                            circle
                        ><i class="iconfont icon-del-button" style="font-size: 22px"></i></el-button>
                        <el-button
                            v-if="scope.row.username == 'admin'"
                            @click="toEdit(scope.row)"
                            type="primary"
                            circle
                            disabled
                        ><i class="iconfont icon-edit-button" style="font-size: 22px"></i></el-button>
                        <el-button
                            disabled
                            v-if="scope.row.username == 'admin'"
                            @click="userDelete(scope.row.uid)"
                            type="danger"
                            circle
                        ><i class="iconfont icon-del-button" style="font-size: 22px"></i></el-button>
                    </template>
                </el-table-column>
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

        <el-dialog
            title="修改用户"
            :visible.sync="editShow"
            width="450px"
            center
            @close="editClose"
        >
            <!-- 内容主题区域 -->
            <el-form
                :model="editUser"
                :rules="editRules"
                ref="editRules"
                label-width="80px"
            >
                <el-form-item label="姓名" prop="nike" class="is-required">
                    <el-input
                        v-model="editUser.nike"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="密码" prop="password" class="is-required">
                    <el-input
                        v-model="editUser.password"
                        show-password
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="余额" prop="money" class="is-required">
                    <el-input
                        v-model.number="editUser.money"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="联系电话" prop="phone" class="is-required">
                    <el-input
                        v-model="editUser.phone"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="车牌号" prop="card" class="is-required">
                    <el-input
                        v-model="editUser.card"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="性别" class="is-required">
                    <template>
                        <el-radio v-model="editUser.sex" label="男"
                            >男</el-radio
                        >
                        <el-radio v-model="editUser.sex" label="女"
                            >女</el-radio
                        >
                    </template>
                </el-form-item>
                <el-form-item label="年龄" prop="age" class="is-required">
                    <el-input
                        v-model.number="editUser.age"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
            </el-form>

            <!-- 底部区域 -->
            <span slot="footer" class="dialog-footer">
                <el-button @click="editClose()">取 消</el-button>
                <el-button type="primary" @click="editCommit('editRules')"
                    icon="iconfont icon-r-yes"> 确认修改</el-button
                >
            </span>
        </el-dialog>
        <el-dialog
            title="新增用户"
            :visible.sync="addShow"
            width="500px"
            center
            @close="addClose"
        >
            <!-- 内容主题区域 -->
            <el-form
                :model="registerUser"
                status-icon
                :rules="registerRules"
                ref="registerRules"
                label-width="100px"
                class="demo-ruleForm"
            >
                <el-form-item
                    label="用户名"
                    prop="username"
                    class="is-required"
                >
                    <el-input
                        v-model="registerUser.username"
                        placeholder="请输入用户名"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="密码" prop="password" class="is-required">
                    <el-input
                        v-model="registerUser.password"
                        placeholder="请输入密码"
                        show-password
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="姓名" prop="nike" class="is-required">
                    <el-input
                        v-model="registerUser.nike"
                        placeholder="请输入姓名"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="性别" prop="sex" class="is-required">
                    <el-radio v-model="registerUser.sex" label="男"
                        >男</el-radio
                    >
                    <el-radio v-model="registerUser.sex" label="女"
                        >女</el-radio
                    >
                </el-form-item>
                <el-form-item label="年龄" prop="age" class="is-required">
                    <el-input
                        v-model.number="registerUser.age"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="车牌号" prop="card" class="is-required">
                    <el-input
                        v-model="registerUser.card"
                        placeholder="请输入车牌号"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="联系电话" prop="phone" class="is-required">
                    <el-input
                        v-model="registerUser.phone"
                        placeholder="请输入联系电话"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
            </el-form>

            <!-- 底部区域 -->
            <span slot="footer" class="dialog-footer">
                <el-button @click="addClose()">取 消</el-button>
                <el-button type="primary" @click="submitForm('registerRules')"
                    >确认添加</el-button
                >
            </span>
        </el-dialog>

        <el-dialog
            title="用户充值"
            :visible.sync="feeUserShow"
            width="50%"
            center
            @close="feeUserShow = false"
        >
            <el-form
                :model="feeUser"
                :rules="feeUserRules"
                ref="feeUserRules"
                label-width="80px"
            >
                <el-form-item label="用户名" prop="username">
                    <el-input v-model="feeUser.username"></el-input>
                </el-form-item>
                <el-form-item label="金额" prop="money">
                    <el-input v-model="feeUser.money"></el-input>
                </el-form-item>
            </el-form>

            <!-- 底部区域 -->
            <span slot="footer" class="dialog-footer">
                <el-button @click="feeUserShow = false">取 消</el-button>
                <el-button type="primary" @click="feeUserCon('feeUserRules')"
                    >确认充值</el-button
                >
            </span>
        </el-dialog>
    </div>
</template>
<script>
import axios from "axios";
export default {
    data() {
        var checkUsername = (rule, value, callback) => {
            if (!value) {
                return callback(new Error("用户名不能为空"));
            }
            setTimeout(() => {
                axios
                    .get("/api/user/checkUsername?username=" + value)
                    .then((res) => {
                        if (!res.data.data) {
                            callback(new Error("用户名已存在"));
                        } else {
                            callback();
                        }
                    });
            }, 10);
        };
        var checkAge = (rule, value, callback) => {
            if (!value) {
                return callback(new Error("年龄不能为空"));
            }
            setTimeout(() => {
                if (!Number.isInteger(value)) {
                    callback(new Error("请输入数字值"));
                } else {
                    if (value < 18) {
                        callback(new Error("必须年满18岁"));
                    } else {
                        callback();
                    }
                }
            }, 1000);
        };
        return {
            total: 0,
            loading: true,
            queryInfo: {
                username: "",
                nike: "",
                card: "",
                pagenum: 1,
                pageSize: 6,
            },
            users: [],
            editUser: {
                password: "",
                nike: "",
                sex: "",
                age: "",
                phone: "",
                money: "",
                card: "",
            },
            registerUser: {
                sex: "男",
            },
            addShow: false,
            editShow: false,
            editRules: {
                niek: [
                    { required: true, message: "请输入姓名", trigger: "blur" },
                ],
                password: [
                    { required: true, message: "请输入密码", trigger: "blur" },
                    {
                        min: 6,
                        max: 15,
                        message: "长度在 6 到 15 个字符",
                        trigger: "blur",
                    },
                ],
                age: [{ validator: checkAge, trigger: "blur" }],
                phone: [
                    {
                        required: true,
                        message: "请输入联系电话",
                        trigger: "blur",
                    },
                ],
                card: [
                    {
                        required: true,
                        message: "请输入车牌号",
                        trigger: "blur",
                    },
                ],
            },
            registerRules: {
                username: [{ validator: checkUsername, trigger: "blur" }],
                password: [
                    { required: true, message: "请输入密码", trigger: "blur" },
                    {
                        min: 6,
                        max: 15,
                        message: "长度在 6 到 15 个字符",
                        trigger: "blur",
                    },
                ],
                niek: [
                    { required: true, message: "请输入姓名", trigger: "blur" },
                ],
                age: [{ validator: checkAge, trigger: "blur" }],
                phone: [
                    {
                        required: true,
                        message: "请输入联系电话",
                        trigger: "blur",
                    },
                ],
                card: [
                    {
                        required: true,
                        message: "请输入车牌号",
                        trigger: "blur",
                    },
                ],
            },
            feeUserShow: false,
            feeUserRules: {
                username: [
                    {
                        required: true,
                        message: "请输入用户名",
                        trigger: "blur",
                    },
                ],
                money: [
                    {
                        required: true,
                        message: "请输入充值金额",
                        trigger: "blur",
                    },
                ],
            },
            feeUser: {
                username: "",
                money: "",
            },
        };
    },
    methods: {
        feeUserCon(formName) {
            // 充值
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    axios.post("/api/fee/userFee", this.feeUser).then((res) => {
                        if (res.data.data.flag) {
                            this.$message.success("充值成功！");
                            this.feeUserShow = false;
                            this.getList();
                            this.feeUser = {
                                username: "",
                                money: "",
                            };
                        } else {
                            this.$message.error(res.data.data.msg);
                        }
                    });
                } else {
                    return false;
                }
            });
        },
        getList() {
            axios.post("/api/user/getUsers", this.queryInfo).then((res) => {
                this.loading = false;
                this.total = res.data.data.total;
                this.users = res.data.data.records;
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
        addUser() {
            for (let item in this.registerUser) {
                this.registerUser[item] = "";
            }
            this.registerUser.sex = "男";
            this.addShow = true;
        },
        editClose() {
            this.editShow = false;
            this.$nextTick(() => {
                this.$refs.editRules.resetFields();
            });
        },
        toEdit(user) {
            this.editUser.uid = user.uid;
            this.editUser.password = user.password;
            this.editUser.nike = user.nike;
            this.editUser.sex = user.sex;
            this.editUser.age = user.age;
            this.editUser.phone = user.phone;
            this.editUser.money = user.money;
            this.editUser.card = user.card;

            this.editShow = true;
        },
        editCommit(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    //日期进行转换
                    // this.editUser.birthday=new Date(this.editUser.birthday).getTime();
                    //请求
                    axios
                        .post("/api/user/update", this.editUser)
                        .then((res) => {
                            if (res.data.flag) {
                                this.$message.success("修改成功！");
                                this.getList();
                            } else {
                                this.$message.error("修改失败！");
                            }
                            this.editShow = false;
                        });
                } else {
                    return false;
                }
            });
        },
        async userDelete(uid) {
            const re = await this.$confirm(
                "此操作将永久删除该用户, 是否继续?",
                "提示",
                {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning",
                }
            ).catch((err) => err);
            // console.log(re)
            if (re != "confirm") {
                this.$message.info("已取消删除！");
            } else {
                axios.get("/api/user/del?uid=" + uid).then((res) => {
                    if (res.data.data) {
                        this.$message.success("删除成功！");
                        this.getList();
                    } else {
                        this.$message.error("删除失败！");
                    }
                });
            }
        },
        async rePassword(uid) {
            const re = await this.$confirm(
                "重置该用户的密码, 是否继续?",
                "提示",
                {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning",
                }
            ).catch((err) => err);
            // console.log(re)
            if (re != "confirm") {
                this.$message.info("已取消操作！");
            } else {
                axios.get("/api/user/resetPassword?uid=" + uid).then((res) => {
                    if (res.data.data) {
                        this.$message.success("重置密码成功！");
                        this.getList();
                    } else {
                        this.$message.error("重置密码失败！");
                    }
                });
            }
        },
        addClose() {
            this.addShow = false;
            this.$nextTick(() => {
                this.$refs.registerRules.resetFields();
            });
        },
        submitForm(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    this.loading = true;
                    axios
                        .post("/api/user/register", this.registerUser)
                        .then((res) => {
                            this.loading = false;
                            if (res.data.data) {
                                this.$message.success("添加成功！");
                                this.getList();
                                this.addShow = false;
                            } else {
                                this.$message.error("添加失败,请重新尝试！");
                            }
                        });
                } else {
                    // console.log('error submit!!');
                    return false;
                }
            });
        },
    },
    mounted() {
        this.getList();
    },
};
</script>
