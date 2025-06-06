# 🍕 Pizza App - Version 1.0

## ✅ 구성 설명

- **구성도**: `NLB → WEB → WAS → DB` 의 단순한 구조
- **작성한 항목**:
  - `Dockerfile`: 각 컴포넌트별로 기본적인 설정 작성
  - `Kubernetes YAML`: Deployment, Service (NodePort or LoadBalancer) 구성
- **역할**:
  - **NLB (GCP LoadBalancer)**: 외부 트래픽 수신
  - **WEB (Nginx)**: 정적 프론트 및 프록시 처리
  - **WAS (Node.js)**: API 서버
  - **DB (PostgreSQL)**: 데이터 저장소

---

## 🔁 회고 (Troubleshooting & Learnings)

### 1. 🔀 Nginx 경로 매핑 이슈

- 문제: 프론트엔드에서 `/api/login`으로 요청했으나, 백엔드에서는 `/login`으로 받아야 하는 구조.
- 원인: Nginx 설정에서 `location /api/` 경로를 프록시할 때, 내부로 전달되는 요청 경로가 `/api/login`이 아닌 `/login`으로 바뀜.
- 해결: 백엔드에서 실제 수신 경로가 어떻게 바뀌는지 확인하고, 프록시 설정 또는 백엔드 라우팅을 맞춰 조정.

### 2. 📁 정적 파일 경로 이슈 (Docker + OS 차이)

- 문제: `Dockerfile`에서 `COPY` 경로를 `/var/www/`로 설정했으나, 의도대로 동작하지 않음.
- 원인: Ubuntu에 익숙한 경로 기준으로 작성했으나, 실제 사용하는 `bookworm` 이미지에서는 기본 루트 경로가 달랐음.
- 해결: 컨테이너 내부에 직접 접속하여 디렉터리 구조를 확인하고 경로 수정 (`/usr/share/nginx/html` 등으로 변경)

---
## 💡 1.0 업그레이드 계획

- [ ] `Ingress` Controller 적용 및 `TLS` 구성
- [ ] `NetworkPolicy` 도입 

---

## 💡 2.0 버전 아이디어

- [ ] **DB Proxy 구성**
  - `pgbouncer`를 sidecar로 DB Deployment에 붙이기
- [ ] **Secret 관리 개선**
  - WAS의 `.env` 환경변수를 `K8s Secret`로 분리
- [ ] **WAS 구조 개선**
  - 단일 Deployment → 메뉴, 주문, 회원 도메인별로 분리
  - `was-order`, `was-member`, `was-menu` Deployment

---

📅 **작성일**: 2025-06-01
✍️ **작성자**: hirundos