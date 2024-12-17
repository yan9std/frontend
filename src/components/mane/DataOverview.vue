<template>
  <div>
      <el-breadcrumb separator-class="el-icon-arrow-right" style="margin-bottom: 20px;">
          <el-breadcrumb-item>
              <i class="iconfont icon-data-overview" style="margin: 5px; font-size: 22px">
                  相关数据总览
              </i>
          </el-breadcrumb-item>
      </el-breadcrumb>

      <el-row :gutter="20">
          <el-col :span="12">
              <el-card>
                  <!-- 第一张图：饼图（by-state） -->
                  <div ref="chartContainer1" class="chart-container"></div>
              </el-card>
          </el-col>
          <el-col :span="12">
              <el-card>
                  <!-- 第二张图：折线图（stall/daily） -->
                  <div ref="chartContainer2" class="chart-container"></div>
              </el-card>
          </el-col>
      </el-row>

      <el-row :gutter="20" style="margin-top: 20px;">
          <el-col :span="12">
              <el-card>
                  <!-- 第三张图：柱状图（user/stats/daily） -->
                  <div ref="chartContainer3" class="chart-container"></div>
              </el-card>
          </el-col>
          <el-col :span="12">
              <el-card>
                  <!-- 第四张图：折线图（login-info/stats/daily） -->
                  <div ref="chartContainer4" class="chart-container"></div>
              </el-card>
          </el-col>
      </el-row>
  </div>
</template>

<script>
import axios from 'axios'
import * as echarts from 'echarts'

export default {
  data() {
      return {
          charts: [],
          chartData: [],     // 饼图数据（/api/stall/stats/by-state）
          dailyData: [],     // 第二张折线图数据（/api/stall/stats/daily）
          userDailyData: [], // 第三张柱状图数据（/api/user/stats/daily）
          loginDailyData: [] // 第四张折线图数据（/api/login-info/stats/daily）
      }
  },
  methods: {
      // 获取车位状态统计（饼图数据）
      async getStats() {
          const res = await axios.get('/api/stall/stats/by-state');
          if (res.data && res.data.flag) {
              this.chartData = res.data.data;
          } else {
              this.$message.error('获取车位状态统计数据失败');
          }
      },
      // 获取每日数据（折线图数据：车位）
      async getDailyStats() {
          const res = await axios.get('/api/stall/stats/daily');
          if (res.data && res.data.flag) {
              this.dailyData = res.data.data;
          } else {
              this.$message.error('获取每日停车统计数据失败');
          }
      },
      // 获取用户每日注册数据（柱状图数据）
      async getUserDailyStats() {
          const res = await axios.get('/api/user/stats/daily');
          if (res.data && res.data.flag) {
              this.userDailyData = res.data.data;
          } else {
              this.$message.error('获取用户每日注册数据失败');
          }
      },
      // 获取每日登录数据（第四张折线图）
      async getLoginDailyStats() {
          const res = await axios.get('/api/login-info/stats/daily');
          if (res.data && res.data.flag) {
              // 假设这里没有flag为true的条件，直接使用返回data
              this.loginDailyData = res.data.data;
          } else {
              this.$message.error('获取每日登录统计数据失败');
          }
      },
      initCharts() {
          const refs = [
              this.$refs.chartContainer1,
              this.$refs.chartContainer2,
              this.$refs.chartContainer3,
              this.$refs.chartContainer4
          ];

          // 饼图数据及配置
          const pieSeriesData = this.chartData.map(item => ({
              name: item.stallState,
              value: item.totalCount
          }));

          const pieOption = {
              title: {
                  text: '停车场使用情况',
                  left: 'center'
              },
              tooltip: {
                  trigger: 'item'
              },
              legend: {
                  orient: 'horizontal',
                  bottom: '0',
              },
              series: [
                  {
                      name: '车位状态',
                      type: 'pie',
                      radius: '50%',
                      data: pieSeriesData,
                      emphasis: {
                          itemStyle: {
                              shadowBlur: 10,
                              shadowOffsetX: 0,
                              shadowColor: 'rgba(0, 0, 0, 0.5)'
                          }
                      },
                      label: {
                          formatter: '{b}: {c} ({d}%)'
                      }
                  }
              ]
          };

          // 第二张图：折线图（车位每日数据）
          const stallDates = this.dailyData.map(item => item.date);
          const stallPays = this.dailyData.map(item => item.totalPay);

          const lineOption = {
              title: {
                  text: '每日订单金额统计',
                  left: 'center'
              },
              tooltip: {
                  trigger: 'axis'
              },
              xAxis: {
                  type: 'category',
                  boundaryGap: false,
                  data: stallDates
              },
              yAxis: {
                  type: 'value'
              },
              series: [{
                  name: '订单金额',
                  type: 'line',
                  data: stallPays,
                  smooth: true,
                  areaStyle: {}
              }],
              legend: {
                  data: ['订单金额'],
                  bottom: '0'
              }
          };

          // 第三张图：柱状图（用户每日注册）
          const userDates = this.userDailyData.map(item => item.registerDate);
          const userCounts = this.userDailyData.map(item => item.userCount);

          const barOption = {
              title: {
                  text: '新增用户数量',
                  left: 'center'
              },
              tooltip: {
                  trigger: 'axis'
              },
              xAxis: {
                  type: 'category',
                  data: userDates,
                  axisTick: { alignWithLabel: true }
              },
              yAxis: {
                  type: 'value'
              },
              series: [{
                  name: '注册用户数',
                  type: 'bar',
                  data: userCounts,
                  barWidth: '50%',
                  itemStyle: {
                      color: '#409EFF'
                  }
              }],
              legend: {
                  data: ['注册用户数'],
                  bottom: '0'
              }
          };

          // 第四张图：折线图（每日登录次数）
          const loginDates = this.loginDailyData.map(item => item.loginDate);
          const loginCounts = this.loginDailyData.map(item => item.loginCount);

          const loginLineOption = {
              title: {
                  text: '日活跃用户数量',
                  left: 'center'
              },
              tooltip: {
                  trigger: 'axis'
              },
              xAxis: {
                  type: 'category',
                  boundaryGap: false,
                  data: loginDates
              },
              yAxis: {
                  type: 'value'
              },
              series: [{
                  name: '登录次数',
                  type: 'line',
                  data: loginCounts,
                  smooth: true,
                  areaStyle: {}
              }],
              legend: {
                  data: ['登录次数'],
                  bottom: '0'
              }
          };

          // 初始化图表
          const chart1 = echarts.init(refs[0]);  // 饼图
          chart1.setOption(pieOption);

          const chart2 = echarts.init(refs[1]);  // 折线图(车位)
          chart2.setOption(lineOption);

          const chart3 = echarts.init(refs[2]);  // 柱状图(用户)
          chart3.setOption(barOption);

          const chart4 = echarts.init(refs[3]);  // 折线图(登录)
          chart4.setOption(loginLineOption);

          this.charts = [chart1, chart2, chart3, chart4];

          window.addEventListener('resize', () => {
              this.charts.forEach(chart => chart.resize());
          });
      }
  },
  async mounted() {
      // 按序获取数据
      await this.getStats();           // 饼图数据
      await this.getDailyStats();      // 第二张折线图数据
      await this.getUserDailyStats();  // 第三张柱状图数据
      await this.getLoginDailyStats(); // 第四张折线图数据

      this.initCharts();
  }
}
</script>

<style scoped>
.icon-chart {
  font-size: 20px;
  margin-right: 5px;
}

/* 控制图表容器的大小与间距 */
.chart-container {
  width: 100%;
  height: 300px;
}
</style>
