<!--
 * 系统首页
 *
 * @Author: ShanZhu
 * @Date: 2023-12-03
-->
<template>
    <div>
        <el-breadcrumb separator-class="el-icon-arrow-right">
            <el-breadcrumb-item><i
                    class="iconfont icon-home-menu"
                    style="margin: 5px; font-size: 22px"
                >
                    首页</i></el-breadcrumb-item>
        </el-breadcrumb>
        <ParkingOverview />
    </div>
</template>
<script>
import ParkingOverview from "../components/map/ParkingOverview.vue"
export default {
  components: {
    ParkingOverview
  }
}
</script>
<style scoped>

</style>
