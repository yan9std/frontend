<!--
 * 登录页
 *
 * @Author: ShanZhu
 * @Date: 2023-12-03
-->
<template>
    <div
        class="login_bg"
        v-loading="loading"
        element-loading-text="正在登录中,请稍等！"
        element-loading-spinner="el-icon-loading"
        element-loading-background="rgba(0, 0, 0, 0.8)"
    >
        <div class="login_box" v-if="!registerShow">
            <div class="login-title">
                <img src="../assets/logo.png" style="width: 40px;position: relative; top: 13px;right: 6px">
                <i style="font-size: 20px;color: #e75c09">登录停车场管理系统</i>
            </div>
            <br />
            <el-form
                class="login_form"
                :model="ruleForm"
                :rules="rules"
                ref="rules"
                label-width="0"
            >
                <el-form-item prop="username">
                    <el-input
                        v-model="ruleForm.username"
                        placeholder="请输入用户名"
                    >
                        <i slot="prefix" class="iconfont icon-user"></i>
                    </el-input>
                </el-form-item>
                <el-form-item prop="password">
                    <el-input
                        type="password"
                        v-model="ruleForm.password"
                        placeholder="请输入密码"
                    >
                        <i slot="prefix" class="iconfont icon-password"></i>
                    </el-input>
                </el-form-item>
                <el-button
                    type="primary"
                    @click="login"
                    icon="iconfont icon-login-button"
                    style="width: 45%; font-size: 16px"
                >登录
                </el-button>
                <el-button
                    type="success"
                    @click="toRegister"
                    icon="iconfont icon-register-button"
                    style="width: 45%; font-size: 16px"
                >注册
                </el-button>
            </el-form>
        </div>
        <div class="register-box" v-if="registerShow">
            <h2>用户注册</h2>
            <el-form
                :model="registerUser"
                status-icon
                :rules="registerRules"
                ref="registerRules"
                label-width="100px"
                class="demo-ruleForm"
            >
                <el-form-item label="用户名" prop="username">
                    <el-input
                        v-model="registerUser.username"
                        placeholder="请输入用户名"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="密码" prop="password">
                    <el-input
                        v-model="registerUser.password"
                        placeholder="请输入密码"
                        show-password
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="确认密码" prop="check" class="is-required">
                    <el-input
                        v-model="registerUser.check"
                        placeholder="确认密码"
                        show-password
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="姓名" prop="nike">
                    <el-input
                        v-model="registerUser.nike"
                        placeholder="请输入姓名"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item label="性别" prop="sex" required>
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
                <el-form-item label="联系电话" prop="phone" required>
                    <el-input
                        v-model="registerUser.phone"
                        placeholder="请输入联系电话"
                        style="width: 300px"
                    ></el-input>
                </el-form-item>
                <el-form-item>
                    <el-button
                        class="register-btn"
                        type="success"
                        icon="iconfont icon-register-button"
                        @click="submitForm('registerRules')"
                        >
                      注册</el-button>
                    <el-button type="primary" class="to-login"
                        icon="iconfont icon-back-button" @click="toLogin"
                        > 返回登录
                    </el-button>
                </el-form-item>
            </el-form>
        </div>
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
        var validatePass2 = (rule, value, callback) => {
            if (value === "") {
                callback(new Error("请再次输入密码"));
            } else if (value !== this.registerUser.password) {
                callback(new Error("两次输入密码不一致!"));
            } else {
                callback();
            }
        };
        return {
            registerShow: false,
            loading: false,
            ruleForm: {
                username: "",
                password: "",
            },
            rules: {
                username: [
                    {
                        required: true,
                        message: "请输入用户名",
                        trigger: "blur",
                    },
                    {
                        min: 3,
                        max: 10,
                        message: "长度在 3 到 10 个字符",
                        trigger: "blur",
                    },
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
            },
            registerUser: {
                username: "",
                password: "",
                check: "",
                sex: "男",
                phone: "",
                age: "",
                card: "",
                nike: "",
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
                check: [{ validator: validatePass2, trigger: "blur" }],
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
                nike: [
                    {
                        required: true,
                        message: "请输入姓名",
                        trigger: "blur",
                    },
                ],
            },
        };
    },
    methods: {
        login() {
            this.loading = true;
            axios
                .post("/api/user/login", this.ruleForm)
                .then((res) => {
                    this.loading = false;
                    if (res.data.data.state) {
                        this.$message.success("登陆成功！");
                        //  token只应在当前网站打开期间生效，所以将token保存在sessionStorage中
                        window.sessionStorage.setItem(
                            "token",
                            res.data.data.uid
                        );
                        if (res.data.data.role == 0) {
                            this.$router.push("/mane");
                        } else {
                            this.$router.push("/conmen");
                        }
                    } else {
                        this.$message.error(
                            "登录失败," + res.data.data.msg + "!"
                        );
                    }
                })
                .catch((error) => {
                    console.log(error.message);
                    this.loading = false;
                    this.$message.error("服务器异常");
                });
        },
        toRegister() {
            this.registerShow = true;
        },
        toLogin() {
            this.registerShow = false;
            this.$nextTick(() => {
                this.$refs.rules.resetFields();
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
                                this.$message.success("注册成功！");
                                this.registerShow = false;
                            } else {
                                this.$message.error("登录失败,请重新尝试！");
                            }
                        });
                } else {
                    return false;
                }
            });
        },
        resetForm(formName) {
            this.$refs[formName].resetFields();
        },
    },
};
</script>
<style lang="less" scoped>
.login_bg {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    overflow-y: auto;
    height: 100%;
    background: url("../../public/img/bg1.jpg") center top / cover no-repeat;
}
.register {
    color: rgb(172, 169, 169);
    cursor: pointer;
}
.register:hover {
    color: red;
}
.register-box {
    background: #fff;
    border-radius: 10px;
    height: 650px;
    margin: 30px 20% 30px 20%;
    padding: 25px 15% 25px 15%;
}
.register-box h2 {
    text-align: center;
}

.login_box {
    background-color: rgb(248, 246, 246);
    padding: 25px 50px 50px 50px;
    border-radius: 5px;
    margin: 10% 38% 0 38%;
    opacity: 0.9;
}
.login-title h2 {
    text-align: center;
}
.to-login {
    cursor: pointer;
    font-size: 14px;
}
</style>
