<!--
 * 用户缴费信息
 *
 * @Author: ShanZhu
 * @Date: 2023-12-03
-->
<template>
    <div>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item>
              <i class="iconfont icon-stall-fee-menu" style="margin: 5px; font-size: 22px">
                    缴费信息
              </i ></el-breadcrumb-item>
        </el-breadcrumb>
        <el-card>
            <el-row>
                <el-col :span="24">
                    <div class="left">
                        <div class="top">
                            <el-row>
                                <el-col :span="24" style="text-align: left">
                                    <i class="iconfont icon-stall-fee-menu"
                                        style="font-size: 32px"
                                    > 账户余额
                                    </i>
                                </el-col>
                            </el-row>
                            <div class="count" v-if="userInfo.money">
                                <span class="num">￥</span>
                                <span class="num">{{
                                    userInfo.money.toFixed(2)
                                }}</span>
                            </div>
                            <br />
                            <el-button
                                class="pay-btn"
                                style="font-size: 22px"
                                type="primary"
                                @click="toPay"
                            ><i
                                class="iconfont icon-add-button"
                                style="font-size: 22px"
                            ></i>
                                立即充值</el-button
                            >
                        </div>
                    </div>
                </el-col>
                <hr />
                <el-col :span="24">
                    <div class="bottom">
                        <el-row>
                            <el-col :span="24" style="text-align: left">
                                <i class="iconfont icon-wait-fee"
                                    style="font-size: 32px; font-weight: 600"
                                > 待缴费</i>
                            </el-col>
                        </el-row>

                        <el-row style="font-weight: 600; font-size: 22px;margin-top: 10px;">
                            <el-col :span="6"> 区域 </el-col>
                            <el-col :span="4"> 车位号 </el-col>
                            <el-col :span="8"> 时间 </el-col>
                            <el-col :span="6"> 操作 </el-col>
                        </el-row>
                        <el-row v-for="res in dRes" :key="res.id">
                            <el-col :span="6">
                                <span class="area">{{
                                    res.stall.stallArea
                                }}</span>
                            </el-col>
                            <el-col :span="4">
                                <samp class="stall-num">{{
                                    res.stall.stallNum
                                }}</samp>
                            </el-col>
                            <el-col :span="8">
                                <span class="create-time">{{
                                    res.createTime
                                }}</span>
                            </el-col>
                            <el-col :span="6">
                                <el-button
                                    style="margin-top: -15px;font-size: 18px"
                                    type="success"
                                    size="type"
                                    @click="payStall(res)"
                                    ><i
                                class="iconfont icon-stall-fee-menu"
                                style="font-size: 18px"
                            ></i
                        > 缴费</el-button
                                >
                            </el-col>
                        </el-row>
                        <div v-if="dRes.length == 0" class="no-res">
                            没有相关记录
                        </div>
                    </div>
                </el-col>
                <hr />
                <el-col :span="24">
                    <div class="right">
                        <el-row>
                            <el-col :span="24" style="text-align: left">
                                <i
                                    class="iconfont icon-wait-fee"
                                    style="font-size: 32px; font-weight: 600"
                                >
                                    缴费记录</i
                                >
                            </el-col>
                        </el-row>
                        <el-row style="font-weight: 600; font-size: 22px;margin-top: 10px;">
                            <el-col :span="6"> 区域 </el-col>
                            <el-col :span="4"> 车位号 </el-col>
                            <el-col :span="8"> 时间 </el-col>
                            <el-col :span="6"> 费用 </el-col>
                        </el-row>
                        <el-row v-for="item in allStallRes" :key="item.id">
                            <el-col :span="6">
                                <span class="area">{{
                                    item.stall.stallArea
                                }}</span>
                            </el-col>
                            <el-col :span="4">
                                <samp class="stall-num">{{
                                    item.stall.stallNum
                                }}</samp>
                            </el-col>
                            <el-col :span="8">
                                <span class="create-time">{{
                                    item.createTime
                                }}</span>
                            </el-col>
                            <el-col :span="6">
                                <span
                                    class="money"
                                    v-if="
                                        item.money != undefined &&
                                        item.money != null
                                    "
                                    >缴费：{{ item.money.toFixed(2) }}元</span
                                >
                                <span class="money num-red" v-else
                                    >待缴费：{{
                                        feeChange(item).toFixed(2)
                                    }}元</span
                                >
                            </el-col>
                        </el-row>
                        <div v-if="allStallRes.length == 0" class="no-res">
                            没有相关记录
                        </div>
                    </div>
                </el-col>
            </el-row>
        </el-card>

        <el-dialog
            title="充值"
            :visible.sync="payShow"
            width="500px"
            center
            @close="payClose"
        >
            <!-- 内容主题区域 -->
            <el-input
                v-model.number="payMoney"
                @blur="checkMoney"
                placeholder="充值金额"
                style="width: 300px"
            ></el-input>
            <br />
            <span class="pay-msg" v-if="msgShow">{{ payMsg }}</span>
            <!-- 底部区域 -->
            <span slot="footer" class="dialog-footer">
                <!-- <el-button @click="payClose">取 消</el-button> -->
                <el-button type="primary" @click="payClick">确认充值</el-button>
            </span>
        </el-dialog>
    </div>
