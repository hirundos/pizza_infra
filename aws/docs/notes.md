# 🍕 Pizza App - Version 1.0

## ✅ 구성 설명

- **구성도**: 
- **작성한 항목**:
  vpc - rds - ec2 - eks 의 구성을 terraform으로 작성

- **역할**:
  - **DB (PostgreSQL)**: 데이터 저장소
  - **bastion server** : bastion server
  - **mgnt server** : management eks
---

## 🔁 회고 (Troubleshooting & Learnings)

### 1. eks 이슈

- 문제: eks 생성 시 join이 되지 않는 문제
- 원인: vpc addon이 설치되지 않아 발생
- 해결: 모듈 사용 + aws_eks_addon 추가로 해결

### 2. helm 순환 참조 이슈

- 문제: helm 순환 참조 이슈
- 원인: eks 모듈 내에 helm 관련 코드를 넣어 발생
- 해결: helm 관련 모듈 분리 및 root main에서의 순서 조정으로 해결

---
## 💡 1.0 업그레이드 계획
  ingress 추가
---

---

📅 **작성일**: 2025-06-16
✍️ **작성자**: hirundos