# AWS cloud Kubernetes Infra Repo

이 저장소는 제가 개발한 애플리케이션을 aws에 배포해보면서 개선사항을 기록해나가는 저장소입니다.

## 구조

- `aws/`: EKS 기반 YAML 및 구성 메모

## 진행 현황
- [x] AWS EKS Terraform으로 자동화 / 2025-06-16
- [x] AWS EKS + ALB 배포 / 2025-06-20
- [] k8s 배포를 terraform으로 자동화
- [] was를 도메인 기준으로 해서 3개로 분리

## 변경 사항
- aws와 gcp 배포 과정을 같은 git repo에 기록하다가 분리하였습니다.
- k8s나 dockerfile도 같이 담고 있는데 이는 과정에 대한 기록으로 terraform과 cicd 사용해서 이들도 코드로 자동화되도록 바꿀 예정입니다.
