# 필요한 패키지 로드
library(ggplot2)
library(sf)
library(dplyr)
library(ggspatial)  # 방위계 및 기준거리표 추가를 위한 패키지

# 한국 지도 데이터 불러오기 및 좌표계 변환
map_korea <- st_read('/Users/woojunbang/Desktop/Korean_mosquiotes_2024/ctprvn_20230729/ctprvn.shp')

# 좌표계 설정 (EPSG:5179) 후 WGS84로 변환
st_crs(map_korea) <- 5179
map_korea <- st_transform(map_korea, crs = 4326)  # WGS84 좌표계로 변환

# 채집 좌표 데이터 불러오기 및 열 이름 지정
coords_data <- read.csv('/Users/woojunbang/Desktop/Korean_mosquiotes_2024/Aedes_japonicus_gps_coordinates.csv', header=TRUE)
colnames(coords_data) <- c("lat", "lon")

# 채집 좌표 데이터를 sf 객체로 변환
coords_data <- st_as_sf(coords_data, coords = c("lon", "lat"), crs = 4326)  # WGS84 좌표계

# 지도 그리기 및 채집 좌표 표시 (방위계 + 기준거리표 추가)
map_korea_ggplot <- ggplot() +
  geom_sf(data = map_korea, fill = 'white', color = 'black') +
  coord_sf() +
  theme_void() +
  
  # 채집 좌표 표시
  geom_sf(data = coords_data, color = 'black', size = 5, shape = 21, fill = 'dodgerblue')
  
# JPG로 저장
ggsave(filename = "/Users/woojunbang/Desktop/Korean_mosquiotes_2024/Aedes_japonicus_coordinates_plot.jpg", 
       plot = map_korea_ggplot, 
       width = 10, height = 8, dpi = 600)
