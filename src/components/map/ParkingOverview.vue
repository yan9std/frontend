<template>
  <el-card class="parking-overview" shadow="hover">
    <h2 class="title">江苏省共享停车场总览</h2>
    <p class="subtitle">展示省内所有市级城市，每个城市15个共享停车场的分布情况</p>
    <el-select 
      v-model="selectedCity" 
      placeholder="请选择城市" 
      class="city-select" 
      @change="focusCity"
      clearable>
      <el-option
        label="全局视图"
        value="global"
      ></el-option>
      <el-option
        v-for="(coord, city) in cityCoordinates"
        :key="city"
        :label="city"
        :value="city"
      ></el-option>
    </el-select>
    <div id="map-container" class="map-container"></div>
  </el-card>
</template>

<script>
export default {
  data() {
    return {
      mapInstance: null,
      parkingLots: [],
      selectedCity: "global",
      cityCoordinates: {
        南京市: [118.796623, 32.059352],
        苏州市: [120.619585, 31.299379],
        无锡市: [120.31191, 31.49117],
        常州市: [119.974061, 31.811226],
        南通市: [120.894291, 31.980172],
        连云港市: [119.221611, 34.596653],
        徐州市: [117.184811, 34.261792],
        盐城市: [120.139998, 33.377631],
        扬州市: [119.421003, 32.393159],
        镇江市: [119.452753, 32.204402],
        淮安市: [119.015285, 33.610353],
        泰州市: [119.915176, 32.484882],
        宿迁市: [118.275198, 33.963232],
      },
    };
  },
  mounted() {
    this.initMap();
  },
  methods: {
    initMap() {
      this.mapInstance = new AMap.Map("map-container", {
        center: [119.368489, 33.013797],
        zoom: 8,
        mapStyle: "amap://styles/whitesmoke", // 使用高德地图现代风格
      });
      this.loadMockParkingLots();
      this.updateMap();
    },
    loadMockParkingLots() {
      for (const [city, coord] of Object.entries(this.cityCoordinates)) {
        for (let i = 1; i <= 15; i++) {
          const offsetLng = (Math.random() - 0.5) * 0.2;
          const offsetLat = (Math.random() - 0.5) * 0.2;
          this.parkingLots.push({
            city,
            name: `${city}共享停车场${i}`,
            longitude: coord[0] + offsetLng,
            latitude: coord[1] + offsetLat,
            totalSpaces: Math.floor(Math.random() * 200) + 50,
            remainingSpaces: Math.floor(Math.random() * 150),
          });
        }
      }
    },
    updateMap() {
      this.mapInstance.clearMap();
      this.parkingLots.forEach((lot) => {
        const marker = new AMap.Marker({
          position: [lot.longitude, lot.latitude],
          title: lot.name,
          icon: "https://webapi.amap.com/theme/v1.3/markers/n/mark_b.png", // 使用高德地图风格图标
          offset: new AMap.Pixel(-20, -40), // 调整偏移量，使标记指针在圆圈中心
          zIndex: 10, // 确保标记在其他元素之上
        });

        const circle = new AMap.Circle({
          center: [lot.longitude, lot.latitude],
          radius: 500,
          fillColor: this.getColor(lot.remainingSpaces, lot.totalSpaces),
          fillOpacity: 0.5,
          strokeColor: this.getColor(lot.remainingSpaces, lot.totalSpaces),
          strokeOpacity: 1,
          strokeWeight: 1,
        });

        this.mapInstance.add(marker);
        this.mapInstance.add(circle);

        marker.on("click", () => {
          const content = `
            <div style="padding: 10px; line-height: 1.5;">
              <h4 style="margin: 0; color: #0099CC;">${lot.name}</h4>
              <p>总泊位：${lot.totalSpaces}</p>
              <p>剩余泊位：${lot.remainingSpaces}</p>
            </div>
          `;
          const infoWindow = new AMap.InfoWindow({
            content,
            offset: new AMap.Pixel(0, -25),
          });
          infoWindow.open(this.mapInstance, marker.getPosition());
        });
      });
    },
    getColor(remainingSpaces, totalSpaces) {
      const usageRate = remainingSpaces / totalSpaces;
      if (usageRate > 0.5) {
        return "rgba(50, 150, 50, 0.6)"; // 绿色
      } else if (usageRate > 0.2) {
        return "rgba(255, 165, 0, 0.6)"; // 橙色
      } else {
        return "rgba(255, 69, 0, 0.6)"; // 红色
      }
    },
    focusCity() {
      if (this.selectedCity === "global") {
        this.mapInstance.setCenter([119.368489, 33.013797]);
        this.mapInstance.setZoom(8);
      } else if (this.cityCoordinates[this.selectedCity]) {
        const [lng, lat] = this.cityCoordinates[this.selectedCity];
        this.mapInstance.setCenter([lng, lat]);
        this.mapInstance.setZoom(11);
      }
    },
  },
};
</script>

<style scoped>
.parking-overview {
  max-width: 1200px;
  margin: 30px auto;
  padding: 25px;
  background: linear-gradient(145deg, #ffffff, #f4f6f9);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  border-radius: 15px;
}
.title {
  font-size: 26px;
  font-weight: bold;
  text-align: center;
  color: #005bb5;
  margin-bottom: 15px;
}
.subtitle {
  font-size: 16px;
  text-align: center;
  margin-bottom: 25px;
  color: #666;
}
.city-select {
  display: block;
  width: 300px;
  margin: 0 auto 20px auto;
  border-radius: 10px;
}
.map-container {
  width: 100%;
  height: 650px;
  border-radius: 15px;
  overflow: hidden;
  border: 2px solid #d1e9fc;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
}
</style>