</template>
<script>
import axios from "axios";
export default {
    data() {
        return {
            allStallRes: [],
            userInfo: {},
            payShow: false,
            payMoney: "",
            payMsg: "",
            msgShow: false,
            dRes: [],
        };
    },
    methods: {
        getAllStallRes(uid) {
            axios.get("/api/stall/listUserStallRes?person=" + uid).then((res) => {
                this.allStallRes = res.data.data;
            });
        },
        getUserInfo(uid) {
            axios.get("/api/user/getUserByUid?uid=" + uid).then((res) => {
                this.userInfo = res.data.data;
                if (this.userInfo.username) {
                    this.getAllStallRes(this.userInfo.username);
                    this.getUserNoPay(this.userInfo.username);
                }
            });
        },
        getUserNoPay(uid) {
            axios.get("/api/stall/allNoPay?person=" + uid).then((res) => {
                this.dRes = res.data.data;
            });
        },
        getUserStallRes(uid) {
            axios.get("/api/stall/allRes?uid=" + uid).then((res) => {
                this.yRes = res.data.data;
            });
        },
        feeChange(stallRes) {
            let startTime = new Date(stallRes.createTime);
            let endTime = new Date();
            let hours = (endTime.getTime() - startTime.getTime()) / 3600000;
            return (Math.floor(hours * 10) / 10) * stallRes.stall.stallMoney;
        },
        toPay() {
            this.payMoney = "";
            this.payShow = true;
        },
        checkMoney() {
            if (typeof this.payMoney === "number") {
                this.msgShow = false;
                this.payMsg = "";
            } else {
                this.msgShow = true;
                this.payMsg = "请输入正确的金额数值";
            }
        },
        payClick() {
            if (typeof this.payMoney === "number") {
                const uid = window.sessionStorage.getItem("token");
                axios
                    .post("/api/user/userPay", {
                        uid: uid,
                        money: this.payMoney,
                    })
                    .then((res) => {
                        if (res.data.data) {
                            this.$message.success("充值成功！");
                            this.getUserInfo(uid);
                            this.payClose();
                        } else {
                            this.$message.error("充值失败，请重新尝试");
                        }
                    });
            } else {
                this.$message.info("输入金额错误，充值失败！");
                this.payClose();
            }
        },
        payClose() {
            this.payShow = false;
            this.msgShow = false;
            this.payMsg = "";
        },
        async payStall(stallRes) {
            const re = await this.$confirm(
                "该次停车缴费" + this.feeChange(stallRes) + "元?",
                "提示",
                {
                    confirmButtonText: "确定",
                    cancelButtonText: "取消",
                    type: "warning",
                }
            ).catch((err) => err);
            // console.log(re)
            if (re != "confirm") {
                this.$message.info("已取消停车缴费！");
            } else {
                let oa = {};
                oa.pid = stallRes.pid;
                oa.person = stallRes.person;
                oa.stallId = stallRes.stallId;
                oa.money = this.feeChange(stallRes);
                axios.post("/api/stall/payMoneyPerson", oa).then((res) => {
                    if (res.data.data.flag) {
                        this.$message.success("停车缴费成功！");
                        this.getAllStallRes(this.userInfo.username);
                        this.getUserNoPay(this.userInfo.username);
                    } else {
                        this.$message.error(res.data.data.msg);
                    }
                });
            }
        },
    },

    mounted() {
        const uid = window.sessionStorage.getItem("token");
        this.getUserInfo(uid);
    },
};
</script>
<style scoped>
.top {
    height: 200px;
}
.top h2 {
    text-align: center;
    color: rgb(102, 102, 102);
}
.count {
    text-align: left;
    color: #e75c09;
}
.num {
    font-size: 34px;
}
.text {
    font-size: 20px;
}
.pay-btn {
    margin-left: 8%;
    width: 180px;
    transform: translateX(-90px);
}
.bottom {
}
.bottom h2 {
    text-align: center;
    color: rgb(102, 102, 102);
}
.right {
}
.el-row {
    height: 50px;
}
.right h2 {
    text-align: center;
    font-size: 24px;
    color: rgb(107, 107, 107);
}
.pay-msg {
    color: red;
    font-size: 12px;
}
.stall-num {
    font-size: 16px;
}
.num-red {
    color: red;
}
.no-res {
    width: 100%;
    height: 150px;
    line-height: 150px;
    text-align: center;
    color: rgb(203, 199, 199);
    font-size: 24px;
}
</style>
