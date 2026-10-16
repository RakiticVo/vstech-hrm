# Nền Splash · Gạch bông

- `splash-bg-390x844.svg`: nền màn Splash đúng khung thiết kế (1x).
- `splash-bg-1170x2532.svg`: cùng mẫu, kích thước iPhone @3x. Ô gạch vẫn 46px nên số ô nhiều hơn; muốn giữ tỉ lệ như bản 1x thì dùng bản 390x844 và scale 3x.
- `gach-bong-tile-46.svg`: một ô gạch 46×46 lặp liền mạch, dùng làm pattern (Flutter: `ImageRepeat.repeat`, CSS: `background-repeat`).

Màu: nền `#0A544E` · nét `#FFF8EC` độ mờ 19%. Vòng tròn bán kính 13,25px, nét 2,5px ở 4 góc ô; chấm giữa bán kính 2,75px.
